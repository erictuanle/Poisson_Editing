# Poisson Seamless Cloning
*Algorithm coded from the lecture of Jean-Michel Morel (École normale supérieure de Cachan), and the article "Poisson Image Editing" (J. Matias Di Martino, Gabriele Facciolo & Enric Meinhardt-Llopis).*

[[Project]](https://medium.com/how-to-detect-digital-on-digital-image/introduction-seamless-copy-move-forgery-79280ee4c110)

## Poisson Image editing
The problem can be summarized as follow. Given an image **R**, we want to modify it on a small area **Ω**, a closed subset of **R²**, based on the information of another image.

<div style="text-align:center"> <img src="https://miro.medium.com/max/380/1*m-4ZnTZ6_--dgVC7haLlkQ.png" width=430> <div style="text-align:left">

Let’s take the example below where a plane needs to be placed from its original image (right image) to another one (left image). In order to do a seamless copy, one needs to make sure that the border of the moved element are not perceptible. A rough image edition will make inadequate color appears around the element (bottom image).

<div style="text-align:center"> <img src="https://miro.medium.com/max/1403/1*_YKL9ZghtE-nK6Dsk7RIVQ.png" width=600> <div style="text-align:left">

<div style="text-align:center"> <img src="https://miro.medium.com/max/3840/1*W64uGEGAoOgSsrdg8XpWmQ.png" width=600> <div style="text-align:left">

Some research studies on human vision draws the conclusion that we are more sensitive to the Laplacian rather than the image as a whole. The Poisson Equation is therefore the right framework to derive a seamless solution to this forgery problem. We know the Laplacian value inside the domain and the border values, which is enough to reconstruct the image.

Let’s note **b** the background image and **e** the image from which the element should be extracted: the resulting image is denoted **r**. The guidance vector field is given by:
<div style="text-align:center"> <img src="https://miro.medium.com/max/646/1*w8txr7yCvjtNBoRSbZIGJA.png" width=200> <div style="text-align:left">

Therefore, image edition boils down to the following minimization problem:
<div style="text-align:center"> <img src="https://miro.medium.com/max/486/1*ozPO4BMZK6VwJ7FEu7ci4w.png" width=200> <div style="text-align:left">

## Method
The method is composed of six successive steps:

* Compute the guidance field **V**:
  * Gradient field of the background image (Top left) and the guidance image(Top right)
  * Guidance field (Bottom)
<div style="text-align:center"> <img src="https://miro.medium.com/max/1736/1*iylAgTd72cyx_XuSK-yURQ.png" width=600> <div style="text-align:left">
<div style="text-align:center"> <img src="https://miro.medium.com/max/868/1*Wl_fFa0bhH7O45oLDyrbDA.png" width=600> <div style="text-align:left">

* Extend the image and the guidance field **V** to a larger image of four time the original size
<div style="text-align:center"> <img src="https://miro.medium.com/max/868/1*59U6sNg4t_T9rIWC7y4vZQ.png" width=600> <div style="text-align:left">

* Compute the Discrete Fourier Transform of the gradient field along the x-axis (Left) and the y-axis (Right)
<div style="text-align:center"> <img src="https://miro.medium.com/max/1534/1*GnGG8F4H2F4hK6M5TuaxFA.png" width=600> <div style="text-align:left">

* Compute the Discrete Fourier Transform of the solution of the problem
<div style="text-align:center"> <img src="https://miro.medium.com/max/732/1*Fbr5LYHFpV_ddkvibsNShQ.png" width=200> <div style="text-align:left">

<div style="text-align:center"> <img src="https://miro.medium.com/max/7680/1*EfG7v2e4nQRFrDhP_VTGHQ.png" width=600> <div style="text-align:left">

* Compute the inverse Fourier transform of the former image
<div style="text-align:center"> <img src="https://miro.medium.com/max/7680/1*yn_NMjaDER4Ckib78pz-nQ.png" width=600> <div style="text-align:left">

* Restrict the samples to the initial domain.
<div style="text-align:center"> <img src="https://miro.medium.com/max/3840/1*urL4PXYbGA-qQf3vq-cr-g.png" width=600> <div style="text-align:left">

* Apply a colour balance algorithm
<div style="text-align:center"> <img src="https://miro.medium.com/max/3840/1*KCqBasamKHARfH-otzx0TQ.jpeg" width=600> <div style="text-align:left">
