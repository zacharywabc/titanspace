<template>
  <div class="btn" :class="`btn-${type}`" v-on="$listeners">
    <slot></slot>
  </div>
</template>
<script lang="ts">
import { Component, Prop, Vue } from 'vue-property-decorator';

@Component
export default class Btn extends Vue {
  @Prop({ type: String, default: '' })
  private type!: string;
}
</script>
<style lang="scss" scoped>
.btn {
  display: inline-block;
  padding: 15px 15px 10px;
  white-space: nowrap;
  cursor: pointer;
  user-select: none;
  background-repeat: no-repeat;
  background-size: 100% 100%;
  background-image: url('../assets/btn-grey.png');

  &-green { background-image: url('../assets/btn-green.png'); }
  &-blue { background-image: url('../assets/btn-blue.png'); }

  &:active {
    opacity: .7;
  }
}
</style>
