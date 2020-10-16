<template>
  <div class="home">
    <div class="first">
      <div class="header flex align-center">
        <a href="/" class="logo">
          <img src="@/assets/logo1.png" />
        </a>
        <div class="nav flex align-center">
          <div @click="defiShow = true">{{t('DEFI')}}</div>
          <div @click="joinShow = true">{{t('HOW_JOIN')}}</div>
          <div @click="aboutShow = true">{{t('ABOUT')}}</div>
        </div>
        <div class="lang">
          <div class="lang_selected">{{langs[lang] || langs.en}}</div>
          <div class="lang_options">
            <router-link
              v-for="(v, k) in langs"
              :key="k"
              :to="`/?lang=${k}`"
              :class="langSelected(lang, k)">{{v}}</router-link>
          </div>
        </div>
      </div>
      <div class="banner">
        <div class="banner_inner">
          <img class="banner_name" src="@/assets/logo2.png" />
          <div class="banner_desc">{{t('SLOGAN')}}</div>
        </div>
        <img class="banner_bg" src="@/assets/bg-window.png" />
      </div>
    </div>
    <div class="main">
      <div class="stat flex">
        <div>
          <span>{{t('GLOBAL')}}</span>
          <span>{{globalMember}}</span>
        </div>
        <div>
          <span>{{t('TLOCK')}}</span>
          <span>{{totalDepositTrx}} TRX</span>
        </div>
        <div>
          <span>{{t('TRELEASE')}}</span>
          <span>{{totalWithDrawTrx}} TRX <br/> {{totalReleaseTsc}} TSC</span>
        </div>
      </div>

      <Item :title="t('JOIN')">
        <div class="join">
          <div class="join_inp flex align-center justify-between">
            <span v-text="trx" />
            <span>TRX</span>
          </div>
          <div class="join_btns">
            <div @click="incTRX(100)">+ 100 TRX</div>
            <div @click="incTRX(500)">+ 500 TRX</div>
            <div @click="incTRX(1000)">+ 1000 TRX</div>
            <div @click="incTRX(5000)">+ 5K TRX</div>
            <div @click="incTRX(10000)">+ 10K TRX</div>
            <div @click="incTRX(50000)">+ 50K TRX</div>
          </div>
          <div class="actions flex align-center justify-between">
            <Btn @click="setTRX(0)">{{t('CANCEL')}}</Btn>
            <Btn @click="deposit" :loading="loading_w" type="green">{{t('LOCK')}}</Btn>
          </div>
        </div>
      </Item>

      <Item :title="t('SMART')">
        <div>
          <div class="text_row"><span>{{t('SMART_ADD')}}</span><span>{{contractAddress}}</span></div>
          <div class="text_row"><span>{{t('SMART_TOTAL')}}</span><span>{{totalDepositTrx}} TRX</span></div>
          <div class="text_row"><span>{{t('SMART_BALANCE')}}</span><span>{{contractBalance}} TRX</span></div>
          <div class="text_row"><span>{{t('MEMBER_COIN_TOTAL')}}</span><span>{{totalWithDrawTrx}} TRX</span></div>
          <!-- <div class="text_row"><span>{{t('DAY_1')}}</span><span>-- TRX</span></div> -->
          <div class="text_row"><span>{{t('TOP_10_CD')}}</span><span>{{poolCountDown}}</span></div>
          <div class="text_row"><span>{{t('TOP_10_TOTAL')}}</span><span>{{poolTop10}} TRX</span></div>
          <div class="text_row"><span>{{t('TSC_REWORD')}}</span><span>{{totalReleaseTsc}} TSC</span></div>
          <div class="text_row"><span>{{t('TSC_WITHDRAWAL')}}</span><span>{{totalWithdrawTSC}} TSC</span></div>
          <div class="text_row"><span>{{t('REF_ADD')}}</span><span>{{upLine}}</span></div>
        </div>
      </Item>

      <Item :title="t('STAT')">
        <div>
          <div class="text_row"><span>{{t('INV_LINK')}}</span><span><span class="copy" @click="copyText(myInvLink)">复制</span> {{myInvLink}}</span></div>
          <div class="text_row"><span>{{t('TRX_LINK')}}</span><span>{{myAddress}}</span></div>
          <div class="text_row"><span>{{t('INV_TOTAL')}}</span><span>{{myTotalDeposit}} TRX</span></div>
          <div class="text_row"><span>{{t('REWARD_161')}}</span><span>{{myReward1618}} TRX</span></div>
          <div class="text_row"><span>{{t('DIRECT')}}</span><span>{{referrals}}</span></div>
          <div class="text_row"><span>{{t('DIRECT_REWARD')}}</span><span>{{myRefRewardAll}} TRX</span></div>
          <div class="text_row"><span>{{t('TOTAL_TEAM')}}</span><span>{{myTeamRewardAll}} TRX</span></div>
          <div class="text_row"><span>{{t('GLOBAL_10')}}</span><span>{{myTop10RewardAll}} TRX</span></div>
          <div class="text_row"><span>{{t('TSC_REWARD')}}</span><span>{{myTscRewardAll}} TSC</span></div>
          <div class="text_row"><span>{{t('TOTAL_WITHDRAWAL')}}</span><span>{{myWithdrawTrxAll}} TRX</span></div>
        </div>
      </Item>

      <Item :title="t('DYNAMIC')">
        <div class="dynamic">
          <div>
            <div class="text_row"><span>{{t('INV_TRX')}}</span><span>{{myInvestTrx}} TRX</span></div>
            <div class="text_row"><span>{{t('DAY_REWARD')}}</span><span>{{myInvestTrx/100}} TRX</span></div>
            <div class="text_row"><span>{{t('TSC_FACTOR')}}</span><span>{{myDymicFactor}}</span></div>
            <div class="text_row"><span>{{t('TRX_AVA')}}</span><span>{{myTrxBalance}} TRX</span></div>
            <div class="text_row"><span>{{t('TSC_AVA')}}</span><span>{{myTscBalance}} TSC</span></div>
          </div>
          <div class="flex justify-between mt-3">
            <div>
              <Btn type="blue" @click="withdrawTSC()">{{t('TSC_COIN')}}</Btn>
              <div class="dynamic_tip">{{t('TSC_FEE')}}</div>
            </div>
            <div>
              <Btn type="green" @click="withdrawTRX()">{{t('TRX_COIN')}}</Btn>
              <div class="dynamic_tip">{{t('TRX_FEE')}}</div>
            </div>
          </div>
        </div>
      </Item>

    </div>
    <div class="footer flex align-center">
      <a target="_blank" href="">TitanSpace  Facebook</a>
      <a target="_blank" href="">TitanSpace  Telegram</a>
    </div>

    <Modal v-model="defiShow" :title="t('DEFI')">
      <div class="modal_detail" v-html="t('GUIDE')"></div>
    </Modal>

    <Modal v-model="joinShow" :title="t('HOW_JOIN')">
      <div class="modal_detail" v-html="t('DETAIL_JOIN')"></div>
    </Modal>

    <Modal v-model="aboutShow" :title="t('ABOUT')">
      <div class="modal_detail" v-html="t('DETAIL_ABOUT')"></div>
    </Modal>
  </div>
