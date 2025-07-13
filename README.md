# BlipBox
## Why Use This

I could not find a single thing that meets the following requirements, so decided to make my own:
1. Instant file transfer between your devices (Like AirDrop). No waiting on an upload before you can download.
2. A long file history to download files years after the initial P2P share.

#### BlipBox also has:

1. Support for sharing files across networks
2. Easily sharable download links
3. Very high file size limits: 20gb for files uploaded to the cloud, and unlimited file size without cloud uploads
4. A chat like interface with embed support (Discord)

## Required Setup
1. Download [Blip](https://blip.net/download) and the [BlipBox](https://github.com/Kn0tzer/BlipBox/releases) zip folder.
2. Sign in to Blip on at least 2 of your devices you'll be sharing files between
3. In Blip, go to settings > default save location. Pick an **empty** folder you want BlipBox to opperate in
4. Create a new [Discord](https://discord.com/app) server and go to Server Settings > Integrations > Create Webhook > Captain Hook > Copy Webhook URL
5. Extract BlipBox.zip and open the config.ini
6. In the config at the top, set discordWebook to the link you copied, and watchFolder to the path of the folder you selected in step 3
7. Run BlipBox.exe
Files you send from one device to another using blip that are under 200mb will now be automatically added to the folder you selected, uploaded to a file host, and shared to Discord. For files above 200mb, see the optional setup below

### Optional Setup
1. [Create a Pixeldrain account](https://pixeldrain.com/register), and [create a free api key](https://pixeldrain.com/user/api_keys)
2. Copy the api key and paste it after pixeldrainApiKey = in the config.ini file
3. If you want, customize the maxCatboxMB and maxPixelMB values. Descriptions for what they do are in the config
4. If you want, you can change the name and profile picture of your Discord server and webhook, along with your device names in the Blip app
5. If you want, create a shortcut to BlipBox.exe, and move the shortcut to C:\Users\your name\AppData\Roaming\Microsoft\Windows\Start Menu\Programs\Startup to have BlipBox automatically start with Windows

## How It Works
It starts with [AutoHotKey](https://www.autohotkey.com/), which runs the compiled BlipBox.exe script in the background.

To transfer a file, you either open the [Blip app](https://blip.net/) or share it to the Blip app. It's then transferred using p2p, and saved to a folder AutoHotKey is watching.

Once AutoHotKey detects an update in the folder, the file is uploaded to [Catbox](https://catbox.moe/) (If <200mb, infinite file storage) or [Pixeldrain](https://pixeldrain.com/) (>200mb, less than 20gb. 4 month file storage).

After the file is uploaded, Discord is contacted using a webhook. The download link is then sent in the Discord server you made, and if uploaded to Catbox, automatically embedded.
