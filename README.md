#SMART HEALTH GUARD

A Flutter-based AI-powered healthcare app focused on real-time health monitoring, emergency detection, and smart home control — designed for safety, accessibility, and rapid response.

![ui](https://github.com/user-attachments/assets/bcf9a771-0149-4c2f-9553-2bbff77d2f8c)
![emergency page](https://github.com/user-attachments/assets/dadc21c8-8ec2-4273-b5c8-d6d8d0d14941)
![heat rate](https://github.com/user-attachments/assets/e5d0c9cd-2bd7-4871-ae92-480941caaa86)

---

## Features

### **Emergency Detection & Alert**
- Fall detection using Machine learning model with CNN algorithm.
- Auto-alerts emergency contacts if no response is given.
- Loud alarm + live location sharing to 108 + emergency call.

### **Health Monitoring**
- **Heart Rate Measurement**
  - Uses the phone’s **camera** and **flashlight (torch)**.
  - Employs **Photoplethysmography (PPG)** by capturing fingertip blood flow.
  - No external device or smartwatch required.

### **Smart Appliance Control**
- Controls for fan, AC, lights, etc.
- Supports **Wi-Fi/Bluetooth-based smart devices**.

###  **Medication Reminders**
- Schedule and track medications with push notifications.
- Mark medications as taken or missed.

### **AI chatbot**
- Helps to chat with Ai and clarify health related questions

---

##  Why We Use Camera & Flashlight for Heart Rate Detection

To measure heart rate without external hardware, we use the principle of **PPG (Photoplethysmography)**:

- The **flashlight** shines through the user’s fingertip.
- The **camera** records color/intensity changes caused by blood flow.
- Frame analysis estimates **BPM** in real time.

>  Permissions Required:
> - `CAMERA`: To capture blood flow under the skin.
> - `FLASHLIGHT`: To illuminate fingertip for accurate detection.
---

##  Tech Stack

 Technology                      Purpose                                         

 **Flutter**             ---- UI and app logic                                
 **Syncfusion Charts**   ---- Visualize heart rate trends                    
 **Camera + Flash**      ---- Heartbeat & vitals via PPG                     
 **Flutter TTS / STT**   ---- Elder-friendly voice alerts & commands      
 **Shared Preferences**  ---- Store vitals history & medication logs     
 **Local Notifications** ---- Reminders for medication & emergencies    
 **HTTP / MQTT**         ---- Smart appliance API/communication               
 **Geolocator**          ---- Real-time location sharing                      

---

##  How to Use heart beat measuremnt

1. **Install the app on a real Android device** (camera required).
2. Open the app and tap **“Measure Now”**.
3. Place your fingertip gently over the camera + flashlight.
4. Wait 15–30 seconds to see BPM and trend line.
5. Use the bottom bar for:
   -  Viewing vitals history
   -  Emergency actions
   

---

##  Privacy First

- All health data is stored **locally**.
- Emergency alerts and location sharing are only triggered with permission.
- No data is sent to cloud unless explicitly configured.

---

##  Future Scope

-  Integrate ML model for predictive health warnings.
-  Smartwatch integration for 24/7 passive monitoring.
-  Cloud sync with health platforms like Google Fit or Apple Health.
-  Fully offline speech command system.

---

##  Contributors
- **Team Member Names** –
  *Akshaya R
  *Gayathri S
  *Deepa prabha P

---

>  Your health, always under watch—smart, simple, and secure.

