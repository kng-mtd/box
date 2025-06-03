// FileSystemObject の作成
var fso = new ActiveXObject("Scripting.FileSystemObject");

// コマンドライン引数の処理
var args = WScript.Arguments;
var inputFile = args.length > 0 ? args(0) : "wide.csv";
var outputFile = args.length > 1 ? args(1) : "long.csv";

// 固定列のインデックス（0始まり、カンマ区切り）
var fixedIndexes = [];
if (args.length > 2) {
    var parts = args(2).split(",");
    for (var i = 0; i < parts.length; i++) {
        fixedIndexes.push(parseInt(parts[i], 10));
    }
} else {
    fixedIndexes = [0]; // デフォルトで最初の列（0番目）を固定
}

// includes の代替関数（JScriptに indexOf がないため）
function includes(arr, val) {
    for (var i = 0; i < arr.length; i++) {
        if (arr[i] === val) return true;
    }
    return false;
}

// CSVファイルの読み込み
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

// CSVファイルの書き込み
function writeCSV(filePath, data) {
    var file = fso.OpenTextFile(filePath, 2, true); // 2 = ForWriting, true = Create if not exists
    for (var i = 0; i < data.length; i++) {
        file.WriteLine(data[i]);
    }
    file.Close();
}

// 横持ちから縦持ちに変換
function transformCSV(inputData, fixedIndexes) {
    var rows = inputData;
    var headers = rows[0].split(",");
    var result = [];

    // 固定列ヘッダーの抽出
    var fixedHeaders = [];
    for (var i = 0; i < fixedIndexes.length; i++) {
        var idx = fixedIndexes[i];
        if (idx < 0 || idx >= headers.length) {
            throw new Error("Invalid column index: " + idx);
        }
        fixedHeaders.push(headers[idx]);
    }

    // 出力ヘッダー作成
    result.push(fixedHeaders.join(",") + ",x,val");

    // データ行の処理
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

// メイン処理
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
