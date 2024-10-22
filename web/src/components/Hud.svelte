<script lang="ts">
  import { visibility } from '../store/stores';
  import { debugData } from '../utils/debugData';
  import { fetchNui } from '../utils/fetchNui';
  import { useNuiEvent } from '../utils/useNuiEvent';

  console.log('hud start')

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

  let hud_data: HUDdata

  useNuiEvent<HUDdata>('updateHUD', (data) => {
    hud_data = data
  })

</script>

<div class="container">
  {#if hud_data}
    <span>GEAR: {hud_data.gear}</span>  
  {/if}
</div>

<style>
  .container {
    border: 1px yellow solid;
    color: green;
    margin: 5% 5% auto auto;
  }
</style>
