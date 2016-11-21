    

    % ECG
    ECG_1 = filtfilt(n_DC, d_DC, ECG);
    ECG_2 = filtfilt(n_067_40, d_067_40, ECG_1);
          
    % ICG
    I = 28* 10^-6;
    Z = Z/I;
    Z0 = mean((Z));
    deltZc = Z - Z0;
    deltZc = HP08(LP8(notch60(deltZc)));
    ICG_1 = diff(deltZc)/(1/500);

    % Resp
    deltZr = HP01(LP05(Z));
