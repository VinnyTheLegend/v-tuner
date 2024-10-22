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

<div class="hud-container">
  {#if hud_data}
    <div><span class="title">Top Speed: </span>{Math.round(hud_data['top-speed'])}</div>
    <!-- <div><span class="title">Top Accel: </span>{Math.round(hud_data['top-accel'])}</div>
    <div><span class="title">Top Decel: </span>{Math.round(hud_data['top-decel'])}</div> -->
    <div><span class="title">Gear: </span>{Math.round(hud_data.gear)}</div>
  {/if}
</div>

<style>
  .hud-container {
    border: 1px var(--border-color) solid;
    border-radius: 5px;
    padding: 2px 5px;
    background-color: var(--bg-color);
    position: absolute;
    top: 50px;
    right: 50px;
  }

  .hud-container>div {
    text-align: right;
  }

  .title {
    color: var(--text-highlight)
  }

</style>
