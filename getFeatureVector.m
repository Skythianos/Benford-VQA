function [output] = getFeatureVector(videoDataGray, videoDataRGB)
    [Gx,Gy,Gz] = imgradientxyz(videoDataGray);
    
    wdec = wavedec3(videoDataGray, 1, 'db1');
    
    HLL = wdec.dec{2};
    LHL = wdec.dec{3};
    HHL = wdec.dec{4};
    LLH = wdec.dec{5};
    HLH = wdec.dec{6};
    LHH = wdec.dec{7};
    HHH = wdec.dec{8};
        
    coeffs_fft = abs(fftn(videoDataGray));
        
    dct3 = mirt_dctn(videoDataGray);
               
    [S, ~, ~, ~] = hosvd(videoDataGray);
        
    output = [
        getFirstDigitDistribution(Gx), getFirstDigitDistribution(Gy),...
        getFirstDigitDistribution(Gz), ...
        getFirstDigitDistribution(HLL), getFirstDigitDistribution(LHL),...
        getFirstDigitDistribution(HHL), ...
        getFirstDigitDistribution(LLH), getFirstDigitDistribution(HLH),...
        getFirstDigitDistribution(LHH),...
        getFirstDigitDistribution(HHH), getFirstDigitDistribution(coeffs_fft),... 
        getFirstDigitDistribution(dct3), getFirstDigitDistribution(S), ...
        getPerceptualFeatures(videoDataRGB)];
    
end

