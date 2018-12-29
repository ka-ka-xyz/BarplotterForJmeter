from bottle import route, run
import time
import random

def waiting(average, sigma):
    time.sleep(random.normalvariate(average, sigma))


@route('/mock/v1.0/login')
def login():
    waiting(0.1, 0.01)
    return "login!"

@route('/mock/v1.0/all')
def all():
    waiting(3, 0.5)
    return "all"

@route('/mock/v1.0/your')
def your():
    waiting(1, 0.2)
    return "your"

@route('/mock/v1.0/base')
def base():
    waiting(0.4, 0.1)
    return "base"

@route('/mock/v1.0/are')
def are():
    waiting(7, 1.5)
    return "are"

@route('/mock/v1.0/belong')
def belong():
    waiting(5, 0.2)
    return "belong"

@route('/mock/v1.0/to')
def to():
    waiting(12, 2)
    return "to"

@route('/mock/v1.0/us')
def us():
    waiting(4, 1)
    return "us!"

@route('/mock/v1.1/login')
def login():
    waiting(0.1, 0.01)
    return "login!"

@route('/mock/v1.1/all')
def all():
    waiting(2, 0.5)
    return "all"

@route('/mock/v1.1/your')
def your():
    waiting(1, 0.1)
    return "your"

@route('/mock/v1.1/base')
def base():
    waiting(0.6, 0.2)
    return "base"

@route('/mock/v1.1/are')
def are():
    waiting(6, 1.5)
    return "are"

@route('/mock/v1.1/belong')
def belong():
    waiting(8, 2)
    return "belong"

@route('/mock/v1.1/to')
def to():
    waiting(8, 3)
    return "to"

@route('/mock/v1.1/us')
def us():
    waiting(5, 0.5)
    return "us!"


run(host='localhost', port=8080, server="paste")
