FROM alpine:3.8
RUN apk update
RUN apk upgrade
RUN apk add --no-cache curl bash
WORKDIR /src
COPY ./createdb.sh .
RUN chmod +x ./createdb.sh
CMD ["bash", "-c", "tail -f /dev/null"]