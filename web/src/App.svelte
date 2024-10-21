<script lang="ts">
  import VisibilityProvider from './providers/VisibilityProvider.svelte';
  import HelloWorld from './components/HelloWorld.svelte';
  import { onMount } from 'svelte';
  import { debugData } from './utils/debugData';
  import { useNuiEvent } from './utils/useNuiEvent';
  import { fetchNui } from './utils/fetchNui'

  debugData([
    {
      action: 'setVisible',
      data: true,
    },
  ]);

  console.log('ui loaded')
  let handling_visible = false


  onMount(() => {
    const keyHandler = (e: KeyboardEvent) => {
      if (handling_visible && ['Escape'].includes(e.code)) {
        fetchNui('CloseMenu');
      }
    };

    window.addEventListener('keydown', keyHandler);

    return () => window.removeEventListener('keydown', keyHandler);
  });


  useNuiEvent<any>('message', (data) => {
    if (data.type === "updateBaseHandling") {console.log(data)}
    else if (data.type === "setFocus") {handling_visible = data.data}
  })

</script>
<!-- <svelte:window on:keydown|preventDefault={onKeyDown} /> -->
<main>
  <VisibilityProvider>
    <div class="hud container">HUD HERE</div>
    {#if handling_visible}
      <div class="handling container">HANDLING HERE</div>
    {/if}
  </VisibilityProvider>
</main>
<style>
  .hud.container {
    color: green
  }

  .handling.container {
    color: red;
  }
</style>