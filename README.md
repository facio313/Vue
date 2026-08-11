# Vue 공간정보 UI 데모

이 저장소의 공개 배포 대상은 `frontend/indiv`입니다. Vue 3, Vue Router, Pinia, OpenLayers로 만든 UI를
`https://bonifacio.work/vue/`에서 보여 줍니다.

## 공개 데모 범위

- 동적 메뉴와 탭 상태 관리
- OpenStreetMap 지도
- 브라우저 안에서의 도형 그리기와 수정
- `/vue/` 하위 경로 새로고침 지원

원본 LH PostGIS 자료와 GeoServer 작업공간은 저장소에 없으므로 공간 레이어 조회와 DB 저장은 공개판에서
명시적으로 비활성화됩니다. 백엔드가 동작하는 것처럼 가짜 데이터를 만들지 않습니다.

## 로컬 개발

```bash
cd frontend/indiv
npm ci
npm run dev
```

외부 연동을 복원할 때는 `.env.example`을 참고해 `.env.local`에 값을 넣습니다. 실제 키나 DB 비밀번호는
커밋하지 않습니다. `VITE_API_BASE_URL`은 `/api`까지 포함한 기준 URL이고,
`VITE_VWORLD_TILE_URL_TEMPLATE`은 `{key}`, `{z}`, `{y}`, `{x}` 자리표시자를 사용할 수 있습니다.

## 전체 공간정보 기능 복원 조건

1. LH 공간 스키마와 데이터를 `cksDB`의 전용 DB·전용 역할로 가져옵니다.
2. GeoServer에 해당 PostGIS 저장소와 `lh:*` 레이어·스타일을 등록합니다.
3. 백엔드에는 `SPRING_DATASOURCE_URL`, `SPRING_DATASOURCE_USERNAME`,
   `SPRING_DATASOURCE_PASSWORD`를 런타임 환경변수로 주입합니다.
4. GeoServer와 백엔드는 호스트 포트를 공개하지 않고 Nginx의 `/vue/` 하위 경로로만 연결합니다.

현재 배포는 프런트엔드 전용이라 `cksDB` 접근 권한 자체를 부여하지 않습니다.
