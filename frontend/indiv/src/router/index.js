import { createRouter, createWebHistory } from 'vue-router';
import Main from '@/components/layout/Main.vue';
import menuData from '@/router/menu.json';
// import Home from '/indiv/src/views/home/Home.vue';

const modules = import.meta.glob('@/views/**/*.vue');

function generateRoutes(menuData) {
    return menuData.map(menu => {
        return {
            path: menu.path,
            name: menu.name,
            component: modules[menu.component.replace('@', '/src')]
        } 
    });
}

const dynamicRoutes = generateRoutes(menuData);

const routes = [
    {
        path: '/',
        name: 'main',
        component: Main,
        children: dynamicRoutes
    }
];

const router = createRouter({
    history: createWebHistory(import.meta.env.BASE_URL),
    routes,
    scrollBehavior() {
        return {
            top : 0
        }
    }
});

export default router;
