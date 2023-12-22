# Ruby CLI shopping cart simulation
This is a demo app which simulates a cash register. It loads products from the text DB and creates an object for each one of them. 
When a product is scanned it's added to a single `cart` object as a `cart_item` object with quantity. Adding multiple items of the same product will increment the item's quantity.

## Installation
```
bundle
```
## Configuration
Configuration file `config.json` contains the currency and discount rules for specified SKUs.

## Extending discounts
Discount calculations are specified in separate classes in `app/discount` folder. To add a new rule you need to create a new class, require it in the `Cart` class and append the rule in `config.json`, where the name of the rule has to match created class name.

## DB
Sample database is located in `data/products.csv`

## Execution
This app runs in a command line. Start the program with `./start.sh` and follow the instructions. You need to input product SKUs one by one to simulate the scan. 
After entering all SKUs type 'exit'. That will simulate checkout and apply discounts. The discounted price is represented by **Final price**.
<br/><br/>Here is the example flow:
```
./start.sh

Enter SKU (or 'exit'): GR1
Scanned: GR1
Enter SKU (or 'exit'): CF1
Scanned: CF1
Enter SKU (or 'exit'): SR1
Scanned: SR1
Enter SKU (or 'exit'): CF1
Scanned: CF1
Enter SKU (or 'exit'): CF1
Scanned: CF1
Enter SKU (or 'exit'): exit
Checkout...
-------------------------------
SKU  NAME           PRICE   QTY
GR1  Green Tea      €3.11   1
CF1  Coffee         €11.23  3
SR1  Strawberries   €5.00   1

Total price: €41.80
Discount: €11.23
Final price: €30.57
```

## Running tests
```
rspec
```
