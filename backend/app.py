from flask import Flask, request, jsonify, Response, json
from flask import render_template, redirect
from flask_pymongo import PyMongo
from datetime import datetime
from bson.json_util import dumps, loads
import datetime
import os
import json
from collections import OrderedDict

app = Flask(__name__)
app.config["MONGO_URI"] = "mongodb://admin:password123@ds147942.mlab.com:47942/greatday"
mongo = PyMongo(app)
activities_db = mongo.db.activities
moods_db = mongo.db.moods
dates_db = mongo.db.dates

@app.route('/')
def index():
  return "hello world"

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

@app.route('/api/getDateInfo', methods=["POST"])
def getDateInfo():
  content = request.json
  print(content)
  result = dates_db.find_one({"date": content["date"]})
  return dumps(result) if result else {}

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
