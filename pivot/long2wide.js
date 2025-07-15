var fso = new ActiveXObject("Scripting.FileSystemObject");

var args = WScript.Arguments;
var inputFile = args.length > 0 ? args(0) : "long.csv";
var outputFile = args.length > 1 ? args(1) : "wide.csv";

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
    var headers = {}; // store header name
    var dataMap = {}; // store data by id
    var result = [];

    // header: id, x, val
    for (var i = 1; i < rows.length; i++) {
        var cols = rows[i].split(",");
        var id = cols[0];
        var key = cols[1];
        var value = cols[2];

        if (!dataMap[id]) {
            dataMap[id] = {};
        }
        dataMap[id][key] = value;

        if (!headers[key]) {
            headers[key] = true;
        }
    }

    var headerRow = ["id"];
    for (var key in headers) {
        headerRow.push(key);
    }
    result.push(headerRow.join(","));

    // make row by id
    for (var id in dataMap) {
        var row = [id];
        for (var j = 1; j < headerRow.length; j++) {
            var colName = headerRow[j];
            row.push(dataMap[id][colName] || ""); // no value
        }
        result.push(row.join(","));
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
