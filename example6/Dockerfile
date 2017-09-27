FROM gcc:4.9
WORKDIR /usr/src/demo
COPY write.c /usr/src/demo
COPY fwrite.c /usr/src/demo
COPY write2.c /usr/src/demo
COPY fwrite2.c /usr/src/demo
COPY entrypoint.sh /
RUN gcc -o write write.c
RUN gcc -o fwrite fwrite.c
RUN gcc -o write2 write2.c
RUN gcc -o fwrite2 fwrite2.c
CMD ["/entrypoint.sh"]
