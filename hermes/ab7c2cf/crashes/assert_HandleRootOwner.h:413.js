h = {}
p = new Proxy({}, h)
h.__proto__ = p;
try { p._ } catch {}
