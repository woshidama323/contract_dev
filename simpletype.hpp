#include <eosiolib/eosio.hpp>
#include <eosiolib/asset.hpp>
#include <string>
using namespace eosio;
using eosio::asset;


namespace simple{

    struct user_ticket{

        uint64_t colleteral_token ;
        uint64_t  col_token_num;
        uint64_t lend_token;
        uint64_t  lend_token_num;
        uint64_t  lend_limit;
        uint64_t  lend_uint64_terest;
        uint64_t  platform_commission;
        uint64_t autoclose;
        //asset quantity;
        //std::string text;
        //name textname;
        
        };
}