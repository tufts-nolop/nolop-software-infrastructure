_description: Imported from Nolop_Prusa_TPU.ini on 2019-02-17 12:00
_display_name: Nolop_Prusa_TPU
bottom_layer_speed: 10
bottom_thickness: 0.3
brim_line_count: 10
cool_head_lift: false
cool_min_feedrate: 10
cool_min_layer_time: 15
end_gcode:
- '
  M104 S0 ; turn off extruder

  M140 S0 ; turn off heatbed

  M107 ; turn off fan

  G1 X0 Y210; home X axis and push Y forward

  M84 ; disable motors'
- '

  M104 T0 S0                     ;extruder heater off

  M104 T1 S0                     ;extruder heater off

  M104 T2 S0                     ;extruder heater off

  M140 S0                     ;heated bed heater off (if you have it)

  G91                                    ;relative positioning

  G1 E-1 F300                            ;retract the filament a bit before lifting
  the nozzle, to release some of the pressure

  G1 Z+0.5 E-5 X-20 Y-20 F{travel_speed} ;move Z up a bit and retract filament even
  more

  G28 X0 Y0                              ;move X/Y to min endstops, so the head is
  out of the way

  M84                         ;steppers off

  G90                         ;absolute positioning

  ;{profile_string}'
- '

  M104 T0 S0                     ;extruder heater off

  M104 T1 S0                     ;extruder heater off

  M104 T2 S0                     ;extruder heater off

  M104 T3 S0                     ;extruder heater off

  M140 S0                     ;heated bed heater off (if you have it)

  G91                                    ;relative positioning

  G1 E-1 F300                            ;retract the filament a bit before lifting
  the nozzle, to release some of the pressure

  G1 Z+0.5 E-5 X-20 Y-20 F{travel_speed} ;move Z up a bit and retract filament even
  more

  G28 X0 Y0                              ;move X/Y to min endstops, so the head is
  out of the way

  M84                         ;steppers off

  G90                         ;absolute positioning

  ;{profile_string}'
fan_enabled: true
fan_full_height: 0.2
fan_speed: 100
fan_speed_max: 100
filament_diameter:
- 1.75
- false
- false
- false
filament_flow: 100
fill_density: 20
fill_overlap: 15
first_layer_width_factor: 125
fix_horrible_extensive_stitching: false
fix_horrible_union_all_type_a: true
fix_horrible_union_all_type_b: false
fix_horrible_use_open_bits: false
follow_surface: false
infill_speed: 30
inner_shell_speed: 20
layer_height: 0.2
object_sink: 0.0
ooze_shield: false
outer_shell_speed: 15
overlap_dual: 0.15
perimeter_before_infill: false
platform_adhesion: none
print_bed_temperature: 50
print_speed: 20
print_temperature:
- 225
- false
- false
- false
raft_airgap: 0.5
raft_airgap_all: 0.0
raft_base_linewidth: 1.0
raft_base_thickness: 0.3
raft_interface_linewidth: 0.4
raft_interface_thickness: 0.27
raft_line_spacing: 3.0
raft_margin: 5.0
raft_surface_layers: 2
raft_surface_linewidth: 0.4
raft_surface_thickness: 0.27
retraction_amount: 0
retraction_combing: all
retraction_dual_amount: 16.5
retraction_enable: false
retraction_hop: 0.6
retraction_min_travel: 1.5
retraction_minimal_extrusion: 0.005
retraction_speed: 35
skirt_gap: 3.0
skirt_line_count: true
skirt_minimal_length: 150.0
solid_bottom: true
solid_layer_thickness: 0.8
solid_top: true
solidarea_speed: 35
spiralize: false
start_gcode:
- '
  G21 ; set units to millimeters

  G90 ; use absolute positioning

  M82 ; absolute extrusion mode

  M104 S{print_temperature} ; set extruder temp

  M140 S{print_bed_temperature} ; set bed temp

  M190 S{print_bed_temperature} ; wait for bed temp

  M109 S{print_temperature} ; wait for extruder temp

  G28 W ; home all without mesh bed level

  G80 ; mesh bed leveling

  G92 E0.0 ; reset extruder distance position

  G1 Y-3.0 F1000.0 ; go outside print area

  G1 X60.0 E9.0 F1000.0 ; intro line

  G1 X100.0 E21.5 F1000.0 ; intro line

  G92 E0.0 ; reset extruder distance position'
