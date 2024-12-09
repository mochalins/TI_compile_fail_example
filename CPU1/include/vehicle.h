#ifndef INCLUDE_VEHICLE_H_
#define INCLUDE_VEHICLE_H_

#ifdef __cplusplus
extern "C" {
#endif

/* Standard Library */
#include <stdbool.h>
#include <stdint.h>

typedef enum {
  /// Disabled servo control.
  VHC_CTRL_NONE = 0,
  /// Speed-based servo control.
  VHC_CTRL_SPD = 1,
  /// Position-based servo control.
  VHC_CTRL_POS = 2,
} VehicleControlKind;

typedef struct {
  uint16_t id : 10;
  VehicleControlKind control : 2;
  bool cas : 1;
} Vehicle;

extern Vehicle vehicles[4];

#ifdef __cplusplus
}
#endif

#endif /* INCLUDE_VEHICLE_H_ */
