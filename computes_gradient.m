function [gradx, grady] = computes_gradient(image)
%COMPUTES_GRADIENT aims at computing the gradient by the Fourier method of 
%the image passed in arguement
%   ARGUMENTS:
%   	image: image to compute the gradient
%   OUTPUT:
%       gradx: gradient along x-axis of the image passed in argument
%       grady: gradient along y-axis of the image passed in argument

% Initialization
[n_rows,n_columns,n_colors] = size(image);
gradx = zeros(n_rows,n_columns,n_colors);
grady = zeros(n_rows,n_columns,n_colors);

% Extending the image by symmetrization
image = [image,image(:,end:-1:1,:);
    image(end:-1:1,:,:),image(end:-1:1,end:-1:1,:)];

% Looping for each colors dimension of the oriignal image
[frequencies_x,frequencies_y] = meshgrid(1:2*n_columns,1:2*n_rows);
frequencies_x = frequencies_x - (n_columns+1);
frequencies_y = frequencies_y - (n_rows+1);
for color = 1:n_colors
    % % Computing the DFT of each components
    dft = fftshift(fft2(image(:,:,color)));
    % Computing the coefficients
    gradx_fourier = (2*pi*1i/(2*n_columns)*frequencies_x).*dft;
    grady_fourier = (2*pi*1i/(2*n_rows)*frequencies_y).*dft;
    % Compute the inverse DFT
    gradx_color = real(ifft2(ifftshift(gradx_fourier)));
    grady_color = real(ifft2(ifftshift(grady_fourier)));
    % Restricting the solution to the original domain
    gradx(:,:,color) = gradx_color(1:n_rows,1:n_columns);
    grady(:,:,color) = grady_color(1:n_rows,1:n_columns);
end
