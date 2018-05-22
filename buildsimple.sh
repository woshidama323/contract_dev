#/bin/bash -x
eosiocpp -g elcontract.abi elcontract.cpp && eosiocpp -o elcontract.wast elcontract.cpp

cleos set contract $1 ../contract_dev elcontract.wast elcontract.abi -j

cleos push action hellotestn addticket '["borrower1","lender1",10,5,"eos","zh",100,"creating"]' -p borrower1
