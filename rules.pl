:- consult('meals.pl').

% Define the recommendation rule
recommend(Item, Cuisine, Type, MealType, MaxPrice) :-
    item(Item, Cuisine, Type, MealType, Price),
    Price =< MaxPrice.




