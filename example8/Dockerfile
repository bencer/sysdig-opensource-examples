FROM ruby:alpine
RUN mkdir /usr/src/app 
RUN apk --update add --virtual build-dependencies ruby-dev build-base && \  
    gem install mongo faker --no-ri --no-rdoc && \
    apk del build-dependencies
ADD filldata.rb /usr/src/app/ 
ADD mapreduce.rb /usr/src/app/ 
ADD aggregate.rb /usr/src/app/ 
ADD entrypoint.sh /
CMD ["/entrypoint.sh"]
