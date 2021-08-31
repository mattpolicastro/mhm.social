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


<script>
export default {
    name: 'Mhm'
    , data() {
        return {
            config: {
                lengthLimit: 140
                , localStorageKey: 'mhmHistory'
            }
            , mhmContent: ''
            , mhmSounds: []
            , mhmHistory: []
            , showHistory: true
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
        // if (rawLsMhmHistory) {
            console.log('mounting history')
            const lsMhmHistory = JSON.parse(rawLsMhmHistory)
            // console.log(lsMhmHistory)
            if (Array.isArray(lsMhmHistory)) {
                this.mhmHistory = lsMhmHistory
            }
        // }

        // 
        this.syncHistory()
    }
    , methods: {
        deleteHistory() {
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
                this.syncHistory()
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
            const sortedHistory = this.mhmHistory.sort((a, b) => (a.timestamp < b.timestamp) ? 1 : -1)

            this.mhmHistory = sortedHistory

            // Write current history to LS
            window.localStorage.setItem(this.config.localStorageKey, JSON.stringify(this.mhmHistory))
        }
        , toggleHistory() {
            this.showHistory = !this.showHistory
        }
    }
    // , watch: {
    //     mhmHistory(newHistory, oldHistory) {
    //         console.log(newHistory, oldHistory)
    //         this.syncHistory()
    //     }
    // }
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