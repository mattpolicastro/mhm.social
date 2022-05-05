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
    
    if (randomTagline < 0.1) {this.tagline = 'just post through it'}
    else if (randomTagline < 0.2) {this.tagline = 'release your drafts, embrace the void'}
    else if (randomTagline < 0.4) {this.tagline = 'an overwrought .plan file'}
  }
}
</script>