p = new Proxy({}, {});
p.__proto__ = p
Reflect.has(p)
