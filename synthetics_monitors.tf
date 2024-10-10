# List of monitors with names and URIs
variable "monitors" {
  type = list(object({
    name = string
    uri  = string
  }))
  default = [
    {
      name = "Google Search"
      uri  = "https://www.google.com"
    },
    {
      name = "Youtube"
      uri  = "https://www.youtube.com/"
      }, {
      name = "Facebook",
      uri  = "https://www.facebook.com"
    },
    {
      name = "Instagram",
      uri  = "https://www.instagram.com"
    },
    {
      name = "What's App",
      uri  = "https://www.whatsapp.com"
    },
    {
      name = "Twitter"
      uri  = "https://www.x.com"
    },
    {
      name = "Wikipedia"
      uri  = "https://www.wikipedia.org/"
      }, {
      name = "Yahoo!",
      uri  = "https://www.yahoo.com"
    },
    {
      name = "Reddit",
      uri  = "https://www.reddit.com"
    },
    {
      name = "Yahoo! Japan",
      uri  = "https://www.yahoo.co.jp"
    }
    # Add more monitors as needed
  ]
}

resource "newrelic_synthetics_monitor" "monitor" {
  for_each = { for idx, monitor in var.monitors : idx => monitor }

  status           = "ENABLED"
  name             = "${each.key + 1} - ${each.value.name} - Ping Monitor"
  period           = "EVERY_MINUTE"
  uri              = each.value.uri
  type             = "SIMPLE"
  locations_public = ["AP_SOUTH_1"]

  treat_redirect_as_failure = true
  validation_string         = "success"
  bypass_head_request       = true
  verify_ssl                = true

  tag {
    key    = "team"
    values = ["instinct", "yellow"]
  }

  tag {
    key    = "terraformManaged"
    values = ["true"]
  }
}


