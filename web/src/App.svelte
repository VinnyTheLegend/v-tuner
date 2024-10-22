<script lang="ts">
  import VisibilityProvider from './providers/VisibilityProvider.svelte';
  import HelloWorld from './components/HelloWorld.svelte';
  import { onMount } from 'svelte';
  import { debugData } from './utils/debugData';
  import { useNuiEvent } from './utils/useNuiEvent';
  import { fetchNui } from './utils/fetchNui'
  import {isEnvBrowser} from "./utils/misc";


  debugData([
    {
      action: 'setVisible',
      data: true,
    },
  ]);

  
  console.log('ui loaded')
  let handling_visible = false
  
  if (isEnvBrowser()) {
    document.body.style.backgroundColor = '#474745';
  }

  onMount(() => {
    const keyHandler = (e: KeyboardEvent) => {
      if (handling_visible && ['Escape'].includes(e.code)) {
        fetchNui('CloseMenu');
      }
    };

    window.addEventListener('keydown', keyHandler);

    return () => window.removeEventListener('keydown', keyHandler);
  });


  useNuiEvent<any>('updateBaseHandling', (data) => {
    console.log(data)
  })

  useNuiEvent<any>('setFocus', (data) => {
    handling_visible = data
  })

</script>

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