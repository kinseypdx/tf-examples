##############################################################
# Create the Infra golden signal alert policy
##############################################################

resource "newrelic_alert_policy" "infra_golden_signal_policy" {
  name = "Infrastructure Golden Signals"
}

##############################################################
# Create the Infra golden signal alert conditions
# 5 signals: CPU, Memory, Storage %, Network transmit, network receive
##############################################################

# 1. CPU
resource "newrelic_nrql_alert_condition" "cpu" {
  account_id                   = var.account_id
  policy_id                    = newrelic_alert_policy.infra_golden_signal_policy.id
  type                         = "static"
  name                         = "CPU"
  runbook_url                  = "https://www.runbookurl.com/cpu"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT average(cpuPercent) FROM SystemSample FACET entityName"
  }

  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}


# 2. Memory
resource "newrelic_nrql_alert_condition" "memory" {
  account_id                   = var.account_id
  policy_id                    = newrelic_alert_policy.infra_golden_signal_policy.id
  type                         = "static"
  name                         = "Memory"
  runbook_url                  = "https://www.runbookurl.com/memory"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT average(memoryUsedPercent) FROM SystemSample FACET entityName"
  }

  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}

# 3. Storage 
resource "newrelic_nrql_alert_condition" "storage" {
  account_id                   = var.account_id
  policy_id                    = newrelic_alert_policy.infra_golden_signal_policy.id
  type                         = "static"
  name                         = "Storage"
  runbook_url                  = "https://www.runbookurl.com/storage"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT average(diskUsedPercent) FROM StorageSample FACET entityName"
  }

  critical {
    operator              = "above"
    threshold             = 90
    threshold_duration    = 300
    threshold_occurrences = "all"
  }
  fill_option        = "none"
  aggregation_window = 60
  aggregation_method = "event_flow"
  aggregation_delay  = 120
}

# 4. Network Transmit
resource "newrelic_nrql_alert_condition" "network_transmit" {
  account_id                   = var.account_id
  policy_id                    = newrelic_alert_policy.infra_golden_signal_policy.id
  type                         = "baseline"
  name                         = "Network Transmit"
  runbook_url                  = "https://www.runbookurl.com/transmit"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT average(transmitBytesPerSecond) FROM NetworkSample FACET entityName"
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

# 5. Network Receive
resource "newrelic_nrql_alert_condition" "network_receive" {
  account_id                   = var.account_id
  policy_id                    = newrelic_alert_policy.infra_golden_signal_policy.id
  type                         = "baseline"
  name                         = "Network receive"
  runbook_url                  = "https://www.runbookurl.com/receive"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT average(receiveBytesPerSecond) FROM NetworkSample FACET entityName"
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
