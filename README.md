# Poisson Seamless Cloning
*Algorithm coded from the lecture of Jean-Michel Morel (École normale supérieure de Cachan), and the article "Poisson Image Editing" (J. Matias Di Martino, Gabriele Facciolo & Enric Meinhardt-Llopis).*

[[Project]](https://medium.com/how-to-detect-digital-on-digital-image/introduction-seamless-copy-move-forgery-79280ee4c110)

## Running the code
To run the code on your own images, you will need to change the parameters in the *Main.m* script.
* **path**: path to your images folder
* **image_background**: background image to place the element in
* **image_element**: image containing the element to move on the background image
* **image_omega**: image of the area where the element needs to be picked from **image_element**.
* **x0** and **y0**: x and y coordinated where to place the element in the background image

## Poisson Image editing
The problem can be summarized as follow. Given an image **R**, we want to modify it on a small area **Ω**, a closed subset of **R²**, based on the information of another image.

<p align="center"><img src="https://miro.medium.com/max/380/1*m-4ZnTZ6_--dgVC7haLlkQ.png" width=430></p>

Let’s take the example below where a plane needs to be placed from its original image (right image) to another one (left image). In order to do a seamless copy, one needs to make sure that the border of the moved element are not perceptible. A rough image edition will make inadequate color appears around the element (bottom image).

<p align="center"><img src="https://miro.medium.com/max/1403/1*_YKL9ZghtE-nK6Dsk7RIVQ.png" width=600></p>

<p align="center"><img src="https://miro.medium.com/max/3840/1*W64uGEGAoOgSsrdg8XpWmQ.png" width=600></p>

Some research studies on human vision draws the conclusion that we are more sensitive to the Laplacian rather than the image as a whole. The Poisson Equation is therefore the right framework to derive a seamless solution to this forgery problem. We know the Laplacian value inside the domain and the border values, which is enough to reconstruct the image.

Let’s note **b** the background image and **e** the image from which the element should be extracted: the resulting image is denoted **r**. The guidance vector field is given by:
<p align="center"><img src="https://miro.medium.com/max/646/1*w8txr7yCvjtNBoRSbZIGJA.png" width=200></p>

Therefore, image edition boils down to the following minimization problem:
<p align="center"><img src="https://miro.medium.com/max/486/1*ozPO4BMZK6VwJ7FEu7ci4w.png" width=200></p>

It can be proved (with a perturbation analysis) that this minimization problem admits a **C²** solution (first and second derivatives continuity). Moreover, this solution satisfies the Poisson equation with Neumann boudary condition:
<p align="center"><img src="https://miro.medium.com/max/682/1*Skkpu0BP5v16XCf8RAZUuA.png" width=200></p>

To apply the Fourier method, the boudary of the domain **Ω** must coincide with the coordinates line. To check this condition, one can simply extend the guidance vector field to the whole image **R** and solve the variational problem on this extended domain.

The Neumann boundary condition is fulfilled by extending the original image symmetrically accross its axes. By doing so, we impose that **V**.**n**=0 on the boundary of the image **R**.

The discrete Fourier transform of a periodic and band limited function **u** can be easily computed from the formula above if we know the function values on a **J**x**L** grid.
<p align="center"><img src="https://miro.medium.com/max/810/1*7zK8f0YfCo_DA-KbFBV0PA.png" width=300></p>

In the Fourier domain, the Poisson equation becomes:
<p align="center"><img src="https://miro.medium.com/max/1330/1*HWgBWthPjGqN6uSYHnhbzw.png" width=300></p>

with **V**=(**V₁**,**V₂**). The equation allows us to retrieve the values of all Fourier coefficients, except the offset i.e. the mean of the solution. As a consequence, at the end of the Fourier method, one need to shift the pixel values so that all values belong to the interval [0,255]. A more natural alternative is to simply apply a color balance to span the full range for pixel values.

## Method
The method is composed of six successive steps:

* Compute the guidance field **V**:
  * Gradient field of the background image (Top left) and the guidance image(Top right)
  * Guidance field (Bottom)
<p align="center"><img src="https://miro.medium.com/max/1736/1*iylAgTd72cyx_XuSK-yURQ.png" width=600></p>
<p align="center"><img src="https://miro.medium.com/max/868/1*Wl_fFa0bhH7O45oLDyrbDA.png" width=600></p>

* Extend the image and the guidance field **V** to a larger image of four time the original size
<p align="center"><img src="https://miro.medium.com/max/868/1*59U6sNg4t_T9rIWC7y4vZQ.png" width=600></p>

* Compute the Discrete Fourier Transform of the gradient field along the x-axis (Left) and the y-axis (Right)
<p align="center"><img src="https://miro.medium.com/max/1534/1*GnGG8F4H2F4hK6M5TuaxFA.png" width=600></p>

* Compute the Discrete Fourier Transform of the solution of the problem
<p align="center"><img src="https://miro.medium.com/max/732/1*Fbr5LYHFpV_ddkvibsNShQ.png" width=200></p>

<p align="center"><img src="https://miro.medium.com/max/7680/1*EfG7v2e4nQRFrDhP_VTGHQ.png" width=600></p>

* Compute the inverse Fourier transform of the former image
<p align="center"><img src="https://miro.medium.com/max/7680/1*yn_NMjaDER4Ckib78pz-nQ.png" width=600></p>


* Restrict the samples to the initial domain.
<p align="center"><img src="https://miro.medium.com/max/3840/1*urL4PXYbGA-qQf3vq-cr-g.png" width=600></p>


* Apply a colour balance algorithm
<p align="center"><img src="https://miro.medium.com/max/3840/1*KCqBasamKHARfH-otzx0TQ.jpeg" width=600></p>
