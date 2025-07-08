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
1. Download [Blip](https://blip.net/download) and BlipBox
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

## How it works
BlipBox combines 5 already existing services: [AutoHotKey](https://www.autohotkey.com/), [Blip](https://blip.net/), [Discord](https://discord.com), [Catbox](https://catbox.moe/), and [Pixeldrain](https://pixeldrain.com/).

### [AutoHotKey](https://www.autohotkey.com/)
BlipBox itself is written in AutoHotKey, a fast, windows only scripting language, with good built in logging, and almost no boilerplate.

### [Blip](https://blip.net/)
Blip is the core of the p2p side of BlipBox. Blip allows for Airdrop like functionality across nearly all platforms, is fast, easy to setup, and supports file transfer across all networks.

### [Discord](https://discord.com)
Discord is used as the ui for BlipBox. It's cross platform, commonly used, supports webhooks, and as far as I can tell, the best, easiest option for this use case.

### [Catbox](https://catbox.moe/)
Catbox is the main file host for BlipBox. Files are stored "until the heat death of the universe", with a very reasonable 200mb file size limit, along with hotlink support which allows for Discord embedding.

### [Pixeldrain](https://pixeldrain.com/)
Pixeldrain is used as the backup host when files are too large to be stored on Catbox. Pixeldrain allows 6gb of downloading at full speed per day. Any more is limited to 1 mb/s. It's file size limit is 20gb on the free plan, and files expire after 4 months.

### The workflow
It starts with AutoHotKey, which runs the compiled BlipBox script continuously in the background, using less than 0.1% cpu usage.

Then, whenever you want to transfer a file, you either open the Blip app, share it using any share button, or use the right click menu. It's then transferred over p2p, and saved to a folder AutoHotKey is watching for updates.

Once a change in the Blip folder is detected, the file is uploaded to catbox or pixeldrain using their api. The host is chosen depending on file size, which is customizable in the config. Catbox is generally preferred.

After the file has been successfully uploaded, Discord is contacted using a webhook. The link to the file download is sent in a message in the Discord server you made, and if uploaded to Catbox, automatically embedded.

### Sidenotes
If your looking for something even easier to use, but less powerful, check out [Wormhole.app](https://wormhole.app/)

If you have any suggestions for a better replacement for Discord, Catbox, Pixeldrain, or really anything, please create an issue