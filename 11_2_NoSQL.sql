-- task 1, 2, 3

hset ip 127.0.0.1 1

SET Tom tom@mail.ru
SET tom@mail.ru Tom
GET TOM
GET tom@mail.ru

db.shop.insert({category: 'Stationary'})
db.shop.insert({category: 'Chemist})

db.shop.update({category: 'Stationary'}, {$set: {items:['pen', 'pencil', 'notebook'] }})
db.shop.UPDATE({category: 'Chemist'}, {$set: {items:['drugs', 'pills', 'medicine'] }})
