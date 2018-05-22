
#include "test.hpp"
using namespace std;

namespace eosio {
    
    void test_da::create(account_name user, string title, string content)
    {
        require_auth( user );
        string content_he;
        das datable( _self, _self);
        datable.emplace(user, [&]( da & d){
            d.title = title;
            d.content = content;
            //d.content2 = content_he;
            d.post_id = datable.available_primary_key();
            d.poster = user;
        });
    }

}


EOSIO_ABI(eosio::test_da, (create))



