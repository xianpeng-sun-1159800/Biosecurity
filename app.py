import os

from flask import Flask
from flask import render_template
from flask import request
from flask import redirect
from flask import url_for
from flask import session
import re
from datetime import datetime
import mysql.connector
from mysql.connector import FieldType
from werkzeug.utils import secure_filename

import connect
from flask_hashing import Hashing

app = Flask(__name__)
hashing = Hashing(app)  #create an instance of hashing

# Change this to your secret key (can be anything, it's for extra protection)
app.secret_key = 'your secret key'

dbconn = None
connection = None

def getDictCursor():
    global dbconn
    global connection
    connection = mysql.connector.connect(user=connect.dbuser, password=connect.dbpass, host=connect.dbhost,
                                         auth_plugin='mysql_native_password', database=connect.dbname, autocommit=True)
    dbconn = connection.cursor(dictionary=True)
    return dbconn

@app.route('/login/', methods=['GET', 'POST'])
def login():
    msg = ''
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form:
        username = request.form['username']
        user_password = request.form['password']
        cursor = getDictCursor()
        cursor.execute('SELECT * FROM user WHERE name = %s', (username,))
        account = cursor.fetchone()
        if account is not None:
            password = account["password"]
            if hashing.check_value(password, user_password, salt='abcd'):
                session['loggedin'] = True
                session['id'] = account['user_id']
                session['username'] = account['name']
                session['userrole'] = account['role']
                return redirect(url_for('home'))
            else:
                msg = 'Incorrect password!'
        else:
            msg = 'Incorrect username'
    return render_template('index.html', msg=msg)

@app.route('/')
def root():
    return redirect(url_for('home'))


# http://localhost:5000/register - this will be the registration page, we need to use both GET and POST requests
@app.route('/register', methods=['GET', 'POST'])
def register():
    # Output message if something goes wrong...
    msg = ''
    # Check if "username", "password" and "email" POST requests exist (user submitted form)
    if request.method == 'POST' and 'username' in request.form and 'password' in request.form and 'email' in request.form:
        # Create variables for easy access
        username = request.form['username']
        password = request.form['password']
        email = request.form['email']
        # Check if account exists using MySQL
        cursor = getDictCursor()
        cursor.execute('SELECT * FROM user WHERE name = %s', (username,))
        account = cursor.fetchone()
        # If account exists show error and validation checks
        if account:
            msg = 'Account already exists!'
        elif not re.match(r'[^@]+@[^@]+\.[^@]+', email):
            msg = 'Invalid email address!'
        elif not re.match(r'[A-Za-z0-9]+', username):
            msg = 'Username must contain only characters and numbers!'
        elif not username or not password or not email:
            msg = 'Please fill out the form!'
        else:
            # Account doesnt exists and the form data is valid, now insert new account into accounts table
            hashed = hashing.hash_value(password, salt='abcd')
            cursor.execute('INSERT INTO user (name, password, email, role) VALUES (%s, %s, %s, %s)', (username, hashed, email, 1))
            msg = 'You have successfully registered!'
    elif request.method == 'POST':
        # Form is empty... (no POST data)
        msg = 'Please fill out the form!'
    # Show registration form with message (if any)
    return render_template('register.html', msg=msg)


@app.route('/home')
def home():
    if 'loggedin' in session:
        cursor = getDictCursor()
        cursor.execute('SELECT * FROM guide')
        guides = cursor.fetchall()
        return render_template('home.html', username=session['username'], userrole=session['userrole'], guides=guides)
    return redirect(url_for('login'))

# http://localhost:5000/profile - this will be the profile page, only accessible for loggedin users
@app.route('/profile')
def profile():
    # Check if user is loggedin
    if 'loggedin' in session:
        # We need all the account info for the user so we can display it on the profile page
        cursor = getDictCursor()
        cursor.execute('SELECT * FROM user WHERE user_id = %s', (session['id'],))
        account = cursor.fetchone()
        # Show the profile page with account info
        return render_template('profile.html', account=account)
    # User is not loggedin redirect to login page
    return redirect(url_for('login'))

# http://localhost:5000/logout - this will be the logout page
@app.route('/logout')
def logout():
    # Remove session data, this will log the user out
   session.pop('loggedin', None)
   session.pop('id', None)
   session.pop('username', None)
   session.pop('userrole', None)
   # Redirect to login page
   return redirect(url_for('login'))


@app.route('/staff_management')
def staff_management():
    if 'loggedin' in session:
        cursor = getDictCursor()
        cursor.execute('SELECT * FROM user WHERE user_id = %s', (session['id'],))
        account = cursor.fetchone()
        if account["role"] == 3:
            cursor.execute('SELECT * FROM user WHERE role = 2')
            users = cursor.fetchall()
            return render_template('user_management.html', userrole=session['userrole'], users=users)
        else:
            return redirect(url_for('home'))
    return redirect(url_for('login'))

