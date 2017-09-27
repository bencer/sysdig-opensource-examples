FROM alpine
RUN mkdir -p /usr/src/app
RUN apk --update add --virtual python  
RUN apk add py-pip
RUN pip install pymongo
ADD hamlet.txt /usr/src/app/ 
ADD wordMap.js /usr/src/app/ 
ADD wordReduce.js /usr/src/app/ 
ADD mapreduce.py /usr/src/app/ 
ADD aggregate.py /usr/src/app/ 
ADD entrypoint.sh /
CMD ["/entrypoint.sh"]
