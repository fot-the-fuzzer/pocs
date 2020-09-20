s = {
    next: function() {
        i.throw()
    }
}

t = {}
t[Symbol.iterator] = function() {
    return s
}

function* g() {
    yield* t
}

var i = g()
i.next()
