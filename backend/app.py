from flask import Flask, request, jsonify, Response, json
from flask import render_template, redirect
from flask_pymongo import PyMongo
from datetime import datetime
from bson.json_util import dumps, loads
import datetime
import os
import json

app = Flask(__name__)
app.config["MONGO_URI"] = "mongodb://admin:password123@ds147942.mlab.com:47942/greatday"
mongo = PyMongo(app)
activities_db = mongo.db.activities
moods_db = mongo.db.moods
dates_db = mongo.db.dates

@app.route('/')
def index():
  return "hello world"

@app.route('/api/test', methods=['GET'])
def test():
  return "test123"

@app.route('/api/addActivity')
def addActivity():
  # data = json.loads(request.data)
  data = {
      "name": "date",
      "mood": "happy",
      "date": "1550276407",
      "time_of_day": "evening"
  }
  activity = activities_db.insert_one(data)
  print(activity)
  return "hello world"

@app.route('/api/getActivities')
def getActivities():
  activities = activities_db.find({})
  for activity in activities:
    print(activity)
  return "works!"

@app.route('/api/addActivityToDate')
def addActivityToDate():
  time_of_day = "evening"
  activity_data = {
      "activity_id": "5c675dcc73d20235873e10da",
      "name": "date",
      "mood": "happy"
  }
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
