##############################################################
# Create the APM golden signal alert policy
##############################################################

resource "newrelic_alert_policy" "apm_golden_signal_policy" {
  name                = "APM Golden Signals"
  incident_preference = "PER_POLICY" # PER_POLICY is default
}

##############################################################
# Create the APM golden signal alert conditions
# 3 signals: response time, throughput, error rate
##############################################################

# 1. Response Time
resource "newrelic_nrql_alert_condition" "response_time" {
  account_id                   = var.account_id
  policy_id                    = newrelic_alert_policy.apm_golden_signal_policy.id
  type                         = "baseline"
  name                         = "Response Time"
  runbook_url                  = "https://www.myrunbookurl.com/responsetime"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT average(apm.service.transaction.duration) * 1000 AS 'Response time (ms)' FROM Metric FACET appName"
  }

  critical {
    operator              = "above"
    threshold             = 3
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  warning {
    operator              = "above"
    threshold             = 2
    threshold_duration    = 300
    threshold_occurrences = "all"
  }

  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
  baseline_direction = "upper_and_lower"
}

# Response Time tags
resource "newrelic_entity_tags" "apm-service-response-time" {
  guid = newrelic_nrql_alert_condition.response_time.entity_guid

  tag {
    key    = "team"
    values = ["instinct", "yellow"]
  }

  tag {
    key    = "terraformManaged"
    values = ["true"]
  }
}


# 2. Throughput
resource "newrelic_nrql_alert_condition" "throughput" {
  account_id                   = var.account_id
  policy_id                    = newrelic_alert_policy.apm_golden_signal_policy.id
  type                         = "baseline"
  name                         = "Throughput"
  runbook_url                  = "https://www.myrunbookurl.com/throughput"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT rate(count(apm.service.transaction.duration), 1 minute) FROM Metric FACET appName"
  }

  critical {
    operator              = "above"
    threshold             = 3
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
  baseline_direction = "upper_and_lower"
}

# 3. Error Rate
resource "newrelic_nrql_alert_condition" "error_rate" {
  account_id                   = var.account_id
  policy_id                    = newrelic_alert_policy.apm_golden_signal_policy.id
  type                         = "baseline"
  name                         = "Error Rate"
  runbook_url                  = "https://www.myrunbookurl.com/errorrate"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT (count(apm.service.error.count) / count(apm.service.transaction.duration)) * 100 AS 'Error %' FROM Metric FACET appName"
  }

  critical {
    operator              = "above"
    threshold             = 3
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
  baseline_direction = "upper_and_lower"
}