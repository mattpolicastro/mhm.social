module.exports = {
  // Update the publicPath to reflect your hosting environment per the vue-cli deployment guide.
  publicPath: process.env.NODE_ENV === 'production'
    // ? '/mhm.social'
    ? '/'
    : '/'
}