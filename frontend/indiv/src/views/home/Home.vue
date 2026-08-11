<template>
    <div class="home">
        <p class="eyebrow">PORTFOLIO DEMO</p>
        <h1>Vue 공간정보 UI 실험실</h1>
        <p class="lead">
            Vue 3, OpenLayers, Pinia와 동적 라우팅을 학습하며 만든 화면입니다.
            공개 서버에는 저장소만으로 재현 가능한 프런트엔드 기능만 배포했습니다.
        </p>

        <div class="cards">
            <article>
                <h2>바로 볼 수 있는 기능</h2>
                <p>메뉴·탭 상태 관리, 동적 페이지 로딩, OpenStreetMap 지도와 브라우저 안에서의 도형 그리기를 확인할 수 있습니다.</p>
            </article>
            <article>
                <h2>의도적으로 비활성화한 기능</h2>
                <p>LH 공간 레이어 조회와 도형 DB 저장은 원본 PostGIS 데이터와 GeoServer 구성이 없어 공개 데모에서 꺼 두었습니다.</p>
            </article>
            <article>
                <h2>다시 연결하는 방법</h2>
                <p>별도 환경변수에 API·GeoServer·VWorld 설정을 주입하면 됩니다. 인증정보는 저장소에 넣지 않습니다.</p>
            </article>
        </div>

        <p class="hint">상단의 Map → Show 메뉴에서 독립적으로 동작하는 지도와 그리기 기능을 시험해 보세요.</p>
    </div>
</template>

<style scoped>
.home {
    max-width: 980px;
    margin: 0 auto;
    padding: 24px;
    color: #30251f;
}
.eyebrow {
    margin: 0;
    color: #8b6c57;
    font-size: 0.78rem;
    font-weight: 700;
    letter-spacing: 0.16em;
}
h1 {
    margin: 8px 0 12px;
    font-size: clamp(2rem, 5vw, 3.4rem);
}
.lead {
    max-width: 760px;
    color: #5c4b40;
    font-size: 1.05rem;
    line-height: 1.7;
}
.cards {
    display: grid;
    grid-template-columns: repeat(auto-fit, minmax(220px, 1fr));
    gap: 16px;
    margin-top: 28px;
}
article {
    padding: 20px;
    border: 1px solid #ded2c7;
    border-radius: 14px;
    background: #fbf8f4;
}
h2 {
    margin-top: 0;
    font-size: 1.05rem;
}
article p,
.hint {
    line-height: 1.6;
}
.hint {
    margin-top: 24px;
    padding: 14px 16px;
    border-radius: 10px;
    background: #eee5dc;
}
</style>
