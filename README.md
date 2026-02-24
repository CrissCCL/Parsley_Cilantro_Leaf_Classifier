# 🌿 Radial Fourier Leaf Classifier (MATLAB)

![MATLAB](https://img.shields.io/badge/MATLAB-Image%20Processing-orange)
![Computer Vision](https://img.shields.io/badge/Computer%20Vision-Fourier%20Descriptors-blue)
![Machine Learning](https://img.shields.io/badge/Machine%20Learning-SVM-green)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

> Shape-based leaf classification using **green segmentation** and a **radial Fourier descriptor**.  
> Case study: Parsley vs Cilantro.

---

## 📌 Overview

This project implements and compares two classical computer vision pipelines for leaf classification.

### 🔹 Baseline approach
- White background binarization  
- Morphological cleanup  
- Contour-based Fourier descriptor  
- Linear classifier  

The baseline method was sensitive to:

- Centroid displacement (translation)  
- Rotation  
- Border noise  
- Small holes inside the leaf region  


### 🔹 Improved approach (robust)

To overcome these issues, the final solution includes:

- Green-based segmentation (`Green − Gray`)
- Morphological refinement
- Radial sampling `r(θ)` from the centroid
- FFT of the radial function
- Harmonic selection (`Kfft`)
- SVM classifier

This significantly improves robustness against translation, rotation and segmentation artifacts.


# 🧩 Design Decisions

- Radial sampling was chosen over contour-based descriptors to avoid sensitivity to contour ordering.
- FFT truncation (Kfft = 14) acts as a shape low-pass filter.
- Magnitude spectrum ensures rotation invariance.
- DC normalization improves scale robustness.
- Manual ROI simplifies background variability for controlled experimentation.

# ⚠️ Limitations

- Manual ROI selection is required.
- Performance may degrade under extreme lighting variations.
- PCA projection shows partial class overlap in 2D visualization.
- Dataset size is limited to controlled acquisition conditions.

# 🧠 Methodology

## 1️⃣ Green Segmentation

Green enhancement using:

Sg = G - (R+G+B)/3

Followed by:

- Otsu thresholding  
- Hole filling  
- Small-object removal  
- Largest connected component selection  

---

## 2️⃣ Radial Fourier Descriptor

For each segmented leaf:

- Compute centroid  
- Sample radial distances `r(θ)` with `Nang = 360`  
- Apply FFT  
- Keep first `Kfft = 14` harmonics  
- Normalize by DC component  

Each leaf is represented by a 14-dimensional feature vector composed of the first 14 Fourier magnitude harmonics of the radial distance function.

### Parsley radial descriptor
<p align="center">
  <img alt="radial_fourier_descr_parsley" src="https://github.com/user-attachments/assets/5232ebb2-53df-4081-be32-e65866d5d8ad" width="600">
</p>

### Cilantro radial descriptor

<p align="center">
  <img alt="radial_fourier descr_cilantro" src="https://github.com/user-attachments/assets/d3d2a707-813e-4c1a-983d-5048940a5278" width="600">
</p>

The radial profiles and their truncated Fourier spectra show consistent structural differences between parsley and cilantro leaf shapes.

This representation is:

- Translation invariant (centroid-based)  
- Rotation invariant (magnitude spectrum)  
- Robust to local contour noise  
- Scale-stabilized through DC normalization  


# 🔎 End-to-End Pipeline Examples

Below are two real classification examples using the complete pipeline:

1. ROI selection  
2. Green-minus-gray segmentation  
3. Morphological cleanup  
4. Radial Fourier feature extraction  
5. SVM prediction  


## Parsley Example

<p align="center">
  <img alt="parsley" src="https://github.com/user-attachments/assets/93c524cb-d038-4ae5-a264-7577ed9d1f68" width="600">
</p>

Final prediction: **PARSLEY**


## Cilantro Example

<p align="center">
  <img alt="cilantro" src="https://github.com/user-attachments/assets/50fc94a6-5205-4440-95ba-dde7b7fd6b5e" width="600">
</p>

Final prediction: **CILANTRO**


The robustness of the pipeline is achieved through:

- Green-minus-gray segmentation (stable under neutral backgrounds)  
- Radial sampling around the centroid  
- FFT magnitude representation (rotation invariant)  
- Harmonic truncation (noise attenuation)  
- SVM classification in the original feature space  


### 📐 Mathematical Formulation

Let $$r(\theta)$$ be the radial distance function sampled at $$N_{ang}$$ angular positions around the leaf centroid.

The discrete Fourier transform is defined as:

$$
R(k) = \sum_{n=0}^{N_{ang}-1} r(\theta_n) e^{-j 2\pi kn / N_{ang}}
$$

The truncated radial Fourier descriptor is:

$$
F = \left[ |R(1)|, |R(2)|, \dots, |R(K_{fft})| \right]
$$

Each leaf is therefore represented as a point in a $$K_{fft}$$-dimensional feature space (here $$K_{fft} = 14$$).



# 📊 Feature Space Visualization

To analyze separability, radial Fourier features were projected onto a 2D PCA space.

<p align="center">
  <img alt="svm and pca" src="https://github.com/user-attachments/assets/40783fa3-5c3b-4ce4-9aad-8b76b916f239" width="700">
</p>

Binary class encoding used for training:
- 0 → Parsley
- 1 → Cilantro

Although partial overlap exists in the 2D PCA projection, the SVM classifier operates in the original 14-dimensional radial Fourier feature space, where class separability improves.

# 📈 Results

Best configuration:

| Parameter | Value |
|------------|--------|
| Nang       | 360    |
| Kfft       | 14     |
| Morph box  | 5      |
| CV folds   | 5      |

**Cross-validation accuracy: 90.71%**

The improved radial descriptor significantly outperformed the baseline contour-based descriptor in robustness to centroid shift and border noise.

<p align="center">
  <img alt="confusion" src="https://github.com/user-attachments/assets/f734fa46-add1-4910-8578-aff5dbdfd2da" width="500">
</p>


# ⚙️ Engineering Notes

- Manual ROI selection simplifies background variability.
- Radial sampling reduces contour ordering sensitivity.
- FFT truncation acts as a low-pass shape filter.
- DC normalization stabilizes descriptor magnitude across scale variations.
- SVM kernel selection influences decision boundary smoothness.

# 🚀 How to Run

1️⃣ Make sure the trained SVM model (.mat) file is in the project folder.

2️⃣ Open MATLAB and set the repository folder as the current directory.

3️⃣ Run:

```matlab
main.m
```
4️⃣ Select an image and draw the ROI around the leaf.


> The repository includes a pre-trained SVM model.
> Training scripts are not required to run the demo.


## 🔬 Requirements

- MATLAB
- Image Processing Toolbox
- Statistics and Machine Learning Toolbox

## 🤝 Support projects
 Support me on Patreon [https://www.patreon.com/c/CrissCCL](https://www.patreon.com/c/CrissCCL)

## 📜 License
MIT License  

