package indiv.common;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import indiv.dto.GeometryDTO;
import indiv.dto.RequestDTO;
import indiv.geometry.GeometryService;
import jakarta.inject.Inject;

@RestController
@RequestMapping("/api/draw")
public class DrawContoller {
    
	@Inject
	private GeometryService geometryService;
	
    @PostMapping("/insert")
    public ResponseEntity<?> insertDraw(@RequestBody RequestDTO<GeometryDTO> requestDTO) {
        GeometryDTO geometryDTO = requestDTO.getDto();
        int result = geometryService.insertGeometry(geometryDTO);
        if (result == 1) {
        	return ResponseEntity.ok("Success");
        } else {
        	return ResponseEntity.ok("Failed");
        }
        // 처리 로직 추가
    }
}
