--[[ROBLOX Content Downloader, version 1.0
Created by digpoe
This script allows you to download images, sounds and meshes and use them in game - without ROBLOX having to moderate them.

TUTORIAL ON HOW TO USE (WINDOWS Vista + 7):
IF LUA IS ALREADY INSTALLED, SKIP TO 2
1 First, you need to install Lua. This can be acomplished by going to 'www.lua.org' and downloading LuaForWindows from the Download page.
2 Second, you need to change the 'dir' variable to your ROBLOX installation. This can easily be done by opening up the Start Menu, pressing 'All Programs', finding 'Roblox' and then right clicking on 'Roblox Studio 2013' and pressing 'Properties'.
3 Copy the content of the 'Target' box but remove 'RobloxStudioLauncherBeta.exe -ide' from the copy when you copy it. Then, paste it in the dir variable. 
4 Replace all single \ characters with double \ characters - so if you had 'Roblox\Versions' it would become 'Roblox\\Versions'
5 Save and run the script. Your content should be downloaded. 

TUTORIAL ON ADDING CONTENTPACKS:
1 First, add a new file in the ContentPacks folder. It can be named anything, with any extension.
2 Second, open it up to edit it and add this base code to it:
'setfenv(1, {
})'

3 To add data to it, you want to add it in a format like this:
'["EntryName"]={"DownloadURL", "FileName", "FileExtension"};'
DownloadURL: the URL of the file that you're downloading
FileName: the name of the file once it's been downloaded.
FileExtension: the extension of the file (ex: .mp3, .wav, .mesh, .png) once it's been downloaded.

4 Save and close your new content pack. It should now be downloaded when you run the script.

Here's an example content pack. It doesn't download anything, so don't try it:

setfenv(1, {
["Hello!"]={"www.hostname.org", "Yay", "wav"};
["Goodbye!"]={"www.google.poop", "Nay", "mp3"};
})
]]
local http = require("socket.http")
local lfs = require("lfs")
local ltn12 = require("ltn12")
local dir = "%LocalAppData%\\Roblox\\Versions"

local files = {}

for file in lfs.dir(".\\ContentPacks") do
	if file ~= "." and file ~=".." then 
		local fil = io.open(".\\ContentPacks\\"..file, "r")
		if fil then fil = fil:read("*a") else print("File doesn't exist!") end
		local func = loadstring(fil)()
		local env = getfenv(func)
		for _, v in pairs(env) do table.insert(files, v) end
	end
end

local version = http.request("http://setup.roblox.com/version.txt")
print("ROBLOX Version: "..version)
for _, v in pairs(files) do
	local download, name, ftype = v[1], v[2], v[3]
	print("Downloading "..name.."."..ftype)
	local data, val, info = http.request(download)
	if data then
		local file = io.open(name.."."..ftype, "wb")
		file:write(data)
		file:close()
		if not os.execute("move "..name.."."..ftype.." "..dir.."\\"..version.."\\content") then 
			os.execute("del "..name.."."..ftype) 
			print("Error downloading: You don't have the right version!")
		end
	else
		print(("Error downloading! Value: %s Info: %s"):format(val, info))
	end
end
print("Finished downloading.")
os.execute("PAUSE")

