<template>
  <div>
    <h2 @click="toggleFAQ">huh? {{showFAQ ? '▼' : '◀︎'}}</h2>
    <div v-if="showFAQ">
      <h3>what is this?</h3>
      <p>sometimes you just need to get something off your chest, but figuring out how to say it is too hard.</p>
      <h3>what does that mean?</h3>
      <p>this is the asocial answer to twitter. it's a box where you can post things, but nobody can ever see them.</p>
      <p>(it does save your posts to a bucket on your computer, but this app will never send them anywhere, ever.)</p>
      <h3>why did you make this?</h3>
      <p>i keep finding myself wanting to tweet things then freeze up at the prospect of how people will read it, if i should try to be funny, etc.</p>  
      <p>mhm gives me some acknowledgement and lets me carry on with my day.</p>
    </div>
  </div>
</template>

<script>
export default {
  name: 'FAQ'
  , data() {
    return {
      showFAQ: false
    }
  }
  , methods: {
    toggleFAQ() {
      this.showFAQ = !this.showFAQ
    }
  }
}
</script>


<!-- Add "scoped" attribute to limit CSS to this component only -->
<style scoped>
h3 {
  margin: 40px 0 0;
}
ul {
  list-style-type: none;
  padding: 0;
}
li {
  display: inline-block;
  margin: 0 10px;
}
a {
  border-left-width: 0px;
}
</style>
