<template>
  <div>
    <h1>mhm.</h1>
    <i>{{tagline}}</i>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'

const tagline = ref('an asocial (not/net)work')

onMounted(() => {
  const randomTagline = Math.random()

  if (randomTagline < 0.1) { tagline.value = 'just post through it' }
  else if (randomTagline < 0.2) { tagline.value = 'release your drafts, embrace the void' }
  else if (randomTagline < 0.4) { tagline.value = 'an overwrought .plan file' }
})
</script>
