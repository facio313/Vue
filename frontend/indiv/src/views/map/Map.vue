<template>
    <h1>Map</h1>
    <p v-if="!hasSpatialLayers" class="demoNotice">
        공개 데모에는 원본 LH 공간 데이터와 GeoServer가 포함되지 않아 WMS 레이어 조회를 비활성화했습니다.
        기본 지도와 로컬 도형 그리기는 계속 사용할 수 있습니다.
    </p>
    <div id="mapBox"></div>
    <Toggle
        v-if="map && hasSpatialLayers"
        :map="map"
        :layers="layers"
        :createTileLayer="createTileLayer"
    />
    <div class="mouseControl">
        <label>
            <input
                type="radio"
                name="mouseGroup"
                v-model="selectedTool"
                value="feature"
                :disabled="!hasSpatialLayers"
            />
            공간 레이어 조회
        </label>
        <label><input type="radio" name="mouseGroup" v-model="selectedTool" value="draw" />도형 그리기</label>
    </div>
    <Feature v-if="map && selectedTool === 'feature' && hasSpatialLayers" :map="map" :layers="layers" />
    <Draw v-if="map && selectedTool === 'draw'" :map="map" />
    <Marker v-if="map" :map="map" />
</template>

<script setup>
import { computed, onMounted, ref } from 'vue';
import Toggle from '@/components/map/Toggle.vue';
import Feature from '@/components/map/Feature.vue';
import Draw from '@/components/map/Draw.vue';
import Marker from '@/components/map/Marker.vue';

import { Map, View } from 'ol';
import { OSM, TileWMS, XYZ } from 'ol/source';
import { fromLonLat } from 'ol/proj';
import TileLayer from 'ol/layer/Tile';
import 'ol/ol.css';

const geoserverWmsUrl = (import.meta.env.VITE_GEOSERVER_WMS_URL || '').trim();
const vworldApiKey = (import.meta.env.VITE_VWORLD_API_KEY || '').trim();
const vworldTileUrlTemplate = (import.meta.env.VITE_VWORLD_TILE_URL_TEMPLATE || '').trim();
const map = ref(null);
const selectedTool = ref(geoserverWmsUrl ? 'feature' : 'draw');

const layerDefinitions = [
    { name: 'sgg', label: 'SGG Layer', layer: 'lh:tl_sgg', style: 'lh:tl_sgg' },
    { name: 'ground', label: 'Ground Layer', layer: 'lh:tl_ground', style: 'lh:tl_ground' },
    { name: 'rw', label: 'RW Layer', layer: 'lh:tl_rw', style: 'lh:tl_rw' },
    { name: 'road', label: 'Road Layer', layer: 'lh:tl_road', style: 'lh:tl_road' },
    { name: 'basic', label: 'Basic Layer', layer: 'lh:tl_basic', style: 'lh:tl_basic' },
    { name: 'eqb', label: 'EQB Layer', layer: 'lh:tl_eqb', style: 'lh:tl_eqb' },
    { name: 'buld', label: 'Buld Layer', layer: 'lh:tl_buld', style: 'lh:tl_buld' },
    { name: 'entrance', label: 'Entrance Layer', layer: 'lh:tl_entrance', style: 'lh:tl_entrance' },
    { name: 'test', label: 'Test Layer', layer: 'lh:tl_test', style: 'lh:tl_test' },
];
const layers = geoserverWmsUrl ? layerDefinitions : [];
const hasSpatialLayers = computed(() => layers.length > 0);

const createTileWMSSource = (layer, style) => new TileWMS({
    url: geoserverWmsUrl,
    params: {
        SERVICE: 'WMS',
        VERSION: '1.1.0',
        REQUEST: 'GetMap',
        LAYERS: layer,
        SRS: 'EPSG:3857',
        FORMAT: 'image/png',
        TILED: true,
        TRANSPARENT: true,
        STYLES: style,
    },
    serverType: 'geoserver',
});

const createTileLayer = (layer) => new TileLayer({
    source: createTileWMSSource(layer.layer, layer.style),
    properties: { name: layer.name },
});

const createBaseSource = () => {
    if (vworldApiKey && vworldTileUrlTemplate) {
        return new XYZ({
            url: vworldTileUrlTemplate.replace('{key}', encodeURIComponent(vworldApiKey)),
            attributions: ['© VWorld'],
            maxZoom: 19,
        });
    }
    return new OSM();
};

onMounted(() => {
    map.value = new Map({
        target: 'mapBox',
        layers: [
            new TileLayer({ source: createBaseSource(), properties: { name: 'base' } }),
            ...layers.map(layer => createTileLayer(layer)),
        ],
        view: new View({
            center: fromLonLat([126.9811405697578, 37.47833241217628]),
            zoom: 18,
        }),
    });
});
</script>

<style scoped>
#mapBox {
    width: 100%;
    height: 62%;
    min-height: 320px;
}
.demoNotice {
    padding: 12px 14px;
    border: 1px solid #d8c7b7;
    border-radius: 8px;
    background: #fff8ef;
    line-height: 1.5;
}
.mouseControl {
    display: flex;
    gap: 16px;
    margin: 12px 0;
}
</style>
