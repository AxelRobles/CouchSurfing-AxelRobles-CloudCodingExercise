import os
import mysql.connector
from fastapi import FastAPI
from fastapi.responses import HTMLResponse

app = FastAPI()

@app.get("/", response_class=HTMLResponse)
def get_free_houses():
    try:
        db_host = os.environ.get('DB_HOST')
        db_user = os.environ.get('DB_USER')
        db_password = os.environ.get('DB_PASSWORD')
        db_name = os.environ.get('DB_NAME')

        conn = mysql.connector.connect(
            host=db_host,
            user=db_user,
            password=db_password,
            database=db_name
        )
        cursor = conn.cursor(dictionary=True)

        cursor.execute("SELECT * FROM housesFree LIMIT 10")
        houses = cursor.fetchall()

        cursor.close()
        conn.close()

        response_html = "<h1>Available Houses</h1><ul>"
        for house in houses:
            response_html += f"<li>{house.get('name', 'N/A')} - Location: {house.get('location', 'N/A')}</li>"
        response_html += "</ul>"
        
        return HTMLResponse(content=response_html, status_code=200)

    except mysql.connector.Error as err:
        error_html = f"<h1>Database Error</h1><p>{err}</p>"
        return HTMLResponse(content=error_html, status_code=500)
    except Exception as e:
        error_html = f"<h1>An unexpected error occurred</h1><p>{e}</p>"
        return HTMLResponse(content=error_html, status_code=500)