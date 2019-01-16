from flask import jsonify
from translate_api.translate_api import api
from flask_babel import _
def translate(text, source_language, dest_language):
    try:
        return_text = api(text,source_language, dest_language)
    except:
        return_text = _('Error: language detction error.')
    return jsonify( {'text':return_text} )
