#include <eosiolib/eosio.hpp>
#include "simpletype.hpp"
#include <eosiolib/contract.hpp>
#include <vector>
#include <string>
using namespace eosio;

/*
 * this elcontract class is the contract itself
 * it inherits from eosio::contract class (that defines _self)
 */
class elcontract : public eosio::contract
{
    public:
/* this is the public constructor of the elcontract class
 * it has a single argument "account_name self", the account deploying it to the chain
 * as per the link below, we can initialize its fields in a list
 * those fields, or attributes, are defined by the structs "contract"
 * (inherited from the eosio::contract class) and "messages"
 * "contract" has its own constructor and it is used to re-pass the deployer account
 * "messages" is a multi_index and its constructor needs two arguments,
 * we pass the now defined _self inherited from the eosio::contract class
 * https://www.tutorialspoint.com/cplusplus/cpp_constructor_destructor.htm
 */
        elcontract(account_name self) : contract(self), messagestab(_self,_self) {}

/*
 * addmessage is a public action that a user can call from the contract using:
 * eosc push action elcontract addmessage "params"
 * these params are the method arguments (see elcontract.sh for more details)
 * for correct generation of the contract abi, we need to mark it for the interpreter
 * thus the use of "// @abi action"
 */

        // @abi action
        void addticket( 
                        account_name borrower,    //borrower name
                        account_name lender,       //lender name
                        uint64_t     contrtime,    //contract time  (day)
                        uint64_t     timeleft,     //left time      (day)
                        account_name tokentypebr,  //the token type of borrower
                        account_name tokentypele,  //the token type of lender
                        uint64_t     bramount,     //borrower deposit the number of token
                        std::string  loanstat,     //the status of ticket
                        std::string       memo
                      )
        {
            require_auth(borrower);

            auto iter = messagestab.emplace( _self, [&](auto& vmsg) {
                vmsg.ticketid = messagestab.available_primary_key();
                vmsg.borrower = borrower;        //borrower name
                vmsg.lender   = lender;          //lender name
                vmsg.contrtime= contrtime;       //contract time  (day)
                vmsg.timeleft = timeleft;        //left time      (day)
                vmsg.tokentypebr = tokentypebr;  //the token type of borrower
                vmsg.tokentypele = tokentypele;  //the token type of lender
                vmsg.bramount    = bramount;     //borrower deposit the number of token
                vmsg.loanstat    = loanstat;     //the status of ticket
                vmsg.memo        = memo;
            } );
            eosio::print("what is iterator ", iter->ticketid); 
            eosio::print("table's name: test --------------------");
        }

        void changeticket(
                        uint64_t ticketid = 0,    //ticket id is unique
                        account_name lender   = 0,       //lender name
                        std::string  loanstat = "",     //the status of ticket
                        std::string  memo = ""
                        )
        {
            eosio::print("changing the table memo : ", memo.c_str());

            msg msgtable(_self,_self);
            auto it = msgtable.find(ticketid);
            eosio::print("do i get that : ", ticketid);

            msgtable.modify(it,_self,[&](auto & p){
                if( lender != 0)
                    p.lender = lender;
                if( loanstat == "")
                    p.loanstat = "waiting";
                else
                    p.loanstat = loanstat;
            });
        }

        // @abi action
        void borrow2contr(account_name borrower,account_name lender,asset shouldback,std::string text ){

            require_auth(borrower);

            //get the table content
            auto itertab = messagestab.find(0);

            for(;itertab != messagestab.end(); itertab++){
                eosio::print("look up for testing:", itertab->memo,"------------");
            }


            //get something by using borrower index
            auto poster_index = messagestab.template get_index<N(byborr)>();
            auto index = poster_index.find(borrower);
            for(;index != poster_index.end(); index++){
                eosio::print("look up for index:", index->memo);
            }

            //get something by using borrower index
            auto lend_index = messagestab.template get_index<N(bylender)>();
            auto indexl = lend_index.find(borrower);
            for(;indexl != lend_index.end(); indexl++){
                eosio::print("look up for index:", indexl->memo);
            }
        }

        // @abi action
        //do this action when the contract is finished.
        void contr2lend(account_name lender,asset shouldback,std::string text ){
            
            action(
                permission_level{ _self, N(active) },
                N(eosio.token), N(transfer),
                std::make_tuple(_self, lender, shouldback,std::string(""))
            ).send();
        }

        // @abi action
        void resettable()
        {
            msg msgtable(_self,_self);

            eosio::print("..........you are deleting your whole table content..........");

            auto it = msgtable.begin();

            while(it != msgtable.end()) {
                it = msgtable.erase(it);
            }
        }

        // @abi action
        void finishloan(){
            msg msgtable(_self,_self);
            auto it = msgtable.begin();
            while(it != msgtable.end()) {
                if(it->loanstat == "finish"){
                    it = msgtable.erase(it);
                }
            }
        }

        //only the ticket which marked with "waiting" would be checked.
        // @abi action
        void chlefttime (uint64_t ticketid)
        {
            msg msgtable(_self,_self);
            auto it = msgtable.find(ticketid);

            msgtable.modify(it,_self,[&](auto & p){
                p.timeleft--;
                eosio::print("left time is :",p.timeleft);
                if(it->timeleft == 0)
                    p.loanstat = "finish";
            });

        }

    private:
/*
 * this is the struct defining the actual table in the chain database,
 * with its columns and keys
 * analogous for defining public actions, we need to make use of "// @abi table"
 * to properly generate the contract abi
 */
        // @abi table messages i64
        struct message
        {
            uint64_t ticketid = 0;
            account_name borrower;     //borrower name
            account_name lender;       //lender name
            uint64_t     contrtime;    //contract time  (day)
            uint64_t     timeleft;     //left time      (day)
            account_name tokentypebr;  //the token type of borrower
            account_name tokentypele;  //the token type of lender
            uint64_t     bramount;     //borrower deposit the number of token
            std::string  loanstat;     //the status of ticket
            std::string  memo;         //the memo for a table

/*
 * the following line define the column id as the primary key
 * it is possible to define secondary keys and more
 */
            uint64_t primary_key() const { return ticketid; }
            account_name getborr() const { return borrower; }
            account_name getlender() const { return lender; }
/*
*add the second index 
*/


/*
 * we need to serialize its data for internal use of the protocol library
 */
            EOSLIB_SERIALIZE( message, (ticketid)(borrower)(lender)(contrtime)(timeleft)(tokentypebr)(tokentypele)(bramount)(loanstat)(memo));
        };

/*
 * this is the actual attribute of the contract that we initialized in the constructor
 * it provides a neat interface to interact with the database,
 * as seen in the addmessage method
 */
        typedef eosio::multi_index<N(messages), message, indexed_by<N(byborr),const_mem_fun<message,account_name,&message::getborr>>, indexed_by<N(bylender),const_mem_fun<message,account_name,&message::getlender>> > msg;
        msg messagestab;
};

/*
 * this line is necessary to properly generate the contract abi
 */
EOSIO_ABI( elcontract, (addticket)(borrow2contr)(contr2lend)(resettable)(changeticket)(finishloan)(chlefttime));
