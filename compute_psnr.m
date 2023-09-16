save_psnr_to_txt1('BasketballDrill_832x480_50.yuv', 'output_420.yuv', 832, 480, 5);

function save_psnr_to_txt1(yuvFile1, yuvFile2, width, height, numFrames)
    % Open the YUV files
    fid1 = fopen(yuvFile1, 'r');
    fid2 = fopen(yuvFile2, 'r');

    psnr_Y_vals = zeros(1, numFrames);
    psnr_U_vals = zeros(1, numFrames);
    psnr_V_vals = zeros(1, numFrames);
    psnr_total_vals = zeros(1, numFrames);

    for i = 1:numFrames
        % Read Y channel
        Y1 = fread(fid1, [width, height], 'uint8')';
        Y2 = fread(fid2, [width, height], 'uint8')';

        % Read U channel
        U1 = fread(fid1, [width/2, height/2], 'uint8')';
        U2 = fread(fid2, [width/2, height/2], 'uint8')';

        % Read V channel
        V1 = fread(fid1, [width/2, height/2], 'uint8')';
        V2 = fread(fid2, [width/2, height/2], 'uint8')';

        % Compute PSNR for each channel
        psnr_Y_vals(i) = 10 * log10(255^2 / immse(Y1, Y2));
        psnr_U_vals(i) = 10 * log10(255^2 / immse(U1, U2));
        psnr_V_vals(i) = 10 * log10(255^2 / immse(V1, V2));

        % Compute total PSNR for the frame
        totalPixels_Y = width * height;
        totalPixels_UV = (width/2) * (height/2);
        mse_total_frame = (immse(Y1, Y2) * totalPixels_Y + immse(U1, U2) * totalPixels_UV + immse(V1, V2) * totalPixels_UV) / (totalPixels_Y + 2 * totalPixels_UV);
        psnr_total_vals(i) = 10 * log10(255^2 / mse_total_frame);
    end

    fclose(fid1);
    fclose(fid2);

    % Save to txt file
    timestamp = datestr(now,'yyyy_mm_dd_HH_MM_SS');
    filename = ['PSNR_Comparison_' timestamp '.txt'];
    fid = fopen(filename, 'w');
    fprintf(fid, 'Comparison between %s and %s\n\n', yuvFile1, yuvFile2);
    
    % Write PSNR values for each frame
    for i = 1:numFrames
        fprintf(fid, 'Frame %d:\n', i);
        fprintf(fid, 'PSNR Y: %f\n', psnr_Y_vals(i));
        fprintf(fid, 'PSNR U: %f\n', psnr_U_vals(i));
        fprintf(fid, 'PSNR V: %f\n', psnr_V_vals(i));
        fprintf(fid, 'Total PSNR: %f\n\n', psnr_total_vals(i));
    end

    % Write average PSNR values
    fprintf(fid, '-------------------------------------\n');
    fprintf(fid, 'Average PSNR Y: %f\n', mean(psnr_Y_vals));
    fprintf(fid, 'Average PSNR U: %f\n', mean(psnr_U_vals));
    fprintf(fid, 'Average PSNR V: %f\n', mean(psnr_V_vals));
    fprintf(fid, 'Average Total PSNR: %f\n', mean(psnr_total_vals));
    fclose(fid);
end
