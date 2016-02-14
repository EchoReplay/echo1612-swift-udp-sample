dgram       = require('dgram')
os          = require('os')
settings = {}
settings.serverport = settings.webport = "1612"
serversToCheck = {}
isRecording = false
uploadLabel = new Date().getTime()

setupMulticast = ->
  udp = dgram.createSocket 'udp4'
  udp.bind settings.serverport
  setInterval ->
    serverIps = getServerIps()
    for ip in serverIps
      message = new Buffer("{\"description\": \"#{os.hostname()}\", \"server\":\"#{ip}\", \"webport\":\"#{settings.webport}\", \"status\":\"#{isRecording}\", \"primary\":\"#{false}\", \"id\":\"#{uploadLabel}\"}")
      udp.send message, 0, message.length, settings.serverport, '224.0.0.1', (err, bytes) ->
  , 3000

getServerIps = ->
  ips = []
  addresses = []
  for devicekey, devicevalue of os.networkInterfaces()
    ips.push devicekey
    for device in ips
      for key, value of os.networkInterfaces()[device]
        if value.family == "IPv4" and value.address != "127.0.0.1"
          addresses.push value.address
  return arrayRemoveDuplicates(addresses)

arrayRemoveDuplicates = (a,b,c) -> #array,placeholder,placeholder
  if a.length > 0
    b = a.length
    while c = --b
      while c--
        a[b] != a[c] or a.splice(c, 1)
  a

setupMulticast()
