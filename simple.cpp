#include <eosiolib/eosio.hpp>
#include "simpletype.hpp"
#include <vector>
using namespace eosio;

/*
 * this simpledb class is the contract itself
 * it inherits from eosio::contract class (that defines _self)
 */
class simpledb : public eosio::contract
{
    public:
/* this is the public constructor of the simpledb class
 * it has a single argument "account_name self", the account deploying it to the chain
 * as per the link below, we can initialize its fields in a list
 * those fields, or attributes, are defined by the structs "contract"
 * (inherited from the eosio::contract class) and "messages"
 * "contract" has its own constructor and it is used to re-pass the deployer account
 * "messages" is a multi_index and its constructor needs two arguments,
 * we pass the now defined _self inherited from the eosio::contract class
 * https://www.tutorialspoint.com/cplusplus/cpp_constructor_destructor.htm
 */
        simpledb(account_name self) : contract(self), messages(_self,_self) {}

/*
 * addmessage is a public action that a user can call from the contract using:
 * eosc push action simpledb addmessage "params"
 * these params are the method arguments (see simpledb.sh for more details)
 * for correct generation of the contract abi, we need to mark it for the interpreter
 * thus the use of "// @abi action"
 */
        // @abi action
        void addmessage( account_name sender, std::string text )
        {
/*
 * require_auth is self explanatory, a user can only be considered "sender" if
 * he has authority
 */
            require_auth(sender);

/*
 * here we define an iterator for the multi_index as the return value from the call
 * to its emplace method (that inserts a new row), see the link below for more details
 * https://www.boost.org/doc/libs/1_66_0/libs/multi_index/doc/index.html
 * for each column of the table, as defined in its struct, has to be filled
 */

            //hello
            simple::user_ticket hello;
            hello.colleteral_token = 1;
            //hello.textname.value = N("waht");
            //eosio::print("hwll");
            
            auto iter = messages.emplace( _self, [&](auto& message) {
                message.id = messages.available_primary_key();
                message.sender.emplace_back(sender);
                //message.text = text;
                message.text.emplace_back(hello);

            } );


            
            eosio::print("what is iterator ", iter->id); 
            
            eosio::print("what is iterator ", iter->id); 


            eosio::print("the size of vector",iter->sender.size());
            // eosio::print("the size of vector",iter->sender.size());
            auto tempid = iter->id;

            // iter--;
            //eosio::print("hello",(iter->text.text).c_str());


            // for(uint64_t i=0; i<tempid;i++){

            //     eosio::print("-----:",i,(iter->text).c_str());
            //     iter--;
            // }

            eosio::print("get_code:",messages.get_code());

            eosio::print("get_scope:",messages.get_scope());

            eosio::print("what are you talking:",(messages.begin())->id);
            //why end can't be used in  this case
            //eosio::print("get the right one",messages.get(N("messages")).id);
            //eosio::print("what are you talking:",(messages.end())->id);

        }


        // @abi action
        void querymessage( account_name sender, std::string text )
        {

            require_auth(sender);

            //eosio::multi_index<N(messages),message>::const_iterator::iterator it;

            auto it = messages.begin();

            
            auto itend = --messages.end();

            vector<int> whatint;
            whatint.emplace_back(12);
            vector<int>::iterator intit;

            
            for(auto i=whatint.begin();i!=whatint.end();i++){

                 print("just test:",*i);
            }
            
            if(messages.find(N("sender")) == messages.end())
            print("haven't found the problem");
            eosio::print("table's name:",messages.find(2)->id);

            eosio::print("table's name:",itend->id);
            
            }

        // @abi action
        void addticket( account_name sender, uint64_t colleteral_token, 
                        uint64_t  col_token_num_l, 
                        uint64_t  lend_token_l, 
                        uint64_t  lend_token_num_l,
                        uint64_t  lend_limit_l,
                        uint64_t  lend_uint64_terest_l,
                        uint64_t  platform_commission_l,
                        uint64_t  autoclose_l )
        {
        // uint64_t colleteral_token ;
        // uint64_t  col_token_num;
        // uint64_t lend_token;
        // uint64_t  lend_token_num;
        // uint64_t  lend_limit;
        // uint64_t  lend_uint64_terest;
        // uint64_t  platform_commission;
        // uint64_t autoclose;
            require_auth(sender);

            auto targetid = messages.find(0);
            eosio_assert(targetid != messages.end(),"can't find targetid");

            simple::user_ticket userticket;
            userticket.colleteral_token = colleteral_token;
            userticket.col_token_num = col_token_num_l;
            userticket.lend_token = lend_token_l;
            userticket.lend_token_num = lend_token_num_l;
            userticket.lend_limit = lend_limit_l;
            userticket.lend_uint64_terest = lend_uint64_terest_l;
            userticket.platform_commission = platform_commission_l;
            userticket.autoclose = autoclose_l;

            messages.modify(targetid,_self,[&](auto &p_tikict){
                p_tikict.text.emplace_back(userticket);
            });

            print("the size of table text", targetid->text.size());
            
            eosio::print("table's name:");
                        eosio::print("table's name:");
        }
    private:
/*
 * this is the struct defining the actual table in the chain database,
 * with its columns and keys
 * analogous for defining public actions, we need to make use of "// @abi table"
 * to properly generate the contract abi
 */


        struct message
        {
            uint64_t id = 0;
            vector<account_name> sender;
            vector<simple::user_ticket> text;
            //user_ticket text;
            //  vector<account_name> text;
/*
 * the following line define the column id as the primary key
 * it is possible to define secondary keys and more
 */
            uint32_t primary_key() const { return id; }
/*
 * we need to serialize its data for internal use of the protocol library
 */
            EOSLIB_SERIALIZE( message, (id)(sender)(text));
        };

/*
 * this is the actual attribute of the contract that we initialized in the constructor
 * it provides a neat interface to interact with the database,
 * as seen in the addmessage method
 */
        eosio::multi_index<N(messages), message> messages;
};

/*
 * this line is necessary to properly generate the contract abi
 */
EOSIO_ABI( simpledb, (addmessage)(querymessage)(addticket));
