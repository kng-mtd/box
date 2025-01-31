// FileSystemObjectの作成
var fso = new ActiveXObject("Scripting.FileSystemObject");

// コマンドライン引数の処理
var args = WScript.Arguments;
var inputFile = args.length > 0 ? args(0) : "wide.csv";
var outputFile = args.length > 1 ? args(1) : "long.csv";

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

// 横持ちから縦持ちに変換
function transformCSV(inputData) {
    var rows = inputData;
    var headers = rows[0].split(","); // ヘッダー行を分割
    var result = ["id,x,val"]; // 出力用のヘッダー

    // 各行を処理
    for (var i = 1; i < rows.length; i++) {
        var cols = rows[i].split(",");
        var id = cols[0];
        for (var j = 1; j < cols.length; j++) {
            result.push(id + "," + headers[j] + "," + cols[j]);
        }
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
