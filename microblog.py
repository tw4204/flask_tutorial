from app import app, db
from app.models import User, Post
from dotenv import load_dotenv

load_dotenv()


@app.shell_context_processor
def make_shell_context():
    return {'db': db, 'User': User, 'Post': Post}
