// FileSystemObjectの作成
var fso = new ActiveXObject("Scripting.FileSystemObject");

// コマンドライン引数の処理
var args = WScript.Arguments;
var inputFile = args.length > 0 ? args(0) : "long.csv";
var outputFile = args.length > 1 ? args(1) : "wide.csv";

// 固定列インデックスの取得（例: "0,1" → [0,1]）
var fixedIndexes = [];
if (args.length > 2) {
    var parts = args(2).split(",");
    for (var i = 0; i < parts.length; i++) {
        fixedIndexes.push(parseInt(parts[i], 10));
    }
} else {
    fixedIndexes = [0]; // デフォルト：最初の列だけ固定
}

// includes の代替関数（JScript向け）
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

// 縦持ちから横持ちに変換
function transformCSV(inputData) {
    var rows = inputData;
    var headers = rows[0].split(",");
    var dataMap = {}; // key: 固定列の値連結 → 動的列名 → 値
    var dynamicKeys = {}; // 動的列名（x）を記録
    var result = [];

    for (var i = 1; i < rows.length; i++) {
        var cols = rows[i].split(",");

        var fixedKeyParts = [];
        for (var j = 0; j < fixedIndexes.length; j++) {
            fixedKeyParts.push(cols[fixedIndexes[j]]);
        }
        var fixedKey = fixedKeyParts.join("|");

        var x = cols[fixedIndexes.length];    // 最初の動的列
        var val = cols[fixedIndexes.length + 1]; // 対応する値

        if (!dataMap[fixedKey]) {
            dataMap[fixedKey] = { __fixed: fixedKeyParts };
        }
        dataMap[fixedKey][x] = val;
        dynamicKeys[x] = true;
    }

    // 出力ヘッダー行の作成
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

    // データ行を作成
    for (var key in dataMap) {
        var row = [];
        var entry = dataMap[key];

        // 固定列
        for (var j = 0; j < fixedIndexes.length; j++) {
            row.push(entry.__fixed[j]);
        }

        // 動的列
        for (var j = 0; j < dynamicKeyList.length; j++) {
            var colName = dynamicKeyList[j];
            row.push(entry[colName] || "");
        }

        result.push(row.join(","));
    }

    return result;
}

// メイン処理
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
