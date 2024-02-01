import './assets/main.css'

import { createApp } from 'vue'
import App from './App.vue'

import { library } from '@fortawesome/fontawesome-svg-core'
import { FontAwesomeIcon } from '@fortawesome/vue-fontawesome'

import { faMagnifyingGlass, faCartShopping, faCartPlus, faMoneyBill, faStar, faBook } from '@fortawesome/free-solid-svg-icons'
import { faStar as faStarEmpty, faSadTear } from '@fortawesome/free-regular-svg-icons'
import { faGithub } from '@fortawesome/free-brands-svg-icons'

library.add(faCartShopping, faGithub, faMagnifyingGlass, faCartPlus, faMoneyBill, faStar, faStarEmpty, faSadTear, faBook)

createApp(App)
    .component('font-awesome-icon', FontAwesomeIcon)
    .mount('#app')
