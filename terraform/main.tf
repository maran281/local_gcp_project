#  # main declarations of the environment. #

######################### Bucket Creation #########################
resource "google_storage_bucket" "inbound-bucket" {
  project       = var.gcp_project
  name          = var.inbucket_name
  location      = var.gcp_region
  force_destroy = true
  storage_class = var.storage_class
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket" "archived-bucket" {
  project       = var.gcp_project
  name          = var.arbucket_name
  location      = var.gcp_region
  force_destroy = true
  storage_class = var.storage_class
  versioning {
    enabled = true
  }
}

resource "google_storage_bucket" "errored-bucket" {
  project       = var.gcp_project
  name          = var.erbucket_name
  location      = var.gcp_region
  force_destroy = true
  storage_class = var.storage_class
  versioning {
    enabled = true
  }
}

######################### BUCKET FOR ZIPPED GCF CODE #########################
# resource "google_storage_bucket" "fn-bucket" {
#   name     = "fn-code-bucket"
#   location = var.gcp_region
# }

# resource "google_storage_bucket_object" "code-archive" {
#   name   = "readPushFunction-index.zip"
#   bucket = google_storage_bucket.fn-bucket.name
#   source = "C:/gcp_poc/src/readPushFunction/readPushFunction.zip"
# }

######################### CONFIGURING PUBSUB TOPIC WITH PULL SUBSCRIPTION #########################

resource "google_pubsub_topic" "topic_test1" {
    project = var.gcp_project
    name = var.gcp_topicname
    labels = {
        foo = "cla"
    }
    message_retention_duration = "86600s"
}

#manage your IAM policy for Cloud Pub/Sub Topic
resource "google_pubsub_topic_iam_member" "sub_viewer" {
  project = var.gcp_project
  topic = google_pubsub_topic.topic_test1.name
  role = "roles/viewer"
  member = "serviceAccount:${var.s_account}"
}

#A named resource representing the stream of messages from a single, 
#specific topic, to be delivered to the subscribing application
resource "google_pubsub_subscription" "topic_test1_pull_subscription" {
    name = var.gcp_milestone_subs
    topic = google_pubsub_topic.topic_test1.name
    ack_deadline_seconds = var.ack_deadline
    message_retention_duration = var.ret_duration
    labels = {
        foo = "cla"
    }
    # pull subscription is by default
    # what is the default retry policy
    # what is default epiration policy
    # what is default value for "retain_acked_messages"
}

#Managing your IAM policy for pubsub subscription.
resource "google_pubsub_subscription_iam_member" "sub_editor" {
  subscription = google_pubsub_subscription.topic_test1_pull_subscription.name
  role = "roles/editor"
  member = "serviceAccount:${var.s_account}"
}

######################### GOOGLE CLOUD FUNCTION #########################

# resource "google_cloudfunctions_function" "cfunction" {
#     name = var.fn_name
#     description = "Main function which processes the inbound payload"
#     runtime = var.fn_runtime
#     available_memory_mb = var.fn_available_memory_mb
#     timeout = "120"
#     source_archive_bucket = google_storage_bucket.fn-bucket.name
#     source_archive_object = google_storage_bucket_object.code-archive.name

#     environment_variables = {projectid=var.gcp_project, inbound_bucket_name=var.inbucket_name, error_bucket_name=var.erbucket_name, archived_bucket_name=var.arbucket_name, milestone_topic_name=var.gcp_topicname}
    
#     event_trigger {
#       event_type = "google.storage.object.finalize"
#       resource = google_storage_bucket.inbound-bucket.name
#     }
#     entry_point           = "hello_gcs"
#     service_account_email = "cla-serviceaccount-manoj1@macro-deck-357611.iam.gserviceaccount.com"
# }

# # IAM entry for all users to invoke the function
# resource "google_cloudfunctions_function_iam_member" "invoker" {
#   project        = google_cloudfunctions_function.cfunction.project
#   region         = google_cloudfunctions_function.cfunction.region
#   cloud_function = var.fn_name

#   depends_on = [google_cloudfunctions_function.cfunction]

#   role   = "roles/cloudfunctions.invoker"
#   member = "allUsers"
# }


############################ Below Code is working ############################
# resource "google_storage_bucket" "inbound-bucket" {
#   project       = var.gcp_project
#   name          = var.inbucket_name
#   location      = var.gcp_region
#   force_destroy = true
#   storage_class = var.storage_class
#   versioning {
#     enabled = true
#   }
# }
# resource "google_storage_bucket" "archived-bucket" {
#   project       = var.gcp_project
#   name          = var.arbucket_name
#   location      = var.gcp_region
#   force_destroy = true
#   storage_class = var.storage_class
#   versioning {
#     enabled = true
#   }
# }
# resource "google_storage_bucket" "errored-bucket" {
#   project       = var.gcp_project
#   name          = var.erbucket_name
#   location      = var.gcp_region
#   force_destroy = true
#   storage_class = var.storage_class
#   versioning {
#     enabled = true
#   }
# }

# resource "google_storage_bucket" "fn-bucket" {
#   name     = "fn-code-bucket"
#   location = var.gcp_region
# }

# resource "google_storage_bucket_object" "code-archive" {
#   name   = "readPushFunction-index.zip"
#   bucket = google_storage_bucket.fn-bucket.name
#   source = "C:/gcp_poc/src/readPushFunction/readPushFunction.zip"
# }

# resource "google_cloudfunctions_function" "cfunction" {
#     name = var.fn_name
#     description = "Main function which processes the inbound payload"
#     runtime = var.fn_runtime
#     available_memory_mb = var.fn_available_memory_mb
#     timeout = "120"
#     source_archive_bucket = google_storage_bucket.fn-bucket.name
#     source_archive_object = google_storage_bucket_object.code-archive.name
#     event_trigger {
#       event_type = "google.storage.object.finalize"
#       resource = google_storage_bucket.inbound-bucket.name
#     }
#     entry_point           = "hello_gcs"
#     service_account_email = "cla-serviceaccount-manoj1@macro-deck-357611.iam.gserviceaccount.com"
# }

# # IAM entry for all users to invoke the function
# resource "google_cloudfunctions_function_iam_member" "invoker" {
#   project        = google_cloudfunctions_function.cfunction.project
#   region         = google_cloudfunctions_function.cfunction.region
#   cloud_function = google_cloudfunctions_function.cfunction.name

#   role   = "roles/cloudfunctions.invoker"
#   member = "allUsers"
# }