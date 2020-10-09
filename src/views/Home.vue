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
          <div class="lang_selected">{{langs[lang] || langs.zh}}</div>
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
          <span>0</span>
        </div>
        <div>
          <span>{{t('TLOCK')}}</span>
          <span>0 TRX</span>
        </div>
        <div>
          <span>{{t('TRELEASE')}}</span>
          <span>0 TRX</span>
          <span>0 TSC</span>
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
            <Btn type="green">{{t('LOCK')}}</Btn>
          </div>
        </div>
      </Item>

      <Item :title="t('SMART')">
        <div>
          <div class="text_row"><span>{{t('SMART_ADD')}}</span><span>--</span></div>
          <div class="text_row"><span>{{t('SMART_TOTAL')}}</span><span>-- TRX</span></div>
          <div class="text_row"><span>{{t('SMART_BALANCE')}}</span><span>-- TRX</span></div>
          <div class="text_row"><span>{{t('MEMBER_COIN_TOTAL')}}</span><span>-- TRX</span></div>
          <div class="text_row"><span>{{t('DAY_1')}}</span><span>-- TRX</span></div>
          <div class="text_row"><span>{{t('TOP_10_CD')}}</span><span>--</span></div>
          <div class="text_row"><span>{{t('TOP_10_TOTAL')}}</span><span>-- TRX</span></div>
          <div class="text_row"><span>{{t('TSC_REWORD')}}</span><span>-- TSC</span></div>
          <div class="text_row"><span>{{t('TSC_WITHDRAWAL')}}</span><span>-- TSC</span></div>
          <div class="text_row"><span>{{t('REF_ADD')}}</span><span>--</span></div>
        </div>
      </Item>

      <Item :title="t('STAT')">
        <div>
          <div class="text_row"><span>{{t('INV_LINK')}}</span><span>--</span></div>
          <div class="text_row"><span>{{t('TRX_LINK')}}</span><span>--</span></div>
          <div class="text_row"><span>{{t('INV_TOTAL')}}</span><span>-- TRX</span></div>
          <div class="text_row"><span>{{t('REWARD_161')}}</span><span>-- TRX</span></div>
          <div class="text_row"><span>{{t('DIRECT')}}</span><span>-- 人</span></div>
          <div class="text_row"><span>{{t('DIRECT_REWARD')}}</span><span>-- TRX</span></div>
          <div class="text_row"><span>{{t('TOTAL_TEAM')}}</span><span>-- TSC</span></div>
          <div class="text_row"><span>{{t('GLOBAL_10')}}</span><span>-- TSC</span></div>
          <div class="text_row"><span>{{t('TSC_REWARD')}}</span><span>--</span></div>
          <div class="text_row"><span>{{t('TOTAL_WITHDRAWAL')}}</span><span>--</span></div>
        </div>
      </Item>

      <Item :title="t('DYNAMIC')">
        <div class="dynamic">
          <div>
            <div class="text_row"><span>{{t('INV_TRX')}}</span><span>-- TRX</span></div>
            <div class="text_row"><span>{{t('DAY_REWARD')}}</span><span>-- TRX</span></div>
            <div class="text_row"><span>{{t('TSC_FACTOR')}}</span><span>--</span></div>
            <div class="text_row"><span>{{t('TRX_AVA')}}</span><span>-- TRX</span></div>
            <div class="text_row"><span>{{t('TSC_AVA')}}</span><span>-- TSC</span></div>
          </div>
          <div class="flex justify-between mt-3">
            <div>
              <Btn type="blue">{{t('TSC_COIN')}}</Btn>
              <div class="dynamic_tip">{{t('TSC_FEE')}}</div>
            </div>
            <div>
              <Btn type="green">{{t('TRX_COIN')}}</Btn>
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
import Item from '@/components/Item.vue';
import Btn from '@/components/Btn.vue';
import Modal from '@/components/Modal.vue';
import t, { langs } from '@/i18n';

@Component({
  components: { Item, Btn, Modal },
})
export default class Home extends Vue {
  private lang = navigator.language || (navigator as any).userLanguage;

  private defiShow = false;

  private joinShow = false;

  private aboutShow = false;

  private trx = 0;

  private langs = {
    zh: '简体中文',
    en: 'English',
  }

  private get t(): Function {
    return t(this.lang);
  }

  @Watch('$route.query.lang', { immediate: true })
  private watchLang(lang: string): void {
    this.lang = langs[lang] ? lang : 'zh';
  }

  private created(): void {
    if (!langs[this.lang]) this.lang = 'zh';
  }

  private langSelected(cur = '', lang: string): string {
    if (cur === lang || cur.split('-')[0] === lang) return 'lang_options-selected';
    return '';
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
  align-items: center;
  justify-content: space-between;
  margin: 10px 0;

  :first-child {
    text-align: left;
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
</style>
