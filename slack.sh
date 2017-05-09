#!/bin/bash

# Slack incoming web-hook URL and user name
url='CHANGEME'		# example: https://hooks.slack.com/services/QW3R7Y/D34DC0D3/BCADFGabcDEF123
username='Zabbix'

# Get the Slack channel or user ($1) and Zabbix subject ($2 - hopefully either PROBLEM or RECOVERY)
channel="$1"
subject="$2"

# Change message emoji depending on the subject - smile (RECOVERY), frowning (PROBLEM), or ghost (for everything else)
if [ "$subject" == 'RECOVERY' ]; then
    emoji=':large_blue_circle:'
    color='good'
elif [ "$subject" == 'PROBLEM' ]; then
    emoji=':red_circle:'
    color='danger'
else
    emoji=':ghost:'
    color='warning'
fi

# The message that we want to send to Slack is the "subject" value ($2 / $subject - that we got earlier)
#  followed by the message that Zabbix actually sent us ($3)
message="${subject}: $3"

# Build our JSON payload and send it as a POST request to the Slack incoming web-hook URL
payload="payload={
  \"channel\": \"${channel}\",
  \"username\": \"${username}\",
  \"icon_emoji\": \"${emoji}\",
  \"text\": \"${message}\",
  \"attachements\": [
    {
      \"color\": \"${color}\"
    }
  ]
}"
#payload="payload={\"channel\": \"${to//\"/\\\"}\", \"username\": \"${username//\"/\\\"}\", \"text\": \"${message//\"/\\\"}\", \"icon_emoji\": \"${emoji}\"}"
curl -m 5 --data-urlencode "${payload}" $url -A 'zabbix-slack-alertscript'
