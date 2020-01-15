    module bmiprmssurface

    use m_prms_surface
    use bmif_2_0
    use, intrinsic :: iso_c_binding, only: c_ptr, c_loc, c_f_pointer
    implicit none

    type, extends (bmi) :: bmi_prms_surface
        private
        type (prms_surface_model) :: model
    contains
    procedure :: get_component_name => prms_component_name
    procedure :: get_input_item_count => prms_input_item_count
    procedure :: get_output_item_count => prms_output_item_count
    procedure :: get_input_var_names => prms_input_var_names
    procedure :: get_output_var_names => prms_output_var_names
    procedure :: initialize => prms_initialize
    procedure :: finalize => prms_finalize
    procedure :: get_start_time => prms_start_time
    procedure :: get_end_time => prms_end_time
    procedure :: get_current_time => prms_current_time
    procedure :: get_time_step => prms_time_step
    procedure :: get_time_units => prms_time_units
    procedure :: update => prms_update
    procedure :: update_until => prms_update_until
    procedure :: get_var_grid => prms_var_grid
    procedure :: get_grid_type => prms_grid_type
    procedure :: get_grid_rank => prms_grid_rank
    !procedure :: get_grid_shape => prms_grid_shape
    procedure :: get_grid_size => prms_grid_size
    !procedure :: get_grid_spacing => prms_grid_spacing
    !procedure :: get_grid_origin => prms_grid_origin
    procedure :: get_grid_x => prms_grid_x
    procedure :: get_grid_y => prms_grid_y
    procedure :: get_grid_z => prms_grid_z
    procedure :: get_var_type => prms_var_type
    procedure :: get_var_units => prms_var_units
    procedure :: get_var_itemsize => prms_var_itemsize
    procedure :: get_var_nbytes => prms_var_nbytes
    procedure :: get_var_location => prms_var_location
    procedure :: get_value_int => prms_get_int
    procedure :: get_value_float => prms_get_float
    procedure :: get_value_double => prms_get_double
    generic :: get_value => &
         get_value_int, &
         get_value_float, &
         get_value_double
    procedure :: get_value_ptr_int => prms_get_ptr_int
    procedure :: get_value_ptr_float => prms_get_ptr_float
    procedure :: get_value_ptr_double => prms_get_ptr_double
    generic :: get_value_ptr => &
         get_value_ptr_int, &
         get_value_ptr_float, &
         get_value_ptr_double
    procedure :: get_value_at_indices_int => prms_get_at_indices_int
    procedure :: get_value_at_indices_float => prms_get_at_indices_float
    procedure :: get_value_at_indices_double => prms_get_at_indices_double
    generic :: get_value_at_indices => &
         get_value_at_indices_int, &
         get_value_at_indices_float, &
         get_value_at_indices_double
    procedure :: set_value_int => prms_set_int
    procedure :: set_value_float => prms_set_float
    procedure :: set_value_double => prms_set_double
    generic :: set_value => &
         set_value_int, &
         set_value_float, &
         set_value_double
    !procedure :: set_value_at_indices_int => prms_set_at_indices_int
    !procedure :: set_value_at_indices_float => prms_set_at_indices_float
    !procedure :: set_value_at_indices_double => prms_set_at_indices_double
    !generic :: set_value_at_indices => &
    !     set_value_at_indices_int, &
    !     set_value_at_indices_float, &
    !     set_value_at_indices_double
    !procedure :: print_model_info
    end type bmi_prms_surface

    private
    public :: bmi_prms_surface

    character (len=BMI_MAX_COMPONENT_NAME), target :: &
        component_name = "prms6-BMI"

    ! Exchange items
    integer, parameter :: input_item_count = 6
    integer, parameter :: output_item_count = 88
    character (len=BMI_MAX_VAR_NAME), target, &
        dimension(input_item_count) :: input_items =(/ &
        'hru_ppt        ', &
        'hru_rain       ', &
        'hru_snow       ', &
        'hortonian_lakes', &
        'lakein_sz      ', &
        'Gw2sm_grav     ' /)
    character (len=BMI_MAX_VAR_NAME), target, &
        dimension(output_item_count) :: &
        output_items 

    contains

    ! Get the name of the model.
    function prms_component_name(this, name) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    character (len=*), pointer, intent(out) :: name
    integer :: bmi_status

    name => component_name
    bmi_status = BMI_SUCCESS
    end function prms_component_name

    ! Count the input variables.
    function prms_input_item_count(this, count) result (bmi_status)
        class (bmi_prms_surface), intent(in) :: this
        integer, intent(out) :: count
        integer :: bmi_status

        count = input_item_count
        bmi_status = BMI_SUCCESS
     end function prms_input_item_count

    ! Count the output variables.
    function prms_output_item_count(this, count) result (bmi_status)
        class (bmi_prms_surface), intent(in) :: this
        integer, intent(out) :: count
        integer :: bmi_status

        count = output_item_count
        bmi_status = BMI_SUCCESS
    end function prms_output_item_count

    ! List input variables.
    function prms_input_var_names(this, names) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    character (*), pointer, intent(out) :: names(:)
    integer :: bmi_status

    names => input_items
    bmi_status = BMI_SUCCESS
    end function prms_input_var_names

    ! List output variables.
    function prms_output_var_names(this, names) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    character (*), pointer, intent(out) :: names(:)
    integer :: bmi_status
    ! vars by nhru            
    output_items(1) = 'soil_rechr_chg'
    output_items(2) = 'soil_moist_chg'
    output_items(3) = 'hru_impervevap'
    output_items(4) = 'hru_frac_perv'
    output_items(5) = 'hru_area_perv'
    output_items(6) = 'active_mask'
    output_items(7) = 'soil_moist_max'
    output_items(8) = 'soil_moist'
    output_items(9) = 'soil_rechr_max'
    output_items(10) = 'soil_rechr'
    output_items(11) = 'snowcov_area'
    output_items(12) = 'snow_evap'
    output_items(13) = 'hru_intcpevap'
    output_items(14) = 'transp_on'
    output_items(15) = 'potet'
    output_items(16) = 'sroff'
    output_items(17) = 'infil'
    output_items(18) = 'dprst_seep_hru'
    output_items(19) = 'dprst_evap_hru'
    output_items(20) = 'hru_type'
    output_items(21) = 'hru_area'
    output_items(22) = 'cov_type'
    output_items(23) = 'lakein_sz'
    output_items(24) = 'hortonian_lakes'
    output_items(25) = 'hru_snow'
    output_items(26) = 'hru_rain'
    output_items(27) = 'hru_ppt'
    ! vars by nsegment  
    output_items(28) = 'seg_outflow'
    output_items(29) = 'seg_inflow'
    output_items(30) = 'seg_gwflow'
    output_items(31) = 'strm_seg_in'
    ! vars by nhrucell
    output_items(32) = 'Gw2sm_grav'
    !vars by nhru_active
    output_items(33) = 'hru_route_order'
    ! vars dim by one    
    output_items(34) = 'basin_sroff'
    output_items(35) = 'basin_area_inv'
    output_items(36) = 'active_hrus'
    output_items(37) = 'basin_potet'
    output_items(38) = 'nlake'
    output_items(39) = 'gsflow_mode'
    output_items(40) = 'dprst_flag'
    output_items(41) = 'cascade_flag'
    ! var boolean    
    output_items(42) = 'srunoff_updated_soil'
    ! var time
    output_items(43) = 'nowtime'
    
    ! new items for groundwater module not alread covered with soil module
    ! all dim by nhru
    output_items(44) = 'pkwater_equiv' !r64
    output_items(45) = 'hru_intcpstor' !r32
    output_items(46) = 'dprst_stor_hru' !r64
    output_items(47) = 'hru_impervstor' !r32
    
    ! new items for streamflow module not already covered. dim by hru
    output_items(48) = 'swrad' ! r32
    
    ! new items for water-balance module
    ! basin module
    output_items(49) = 'cascadegw_flag' !int by 1
    output_items(50) = 'nhru' !i32 by 1
    output_items(51) = 'hru_area_dble' ! r64 by nhru
    ! intercep module
    output_items(52) = 'use_transfer_intcp' ! logical by 1
    output_items(53) = 'canopy_covden' ! r32 by nhru
    output_items(54) = 'gain_inches' ! r32 by nhru
    output_items(55) = 'intcp_changeover' !r32 by hru
    output_items(56) = 'intcp_evap' !r32 by hru
    output_items(57) = 'intcp_stor'  !r32 by hru
    output_items(58) = 'intcp_stor_ante' !r32 by hru
    output_items(59) = 'net_apply' !r32 by hru
    output_items(60) = 'net_ppt' !r32 by hru
    output_items(61) = 'net_rain' !r32 by hru
    output_items(62) = 'net_snow' !r32 by hru
    output_items(63) = 'snow_intcp' !r32 by hru
    output_items(64) = 'srain_intcp' !r32 by hru
    output_items(65) = 'wrain_intcp' !r32 by hru
    output_items(66) = 'last_intcp_stor' !r64 by 1
    
    !precip module
    
    !snow module
    output_items(67) = 'newsnow' !i32 by hru
    output_items(68) = 'pkwater_ante' !r64 by hru
    output_items(69) = 'pptmix' !i32 by hru
    output_items(70) = 'pptmix_nopack' !logical by hru
    output_items(71) = 'snowmelt' !r32 by hru
    
    !runoff module
    output_items(72) = 'dprst_area_clos' !r32 by hru
    output_items(73) = 'dprst_area_max' !r32 by hru
    output_items(74) = 'dprst_frac' !r32 by hru
    output_items(75) = 'dprst_in' !r64 by hru
    output_items(76) = 'dprst_insroff_hru' !r32 by hru
    output_items(77) = 'dprst_sroff_hru' !r64 by hru
    output_items(78) = 'dprst_stor_ante' !r64 by hru
    output_items(79) = 'dprst_vol_clos' !r64 by hru
    output_items(80) = 'dprst_vol_open' !r64 by hru
    output_items(81) = 'hru_hortn_cascflow' !r64 by hru
    output_items(82) = 'hru_percent_imperv' !r32 by hru
    output_items(83) = 'hru_sroffi' !r32 by hru
    output_items(84) = 'hru_sroffp' !r32 by hru
    output_items(85) = 'imperv_stor_ante' !r32 by hru
    output_items(86) = 'sro_to_dprst_perv' !r32 by hru
    output_items(87) = 'upslope_hortonian' !r64 by hru
    output_items(88) = 'hortonian_flow' !r32 by hru

    !'dprst_area_clos','dprst_area_max','dprst_frac', &
    !'dprst_insroff_hru', &
    !'hru_percent_imperv', &
    !'hru_sroffi', 'hru_sroffp', 'imperv_stor_ante', 'sro_to_dprst_perv', &
    !'upslope_hortonian', 
    !
    !'dprst_in','dprst_sroff_hru','dprst_stor_ante','dprst_vol_clos','dprst_vol_open', 'hru_hortn_cascflow', 'hortonian_flow'
    names => output_items
    bmi_status = BMI_SUCCESS
    end function prms_output_var_names

    ! BMI initializer.
    function prms_initialize(this, config_file) result (bmi_status)
    class (bmi_prms_surface), intent(out) :: this
    character (len=*), intent(in) :: config_file
    integer :: bmi_status

    if (len(config_file) > 0) then
        call initialize_from_file(this%model, config_file)
    else
        !call initialize_from_defaults(this%model)
    end if
    bmi_status = BMI_SUCCESS
    end function prms_initialize

    ! BMI finalizer.
    function prms_finalize(this) result (bmi_status)
    class (bmi_prms_surface), intent(inout) :: this
    integer :: bmi_status

    call cleanup(this%model)
    bmi_status = BMI_SUCCESS
    end function prms_finalize

    ! Model start time.
    function prms_start_time(this, time) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    double precision, intent(out) :: time
    integer :: bmi_status

    time = 0.d0
    !time = this%model%model_simulation%model_time%Timestep
    bmi_status = BMI_SUCCESS
    end function prms_start_time

    ! Model end time.
    function prms_end_time(this, time) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    double precision, intent(out) :: time
    integer :: bmi_status

    time = dble(this%model%model_simulation%model_time%Number_timesteps)
    bmi_status = BMI_SUCCESS
    end function prms_end_time

    ! Model current time.
    function prms_current_time(this, time) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    double precision, intent(out) :: time
    integer :: bmi_status

    time = dble(this%model%model_simulation%model_time%Timestep)
    bmi_status = BMI_SUCCESS
    end function prms_current_time

    ! Model time step.
    function prms_time_step(this, time_step) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    double precision, intent(out) :: time_step
    integer :: bmi_status

    time_step = dble(this%model%model_simulation%model_time%Timestep_seconds)
    bmi_status = BMI_SUCCESS
    end function prms_time_step

    ! Model time units.
    function prms_time_units(this, units) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    character (len=*), intent(out) :: units
    integer :: bmi_status

    units = "s"
    bmi_status = BMI_SUCCESS
    end function prms_time_units

    ! Advance model by one time step.
    function prms_update(this) result (bmi_status)
    class (bmi_prms_surface), intent(inout) :: this
    integer :: bmi_status

    call advance_in_time(this%model)
    bmi_status = BMI_SUCCESS
    end function prms_update

    ! Advance the model until the given time.
    function prms_update_until(this, time) result (bmi_status)
    class (bmi_prms_surface), intent(inout) :: this
    double precision, intent(in) :: time
    double precision :: current_time, end_time, dt
    integer :: bmi_status
    double precision :: n_steps_real
    integer :: n_steps, i, s
    s = this%get_current_time(current_time)
    s = this%get_end_time(end_time)
    s = this%get_time_step(dt)
    if (time > current_time) then
        n_steps_real = (time - current_time)
        n_steps = floor(n_steps_real)
        do i = 1, n_steps
            s = this%update()
        end do
        !s = this%update_frac(n_steps_real - dble(n_steps))
    end if
    bmi_status = BMI_SUCCESS
    end function prms_update_until

    ! Get the grid id for a particular variable.
    function prms_var_grid(this, name, grid) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    character (len=*), intent(in) :: name
    integer, intent(out) :: grid
    integer :: bmi_status

    select case(name)
    case('hru_ppt', 'hru_rain', 'hru_snow', 'hru_x', &
        'hru_y', 'hru_elev', 'hru_actet', 'hortonian_lakes', &
        'lakein_sz', 'cov_type', 'hru_area', 'hru_type', &
        'dprst_evap_hru', 'dprst_seep_hru', 'infil', &
        'sroff', 'potet', 'transp_on', 'hru_intcpevap', &
        'snow_evap', 'snowcov_area', 'soil_rechr', &
        'soil_rechr_max', 'soil_moist', 'soil_moist_max', &
        'active_mask', 'hru_area_perv', 'hru_frac_perv', &
        'hru_impervevap', 'soil_moist_chg', 'soil_rechr_chg', &
        'pkwater_equiv', 'hru_intcpstor', 'dprst_stor_hru', &
        'hru_impervstor', 'swrad', 'hru_area_dble', &
        'canopy_covden', 'gain_inches', 'intcp_changeover', 'intcp_evap', &
        'intcp_stor', 'intcp_stor_ante', 'net_apply', 'net_ppt', 'net_rain', &
        'net_snow', 'snow_intcp', 'srain_intcp', 'wrain_intcp', &
        'newsnow', 'pkwater_ante', 'pptmix', 'pptmix_nopack', 'snowmelt', &
        'dprst_area_clos','dprst_area_max','dprst_frac','dprst_in', &
        'dprst_insroff_hru','dprst_sroff_hru','dprst_stor_ante','dprst_vol_clos', &
        'dprst_vol_open', 'hru_hortn_cascflow', 'hru_percent_imperv', &
        'hru_sroffi', 'hru_sroffp', 'imperv_stor_ante', 'sro_to_dprst_perv', &
        'upslope_hortonian', 'hortonian_flow')
        grid = 0
        bmi_status = BMI_SUCCESS
    case('seg_gwflow', 'seg_inflow', 'seg_outflow', 'strm_seg_in')
        grid = 1
        bmi_status = BMI_SUCCESS
    case('cascade_flag', 'dprst_flag', 'gsflow_mode', &
        'print_debug', 'nlake', 'basin_potet', 'active_hrus', &
        'srunoff_updated_soil', 'basin_area_inv','basin_sroff', &
        'cascadegw_flag', 'nhru', 'use_transfer_intcp', 'last_intcp_stor', &
        'use_sroff_transfer')
        grid = 2
        bmi_status = BMI_SUCCESS
    case('hru_route_order')
        grid = 3 ! nhru_active
        bmi_status = BMI_SUCCESS
    case('Gw2sm_grav')
        grid = 4 ! by nhrucell
        bmi_status = BMI_SUCCESS
    case default
        grid = -1
        bmi_status = BMI_FAILURE
    end select
    end function prms_var_grid

    ! The type of a variable's grid.
    function prms_grid_type(this, grid, type) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    integer, intent(in) :: grid
    character (len=*), intent(out) :: type
    integer :: bmi_status

    select case(grid)
    case(0)
        type = "vector"
        bmi_status = BMI_SUCCESS
    case(1)
        type = "vector"
        bmi_status = BMI_SUCCESS
    case(2)
        type = 'scalar'
        bmi_status = BMI_FAILURE
    case(3)
        type = "vector"
        bmi_status = BMI_SUCCESS
    case(4)
        type = "vector"
        bmi_status = BMI_SUCCESS
    case default
        type = "-"
        bmi_status = BMI_FAILURE
    end select
    end function prms_grid_type

    ! The number of dimensions of a grid.
    function prms_grid_rank(this, grid, rank) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    integer, intent(in) :: grid
    integer, intent(out) :: rank
    integer :: bmi_status

    select case(grid)
    case(0)
        rank = 1
        bmi_status = BMI_SUCCESS
    case(1)
        rank = 1
        bmi_status = BMI_SUCCESS
    case(2)
        rank = 0
        bmi_status = BMI_SUCCESS
    case(3)
        rank = 1
        bmi_status = BMI_SUCCESS
    case(4)
        rank = 1
        bmi_status = BMI_SUCCESS
    case default
        rank = -1
        bmi_status = BMI_FAILURE
    end select
    end function prms_grid_rank

    !! The dimensions of a grid.
    !function prms_grid_shape(this, type, grid_shape) result (bmi_status)
    !  class (bmi_prms_surface), intent(in) :: this
    !  integer, intent(in) :: type
    !  integer, dimension(:), intent(out) :: grid_shape
    !  integer :: bmi_status
    !
    !  select case(type)
    !  case(0)
    !     grid_shape = this%model%control_data%nhru%value
    !     bmi_status = BMI_SUCCESS
    !  case default
    !     grid_shape = [-1]
    !     bmi_status = BMI_FAILURE
    !  end select
    !end function prms_grid_shape
    !
    ! The total number of elements in a grid.
    function prms_grid_size(this, grid, size) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    integer, intent(in) :: grid
    integer, intent(out) :: size
    integer :: bmi_status

    select case(grid)
    case(0)
        size = this%model%model_simulation%model_basin%nhru
        bmi_status = BMI_SUCCESS
    case(1)
        size = this%model%model_simulation%model_basin%nsegment
        bmi_status = BMI_SUCCESS
    case(2)
        size = 1
        bmi_status = BMI_SUCCESS
    case(3)
        size = count(this%model%model_simulation%model_basin%active_mask)
        bmi_status = BMI_SUCCESS
    case(4)
        size = this%model%model_simulation%soil%nhrucell
        bmi_status = BMI_SUCCESS
    case default
        size = -1
        bmi_status = BMI_FAILURE
    end select
    end function prms_grid_size

    !! The distance between nodes of a grid.
    !function prms_grid_spacing(this, type, grid_spacing) result (bmi_status)
    !  class (bmi_prms_surface), intent(in) :: this
    !  integer, intent(in) :: type
    !  real, dimension(:), intent(out) :: grid_spacing
    !  integer :: bmi_status
    !
    !  select case(type)
    !  case(0)
    !     grid_spacing = [this%model%dy, this%model%dx]
    !     bmi_status = BMI_SUCCESS
    !  case default
    !     grid_spacing = -1
    !     bmi_status = BMI_FAILURE
    !  end select
    !end function prms_grid_spacing
    !
    !! Coordinates of grid origin.
    !function prms_grid_origin(this, type, grid_origin) result (bmi_status)
    !  class (bmi_prms_surface), intent(in) :: this
    !  integer, intent(in) :: type
    !  real, dimension(:), intent(out) :: grid_origin
    !  integer :: bmi_status
    !
    !  select case(type)
    !  case(0)
    !     grid_origin = [0.0, 0.0]
    !     bmi_status = BMI_SUCCESS
    !  case default
    !     grid_origin = [-1.0]
    !     bmi_status = BMI_FAILURE
    !  end select
    !end function prms_grid_origin
    !
    ! X-coordinates of grid nodes.
    function prms_grid_x(this, grid, x) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    integer, intent(in) :: grid
    double precision, dimension(:), intent(out) :: x
    integer :: bmi_status

    select case(grid)
    case(0)
        x = this%model%model_simulation%model_basin%hru_x
        bmi_status = BMI_SUCCESS
    case default
        x = [-1.0]
        bmi_status = BMI_FAILURE
    end select
    end function prms_grid_x

    ! Y-coordinates of grid nodes.
    function prms_grid_y(this, grid, y) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    integer, intent(in) :: grid
    double precision, dimension(:), intent(out) :: y
    integer :: bmi_status

    select case(grid)
    case(0)
        y = this%model%model_simulation%model_basin%hru_y
        bmi_status = BMI_SUCCESS
    case default
        y = [-1.0]
        bmi_status = BMI_FAILURE
    end select
    end function prms_grid_y

    ! Z-coordinates of grid nodes.
    function prms_grid_z(this, grid, z) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    integer, intent(in) :: grid
    double precision, dimension(:), intent(out) :: z
    integer :: bmi_status

    select case(grid)
    case(0)
        z = this%model%model_simulation%model_basin%hru_elev
        bmi_status = BMI_SUCCESS
    case default
        z = [-1.0]
        bmi_status = BMI_FAILURE
    end select
    end function prms_grid_z
    !
    ! The data type of the variable, as a string.
    function prms_var_type(this, name, type) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    character (len=*), intent(in) :: name
    character (len=*), intent(out) :: type
    integer :: bmi_status

    select case(name)
    case("hru_ppt", "hru_snow", "hru_rain",  &
        "hru_actet", 'hru_area', 'dprst_evap_hru', 'infil', &
        'sroff', 'potet', 'hru_intcpevap', 'snow_evap', 'snowcov_area', &
        'soil_rechr', 'soil_rechr_max', 'soil_moist', 'soil_moist_max', &
        'hru_area_perv', 'hru_frac_perv', 'hru_impervevap', 'soil_moist_chg', &
        'soil_rech_chg', 'gw2sm_grav', 'hru_intcpstor', 'hru_impervstor', 'swrad', &
        'gain_inches', 'intcp_changeover', 'intcp_evap', &
        'intcp_stor', 'intcp_stor_ante', 'net_apply', 'net_ppt', 'net_rain', &
        'net_snow', 'snow_intcp', 'srain_intcp', 'wrain_intcp', 'snowmelt', &
        'dprst_area_clos','dprst_area_max','dprst_frac', 'dprst_insroff_hru', &
        'hru_percent_imperv', 'hru_sroffi', 'hru_sroffp', 'imperv_stor_ante', &
        'sro_to_dprst_perv', 'upslope_hortonian')
        type = "real"
        bmi_status = BMI_SUCCESS
        case("seg_gwflow", "seg_inflow", "seg_outflow", 'basin_potet', &
        'basin_area_inv', 'basin_sroff', "hortonian_lakes", 'lakein_sz', &
        'dprst_seep_hru', 'strm_seg_in', 'pkwater_equiv', 'dprst_stor_hru', &
        'last_intcp_stor', 'hru_area_dble', 'pkwater_ante', 'dprst_in', &
        'dprst_sroff_hru','dprst_stor_ante','dprst_vol_clos','dprst_vol_open', &
        'hru_hortn_cascflow', 'hortonian_flow')
        type = "double"
        bmi_status = BMI_SUCCESS
        case("nlake", 'active_hrus', 'nowtime', 'cov_type', 'hru_type', &
        'hru_route_order', 'cascade_flag', 'dprst_flag', 'print_debug', &
        'gsflow_mode', 'cascadegw_flag', 'nhru', 'newsnow', 'pptmix')
        type = "integer"
        bmi_status = BMI_SUCCESS
    case('srunoff_updated_soil', 'use_transfer_intcp', 'use_sroff_transfer', &
        'pptmix_nopack')
        type = 'logical'
        bmi_status = BMI_SUCCESS
    case default
        type = "-"
        bmi_status = BMI_FAILURE
    end select
    end function prms_var_type

    ! The units of the given variable.
    function prms_var_units(this, name, units) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    character (len=*), intent(in) :: name
    character (len=*), intent(out) :: units
    integer :: bmi_status

    select case(name)
    case("hru_ppt", "hru_snow", "hru_rain", "hortonian_lakes", &
        "hru_actet","seg_gwflow", 'dprst_evap_hru', 'infil', &
        'sroff', 'potet', 'hru_intcpevap', 'snow_evap', &
        'soil_rechr', 'soil_rechr_max', 'soil_moist', 'soil_moist_max', &
        'soil_moist_ch', 'soil_rechr_chg', 'gwwsm_grav', 'basin_potet', &
        'basin_sroff', 'lakein_sz', 'dprst_seep_hru', &
        'pkwater_equiv', 'hru_intcpstor', 'dprst_stor_hru', 'hru_impervstor', &
        'swrad', 'last_intcp_stor','gain_inches', 'intcp_changeover', 'intcp_evap', &
        'intcp_stor', 'intcp_stor_ante', 'net_apply', 'net_ppt', 'net_rain', &
        'net_snow', 'snow_intcp', 'srain_intcp', 'wrain_intcp', 'pkwater_ante', &
        'snowmelt', 'dprst_insroff_hru', 'dprst_sroff_hru', 'dprst_stor_ante', &
        'hortonian_flow', 'hru_hortn_cascflow', 'hru_sroffi', 'hru_sroffp', &
        'imporv_stor_ante', 'upslope_ante')
        units = "in"
        bmi_status = BMI_SUCCESS
    case("seg_inflow", "seg_outflow", 'strm_seg_in', 'hru_area')
        units = "ft3 s-1"
        bmi_status = BMI_SUCCESS
    case('dprst_area_clos', 'dprst_area_max')
        units = 'acres'
        bmi_status = BMI_SUCCESS
    case('dprst_in', 'dprst_vol_clos', 'dprst_vol_open')
        units = 'acre-inches'
        bmi_status = BMI_SUCCESS
    case default
        units = "-"
        bmi_status = BMI_FAILURE
    end select
    end function prms_var_units

    ! Memory use per array element.
    function prms_var_itemsize(this, name, size) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    character (len=*), intent(in) :: name
    integer, intent(out) :: size
    integer :: bmi_status

    select case(name)
    case("nlake")
        size = sizeof(this%model%model_simulation%model_basin%nlake)
        bmi_status = BMI_SUCCESS
    case('active_hrus')
        size = sizeof(this%model%model_simulation%model_basin%active_hrus)
        bmi_status = BMI_SUCCESS
    case('nowtime')
        size = sizeof(this%model%model_simulation%model_time%nowtime)
        bmi_status = BMI_SUCCESS
    case('cov_type')
        size = sizeof(this%model%model_simulation%model_basin%cov_type)
        bmi_status = BMI_SUCCESS
    case('hru_type')
        size = sizeof(this%model%model_simulation%model_basin%hru_type)
        bmi_status = BMI_SUCCESS
    case('hru_route_order')
        size = sizeof(this%model%model_simulation%model_basin%hru_route_order)
        bmi_status = BMI_SUCCESS
    case('cascade_flag')
        size = sizeof(this%model%control_data%cascade_flag%value)
        bmi_status = BMI_SUCCESS
    case('cascadegw_flag')
        size = sizeof(this%model%control_data%cascadegw_flag%value)
        bmi_status = BMI_SUCCESS
	case('hru_area_dble')
        size = sizeof(this%model%model_simulation%model_basin%hru_area_dble)
		bmi_status = BMI_SUCCESS
    case('nhru')
        size = sizeof(this%model%model_simulation%model_basin%nhru)
        bmi_status = BMI_SUCCESS
    case('use_transfer_intcp')
        size = sizeof(this%model%model_simulation%intcp%use_transfer_intcp)
        bmi_status = BMI_SUCCESS
    case('use_sroff_transfer')
        size = sizeof(this%model%model_simulation%runoff%use_sroff_transfer)
        bmi_status = BMI_SUCCESS
    case('dprst_flag')
        size = sizeof(this%model%control_data%dprst_flag%value)
        bmi_status = BMI_SUCCESS
    case('print_debug')
        size = sizeof(this%model%control_data%print_debug%value)
        bmi_status = BMI_SUCCESS
    case('gsflow_mode')
        size = sizeof(this%model%control_data%gsflow_mode)
        bmi_status = BMI_SUCCESS
    case('srunoff_updated_soil')
        size = sizeof(this%model%model_simulation%runoff%srunoff_updated_soil)
        bmi_status = BMI_SUCCESS
    case('last_intcp_stor')
        size = sizeof(this%model%model_simulation%intcp%last_intcp_stor)
        bmi_status = BMI_SUCCESS
    case('transp_on')
        size = sizeof(this%model%model_simulation%transpiration%transp_on)
        bmi_status = BMI_SUCCESS
    case('active_mask')
        size = sizeof(this%model%model_simulation%model_basin%active_mask)
        bmi_status = BMI_SUCCESS
    case('hru_ppt')
        size = sizeof(this%model%model_simulation%model_precip%hru_ppt)
        bmi_status = BMI_SUCCESS
    case('hru_rain')
        size = sizeof(this%model%model_simulation%model_precip%hru_rain)
        bmi_status = BMI_SUCCESS
    case('hru_snow')
        size = sizeof(this%model%model_simulation%model_precip%hru_snow)
        bmi_status = BMI_SUCCESS
    case('hru_area')
        size = sizeof(this%model%model_simulation%model_basin%hru_area)
        bmi_status = BMI_SUCCESS
    case('dprst_evap_hru')
        size = sizeof(this%model%model_simulation%runoff%dprst_evap_hru)
        bmi_status = BMI_SUCCESS
    case('infil')
        size = sizeof(this%model%model_simulation%runoff%infil)
        bmi_status = BMI_SUCCESS
    case('sroff')
        size = sizeof(this%model%model_simulation%runoff%sroff)
        bmi_status = BMI_SUCCESS
    case('potet')
        size = sizeof(this%model%model_simulation%potet%potet)
        bmi_status = BMI_SUCCESS
    case('hru_intcpevap')
        size = sizeof(this%model%model_simulation%intcp%hru_intcpevap)
        bmi_status = BMI_SUCCESS
        
    case('gain_inches')
        size = sizeof(this%model%model_simulation%intcp%gain_inches)
        bmi_status = BMI_SUCCESS
    case('intcp_changeover')
        size = sizeof(this%model%model_simulation%intcp%intcp_changeover)
        bmi_status = BMI_SUCCESS
    case('intcp_evap')
        size = sizeof(this%model%model_simulation%intcp%intcp_evap)
        bmi_status = BMI_SUCCESS
    case('intcp_stor')
        size = sizeof(this%model%model_simulation%intcp%intcp_stor)
        bmi_status = BMI_SUCCESS
    case('intcp_stor_ante')
        size = sizeof(this%model%model_simulation%intcp%intcp_stor_ante)
        bmi_status = BMI_SUCCESS
    case('net_apply')
        size = sizeof(this%model%model_simulation%intcp%net_apply)
        bmi_status = BMI_SUCCESS
    case('net_ppt')
        size = sizeof(this%model%model_simulation%intcp%net_ppt)
        bmi_status = BMI_SUCCESS
    case('net_rain')
        size = sizeof(this%model%model_simulation%intcp%net_rain)
        bmi_status = BMI_SUCCESS
    case('net_snow')
        size = sizeof(this%model%model_simulation%intcp%net_snow)
        bmi_status = BMI_SUCCESS
    case('snow_intcp')
        size = sizeof(this%model%model_simulation%intcp%snow_intcp)
        bmi_status = BMI_SUCCESS
    case('srain_intcp')
        size = sizeof(this%model%model_simulation%intcp%srain_intcp)
        bmi_status = BMI_SUCCESS
    case('wrain_intcp')
        size = sizeof(this%model%model_simulation%intcp%wrain_intcp)
        bmi_status = BMI_SUCCESS

    case('snow_evap')
        size = sizeof(this%model%model_simulation%snow%snow_evap)
        bmi_status = BMI_SUCCESS
    case('snowcov_area')
        size = sizeof(this%model%model_simulation%snow%snowcov_area)
        bmi_status = BMI_SUCCESS
    case('soil_rechr')
        size = sizeof(this%model%model_simulation%climate%soil_rechr)
        bmi_status = BMI_SUCCESS
    case('soil_rechr_max')
        size = sizeof(this%model%model_simulation%climate%soil_rechr_max)
        bmi_status = BMI_SUCCESS
    case('soil_moist')
        size = sizeof(this%model%model_simulation%climate%soil_moist)
        bmi_status = BMI_SUCCESS
    case('soil_moist_max')
        size = sizeof(this%model%model_simulation%climate%soil_moist_max)
        bmi_status = BMI_SUCCESS
    case('hru_area_perv')
        size = sizeof(this%model%model_simulation%runoff%hru_area_perv)
        bmi_status = BMI_SUCCESS
    case('hru_impervevap')
        size = sizeof(this%model%model_simulation%runoff%hru_impervevap)
        bmi_status = BMI_SUCCESS
    case('soil_moist_chg')
        size = sizeof(this%model%model_simulation%runoff%soil_moist_chg)
        bmi_status = BMI_SUCCESS
    case('soil_rechr_chg')
        size = sizeof(this%model%model_simulation%runoff%soil_rechr_chg)
        bmi_status = BMI_SUCCESS
    case('basin_potet')
        size = sizeof(this%model%model_simulation%potet%basin_potet)
        bmi_status = BMI_SUCCESS
    case('basin_area_inv')
        size = sizeof(this%model%model_simulation%model_basin%basin_area_inv)
        bmi_status = BMI_SUCCESS
    case('basin_sroff')
        size = sizeof(this%model%model_simulation%runoff%basin_sroff)
        bmi_status = BMI_SUCCESS
    case('hortonian_lakes')
        size = sizeof(this%model%model_simulation%runoff%hortonian_lakes)
        bmi_status = BMI_SUCCESS
    case('dprst_seep_hru')
        size = sizeof(this%model%model_simulation%runoff%dprst_seep_hru)
        bmi_status = BMI_SUCCESS
    case('strm_seg_in')
        size = sizeof(this%model%model_simulation%runoff%strm_seg_in)
        bmi_status = BMI_SUCCESS
    case('pkwater_equiv') 
        size = sizeof(this%model%model_simulation%climate%pkwater_equiv)
        bmi_status = BMI_SUCCESS
    case('hru_intcpstor') 
        size = sizeof(this%model%model_simulation%intcp%hru_intcpstor)
        bmi_status = BMI_SUCCESS
    case('dprst_stor_hru') 
        size = sizeof(this%model%model_simulation%runoff%dprst_stor_hru)
        bmi_status = BMI_SUCCESS
    case('hru_impervstor') 
        size = sizeof(this%model%model_simulation%runoff%hru_impervstor)
        bmi_status = BMI_SUCCESS
    case('swrad')
        size = sizeof(this%model%model_simulation%solrad%swrad)
        bmi_status = BMI_SUCCESS
        
    case('newsnow')
        size = sizeof(this%model%model_simulation%snow%newsnow)
        bmi_status = BMI_SUCCESS
    case('pptmix')
        size = sizeof(this%model%model_simulation%snow%pptmix)
        bmi_status = BMI_SUCCESS
    case('snowmelt')
        size = sizeof(this%model%model_simulation%snow%snowmelt)
        bmi_status = BMI_SUCCESS
    case('pkwater_ante')
        size = sizeof(this%model%model_simulation%snow%pkwater_ante)
        bmi_status = BMI_SUCCESS
    case('pptmix_nopack')
        size = sizeof(this%model%model_simulation%snow%pptmix_nopack)
        bmi_status = BMI_SUCCESS
        
    case('dprst_area_clos')
        size = sizeof(this%model%model_simulation%runoff%dprst_area_clos)
        bmi_status = BMI_SUCCESS
    case('dprst_area_max')
        size = sizeof(this%model%model_simulation%runoff%dprst_area_max)
        bmi_status = BMI_SUCCESS
    case('dprst_frac')
        size = sizeof(this%model%model_simulation%runoff%dprst_frac)
        bmi_status = BMI_SUCCESS
    case('dprst_insroff_hru')
         size = sizeof(this%model%model_simulation%runoff%dprst_insroff_hru)
        bmi_status = BMI_SUCCESS
   case('hru_percent_imperv')
        size = sizeof(this%model%model_simulation%runoff%hru_percent_imperv)
        bmi_status = BMI_SUCCESS
    case('hru_sroffi')
        size = sizeof(this%model%model_simulation%runoff%hru_sroffi)
        bmi_status = BMI_SUCCESS
    case('hru_sroffp')
        size = sizeof(this%model%model_simulation%runoff%hru_sroffp)
        bmi_status = BMI_SUCCESS
    case('imperv_stor_ante')
        size = sizeof(this%model%model_simulation%runoff%imperv_stor_ante)
        bmi_status = BMI_SUCCESS
    case('sro_to_dprst_perv')
        size = sizeof(this%model%model_simulation%runoff%sro_to_dprst_perv)
        bmi_status = BMI_SUCCESS
    case('hortonian_flow')
        size = sizeof(this%model%model_simulation%runoff%hortonian_flow)
        bmi_status = BMI_SUCCESS

    case('upslope_hortonian')
        size = sizeof(this%model%model_simulation%runoff%upslope_hortonian)
        bmi_status = BMI_SUCCESS
    case('dprst_in')
        size = sizeof(this%model%model_simulation%runoff%dprst_in)
        bmi_status = BMI_SUCCESS
    case('dprst_sroff_hru')
        size = sizeof(this%model%model_simulation%runoff%dprst_sroff_hru)
        bmi_status = BMI_SUCCESS
    case('dprst_stor_ante')
        size = sizeof(this%model%model_simulation%runoff%dprst_stor_ante)
        bmi_status = BMI_SUCCESS
    case('dprst_vol_clos')
        size = sizeof(this%model%model_simulation%runoff%dprst_vol_clos)
        bmi_status = BMI_SUCCESS
    case('dprst_vol_open')
        size = sizeof(this%model%model_simulation%runoff%dprst_vol_open)
        bmi_status = BMI_SUCCESS
    case('hru_hortn_cascflow')
        size = sizeof(this%model%model_simulation%runoff%hru_hortn_cascflow)
        bmi_status = BMI_SUCCESS
    case default
        size = -1
        bmi_status = BMI_FAILURE
    end select
    end function prms_var_itemsize
    
    ! The size of the given variable.
    function prms_var_nbytes(this, name, nbytes) result (bmi_status)
      class (bmi_prms_surface), intent(in) :: this
      character (len=*), intent(in) :: name
      integer, intent(out) :: nbytes
      integer :: bmi_status
      integer :: s1, s2, s3, type, grid_size, item_size
    
      s1 = this%get_var_grid(name, type)
      s2 = this%get_grid_size(type, grid_size)
      s3 = this%get_var_itemsize(name, item_size)
    
      if ((s1 == BMI_SUCCESS).and.(s2 == BMI_SUCCESS).and.(s3 == BMI_SUCCESS)) then
         nbytes = item_size * grid_size
         bmi_status = BMI_SUCCESS
      else
         nbytes = -1
         bmi_status = BMI_FAILURE
      end if
    end function prms_var_nbytes
    
  ! The location (node, face, edge) of the given variable.
    function prms_var_location(this, name, location) result (bmi_status)
        class (bmi_prms_surface), intent(in) :: this
        character (len=*), intent(in) :: name
        character (len=*), intent(out) :: location
        integer :: bmi_status

        select case(name)
        case default
           location = "face"
           bmi_status = BMI_SUCCESS
        end select
    end function prms_var_location
    
    ! Get a copy of a integer variable's values, flattened.
    function prms_get_int(this, name, dest) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    character (len=*), intent(in) :: name
    integer, intent(inout) :: dest(:)
    integer :: bmi_status

    select case(name)
    case("nlake")
        dest = [this%model%model_simulation%model_basin%nlake]
        bmi_status = BMI_SUCCESS
    case('active_hrus')
        dest = [this%model%model_simulation%model_basin%active_hrus]
        bmi_status = BMI_SUCCESS
    case('nowtime')
        dest = [this%model%model_simulation%model_time%nowtime]
        bmi_status = BMI_SUCCESS
    case('cov_type')
        dest = [this%model%model_simulation%model_basin%cov_type]
        bmi_status = BMI_SUCCESS
    case('hru_type')
        dest = [this%model%model_simulation%model_basin%hru_type]
        bmi_status = BMI_SUCCESS
    case('hru_route_order')
        dest = [this%model%model_simulation%model_basin%hru_route_order]
        bmi_status = BMI_SUCCESS
    case('cascade_flag')
        dest = [this%model%control_data%cascade_flag%value]
        bmi_status = BMI_SUCCESS
    case('cascadegw_flag')
        dest = [this%model%control_data%cascade_flag%value]
        bmi_status = BMI_SUCCESS
    case('hru_area_dble')
        dest = [this%model%model_simulation%model_basin%hru_area_dble]
        bmi_status = BMI_SUCCESS
    case('nhru')
        dest = [this%model%model_simulation%model_basin%nhru]
        bmi_status = BMI_SUCCESS
    case('dprst_flag')
        dest = [this%model%control_data%dprst_flag%value]
        bmi_status = BMI_SUCCESS
    case('print_debug')
        dest = [this%model%control_data%print_debug%value]
        bmi_status = BMI_SUCCESS
    case('gsflow_mode')
        dest = [this%model%control_data%gsflow_mode]
        bmi_status = BMI_SUCCESS
    case('srunoff_updated_soil')
        dest = [this%model%model_simulation%runoff%srunoff_updated_soil]
        bmi_status = BMI_SUCCESS
    case('last_intcp_stor')
        dest = [this%model%model_simulation%intcp%last_intcp_stor]
        bmi_status = BMI_SUCCESS
    case('transp_on')
        dest = [this%model%model_simulation%transpiration%transp_on]
        bmi_status = BMI_SUCCESS
    case('active_mask')
        dest = [this%model%model_simulation%model_basin%active_mask]
        bmi_status = BMI_SUCCESS
        
    case('newsnow')
        dest = [this%model%model_simulation%snow%newsnow]
        bmi_status = BMI_SUCCESS
    case('pptmix')
        dest = [this%model%model_simulation%snow%pptmix]
        bmi_status = BMI_SUCCESS
    case('pptmix_nopack')
        dest = [this%model%model_simulation%snow%pptmix_nopack]
        bmi_status = BMI_SUCCESS


        case default
        dest = [-1]
        bmi_status = BMI_FAILURE
    end select
    end function prms_get_int
    
    ! Get a copy of a real variable's values, flattened.
    function prms_get_float(this, name, dest) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    character (len=*), intent(in) :: name
    real, intent(inout) :: dest(:)
    integer :: bmi_status

    select case(name)
        !case("plate_surface__temperature")
        !   ! This would be safe, but subject to indexing errors.
        !   ! do j = 1, this%model%n_y
        !   !    do i = 1, this%model%n_x
        !   !       k = j + this%model%n_y*(i-1)
        !   !       dest(k) = this%model%temperature(j,i)
        !   !    end do
        !   ! end do
        !
        !   ! This is an equivalent, elementwise copy into `dest`.
        !   ! See https://stackoverflow.com/a/11800068/1563298
        !   dest = reshape(this%model%temperature, [this%model%n_x*this%model%n_y])
        !   bmi_status = BMI_SUCCESS
        !case("plate_surface__thermal_diffusivity")
        !   dest = [this%model%alpha]
        !   bmi_status = BMI_SUCCESS
    case('hru_ppt')
        dest = [this%model%model_simulation%model_precip%hru_ppt]
        bmi_status = BMI_SUCCESS
    case('hru_rain')
        dest = [this%model%model_simulation%model_precip%hru_rain]
        bmi_status = BMI_SUCCESS
    case('hru_snow')
        dest = [this%model%model_simulation%model_precip%hru_snow]
        bmi_status = BMI_SUCCESS
    case('hru_area')
        dest = [this%model%model_simulation%model_basin%hru_area]
        bmi_status = BMI_SUCCESS
    case('dprst_evap_hru')
        dest = [this%model%model_simulation%runoff%dprst_evap_hru]
        bmi_status = BMI_SUCCESS
    case('infil')
        dest = [this%model%model_simulation%runoff%infil]
        bmi_status = BMI_SUCCESS
    case('sroff')
        dest = [this%model%model_simulation%runoff%sroff]
        bmi_status = BMI_SUCCESS
    case('potet')
        dest = [this%model%model_simulation%potet%potet]
        bmi_status = BMI_SUCCESS
    case('hru_intcpevap')
        dest = [this%model%model_simulation%intcp%hru_intcpevap]
        bmi_status = BMI_SUCCESS
    case('snow_evap')
        dest = [this%model%model_simulation%snow%snow_evap]
        bmi_status = BMI_SUCCESS
    case('snowcov_area')
        dest = [this%model%model_simulation%snow%snowcov_area]
        bmi_status = BMI_SUCCESS
    case('soil_rechr')
        dest = [this%model%model_simulation%climate%soil_rechr]
        bmi_status = BMI_SUCCESS
    case('soil_rechr_max')
        dest = [this%model%model_simulation%climate%soil_rechr_max]
        bmi_status = BMI_SUCCESS
    case('soil_moist')
        dest = [this%model%model_simulation%climate%soil_moist]
        bmi_status = BMI_SUCCESS
    case('soil_moist_max')
        dest = [this%model%model_simulation%climate%soil_moist_max]
        bmi_status = BMI_SUCCESS
    case('hru_area_perv')
        dest = [this%model%model_simulation%runoff%hru_area_perv]
        bmi_status = BMI_SUCCESS
    case('hru_impervevap')
        dest = [this%model%model_simulation%runoff%hru_impervevap]
        bmi_status = BMI_SUCCESS
    case('soil_moist_chg')
        dest = [this%model%model_simulation%runoff%soil_moist_chg]
        bmi_status = BMI_SUCCESS
    case('soil_rechr_chg')
        dest = [this%model%model_simulation%runoff%soil_rechr_chg]
        bmi_status = BMI_SUCCESS
    case('hru_frac_perv')
        dest = [this%model%model_simulation%runoff%hru_frac_perv]
        bmi_status = BMI_SUCCESS
    case('hru_intcpstor')
        dest = [this%model%model_simulation%intcp%hru_intcpstor]
        bmi_status = BMI_SUCCESS
    case('hru_impervstor')
        dest = [this%model%model_simulation%runoff%hru_impervstor]
        bmi_status = BMI_SUCCESS
    case('swrad')
        dest = [this%model%model_simulation%solrad%swrad]
        bmi_status = BMI_SUCCESS

    case('gain_inches')
        dest = [this%model%model_simulation%intcp%gain_inches]
        bmi_status = BMI_SUCCESS
    case('intcp_changeover')
        dest = [this%model%model_simulation%intcp%intcp_changeover]
        bmi_status = BMI_SUCCESS
    case('intcp_evap')
        dest = [this%model%model_simulation%intcp%intcp_evap]
        bmi_status = BMI_SUCCESS
    case('intcp_stor')
        dest = [this%model%model_simulation%intcp%intcp_stor]
        bmi_status = BMI_SUCCESS
    case('intcp_stor_ante')
        dest = [this%model%model_simulation%intcp%intcp_stor_ante]
        bmi_status = BMI_SUCCESS
    case('net_apply')
        dest = [this%model%model_simulation%intcp%net_apply]
        bmi_status = BMI_SUCCESS
    case('net_ppt')
        dest = [this%model%model_simulation%intcp%net_ppt]
        bmi_status = BMI_SUCCESS
    case('net_rain')
        dest = [this%model%model_simulation%intcp%net_rain]
        bmi_status = BMI_SUCCESS
    case('net_snow')
        dest = [this%model%model_simulation%intcp%net_snow]
        bmi_status = BMI_SUCCESS
    case('snow_intcp')
        dest = [this%model%model_simulation%intcp%snow_intcp]
        bmi_status = BMI_SUCCESS
    case('srain_intcp')
        dest = [this%model%model_simulation%intcp%srain_intcp]
        bmi_status = BMI_SUCCESS
    case('wrain_intcp')
        dest = [this%model%model_simulation%intcp%wrain_intcp]
        bmi_status = BMI_SUCCESS

    case('snowmelt')
        dest = [this%model%model_simulation%snow%snowmelt]
        bmi_status = BMI_SUCCESS

        
    case('dprst_area_clos')
        dest = [this%model%model_simulation%runoff%dprst_area_clos]
        bmi_status = BMI_SUCCESS
    case('dprst_area_max')
        dest = [this%model%model_simulation%runoff%dprst_area_max]
        bmi_status = BMI_SUCCESS
    case('dprst_frac')
        dest = [this%model%model_simulation%runoff%dprst_frac]
        bmi_status = BMI_SUCCESS
    case('dprst_insroff_hru')
        dest = [this%model%model_simulation%runoff%dprst_insroff_hru]
        bmi_status = BMI_SUCCESS
   case('hru_percent_imperv')
        dest = [this%model%model_simulation%runoff%hru_percent_imperv]
        bmi_status = BMI_SUCCESS
    case('hru_sroffi')
        dest = [this%model%model_simulation%runoff%hru_sroffi]
        bmi_status = BMI_SUCCESS
    case('hru_sroffp')
        dest = [this%model%model_simulation%runoff%hru_sroffp]
        bmi_status = BMI_SUCCESS
    case('imperv_stor_ante')
        dest = [this%model%model_simulation%runoff%imperv_stor_ante]
        bmi_status = BMI_SUCCESS
    case('sro_to_dprst_perv')
        dest = [this%model%model_simulation%runoff%sro_to_dprst_perv]
        bmi_status = BMI_SUCCESS
    case('hortonian_flow')
        dest = [this%model%model_simulation%runoff%hortonian_flow]
        bmi_status = BMI_SUCCESS

    case default
        dest = [-1.0]
        bmi_status = BMI_FAILURE
    end select
    end function prms_get_float

    ! Get a copy of a double variable's values, flattened.
    function prms_get_double(this, name, dest) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    character (len=*), intent(in) :: name
    double precision, intent(inout) :: dest(:)
    integer :: bmi_status

    select case(name)
    case('basin_potet')
        dest = [this%model%model_simulation%potet%basin_potet]
        bmi_status = BMI_SUCCESS
    case('basin_area_inv')
        dest = [this%model%model_simulation%model_basin%basin_area_inv]
        bmi_status = BMI_SUCCESS
    case('basin_sroff')
        dest = [this%model%model_simulation%runoff%basin_sroff]
        bmi_status = BMI_SUCCESS
    case('hortonian_lakes')
        dest = [this%model%model_simulation%runoff%hortonian_lakes]
        bmi_status = BMI_SUCCESS
    case('dprst_seep_hru')
        dest = [this%model%model_simulation%runoff%dprst_seep_hru]
        bmi_status = BMI_SUCCESS
    case('strm_seg_in')
        dest = [this%model%model_simulation%runoff%strm_seg_in]
        bmi_status = BMI_SUCCESS
    case('pkwater_equiv')
        dest = [this%model%model_simulation%climate%pkwater_equiv]
        bmi_status = BMI_SUCCESS
    case('dprst_stor_hru')
        dest = [this%model%model_simulation%runoff%dprst_stor_hru]
        bmi_status = BMI_SUCCESS

    case('pkwater_ante')
        dest = [this%model%model_simulation%snow%pkwater_ante]
        bmi_status = BMI_SUCCESS

    case('upslope_hortonian')
        dest = [this%model%model_simulation%runoff%upslope_hortonian]
        bmi_status = BMI_SUCCESS
    case('dprst_in')
        dest = [this%model%model_simulation%runoff%dprst_in]
        bmi_status = BMI_SUCCESS
    case('dprst_sroff_hru')
        dest = [this%model%model_simulation%runoff%dprst_sroff_hru]
        bmi_status = BMI_SUCCESS
    case('dprst_stor_ante')
        dest = [this%model%model_simulation%runoff%dprst_stor_ante]
        bmi_status = BMI_SUCCESS
    case('dprst_vol_clos')
        dest = [this%model%model_simulation%runoff%dprst_vol_clos]
        bmi_status = BMI_SUCCESS
    case('dprst_vol_open')
        dest = [this%model%model_simulation%runoff%dprst_vol_open]
        bmi_status = BMI_SUCCESS
    case('hru_hortn_cascflow')
        dest = [this%model%model_simulation%runoff%hru_hortn_cascflow]
        bmi_status = BMI_SUCCESS

    case default
        dest = [-1.d0]
        bmi_status = BMI_FAILURE
    end select
    end function prms_get_double

    ! Get a reference to an integer-valued variable, flattened.
    function prms_get_ptr_int(this, name, dest_ptr) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    character (len=*), intent(in) :: name
    integer, pointer, intent(inout) :: dest_ptr(:)
    integer :: bmi_status, status
    type (c_ptr) :: src
    integer :: n_elements, gridid

    select case(name)
    case("nlake")
        src = c_loc(this%model%model_simulation%model_basin%nlake)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('active_hrus')
        src = c_loc(this%model%model_simulation%model_basin%active_hrus)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('nowtime')
        src = c_loc(this%model%model_simulation%model_time%nowtime(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('cov_type')
        src = c_loc(this%model%model_simulation%model_basin%cov_type(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('hru_type')
        src = c_loc(this%model%model_simulation%model_basin%hru_type(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('hru_route_order')
        src = c_loc(this%model%model_simulation%model_basin%hru_route_order(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('cascade_flag')
        src = c_loc(this%model%control_data%cascade_flag%value)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('cascadegw_flag')
        src = c_loc(this%model%control_data%cascadegw_flag%value)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('hru_area_dble')
        src = c_loc(this%model%model_simulation%model_basin%hru_area_dble)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('nhru')
        src = c_loc(this%model%model_simulation%model_basin%nhru)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('dprst_flag')
        src = c_loc(this%model%control_data%dprst_flag%value)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('print_debug')
        src = c_loc(this%model%control_data%print_debug%value)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('gsflow_mode')
        src = c_loc(this%model%control_data%gsflow_mode)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('srunoff_updated_soil')
        src = c_loc(this%model%model_simulation%runoff%srunoff_updated_soil)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('last_intcp_stor')
        src = c_loc(this%model%model_simulation%intcp%last_intcp_stor)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('transp_on')
        src = c_loc(this%model%model_simulation%transpiration%transp_on(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('active_mask')
        src = c_loc(this%model%model_simulation%model_basin%active_mask(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
        
    case('newsnow')
        src = c_loc(this%model%model_simulation%snow%newsnow(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('pptmix')
        src = c_loc(this%model%model_simulation%snow%pptmix(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('pptmix_nopack')
        src = c_loc(this%model%model_simulation%snow%pptmix_nopack(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS

    case default
        bmi_status = BMI_FAILURE
    end select

    end function prms_get_ptr_int

    ! Get a reference to a real-valued variable, flattened.
    function prms_get_ptr_float(this, name, dest_ptr) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    character (len=*), intent(in) :: name
    real, pointer, intent(inout) :: dest_ptr(:)
    integer :: bmi_status
    type (c_ptr) :: src
    integer :: n_elements, gridid, status

    select case(name)
        !case("plate_surface__temperature")
        !   src = c_loc(this%model%temperature(1,1))
        !   n_elements = this%model%n_y * this%model%n_x
        !   call c_f_pointer(src, dest, [n_elements])
        !   bmi_status = BMI_SUCCESS
    case('hru_ppt')
        src = c_loc(this%model%model_simulation%model_precip%hru_ppt(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('hru_rain')
        src = c_loc(this%model%model_simulation%model_precip%hru_rain(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('hru_snow')
        src = c_loc(this%model%model_simulation%model_precip%hru_snow(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('hru_area')
        src = c_loc(this%model%model_simulation%model_basin%hru_area(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('dprst_evap_hru')
        src = c_loc(this%model%model_simulation%runoff%dprst_evap_hru(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('infil')
        src = c_loc(this%model%model_simulation%runoff%infil(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('sroff')
        src = c_loc(this%model%model_simulation%runoff%sroff(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('potet')
        src = c_loc(this%model%model_simulation%potet%potet(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('hru_intcpevap')
        src = c_loc(this%model%model_simulation%intcp%hru_intcpevap(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('snow_evap')
        src = c_loc(this%model%model_simulation%snow%snow_evap(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('snowcov_area')
        src = c_loc(this%model%model_simulation%snow%snowcov_area(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('soil_rechr')
        src = c_loc(this%model%model_simulation%climate%soil_rechr(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('soil_rechr_max')
        src = c_loc(this%model%model_simulation%climate%soil_rechr_max(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('soil_moist')
        src = c_loc(this%model%model_simulation%climate%soil_moist(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('soil_moist_max')
        src = c_loc(this%model%model_simulation%climate%soil_moist_max(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('hru_area_perv')
        src = c_loc(this%model%model_simulation%runoff%hru_area_perv(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('hru_impervevap')
        src = c_loc(this%model%model_simulation%runoff%hru_impervevap(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('soil_moist_chg')
        src = c_loc(this%model%model_simulation%runoff%soil_moist_chg(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('soil_rechr_chg')
        src = c_loc(this%model%model_simulation%runoff%soil_rechr_chg(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('hru_intcpstor')
        src = c_loc(this%model%model_simulation%intcp%hru_intcpstor(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('hru_impervstor')
        src = c_loc(this%model%model_simulation%runoff%hru_impervstor(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('swrad')
        src = c_loc(this%model%model_simulation%solrad%swrad(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
        
    case('gain_inches')
        src = c_loc(this%model%model_simulation%intcp%gain_inches(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('intcp_changeover')
        src = c_loc(this%model%model_simulation%intcp%intcp_changeover(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('intcp_evap')
        src = c_loc(this%model%model_simulation%intcp%intcp_evap(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('intcp_stor')
        src = c_loc(this%model%model_simulation%intcp%intcp_stor(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('intcp_stor_ante')
        src = c_loc(this%model%model_simulation%intcp%intcp_stor_ante(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('net_apply')
        src = c_loc(this%model%model_simulation%intcp%net_apply(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('net_ppt')
        src = c_loc(this%model%model_simulation%intcp%net_ppt(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('net_rain')
        src = c_loc(this%model%model_simulation%intcp%net_rain(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('net_snow')
        src = c_loc(this%model%model_simulation%intcp%net_snow(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('snow_intcp')
        src = c_loc(this%model%model_simulation%intcp%snow_intcp(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('srain_intcp')
        src = c_loc(this%model%model_simulation%intcp%srain_intcp(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('wrain_intcp')
        src = c_loc(this%model%model_simulation%intcp%wrain_intcp(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS

    case('snowmelt')
        src = c_loc(this%model%model_simulation%snow%snowmelt(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
        
    case('dprst_area_clos')
        src = c_loc(this%model%model_simulation%runoff%dprst_area_clos(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('dprst_area_max')
        src = c_loc(this%model%model_simulation%runoff%dprst_area_max(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('dprst_frac')
        src = c_loc(this%model%model_simulation%runoff%dprst_frac(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('dprst_insroff_hru')
        src = c_loc(this%model%model_simulation%runoff%dprst_insroff_hru(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
   case('hru_percent_imperv')
        src = c_loc(this%model%model_simulation%runoff%hru_percent_imperv(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('hru_sroffi')
        src = c_loc(this%model%model_simulation%runoff%hru_sroffi(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('hru_sroffp')
        src = c_loc(this%model%model_simulation%runoff%hru_sroffp(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('imperv_stor_ante')
        src = c_loc(this%model%model_simulation%runoff%imperv_stor_ante(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('sro_to_dprst_perv')
        src = c_loc(this%model%model_simulation%runoff%sro_to_dprst_perv(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('hortonian_flow')
        src = c_loc(this%model%model_simulation%runoff%hortonian_flow(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS

    case default
        bmi_status = BMI_FAILURE
    end select
    end function prms_get_ptr_float

    ! Get a reference to an double-valued variable, flattened.
    function prms_get_ptr_double(this, name, dest_ptr) result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    character (len=*), intent(in) :: name
    double precision, pointer, intent(inout) :: dest_ptr(:)
    integer :: bmi_status
    type (c_ptr) :: src
    integer :: n_elements, status, gridid

    select case(name)
    case('basin_potet')
        src = c_loc(this%model%model_simulation%potet%basin_potet)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('basin_area_inv')
        src = c_loc(this%model%model_simulation%model_basin%basin_area_inv)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('basin_sroff')
        src = c_loc(this%model%model_simulation%runoff%basin_sroff)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('hortonian_lakes')
        src = c_loc(this%model%model_simulation%runoff%hortonian_lakes(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('dprst_seep_hru')
        src = c_loc(this%model%model_simulation%runoff%dprst_seep_hru(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('strm_seg_in')
        src = c_loc(this%model%model_simulation%runoff%strm_seg_in(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('pkwater_equiv')
        src = c_loc(this%model%model_simulation%climate%pkwater_equiv(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('dprst_stor_hru')
        src = c_loc(this%model%model_simulation%runoff%dprst_stor_hru(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
        
    case('pkwater_ante')
        src = c_loc(this%model%model_simulation%snow%pkwater_ante(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS


    case('upslope_hortonian')
        src = c_loc(this%model%model_simulation%runoff%upslope_hortonian)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('dprst_in')
        src = c_loc(this%model%model_simulation%runoff%dprst_in)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('dprst_sroff_hru')
        src = c_loc(this%model%model_simulation%runoff%dprst_sroff_hru)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('dprst_stor_ante')
        src = c_loc(this%model%model_simulation%runoff%dprst_stor_ante)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('dprst_vol_clos')
        src = c_loc(this%model%model_simulation%runoff%dprst_vol_clos)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('dprst_vol_open')
        src = c_loc(this%model%model_simulation%runoff%dprst_vol_open)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS
    case('hru_hortn_cascflow')
        src = c_loc(this%model%model_simulation%runoff%hru_hortn_cascflow)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, dest_ptr, [n_elements])
        bmi_status = BMI_SUCCESS

    case default
        bmi_status = BMI_FAILURE
    end select
    end function prms_get_ptr_double

    ! Get values of an integer variable at the given locations.
    function prms_get_at_indices_int(this, name, dest, inds) &
        result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    character (len=*), intent(in) :: name
    integer, intent(inout) :: dest(:)
    integer, intent(in) :: inds(:)
    integer :: bmi_status
    type (c_ptr) src
    integer, pointer :: src_flattened(:)
    integer :: i, n_elements, status, gridid

    select case(name)
    case('cov_type')
        src = c_loc(this%model%model_simulation%model_basin%cov_type(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('hru_type')
        src = c_loc(this%model%model_simulation%model_basin%hru_type(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1, size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('hru_route_order')
        src = c_loc(this%model%model_simulation%model_basin%hru_route_order(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('transp_on')
        src = c_loc(this%model%model_simulation%transpiration%transp_on(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('active_mask')
        src = c_loc(this%model%model_simulation%model_basin%active_mask(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS

    case('newsnow')
        src = c_loc(this%model%model_simulation%snow%newsnow(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('pptmix')
        src = c_loc(this%model%model_simulation%snow%pptmix(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('pptmix_nopack')
        src = c_loc(this%model%model_simulation%snow%pptmix_nopack(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS

        case default
        bmi_status = BMI_FAILURE
    end select
    end function prms_get_at_indices_int

    ! Get values of a real variable at the given locations.
    function prms_get_at_indices_float(this, name, dest, inds) &
        result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    character (len=*), intent(in) :: name
    real, intent(inout) :: dest(:)
    integer, intent(in) :: inds(:)
    integer :: bmi_status
    type (c_ptr) src
    real, pointer :: src_flattened(:)
    integer :: i, n_elements, status, gridid

    select case(name)
        !case("plate_surface__temperature")
        !   src = c_loc(this%model%temperature(1,1))
        !   call c_f_pointer(src, src_flattened, [this%model%n_y * this%model%n_x])
        !   n_elements = size(indices)
        !   do i = 1, n_elements
        !      dest(i) = src_flattened(indices(i))
        !   end do
        !   bmi_status = BMI_SUCCESS
    case('hru_ppt')
        src = c_loc(this%model%model_simulation%model_precip%hru_ppt(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('hru_rain')
        src = c_loc(this%model%model_simulation%model_precip%hru_rain(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('hru_snow')
        src = c_loc(this%model%model_simulation%model_precip%hru_snow(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('hru_area')
        src = c_loc(this%model%model_simulation%model_basin%hru_area(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('dprst_evap_hru')
        src = c_loc(this%model%model_simulation%runoff%dprst_evap_hru(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('infil')
        src = c_loc(this%model%model_simulation%runoff%infil(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('sroff')
        src = c_loc(this%model%model_simulation%runoff%sroff(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('potet')
        src = c_loc(this%model%model_simulation%potet%potet(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('hru_intcpevap')
        src = c_loc(this%model%model_simulation%intcp%hru_intcpevap(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1, n_elements
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('snow_evap')
        src = c_loc(this%model%model_simulation%snow%snow_evap(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('snowcov_area')
        src = c_loc(this%model%model_simulation%snow%snowcov_area(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('soil_rechr')
        src = c_loc(this%model%model_simulation%climate%soil_rechr(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('soil_rechr_max')
        src = c_loc(this%model%model_simulation%climate%soil_rechr_max(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('soil_moist')
        src = c_loc(this%model%model_simulation%climate%soil_moist(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1, n_elements
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('soil_moist_max')
        src = c_loc(this%model%model_simulation%climate%soil_moist_max(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('hru_area_perv')
        src = c_loc(this%model%model_simulation%runoff%hru_area_perv(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('hru_impervevap')
        src = c_loc(this%model%model_simulation%runoff%hru_impervevap(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('soil_moist_chg')
        src = c_loc(this%model%model_simulation%runoff%soil_moist_chg(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('soil_rechr_chg')
        src = c_loc(this%model%model_simulation%runoff%soil_rechr_chg(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('hru_intcpstor')
        src = c_loc(this%model%model_simulation%intcp%hru_intcpstor(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1, n_elements
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('hru_impervstor')
        src = c_loc(this%model%model_simulation%runoff%hru_impervstor(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('swrad')
        src = c_loc(this%model%model_simulation%solrad%swrad(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
        
    case('gain_inches')
        src = c_loc(this%model%model_simulation%intcp%gain_inches(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('intcp_changeover')
        src = c_loc(this%model%model_simulation%intcp%intcp_changeover(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('intcp_evap')
        src = c_loc(this%model%model_simulation%intcp%intcp_evap(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('intcp_stor')
        src = c_loc(this%model%model_simulation%intcp%intcp_stor(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('intcp_stor_ante')
        src = c_loc(this%model%model_simulation%intcp%intcp_stor_ante(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('net_apply')
        src = c_loc(this%model%model_simulation%intcp%net_apply(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('net_ppt')
        src = c_loc(this%model%model_simulation%intcp%net_ppt(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('net_rain')
        src = c_loc(this%model%model_simulation%intcp%net_rain(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('net_snow')
        src = c_loc(this%model%model_simulation%intcp%net_snow(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('snow_intcp')
        src = c_loc(this%model%model_simulation%intcp%snow_intcp(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('srain_intcp')
        src = c_loc(this%model%model_simulation%intcp%srain_intcp(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('wrain_intcp')
        src = c_loc(this%model%model_simulation%intcp%wrain_intcp(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS

    case('snowmelt')
        src = c_loc(this%model%model_simulation%snow%snowmelt(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS

    case('dprst_area_clos')
        src = c_loc(this%model%model_simulation%runoff%dprst_area_clos(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('dprst_area_max')
        src = c_loc(this%model%model_simulation%runoff%dprst_area_max(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('dprst_frac')
        src = c_loc(this%model%model_simulation%runoff%dprst_frac(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('dprst_insroff_hru')
        src = c_loc(this%model%model_simulation%runoff%dprst_insroff_hru(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
   case('hru_percent_imperv')
        src = c_loc(this%model%model_simulation%runoff%hru_percent_imperv(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('hru_sroffi')
        src = c_loc(this%model%model_simulation%runoff%hru_sroffi(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('hru_sroffp')
        src = c_loc(this%model%model_simulation%runoff%hru_sroffp(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('imperv_stor_ante')
        src = c_loc(this%model%model_simulation%runoff%imperv_stor_ante(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('sro_to_dprst_perv')
        src = c_loc(this%model%model_simulation%runoff%sro_to_dprst_perv(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('hortonian_flow')
        src = c_loc(this%model%model_simulation%runoff%hortonian_flow(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
 
    case default
        bmi_status = BMI_FAILURE
    end select
    end function prms_get_at_indices_float

    ! Get values of a double variable at the given locations.
    function prms_get_at_indices_double(this, name, dest, inds) &
        result (bmi_status)
    class (bmi_prms_surface), intent(in) :: this
    character (len=*), intent(in) :: name
    double precision, intent(inout) :: dest(:)
    integer, intent(in) :: inds(:)
    integer :: bmi_status
    type (c_ptr) src
    double precision, pointer :: src_flattened(:)
    integer :: i, n_elements, status, gridid

    select case(name)
    case('hortonian_lakes')
        src = c_loc(this%model%model_simulation%runoff%hortonian_lakes(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('dprst_seep_hru')
        src = c_loc(this%model%model_simulation%runoff%dprst_seep_hru(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('strm_seg_in')
        src = c_loc(this%model%model_simulation%runoff%strm_seg_in(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('pkwater_equiv')
        src = c_loc(this%model%model_simulation%climate%pkwater_equiv(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('dprst_stor_hru')
        src = c_loc(this%model%model_simulation%runoff%dprst_stor_hru(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS

    case('pkwater_ante')
        src = c_loc(this%model%model_simulation%snow%pkwater_ante(1))
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS

    case('upslope_hortonian')
        src = c_loc(this%model%model_simulation%runoff%upslope_hortonian)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('dprst_in')
        src = c_loc(this%model%model_simulation%runoff%dprst_in)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('dprst_sroff_hru')
        src = c_loc(this%model%model_simulation%runoff%dprst_sroff_hru)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('dprst_stor_ante')
        src = c_loc(this%model%model_simulation%runoff%dprst_stor_ante)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('dprst_vol_clos')
        src = c_loc(this%model%model_simulation%runoff%dprst_vol_clos)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('dprst_vol_open')
        src = c_loc(this%model%model_simulation%runoff%dprst_vol_open)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS
    case('hru_hortn_cascflow')
        src = c_loc(this%model%model_simulation%runoff%hru_hortn_cascflow)
        status = this%get_var_grid(name,gridid)
        status = this%get_grid_size(gridid, n_elements)
        call c_f_pointer(src, src_flattened, [n_elements])
        do i = 1,  size(inds)
            dest(i) = src_flattened(inds(i))
        end do
        bmi_status = BMI_SUCCESS

        case default
        bmi_status = BMI_FAILURE
    end select
    end function prms_get_at_indices_double

    ! Set new integer values.
    function prms_set_int(this, name, src) result (bmi_status)
    class (bmi_prms_surface), intent(inout) :: this
    character (len=*), intent(in) :: name
    integer, intent(in) :: src(:)
    integer :: bmi_status

    select case(name)
      case('srunoff_updated_soil')
          this%model%model_simulation%runoff%srunoff_updated_soil = src(1)
          bmi_status = BMI_SUCCESS
        case default
        bmi_status = BMI_FAILURE
    end select
    end function prms_set_int

    ! Set new real values.
    function prms_set_float(this, name, src) result (bmi_status)
    class (bmi_prms_surface), intent(inout) :: this
    character (len=*), intent(in) :: name
    real, intent(in) :: src(:)
    integer :: bmi_status

    select case(name)
    case('dprst_evap_hru')
        this%model%model_simulation%runoff%dprst_evap_hru = src
        bmi_status = BMI_SUCCESS
    case('hru_area_perv')
        this%model%model_simulation%runoff%hru_area_perv = src
        bmi_status = BMI_SUCCESS
    case('hru_impervevap')
        this%model%model_simulation%runoff%hru_impervevap = src
        bmi_status = BMI_SUCCESS
    case('infil')
        this%model%model_simulation%runoff%infil = src
        bmi_status = BMI_SUCCESS
    case('soil_moist_chg')
        this%model%model_simulation%runoff%soil_moist_chg = src
        bmi_status = BMI_SUCCESS
    case('soil_rechr_chg')
        this%model%model_simulation%runoff%soil_rechr_chg = src
        bmi_status = BMI_SUCCESS
    case('sroff')
        this%model%model_simulation%runoff%sroff = src
        bmi_status = BMI_SUCCESS
    case('potet')
        this%model%model_simulation%potet%potet = src
        bmi_status = BMI_SUCCESS
    case('soil_rechr')
        this%model%model_simulation%climate%soil_rechr = src
        bmi_status = BMI_SUCCESS
    case('soil_rechr_max')
        this%model%model_simulation%climate%soil_rechr_max = src
        bmi_status = BMI_SUCCESS
    case('soil_moist')
        this%model%model_simulation%climate%soil_moist = src
        bmi_status = BMI_SUCCESS
    case('soil_moist_max')
        this%model%model_simulation%climate%soil_moist_max = src
        bmi_status = BMI_SUCCESS
        case default
        bmi_status = BMI_FAILURE
    end select
    end function prms_set_float

    ! Set new double values.
    function prms_set_double(this, name, src) result (bmi_status)
    class (bmi_prms_surface), intent(inout) :: this
    character (len=*), intent(in) :: name
    double precision, intent(in) :: src(:)
    integer :: bmi_status

    select case(name)
     case('basin_sroff')
        this%model%model_simulation%runoff%basin_sroff = src(1)
        bmi_status = BMI_SUCCESS
    case('dprst_seep_hru')
        this%model%model_simulation%runoff%dprst_seep_hru = src
        bmi_status = BMI_SUCCESS
    case('strm_seg_in')
        this%model%model_simulation%runoff%strm_seg_in = src
        bmi_status = BMI_SUCCESS
    case('basin_potet')
        this%model%model_simulation%potet%basin_potet = src(1)
        bmi_status = BMI_SUCCESS
        
        case default
        bmi_status = BMI_FAILURE
    end select
    end function prms_set_double
    !
    !! Set integer values at particular locations.
    !function prms_set_at_indices_int(this, name, indices, src) &
    !     result (bmi_status)
    !  class (bmi_prms_surface), intent(inout) :: this
    !  character (len=*), intent(in) :: name
    !  integer, intent(in) :: indices(:)
    !  integer, intent(in) :: src(:)
    !  integer :: bmi_status
    !  type (c_ptr) dest
    !  integer, pointer :: dest_flattened(:)
    !  integer :: i
    !
    !  select case(name)
    !  case default
    !     bmi_status = BMI_FAILURE
    !  end select
    !end function prms_set_at_indices_int
    !
    !! Set real values at particular locations.
    !function prms_set_at_indices_float(this, name, indices, src) &
    !     result (bmi_status)
    !  class (bmi_prms_surface), intent(inout) :: this
    !  character (len=*), intent(in) :: name
    !  integer, intent(in) :: indices(:)
    !  real, intent(in) :: src(:)
    !  integer :: bmi_status
    !  type (c_ptr) dest
    !  real, pointer :: dest_flattened(:)
    !  integer :: i
    !
    !  select case(name)
    !  case("plate_surface__temperature")
    !     dest = c_loc(this%model%temperature(1,1))
    !     call c_f_pointer(dest, dest_flattened, [this%model%n_y * this%model%n_x])
    !     do i = 1, size(indices)
    !        dest_flattened(indices(i)) = src(i)
    !     end do
    !     bmi_status = BMI_SUCCESS
    !  case default
    !     bmi_status = BMI_FAILURE
    !  end select
    !end function prms_set_at_indices_float
    !
    !! Set double values at particular locations.
    !function prms_set_at_indices_double(this, name, indices, src) &
    !     result (bmi_status)
    !  class (bmi_prms_surface), intent(inout) :: this
    !  character (len=*), intent(in) :: name
    !  integer, intent(in) :: indices(:)
    !  double precision, intent(in) :: src(:)
    !  integer :: bmi_status
    !  type (c_ptr) dest
    !  double precision, pointer :: dest_flattened(:)
    !  integer :: i
    !
    !  select case(name)
    !  case default
    !     bmi_status = BMI_FAILURE
    !  end select
    !end function prms_set_at_indices_double
    !
    !! A non-BMI procedure for model introspection.
    !subroutine print_model_info(this)
    !  class (bmi_prms_surface), intent(in) :: this
    !
    !  call print_info(this%model)
    !end subroutine print_model_info

    end module bmiprmssurface