</template>
<script lang="ts">
import { Component, Vue, Watch } from 'vue-property-decorator';
import TronWeb from 'tronweb';
import Item from '@/components/Item.vue';
import Btn from '@/components/Btn.vue';
import Modal from '@/components/Modal.vue';
import t, { langs } from '@/i18n';
import abi from '../store/abi';

const contractAddress = 'TRdc9ghNAGqRKmf2hG7X7iyKQKwYJD1zgr';
const defaultUpline = 'TB6AGbDLjxwuJwLwJzHJ8XsZAyrbnZXSeV';

@Component({
  components: { Item, Btn, Modal },
})
export default class Home extends Vue {
  private lang = (navigator.language || (navigator as any).userLanguage || '').split('-')[0];

  private defiShow = false;

  private joinShow = false;

  private aboutShow = false;

  private trx = 0;

  private langs = {
    zh: '简体中文',
    en: 'English',
  }

  // 合约地址
  private contractAddress = contractAddress;

  // 全球参与者
  private globalMember = 0;

  // 总充值量TRX
  private totalDepositTrx = 0;

  // 总提现量TRX
  private totalWithDrawTrx = 0;

  // 总释放量TSC
  private totalReleaseTsc = 0;

  // 合约余额
  private contractBalance = 0;

  // TSC已提总量
  private totalWithdrawTSC = 0;

