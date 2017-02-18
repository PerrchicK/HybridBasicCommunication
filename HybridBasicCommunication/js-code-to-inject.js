function injectOnClickReporters() {
    var result = null;
    var imageTags = document.getElementsByTagName("img");
    var buttonTags = document.getElementsByTagName("button");

    if (imageTags && imageTags.length) {
        var foundImageTag = null;
        for (var i = 0; i < imageTags.length; i++) {
            if ((imageTags[i].getAttribute("alt")) == "lovely pic") {
                foundImageTag = imageTags[i];
            }
        }

        if (foundImageTag) {
            // "swizzle" methods to maintain the previous behaviour
            foundImageTag.onclick = swizzleAndMaintain(foundImageTag.onclick, function() {
                                                       report("clicked-on-image");
                                                       });
            result = "listening to image clicks";
        }
    }

    if (buttonTags && buttonTags.length) {
        // "swizzle" methods to maintain the previous behaviour
        var oldFunc = buttonTags[0].onclick;
        buttonTags[0].onclick = swizzleAndMaintain(buttonTags[0].onclick, function() {
                                                   report(document.getElementById("txtInput").value);
                                                   });
        result += ", listening to button clicks";
    }

    if (result) {
        report("I'm in...");
    } else {
        result = "failed to listen...";
    }

    return result;
}

var jsReporterPrefix = "perrchick://js-reporter/?";

function report(reportString) {
    document.location = jsReporterPrefix + reportString;
}

// To avoid harm on the expected behaviour
function swizzleAndMaintain(oldFunc, newFunc) {
    // guard-like (from Swift)
    if (!newFunc) { return oldFunc }
    if (!oldFunc) { return newFunc }

    return function() {
        newFunc();
        if (oldFunc) oldFunc();
    };
}

injectOnClickReporters();
