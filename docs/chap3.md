Flask mega tutorial 3
==

#### Introduction to Flask-WTF

Flask-WTF은 처음으로 선보이는 extension으로써 flask에서 web form을 쓸 수 있게 해주는 extension이다.

pip을 사용해서 install할 수 있다.

``` pip3 install flask-wtf```

#### Configuration

configuration을 하는 가장 간단한 방식은 flask에서 자체적으로 관리하는 config변수를 사용하는 것이다.

``` python
app = Flask(__name__)
app.config['SECRET_KEY'] = 'you-will-never-guess'
# ... add more variables here as needed
```

>app.config가 처음에 어떻게 정의돠는지 궁금하다.
>
>app.py에서 Flask 클래스의 \__init\__함수에서 처음으로 정의 된다.
>
>[flask/app.py](https://github.com/pallets/flask/blob/master/flask/app.py#L396)
> ```python
> class Flask(...):
>   ...
>   def __init__(...):
>       ...
>       self.config = self.make_config(instance_relative_config)
> ```
> [self.make_config](https://github.com/pallets/flask/blob/master/flask/app.py#L653)를 살펴보자.
>
> ```python
>...
>   def make_config(self,instance_relative=False):
>       ...
>       root_path = self.root_path
>       if instance_relative:
>           root_path = self.instance_path
>       defaults = dict(self.default_config)
>       defaults['ENV'] = get_env()
>       defaults['DEBUG'] = get_debug_flag()
>       return self.config_class(root_path, defaults)
> ```
> 반환값이 ```config_class```다. 
>
> ```config_class = Config ```이기 때문에, 결국 Config클래스 인스턴스를 만들어서 반환해 준다.
>
>config.py의 Config 클래스를 보자.
> 
>[flask/config.py](https://github.com/pallets/flask/blob/master/flask/config.py#L84)
> ``` python
> class Config(dict):
>   def __init__(self, root_path, defaults=None):
>       dict.__init__(self, defaults or {})
>       self.root_path = root_path
> ```
> argument로 받은 defaults로 사전을 만든다는 것을 알 수 있다.
> 
> make_config에서 defaults에 default_config변수와 get_env()와 get_debug_flag()를 넣어준다.
>
> default_config은 다음과 같다.
>
>[flask/app.py](https://github.com/pallets/flask/blob/master/flask/app.py#L282)
>``` python
>   default_config = ImmutableDict({'ENV': None,'DEBUG':  None,'TESTING':False,'PROPAGATE_EXCEPTIONS': None,'PRESERVE_CONTEXT_ON_EXCEPTION': None, 'SECRET_KEY': None, 'PERMANENT_SESSION_LIFETIME': timedelta(days=31), 'USE_X_SENDFILE': False, 'SERVER_NAME': None, 'APPLICATION_ROOT': '/', 'SESSION_COOKIE_NAME': 'session', 'SESSION_COOKIE_DOMAIN': None, 'SESSION_COOKIE_PATH': None, 'SESSION_COOKIE_HTTPONLY': True, 'SESSION_COOKIE_SECURE': False, 'SESSION_COOKIE_SAMESITE': None, 'SESSION_REFRESH_EACH_REQUEST': True, 'MAX_CONTENT_LENGTH': None, 'SEND_FILE_MAX_AGE_DEFAULT': timedelta(hours=12), 'TRAP_BAD_REQUEST_ERRORS': None, 'TRAP_HTTP_EXCEPTIONS': False, 'EXPLAIN_TEMPLATE_LOADING': False, 'PREFERRED_URL_SCHEME': 'http', 'JSON_AS_ASCII': True, 'JSON_SORT_KEYS': True, 'JSONIFY_PRETTYPRINT_REGULAR': False, 'JSONIFY_MIMETYPE': 'application/json', 'TEMPLATES_AUTO_RELOAD': None, 'MAX_COOKIE_SIZE': 4093, })
>```
> get_env()와 get_debug_flag()는 helpers.py에 정의되어 있다.
>
> [flask/helpers.py](https://github.com/pallets/flask/blob/master/flask/helpers.py#L49)
> ```python
> def get_env():
>    return os.environ.get('FLASK_ENV') or 'production'
> ...
> def get_debug_flag():
>   val = os.environ.get('FLASK_DEBUG')
>   if not val:
>       return get_env() == 'development'
>   return val.lower() not in ('0', 'false', 'no')
> ```
> get_env는 FLASK_ENV라는 환경변수를 반환한다. 만약, 아무것도 없다면 production을 반환한다. 
>
> get_debug_flag는 현재 디버그 모드인지 아닌지를 boolean값으로 반환해준다.

하지만, configuration은 어플리케이션과 따로 관리할 필요가 있다.
따라서, 