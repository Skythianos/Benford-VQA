function [output] = getContrast(img)
    img = im2double(img);
    if(size(img,3)==3)
        img=rgb2gray(img);
    end
    output=std(img(:));
end

