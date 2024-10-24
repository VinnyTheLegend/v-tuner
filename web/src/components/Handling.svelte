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

    const sleep = (milliseconds: number) => {
        return new Promise(resolve => setTimeout(resolve, milliseconds))
    }

    interface Loading {
        spinner: boolean,
        check: boolean,
        x: boolean
    }
    let loading: Loading[] = []

    async function checkx(index: number, icon: string) {
        if (icon === "check") {
            loading[index] = {
                spinner: false,
                check: true,
                x: false,
            }
        } else if (icon === "x") {
            loading[index] = {
                spinner: false,
                check: false,
                x: true
            }
        }
        await sleep(500)
        loading[index] = {
            spinner: false,
            check: false,
            x: false
        }
    }

    function updateHandling(key: number) {
        let value: number | undefined = undefined
        let index: number | undefined = undefined
        for (let i = 0; i < handling_data.length; i++) {
            if (handling_data[i].key === key) {
                console.log(handling_data[i]);
                value = handling_data[i].value
                index = i
                loading[i] = {
                    spinner: true,
                    check: false,
                    x: false,
                }
            }
        }
    
        if (value === undefined) return 
        
        fetchNui("updateHandling", {key: key, value: value}).then(retData => {
            console.log('Got return data from client scripts:', retData);
            if (index != undefined) {
                loading[index].spinner = false
                checkx(index, "check")
            }
        }).catch(error => {
            console.log(error)
            if (index != undefined) {
                loading[index].spinner = false
                checkx(index, "x")
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
                        <Input class="text-right h-auto bg-gray-800" bind:value={handling.value} disabled/>
                    </div>
                    <div class="current">
                        {#if loading != undefined && loading[i] != undefined && loading[i].spinner}
                            <span class="loader"></span>
                        {/if}
                        {#if loading != undefined && loading[i] != undefined && loading[i].check}
                            <img class="absolute pl-1" src={check} alt="">
                        {/if}
                        {#if loading != undefined && loading[i] != undefined && loading[i].x}
                            <img class="absolute" src={img_x} alt="">
                        {/if}
                        <Input class="text-right h-auto bg-gray-800" bind:value={handling.value} on:input={(event) => updateHandling(handling.key)}/>
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
