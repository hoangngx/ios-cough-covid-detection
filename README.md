# ios-cough-covid-detection
Cough Covid Detection on iOS

## Table of contents
* [1. Demo](#1-demo)
* [2. The structures of the repository](#2-the-structures-of-the-repository)
* [3. Training and prediction](#3-training-and-prediction)
    * [3.1 Training](#31-training)
    * [3.2 Prediction](#32-prediction)
* [4. For tesing with your own audio](#4-for-tesing-with-your-own-audio)

## 1. Demo

After the app runs, tap the Start button and start coughing; after 5 seconds (you can change `private let AUDIO_LEN_IN_SECOND = 5` in `ViewController.swift` for a longer or shorter recording length), the model will infer to recognize your cough. Some example results are as follows:


![alt text](https://github.com/hoangngx/vn-cough-covid/blob/main/demo-imgs/home_demo.png?raw=true)
*Home Screen Demo*



![alt text](https://github.com/hoangngx/vn-cough-covid/blob/main/demo-imgs/news_maps.png?raw=true)
*Read News, Search News and Navigate nearest clinics feature*



<img src="https://github.com/hoangngx/vn-cough-covid/blob/main/demo-imgs/login_signUp.png" width="500" height="500" />
*Log In and Sign Up screen*



<img src="https://github.com/hoangngx/vn-cough-covid/blob/main/demo-imgs/FAQs_feature.png" width="400" height="800" />
*FAQs (Frequently Asked Questions) feature*
