# 🧠 Brain Tumor Detection using MATLAB

This project implements a **Brain Tumor Detection system** using **MATLAB**.  
The approach applies **anisotropic diffusion filtering**, **thresholding**, and **morphological operations** to detect and highlight brain tumors in MRI images.  

---

## 📌 Overview

The system processes MRI brain images through several stages:  

1. **Preprocessing**  
   - Noise removal using *Anisotropic Diffusion Filtering*  

2. **Thresholding**  
   - Segmenting possible tumor regions  

3. **Morphological Operations**  
   - Extracting high-density areas  
   - Identifying the largest connected region as the tumor  

4. **Tumor Localization**  
   - Bounding box drawn around detected tumor  

5. **Tumor Outline**  
   - Outline of tumor region is extracted and highlighted in red  

---

## ⚙️ Workflow

1. **Input**: MRI brain image (`.jpg`)  
2. **Noise Removal**: Anisotropic diffusion filtering (Perona-Malik)  
3. **Segmentation**: Thresholding → binary image of possible tumor regions  
4. **Morphology**: Connected components analysis, solidity & area filtering  
5. **Tumor Detection**: Largest dense region detected as tumor  
6. **Visualization**:  
   - Tumor mask  
   - Bounding box  
   - Tumor outline  
   - Final detected tumor overlay  

---

## 📊 Results

- **Input Image** → MRI scan  
- **Filtered Image** → Noise reduced, enhanced edges  
- **Binary Segmentation** → Tumor region isolated  
- **Bounding Box** → Highlighted tumor area  
- **Tumor Outline** → Boundary extracted  
- **Final Output** → Tumor highlighted in **red** on MRI  

---

## 🛠️ Tools & Requirements

- **MATLAB R2018a or later** (Image Processing Toolbox recommended)  

Functions used:  
- `imread`, `imshow`  
- `imfilter`, `rgb2gray`  
- `bwlabel`, `regionprops`  
- `imfill`  
- Custom anisotropic diffusion function (`anisodiff.m`)  

---

## ▶️ How to Run

1. Open MATLAB.  
2. Place both scripts in the same folder:  
   - `anisodiff.m`  
   - `main.m` (the tumor detection code)  
3. Run the main script:  
   ```matlab
   main
