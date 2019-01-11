Flask mega tutorial 1
==

### Installing Python

#### 홈 브루 설치

``` bash
$ ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```
#### 파이썬 설치
``` bash
$ brew install python
```

### Installing Flask
#### venv 만들기

python3에 virtual environment를 만들어 주는 내장 모듈이 있다.
``` bash
$ python3 -m venv venv
```



#### vevn 활성화

~/.bash_profile에 아래의 코드 추가
```bash
workon () {
    source ~/git/$1/venv/bin/activate
}
alias workoff='deactivate'
```

activate
```bash
$ workon flask
```
deactivate
```bash
$ workoff
```

#### flask 설치
```bash
(venv) $ pip3 install flask
```

### A "Hello, World" Flask Application

#### app 폴더 생성
```bash
(venv) $ mkdir app
```
#### __init\__.&#8203;py 생성
[ ~/app/__init\__.py ]
```python
from flask import Flask
app = Flask(__name__)
from app import routes
```
이 코드에서 app이 두 번 쓰인다.
2번째 줄의 app은 Flask instance이다.
3번째 줄의 app은 package로서의 app을 뜻한다.

routes에서 두 번째 줄에서 정의된 app을 사용하기 때문에
import를 가장 밑에 했다. (bottom import)
>app과 route가 서로 참조하기 때문에 생긴 문제다.
이 는 flask에서 흔히 일어나는 문제라고 한다.

#### routes.&#8203;py 생성

[ ~/app/routes.py ]
```python
from app import app

@app.route('/')
@app.route('/index')
def index():
    return "Hello, World!"
```

decorator를 통해 정의된 함수를 url과 bind한다.
> app은 flask instance이다.
https://github.com/pallets/flask/blob/master/flask/app.py
위의 링크에 flask 클래스 정의되어 있다.
flask 클래스안의 route 함수를 보자.
>``` python
> def route(self, rule, **options):
> ... 중략 ...
>   def decorator(f):
>     endpoint = options.pop('endpoint', None)
>     self.add_url_rule(rule, endpoint, f, **options)
>     return f
> return decorator
>```
>5번째 줄에서 routing해줄 url을 나타내는 'rule'과 decorator로 꾸며줄 함수 'f'를 bind해준다.
#### test 하기

우선 간단한 테스트용 스크립트를 만든다.
[~/test.py]

```python
from app import app
```

환경변수 FLASK_APP을 설정해준다.
` $ export FLASK_APP=test.py`

FLASK_APP은 어떻게 flask를 load할지 정해주는 환경변수다.
환경변수를 다양하게 설정해줄 수 있다.
자세한 건 아래의 링크를 참고하면 된다.
(http://flask.pocoo.org/docs/1.0/cli/)



flask를 실행시킨다.
` $ flask run`
