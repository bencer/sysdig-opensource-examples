from pymongo import MongoClient

connection = MongoClient("mongodb")
db = connection.test

db.texts.remove()

lines = open("hamlet.txt").readlines()
[db.texts.insert({"text": line}) for line in lines]

map = open('wordMap.js', 'r').read()
reduce = open('wordReduce.js', 'r').read()

while True:

    tracer = open("/dev/null", "a", 0)
    tracer.write(">:t:mapreduce::")
    tracer.flush()

    results = db.texts.map_reduce(map, reduce, "myresults")

    for result in results.find():
        print result["_id"], result["value"]["count"]

    tracer.write("<:t:mapreduce::")
    tracer.flush()

