#!/bin/bash -x


   rm -rf /Users/easylend/Library/Application\ Support/eosio/nodeos/data/./default.wallet


date >>log
  cleos wallet create>>log

   cleos wallet import 5HyxSWzMnuvzYW7Vgg4zhRXbZdGVY7GoJW5Bs4vf1yG39VfUbsE
   cleos create account  eosio testlend EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB
   cleos create account  eosio tester EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB
   cleos set contract testlend ../testcontract/contract_dev simple.wast simple.abi 
   #cleos push action testlend addmessage '["tester", "hellotester"]' -p tester
