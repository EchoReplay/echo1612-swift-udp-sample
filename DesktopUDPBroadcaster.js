(function() {
  var arrayRemoveDuplicates, dgram, getServerIps, isRecording, os, serversToCheck, settings, setupMulticast, uploadLabel;

  dgram = require('dgram');

  os = require('os');

  settings = {};

  settings.serverport = settings.webport = "1612";

  serversToCheck = {};

  isRecording = false;

  uploadLabel = new Date().getTime();

  setupMulticast = function() {
    var udp;
    udp = dgram.createSocket('udp4');
    udp.bind(settings.serverport);
    return setInterval(function() {
      var i, ip, len, message, results, serverIps;
      serverIps = getServerIps();
      results = [];
      for (i = 0, len = serverIps.length; i < len; i++) {
        ip = serverIps[i];
        message = new Buffer("{\"description\": \"" + (os.hostname()) + "\", \"server\":\"" + ip + "\", \"webport\":\"" + settings.webport + "\", \"status\":\"" + isRecording + "\", \"primary\":\"" + false + "\", \"id\":\"" + uploadLabel + "\"}");
        results.push(udp.send(message, 0, message.length, settings.serverport, '224.0.0.1', function(err, bytes) {}));
      }
      return results;
    }, 3000);
  };

  getServerIps = function() {
    var addresses, device, devicekey, devicevalue, i, ips, key, len, ref, ref1, value;
    ips = [];
    addresses = [];
    ref = os.networkInterfaces();
    for (devicekey in ref) {
      devicevalue = ref[devicekey];
      ips.push(devicekey);
      for (i = 0, len = ips.length; i < len; i++) {
        device = ips[i];
        ref1 = os.networkInterfaces()[device];
        for (key in ref1) {
          value = ref1[key];
          if (value.family === "IPv4" && value.address !== "127.0.0.1") {
            addresses.push(value.address);
          }
        }
      }
    }
    return arrayRemoveDuplicates(addresses);
  };

  arrayRemoveDuplicates = function(a, b, c) {
    if (a.length > 0) {
      b = a.length;
      while (c = --b) {
        while (c--) {
          a[b] !== a[c] || a.splice(c, 1);
        }
      }
    }
    return a;
  };

  setupMulticast();

}).call(this);
