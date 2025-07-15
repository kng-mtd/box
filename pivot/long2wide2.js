var fso = new ActiveXObject("Scripting.FileSystemObject");

var args = WScript.Arguments;
var inputFile = args.length > 0 ? args(0) : "long.csv";
var outputFile = args.length > 1 ? args(1) : "wide.csv";

var fixedIndexes = [];
if (args.length > 2) {
    var parts = args(2).split(",");
    for (var i = 0; i < parts.length; i++) {
        fixedIndexes.push(parseInt(parts[i], 10));
    }
} else {
    fixedIndexes = [0]; // first column is fixed as defalut
}

function includes(arr, val) {
    for (var i = 0; i < arr.length; i++) {
        if (arr[i] === val) return true;
    }
    return false;
}

function readCSV(filePath) {
    if (!fso.FileExists(filePath)) {
        throw new Error("Not found the file: " + filePath);
    }
    var file = fso.OpenTextFile(filePath, 1); // 1 = ForReading
    var data = [];
    while (!file.AtEndOfStream) {
        data.push(file.ReadLine());
    }
    file.Close();
    return data;
}

function writeCSV(filePath, data) {
    var file = fso.OpenTextFile(filePath, 2, true); // 2 = ForWriting, true = Create if not exists
    for (var i = 0; i < data.length; i++) {
        file.WriteLine(data[i]);
    }
    file.Close();
}

function transformCSV(inputData) {
    var rows = inputData;
    var headers = rows[0].split(",");
    var dataMap = {}; 
    var dynamicKeys = {};
    var result = [];

    for (var i = 1; i < rows.length; i++) {
        var cols = rows[i].split(",");

        var fixedKeyParts = [];
        for (var j = 0; j < fixedIndexes.length; j++) {
            fixedKeyParts.push(cols[fixedIndexes[j]]);
        }
        var fixedKey = fixedKeyParts.join("|");

        var x = cols[fixedIndexes.length];
        var val = cols[fixedIndexes.length + 1];

        if (!dataMap[fixedKey]) {
            dataMap[fixedKey] = { __fixed: fixedKeyParts };
        }
        dataMap[fixedKey][x] = val;
        dynamicKeys[x] = true;
    }

    // make new header
    var dynamicKeyList = [];
    for (var k in dynamicKeys) {
        dynamicKeyList.push(k);
    }

    var headerRow = [];
    for (var j = 0; j < fixedIndexes.length; j++) {
        headerRow.push(headers[fixedIndexes[j]]);
    }
    for (var j = 0; j < dynamicKeyList.length; j++) {
        headerRow.push(dynamicKeyList[j]);
    }
    result.push(headerRow.join(","));

    // make row
    for (var key in dataMap) {
        var row = [];
        var entry = dataMap[key];

        // fixed column
        for (var j = 0; j < fixedIndexes.length; j++) {
            row.push(entry.__fixed[j]);
        }

        // dynamic column
        for (var j = 0; j < dynamicKeyList.length; j++) {
            var colName = dynamicKeyList[j];
            row.push(entry[colName] || "");
        }

        result.push(row.join(","));
    }

    return result;
}

try {
    WScript.Echo("Input file: " + inputFile);
    WScript.Echo("Output file: " + outputFile);
    WScript.Echo("Fixed column indexes: " + fixedIndexes.join(","));

    var inputData = readCSV(inputFile);
    var outputData = transformCSV(inputData);
    writeCSV(outputFile, outputData);

    WScript.Echo("Converted: " + outputFile);
} catch (e) {
    WScript.Echo("Error: " + e.message);
}
