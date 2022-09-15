from datetime import datetime
from google.cloud import storage
from google.cloud import pubsub_v1
import base64
import os.path
from os import path
import json
import os

################### Working code in GCF ############################

fTime = datetime.now()
inTimeFormated = fTime.strftime("%m-%d-%Y-%H:%M:%S")
in_bucket = os.environ.get("inbound_bucket_name", "none")
er_bucket = os.environ.get("error_bucket_name", "none")
ar_bucket = os.environ.get("archived_bucket_name", "none")
topic_name = os.environ.get("milestone_topic_name", "none")
project_id = os.environ.get("projectid", "none")

def hello_gcs(event, context):
    
    file = event
    fName = file['name']
    if fName.endswith(".json"):
        function_start(fName, context, inTimeFormated)
        #print('processing file '+fName)
    else:
        print('There is no file to process')

def function_start(fileName, context, inTime):
    #Variables
    #project_id = 'macro-deck-357611'
    #topic_name = 'jsonMessage_Topic_manoj1'
    folder = '/tmp/'

    #Clients
    storage_client = storage.Client()
    publisher_client = pubsub_v1.PublisherClient()  

    try:
        #buckets conf
        inbound_bucket = storage_client.get_bucket(in_bucket)
        archive_bucket = storage_client.get_bucket(ar_bucket)
        errored_bucket = storage_client.get_bucket(er_bucket)

        #topics conf
        topic_path = publisher_client.topic_path(project_id, topic_name)
        
        #Downloading the file to tmp location inside cloud function
        inboundblob = inbound_bucket.blob(fileName)
        print('printing the inbound blob publish time below')
        print(inboundblob['custom_time'])
        destination_uri = '{}/{}'.format(folder,fileName)
        inboundblob.download_to_filename(destination_uri)
        print("File has been downloaded inside clouf cuntion at: "+destination_uri)

        #Traversing the json file stored in tmp to publish
        #individual json documetns from the file to pubsub
        with open(destination_uri) as data_file:
            
            data = checkAndLoadJson(data_file, fileName)
            
            if data == "failed":
                inbound_bucket.copy_blob(inboundblob, errored_bucket, fileName)
                print("Invalid json file moved to Errored Bucket")
                inbound_bucket.delete_blob(fileName)      
                print("deleted the file from inbound Bucket")
                data_file.close()

                #Removing file from Temporary location
                removeTmp(folder, fileName)
                #exit()
                return "invalidJSON"
            else:
                for jsonObject in data['restaurants']:
                    pubsubStatus = publishToPubSub(jsonObject, publisher_client, topic_path, fileName)
                    if pubsubStatus=='Success':
                        continue
                    else:
                        raise

        #Moving file from inbound bucket to archived bucket
        inboundToArchived(inboundblob, inbound_bucket, archive_bucket, fileName, inTime)      
        
        #Removing file from the tmp location inside cloudFunction
        removeTmp(folder, fileName)

    except Exception as e:
        print('Flow is failed to process file ' + fileName)
        print(e)
        print(e.__cause__)
        print(e.__context__)
        raise

#Publishing individual json object to pubsub
def publishToPubSub(ptp_jsonObject, ptp_publisher_client, ptp_topic_path, ptp_fileName):
    try:
        pubMessage = ptp_jsonObject['restaurant']
        message_bytes = str(pubMessage).encode('utf-8')
        print('PRINTING THE ENCODED STRING')
        #print(bas64_bytes)
        print(message_bytes)
        publish_future = ptp_publisher_client.publish(ptp_topic_path, message_bytes)
        result = publish_future.result()
        print('Successfully published the event to pubsub')
        
        # base64_message = base64.b64decode(bas64_bytes).decode('utf-8')
        # #print(jsonObject['restaurant']))
        # print(base64_message)

    except Exception as e:
        print('Failed while publishing the message to pubsub for file :'+ptp_fileName)
        print(e)
        print(e.__cause__)
        raise   

    return 'Success'

#Checking the validity of Json and returning the result back
def checkAndLoadJson(data_file1, fileName1):
    try:
        data = json.load(data_file1)
        print('Valid json file: '+fileName1)
    except Exception as e:
        print("Invalid json file: "+ fileName1)
        return "failed"
    
    return data

#Adding a timestamp in all the file in the archived bucket
def renameFile(rf_inboundblob, rf_inbound_bucket, archBucket, rf_fileName,rf_inTime):
    archblob = archBucket.blob(rf_fileName)
    try:
        newExt = '_'+rf_inTime+'.json'
        updateName = rf_fileName.replace(".json", newExt)
        newBlob = archBucket.rename_blob(archblob, updateName)
        print('Blob has been renamed in the archived bucket')

    except Exception as e:
        print("Flow is failing while renaming the file, File cannot be moved to archived folder and might get reprocessed if not fixed before the next execution. Below is the cause of failure")
        print(e.__cause__)
        raise

#Archiving the processed file to archive bucket
def inboundToArchived(ita_inboundblob, ita_inbound_bucket, ita_archive_bucket, ita_fileName, ita_inTime):
    try:
        #copying payload from inbound bucket to archived bucket
        ita_inbound_bucket.copy_blob(ita_inboundblob, ita_archive_bucket, ita_fileName)
        print('Blob has been moved to the archived bucket')
        
        renameFile(ita_inboundblob, ita_inbound_bucket, ita_archive_bucket, ita_fileName, ita_inTime) 
        
        #Deleting the blob from inbound bucket
        ita_inbound_bucket.delete_blob(ita_fileName)
        print('Blob has been deleted from the inbound bucket')

    except Exception as e:
        print(())
        print (e.__cause__)
        raise

def removeTmp(rt_folder, rt_fileName):
    try:
        fPath = rt_folder+rt_fileName
        if path.exists(fPath):
            os.remove(fPath)
            print('File is successfully removed from the tmp location: '+fPath)
        else:
            print('There is no file to be deleted at: '+fPath)
            raise

    except Exception as e:
        print(e.__cause__)
        raise


#hello_gcs('TestData_8.json', 'blabla')
