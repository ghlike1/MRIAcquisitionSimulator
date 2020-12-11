function maskLayer = getMask(S, maskType, maskPercent)
    switch maskType 
        case 1
            maskLayer = ones(S);
            value = 0;
            if maskPercent > .9
                maskPercent = .9;
            end
            offset = round((min(S)/2) * (1-maskPercent));
            for i=1+offset:S(1)-offset
                for j=1+offset:S(2)-offset
                    maskLayer(i,j) = value;
                end
            end
        case 2
            radius = round(min(S)/2 * maskPercent);
            centerWidth = S(2)/2;
            centerHeight = S(1)/2;
            [Width,Height] = meshgrid(1:S(2),1:S(1));
            maskLayer = ((Width-centerWidth).^2 + (Height-centerHeight).^2) < radius^2;
        otherwise
            maskLayer = ones(S);
    end
end