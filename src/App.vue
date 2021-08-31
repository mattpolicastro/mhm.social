<template>
  <Header />
  <Mhm />
  <FAQ />
  <Footer />
</template>

<script>
// import HelloWorld from './components/HelloWorld.vue'
import Header from './components/Header.vue'
import Mhm from './components/Post.vue'
import FAQ from './components/FAQ.vue'
import Footer from './components/Footer.vue'

export default {
  name: 'App',
  components: {
    Header
    , Mhm
    , FAQ
    , Footer
  }
}
</script>

<style>
#app {
  font-family: 'Montserrat', Helvetica, Arial, sans-serif;
  font-weight: 500;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  max-width: 22em;
}
h1, h2, h3, h4, h5, h6 {
  font-weight: 900;
}
div {
  margin: 3em auto 3em auto;
}
ul {
  list-style-type: none;
  padding: 0;
}
a {
  color: #42b983;
}
.button {
  font-weight: 900;
  color: white;
  background-color: rgb(3, 117, 121);
  border-radius: 0.3em;
  padding: .5em;
}
</style>
