import importlib
import string
import random

def randNum():
    count = 6
    ran = ''.join(random.choices(
        string.digits + string.digits, k=count))
    return str(ran)

def randChar():
    count = 10
    ran = ''.join(random.choices(
        string.ascii_lowercase + string.digits, k=count))
    return str(ran)