var p = new Proxy({}, {});
p.__proto__ = p;
try { p.__proto__; } catch(e) {}
