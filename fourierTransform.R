# 周波数 5Hz の正弦波を含むデータ
t <- seq(0,1, length.out = 32) # 時間軸（0から1秒まで）
freq <- 5                        # 5Hzの周波数
signal <- sin(2 * pi * freq * t) # 5Hzの正弦波信号

plot(t, signal, type = "l", col = "blue", main = "Original", ylab = "Signal")


# フーリエ変換を実行
fft_result <- fft(signal)

# 結果の表示
print(fft_result)

# 振幅スペクトルの計算
amplitude <- Mod(fft_result)

# 振幅スペクトルのプロット
plot(amplitude, type = "h", main = "Amplitude Spectrum", xlab = "Frequency", ylab = "Amplitude")

# 位相スペクトルの計算
phase <- Arg(fft_result)

# 位相スペクトルのプロット
plot(phase, type = "h", main = "Phase Spectrum", xlab = "Frequency", ylab = "Phase (radians)")


# フーリエ逆変換
inverse_fft <- fft(fft_result, inverse = TRUE) / length(fft_result)

# 元の信号との比較
plot(t, signal, type = "l", col = "blue", main = "Original and Inverse FFT Signal", ylab = "Signal")
lines(t, Re(inverse_fft), col = "red", lty = 2) # 再構築された信号
legend("topright", legend = c("Original Signal", "Inverse FFT Signal"), col = c("blue", "red"), lty = 1:2)
