function [gradx, grady] = mix_gradient(gradx_background, grady_background,...
    gradx_element, grady_element, omega)
%MIX_GRADIENT aims at computing the gradient field by composing the
%gradient of the background image with the gradient of the element to
%extract
%   ARGUMENTS:
%   	gradx_background: gradient along x-axis of the background image
%   	grady_background: gradient along y-axis of the background image
%   	gradx_element: gradient along x-axis of the element image
%   	grady_element: gradient along y-axis of the element image
%   	omega: area where the element needs to be extracted from the
%           element image
%   OUTPUT:
%       gradx: resulting gradient field along x-axis
%       grady: resulting gradient field along y-axis

% Building the area (omega U d_omega)
area = padarray(omega,[1 1],0,'both');
area = circshift(area,[1 0]) | circshift(area,[-1 0]) ...
  | circshift(area,[0 1]) | circshift(area,[0 -1]);
area = area(2:end-1,2:end-1,:);

% Initialization
gradx = gradx_background;
grady = grady_background;

% Replacing the gradient field on Omega
condition_area = area==1;
gradx(condition_area) = gradx_element(condition_area);
grady(condition_area) = grady_element(condition_area);