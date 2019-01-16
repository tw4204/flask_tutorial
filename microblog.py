from app import db, cli, create_app
from app.models import User, Post
from dotenv import load_dotenv

load_dotenv()
app = create_app()
cli.register(app)

@app.shell_context_processor
def make_shell_context():
    return {'db': db, 'User': User, 'Post': Post}