  // 邀请人地址
  private upLine = '';

  // 我的邀请地址
  private myInvLink = '';

  // 我的投资总额
  private myTotalDeposit = 0;

  // 我的提现总额TRX
  private myWithdrawTrxAll = 0;

  // 我的1618%奖励
  private myReward1618 = 0;

  // 我的直推人数
  private referrals = 0;

  private poolCountDown = '';

  // 我的直推奖励总额
  private myRefRewardAll = 0;

  // 我的团队奖励总额
  private myTeamRewardAll = 0;

  // 我的Top10奖励总额
  private myTop10RewardAll = 0;

  // 我的TSC奖励总额
  private myTscRewardAll = 0;

  // 已提TSC总额
  private myWithdrawedTSC = 0;

  // 可提TSC总额
  private myTscBalance = 0;

  // 可提TRX
  private myTrxBalance = 0;

  // 我的在投trx
  private myInvestTrx = 0;

  // 当前动态释放因子
  private myDymicFactor = 0;

  //
  private loading_w = true;

  private poolBalance = 0;

  private poolTop10 = 0;

  private tvs = 'dsss';

  private ds = '';

  private tronWeb: any = null;

  private myContract: any = null;

  private tronWebInject: any;

  private myAddress = '';

  private tronlinkflg = false;

  private tronState: any;

  private get t(): Function {
    return t(this.lang);
  }

  @Watch('$route.query.lang')
  private watchLang(lang: string): void {
    this.lang = langs[lang] ? lang : 'en';
  }

  private created(): void {
    if (!langs[this.lang]) this.lang = 'en';
  }

  private mounted(): void {
    setInterval(async () => {
      this.initWebJect();
    }, 5000);
  }

  private async initWebJect() {
    if (window.tronWeb) {
      this.tronlinkflg = true;
      const thisAddress = window.tronWeb.defaultAddress.base58;
      if (this.myAddress !== thisAddress) {
        this.myAddress = thisAddress;
        this.success(`Your trx wallet address: ${thisAddress}`);
      } else {
        return;
      }
    } else {
      this.fail('loading tronlink');
      return;
    }

    const { HttpProvider } = TronWeb.providers;
    const fullNode = new HttpProvider('https://api.shasta.trongrid.io', 60000);
    const solidityNode = new HttpProvider('https://api.shasta.trongrid.io', 60000);
    const eventServer = new HttpProvider('https://api.shasta.someotherevent.io/', 60000);
    this.tronWeb = new TronWeb(
      fullNode,
      solidityNode,
      eventServer,
    );

    this.tronWebInject = window.tronWeb;
    this.myAddress = this.tronWebInject.defaultAddress.base58;
    if (this.myAddress) {
      const webInject = window.tronWeb;
      const contractx = webInject.contract(abi, contractAddress);
      this.myContract = contractx;
      console.log(this.myContract);
    }
    this.initPage();
  }

