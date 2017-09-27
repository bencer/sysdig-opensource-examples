from pymongo import MongoClient

connection = MongoClient("mongodb")
db = connection.test

db.texts.remove()

lines = open("hamlet.txt").readlines()
[db.texts.insert({"text": line}) for line in lines]

while True:

    tracer = open("/dev/null", "a", 0)
    tracer.write(">:t:aggregate::")
    tracer.flush()

    cursor = db.texts.find({})

    wordcount = {}

    for document in cursor:
        linesplit = document.get("text").split()
        for word in linesplit:
            if word in wordcount:
                wordcount[word] += 1
            else:
                wordcount[word] = 1

    for word, times in wordcount.items():
            print "%s was found %d times" % (word, times)

    tracer.write("<:t:aggregate::")
    tracer.flush()

