resource "newrelic_one_dashboard_json" "aqm" {
  json = file("dashboard_json/aqm.json")
}

resource "newrelic_one_dashboard_json" "data_governance" {
  json = file("dashboard_json/dataGovernance.json")
}

resource "newrelic_one_dashboard_json" "k6" {
  json = file("dashboard_json/k6.json")
}
