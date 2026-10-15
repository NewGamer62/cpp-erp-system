# 🏢 Boutique IUT — ERP Client (Flutter)

[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Dart](https://img.shields.io/badge/Dart-3.x-0175C2?logo=dart&logoColor=white)](https://dart.dev)
[![State Management](https://img.shields.io/badge/State-Provider%206.x-blueviolet)](https://pub.dev/packages/provider)
[![Platform](https://img.shields.io/badge/Platform-Windows%20%7C%20Web%20%7C%20Android-4CAF50)](#)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

Application multiplateforme (Desktop Windows, Web, Android) développée avec **Flutter** et **Dart**, connectée à l'infrastructure backend d'un Progiciel de Gestion Intégré (**ERP Wavesoft / Polyèdre**) via des passerelles CGI exposant des flux JSON en temps réel.

Projet réalisé dans le cadre du module **R4-091 ERP** (BUT Informatique, Semestre 4).

---

## 📸 Aperçu Visuel

<div align="center">
  <img src="Screen/Capture%20d'écran%202026-04-02%20172536.png" alt="Catalogue Articles ERP" width="48%" />
  <img src="Screen/Capture%20d'écran%202026-04-02%20172614.png" alt="Fiche Détaillée Article" width="48%" />
  <p><em>À gauche : Catalogue des articles d'un fournisseur avec prix et images. À droite : Fiche détaillée de l'article sélectionné.</em></p>
</div>

---

## 🎯 Objectif & Pitch Fonctionnel

Dans un écosystème d'entreprise, l'ERP centralise la base de données relationnelle et les règles de gestion commerciale (référentiel articles, tarification, gestion des stocks et fournisseurs). 

Ce projet implémente un **frontend découplé**, réactif et moderne permettant à un client ou collaborateur :
1. **D'explorer les fournisseurs :** Bandeau horizontal dynamique (`SupplierBanner`) interrogeant le webservice des fournisseurs du groupe (`getfrstd1.cgi`).
2. **De consulter les catalogues en direct :** Chargement asynchrone des articles rattachés au fournisseur sélectionné (`getart.cgi?frs={supplierId}`) avec gestion robuste du fallback sur image manquante (`image_not_supported`).
3. **D'accéder aux fiches produits :** Vue détaillée (`DetailsScreen`) affichant le libellé long de l'ERP, le visuel haute résolution et le tarif unitaire.
4. **De gérer un panier d'achat persistant :** Gestion centralisée d'état avec `Provider`, badge numérique de panier en temps réel, ajustement des quantités et checkout simulé.

---

## 🛠️ Stack Technique & Architecture

### Stack
- **Framework & UI :** Flutter 3.x (Material 3)
- **Langage :** Dart 3.x
- **Gestion d'État (State Management) :** `provider` (^6.1.2) — séparation stricte UI / Métier via `AppState` (`ChangeNotifier`)
- **Client HTTP :** `http` (^1.1.0)
- **Backend ERP :** Serveur Wavesoft / passerelles CGI Polyèdre (`http://polyedre.eu:8000/polyfx/cgi/`)

### Architecture Applicative (`front_erp/lib/`)

```
lib/
├── main.dart                  # Point d'entrée, initialisation du ChangeNotifierProvider
├── models/                    # Modèles immuables fortement typés
│   ├── article.dart           # Entité Article (id, name, price, image, description)
│   ├── cart_item.dart         # Ligne de panier (article + quantity)
│   └── supplier.dart          # Entité Fournisseur (id, name)
├── providers/
│   └── app_state.dart         # Logique métier globale (fournisseur actif, panier, totaux)
├── screens/                   # Vues complètes
│   ├── cart_screen.dart       # Vue panier, ajustement des quantités et validation
│   ├── details_screen.dart    # Vue détaillée d'un article et ajout panier
│   └── home_screen.dart       # Écran d'accueil (bandeau fournisseurs + catalogue)
├── services/
│   └── api_service.dart       # Couche réseau isolée (appels HTTP & parsing JSON)
└── widgets/                   # Composants UI atomiques et réutilisables
    ├── article_card.dart      # Carte produit avec gestion d'image et action rapide
    └── supplier_banner.dart   # Liste horizontale scrollable des fournisseurs
```

---

## 🚀 Démarrage Rapide

### Prérequis
- [Flutter SDK](https://docs.flutter.dev/get-started/install) (version 3.10+ recommandée)
- Visual Studio avec la charge de travail *Développement Desktop en C++* (pour cible Windows) ou Google Chrome (pour cible Web)

### Lancement

1. **Cloner le dépôt :**
   ```bash
   git clone https://github.com/NewGamer62/cpp-erp-system.git
   cd cpp-erp-system/front_erp
   ```

2. **Récupérer les dépendances :**
   ```bash
   flutter pub get
   ```

3. **Lancer l'application :**
   ```bash
   # Exécution sur Windows Desktop
   flutter run -d windows

   # Ou exécution dans le navigateur
   flutter run -d chrome
   ```

---

## 🔍 Qualité & Analyse Statique

Le projet respecte scrupuleusement l'ensemble des règles de linting officielles de Dart / Flutter :

```bash
flutter analyze
# Output: No issues found!
```
