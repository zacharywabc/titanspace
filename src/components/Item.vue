<template>
  <div class="item">
    <div class="item_title" v-text="title" />
    <div class="item_inner">
      <slot></slot>
    </div>
  </div>
</template>
<script lang="ts">
import { Component, Prop, Vue } from 'vue-property-decorator';

@Component
export default class Item extends Vue {
  @Prop({ type: String, default: '' })
  private title!: string;
}
</script>
<style lang="scss" scoped>
@import '@/styles/index.scss';

.item {
  position: relative;
  max-width: 1000px;
  margin: 50px auto;
  padding: 50px 20px;
  text-align: center;
  background: url('../assets/base2.png') 0 0/100% 100% no-repeat;

  &_title {
    position: absolute;
    left: 22%;
    top: 6%;
    font-weight: bold;
    font-size: 1.8vw;
  }

  &_inner {
    width: 60%;
    margin: 0 auto;
    padding: 50px 40px;
  }

   @include respond(phone) {
    margin: 50px 10px;

    &_title {
      left: 22vw;
      top: 10%;
      font-size: 3.5vw;
    }

    &_inner {
      width: 90% !important;
      padding: 40px 20px !important;
    }
  }
}
</style>
