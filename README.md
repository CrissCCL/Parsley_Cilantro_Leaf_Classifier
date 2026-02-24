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

---

### 🔹 Improved approach (robust)

To overcome these issues, the final solution includes:

- Green-based segmentation (`Green - Gray`)
- Morphological refinement
- Radial sampling `r(θ)` from the centroid
- FFT of the radial function
- Harmonic selection (`Kfft`)
- SVM classifier

This significantly improves robustness against translation, rotation and segmentation artifacts.

---

## 🧠 Methodology

### 1️⃣ Green Segmentation

Green enhancement using:
Sg = G - (R+G+B)/3


Followed by:
- Otsu thresholding
- Hole filling
- Small-object removal
- Largest connected component selection

<p align="center">
  <img src="assets/green_segmentation_steps.png" width="850">
</p>

---

### 2️⃣ Radial Fourier Descriptor

For each segmented leaf:

- Compute centroid
- Sample radial distances `r(θ)` with `Nang = 360`
- Apply FFT
- Keep first `Kfft = 14` harmonics
- Normalize by DC component

<p align="center">
  <img src="assets/radial_fourier_descriptor.png" width="850">
</p>

This representation is:

- Translation invariant (centroid-based)
- Rotation invariant (magnitude spectrum)
- More robust to local contour noise

---

## 📊 Results

Best configuration:

| Parameter | Value |
|------------|--------|
| Nang       | 360    |
| Kfft       | 14     |
| Morph box  | 5      |
| CV folds   | 5      |

**Cross-validation accuracy: 90.71%**

Confusion matrix example:

<p align="center">
  <img alt="confusion" src="https://github.com/user-attachments/assets/6c490241-7467-4443-bdfd-c822d55151d8" width="500">
</p>

## 🚀 How to Run

### 1️⃣ Demo classification (manual ROI)

```matlab
scripts/01_demo_classify_roi
```
2️⃣ Train improved SVM model

scripts/03_train_improved_svm


## 🔬 Requirements

- MATLAB
- Image Processing Toolbox
- Statistics and Machine Learning Toolbox

## 📜 License

MIT License.
