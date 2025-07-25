<script lang="ts">
  import { debugData } from '../utils/debugData';
  import { fetchNui } from '../utils/fetchNui';
  import { useNuiEvent } from '../utils/useNuiEvent';
  import { Button } from "$lib/components/ui/button/index.js";

  debugData([
    {
      action: 'resetConfirm',
      data: true
    }
  ]);

  let reset_confirm = false
  useNuiEvent<boolean>('resetConfirm', (data) => {
    reset_confirm = data
  })

  const HandleConfirm = (confirm: boolean) => {
    fetchNui('resetConfirm', confirm);
    reset_confirm = false;
  }

</script>

<div class="absolute size-[99%] flex justify-center items-center box-border z-10">
  {#if reset_confirm}
    <div class="confirm absolute">
      <div class="text-center p-2">
        <p>Are you sure you want to reset the handling?</p>
        <p>This cannot be undone!</p>
      </div>
      <div class="text-center">
        <Button class="mb-2" on:click={() => HandleConfirm(true)}>Yes</Button>
        <Button class="mb-2" on:click={() => HandleConfirm(false)}>No</Button>
      </div>
    </div>
  {/if}
</div>

<style>
  .confirm {
    border: 1px var(--border-color) solid;
    border-radius: 5px;
    background-color: var(--bg-color);
    margin: 50px auto 50px 50px;
    animation: 3s infinite alternate slide-in;
}
</style>
