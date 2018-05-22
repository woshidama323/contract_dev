#!/bin/bash  -x


#1.the borrower need to add a new load request to the platform
#actually just create a new contract account to the platform
# and also give the public key  


#dawn4.0中，钱包是定期锁定的，所以这里需要提前unlock
#echo "PW5JBUgvLsBDuCTEL8zSWY4qWXwsZULmUN9JMY7NG7XTUbCSMJHoq" |cleos wallet unlock

echo `tail -n1 log`|cleos wallet unlock

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
cleos push action eosio.eos issue '["borrower2","100.00 EOS","hello"]' -p eosio
cleos push action eosio.eos issue '["borrower3","100.00 EOS","hello"]' -p eosio
cleos push action eosio.eos issue '["borrower4","100.00 EOS","hello"]' -p eosio
cleos push action eosio.eos issue '["borrower5","100.00 EOS","hello"]' -p eosio



cleos push action eosio.zh issue '["lender1","100.00 ZH","hello"]' -p eosio
cleos push action eosio.zh issue '["lender2","100.00 ZH","hello"]' -p eosio
cleos push action eosio.zh issue '["lender3","100.00 ZH","hello"]' -p eosio
cleos push action eosio.zh issue '["lender4","100.00 ZH","hello"]' -p eosio
cleos push action eosio.zh issue '["lender5","100.00 ZH","hello"]' -p eosio


#read the pubkey from the keyfile
# pubkey=`cat `

printf "#1---------------------------------------\n"
#1.eosio create accounts borrowers and lenders
#    "EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB","5HyxSWzMnuvzYW7Vgg4zhRXbZdGVY7GoJW5Bs4vf1yG39VfUbsE"

cleos get account borrower1
if [[ $? -ne 0 ]];then
    cleos create account eosio borrower1 EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB
fi
cleos get account borrower2
if [[ $? -ne 0 ]];then
    cleos create account eosio borrower2 EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB
fi
cleos get account borrower3
if [[ $? -ne 0 ]];then
    cleos create account eosio borrower3 EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB
fi
cleos get account borrower4
if [[ $? -ne 0 ]];then
    cleos create account eosio borrower4 EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB
fi
cleos get account borrower5
if [[ $? -ne 0 ]];then
    cleos create account eosio borrower5 EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB
fi


cleos get account lender1
if [[ $? -ne 0 ]];then
    cleos create account eosio lender1 EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB
fi
cleos get account lender2
if [[ $? -ne 0 ]];then
    cleos create account eosio lender2 EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB
fi
cleos get account lender3
if [[ $? -ne 0 ]];then
    cleos create account eosio lender3 EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB
fi
cleos get account lender4
if [[ $? -ne 0 ]];then
    cleos create account eosio lender4 EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB
fi
cleos get account lender5
if [[ $? -ne 0 ]];then
    cleos create account eosio lender5 EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB
fi

printf "#3---------------------------------------\n"
#3 fill the requirement information and then submit it to the blockchain
#重复的部分需要前端过滤。
if [[ $1 == "addt" ]];then
cleos push action hellotable addticket '["borrower1","",10,10,"eos","zh",100,"creating","ticket1"]' -p borrower1
cleos push action hellotable addticket '["borrower2","",10,10,"eos","zh",100,"creating","ticket2"]' -p borrower2
cleos push action hellotable addticket '["borrower3","",10,10,"eos","zh",100,"creating","ticket3"]' -p borrower3
cleos push action hellotable addticket '["borrower4","",10,10,"eos","zh",100,"creating","ticket4"]' -p borrower4
cleos push action hellotable addticket '["borrower5","",10,10,"eos","zh",100,"creating","ticket5"]' -p borrower5
fi

#为合约增加授权 从 loan的创建者到合约账户。
echo -n "----------------------------------------\nadd the new permission to the contract account"
cleos set account permission borrower1 active '{"threshold": 1,"keys": [{"key": "EOS6eYSBt7tWdLi145uMu5DTmykKmngn3Q8bPuBunek7yqB1cNuwB","weight": 1}],"accounts": [{"permission":{"actor":"hellotable","permission":"eosio.code"},"weight":1}]}' owner -p borrower1


cleos push action hellotable changeticket '[1,"lender1","","response the"]' -p hellotable

cleos push action hellotable changeticket '[2,"lender2","finish","response the"]' -p hellotable

printf "#6---------------------------------------\n"
#6 but the borrower hasn't back the tokens to the lender.
#cleos push action borrower1 borrow2contr '["borrower1","lender1","1.00 EOS","hello"]' -p borrower1
