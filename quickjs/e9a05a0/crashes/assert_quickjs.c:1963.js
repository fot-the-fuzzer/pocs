import * as os from "os"; 
var w = new os.Worker()
e = w.onmessage = function() { w }
