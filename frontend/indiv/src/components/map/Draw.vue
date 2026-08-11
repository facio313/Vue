<template>
    <div class="drawControl">
        <label for="type">Geometry type</label>
        <select id="type" v-model="typeSelect">
            <option value="">-선택-</option>
            <option value="Point">Point</option>
            <option value="LineString">LineString</option>
            <option value="Polygon">Polygon</option>
            <option value="Circle">Circle</option>
        </select>
        <button type="button" :disabled="featureCount === 0" @click="clearDrawings">로컬 도형 지우기</button>
        <button type="button" :disabled="!canPersist || featureCount === 0" @click="insertDraw">DB에 저장</button>
        <span v-if="!canPersist" class="status">공개 데모에서는 DB 저장이 비활성화되어 있습니다.</span>
        <span v-else-if="statusMessage" class="status">{{ statusMessage }}</span>
    </div>
</template>

<script setup>
import { computed, onBeforeUnmount, onMounted, ref, watch } from 'vue';
import { Draw, Modify, Snap } from 'ol/interaction.js';
import { Vector as VectorSource } from 'ol/source.js';
import { Vector as VectorLayer } from 'ol/layer.js';
import GeoJSON from 'ol/format/GeoJSON';
import { Circle as CircleStyle, Fill, Stroke, Style } from 'ol/style';

const props = defineProps({
    map: Object,
});
const map = props.map;
const apiBaseUrl = (import.meta.env.VITE_API_BASE_URL || '').trim().replace(/\/$/, '');
const canPersist = computed(() => Boolean(apiBaseUrl));
const vectorSource = new VectorSource();
const vectorLayer = new VectorLayer({
    source: vectorSource,
    style: new Style({
        fill: new Fill({ color: 'rgba(255, 255, 255, 0.7)' }),
        stroke: new Stroke({ color: '#ffcc33', width: 2 }),
        image: new CircleStyle({ radius: 7, fill: new Fill({ color: '#ffcc33' }) }),
    }),
});

const draw = ref(null);
const snap = ref(null);
const modify = ref(null);
const typeSelect = ref('');
const featureCount = ref(0);
const statusMessage = ref('');

vectorSource.on('change', () => {
    featureCount.value = vectorSource.getFeatures().length;
});

const removeDrawInteractions = () => {
    if (draw.value) map.removeInteraction(draw.value);
    if (snap.value) map.removeInteraction(snap.value);
    draw.value = null;
    snap.value = null;
};

const addInteractions = () => {
    if (!typeSelect.value) return;
    draw.value = new Draw({ source: vectorSource, type: typeSelect.value });
    map.addInteraction(draw.value);
    snap.value = new Snap({ source: vectorSource });
    map.addInteraction(snap.value);
};

const clearDrawings = () => {
    vectorSource.clear();
    statusMessage.value = '';
};

const insertDraw = async () => {
    if (!canPersist.value || featureCount.value === 0) return;

    const geoJsonFormat = new GeoJSON();
    const feature = vectorSource.getFeatures()[0];
    const geometry = JSON.parse(geoJsonFormat.writeFeature(feature)).geometry;
    const requestBody = { page: null, dto: { geoJson: JSON.stringify(geometry) } };

    statusMessage.value = '저장 중…';
    try {
        const response = await fetch(`${apiBaseUrl}/draw/insert`, {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify(requestBody),
        });
        if (!response.ok) throw new Error(`HTTP ${response.status}`);
        vectorSource.clear();
        statusMessage.value = '저장했습니다.';
    } catch (error) {
        console.error('Geometry save failed', error);
        statusMessage.value = '저장하지 못했습니다. API 설정을 확인하세요.';
    }
};

onMounted(() => {
    map.addLayer(vectorLayer);
    modify.value = new Modify({ source: vectorSource });
    map.addInteraction(modify.value);
    addInteractions();
});

onBeforeUnmount(() => {
    removeDrawInteractions();
    if (modify.value) map.removeInteraction(modify.value);
    map.removeLayer(vectorLayer);
});

watch(typeSelect, () => {
    removeDrawInteractions();
    addInteractions();
}, { flush: 'post' });
</script>

<style scoped>
.drawControl {
    display: flex;
    flex-wrap: wrap;
    align-items: center;
    gap: 8px;
}
button,
select {
    min-height: 32px;
}
.status {
    color: #725744;
    font-size: 0.9rem;
}
</style>
