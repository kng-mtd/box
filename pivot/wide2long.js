// first column is fixed
// cscript wide2long.js wide.csv long.csv


var fso = new ActiveXObject("Scripting.FileSystemObject");

var args = WScript.Arguments;
var inputFile = args.length > 0 ? args(0) : "wide.csv";
var outputFile = args.length > 1 ? args(1) : "long.csv";

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
    var headers = rows[0].split(","); // split original header
    var result = ["id,x,val"]; // new header

    for (var i = 1; i < rows.length; i++) {
        var cols = rows[i].split(",");
        var id = cols[0];
        for (var j = 1; j < cols.length; j++) {
            result.push(id + "," + headers[j] + "," + cols[j]);
        }
    }

    return result;
}

try {
    WScript.Echo("input file: " + inputFile);
    WScript.Echo("output file: " + outputFile);

    var inputData = readCSV(inputFile);
    var outputData = transformCSV(inputData);
    writeCSV(outputFile, outputData);

    WScript.Echo("Converted: " + outputFile);
} catch (e) {
    WScript.Echo("Error: " + e.message);
}
