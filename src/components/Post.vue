<template>
    <textarea
        v-model="mhmContent"
        v-bind:maxlength="config.lengthLimit"
        @keyup.ctrl.enter="postMhm"
        placeholder="what's on your mind?"
    />
    <div class="post-controls">
        <i>{{mhmLength}}/{{config.lengthLimit}} characters</i>
        <span class="button" @click="postMhm">mhm.</span>
    </div>
    <div v-if="mhmHistory.length > 0">
        <h2 @click="toggleHistory">history {{showHistory ?  '▼' : '◀︎'}}</h2>
        <div v-if="showHistory" class="post-history">
            <i>these posts aren't stored anywhere other than your device.</i>
            <ul >
                <li v-for="mhm in mhmHistory" :key="mhm.timestamp">
                    <p>{{mhm.content}}</p><i>{{timestampHelper(mhm.timestamp)}} ago</i>
                </li>
            </ul>
            <span class="button" v-on:click="deleteHistory">delete history</span>
        </div>
    </div>
</template>


<script setup>
import { ref, computed, onMounted } from 'vue'

const config = {
    lengthLimit: 140,
    localStorageKey: 'mhmHistory'
}

const mhmContent = ref('')
const mhmSounds = ref([])
const mhmHistory = ref([])
const showHistory = ref(true)

const mhmLength = computed(() => mhmContent.value.length)

// Eagerly glob all mp3s in ../assets/sounds and store their URLs
const soundModules = import.meta.glob('../assets/sounds/*.mp3', { query: '?url', import: 'default', eager: true })
mhmSounds.value = Object.values(soundModules).map(path => ({ path }))

onMounted(() => {
    // Perform one-time check for mhm history in LS
    const rawLsMhmHistory = window.localStorage.getItem('mhmHistory')
    console.log('mounting history')
    const lsMhmHistory = JSON.parse(rawLsMhmHistory)
    if (Array.isArray(lsMhmHistory)) {
        mhmHistory.value = lsMhmHistory
    }

    syncHistory()
})

function deleteHistory() {
    mhmHistory.value = []
    syncHistory()
}

function playSound() {
    const randomMhm = mhmSounds.value[Math.floor(Math.random() * mhmSounds.value.length)]
    new Audio(randomMhm.path).play()
}

function postMhm() {
    if (mhmContent.value === '') {
        return
    } else {
        const currentMhm = {
            content: mhmContent.value,
            timestamp: Date.now()
        }
        mhmHistory.value.unshift(currentMhm)
        syncHistory()
        playSound()
        mhmContent.value = ''
    }
}

function timestampHelper(timestamp) {
    const timestampDelta = (Date.now() - timestamp)

    if (timestampDelta < 6e+4) { return `${Math.floor(timestampDelta / 1e+3)} seconds` } else
    if (timestampDelta < 3.6e+6) { return `${Math.floor(timestampDelta / 6e+4)} minutes` } else
    if (timestampDelta < 8.64e+7) { return `${Math.floor(timestampDelta / 3.6e+6)} hours` } else
    return `${Math.floor(timestampDelta / 8.64e+7)} days`
}

function syncHistory() {
    // Force sort of history just to be safe
    const sortedHistory = mhmHistory.value.sort((a, b) => (a.timestamp < b.timestamp) ? 1 : -1)

    mhmHistory.value = sortedHistory

    // Write current history to LS
    window.localStorage.setItem(config.localStorageKey, JSON.stringify(mhmHistory.value))
}

function toggleHistory() {
    showHistory.value = !showHistory.value
}
</script>

<style scoped>
.post-controls {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-top: 1em;
}
.post-history {
    margin-top: 0em;
}
li {
    margin: 3em auto;
    border-left: 0.5em solid rgb(3, 117, 121);
    padding-right: 0.5em;
}
li > i {
    font-size: 0.9em;
}
button {
    padding: 0.5em;
}
textarea {
    font-family: 'Montserrat';
    font-weight: 500;
    font-size: 1.3em;
    display: block;
    width: 100%;
    height: 7em;
    box-sizing: border-box;
    resize: none;
    padding: 0.5em;
}
</style>
