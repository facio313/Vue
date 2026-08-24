<template>
    <div class="header">
        <div class="menuArea">
            <a class="bonifacio-return-link" href="https://bonifacio.work/">← Bonifacio</a>
            <div class="appMenu">
                <Menu/>
            </div>
        </div>
        <div class="tabArea">
            <Tab/>
        </div>
    </div>
</template>
<script setup>
import Menu from '@/components/layout/Menu.vue';
import Tab from '@/components/layout/Tab.vue';

</script>
<style scoped>
.header {
    width: 100%;
    height: 100px;
    background-color: rgb(149, 124, 104);
    overflow: hidden;
    display: flex;
    flex-direction: column;
    justify-content: center;
    z-index: 9999;
}
.menuArea {
    width: 100%;
    height: 60%;
    display: flex;
    gap: 1rem;
    justify-content: flex-start;
    align-items: center;
    padding: 0 1rem;
    box-sizing: border-box;
    overflow-x: auto;
}
.appMenu {
    min-width: 650px;
    flex: 1 0 650px;
    display: flex;
    justify-content: space-around;
    align-items: center;
}
.bonifacio-return-link {
    position: sticky;
    left: 0;
    z-index: 1;
    display: inline-flex;
    min-width: 44px;
    min-height: 44px;
    flex: 0 0 auto;
    box-sizing: border-box;
    align-items: center;
    justify-content: center;
    padding: 0.55rem 0.75rem;
    border: 1px solid rgba(255, 255, 255, 0.54);
    border-radius: 6px;
    background: rgb(149, 124, 104);
    color: white;
    font-weight: 700;
    line-height: 1;
    text-decoration: none;
}
.bonifacio-return-link:hover {
    border-color: white;
    background: rgb(132, 107, 88);
}
.bonifacio-return-link:focus-visible {
    outline: 3px solid white;
    outline-offset: 2px;
}
.tabArea {
    width: 100%;
    height: 40%;
    padding-left: 50px;
    padding-top: 10px;
    display: flex;
    background-color: rgb(226, 226, 226);
}
</style>
