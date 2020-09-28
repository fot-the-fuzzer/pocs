function echo(m) {
    try {
        print(m);
    } catch (e) {
        console.log(m);
    }
}

function oos() {
    oos();
}

try {
    try {
        oos();
    } finally {
        try {
            oos();
        } catch (e) {
            echo("caught: " + e);
        } finally {
        }
    }
} catch (e) {
    if (e) {
        echo("pass");
    }
}
