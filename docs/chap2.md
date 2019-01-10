Flask mega tutorial 2
==
chap1에서 아주 기본적인 웹앱을 만들었다.
이제 홈페이지를 만들어 보자.

아직 사용자라는 개념이 없으니, 다음과 같이 가상의 사용자를 정의한다.
```
 user = {'username': 'tw4204'}
```

사용자에 대한 정확한 구현은 나중에 한다.

#### What Are Templates?

유저의 request가 들어오면 html파일을 돌려줘야한다.
이를 다음과 같이 간단히 구현할 수 있다.

[~/app/routes.py]
```python
from app import app

@app.route('/')
@app.route('/index')
def index():
    user = {'username': 'Miguel'}
    return '''
<html>
    <head>
        <title>Home Page - Microblog</title>
    </head>
    <body>
        <h1>Hello, ''' + user['username'] + '''!</h1>
    </body>
</html>'''
```

하지만, view function이 많아졌다고 했을 때 홈페이지의 전체적인
layout을 바꾸려고 하면 각 view function의 html코드를 바꿔줘야 한다.

따라서, 홈페이지를 presentation 하는 것을 따로 분리해서 관리해야 한다.
template을 통해 presentation과 business logic을 분리할 수 있다.

template을 위한 디렉토리를 우선 만든다.
```bash
 $ mkdir app/templates
```

초기 화면의 template을 다음과 같이 만든다.
[~/app/templates/index.html]
```html
<html>
   <head>
       <title>{{ title }} - Microblog</title>
   </head>
   <body>
       <h1>Hello, {{ user.username }}!</h1>
   </body>
</html>
```
기존의 html파일과는 다른 점이 있다.
{{}}로 둘러싸인 부분은 동적으로 변하는 placeholder다.
아래의 새로운 view function을 보자.
[~/app/routes.py]
```python{.line-numbers}
from flask import render_template
from app import app

@app.route('/')
@app.route('/index')
def index():
    user = {'username': 'tw4204'}
    return render_template('index.html', title='Home', user=user)
```
8번째 줄에서 render_template을 통해, index.html의 placeholder에 실제로 들어가는 값들을 넣어준다.
이 는 [jinja](http://jinja.pocoo.org/)라는 template 엔진을 통해 이뤄진다.
이렇게 만들어진 html을 반환해주게 된다.

### Jinja
jinja에서는 다양한 기능을 제공해준다.
#### Conditional Statements
```html{.line-numbers}
<html>
    <head>
        {% if title %}
        <title>{{ title }} - Microblog</title>
        {% else %}
        <title>Welcome to Microblog!</title>
        {% endif %}
    </head>
    <body>
        <h1>Hello, {{ user.username }}!</h1>
    </body>
</html>
```
조건문을 사용할 수 있다.

#### Loop

loop를 보여주기 위해, 일단 가상의 post들을 만들어준다.

[~/app/routes.py]

```python{.line-numbers}
from flask import render_template
from app import app

@app.route('/')
@app.route('/index')
def index():
    user = {'username': 'tw4204'}
    posts = [
        {
            'author': {'username': 'John'},
            'body': 'Beautiful day in Portland!'
        },
        {
            'author': {'username': 'Susan'},
            'body': 'The Avengers movie was so cool!'
        }
    ]
    return render_template('index.html', title='Home', user=user, posts=posts)
```

[~/app/templates/index.html]

```html{.line-numbers}
<html>
    <head>
        {% if title %}
        <title>{{ title }} - Microblog</title>
        {% else %}
        <title>Welcome to Microblog</title>
        {% endif %}
    </head>
    <body>
        <h1>Hi, {{ user.username }}!</h1>
        {% for post in posts %}
        <div><p>{{ post.author.username }} says: <b>{{ post.body }}</b></p></div>
        {% endfor %}
    </body>
</html>
```
위와 같이 반복문도 쓸 수 있다.

#### Template Inheritance
대부분의 웹 어플리케이션들은 navigation bar가 있다.
index.html에 코드를 추가해 구현할 수 있겠지만, 초기 화면외의 다른 화면에서도 navigation bar가 존재해야하기 때문에 다른 html코드에도 navigation bar부분을 추가해야 한다.

이런 문제를 해결하기 위해, navigation bar가 구현된 기본적인 템플릿을 만든 후에, 나중에 새로운 템플릿들을 추가할 때 이 기본 템플릿을 상속하게 하면 된다.

간단한 navigation bar가 구현된 base 템플릿을 만든다.

[~/app/templates/base.html]
```html{.line-numbers}
<html>
    <head>
      {% if title %}
      <title>{{ title }} - Microblog</title>
      {% else %}
      <title>Welcome to Microblog</title>
      {% endif %}
    </head>
    <body>
        <div>Microblog: <a href="/index">Home</a></div>
        <hr>
        {% block content %}{% endblock %}
    </body>
</html>
```
후에 새로 만들 템플릿을 block 부분에 넣어줄 수 있다.

기존의 index 템플릿은 다음과 같이 바꿀 수 있다.

[~/app/templates/index.html]
```html{.line-numbers}
{% extends "base.html" %}

{% block content %}
    <h1>Hi, {{ user.username }}!</h1>
    {% for post in posts %}
    <div><p>{{ post.author.username }} says: <b>{{ post.body }}</b></p></div>
    {% endfor %}
{% endblock %}
```
