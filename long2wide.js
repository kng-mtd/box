// FileSystemObjectの作成
var fso = new ActiveXObject("Scripting.FileSystemObject");

// コマンドライン引数の処理
var args = WScript.Arguments;
var inputFile = args.length > 0 ? args(0) : "long.csv";
var outputFile = args.length > 1 ? args(1) : "wide.csv";

// CSVファイルの読み込み
function readCSV(filePath) {
    if (!fso.FileExists(filePath)) {
        throw new Error("指定された入力ファイルが見つかりません: " + filePath);
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
    var headers = {}; // 動的にヘッダーを収集
    var dataMap = {}; // idごとのデータを保持
    var result = [];

    // 1行目はヘッダー: id, x, val
    for (var i = 1; i < rows.length; i++) {
        var cols = rows[i].split(",");
        var id = cols[0];
        var key = cols[1];
        var value = cols[2];

        // データをマッピング
        if (!dataMap[id]) {
            dataMap[id] = {};
        }
        dataMap[id][key] = value;

        // ヘッダーを記録
        if (!headers[key]) {
            headers[key] = true;
        }
    }

    // ヘッダー行の作成
    var headerRow = ["id"];
    for (var key in headers) {
        headerRow.push(key);
    }
    result.push(headerRow.join(","));

    // 各idごとのデータ行を作成
    for (var id in dataMap) {
        var row = [id];
        for (var j = 1; j < headerRow.length; j++) {
            var colName = headerRow[j];
            row.push(dataMap[id][colName] || ""); // 値が存在しない場合は空文字
        }
        result.push(row.join(","));
    }

    return result;
}

// メイン処理
try {
    WScript.Echo("入力ファイル: " + inputFile);
    WScript.Echo("出力ファイル: " + outputFile);

    var inputData = readCSV(inputFile);
    var outputData = transformCSV(inputData);
    writeCSV(outputFile, outputData);

    WScript.Echo("変換が完了しました。出力ファイル: " + outputFile);
} catch (e) {
    WScript.Echo("エラーが発生しました: " + e.message);
}