@app.route('/user_management')
def user_management():
    if 'loggedin' in session:
        cursor = getDictCursor()
        cursor.execute('SELECT * FROM user WHERE user_id = %s', (session['id'],))
        account = cursor.fetchone()
        if account["role"] == 2 or account["role"] == 3:
            cursor.execute('SELECT * FROM user WHERE role = 1')
            users = cursor.fetchall()
            return render_template('user_management.html', userrole=session['userrole'], users=users)
        else:
            return redirect(url_for('home'))
    return redirect(url_for('login'))

@app.route('/guide_management')
def guide_management():
    if 'loggedin' in session:
        cursor = getDictCursor()
        cursor.execute('SELECT * FROM user WHERE user_id = %s', (session['id'],))
        account = cursor.fetchone()
        if session.get('userrole') in [2, 3]:
            cursor.execute('SELECT * FROM guide')
            guides = cursor.fetchall()
            return render_template('guide_management.html', userrole=session['userrole'], guides=guides)
        else:
            return redirect(url_for('home'))
    return redirect(url_for('login'))


@app.route('/guides/delete/<int:guide_id>', methods=['POST'])
def delete_guide(guide_id):
    cursor = getDictCursor()
    sql = "DELETE FROM guide WHERE horticulture_id=%s"
    cursor.execute(sql, (guide_id,))
    return "successfully"


@app.route('/guides/edit/<int:horticulture_id>', methods=['POST'])
def edit_guide(horticulture_id):
    data = request.json

    cursor = getDictCursor()
    sql = "UPDATE guide SET common_name=%s, scientific_name=%s, key_characteristics=%s, biology_description=%s, symptoms=%s WHERE horticulture_id=%s"
    cursor.execute(sql, (
        data['common_name'], data['scientific_name'], data['key_characteristics'], data['biology_description'],
        data['symptoms'], horticulture_id))
    return redirect(url_for('guide_management'))



@app.route('/delete_user/<int:user_id>', methods=['POST'])
def delete_user(user_id):
    cursor = getDictCursor()
    sql = "SELECT * FROM user WHERE user_id = %s" % user_id
    cursor.execute(sql)
    user = cursor.fetchone()
    cursor.execute("DELETE FROM user WHERE user_id=%s", (user_id,))
    if user["role"] == 2:
        return redirect(url_for('staff_management'))
    else:
        return redirect(url_for('user_management'))


@app.route('/update_user', methods=['POST'])
def update_user():
    if request.method == 'POST':
        user_id = request.form['id']
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        phone_number = request.form['phone_number']
        cursor = getDictCursor()
        sql = "UPDATE user SET first_name='%s', last_name='%s', phone_number='%s' WHERE user_id=%s" % (first_name, last_name, phone_number, user_id)
        cursor.execute(sql)
        return 'User information has been successfully updated!', 200
    return 'Failed to update user information.', 500


app.config['UPLOAD_FOLDER'] = 'static'
@app.route('/guides/create', methods=['POST'])
def create_guide():
    data = request.form
    primary_image = request.files['primary_image']

    try:
        if primary_image:
            primary_image.save(os.path.join(app.config['UPLOAD_FOLDER'], primary_image.filename))
            primary_image_path = primary_image.filename
        else:
            primary_image_path = None

        cursor = getDictCursor()
        sql = "INSERT INTO guide (horticulture_item_type, present_in_NZ, common_name, scientific_name, key_characteristics, biology_description, symptoms, primary_image) VALUES (%s, %s, %s, %s, %s, %s, %s, %s)"
        cursor.execute(sql, (
            "pest", "yes", data['common_name'], data['scientific_name'],
            data['key_characteristics'], data['biology_description'], data['symptoms'], primary_image_path))
    except Exception as e:
        print(e)

    return redirect(url_for('guide_management'))

@app.route('/profile/update', methods=['POST'])
def update_profile():
    if request.method == 'POST':
        cursor = getDictCursor()

        data = request.get_json()
        first_name = data['first_name']
        last_name = data['last_name']
        email = data['email']

        password = data['password']
        if password != "******":
            hashed = hashing.hash_value(password, salt='abcd')
            sql = "UPDATE user SET password=%s, first_name=%s, last_name=%s WHERE email=%s"
            cursor.execute(sql, (hashed, first_name, last_name, email))
        else:
            sql = "UPDATE user SET first_name=%s, last_name=%s WHERE email=%s"
            cursor.execute(sql, (first_name, last_name, email))
        return 'User information has been successfully updated!', 200
    return 'Failed to update user information.', 500


if __name__ == '__main__':
    app.run(debug=True)
