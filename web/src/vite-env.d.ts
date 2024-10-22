/// <reference types="svelte" />
/// <reference types="vite/client" />

interface HUDdata {
    "top-speed": number,
    "top-accel": number,
    "top-decel": number,
    "gear": number
}

interface HandlingData {
    key: number,
    name: string,
    description: string,
    value: number
}