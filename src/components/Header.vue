<template>
  <div>
    <h1>mhm.</h1>
    <i>{{tagline}}</i>
  </div>
</template>

<script>
export default {
  name: 'Header'
  , data() {
    return {
      tagline: 'an asocial (not/net)work'
    }
  }
  , mounted() {
    const randomTagline = Math.random()

    if (randomTagline < 0.05) {this.tagline = 'just post through it'}
    if (randomTagline < 0.10) {this.tagline = 'release your drafts, embrace the void'}
  }
}
</script>