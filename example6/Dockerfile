FROM gcc:4.9
WORKDIR /usr/src/demo
COPY write.c /usr/src/demo
COPY fwrite.c /usr/src/demo
COPY entrypoint.sh /
RUN gcc -o write write.c
RUN gcc -o fwrite fwrite.c
CMD ["/entrypoint.sh"]
