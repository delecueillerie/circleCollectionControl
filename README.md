#circleCollectionControl

This app is an exemple of a collection view with the use of a UICollectionViewFlowLayout subclass.

* Their is a scale effect on items which depends of the scrolling.
* When scrolling ending the centered item is selected automatically
* When you touch an item, it is automatically centered and selected.

Technically this control is a subclass of a UICollectionView with its own constructor. it uses delegation to act with its controller when an item is selected.


## Screenshot

![Screenshot 1](screenshot1.png)


## Some Ressources

* Many type of Collection views : https://github.com/mpospese/IntroducingCollectionViews

* A nice subclassing of UIcollectionViewLayout : https://github.com/awdigital/AWCollectionViewDialLayout
