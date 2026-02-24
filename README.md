# 🌿 Radial Fourier Leaf Classifier (MATLAB)

![MATLAB](https://img.shields.io/badge/MATLAB-Image%20Processing-orange)
![Computer Vision](https://img.shields.io/badge/Computer%20Vision-Fourier%20Descriptors-blue)
![Machine Learning](https://img.shields.io/badge/Machine%20Learning-SVM-green)
![License](https://img.shields.io/badge/License-MIT-lightgrey)

> Shape-based leaf classification using **green segmentation** and a **radial Fourier descriptor**.  
> Case study: Parsley vs Cilantro.


## 📌 Overview

This project implements and compares two classical computer vision pipelines for leaf classification.

### 🔹 Baseline approach
- White background binarization  
- Morphological cleanup  
- Contour-based Fourier descriptor  
- Linear classifier  

The baseline method was sensitive to:
- Centroid displacement  
- Rotation  
- Border noise  
- Small holes inside the leaf region  


### 🔹 Improved approach

To overcome these issues, the final solution includes:

- Green-based segmentation (`Green − Gray`)
- Morphological refinement
- Radial sampling \( r(\theta) \) from the centroid
- FFT of the radial function
- Harmonic selection (`Kfft = 14`)
- SVM classifier

This improves robustness against translation, rotation and segmentation artifacts.


## 📂 Contents

- `main.m` → Main demo script (ROI selection + classification pipeline)
- `segment_green_minus_gray.m` → Green channel segmentation and morphological refinement
- `radial_fourier_descriptor.m` → Radial Fourier feature extraction
- `model_green_svm.mat` → Trained SVM classification model
- `test images` → Example parsley and cilantro images


# 🧠 Methodology

## 1️⃣ Green Segmentation

Green enhancement:

```
Sg = G - (R + G + B)/3
```

Followed by:
- Otsu thresholding  
- Hole filling  
- Small-object removal  
- Largest connected component selection  


## 2️⃣ Radial Fourier Descriptor

For each segmented leaf:

- Compute centroid  
- Sample radial distances \( r(\theta) \) with `Nang = 360`  
- Apply FFT  
- Keep first `Kfft = 14` magnitude coefficients  
- Normalize by DC component  

Each leaf is represented as a point in a **14-dimensional feature space** defined by the truncated Fourier magnitude spectrum of its radial distance profile.

### Parsley radial descriptor
<p align="center">
  <img alt="radial_fourier_descr_parsley" src="https://github.com/user-attachments/assets/5232ebb2-53df-4081-be32-e65866d5d8ad" width="600">
</p>

### Cilantro radial descriptor

<p align="center">
  <img alt="radial_fourier descr_cilantro" src="https://github.com/user-attachments/assets/d3d2a707-813e-4c1a-983d-5048940a5278" width="600">
</p>

This representation is:

- Translation invariant (centroid-based)  
- Rotation invariant (magnitude spectrum)  
- Robust to local contour noise  
- Scale-stabilized via DC normalization  


### 📐 Mathematical Formulation

Let $$r(\theta_n)$$ be the radial distance function sampled at $$N_{ang}$$ angles.

The discrete Fourier transform is:

$$
R(k) = \sum_{n=0}^{N_{ang}-1} r(\theta_n)\, e^{-j 2\pi kn / N_{ang}}
$$

The truncated descriptor is:

$$
F = \left[ |R(0)|, |R(1)|, \dots, |R(K_{fft}-1)| \right]
$$

where $$K_{fft} = 14$$.

> The value Kfft = 14 was selected empirically after evaluating classification accuracy as a function of harmonic truncation.

### Performance Comparison Under Different Dataset Conditions

| Descriptor Method                    | Dataset Condition | 5-Fold CV Accuracy |
|--------------------------------------|------------------|-------------------|
| Classical Contour Fourier Descriptor | Raw Dataset      | 58–65% |
| Radial Fourier + SVM                 | Raw Dataset      | 75% |
| Radial Fourier + SVM                 | Refined Dataset  | **90.71%** |

The results highlight the impact of dataset preprocessing quality on classifier performance, particularly for shape-based descriptors.

# 🔎 End-to-End Pipeline Examples

Complete processing pipeline:

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


# 📊 Feature Space Visualization

Radial Fourier features projected onto 2D PCA space:

<p align="center">
  <img alt="svm and pca" src="https://github.com/user-attachments/assets/40783fa3-5c3b-4ce4-9aad-8b76b916f239" width="700">
</p>

Binary encoding used for training:
- 0 → Parsley  
- 1 → Cilantro  

Although partial overlap exists in the 2D PCA projection, the SVM decision boundary is learned in the original 14-dimensional feature space.
> PCA is used for visualization only and does not represent the true decision boundary, which is learned in the full feature space.
---

# 📈 Results

| Parameter | Value |
|------------|--------|
| Nang       | 360    |
| Kfft       | 14     |
| Morph box  | 5      |
| CV folds   | 5      |

**Cross-validation accuracy: 90.71%**

<p align="center">
  <img alt="confusion" src="https://github.com/user-attachments/assets/f734fa46-add1-4910-8578-aff5dbdfd2da" width="500">
</p>



# 🧩 Design Decisions

- Radial sampling avoids contour ordering sensitivity  
- FFT truncation acts as a shape low-pass filter  
- Magnitude spectrum ensures rotation invariance  
- DC normalization improves scale robustness  
- Manual ROI simplifies controlled experimentation  

# ⚠️ Limitations

- Manual ROI selection required  
- Performance may degrade under extreme lighting  
- PCA shows partial overlap in reduced dimension  
- Dataset collected under controlled conditions  


# 🚀 How to Run

1️⃣ Ensure the trained SVM model (`modelo_verde_svm.mat`) is in the project folder.

2️⃣ Open MATLAB and set the repository as the current directory.

3️⃣ Run:

```matlab
main
```

4️⃣ Select the ROI around the leaf.

> The repository includes a pre-trained SVM model.


# 🔬 Requirements

- MATLAB  
- Image Processing Toolbox  
- Statistics and Machine Learning Toolbox  



## 🤝 Support projects
 Support me on Patreon [https://www.patreon.com/c/CrissCCL](https://www.patreon.com/c/CrissCCL)

## 📜 License
MIT License  