  private async initPage() {
    // console.log(this.myContract);
    // const pb = await this.myContract.userInfo('TW9Fwdqet3Km6u4y41d5ANZruZ3C7f1nur').call();
    // this.poolBalance = this.tronWeb.fromSun(pb).toFixed(2);
    this.success('LOADING');
    const contractInfo = await this.myContract.contractInfo().call();
    this.contractBalance = contractInfo._trx_balance;
    this.contractBalance = this.hexToTrx(this.contractBalance);
    this.totalReleaseTsc = contractInfo._total_token_mined;
    this.totalReleaseTsc = this.hexToTrx(this.totalReleaseTsc);
    this.totalWithdrawTSC = contractInfo._total_token_withdraw;
    this.totalWithdrawTSC = this.hexToTrx(this.totalWithdrawTSC);

    this.globalMember = contractInfo._total_users;
    this.totalDepositTrx = this.hexToTrx(contractInfo._total_deposited);
    this.totalWithDrawTrx = this.hexToTrx(contractInfo._total_withdraw);
    this.poolTop10 = this.hexToTrx(contractInfo._pool_balance) / 10;
    this.poolCountDown = this.calPoolCountDown(contractInfo._pool_last_draw);

    const userInfo = await this.myContract.users(this.myAddress).call();
    const ttd = this.hexToTrx(userInfo.total_deposits);
    if (ttd > 0) {
      this.upLine = this.tronWeb.address.fromHex(userInfo.upline);
      this.myInvLink = `${window.location.protocol}//${window.location.host}?ref=${this.myAddress}`;
      this.myTotalDeposit = this.hexToTrx(userInfo.total_deposits);
      this.myWithdrawTrxAll = this.hexToTrx(userInfo.total_payouts);
      this.myInvestTrx = this.hexToTrx(userInfo.deposit_amount);
      this.myReward1618 = this.myTotalDeposit * 1.618;
      this.referrals = userInfo.referrals;
      this.myRefRewardAll = this.hexToTrx(userInfo.direct_bonus);
      this.myTeamRewardAll = this.hexToTrx(userInfo.match_bonus);
      this.myTop10RewardAll = this.hexToTrx(userInfo.pool_bonus);

      // TSC 挖矿
      const tscMiningInfo = await this.myContract.users_mining(this.myAddress).call();
      if (tscMiningInfo) {
        this.myTscBalance = this.hexToTrx(tscMiningInfo.mining_rewards);
        this.myTscRewardAll = this.hexToTrx(tscMiningInfo.total_mining_rewards);
        this.myWithdrawedTSC = this.hexToTrx(tscMiningInfo.total_mining_payouts);
      }

      // 动态因子
      const dymicFactor = await this.myContract.dynamicFactorOf(this.myAddress).call();
      console.log(`dymic:${dymicFactor.dynamic_factor}`);
      this.myDymicFactor = dymicFactor.dynamic_factor / 10;

      // 我的payouts
      const myPayouts = await this.myContract.availablePayoutOf(this.myAddress).call();
      console.log(myPayouts);
      this.myTrxBalance = this.hexToTrx(myPayouts);
    } else {
      // 未注册
      this.upLine = this.getUrlKey('ref');
      console.log(`ref upline :${this.upLine}`);
      this.clearMyData();
      try {
        const uplineInfo = await this.myContract.users(this.upLine).call();
        const ttd1 = this.hexToTrx(uplineInfo.total_deposits);
        console.log(`ttd1: ${ttd1}`);
        if (ttd1 > 0) {
          //
        } else {
          this.upLine = defaultUpline;
        }
      } catch (err) {
        console.log(`ref upne err${err}`);
        this.upLine = defaultUpline;
      }
      console.log(`real:${this.upLine}`);
    }
  }

  private clearMyData() {
    this.myDymicFactor = 0;
    this.myInvestTrx = 0;
    this.myRefRewardAll = 0;
    this.myReward1618 = 0;
    this.myTeamRewardAll = 0;
    this.myTop10RewardAll = 0;
    this.myTotalDeposit = 0;
    this.myTrxBalance = 0;
    this.myTscBalance = 0;
    this.myTscRewardAll = 0;
    this.myWithdrawTrxAll = 0;
    this.myWithdrawedTSC = 0;
  }

  private async deposit() {
    if (this.trx == 0) return;
    const args = {
      feeLimit: 200000000,
      callValue: this.tronWeb.toSun(this.trx),
      shouldPollResponse: true,
    };

    this.$toast.loading({
      forbidClick: true,
      duration: 0,
    });

    this.myContract.deposit(this.upLine).send(args).then(() => {
      this.initPage();
      this.success('Success!');
    }, () => {
      this.fail('Failed!');
    }).finally(() => {
      this.$toast.clear();
    });
  }

