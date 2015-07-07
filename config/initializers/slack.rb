require 'slack/post'

webhook_url = ENV['SLACK_WEBHOOK_URL']

unless webhook_url.blank?
  Slack::Post.configure(
    webhook_url: webhook_url,
    username: 'EA Pong'
  )
end

