#!/usr/bin/python
from flask import Flask, flash, redirect, render_template, \
     request, url_for
import os
import functools
#these are needed for graphdashboard
import operator
import sys

app = Flask(__name__)
app.secret_key = 'some_secret'
source = None;
days = None;


@app.route('/')
@app.route('/index')
@app.route('/index.html')
def Main():
	return render_template('index.html')




@app.route('/display')
@app.route('/display.html')	
def Display():


	source = request.args.get('Source')
	days = request.args.get('Days')
	if source is None and days is None:
		flash('ERROR! No Source was provided, please specify source and press the SUBMIT button', 'error')
		return render_template('index.html')
	else:
		flash('Your graphs have been generated','feedback')
		
		import csv
		import numpy as np
		import graphdashboard
		
		graphdashboard.main(source,days)
		

		return render_template('display.html')




@app.route('/documentation')
@app.route('/documentation.html')
def Documentation():
	return render_template('documentation.html')		
	

@app.route('/about')
@app.route('/about.html')
def About():
	return render_template('about.html')		
	
	

@app.route('/contact')
@app.route('/contact.html')
def Contact():
	return render_template('contact.html')	

	
	


if __name__ == '__main__':
	app.run(host='0.0.0.0',port=5000,debug=True)

app.debug = True
#app.run()
