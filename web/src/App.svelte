<script lang="ts">
  import VisibilityProvider from './providers/VisibilityProvider.svelte';
  import { onMount } from 'svelte';
  import { debugData } from './utils/debugData';
  import { useNuiEvent } from './utils/useNuiEvent';
  import { fetchNui } from './utils/fetchNui'
  import {isEnvBrowser} from "./utils/misc";

  import Hud from './components/Hud.svelte';
  import Handling from './components/Handling.svelte';
  import ResetConfirm from './components/ResetConfirm.svelte';

  debugData([
    {
      action: 'setVisible',
      data: true,
    },
    {
      action: 'setFocus',
      data: true,
    },
  ]);
  debugData([
    {
      action: 'updateCurrentHandling',
      data: [{
        key: 0,
        name: "ftesthandlingname",
        description: "this is an extra long thing to test description for handling fields and stuff ya know baws",
        value: 11123.54123123
      },
      {
        key: 1,
        name: "ftesthasdandlingname",
        description: "thisasd is an extra long thing to test description for handling fields and stuff ya know baws",
        value: 11123.54123123
      }
    ],
    },
    {
      action: 'updateBaseHandling',
      data: [{
        key: 0,
        name: "ftesthandlingname",
        description: "this is an extra long thing to test description for handling fields and stuff ya know baws",
        value: 11123.54123123
      },
      {
        key: 1,
        name: "ftesthasdandlingname",
        description: "thisasd is an extra long thing to test description for handling fields and stuff ya know baws",
        value: 11123.54123123
      }
    ],
    },
    
  ]);

  console.log('ui loaded')
  let handling_visible = false
  let handling_data: HandlingData[]
  let base_handling: HandlingData[]
  let reset_confirm = false

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


  useNuiEvent<HandlingData[]>('updateCurrentHandling', (data) => {
    console.log(data)
    handling_data = data
  })

  useNuiEvent<HandlingData[]>('updateBaseHandling', (data) => {
    console.log(data)
    base_handling = data
  })

  useNuiEvent<boolean>('setFocus', (data) => {
    handling_visible = data
  })

</script>

<main class="">
  <ResetConfirm />
  <div class="main-container">
  <VisibilityProvider>
    <Hud />
    {#if handling_visible && handling_data}
    <Handling {handling_data} {base_handling}/>
    {/if}
    </VisibilityProvider>
  </div>
</main>
<style>
  :global(:root){
    font-family: "Lucida Console", "Courier New", monospace;
    color: white;
    --bg-color: rgba(17, 0, 15, 0.801);
    --border-color: #000000cc;
    --text-color: white;
    --text-highlight: rgb(0, 238, 255);
  }

  main {
    height: 100vh;
    width: 100vw;
    position: relative;
    padding: 0;
    margin: 0;
    padding: 2px;
    margin: 0;
    box-sizing: border-box;
  }

  .main-container {
    padding: 1px;
    margin: 0;
    height: 100%;
    width: 100%;
    box-sizing: border-box;
    display: flex;
    flex-direction: column;
    position: relative;
  }

</style>