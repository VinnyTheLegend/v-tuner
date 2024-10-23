<script lang="ts">
    import { debugData } from '../utils/debugData';
    import { fetchNui } from '../utils/fetchNui';

    import * as Tooltip from "$lib/components/ui/tooltip";
    import { Input } from "$lib/components/ui/input";
    import { fly } from 'svelte/transition';

    console.log('handling start')
    export let handling_data: HandlingData[]


</script>

<div class="handling-container" transition:fly="{{ x: -600, duration: 500 }}"> 
    <ol class="size-full overflow-auto">
        <li class="header">
            <div id="header-name">Name</div>
            <div id="header-base">Base Value</div>
            <div id="header-current">Current Value</div>
        </li>
        {#if handling_data}            
            {#each handling_data as handling}
                <li class="handling-item">
                    <div class="name">
                        <Tooltip.Root disableHoverableContent={true} closeOnPointerDown={false}>
                            <Tooltip.Trigger> {handling.name} </Tooltip.Trigger>
                            <Tooltip.Content>
                                <div>{@html handling.description}</div>
                            </Tooltip.Content>
                        </Tooltip.Root>
                    </div>
                    <div class="base">
                        <Input class="text-right h-auto bg-gray-800" value={Math.floor(handling.value * 1000) / 1000} disabled> </Input>
                    </div>
                    <div class="current">
                        <Input class="text-right h-auto bg-gray-800" value={Math.floor(handling.value * 1000) / 1000}> </Input>
                    </div>
                </li>
            {/each}
        {/if}
    </ol>
</div>

<style>
.handling-container {
    height: calc(100vh - 100px);
    border: 1px var(--border-color) solid;
    border-radius: 5px;
    background-color: var(--bg-color);
    margin: 50px auto 50px 50px;
    width: 550px;
    animation: 3s infinite alternate slide-in;
}
li {
    display: flex;
}
li:nth-child(even) {
    background-color: rgba(54, 1, 54, 0.801);
}
li.header>div {
    color: var(--text-highlight);
    padding-top: 2px;
    display: flex;
    text-align: center;
    justify-content: center;
    align-items: center;
    border-bottom: 1px solid var(--border-color)
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
li.handling-item {
}
div.name {
    display: flex;
    text-align: left;
    width: 60%;
    align-items: center;
}
.base, .current {
    width: 20%;
    padding: 2px
}
</style>
