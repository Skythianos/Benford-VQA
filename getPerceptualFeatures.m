function [output] = getPerceptualFeatures(videoDataRGB)
    
    numberOfFrames = size(videoDataRGB,2);
    BLUR = zeros(1,numberOfFrames);
    CF  = zeros(1,numberOfFrames);
    GCF = zeros(1,numberOfFrames);
    DCF = zeros(1,numberOfFrames);
    Ent = zeros(1,numberOfFrames);
    PC  = zeros(1,numberOfFrames);
    SI  = zeros(1,numberOfFrames);
    TI  = zeros(1,numberOfFrames-1);
    NIQE = zeros(1,numberOfFrames);
    for i=1:numberOfFrames
        frame = videoDataRGB{i};
        BLUR(i) = blurMetric(rgb2gray(frame));
        CF(i) = getColorfulness(frame);
        GCF(i)= getContrast(frame);
        DCF(i)= getDarkChannelFeature(frame);
        Ent(i)= entropy(frame);
        P = getPhaseCongruencyImage(frame);
        PC(i) = mean(P(:));
        [Gmag,~] = imgradient(rgb2gray(frame),'sobel');
        SI(i) = std(Gmag(:));
        if(i<numberOfFrames)
            frame2 = im2double(videoDataRGB{i+1});
            diff = frame2 - im2double(frame);
            TI(i)= std(diff(:));
        end
        NIQE(i) = niqe(frame);
    end
    output = [mean(BLUR(:)), mean(CF(:)), mean(GCF(:)), mean(DCF(:)), mean(Ent(:)),...
        mean(PC(:)), mean(SI(:)), mean(TI(:)), mean(NIQE(:))];
end

