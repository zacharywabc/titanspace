<template>
  <div v-show="value" class="modal">
    <div class="modal_mask"></div>
    <div class="modal_content">
      <img src="@/assets/close.png" class="modal_close" @click="$emit('input', false)" />
      <div v-if="title" class="modal_title" v-text="title" />
      <slot></slot>
    </div>
  </div>
</template>
<script lang="ts">
import { Component, Prop, Vue } from 'vue-property-decorator';

@Component
export default class Modal extends Vue {
  @Prop({ type: String, default: '' })
  private title!: string;

  @Prop(Boolean)
  private value!: boolean;
}
</script>
<style lang="scss" scoped>
.modal {
  position: fixed;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;

  &_mask {
    position: absolute;
    left: 0;
    right: 0;
    top: 0;
    bottom: 0;
  }

  &_title {
    margin-bottom: 10px;
    text-align: center;
    font-weight: bold;
    font-size: 22px;
  }

  &_content {
    position: absolute;
    left: 50%;
    top: 50%;
    transform: translate(-50%, -50%);
    padding: 20px;
    min-width: 80vw;
    background: rgba(18, 61, 116, .96);
    border-radius: 10px;
  }

  &_close {
    position: absolute;
    right: 0;
    transform: translateY(-150%);
    cursor: pointer;
    width: 50px;

    &:active {
      opacity: .7;
    }
  }
}
</style>
