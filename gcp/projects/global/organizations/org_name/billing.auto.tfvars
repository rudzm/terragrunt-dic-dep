default_notification_channels_email = [
  {
    email        = "user@example.com",
    display_name = "Big Brother is watching You"
  }
]

default_budget = {
  amount       = 2000,
  display_name = "Default budget",
  tresholds    = [0.8, 1.0]
}

projects_billing_alerts = {
  project-a = {
    notification_channels_email = [
      {
        email        = "user2@example.com",
        display_name = "notify owner: user2"
      }
    ],
    budget = {
      amount       = 1000,
      display_name = "",
      tresholds    = [0.7, 1.0]
    }
  },
  project-b = {
    budget = {
      amount       = 8000,
      display_name = "Project: apicall-metrics-179f",
      tresholds    = [0.8, 1.0]
    }
  },
}