  private async withdrawTRX() {
    if (this.myTrxBalance <= 1) {
      return;
    }
    const args = {
      feeLimit: 200000000,
      callValue: 0,
      shouldPollResponse: true,
    };

    this.$toast.loading({
      forbidClick: true,
      duration: 0,
    });

    this.myContract.withdraw().send(args).then(() => {
      this.initPage();
      this.success('Success!');
    }, () => {
      this.fail('Failed!');
    }).finally(() => {
      this.$toast.clear();
    });
  }

  private copyText(value: string): void {
    const s = document.createElement('input');
    s.value = value;
    document.body.appendChild(s);
    s.select();

    if (navigator.userAgent.match(/ipad|ipod|iphone/i)) {
      s.contentEditable = 'true';
      s.readOnly = false;
      const range = document.createRange();
      range.selectNodeContents(s);
      const sel = window.getSelection() as any;
      sel.removeAllRanges();
      sel.addRange(range);
      s.setSelectionRange(0, 999999);
    }

    try { document.execCommand('copy'); this.$toast('Copied!'); } catch (err) { this.$toast.fail('Copy error'); }

    s.remove();
  }

  private async withdrawTSC() {
    if (this.myTscBalance <= 20) {
      return;
    }
    const args = {
      feeLimit: 200000000,
      callValue: 0,
      shouldPollResponse: true,
    };

    this.$toast.loading({
      forbidClick: true,
      duration: 0, // 如果不想长时间显示loading可删除该参数
    });
    this.myContract.tokenWithdraw().send(args).then(() => {
      this.initPage();
      this.success('Success!');
    }, () => {
      this.fail('Failed!');
    })
      .finally(() => { // 如果不想长时间显示loading可删除该方法
        this.$toast.clear();
      });
  }

  private success(message: string): void {
    setTimeout(() => {
      this.$toast.success({ message, duration: 5000 });
    });
  }

  private fail(message: string): void {
    setTimeout(() => {
      this.$toast.fail({ duration: 5000, message });
    });
  }

  private langSelected(cur = '', lang: string): string {
    if (cur === lang || cur.split('-')[0] === lang) return 'lang_options-selected';
    return '';
  }

  private getUrlKey(name: string): string {
    return decodeURIComponent(location.search).slice(1).split('&').reduce((a: any, c) => { const [k, v] = c.split('='); a[k] = v; return a; }, {})[name];
  }

  private incTRX(inc: number): void {
    this.trx += inc;
  }

  private setTRX(val: number): void {
    this.trx = val;
  }

  private changeLang(lang: string): void {
    this.lang = lang;
  }

  private calPoolCountDown(lastTime: string) {
    const lastD = new Date(lastTime);
    const now = new Date();
    const total = (now.getTime() - lastD.getTime()) / 1000;
    const day = total / (24 * 60 * 60);// 计算整数天数
    if (day >= 1) {
      return '00:00';
    }
    const afterDay = total - day * 24 * 60 * 60;// 取得算出天数后剩余的秒数

    const hour = afterDay / (60 * 60);// 计算整数小时数

    const afterHour = total - day * 24 * 60 * 60 - hour * 60 * 60;// 取得算出小时数后剩余的秒数

    const min = afterHour / 60;// 计算整数分

    return `${hour} : ${min}`;
  }

  private formatDate(time: string) {
    const d = new Date(time);
    const year = d.getFullYear(); // 取得4位数的年份
    const month = d.getMonth() + 1; // 取得日期中的月份，其中0表示1月，11表示12月
    const date = d.getDate(); // 返回日期月份中的天数（1到31）
    const hour = d.getHours(); // 返回日期中的小时数（0到23）
    const minute = d.getMinutes(); // 返回日期中的分钟数（0到59）
    const second = d.getSeconds(); // 返回日期中的秒数（0到59）
    return `${year}-${month}-${date} ${hour}:${minute}:${second}`;
  }

  private hexToTrx(hex: number) {
    return Number(this.tronWeb.fromSun(hex.toString()));
  }
}
</script>
<style lang="scss" scoped>
@import '@/styles/index.scss';

