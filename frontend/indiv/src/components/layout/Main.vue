<template>
    <main>
        <section>
            <RouterView v-slot="{ Component }">
                <KeepAlive :include="cachedComponents">
                    <component :is="Component" :key="currentTab" />
                </KeepAlive>
            </RouterView>
        </section>
    </main>
</template>

<script setup>
import { onMounted, computed, ref, watch } from 'vue';
import { useRoute, useRouter } from 'vue-router';
import { useMenuStore } from '@/stores/menu';

const route = useRoute();
const router = useRouter();
const menuStore = useMenuStore();
const currentTab = computed(() => route.name);
const cachedComponents = ref([]);

// 처음 시작 시 home으로 이동
onMounted(() => {
    if (route.path === '/') {
        router.replace('/home');
        cachedComponents.value.push('Home')
    }
});

// 탭 새로고침 방지 (탭 변경 시 캐시 업데이트))
watch(() => menuStore.activeTab, (newTab) => {
    if (!cachedComponents.value.includes(newTab)) {
        cachedComponents.value.push(newTab);
    }
});

</script>

<style scoped>
main {
    background-color: rgb(226, 226, 226);
    padding-left: 50px;
    padding-right: 25px;
    padding-bottom: 50px;
    height: calc(100% - 100px);
}

section {
    background-color: white;
    border-radius: 0px 15px 15px 15px;
    padding: 1%;
    height: 100%;
    overflow-y: auto;
    transition: all 0.5s ease;
}
</style>
