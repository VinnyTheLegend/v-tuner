<script lang="ts">
    import { debugData } from '../utils/debugData';
    import { fetchNui } from '../utils/fetchNui';
  
    console.log('handling start')
    export let handling_data: HandlingData[]

  </script>
  
  <div class="container">
      <ol>
        {#if handling_data}            
            {#each handling_data as handling}
                <li class="handling-item">{handling.name}</li>
            {/each}
        {/if}
      </ol>
  </div>
  
  <style>
    .container {
        display: flex;
        flex-grow: 1;
        border: 1px var(--border-color) solid;
        border-radius: 5px;
        padding: 2px 5px;
        background-color: var(--bg-color);
        margin: 50px auto 50px 50px;
    }
  
  </style>
  