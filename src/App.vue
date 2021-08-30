<template>
  <Header />
  <Mhm />
  <Footer />
</template>

<script>
// import HelloWorld from './components/HelloWorld.vue'
import Header from './components/Header.vue'
import Mhm from './components/Post.vue'
import Footer from './components/Footer.vue'

export default {
  name: 'App',
  components: {
    Header
    , Mhm
    , Footer
  }
}
</script>

<style>
#app {
  font-family: 'Montserrat', Helvetica, Arial, sans-serif;
  -webkit-font-smoothing: antialiased;
  -moz-osx-font-smoothing: grayscale;
  text-align: center;
  color: #2c3e50;
  margin-top: 60px;
}
h1, h2, h3, h4, h5, h6, button {
  font-weight: 900;
}
div {
  margin: 3em auto 3em auto;
}
</style>
