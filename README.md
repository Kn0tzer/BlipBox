# BlipBox
## Why Use This

I could not find a single thing that meets the following requirements, so decided to make my own:
1. Instant file transfer between your devices (Like AirDrop). No waiting on an upload before you can download.
2. A long file history to download files months after the initial P2P share

### Not only does BlipBox do this, but also much more no other service offers:

3. Support for sharing files across networks
4. Easily sharable file download links
5. Very high file size limits: 20gb for files uploaded to the cloud, unlimited file size without cloud uploads
6. Easy to setup: Only 7 required steps
7. Cross platform: Windows (Required), Mac, iOS, Android, and soon Linux
8. A chat like interface with a good ui and embeds common file extensions
9. Not bloated. This repository has **less than 150 lines of code**, the rest is offloaded on to services you already use
10. Not self hosted, doesn't eat your storage, and uses less than 0.1% cpu when not uploading
11. Free and open source. Forever.

## How it works

## Required Setup
1. Download AutoHotKey v1, this .ahk file, and Blip.
2. Sign in to Blip on at least 2 of your devices you'll be sharing files between.
3. In Blip, go to settings > default save location. Pick an **empty** folder you want BlipBox to opperate in.
4. Create a new Discord server and go to Server Settings > Integrations > Create Webhook > Captain Hook > Copy Webhook URL
5. Right click on the .ahk file you downloaded and select edit.
6. In the config at the top, set discordWebook to the link you copied, and watchFolder to the same folder you select in step 5.
7. Open the .ahk file in AutoHotKey
Files you send from one device to another using blip will now be automatically added to the folder you selected, uploaded to a file host, and shared to Discord.

## 
