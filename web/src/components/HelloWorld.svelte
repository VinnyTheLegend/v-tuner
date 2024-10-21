<script lang="ts">
  import { visibility } from '../store/stores';
  import { fetchNui } from '../utils/fetchNui';
  import { useNuiEvent } from '../utils/useNuiEvent';

  useNuiEvent<string>('message', (data) => {
    console.log(data)
  })

</script>

<div class="container">

</div>

<style>
  
</style>
