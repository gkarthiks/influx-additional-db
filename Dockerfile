FROM alpine:3.8
MAINTAINER gkarthiks "github.gkarthiks@gmail.com"
RUN apk update
RUN apk upgrade
RUN apk add --no-cache curl bash
WORKDIR /src
COPY ./createdb.sh .
RUN chmod +x ./createdb.sh
ENTRYPOINT [ "./createdb.sh"]