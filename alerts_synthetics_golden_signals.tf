##############################################################
# Create the Synthetics golden signal alert policy
##############################################################

resource "newrelic_alert_policy" "synthetics_golden_signal_policy" {
  name = "Synthetics Golden Signals"
}

##############################################################
# Create the Synthetics golden signal alert conditions
# 2 Signals: Latency and Failures
##############################################################

# 1. Latency
resource "newrelic_nrql_alert_condition" "synthetics_latency" {
  account_id                   = var.account_id
  policy_id                    = newrelic_alert_policy.synthetics_golden_signal_policy.id
  type                         = "baseline"
  name                         = "Synthetics Latency"
  runbook_url                  = "https://www.runbookurl.com/latency"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT percentile(duration, 50) / 1000 FROM SyntheticCheck FACET monitorName"
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


# 2. Monitor Failures
resource "newrelic_nrql_alert_condition" "synthetics_failure" {
  account_id                   = var.account_id
  policy_id                    = newrelic_alert_policy.synthetics_golden_signal_policy.id
  type                         = "static"
  name                         = "Synthetics Failure"
  runbook_url                  = "https://www.runbookurl.com/fails"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT filter(count(*), WHERE result = 'FAILED') AS 'Failures' FROM SyntheticCheck FACET monitorName"
  }

  critical {
    operator              = "above"
    threshold             = 1
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_timer"
  aggregation_timer  = 60
}
