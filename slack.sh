#!/bin/bash

# Slack incoming web-hook URL and user name
url='CHANGEME'		# example: https://hooks.slack.com/services/QW3R7Y/D34DC0D3/BCADFGabcDEF123
username='Zabbix'

## Values received by this script:
# To = $1 (Slack channel or user to send the message to, specified in the Zabbix web interface; "@username" or "#channel")
# Subject = $2 (usually either PROBLEM or RECOVERY)
# Message = $3 (whatever message the Zabbix action sends, preferably something like "Zabbix server is unreachable for 5 minutes - Zabbix server (127.0.0.1)")

# Get the Slack channel or user ($1) and Zabbix subject ($2 - hopefully either PROBLEM or RECOVERY)
channel="$1"
subject="$2"
message="$3"

# Change message emoji depending on the subject - smile (RECOVERY), frowning (PROBLEM), or ghost (for everything else)
if [ "$subject" == 'RECOVERY' ]; then
    emoji=':black_circle:'
    color='good'
elif [ "$subject" == 'PROBLEM' ]; then
    emoji=':black_circle:'
    color='danger'
else
    emoji=':ghost:'
    color='warning'
fi

# Build our JSON payload and send it as a POST request to the Slack incoming web-hook URL
payload="payload={
  \"channel\": \"${channel}\",
  \"username\": \"${username}\",
  \"icon_emoji\": \"${emoji}\",
  \"attachments\": [
    {
      \"fallback\": \"${message}\",
      \"color\": \"${color}\",
      \"title\": \"${subject}\",
      \"text\": \"${message}\"
    }
  ]
}"

#echo $payload
curl -m 5 --data-urlencode "${payload}" $url -A 'zabbix-slack-alertscript'