- '

  ;Basic settings: Layer height: {layer_height} Walls: {wall_thickness} Fill: {fill_density}

  ;Print time: {print_time}

  ;Filament used: {filament_amount}m {filament_weight}g

  ;Filament cost: {filament_cost}

  ;M190 S{print_bed_temperature} ;Uncomment to add your own bed temperature line

  ;M104 S{print_temperature} ;Uncomment to add your own temperature line

  ;M109 T1 S{print_temperature2} ;Uncomment to add your own temperature line

  ;M109 T0 S{print_temperature} ;Uncomment to add your own temperature line

  G21        ;metric values

  G90        ;absolute positioning

  M107       ;start with the fan off

  G28 X0 Y0  ;move X/Y to min endstops

  G28 Z0     ;move Z to min endstops

  G1 Z15.0 F{travel_speed} ;move the platform down 15mm

  T1                      ;Switch to the 2nd extruder

  G92 E0                  ;zero the extruded length

  G1 F200 E10             ;extrude 10mm of feed stock

  G92 E0                  ;zero the extruded length again

  G1 F200 E-{retraction_dual_amount}

  T0                      ;Switch to the first extruder

  G92 E0                  ;zero the extruded length

  G1 F200 E10             ;extrude 10mm of feed stock

  G92 E0                  ;zero the extruded length again

  G1 F{travel_speed}

  ;Put printing message on LCD screen

  M117 Printing...'
- '

  ;Basic settings: Layer height: {layer_height} Walls: {wall_thickness} Fill: {fill_density}

  ;Print time: {print_time}

  ;Filament used: {filament_amount}m {filament_weight}g

  ;Filament cost: {filament_cost}

  ;M190 S{print_bed_temperature} ;Uncomment to add your own bed temperature line

  ;M104 S{print_temperature} ;Uncomment to add your own temperature line

  ;M109 T1 S{print_temperature2} ;Uncomment to add your own temperature line

  ;M109 T0 S{print_temperature} ;Uncomment to add your own temperature line

  G21        ;metric values

  G90        ;absolute positioning

  M107       ;start with the fan off

  G28 X0 Y0  ;move X/Y to min endstops

  G28 Z0     ;move Z to min endstops

  G1 Z15.0 F{travel_speed} ;move the platform down 15mm

  T2                      ;Switch to the 2nd extruder

  G92 E0                  ;zero the extruded length

  G1 F200 E10             ;extrude 10mm of feed stock

  G92 E0                  ;zero the extruded length again

  G1 F200 E-{retraction_dual_amount}

  T1                      ;Switch to the 2nd extruder

  G92 E0                  ;zero the extruded length

  G1 F200 E10             ;extrude 10mm of feed stock

  G92 E0                  ;zero the extruded length again

  G1 F200 E-{retraction_dual_amount}

  T0                      ;Switch to the first extruder

  G92 E0                  ;zero the extruded length

  G1 F200 E10             ;extrude 10mm of feed stock

  G92 E0                  ;zero the extruded length again

  G1 F{travel_speed}

  ;Put printing message on LCD screen

  M117 Printing...'
- '

  ;Basic settings: Layer height: {layer_height} Walls: {wall_thickness} Fill: {fill_density}

  ;Print time: {print_time}

  ;Filament used: {filament_amount}m {filament_weight}g

  ;Filament cost: {filament_cost}

  ;M190 S{print_bed_temperature} ;Uncomment to add your own bed temperature line

  ;M104 S{print_temperature} ;Uncomment to add your own temperature line

  ;M109 T2 S{print_temperature2} ;Uncomment to add your own temperature line

  ;M109 T1 S{print_temperature2} ;Uncomment to add your own temperature line

  ;M109 T0 S{print_temperature} ;Uncomment to add your own temperature line

  G21        ;metric values

  G90        ;absolute positioning

  M107       ;start with the fan off

  G28 X0 Y0  ;move X/Y to min endstops

  G28 Z0     ;move Z to min endstops

  G1 Z15.0 F{travel_speed} ;move the platform down 15mm

  T3                      ;Switch to the 4th extruder

  G92 E0                  ;zero the extruded length

  G1 F200 E10             ;extrude 10mm of feed stock

  G92 E0                  ;zero the extruded length again

  G1 F200 E-{retraction_dual_amount}

  T2                      ;Switch to the 3th extruder

  G92 E0                  ;zero the extruded length

  G1 F200 E10             ;extrude 10mm of feed stock

  G92 E0                  ;zero the extruded length again

  G1 F200 E-{retraction_dual_amount}

  T1                      ;Switch to the 2nd extruder

  G92 E0                  ;zero the extruded length

  G1 F200 E10             ;extrude 10mm of feed stock

  G92 E0                  ;zero the extruded length again

  G1 F200 E-{retraction_dual_amount}

  T0                      ;Switch to the first extruder

  G92 E0                  ;zero the extruded length

  G1 F200 E10             ;extrude 10mm of feed stock

  G92 E0                  ;zero the extruded length again

  G1 F{travel_speed}

  ;Put printing message on LCD screen

  M117 Printing...'
support: none
support_angle: 45
support_dual_extrusion: both
support_fill_rate: 30
support_type: lines
support_xy_distance: 1.5
support_z_distance: 0.4
travel_speed: 175
wall_thickness: 0.8
wipe_tower: false
wipe_tower_volume: 15
