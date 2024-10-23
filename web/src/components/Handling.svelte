<script lang="ts">
    import { debugData } from '../utils/debugData';
    import { fetchNui } from '../utils/fetchNui';

    import * as Tooltip from "$lib/components/ui/tooltip";

    console.log('handling start')
    export let handling_data: HandlingData[]

</script>

<div class="handling-container">
    <ol class="w-full">
        <li class="header">
            <div id="header-name" class="text-blue-500">Name</div>
            <div id="header-base">Base Value</div>
            <div id="header-current">Current Value</div>
        </li>
        {#if handling_data}            
            {#each handling_data as handling}
                <li class="handling-item">
                    <div class="name">
                        <Tooltip.Root disableHoverableContent={true}>
                            <Tooltip.Trigger> {handling.name} </Tooltip.Trigger>
                            <Tooltip.Content>
                                <div>{@html handling.description}</div>
                            </Tooltip.Content>
                        </Tooltip.Root>
                    </div>
                    <div class="base">{Math.round(handling.value)}</div>
                    <div class="current">{Math.round(handling.value)}</div>
                </li>
            {/each}
        {/if}
    </ol>
</div>

<style>
.handling-container {
    display: flex;
    flex-grow: 1;
    border: 1px var(--border-color) solid;
    border-radius: 5px;
    background-color: var(--bg-color);
    margin: 50px auto 50px 50px;
    width: 500px;
}
li {
    display: flex;
}
li.header>div {
    padding-top: 2px;
    display: flex;
    text-align: center;
    justify-content: center;
    align-items: center;
}
li.header>div#header-name {
    width: 60%;
}
li.header>div#header-base {
    width: 20%;
    padding: 0 2px 0 2px;
}
li.header>div#header-current {
    width: 20%;
}
div.name {
    text-align: left;
    width: 60%;
}
li.handling-item>div.base {
    width: 20%;
    text-align: right;
}
li.handling-item>div.current {
    width: 20%;
    text-align: right;
}
</style>
