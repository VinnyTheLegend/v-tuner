<script lang="ts">
  import VisibilityProvider from './providers/VisibilityProvider.svelte';
  import HelloWorld from './components/HelloWorld.svelte';
  import { debugData } from './utils/debugData';
  import { useNuiEvent } from './utils/useNuiEvent';

  debugData([
    {
      action: 'setVisible',
      data: true,
    },
  ]);

  console.log('ui loaded')


  useNuiEvent<string>('message', (data) => {
    console.log('message:')
    console.log(data)
  })

</script>

<main>
  <VisibilityProvider>
    <HelloWorld />
  </VisibilityProvider>
</main>
