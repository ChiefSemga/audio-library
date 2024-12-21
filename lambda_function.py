import json
import boto3
import pymysql

s3 = boto3.client('s3')
bucket_name = 'your-audiobook-library-bucket'

def get_db_connection():
    return pymysql.connect(
        host=os.environ['DB_HOST'],
        user=os.environ['DB_USER'],
        password=os.environ['DB_PASSWORD'],
        db=os.environ['DB_NAME'],
        cursorclass=pymysql.cursors.DictCursor
    )

def lambda_handler(event, context):
    conn = get_db_connection()
    
    try:
        with conn.cursor() as cursor:
            if event['httpMethod'] == 'GET':
                cursor.execute("SELECT * FROM audiobooks")
                result = cursor.fetchall()
                return {
                    'statusCode': 200,
                    'body': json.dumps(result)
                }
            elif event['httpMethod'] == 'POST':
                body = json.loads(event['body'])
                cursor.execute(
                    "INSERT INTO audiobooks (title, author, file_path) VALUES (%s, %s, %s)",
                    (body['title'], body['author'], body['file_path'])
                )
                conn.commit()
                return {
                    'statusCode': 201,
                    'body': json.dumps({'message': 'Audiobook created successfully'})
                }
    finally:
        conn.close()

    return {
        'statusCode': 400,
        'body': json.dumps('Invalid request')
    }

