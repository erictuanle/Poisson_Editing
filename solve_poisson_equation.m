function resulting_image = solve_poisson_equation(gradient_x,gradient_y)
%SOLVE_POISSON_EQUATION solve the Poisson equation with Neuman Border
%   ARGUMENTS:
%   	gradient_x: gradient map (partial derivative) on x-axis
%       gradient_y: gradient map (partial derivative) on y-axis
%   OUTPUT:
%       I: solution of the Poisson Equation

% Computing the size of gradient_x (same as gradient_y)
[n_rows,n_columns,n_colors] = size(gradient_x);

% Initialization of the resulting image
resulting_image = zeros(n_rows,n_columns,n_colors);

% Extending the gradient field of V by symmetrization to W
gradient_x = [gradient_x,-gradient_x(:,end:-1:1,:); 
    gradient_x(end:-1:1,:,:),-gradient_x(end:-1:1,end:-1:1,:)];
gradient_y = [gradient_y,-gradient_y(:,end:-1:1,:); 
    gradient_y(end:-1:1,:,:),-gradient_y(end:-1:1,end:-1:1,:)];

% Looping for each colors dimension of the oriignal image
[frequencies_x,frequencies_y] = meshgrid(1:2*n_columns,1:2*n_rows);
frequencies_x = frequencies_x - (n_columns+1);
frequencies_y = frequencies_y - (n_rows+1);
for color = 1:n_colors
    % Computing the DFT of each components of W
    dft_x = fftshift(fft2(gradient_x(:,:,color)));
    dft_y = fftshift(fft2(gradient_y(:,:,color)));
    % Computing the coefficients of the solution
    coefficients_dft = ((2*pi*1i/(2*n_columns)*frequencies_x).*dft_x+(2*pi*1i/(2*n_rows)*frequencies_y).*dft_y)./...
        ((2*pi*1i/(2*n_columns)*frequencies_x).^2+(2*pi*1i/(2*n_rows)*frequencies_y).^2);
    coefficients_dft((n_rows+1),(n_columns+1)) = 0;
    % Compute the inverse DFT
    resulting_image_color = real(ifft2(ifftshift(coefficients_dft)));
    % Restricting the solution to the original domain
    resulting_image(:,:,color) = resulting_image_color(1:n_rows,1:n_columns);
end