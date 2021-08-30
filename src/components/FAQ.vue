<template>
  <div>
    <a><h2 @click="toggleFAQ">hm?</h2></a>
    <div v-if="showFAQ">
      <h3>what is this?</h3>
      <p>sometimes you just need to post something, but maybe nobody needs to see it.</p>
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
  color: #42b983;
}
</style>
