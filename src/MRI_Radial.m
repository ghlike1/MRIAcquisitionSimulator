
function [acq_img, mask] = MRI_Radial(img, lines, pointsperline, maskType, maskPercent)
    wb = waitbar(0,'Generating...');
    
    N1 = size(img);
    sampling = (N1(1)/pointsperline);
    N = N1(1)*3*sampling;
    I = zeros(N, N);
    I(1:N1(1), 1:N1(1)) = img;
    F = fftshift(fft2(I));

    waitbar(1/4)
    i=1;
    j=1;
    delT = lines;

    for r=-N/2:sampling:N/2
       for theta = 0:pi/delT:(pi-pi/delT)
           Rx(i, j) = r*cos(-theta)+ N/2;
           Ry(i, j) = r*sin(-theta)+ N/2;
           i = i+1;
       end
       j = j+1;
       i = 1;
    end
    waitbar(2/4)    

    Rv = interp2(F, Rx, Ry, 'bicubic');
    Rv(isnan(Rv)) = 0;

    S = size(Rv);
    maskedRv = zeros(S);
    mask = getMask(S, maskType, maskPercent);
    for i=1:1:S(1)
        for j=1:1:S(2)
            if mask(i,j) == 1
                maskedRv(i, j) = Rv(i,j);
            end
        end
    end

    waitbar(3/4)
    IR = zeros(size(maskedRv));
    
    for i = 1:delT
       IR(i, :) =fliplr(fftshift((abs(ifft((maskedRv(i, :))))))); 
    end

    recons = iradon(IR', 180/delT);
    recons = rot90(recons(16:N1+15, 16:N1+15),2);

    acq_img = recons;
    waitbar(4/4)
    close(wb)    
end