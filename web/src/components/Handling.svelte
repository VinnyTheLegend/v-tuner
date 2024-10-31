<script lang="ts">
    import check from "../assets/check.svg" 
    import img_x from "../assets/img_x.svg"
    import { debugData } from '../utils/debugData';
    import { fetchNui } from '../utils/fetchNui';

    import * as Tooltip from "$lib/components/ui/tooltip";
    import { Input } from "$lib/components/ui/input";
    import { fly } from 'svelte/transition';

    console.log('handling start')
    export let handling_data: HandlingData[]
    export let base_handling: HandlingData[]

    const sleep = (milliseconds: number) => {
        return new Promise(resolve => setTimeout(resolve, milliseconds))
    }

    interface Loading {
        spinner: boolean,
        check: boolean,
        x: boolean
    }
    let current_loading: Loading[] = []
    let base_loading: Loading[] = []

    async function checkxCurrent(index: number, icon: string) {
        if (icon === "check") {
            current_loading[index] = {
                spinner: false,
                check: true,
                x: false,
            }
            await sleep(500)
            current_loading[index].spinner = false
        } else if (icon === "x") {
            current_loading[index] = {
                spinner: false,
                check: false,
                x: true
            }
        }
    }

    async function checkxBase(index: number, icon: string) {
        if (icon === "check") {
            base_loading[index] = {
                spinner: false,
                check: true,
                x: false,
            }
            await sleep(500)
            base_loading[index].check = false
        } else if (icon === "x") {
            base_loading[index] = {
                spinner: false,
                check: false,
                x: true
            }
        }
    }

    function updateCurrentHandling(key: number) {
        let value: number | undefined = undefined
        let index: number | undefined = undefined
        for (let i = 0; i < handling_data.length; i++) {
            if (handling_data[i].key === key) {
                console.log(handling_data[i]);
                value = handling_data[i].value
                index = i
                current_loading[i] = {
                    spinner: true,
                    check: false,
                    x: false,
                }
            }
        }
    
        if (value === undefined) return 
        
        fetchNui("updateCurrentHandling", {key: key, value: value}).then(retData => {
            console.log('Got return data from client scripts:', retData);
            if (index != undefined) {
                current_loading[index].spinner = false
                if (retData !== false) checkxCurrent(index, "check"); else checkxCurrent(index, "x")
            }
        }).catch(error => {
            console.log(error)
            if (index != undefined) {
                current_loading[index].spinner = false
                checkxCurrent(index, "x")
            }
        })
    }

    function updateBaseHandling(key: number) {
        let value: number | undefined = undefined
        let index: number | undefined = undefined
        let name: string | undefined = undefined

        for (let i = 0; i < base_handling.length; i++) {
            if (base_handling[i].key === key) {
                console.log(base_handling[i]);
                value = base_handling[i].value
                name = base_handling[i].name
                index = i
                base_loading[i] = {
                    spinner: true,
                    check: false,
                    x: false,
                }
            }
        }
    
        if (value === undefined) return 
        
        fetchNui("updateBaseHandling", {key: key, field: name, value: value}).then(retData => {
            console.log('Got return data from client scripts:', retData);
            if (index != undefined) {
                base_loading[index].spinner = false
                if (retData !== false) checkxBase(index, "check"); else checkxBase(index, "x")
            }
        }).catch(error => {
            console.log(error)
            if (index !== undefined) {
                base_loading[index].spinner = false
                checkxBase(index, "x")
            }
        })
    }


</script>

<div class="handling-container" transition:fly="{{ x: -600, duration: 500 }}"> 
    <ol class="size-full overflow-auto">
        <li class="header">
            <div id="header-name">Name</div>
            <div id="header-base">Base Value</div>
            <div id="header-current">Current Value</div>
        </li>
        {#if handling_data}            
            {#each handling_data as handling, i}
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
                        {#if base_loading != undefined && base_loading[i] != undefined && base_loading[i].spinner}
                            <span class="loader"></span>
                        {/if}
                        {#if base_loading != undefined && base_loading[i] != undefined && base_loading[i].check}
                            <img class="absolute pl-1" src={check} alt="">
                        {/if}
                        {#if base_loading != undefined && base_loading[i] != undefined && base_loading[i].x}
                            <img class="absolute pl-1" src={img_x} alt="">
                        {/if}
                        {#if base_handling && base_handling[i]}
                            <Input class="text-right h-auto bg-gray-800" bind:value={base_handling[i].value} on:input={(event) => updateBaseHandling(handling.key)}/>
                        {:else}
                            <Input class="text-right h-auto bg-gray-800" disabled/>
                        {/if}
                    </div>
                    <div class="current">
                        {#if current_loading != undefined && current_loading[i] != undefined && current_loading[i].spinner}
                            <span class="loader"></span>
                        {/if}
                        {#if current_loading != undefined && current_loading[i] != undefined && current_loading[i].check}
                            <img class="absolute pl-1" src={check} alt="">
                        {/if}
                        {#if current_loading != undefined && current_loading[i] != undefined && current_loading[i].x}
                            <img class="absolute pl-1" src={img_x} alt="">
                        {/if}
                        <Input class="text-right h-auto bg-gray-800" bind:value={handling.value} on:input={(event) => updateCurrentHandling(handling.key)}/>
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
    width: 620px;
    animation: 3s infinite alternate slide-in;
}
li {
    display: flex;
}
li:nth-child(even) {
    background-color: rgba(44, 0, 44, 0.801);
}
li.header>div {
    color: var(--text-highlight);
    padding-top: 5px;
    display: flex;
    text-align: center;
    justify-content: center;
    align-items: center;
    border-bottom: 1px solid var(--border-color)
}
li.header>div#header-name {
    width: 50%;
}
li.header>div#header-base {
    width: 25%;
}
li.header>div#header-current {
    width: 25%;
}
div.name {
    display: flex;
    text-align: left;
    width: 50%;
    align-items: center;
}
.base, .current {
    width: 25%;
    padding: 2px;
    position: relative;
    display: flex;
    align-items: center;
}

.base>img, .current>img {
    width: 22px;
    height: 22px
}

.loader {
  width: 22px;
  height: 22px;
  border-radius: 50%;
  display: inline-block;
  position: absolute;
  border: 3px solid;
  border-color: #FFF #FFF transparent;
  box-sizing: border-box;
  animation: rotation 1s linear infinite;
}
.loader::after {
  content: '';  
  box-sizing: border-box;
  position: absolute;
  left: 0;
  right: 0;
  top: 0;
  bottom: 0;
  margin: auto;
  border: 3px solid;
  border-color: transparent #FF3D00 #FF3D00;
  width: 10px;
  height: 10px;
  border-radius: 50%;
  animation: rotationBack 0.5s linear infinite;
  transform-origin: center center;
}

@keyframes rotation {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(360deg);
  }
} 
    
@keyframes rotationBack {
  0% {
    transform: rotate(0deg);
  }
  100% {
    transform: rotate(-360deg);
  }
}
</style>
