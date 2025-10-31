# confusion-matrix (Typst)

Rendu de matrice de confusion réutilisable pour Typst, basé sur @preview/cetz.

- Fichier principal: `confusion.typ` (exporte la fonction `confusion-matrix`)
- Démo: `demo.typ`
- Licence: voir `LICENSE`

Prérequis

- Typst installé
- Accès au package `@preview/cetz:0.4.2` (utilisé en interne par `confusion.typ`)

Installation / Utilisation locale

- Copiez `confusion.typ` dans votre projet (ou placez-le dans un dossier de packages local si vous en utilisez un).
- Importez et appelez la fonction comme ci-dessous.

Import

```
#import "confusion.typ": confusion-matrix
```

API

```
#let confusion-matrix(
  labels,                         // tuple/liste de n labels
  M,                              // matrice n×n (tuple de tuples) de valeurs >= 0
  title-row: "Predicted",         // titre axe colonnes
  title-col: "Ground Truth",      // titre axe lignes
  colormap-name: "viridis",       // "viridis" | "magma" | "inferno" | "plasma" | "cividis"
  cell-size: 1.3,                 // taille d’une cellule (unités canvas)
  show-colorbar: true,            // affiche la barre de couleurs
  label-rotate: -35deg,           // rotation des labels colonnes
  value-font-size: 9pt,           // taille du texte dans les cellules
  tick-scale: 0.07,               // longueur des ticks en proportion de cell-size
)
```

Exemple minimal

```
#import "confusion.typ": confusion-matrix

#let labels = ("Covered", "ConditionUnmet", "NotCovered", "Uncertain")
#let M = (
  (10, 3, 6, 2),
  (2, 4, 3, 2),
  (1, 0, 1, 1),
  (2, 2, 0, 0),
)

#confusion-matrix(
  labels,
  M,
  title-row: "Predicted",
  title-col: "Ground Truth",
  colormap-name: "magma",
  cell-size: 1.3,
  show-colorbar: true,
)
```

Démo

- Compilez la démo:

```
typst compile demo.typ
```

Notes

- La sélection de colormap prend en charge: `viridis`, `magma`, `inferno`, `plasma`, `cividis`. Toute autre valeur retombe sur `viridis`.
- Si `max(M) == 0`, une couleur uniforme est utilisée et la colorbar n’affiche pas de graduation non pertinente.
- La couleur du texte dans les cellules est ajustée automatiquement pour le contraste (noir/blanc) selon le fond.

Bonnes pratiques et extensions possibles

- Valider que `len(labels) == n`, `M` est carrée et de taille `n × n`.
- Option future: `normalize: "none" | "row" | "column"` pour afficher des pourcentages.
- Personnalisation fine (tailles, épaisseurs, marges) possible via de nouveaux paramètres.

Publication (optionnelle)

- Pour un usage local, rien d’autre n’est requis.
- Pour publier sur le registry Typst: préparer la structure conforme puis:

```
typst package publish confusion-matrix
```

(consultez la documentation Typst pour le manifeste/metadata.)

Crédits

- Rendu basé sur `@preview/cetz:0.4.2` (canvas/draw).
