// for multi fixed column
// cscript wide2long2.js wide.csv long.csv 0,1 > column 0,1 is fixed


var fso = new ActiveXObject("Scripting.FileSystemObject");

var args = WScript.Arguments;
var inputFile = args.length > 0 ? args(0) : "wide.csv";
var outputFile = args.length > 1 ? args(1) : "long.csv";

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

function transformCSV(inputData, fixedIndexes) {
    var rows = inputData;
    var headers = rows[0].split(",");
    var result = [];

    // fixed column header
    var fixedHeaders = [];
    for (var i = 0; i < fixedIndexes.length; i++) {
        var idx = fixedIndexes[i];
        if (idx < 0 || idx >= headers.length) {
            throw new Error("Invalid column index: " + idx);
        }
        fixedHeaders.push(headers[idx]);
    }

    // new header
    result.push(fixedHeaders.join(",") + ",x,val");

    for (var i = 1; i < rows.length; i++) {
        var cols = rows[i].split(",");
        var fixedValues = [];
        for (var j = 0; j < fixedIndexes.length; j++) {
            fixedValues.push(cols[fixedIndexes[j]]);
        }

        for (var j = 0; j < cols.length; j++) {
            if (!includes(fixedIndexes, j)) {
                result.push(fixedValues.join(",") + "," + headers[j] + "," + cols[j]);
            }
        }
    }

    return result;
}

try {
    WScript.Echo("Input file: " + inputFile);
    WScript.Echo("Output file: " + outputFile);
    WScript.Echo("Fixed column indexes: " + fixedIndexes.join(","));

    var inputData = readCSV(inputFile);
    var outputData = transformCSV(inputData, fixedIndexes);
    writeCSV(outputFile, outputData);

    WScript.Echo("Converted successfully: " + outputFile);
} catch (e) {
    WScript.Echo("Error: " + e.message);
}
