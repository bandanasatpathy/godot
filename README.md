
# 🐍 Godot Snake – Day 8 (Start Screen, Pause & Resume)

This folder is a **reference project guide**.
It explains **exact Inspector settings**, **node structure**, and **why each setting exists**.
You can follow this step-by-step in a fresh Godot project.

---

## 📁 Scene Tree Structure

Main (Node2D)
├── Border
├── Background
├── Snake
│   └── Head
├── Apple
├── ScoreLabel
├── EatSound
├── GameOverSound
├── StartScreen (CanvasLayer)
│   └── Panel
│       ├── VBoxContainer
│       │   ├── TitleLabel
│       │   └── StartButton
├── PauseUI (CanvasLayer)
│   └── Panel
│       ├── PauseLabel
│       └── ResumeButton

---

## 🟢 StartScreen Inspector Settings

### StartScreen (CanvasLayer)
- Follow Viewport: **ON**
- Process Mode: **Always**
- Script: `startScreen.gd`

### Panel (inside StartScreen)
- Layout → Anchors Preset → **Full Rect**
- Theme Overrides → Styles → Panel → StyleBoxFlat
  - BG Color: `#000000AA` (semi-transparent black)

### VBoxContainer
- Anchors Preset: **Center**
- Alignment: **Center**
- Custom Minimum Size:
  - X: 300
  - Y: 200

### TitleLabel
- Text: **SNAKE GAME**
- Horizontal Alignment: **Center**
- Vertical Alignment: **Center**
- Layout Mode: **Container**

### StartButton
- Text: **START**
- Layout Mode: **Container**
- Script: `StartButton.gd`
- Signal:
  - `pressed()` → connect to **Main**

---

## 🟡 PauseUI Inspector Settings

### PauseUI (CanvasLayer)
- Follow Viewport: **ON**
- ⚠️ Process Mode: **Always** (IMPORTANT)
- Script: `PauseUI.gd`

### Panel (inside PauseUI)
- Layout → Anchors Preset → **Full Rect**
- Theme Overrides → Styles → Panel → StyleBoxFlat
  - BG Color: `#000000AA`

### PauseLabel
- Text: **PAUSED**
- Horizontal Alignment: **Center**

### ResumeButton
- Text: **RESUME**
- ⚠️ Process Mode: **Always**
- Signal:
  - `pressed()` → connect to **PauseUI**

---

## 🔵 Main Scene Inspector Notes

### ScoreLabel
- Visible: **false** (shown after Start)

---

## ⌨️ Input Map (Project → Project Settings → Input Map)

Add:
- `ui_cancel` → **Esc key**

---

## 🧠 Important Rules (WHY this works)

### Why UI needs Process Mode = Always
When `get_tree().paused = true`:
- Game logic stops
- UI ALSO stops ❌
- Buttons won't work ❌

Setting **Process Mode = Always** allows UI to work while paused.

---

## 🎮 Expected Flow

1. Game launches → StartScreen visible → Snake not moving
2. Click START → Game begins → Snake moves
3. Press ESC → PauseUI appears → Snake stops
4. Click RESUME → Game continues

---

## 🎥 Perfect for YouTube Day 8

Topics you can explain:
- CanvasLayer usage
- Pause vs Process Mode
- Why UI freezes on pause
- Clean separation of UI & game logic

---

Happy coding & recording 🎬🐍
