<script lang="ts">
    import { debugData } from '../utils/debugData';
    import { fetchNui } from '../utils/fetchNui';

    console.log('handling start')
    export let handling_data: HandlingData[]

</script>

<div class="handling-container">
    <ol>
    <li class="header">
        <div id="name" class="text-blue-500">Name</div>
        <div id="base">Base Value</div>
        <div id="current">Current Value</div>
    </li>
    {#if handling_data}            
        {#each handling_data as handling}
            <li class="handling-item">
                <div id="name">{handling.name}</div>
                <div id="base">{Math.round(handling.value)}</div>
                <div id="current">{Math.round(handling.value)}</div>
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
li.header>div#name {
    width: 250px;
}
li.header>div#base {
    width: 100px;
    padding: 0 2px 0 2px;
}
li.header>div#current {
    width: 100px;
}
li.handling-item>div#name {
    width: 250px;
}
li.handling-item>div#base {
    width: 100px;
    text-align: right;
}
li.handling-item>div#current {
    width: 100px;
    text-align: right;
}
</style>
