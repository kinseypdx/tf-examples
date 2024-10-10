##############################################################
# Create the Browser golden signal alert policy
##############################################################

resource "newrelic_alert_policy" "browser_golden_signal_policy" {
  name = "Browser Golden Signals"
}

##############################################################
# Create the APM golden signal alert conditions
# 5 signals: Throughput, LCP, INP, Pageload time, Ajax throughput
##############################################################

# 1. Throughput
resource "newrelic_nrql_alert_condition" "browser_throughput" {
  account_id                   = var.account_id
  policy_id                    = newrelic_alert_policy.browser_golden_signal_policy.id
  type                         = "baseline"
  name                         = "frontend throughput"
  runbook_url                  = "https://www.runbook.url/throughput"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT rate(count(*), 1 minute) FROM PageView FACET appName"
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

# 2. LCP
resource "newrelic_nrql_alert_condition" "largest_contentful_paint" {
  account_id                   = var.account_id
  policy_id                    = newrelic_alert_policy.browser_golden_signal_policy.id
  type                         = "baseline"
  name                         = "Largest Contentful Paint"
  runbook_url                  = "https://www.runbook.url/lcp"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT percentile(largestContentfulPaint, 75) FROM PageViewTiming FACET appName"
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
  baseline_direction = "upper_only"
}

# 3. INP
resource "newrelic_nrql_alert_condition" "inp" {
  account_id                   = var.account_id
  policy_id                    = newrelic_alert_policy.browser_golden_signal_policy.id
  type                         = "baseline"
  name                         = "Interaction to Next Paint"
  runbook_url                  = "https://www.runbook.url/inp"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT percentile(interactionToNextPaint, 75) FROM PageViewTiming FACET appName"
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
  baseline_direction = "upper_only"
}

# 4. Pageload time
resource "newrelic_nrql_alert_condition" "pageload_time" {
  account_id                   = var.account_id
  policy_id                    = newrelic_alert_policy.browser_golden_signal_policy.id
  type                         = "baseline"
  name                         = "Pageload Time"
  runbook_url                  = "https://www.runbook.url/pageload"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT average(duration) FROM PageView FACET appName"
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

# 5. Ajax throughput
resource "newrelic_nrql_alert_condition" "ajax_requests" {
  account_id                   = var.account_id
  policy_id                    = newrelic_alert_policy.browser_golden_signal_policy.id
  type                         = "baseline"
  name                         = "ajax requests"
  runbook_url                  = "https://www.runbook.url/ajax"
  enabled                      = true
  violation_time_limit_seconds = 259200

  nrql {
    query = "SELECT rate(count(*), 1 minute) FROM AjaxRequest FACET appName"
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