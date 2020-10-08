<template>
  <div id="app">
    <router-view/>
  </div>
</template>
<script lang="ts">
import { Component, Vue } from 'vue-property-decorator';

@Component
export default class App extends Vue {
  private created(): void {
    // eslint-disable-next-line @typescript-eslint/no-empty-function
    document.addEventListener('touchstart', () => {}, true);
  }
}
</script>
<style lang="scss">
html {
  font-size: 14px;
}
.flex {
  display: flex;
}
.align-center {
  align-items: center;
}
.justify-between {
  justify-content: space-between;
}
.mt-2 {
  margin-top: 20px;
}
.mt-3 {
  margin-top: 30px;
}
a {
  color: inherit;
}
</style>
