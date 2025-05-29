:- consult('rules.pl').

% Start the chatbot
start_chatbot :- 
    nl,
    write('Welcome to the Meal Recommendation Chatbot!'), nl,
    write('I can help you find meals or add new items to the menu.'), nl,
    write('Type show_instructions. to show instruction menu.'), nl,
    write('Type filter. to filter items.'), nl,
    write('Type exit. to quit the chatbot.'), nl,
    write('Type chatbot. to start the chatbot.'), nl,
    write('Enter your command: '), nl,
    read(Command),
    ( Command == show_instructions ->
        show_instructions
    ; Command == filter ->
        filter_items
    ; Command == exit ->
        write('Goodbye!'), nl, halt
    ; Command == chatbot ->
        chatbot
    ;
        write('Invalid command. Try again.'), nl,
        start_chatbot
    ).

show_instructions :-
    nl,
    write('--- Meal Recommendation Chatbot Instructions ---'), nl,
    write('1. When prompted, enter your role as either `owner.` or `customer.`'), nl,
    write('2. If you are the owner:'), nl,
    write('   - You can add new menu items with details like name, cuisine, type, meal type, and price.'), nl,
    write('   - All item names must be atoms (e.g., vegetable_pasta).'), nl,
    write('   - Cuisine: indian, chinese, italian, etc.'), nl,
    write('   - Type: vegan or non_vegan.'), nl,
    write('   - Meal Type: breakfast, lunch, dinner, or snack.'), nl,
    write('3. If you are a customer:'), nl,
    write('   - You can input your preferences to get matching meal recommendations.'), nl,
    write('   - You will be asked for cuisine, type, meal time, and maximum price.'), nl,
    write('4. At any point, type `yes.` or `no.` when asked to continue or quit.'), nl,
    write('5. Enter _ (underscore) if you like any.'), nl,
    write('--------------------------------------------------'), nl.

chatbot :-
    write('Select owner or customer ---->'), nl,
    read(Role),
    handle_role(Role).

% Filter items based on user preferences
filter_items :-
    write('Filter by: item_name / cuisine / type / meal_type / price'), nl,
    read(Criteria),
    (
        Criteria == item_name ->
            write('Enter item name (e.g., paneer_tikka):'), nl,
            read(Item),
            ( item(Item, _, _, _, _) ->
                write('Item found: '), nl,
                print_items([Item])
            ;
                write('Item not found.'), nl
            )
    ;   Criteria == cuisine ->
            write('Enter cuisine (e.g., indian):'), nl,
            read(Cuisine),
            findall(Item, item(Item, Cuisine, _, _, _), Items),
            print_items(Items)
    ;   Criteria == type ->
            write('Enter type (vegan / non_vegan):'), nl,
            read(Type),
            findall(Item, item(Item, _, Type, _, _), Items),
            print_items(Items)
    ;   Criteria == meal_type ->
            write('Enter meal type (breakfast / lunch / dinner / snack):'), nl,
            read(MealType),
            findall(Item, item(Item, _, _, MealType, _), Items),
            print_items(Items)

%% findall(Fruit, color(Fruit, yellow), Fruits).
%% Fruits = [banana, lemon].


    ;   Criteria == price ->
            write('Enter maximum price:'), nl,
            read(MaxPrice),
            findall(Item-Price, item(Item, _, _, _, Price), ItemPricePairs),
            include(within_price(MaxPrice), ItemPricePairs, FilteredPairs),
            extract_items(FilteredPairs, FilteredItems),
            print_items(FilteredItems)
    ;   write('Invalid criteria. Please try again.'), nl,
        filter_items
    ).

within_price(Max, _Item-Price) :- Price =< Max.

extract_items([], []).
extract_items([Item-_|T], [Item|Rest]) :- extract_items(T, Rest).



% Handle role-based interaction
handle_role(owner) :-
    write('Hello, Owner! Choose an option:'), nl,
    write('1. Add item'), nl,
    write('2. Delete item'), nl,
    write('3. Exit'), nl,
    read(Answer),
    ( Answer == 1 ->
        add_menu_item
    ; Answer == 2 ->
        delete_menu_item
    ; Answer == 3 ->
        write('Okay, goodbye!'), nl
    ; write('Invalid choice. Returning to main menu...'), nl,
      start_chatbot
    ).
handle_role(customer) :-
    write('Hello, Customer! Let\'s find you a great meal.'), nl,
    customer_recommendation.
handle_role(_) :-
    write('Sorry, I didn\'t understand that. Please type owner or customer.'), nl,
    start_chatbot.

% Owner flow: Add a new menu item
add_menu_item :-
    write('Enter item name (as an atom, e.g., paneer_tikka):'), nl,
    read(Item),
    write('Enter cuisine (e.g., indian):'), nl,
    read(Cuisine),
    write('Enter type (vegan/non_vegan):'), nl,
    read(Type),
    write('Enter meal type (breakfast/lunch/dinner/snack):'), nl,
    read(MealType),
    write('Enter price (number):'), nl,
    read(Price),
    assert(item(Item, Cuisine, Type, MealType, Price)),
    write('Item added successfully!'), nl,
    write('Would you like to add another item? (yes/no)'), nl,
    read(Answer),
    ( Answer == yes -> add_menu_item ; write('Returning to main menu...'), nl, start_chatbot ).

% Owner flow: Delete a menu item
delete_menu_item :-
    write('Enter the item name you want to delete (as an atom, e.g., paneer_tikka):'), nl,
    read(Item),
    ( retract(item(Item, _, _, _, _)) ->
        write('Item deleted successfully!'), nl
    ;
        write('Item not found.'), nl
    ),
    write('Would you like to delete another item? (yes/no)'), nl,
    read(Answer),
    ( Answer == yes -> delete_menu_item ; write('Returning to main menu...'), nl, start_chatbot ).

% Customer flow: Get recommendations
customer_recommendation :-
    write('What cuisine do you prefer?'), nl,
    read(Cuisine),
    write('Do you want vegan or non_vegan?'), nl,
    read(Type),
    write('Which meal? (breakfast/lunch/dinner/snack)'), nl,
    read(MealType),
    write('What is your maximum price?'), nl,
    read(MaxPrice),
    findall(Item, recommend(Item, _, _, _, MaxPrice), Items),
    ( Items = [] ->
        write('Sorry, no items match your criteria.'), nl
    ;
        write('Here are some recommendations:'), nl,
        print_items(Items)
    ),
    write('Would you like another recommendation? (yes/no)'), nl,
    read(Answer),
    ( Answer == yes -> customer_recommendation ; write('Goodbye!'), nl ).

% items printer
print_items([]).
print_items([H|T]) :-
    write('- '), write(H), nl,
    print_items(T).
