
<img src="https://raw.githubusercontent.com/Katayath-Sai-Kiran/curved_text_codespark/main/assets/banner.png" alt="Curved Text Codespark" />

# 🌀 curved_text_codespark

[![Pub Version](https://img.shields.io/pub/v/curved_text_codespark)](https://pub.dev/packages/curved_text_codespark)
[![Likes](https://img.shields.io/pub/likes/curved_text_codespark)](https://pub.dev/packages/curved_text_codespark/score)
[![Code Style: Flutter](https://img.shields.io/badge/style-flutter-blue)](https://flutter.dev)
[![GitHub Repo](https://img.shields.io/badge/github-source-black?logo=github)](https://github.com/Katayath-Sai-Kiran/curved_text_codespark)

> **Next-level Flutter text rendering — wrap your words around curves, waves, spirals & paths!**  
> Perfect for logos, animations, interactive UIs, and attention-grabbing designs.

---

## ✨ Features

✅ Circular, elliptical, spiral, wave, and custom curved text  
✅ Customizable radius, spacing, direction, baseline, and angle  
✅ Per-character style control via builder  
✅ Animate text along the path  
✅ Character tap callbacks  
✅ RTL and multiline-ready architecture  
✅ Works with `TextStyle`, emojis, symbols, and more  
✅ Null-safe, Flutter 3.x compatible

---

## 📸 Preview

> *(Include GIFs/Screenshots here)*  
> _You can show: Circular text, Wave animation, Spiral logo-style text, Tap effect._

---

## 🚀 Getting Started

Add to your `pubspec.yaml`:

```yaml
dependencies:
  curved_text_codespark: ^0.0.1
````

Import in your Dart file:

```dart
import 'package:curved_text_codespark/curved_text_codespark.dart';
```

---

## 🧪 Example

```dart
CurvedText(
  text: 'CURVED TEXT CODESPARK',
  options: CurvedTextOptions(
    curveType: CurveType.circular,
    radius: 120,
    spacing: 8,
    clockwise: true,
    rtl: false,
    defaultTextStyle: TextStyle(
      fontSize: 20,
      color: Colors.tealAccent,
      fontWeight: FontWeight.bold,
    ),
  ),
  onCharTap: (index, char) {
    print('Tapped: "$char" at index $index');
  },
  styleBuilder: (index, char) {
    return TextStyle(
      fontSize: 20 + (index % 4) * 2,
      color: index.isEven ? Colors.tealAccent : Colors.orangeAccent,
    );
  },
)
```

---

## 🆚 Comparison with Other Packages

| Feature / Package                       | `curved_text_codespark` | `curved_text` | `curved_render_text` | `flutter_circular_text` |
| --------------------------------------- | :---------------------: | :-----------: | :------------------: | :---------------------: |
| Circular Text                           |            ✅            |       ✅       |           ✅          |            ✅            |
| Elliptical / Spiral / Wave              |            ✅            |       ❌       |           ❌          |            ❌            |
| Custom Path Support                     |      ✅ *(planned)*      |       ❌       |           ❌          |            ❌            |
| Per-character Styling                   |            ✅            |       ❌       |           ❌          |            ❌            |
| Tap Callbacks                           |            ✅            |       ❌       |           ❌          |            ❌            |
| RTL Support                             |            ✅            |       ❌       |           ❌          |            ❌            |
| Text Animation                          |       ✅ *(early)*       |       ❌       |           ❌          |            ❌            |
| Null Safety & Flutter 3.x Compatibility |            ✅            |   ⚠️ Partial  |           ❌          |            ❌            |
| Maintained                              |            ✅            |       ❌       |           ❌          |            ❌            |

---

## 🧩 Roadmap

* [x] Circular/elliptical curved text
* [x] Tap detection on characters
* [x] Style builder support
* [ ] Spiral / Sine / Arc / Bezier / SVG path text
* [ ] Scroll-responsive curvature
* [ ] Custom painter API for integration into canvas
* [ ] Text shadows & gradient fills
* [ ] Multiline & RTL text support
* [ ] Path morph animations

---

## 🤔 Why `curved_text_codespark`?

Other packages stop at circular text.
We go **around** and **beyond** it — with animations, interactivity, styling freedom, and upcoming full-path rendering support.

Whether you're making a **logo**, a **radial menu**, or **eye-catching titles**, this package gives you the **flexibility and finesse** missing from others.

---

## 👨‍💻 Maintainer

Built and maintained by [K Sai Kiran](https://pub.dev/publishers/ksaikiran.tech/packages)

Have ideas or feedback? PRs & issues welcome!
⭐️ Star the [GitHub repo](https://github.com/Katayath-Sai-Kiran/curved_text_codespark) to support ongoing development.




