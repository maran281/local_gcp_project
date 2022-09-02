#gcp_auth_file = "C:/gcp_poc/key/cla-poc-key.json"

    # name = 
    # description = 
    # runtime = 
    # available_memory_mb = 256
    # source_archive_bucket = 
    # source_archive_object = 

# fn_name = "cla-function-test1"
# fn_runtime = "python310"
# fn_available_memory_mb = "256"
gcp_project   = "macro-deck-357611"
gcp_region    = "europe-west1"
inbucket_name   = "macro-deck-357611-inbound_bucket"
arbucket_name   = "macro-deck-357611-archive_bucket"
erbucket_name   = "macro-deck-357611-error_bucket"
storage_class = "REGIONAL"
gcp_topicname = "cla_milestone_topic"
gcp_milestone_subs = "cla_milestone_topic_subscription"
ack_deadline = "20"
ret_duration = "1200s"
s_account = "cla-serviceaccount-manoj1@macro-deck-357611.iam.gserviceaccount.com"


###################### Below code is working ######################

# gcp_project   = "macro-deck-357611"
# gcp_region    = "europe-west1"
# inbucket_name   = "macro-deck-357611-clabucket-in-test1"
# arbucket_name   = "macro-deck-357611-clabucket-ar-test1"
# erbucket_name   = "macro-deck-357611-clabucket-er-test1"
# storage_class = "REGIONAL"