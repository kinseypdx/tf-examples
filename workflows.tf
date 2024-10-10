
# WIP
# resource "newrelic_workflow" "workflow" {
#   account_id = var.account_id
#   name = "Staging Workflow"
#   enabled = true
#   muting_rules_handling = "DONT_NOTIFY_FULLY_MUTED_ISSUES"

#   issues_filter {
#     name = "workflow_filter"
#     type = "FILTER"

#     predicate {
#       attribute = "accumulations.nrqlEventType"
#       operator = "EXACTLY_MATCHES"
#       values = ["SyntheticCheck", "NetworkSample"]
#     }
#   }

#   destination {
#     channel_id = newrelic_notification_channel.email_channel_1.id
#     notification_triggers = ["ACKNOWLEDGED", "ACTIVATED", "CLOSED"]
#     update_original_message = true
#   }
# }




# ##########################################################
# # Staging Workflow 
# ##########################################################

# resource "newrelic_workflow" "staging" {
#   name                  = "Staging Workflow"
#   muting_rules_handling = "NOTIFY_ALL_ISSUES"

#   issues_filter {
#     name = "staging filter"
#     type = "FILTER"

#     predicate {
#       attribute = "accumulations.tag.env"
#       operator  = "EXACTLY_MATCHES"
#       values    = ["staging", "stg", "stag"]
#     }
#   }

#   destination {
#     channel_id = newrelic_notification_destination.kinsey.id
#   }
# }


# ##########################################################
# # Production Workflow
# # if not tagged, treat as higher priority - prod - just in case
# ##########################################################
# resource "newrelic_workflow" "prod" {
#   name                  = "Production Workflow"
#   muting_rules_handling = "NOTIFY_ALL_ISSUES"

#   issues_filter {
#     name = "prod filter"
#     type = "FILTER"

#     predicate {
#       attribute = "accumulations.tag.env"
#       operator  = "DOES_NOT_EQUAL"
#       values    = ["staging", "stg", "stag"]
#     }
#   }

#   destination {
#     channel_id = newrelic_notification_destination.boris_directs.id
#   }
# }