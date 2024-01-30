import './assets/main.css'

import { createApp } from 'vue'
import App from './App.vue'

import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

import { faCartShopping, faCartPlus, faMoneyBill } from '@fortawesome/free-solid-svg-icons'
import { faGithub } from '@fortawesome/free-brands-svg-icons'
import { faMagnifyingGlass } from '@fortawesome/free-solid-svg-icons'

library.add(faCartShopping, faGithub, faMagnifyingGlass, faCartPlus, faMoneyBill)

createApp(App)
    .component('font-awesome-icon', FontAwesomeIcon)
    .mount('#app')
