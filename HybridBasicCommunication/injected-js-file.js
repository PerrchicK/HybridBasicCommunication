// some injected javascript section
function initClickReporters() {
    var result = "failed to listen...";
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
            foundImageTag.onclick = function() {
                report("clicked-on-image");
            };
        }

        result = "listening to image clicks";
    }

    if (buttonTags && buttonTags.length) {
        buttonTags[0].onclick = function() {
            report(document.getElementById("txtInput").value);
        };
        result += ", listening to button clicks";
    }

    return result;
}

function report(reportString) {
    document.location = "http://js-reporter/?" + reportString;
}

initClickReporters();
