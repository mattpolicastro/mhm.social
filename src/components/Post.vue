<template>
    <div>
        <textarea 
            v-model="mhmContent" 
            v-bind:maxlength="config.lengthLimit" 
            @keyup.ctrl.enter="postMhm"
            placeholder="post here"
        />
        <i>Using {{mhmLength}}/{{config.lengthLimit}}</i>
        <button v-on:click="postMhm">mhm.</button>
        <FAQ />
        <div v-if="mhmHistory.length > 0">
            <div v-for="mhm in mhmHistory" :key="mhm.timestamp">
                <p>{{mhm.content}}</p><i>{{timestampHelper(mhm.timestamp)}} ago</i>
            </div>
            <button v-on:click="clearHistory">clear history</button>
        </div>
    </div>
</template>


<script>
import FAQ from './FAQ.vue'

export default {
    name: 'Mhm'
    , components: {
        FAQ
    }
    , data() {
        return {
            config: {
                lengthLimit: 140
                , localStorageKey: 'mhmHistory'
            }
            , mhmContent: ''
            , mhmSounds: []
            , mhmHistory: []
        }
    }
    , computed: {
        mhmLength() {
            return(this.mhmContent.length)
        }
    }
    , mounted() {
        // The `importSounds` workaround for sound file loading inspired by: https://stackoverflow.com/questions/54095215/how-to-get-all-the-image-files-in-a-directory-using-vue-js-nuxt-js
        this.importSounds(require.context('../assets/sounds', true, /\.mp3$/))
        
        // Perform one-time check for mhm history in LS
        const rawLsMhmHistory = window.localStorage.getItem('mhmHistory')
        if (rawLsMhmHistory) {
            const lsMhmHistory = JSON.parse(rawLsMhmHistory)
            if (Array.isArray(lsMhmHistory)) {
                this.mhmHistory = lsMhmHistory
            }
        }

        // 
        this.syncHistory()
    }
    , methods: {
        clearHistory() {
            this.mhmHistory = []
            this.syncHistory()
        }
        , importSounds(r) {
            r.keys().forEach(key => {
                this.mhmSounds.push({path: r(key)})
            })
        }
        , playSound() {
            const randomMhm = this.mhmSounds[Math.floor(Math.random() * this.mhmSounds.length)]
            new Audio(randomMhm.path).play()
        }
        , postMhm() {
            if (this.mhmContent === '') {
                return
            } else {
                const currentMhm = {
                    content: this.mhmContent
                    , timestamp: Date.now()
                }
                this.mhmHistory.unshift(currentMhm)
                this.playSound()
                this.mhmContent = ''
            }
        }
        , timestampHelper(timestamp) {
            const timestampDelta = (Date.now() - timestamp)

            if (timestampDelta < 6e+4) {return `${Math.floor(timestampDelta / 1e+3)} seconds`} else
            if (timestampDelta < 3.6e+6) {return `${Math.floor(timestampDelta / 6e+4)} minutes`} else
            if (timestampDelta < 8.64e+7) {return `${Math.floor(timestampDelta / 3.6e+6)} hours`} else
            return `${Math.floor(timestampDelta / 8.64e+7)} days`
            
        }
        , syncHistory() {
            // Force sort of history just to be safe
            this.mhmHistory = this.mhmHistory.sort((a, b) => (a.timestamp < b.timestamp) ? 1 : -1)

            // Write current history to LS
            window.localStorage.setItem(this.config.localStorageKey, JSON.stringify(this.mhmHistory))
        }
    }
    , watch: {
        mhmHistory() {
            this.syncHistory()
        }
    }
}
</script>
