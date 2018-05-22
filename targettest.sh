#!/bin/bash  -x


#1.the borrower need to add a new load request to the platform
#actually just create a new contract account to the platform
# and also give the public key  


#dawn4.0中，钱包是定期锁定的，所以这里需要提前unlock
echo "PW5JBUgvLsBDuCTEL8zSWY4qWXwsZULmUN9JMY7NG7XTUbCSMJHoq" |cleos wallet unlock

echo -e "---------------------------------------------------------------------------\n    \
        create eosio.token for create a new token EOS and ZH\n\
---------------------------------------------------------------------------\n"


echo -e "---------------------------------------------------------------------------\n\
cleos get account eosio.eos\n"
cleos get account eosio.eos

if [[ $? -ne 0 ]];then
    cleos create account eosio eosio.eos EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB
fi


echo -e "---------------------------------------------------------------------------\n\
cleos get account eosio.zh\n"
cleos get account eosio.zh

if [[ $? -ne 0 ]];then
    cleos create account eosio eosio.zh EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB
fi


echo -e "---------------------------------------------------------------------------\n\
push the contract on the blockchain\n"
cleos set contract eosio.eos  /Users/easylend/Documents/eos/build/contracts/eosio.token 
cleos set contract eosio.zh  /Users/easylend/Documents/eos/build/contracts/eosio.token 


cleos push action eosio.eos create '["eosio","10000.00 EOS",1,1,1]' -p eosio.eos
cleos push action eosio.zh create '["eosio","10000.00 ZH",1,1,1]' -p eosio.zh

cleos push action eosio.eos issue '["borrower1","100.00 EOS","hello"]' -p eosio
cleos push action eosio.zh issue '["lender1","100.00 ZH","hello"]' -p eosio


#read the pubkey from the keyfile
# pubkey=`cat `

printf "#1---------------------------------------\n"
#1.eosio create accounts borrowers and lenders
#    "EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB","5HyxSWzMnuvzYW7Vgg4zhRXbZdGVY7GoJW5Bs4vf1yG39VfUbsE"

cleos get account borrower1
if [[ $? -ne 0 ]];then
    cleos create account eosio borrower1 EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB
fi
#cleos create account eosio borrower1 EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB
#cleos create account eosio borrower1 EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB

cleos get account lender1
if [[ $? -ne 0 ]];then
    cleos create account eosio lender1 EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB
fi
#cleos create account eosio lender2 EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB
#cleos create account eosio lender3 EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB



#cleos set account permission tester active '{"threshold": 1,"keys": [{"key": "EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB","weight": 1}],"accounts": [{"permission":{"actor":"testlend","permission":"active"},"weight":1}]}' owner -p tester

printf "#2-------------------compiling the contract--------------------\n"
#2.borrower1 would create a loan request on the platform 
#here the testlend contract account would be used at the next time
./buildsimple.sh lender1



printf "#3---------------------------------------\n"
#3 fill the requirement information and then submit it to the blockchain
cleos push action borrower1 addticket '["borrower1",1,1,1,1,1,1,1,1,"100.00 EOS"]' -p borrower1

printf "#4---------------------------------------\n"
#4 lender would response the request and then transfer the fund to the borrower
cleos push action eosio.zh transfer '["lender1","borrower1","10.00 ZH","response the load request"]' -p lender1


printf "#5---------------------------------------\n"
#5 if time's up, the borrower need to back the tokens to the lenders
cleos push action eosio.eos transfer '["borrower1","lender1","100.00 EOS","try to back fund to lender1"]' -p borrower1



#为合约增加授权 从 loan的创建者到合约账户。
echo -n "----------------------------------------\nadd the new permission to the contract account"
cleos set account permission borrower1 active '{"threshold": 1,"keys": [{"key": "EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB","weight": 1}],"accounts": [{"permission":{"actor":"borrower1","permission":"eosio.code"},"weight":1}]}' owner -p borrower1

printf "#6---------------------------------------\n"
#6 but the borrower hasn't back the tokens to the lender.
cleos push action borrower1 borrow2contr '["borrower1","lender1","1.00 EOS","hello"]' -p borrower1

printf "#7---------------------------------------\n"
#6 but the borrower hasn't back the tokens to the lender.
#cleos push action borrower1 contr2lend '["lender1","100.00 EOS","hello"]' -p borrower1


#本地需要创建一个钱包，这样的话给平台用，当一个账户被创建出来的时候，一个钱包也相应陪创建出来，然后，
#1.平台可以直接用这个钱包在  合约账户《----》lender 之间进行  合约账户《----》borrower 之间进行 交易

#2.用borrower的公钥进行交易。 需要合约账户得到borrower的授权。




 
