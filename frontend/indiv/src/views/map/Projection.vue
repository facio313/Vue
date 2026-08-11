<template>
    <h1>Projection</h1>
    <p v-if="!isConfigured" class="demoNotice">
        EPSG:5174 투영 실험은 LH GeoServer 레이어가 필요합니다. 공개 저장소에는 원본 공간 데이터가 없으므로
        현재는 설명만 제공합니다.
    </p>
    <div v-if="isConfigured" id="projectionMap"></div>
</template>

<script setup>
import { computed, onMounted } from 'vue';
import 'ol/ol.css';
import { Map, View } from 'ol';
import TileLayer from 'ol/layer/Tile';
import { TileWMS, XYZ } from 'ol/source';
import { get as getProjection } from 'ol/proj';
import { register } from 'ol/proj/proj4';
import proj4 from 'proj4';

const geoserverWmsUrl = (import.meta.env.VITE_GEOSERVER_WMS_URL || '').trim();
const vworldApiKey = (import.meta.env.VITE_VWORLD_API_KEY || '').trim();
const vworldTileUrlTemplate = (import.meta.env.VITE_VWORLD_TILE_URL_TEMPLATE || '').trim();
const isConfigured = computed(() => Boolean(geoserverWmsUrl));

proj4.defs(
    'EPSG:5174',
    '+proj=tmerc +lat_0=38 +lon_0=127.0028902777778 +k=1 +x_0=200000 +y_0=600000 +ellps=bessel +towgs84=-146.43,507.89,681.46,0.0,0.0,0.0,0.0 +units=m +no_defs'
);
register(proj4);
const projection5174 = getProjection('EPSG:5174');

const createWmsLayer = (layer, style) => new TileLayer({
    source: new TileWMS({
        url: geoserverWmsUrl,
        params: {
            SERVICE: 'WMS',
            VERSION: '1.1.0',
            REQUEST: 'GetMap',
            LAYERS: layer,
            SRS: 'EPSG:5174',
            FORMAT: 'image/png',
            TILED: true,
            TRANSPARENT: true,
            STYLES: style,
        },
        serverType: 'geoserver',
    }),
});

onMounted(() => {
    if (!isConfigured.value) return;

    const mapLayers = [];
    if (vworldApiKey && vworldTileUrlTemplate) {
        mapLayers.push(new TileLayer({
            source: new XYZ({
                url: vworldTileUrlTemplate.replace('{key}', encodeURIComponent(vworldApiKey)),
                attributions: ['© VWorld'],
                maxZoom: 19,
            }),
        }));
    }
    mapLayers.push(
        createWmsLayer('lh:tl_sgg', 'lh:tl_sgg'),
        createWmsLayer('lh:tl_ground', 'lh:tl_ground'),
        createWmsLayer('lh:tl_purpose', 'lh:tl_purpose'),
        createWmsLayer('lh:tl_juso', 'lh:tl_juso'),
    );

    new Map({
        target: 'projectionMap',
        layers: mapLayers,
        view: new View({
            center: [195197.28181, 544538.61928],
            zoom: 14,
            projection: projection5174,
        }),
    });
});
</script>

<style scoped>
#projectionMap {
    width: 100%;
    height: 65vh;
}
.demoNotice {
    max-width: 760px;
    padding: 16px;
    border: 1px solid #d8c7b7;
    border-radius: 8px;
    background: #fff8ef;
    line-height: 1.6;
}
</style>