.home {
  color: #fff;
  background: url('../assets/bg-space.png') 0 0/100% repeat-y;
}
.first {
  min-height: 100vh;

  @include respond(pad) {
    min-height: auto;
  }
}
.header {
  max-width: 70vw;
  margin: 0 auto;
  padding: 20px 0;

  @include respond(phone) {
    max-width: 100vw;
    padding: 10px;
    flex-wrap: wrap;

    .nav {
      order: 3;
      margin: 20px 0;
      flex: 1;
      text-align: center;
      > div {
        flex: 1;
        margin: 0;
      }
    }
  }
}
.logo {
  margin-right: auto;
}
.nav {
  white-space: nowrap;

  > div {
    margin: 0 20px;
    cursor: pointer;
  }
}
.lang {
  position: relative;
  white-space: nowrap;
  margin-left: 20px;

  &_selected {
    display: flex;
    align-items: center;
    padding: 5px 10px;

    &::after {
      content: '';
      display: block;
      margin-left: 10px;
      margin-top: 5px;
      border: 5px solid transparent;
      border-top-color: #666;
    }
  }

  &_selected, &_options {
    border: 1px solid #666;
    border-radius: 6px;
    cursor: pointer;
  }

  &:hover &_options, &:active &_options {
    display: block;
  }

  &_options {
    display: none;
    position: absolute;
    left: 0;
    right: 0;
    margin-top: 1px;
    padding: 5px 0;
    z-index: 2;
    background: rgba(0, 0, 0, .7);

    > a {
      display: block;
      text-decoration: none;
      padding: 5px 10px;
    }

    &-selected {
      background: rgba(31, 92, 167, .3);
    }
  }
}
.banner {
  position: relative;
  text-align: center;

  &_bg {
    width: 100%;
  }

  &_inner {
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
  }

  &_name {
    width: 70vw;
  }

  &_desc {
    font-size: 2.2vw;
  }
}
.stat {
  max-width: 1000px;
  margin: 0 auto 70px;
  text-align: center;
  padding: 50px;
  font-size: 16px;
  background: url('../assets/base.png') 0 0/100% 100% no-repeat;

  > div {
    display: flex;
    flex-flow: column;
    flex: 1;
    padding: 20px 0 10px;

    :first-child {
      margin-bottom: 10px;
    }

    :last-child {
      margin-left: 5px;
    }
  }

  @include respond(phone) {
    flex-flow: column;
    padding: 60px 40px 50px;

    > div {
      padding: 5px 0;
      flex-flow: row;
      :first-child {
        margin-right: auto;
      }
    }
  }
}
.join {
  &_inp {
    padding: 5px 10px;
    border: 2px solid #fff;
    border-radius: 5px;
  }

  &_btns {
    margin: 30px 0;
    display: grid;
    grid-gap: 10px;
    grid-template: repeat(2, 1fr) / repeat(3, 1fr);

    > div {
      padding: 5px 10px;
      border: 2px solid #fff;
      border-radius: 5px;
      cursor: pointer;
      user-select: none;

      &:active {
        opacity: .7;
      }
    }
  }
}
.text_row {
  display: flex;
  justify-content: space-between;
  margin: 10px 0;
  white-space: nowrap;

  :first-child {
    text-align: left;
    margin-right: 10px;
  }

  :last-child {
    word-break: break-all;
    white-space: pre-wrap;
  }
}
.dynamic {
  &_tip {
    margin-top: 10px;
    font-size: 12px;
  }
}
.footer {
  justify-content: space-evenly;
  padding: 20px 0 50px;
  flex: 1;
  text-align: center;
  flex-wrap: wrap;
}
.modal_detail {
  max-height: 50vh;
  overflow: auto;
  white-space: pre-wrap;
}
.copy {
  margin: 0 !important;
  padding: 0 8px;
  border-radius: 20px;
  font-size: 12px;
  border: 1px solid;
  cursor: pointer;

  &:active {
    opacity: .7;
  }
}
</style>
