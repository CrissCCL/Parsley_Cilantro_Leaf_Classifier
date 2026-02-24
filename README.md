# 🌿 Parsley vs Cilantro Leaf Classifier (MATLAB)

![MATLAB](https://img.shields.io/badge/MATLAB-Code-orange)
![Computer Vision](https://img.shields.io/badge/Computer%20Vision-Image%20Processing-blue)
![ML](https://img.shields.io/badge/Machine%20Learning-SVM-green)
![License: MIT](https://img.shields.io/badge/License-MIT-lightgrey)

> Classical computer vision pipeline for **parsley vs cilantro** leaf classification.
> Includes a baseline approach and an improved, more robust method based on **green segmentation** + **radial Fourier descriptor** + **SVM**.

<p align="center">
  <img src="assets/banner_pipeline.png" width="900">
</p>

---

## ✨ Overview

This project started with a white-background binarization pipeline using morphological operations and a contour-based Fourier descriptor with a linear classifier.

However, the baseline was sensitive to:
- centroid shift (translation)
- orientation (rotation)
- border noise
- small holes

To address these issues, the improved pipeline performs **green-based segmentation** and extracts a **radial Fourier descriptor**, then trains a **Support Vector Machine (SVM)** classifier.

---

## 🧠 Methods

### 1) Baseline pipeline
- White background binarization
- Morphological cleanup (open/close/fill)
- Contour extraction
- Fourier descriptor (contour-based)
- Linear classifier

<p align="center">
  <img src="assets/baseline_binarization_steps.png" width="900">
</p>

### 2) Improved pipeline (robust)
- Green segmentation (ExG / HSV / normalized G)
- Morphological cleanup
- Radial function sampling `r(θ)` (e.g., `Nang = 360`)
- FFT of `r(θ)` → keep first harmonics (e.g., `Kfft = 14`)
- SVM classifier

<p align="center">
  <img src="assets/green_segmentation_steps.png" width="900">
</p>

<p align="center">
  <img src="assets/radial_fourier_descriptor.png" width="900">
</p>

---

## 📊 Results

Best configuration example:
- `Nang = 360`
- `Kfft = 14`
- `Box = 5`
- `Accuracy (5-fold CV) = 90.71%`
- `TP=63, TN=64, FP=6, FN=7`

<p align="center">
  <img src="assets/svm_confusion_matrix.png" width="550">
</p>

---

## 🚀 How to Run

### 1) Dataset

Place images into:

data/raw/cilantro/
data/raw/parsley/

Or use the small demo dataset in data/sample/ (if included).

### 2) Run baseline
scripts/02_train_baseline
### 3) Run improved SVM pipeline
scripts/03_train_improved_svm
### 4) Generate README figures

scripts/04_make_readme_figures

## ✅ Requirements

- MATLAB

- Image Processing Toolbox

- Statistics and Machine Learning Toolbox

