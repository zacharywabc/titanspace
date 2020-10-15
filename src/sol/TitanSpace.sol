pragma solidity ^0.5.9;

contract Tspace {
    
    struct User {
        uint256 cycle; // 周期
        address upline; // 邀请人（上线）
        uint256 referrals; // 邀请人数
        uint256 payouts; // 当前累计提现金额（存款提现金额 + 直接分红提现金额 + 奖池分红提现金额 + 合伙人级别提现金额）
        uint256 direct_bonus; // 当前直接分红的余额
        uint256 pool_bonus; // 当前奖池分红的余额
        uint256 match_bonus; // 当前合伙人级别分红的余额
        uint256 deposit_amount; // 当前存款金额
        uint256 deposit_payouts; // 当前存款累计提现金额
        uint40 deposit_time; // 当前存款时间
        uint256 total_deposits; // 总的存款金额
        uint256 total_payouts; // 总的提现金额
        uint256 total_structure; 
    }
    
    struct UserMining {
        uint256 mining_rewards; // 当前挖矿奖励的余额
        uint256 total_mining_rewards; // 总的挖矿奖励金额
        uint256 total_mining_payouts; // 总的挖矿提现金额
    }
    
    address payable public owner;
    address payable public etherchain_fund;
    address payable public admin_fee;
    address payable public tsc_contract_address;
    address payable public tsc_mining_from_address;
    
    mapping(address => User) public users;
    mapping(address => UserMining) public users_mining;

    uint256[] public cycles;
    uint8[] public dynamic_factors;
    uint8[] public ref_bonuses;                     // 1 => 1%

    uint8[] public pool_bonuses;                    // 1 => 1%
    uint40 public pool_last_draw = uint40(block.timestamp);
    uint256 public pool_cycle;
    uint256 public pool_balance;
    mapping(uint256 => mapping(address => uint256)) public pool_users_refs_deposits_sum;
    mapping(uint8 => address) public pool_top;

    uint256 public total_users = 1;
    uint256 public total_deposited;
    uint256 public total_withdraw;
    uint256 public total_token_mined;
    uint256 public total_token_withdraw;
    
    uint256 public max_tsc_amount = 120000000e6;
    
    // uint40 constant public PER_DAY = 1 days;
    // uint40 constant public PER_WEEK = 1 weeks;
    uint40 constant public PER_DAY = 60 minutes;
    uint40 constant public PER_WEEK = 90 minutes;
    uint256 constant public MIN_TSC_WITHDRAW = 20e6;
    
    event Upline(address indexed addr, address indexed upline);
    event NewDeposit(address indexed addr, uint256 amount);
    event DirectPayout(address indexed addr, address indexed from, uint256 amount);
    event MatchPayout(address indexed addr, address indexed from, uint256 amount);
    event PoolPayout(address indexed addr, uint256 amount);
    event Withdraw(address indexed addr, uint256 amount);
    event LimitReached(address indexed addr, uint256 amount);
    event MiningTokenReward(address indexed addr, uint256 amount, uint256 trx_amount);
    event TokenWithdraw(address indexed addr, uint256 indexed total, uint256 indexed amount, uint256 fee);
    event SetMaxTscAmount(address indexed addr, uint256 amount);

    constructor(address payable _owner, address payable _tsc_contract_address, address payable _tsc_mining_from_address) public {
        owner = msg.sender;
        
        etherchain_fund = _owner;
        admin_fee = _owner;
        tsc_contract_address = _tsc_contract_address;
        tsc_mining_from_address = _tsc_mining_from_address;
        
        // Generation bonus
        ref_bonuses.push(24); // 1
        ref_bonuses.push(12); // 2
        ref_bonuses.push(12); // 3
        ref_bonuses.push(12); // 4
        ref_bonuses.push(12); // 5
        ref_bonuses.push(12); // 6
        ref_bonuses.push(8);  // 7
        ref_bonuses.push(8);  // 8
        ref_bonuses.push(8);  // 9
        ref_bonuses.push(4);  // 10
        ref_bonuses.push(4);  // 11
        ref_bonuses.push(4);  // 12
        ref_bonuses.push(2);  // 13
        ref_bonuses.push(2);  // 14
        ref_bonuses.push(2);  // 15

        // Top 10 bonus
        pool_bonuses.push(35);
        pool_bonuses.push(20);
        pool_bonuses.push(10);
        pool_bonuses.push(5);
        pool_bonuses.push(5);
        pool_bonuses.push(5);
        pool_bonuses.push(5);
        pool_bonuses.push(5);
        pool_bonuses.push(5);
        pool_bonuses.push(5);

        cycles.push(1e11); //   100,000 trx
        cycles.push(3e11); //   300,000 trx
        cycles.push(9e11); //   900,000 trx
        cycles.push(2e12); // 2,000,000 trx
        
        dynamic_factors.push(24);
        dynamic_factors.push(20);
        dynamic_factors.push(18);
        dynamic_factors.push(15);
        dynamic_factors.push(12);
        dynamic_factors.push(8);
        dynamic_factors.push(6);
        dynamic_factors.push(3);
        dynamic_factors.push(3);
        dynamic_factors.push(3);
        dynamic_factors.push(3);
        dynamic_factors.push(3);
    }

    function() payable external {
        _deposit(msg.sender, msg.value);
    }

    function _setUpline(address _addr, address _upline) private {
        if(users[_addr].upline == address(0) && _upline != _addr && _addr != owner && (users[_upline].deposit_time > 0 || _upline == owner)) {
            users[_addr].upline = _upline;
            users[_upline].referrals++;

            emit Upline(_addr, _upline);

            total_users++;

            for(uint8 i = 0; i < ref_bonuses.length; i++) {
                if(_upline == address(0)) break;

                users[_upline].total_structure++;

                _upline = users[_upline].upline;
            }
        }
    }

    function _deposit(address _addr, uint256 _amount) private {
        require(users[_addr].upline != address(0) || _addr == owner, "No upline");

        if(users[_addr].deposit_time > 0) {
            users[_addr].cycle++;
            
            require(users[_addr].payouts >= this.maxPayoutOf(users[_addr].deposit_amount), "Deposit already exists");
            require(_amount >= users[_addr].deposit_amount && _amount <= cycles[users[_addr].cycle > cycles.length - 1 ? cycles.length - 1 : users[_addr].cycle], "Bad amount");
        }
        else require(_amount >= 1e8 && _amount <= cycles[0], "Bad amount");
        
        users[_addr].payouts = 0;
        users[_addr].deposit_amount = _amount;
        users[_addr].deposit_payouts = 0;
        users[_addr].deposit_time = uint40(block.timestamp);
        users[_addr].total_deposits += _amount;

        total_deposited += _amount;
        
        _miningRewards(_addr, _amount, true);
        
        emit NewDeposit(_addr, _amount);

        if(users[_addr].upline != address(0)) {
            users[users[_addr].upline].direct_bonus += _amount * 10 / 100;
            
            _miningRewards(users[_addr].upline, _amount * 10 / 100, false);
            
            emit DirectPayout(users[_addr].upline, _addr, _amount * 10 / 100);
        }

        _poolDeposits(_addr, _amount);

        if(pool_last_draw + PER_DAY < block.timestamp) {
            _drawPool();
        }

        admin_fee.transfer(_amount * 2 / 100);
        etherchain_fund.transfer(_amount * 3 / 100);
        
    }

    function _poolDeposits(address _addr, uint256 _amount) private {
        pool_balance += _amount * 3 / 100;

        address upline = users[_addr].upline;

        if(upline == address(0)) return;
        
        pool_users_refs_deposits_sum[pool_cycle][upline] += _amount;

        for(uint8 i = 0; i < pool_bonuses.length; i++) {
            if(pool_top[i] == upline) break;

            if(pool_top[i] == address(0)) {
                pool_top[i] = upline;
                break;
            }

            if(pool_users_refs_deposits_sum[pool_cycle][upline] > pool_users_refs_deposits_sum[pool_cycle][pool_top[i]]) {
                for(uint8 j = i + 1; j < pool_bonuses.length; j++) {
                    if(pool_top[j] == upline) {
                        for(uint8 k = j; k <= pool_bonuses.length; k++) {
                            pool_top[k] = pool_top[k + 1];
                        }
                        break;
                    }
                }

                for(uint8 j = uint8(pool_bonuses.length - 1); j > i; j--) {
                    pool_top[j] = pool_top[j - 1];
                }

                pool_top[i] = upline;

                break;
            }
        }
    }

    function _refPayout(address _addr, uint256 _amount) private {
        address up = users[_addr].upline;

        for(uint8 i = 0; i < ref_bonuses.length; i++) {
            if(up == address(0)) break;
            
            if(users[up].referrals >= i + 1) {
                uint256 bonus = _amount * ref_bonuses[i] / 100;
                
                users[up].match_bonus += bonus;
                
                _miningRewards(up, bonus, false);

                emit MatchPayout(up, _addr, bonus);
            }

            up = users[up].upline;
        }
    }

    function _drawPool() private {
        pool_last_draw = uint40(block.timestamp);
        pool_cycle++;

        // 10 percent 
        uint256 draw_amount = pool_balance * 10 / 100;

        // Payout top 10 bonus
        for(uint8 i = 0; i < pool_bonuses.length; i++) {
            if(pool_top[i] == address(0)) break;

            uint256 win = draw_amount * pool_bonuses[i] / 100;

            users[pool_top[i]].pool_bonus += win;
            pool_balance -= win;
            
            _miningRewards(pool_top[i], win, false);

            emit PoolPayout(pool_top[i], win);
        }
        
        // Clear top 10 data
        for(uint8 i = 0; i < pool_bonuses.length; i++) {
            pool_top[i] = address(0);
        }
    }
    
    function _miningRewards(address _addr, uint256 _amount, bool _is_new_deposit) private {
        uint256 token_amount = 0;
        if (_is_new_deposit) {
            token_amount = _amount * 10 / 100;
        } else {
            uint8 dynamic_factor = this.dynamicFactorOf(_addr);
            if (dynamic_factor > 0) {
                token_amount = _amount * dynamic_factor * 10 / 100;
            }
        }
        
        if (token_amount > 0 && (total_token_mined + token_amount <= max_tsc_amount)) {
            users_mining[_addr].mining_rewards += token_amount;
            users_mining[_addr].total_mining_rewards += token_amount;
            
            total_token_mined += token_amount;
            
            emit MiningTokenReward(_addr, token_amount, _amount);
        }
    }

    function deposit(address _upline) payable external {
        _setUpline(msg.sender, _upline);
        _deposit(msg.sender, msg.value);
    }

    function withdraw() external {
        (uint256 to_payout, uint256 max_payout) = this.payoutOf(msg.sender);
        
        require(users[msg.sender].payouts < max_payout, "Full payouts");

        // Deposit payout
        if(to_payout > 0) {
            if(users[msg.sender].payouts + to_payout > max_payout) {
                to_payout = max_payout - users[msg.sender].payouts;
            }

            users[msg.sender].deposit_payouts += to_payout;
            users[msg.sender].payouts += to_payout;

            _refPayout(msg.sender, to_payout);
        }
        
        // Direct payout
        if(users[msg.sender].payouts < max_payout && users[msg.sender].direct_bonus > 0) {
            uint256 direct_bonus = users[msg.sender].direct_bonus;

            if(users[msg.sender].payouts + direct_bonus > max_payout) {
                direct_bonus = max_payout - users[msg.sender].payouts;
            }

            users[msg.sender].direct_bonus -= direct_bonus;
            users[msg.sender].payouts += direct_bonus;
            to_payout += direct_bonus;
        }
        
        // Pool payout
        if(users[msg.sender].payouts < max_payout && users[msg.sender].pool_bonus > 0) {
            uint256 pool_bonus = users[msg.sender].pool_bonus;

            if(users[msg.sender].payouts + pool_bonus > max_payout) {
                pool_bonus = max_payout - users[msg.sender].payouts;
            }

            users[msg.sender].pool_bonus -= pool_bonus;
            users[msg.sender].payouts += pool_bonus;
            to_payout += pool_bonus;
        }

        // Match payout
        if(users[msg.sender].payouts < max_payout && users[msg.sender].match_bonus > 0) {
            uint256 match_bonus = users[msg.sender].match_bonus;

            if(users[msg.sender].payouts + match_bonus > max_payout) {
                match_bonus = max_payout - users[msg.sender].payouts;
            }

            users[msg.sender].match_bonus -= match_bonus;
            users[msg.sender].payouts += match_bonus;
            to_payout += match_bonus;
        }

        require(to_payout > 0, "Zero payout");
        
        users[msg.sender].total_payouts += to_payout;
        total_withdraw += to_payout;

        msg.sender.transfer(to_payout);

        emit Withdraw(msg.sender, to_payout);

        if(users[msg.sender].payouts >= max_payout) {
            emit LimitReached(msg.sender, users[msg.sender].payouts);
        }
    }
    
    function tokenWithdraw() external {
        require(users_mining[msg.sender].mining_rewards >= MIN_TSC_WITHDRAW, "Must be greater than min");
        
        uint256 mining_rewards = users_mining[msg.sender].mining_rewards;
        users_mining[msg.sender].mining_rewards = 0;
        
        uint256 user_rewards = mining_rewards * 99 / 100;
        users_mining[msg.sender].total_mining_payouts += mining_rewards;
        total_token_withdraw += mining_rewards;
        
        // transfer token to msg.sender
        ITRC20(tsc_contract_address).transferFrom(tsc_mining_from_address, msg.sender, user_rewards);
        
        // admin_fee
        ITRC20(tsc_contract_address).transferFrom(tsc_mining_from_address, admin_fee, mining_rewards - user_rewards);
        
        emit TokenWithdraw(msg.sender, mining_rewards, user_rewards, mining_rewards - user_rewards);
    }
    
    function setMaxTscAmount(uint256 _max_tsc_amount) external {
        require(msg.sender == owner, "Only owner");
        require(_max_tsc_amount > max_tsc_amount, "Invalid amount");
        
        max_tsc_amount = _max_tsc_amount;
        
        emit SetMaxTscAmount(msg.sender, _max_tsc_amount);
    }
    
    function availablePayoutOf(address _addr) view external returns(uint256) {
        (uint256 to_payout, uint256 max_payout) = this.payoutOf(_addr);
        
        uint256 userPayOuts = users[_addr].payouts;
        
        // Deposit payout
        if(to_payout > 0) {
            if(userPayOuts + to_payout > max_payout) {
                to_payout = max_payout - userPayOuts;
            }
            userPayOuts += to_payout;
        }
        
        // Direct payout
        if(userPayOuts < max_payout && users[_addr].direct_bonus > 0) {
            uint256 direct_bonus = users[_addr].direct_bonus;

            if(userPayOuts + direct_bonus > max_payout) {
                direct_bonus = max_payout - userPayOuts;
            }
            
            userPayOuts += direct_bonus;
            to_payout += direct_bonus;
        }
        
        // Pool payout
        if(userPayOuts < max_payout && users[_addr].pool_bonus > 0) {
            uint256 pool_bonus = users[_addr].pool_bonus;

            if(userPayOuts + pool_bonus > max_payout) {
                pool_bonus = max_payout - userPayOuts;
            }
            
            userPayOuts += pool_bonus;
            to_payout += pool_bonus;
        }

        // Match payout
        if(userPayOuts < max_payout && users[_addr].match_bonus > 0) {
            uint256 match_bonus = users[_addr].match_bonus;

            if(userPayOuts + match_bonus > max_payout) {
                match_bonus = max_payout - userPayOuts;
            }
            
            userPayOuts += match_bonus;
            to_payout += match_bonus;
        }
        
        if(userPayOuts >= max_payout){
            return 0;
        }
        
        return to_payout;
    }

    function maxPayoutOf(uint256 _amount) pure external returns(uint256) {
        return _amount * 1618 / 1000; // 1.618 times
    }

    function payoutOf(address _addr) view external returns(uint256 payout, uint256 max_payout) {
        max_payout = this.maxPayoutOf(users[_addr].deposit_amount);

        if(users[_addr].deposit_payouts < max_payout) {
            payout = (users[_addr].deposit_amount * ((block.timestamp - users[_addr].deposit_time) / PER_DAY) / 100) - users[_addr].deposit_payouts;
            
            if(users[_addr].deposit_payouts + payout > max_payout) {
                payout = max_payout - users[_addr].deposit_payouts;
            }
        }
    }

    function dynamicFactorOf(address _addr) view external returns(uint8 dynamic_factor) {
        if (users[_addr].deposit_time > 0) {
            uint week_n = (block.timestamp - users[_addr].deposit_time) / PER_WEEK;
            dynamic_factor = week_n >= dynamic_factors.length ? 0 : dynamic_factors[week_n];
        } 
    }

    /*
        Only external call
    */
    function userInfo(address _addr) view external returns(address upline, uint40 deposit_time, uint256 deposit_amount, uint256 payouts, uint256 direct_bonus, uint256 pool_bonus, uint256 match_bonus) {
        return (users[_addr].upline, users[_addr].deposit_time, users[_addr].deposit_amount, users[_addr].payouts, users[_addr].direct_bonus, users[_addr].pool_bonus, users[_addr].match_bonus);
    }

    function userInfoTotals(address _addr) view external returns(uint256 referrals, uint256 total_deposits, uint256 total_payouts, uint256 total_structure) {
        return (users[_addr].referrals, users[_addr].total_deposits, users[_addr].total_payouts, users[_addr].total_structure);
    }

    function contractInfo() view external returns(uint256 _trx_balance, uint256 _total_users, uint256 _total_deposited, uint256 _total_withdraw, uint40 _pool_last_draw, uint256 _pool_balance, uint256 _pool_lider, uint256 _total_token_mined, uint256 _total_token_withdraw) {
        return (address(this).balance, total_users, total_deposited, total_withdraw, pool_last_draw, pool_balance, pool_users_refs_deposits_sum[pool_cycle][pool_top[0]], total_token_mined, total_token_withdraw);
    }

    function poolTopInfo() view external returns(address[4] memory addrs, uint256[4] memory deps) {
        for(uint8 i = 0; i < pool_bonuses.length; i++) {
            if(pool_top[i] == address(0)) break;

            addrs[i] = pool_top[i];
            deps[i] = pool_users_refs_deposits_sum[pool_cycle][pool_top[i]];
        }
    }
}

interface ITRC20 {

    function totalSupply() external returns (uint supply);
    
    function balanceOf(address _owner)  external returns (uint balance);
    
    function transfer(address _to, uint _value) external returns (bool success);

    function transferFrom(address _from, address _to, uint _value) external returns (bool success);

    function approve(address _spender, uint _value) external returns (bool success);

    function allowance(address _owner, address _spender) external returns (uint remaining);

    event Transfer(address indexed _from, address indexed _to, uint _value);
    event Approval(address indexed _owner, address indexed _spender, uint _value);
}