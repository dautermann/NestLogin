# NestLogin
Sample app in Swift using the Nest Restful API

Demonstrates how to to get an authorization code (via a WebView) and exchange it for an access token that can be saved off.

If the access token already exists in user defaults (and isn't expired, which isn't likely, seeing as tokens seem to last for 20 years) then we go straight to the logged in screen that displays the token and it's expiration date.


