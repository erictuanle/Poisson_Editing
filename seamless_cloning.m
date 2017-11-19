function resulting_image = seamless_cloning(image_background,image_element,...
    image_omega,x0,y0)
%SEAMLESS_CLONING clones the element in image_element (definded by the area
%omega) in the image_background
%   ARGUMENTS:
%   	image_background: background image to place the element in
%       image_element: image containing the element to move on the background image
%       image_omega: image of the area where to pick the element in the
%           element image
%       x_omega: x coordinate where to place the element in the background image
%       y_omega: y coordinate where to place the element in the background image
%   OUTPUT:
%       resulting_image: resulting image

% Initialization of the images
image_background = im2double(image_background);
[n_rows_back,n_columns_back,n_colors_back] = size(image_background);
image_element = im2double(image_element);
[n_rows_element,n_columns_element,n_colors_element] = size(image_element);

% Initialization of the selection mask
image_omega = image_omega==max(image_omega(:));

% Replicating the input if not in RGB format
if n_colors_back==1
    image_background = cat(3,image_background,image_background,image_background);
    n_colors_back = 3;
end
if n_colors_element==1
    image_element = cat(3,image_element,image_element,image_element);
    n_colors_element = 3;
end
if size(image_omega,3)==1
    image_omega = cat(3,image_omega,image_omega,image_omega);
end

% Truncating the image if neededs
if (n_rows_back<n_rows_element) || (n_columns_back<n_columns_element)
    % Centering the element of interest
	[x,y] = meshgrid(1:n_rows_back,1:n_columns_back);
    omega_boolean = max(omega,3);
    xcoordinate_min = max(1,min(x(omega_boolean(:)==1))-3);
    ycoordinate_min = max(1,min(y(omega_boolean(:)==1))-3);
    image_element = circshift(image_element,round([1-xcoordinate_min,1-ycoordinate_min]));
    image_omega = circshift(image_omega,round([1-xcoordinate_min,1-ycoordinate_min]));
    % Truncating the element image and the area image
    image_element = image_element(1:min(n_rows_back,n_rows_element),1:min(n_columns_back,n_columns_element),:);
    image_omega = image_omega(1:min(n_rows_back,n_rows_element),1:min(n_columns_back,n_columns_element),:);
    [n_rows_element,n_columns_element,n_colors_element] = size(image_element);
end

% Changing the size of the element image and the area image to ensure that
% they have the same size as the background image
image_element_mod = zeros(n_rows_back,n_columns_back,n_colors_back);
image_omega_mod = zeros(n_rows_back,n_columns_back,n_colors_back);
omega_boolean = max(image_omega,[],3);
image_element_mod(1:n_rows_element,1:n_columns_element,:) = image_element;
image_omega_mod(1:n_rows_element,1:n_columns_element,:) = image_omega;
% Centering the element of interest
[x,y] = meshgrid(1:n_rows_element,1:n_columns_element);
x_center = mean(x(omega_boolean(:)==1));
y_center = mean(y(omega_boolean(:)==1));
image_element_mod = circshift(image_element_mod,round([x0-x_center,y0-y_center,0]));
image_omega_mod = circshift(image_omega_mod,round([x0-x_center,y0-y_center,0]));

% Computing the gradient field
[gradx_background,grady_background] = computes_gradient(image_background);
[gradx_element,grady_element] = computes_gradient(image_element_mod);
[gradx,grady] = mix_gradient(gradx_background, grady_background,...
    gradx_element, grady_element, image_omega_mod);

% Solving the Poisson equation
resulting_image = solve_poisson_equation(gradx,grady);
% Recovering the mean values of images
for color = 1:n_colors_back
    omega_color = image_omega_mod(:,:,color);
    % Outside omega area - Background image
    outside_omega_area_back = image_background(:,:,color).*(1-omega_color);
    mean_value_outside_omega_back = sum(outside_omega_area_back(:))/sum(1-omega_color(:));
    % Outside omega area - Element image
    outside_omega_area_element = image_element_mod(:,:,color).*(1-omega_color);
    mean_value_outside_omega_element = sum(outside_omega_area_element(:))/sum(1-omega_color(:));
    % Set the mean value,
    resulting_image(:,:,color) = resulting_image(:,:,color) - mean_value_outside_omega_element + mean_value_outside_omega_back;
end
