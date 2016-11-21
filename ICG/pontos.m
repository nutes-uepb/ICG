    clear all;
    Fs = 500;    
        
        data_mod
        FiltrosADS
        filtros_uso
        
           
    ECG_f = ECG_2(end*0.2:end*0.8);
    ICG_f = ICG_1(floor(end*0.2:(end*0.8)));
    
    R_est = max(ECG_f(floor(end/4):floor(end*(3/4))));
    R_thr = R_est*.7;
    tam = length(deltZr);
    [pks, lcs] = findpeaks(ECG_f,1,'MinPeakHeight',R_thr);
    Z_resp = deltZr(floor(tam*0.2):floor(tam*0.8));
    
    %pontos C
    for n=1:length(lcs)-1
        delta_r(n) = floor(( lcs(n+1) - lcs(n))*0.4);
        pks_C(n) = max(ICG_f(lcs(n): lcs(n)+delta_r(n)));
        lcs_C(n) = lcs(n) + find(ICG_f(lcs(n): lcs(n)+delta_r(n)) == pks_C(n));
    end
    
    %Ponto X
    for n=1:length(lcs_C)-1
        delta_c(n) = floor(( lcs_C(n+1) - lcs_C(n))*0.3);
        val_X(n) = (-1)*(max((-1)*ICG_f(lcs_C(n): lcs_C(n)+delta_c(n))));
        lcs_X(n) = lcs_C(n) + find(ICG_f(lcs_C(n): lcs_C(n)+delta_c(n)) == val_X(n));
    end
    
    %Ponto B
    for n=1:length(lcs_C)-1
        delta_c(n) = floor(( lcs_C(n+1) - lcs_C(n))*0.3);
        [val_b, lcs_b] = findpeaks((-1*(ICG_f(lcs_C(n)-delta_c(n): lcs_C(n)))));
        lcs_B(n) = lcs_C(n) - delta_c(n) + max(lcs_b);
    end
    
    LV_tempo_ejecao = (lcs_X - lcs_B)./Fs;
    Frequencia_Cardiaca   = 60/(mean((lcs(2:end) - lcs(1:end-1)))./500)
    dZmax = pks_C;
    Distancia_Eletrodos = 25; %cm
    resistividade_sangue = 147; %ohm.cm de master thesis
    Impedancia_Basal = 30 ; %não consistente
    Volume_Sistolico = (resistividade_sangue*(Distancia_Eletrodos/Impedancia_Basal)^2) .* LV_tempo_ejecao .* dZmax(1:end-1);%LEM mL
    Volume_Sistolico_medio = mean(Volume_Sistolico)
    Volume_Sistolico = Volume_Sistolico*10^-3; % EM L
    Debito_Cardiaco = mean(Volume_Sistolico)*Frequencia_Cardiaca
    
    [pks_r, lcs_r] = findpeaks(Z_resp);
    Frequencia_Resp   = 60/(mean((lcs_r(2:end) - lcs_r(1:end-1)))./500)
    figure(1)
    plot(Z_resp);
    ylabel('Delta Z resp');
    hold on
    plot(lcs_r(1:end),pks_r(1:end), 'ro');
    
    
    figure(2)
    plot(ICG_f);
    ylabel('ICG');
    hold on
    plot(lcs_C(1:end),ICG_f(lcs_C(1:end)), 'ro');
    plot(lcs_X(1:end),ICG_f(lcs_X(1:end)), 'bo');
    plot(lcs_B(1:end),ICG_f(lcs_B(1:end)), 'go');
    
    
    
    %Área(m^2) = Raiz quadrada(Altura(cm) * Peso(kg) / 3600) - Albert Einstein Medical Suite
    height = 182;
    weight = 78;
    area = sqrt(height*weight/3600)
    Indice_Cardiaco = Debito_Cardiaco/area
    
    figure(3)
    plot(ECG_f);
    ylabel('ECG');
    hold on
    plot(lcs(1:end),ECG_f(lcs(1:end)), 'ro');
    
    DC = num2str(Debito_Cardiaco);
    FC = num2str(Frequencia_Cardiaca);
    RF = num2str(Frequencia_Resp);
    data = strcat(DC,'/',RF)
    t = tcpip('192.168.1.105', 3000,'NetworkRole', 'client');
    fopen(t)
    fwrite(t, data)
    
    
    
  