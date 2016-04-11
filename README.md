# StatusPageIOSampleApp

Sample App that reads the URL of a StatusPageIO customer and presents the information in an easy to read format for use on an iOS platform.

![Alt text](SampleImage.png?raw=true "Sample Summary Page")

## Background
A lot of companies use StatusPageIO (https://www.statuspage.io) to host and present status information on Servers, platforms, API's and other services used by a lot of consumers. 
Several examples of customers are: 
Twilio - http://status.twilio.com
Bitbucket - http://status.bitbucket.org
KickStarter - http://status.kickstarter.com
Cloudflare - https://www.cloudflarestatus.com

All of these pages have a few things in common; 

1) They all have an API Page, eg:
Twilio - http://status.twilio.com/api
Bitbucket - http://status.bitbucket.org/api
KickStarter - http://status.kickstarter.com/api
Cloudflare- https://www.cloudflarestatus.com/api

2) The format for accessing this API data is all the same, with a reference key for each company, eg: 
Twilio - http://gpkpyklzq55q.statuspage.io/api/v2/summary.json
Bitbucket - http://bqlf8qjztdtr.statuspage.io/api/v2/summary.json
KickStarter - http://4p1vb67yqzdy.statuspage.io/api/v2/summary.json
Cloudflare - https://yh6f0r4529hb.statuspage.io/api/v2/summary.json

So the base URL is : https://CompanyKey.statuspage.io/api/v2/summary.json
Where CompanyKey is the reference key to that company. 

## Sample App
Sample App reads three endpoints;
Summary - https://CompanyKey.statuspage.io/api/v2/summary.json
Unresolved incidents - http://CompanyKey.statuspage.io/api/v2/incidents/unresolved.json
All incidents - http://CompanyKey.statuspage.io/api/v2/incidents.json

## Extras
If the company has enabled WebHooks (within StatusPageIO), you can use a 3rd party server to host a DB and endpoint that StatusPageIO will make a request to when they make a change to the state of the platform.
From this you can use APNS to push out an update to your end users alerting them to a change in the status of the platform.
