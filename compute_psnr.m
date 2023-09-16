function psnr_value = compute_psnr(png1_path, png2_path)
    % Load PNG images
    img1 = imread(png1_path);
    img2 = imread(png2_path);

    % Ensure the images have the same size
    if size(img1) ~= size(img2)
        error('The two images have different sizes.');
    end

    % Calculate MSE (Mean Square Error)
    mse = mean((double(img1) - double(img2)).^2, 'all');

    % If MSE is zero, PSNR is set to a very high value (infinite theoretically)
    if mse == 0
        psnr_value = 100;  % You can also use Inf
        return;
    end

    % Compute PSNR
    max_pixel_value = 255.0;  % for 8-bit PNG images
    psnr_value = 20 * log10(max_pixel_value / sqrt(mse));
end

% Example usage:

