def lambda_handler(event, context):

    for record in event['Records']:

        body = record["body"]

        print("Received:", body)

    return {
        "statusCode": 200
    }