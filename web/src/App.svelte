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

  debugData([
    {
      action: 'updateHUD',
      data: {
        "top-speed": 1,
        "top-accel": 2,
        "top-decel": 3,
        "gear": 4
      },
    },
  ]);




  console.log('ui loaded')
  let handling_visible = false
  let hud_data: HUDdata
  let handling_data: HandlingData[]

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


  useNuiEvent<HandlingData>('updateBaseHandling', (data) => {
    console.log(data)
  })

  useNuiEvent<boolean>('setFocus', (data) => {
    handling_visible = data
  })

  useNuiEvent<HUDdata>('updateHUD', (data) => {
    hud_data = data
  })

</script>

<main>
  <VisibilityProvider>
    <div class="main-container">
      {#if hud_data}
        <div class="hud container">GEAR: {hud_data.gear}</div>
      {/if}
      {#if handling_visible}
        <div class="handling container">HANDLING HERE</div>
      {/if}
    </div>
  </VisibilityProvider>
</main>
<style>
  main {
    height: 100vh;
    width: 100vw;
    position: relative;
    border: 2px red solid;
    padding: 0;
    margin: 0;
    padding: 2px;
    margin: 0;
    box-sizing: border-box;
  }

  .main-container {
    border: 1px green solid;
    padding: 1px;
    margin: 0;
    height: 100%;
    width: 100%;
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
    position: relative;
  }

  .hud.container {
    
    border: 1px yellow solid;
    color: green;
    margin: 5% 5% auto auto;
  }

  .handling.container {
    color: red;
  }
</style>