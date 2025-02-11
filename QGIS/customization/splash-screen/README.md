# 🖼️ Custom QGIS Splash Screen

*This guide explains how to **enable QGIS interface customization** and modify the splash screen by editing `QGISCUSTOMIZATION3.ini`.*

*Ce guide explique comment **activer l'interface de Customisation QGIS** et modifier l'écran de démarrage en éditant `QGISCUSTOMIZATION3.ini`.*

---

## 🌍 English

### ✅ Enable Customization
1️⃣ Open **QGIS**.

2️⃣ Go to **Settings → Interface Customization...**.

3️⃣ Tick the **Enable customization** checkbox.
   *⚠️ If you skip this step, `QGISCUSTOMIZATION3.ini` will not exist!*

### 📂 Access `QGISCUSTOMIZATION3.ini`
1️⃣ Go to **Settings → User Profiles → Open Active Profile Folder**.

2️⃣ Locate the file at:
```./QGIS/QGISCUSTOMIZATION3.ini```

### ✏️ Edit `QGISCUSTOMIZATION3.ini`
- Add a key named **`splashpath`** to the `.ini` file.  
- This key should point to a folder **containing an image named** `splash.png`.  
- **The image must be exactly** `600x300 px`.  
- **Example paths:**

#### 🐧 Linux Syntax:
*(For an image located in the `default` profile folder)*

```splashpath=home/asus/qgis/qgis3/profiles/default/```

#### 🖥️ Windows Syntax:

*(For an image located in the `default` profile folder)*

```splashpath=C:\\Users\\ASUS\\AppData\\Roaming\\QGIS\\QGIS3\\profiles\\default\\```

---

## 🌍 Français

### ✅ Activer les options de personnalisation
1️⃣ Ouvrir **QGIS**.

2️⃣ Aller dans Préférences → Interface....

3️⃣ Cocher la case **Activer la personnalisation**.  
   *⚠️ Sans cette étape, le fichier `QGISCUSTOMIZATION3.ini` n'existera pas !*

### 📂 Accéder à `QGISCUSTOMIZATION3.ini`
1️⃣ Aller dans **Préférences → Profils → Ouvrir le répertoire du profil actif**.
2️⃣ Le fichier se situe à :
```./QGIS/QGISCUSTOMIZATION3.ini```

### ✏️ Modifier `QGISCUSTOMIZATION3.ini`
- Ajouter une clé nommée **``splashpath``** dans le fichier ``.ini``.
- Cette clé doit pointer vers un dossier **contenant une image nommée** ``splash.png``.
- **L’image doit mesurer exactement** ``600x300 px``.
- **Exemples de chemins:**

#### 🐧 Syntaxe Linux :
*(Pour une image située dans le dossier `default`)*

```splashpath=home/asus/qgis/qgis3/profiles/default/```

#### 🖥️ Syntaxe Windows :
*(Pour une image située dans le dossier `default`)*

```splashpath=C:\\Users\\ASUS\\AppData\\Roaming\\QGIS\\QGIS3\\profiles\\default\\```

---
