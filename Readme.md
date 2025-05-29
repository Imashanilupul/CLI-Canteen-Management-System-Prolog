## include function
ItemPricePairs = [sushi-600, pizza-500, salad-300].
MaxPrice = 500.

include(within_price(500), ItemPricePairs, FilteredPairs).
% FilteredPairs = [pizza-500, salad-300].


## find all function

findall(Fruit, color(Fruit, yellow), Fruits).
Fruits = [banana, lemon].

not fail always like bagof and setof functions
