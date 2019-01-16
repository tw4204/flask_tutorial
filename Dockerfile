FROM alpine:3.8
RUN apk add python3 && pip3 install --upgrade pip setuptools
RUN apk add enchant
RUN adduser -D microblog
WORKDIR /home/microblog
RUN pip3 install virtualenv 
RUN python3 -m venv venv
COPY requirements.txt requirements.txt
RUN venv/bin/pip3 install gunicorn pymysql
RUN venv/bin/pip3 install -r requirements.txt
RUN venv/bin/pip3 install gunicorn
COPY app app
COPY migrations migrations
COPY microblog.py config.py boot.sh ./
RUN chmod +x boot.sh
ENV FLASK_APP microblog.py
RUN chown -R microblog:microblog ./
USER microblog
EXPOSE 5000
ENTRYPOINT ["./boot.sh"]
