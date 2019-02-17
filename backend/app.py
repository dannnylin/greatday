from flask import Flask, request, jsonify, Response, json
from flask import render_template, redirect
from flask_pymongo import PyMongo
from datetime import datetime
from bson.json_util import dumps, loads
from datetime import datetime
import os
import json
from collections import OrderedDict
from pprint import pprint

app = Flask(__name__)
app.config["MONGO_URI"] = "mongodb://admin:password123@ds147942.mlab.com:47942/greatday"
mongo = PyMongo(app)
activities_db = mongo.db.activities
moods_db = mongo.db.moods
dates_db = mongo.db.dates

@app.route('/')
def index():
  return render_template('index.html')

@app.route('/api/addActivity', methods=['POST'])
def addActivity():
  content = request.json
  data = {
      "name": content["activity"],
      "mood": content["mood"],
      "date": content["date"],
      "time_of_day": content["timeOfDay"]
  }
  activity = activities_db.insert_one(data)
  result = dates_db.find_one({"date": data["date"]})
  activities = result["activities"]
  activities[data["time_of_day"]].append(data)
  result = dates_db.find_one_and_update(
      {"date": data["date"]}, {"$set": {"activities": activities}})
  return "hello world"

@app.route('/api/getActivities')
def getActivities():
  result = activities_db.find({})
  return dumps(result) if result else {}

@app.route('/api/getMoodCounts')
def getMoodCounts():
  counter = {}
  result = activities_db.find({"mood": "happy"})
  counter["happy"] = result.count()
  result = activities_db.find({"mood": "meh"})
  counter["meh"] = result.count()
  result = activities_db.find({"mood": "sad"})
  counter["sad"] = result.count()
  return json.dumps(counter)

@app.route('/api/getStats')
def getStats():
  returnResults = {}
  activities = activities_db.find({})
  rankings = {}
  for activity in activities:
    if activity["mood"] == "happy":
      rankings[activity["name"]] = rankings.get(activity["name"], 0) + 1
  rankedData = OrderedDict(
      sorted(rankings.items(), key=lambda x: x[1], reverse=True))
  returnResults["happy"] = rankedData
  rankings = {}
  activities = activities_db.find({})
  for activity in activities:
    if activity["mood"] == "sad":
      rankings[activity["name"]] = rankings.get(activity["name"], 0) + 1
  rankedData = OrderedDict(
      sorted(rankings.items(), key=lambda x: x[1], reverse=True))
  returnResults["sad"] = rankedData
  return json.dumps(returnResults)

@app.route('/api/getRecommended')
def getRecommended():
  hourNow = int(datetime.now().hour)
  timeOfDay = ""
  if hourNow < 12:
    timeOfDay = "morning"
  elif hourNow > 12 and hourNow < 18:
    timeOfDay = "afternoon"
  else:
    timeOfDay = "evening"
  results = activities_db.distinct("name", {"time_of_day": "evening", "mood": "happy"})
  return dumps(results) if results else {}

@app.route('/api/getHappyStats')
def getHappyStats():
  activities = activities_db.find({"mood": "happy"})
  return dumps(activities) if activities else {}

@app.route('/api/getDateInfo', methods=["POST"])
def getDateInfo():
  content = request.json
  result = dates_db.find_one({"date": content["date"]})
  return dumps(result) if result else {}

@app.route('/api/getLastFiveDaysInfo')
def getLastFiveDaysInfo():
  returnData = []
  scoreMap = {"happy": 5, "sad": -5, "meh": 0}

  now = datetime.now()
  currentYear = str(now.year)
  currentMonth = int(now.month)
  currentDay = str(now.day)
  if currentMonth < 10:
    currentMonth = "0" + str(currentMonth)
  currentDateStr = currentYear + "-" + currentMonth + "-" + currentDay

  for i in range(0, 10):
    score = 0
    currentDay = int(currentDay)
    previousDayStr = str(currentDay-i)
    if int(previousDayStr) < 10:
      previousDayStr = "0" + str(previousDayStr)
    previousDayWholeStr = currentYear + "-" + currentMonth + "-" + previousDayStr
    result = dates_db.find_one({"date": previousDayWholeStr})
    if result:
      for activity in result["activities"]:
        for each in result["activities"][activity]:
          score += scoreMap[each["mood"]]
      returnData.append((previousDayWholeStr, score))
    else:
      returnData.append((previousDayWholeStr, 0))

  returnData.reverse()
  return json.dumps(returnData)
  

@app.route('/api/addActivityToDate')
def addActivityToDate():
  date = datetime.date.today()
  date_str = "{0}-{1}-{2}".format(date.year, date.month, date.day)
  result = dates_db.find_one({"date": date_str})
  activities = result["activities"]
  activities[time_of_day].append(activity_data)
  result = activities_db.find_one_and_update(
      {"date": date_str}, {"$set": {"activities": activities}})
  return "abc"

@app.route('/api/addMoodToDate', methods=['GET', 'POST'])
def addMoodToDate():
  content = request.json
  date = content["date"]
  mood = content["mood"]
  result = dates_db.find_one({"date": date})
  print(result)
  if result:
    dates_db.find_one_and_update(
        {"date": date}, {"$set": {"mood": mood}})
  else:
    dates_db.insert_one({"date": date, "mood": mood, "activities": {"morning": [], "afternoon": [], "evening": []}})
  
  return "hello"

if __name__ == "__main__":
    app.run(host="0.0.0.0", port=80)
