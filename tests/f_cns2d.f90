!!-----------------------------------------------------------------------bl-
!!--------------------------------------------------------------------------
!!
!! MASA - Manufactured Analytical Solutions Abstraction Library
!!
!! Copyright (C) 2010 The PECOS Development Team
!!
!! This library is free software; you can redistribute it and/or
!! modify it under the terms of the Version 2.1 GNU Lesser General
!! Public License as published by the Free Software Foundation.
!!
!! This library is distributed in the hope that it will be useful,
!! but WITHOUT ANY WARRANTY; without even the implied warranty of
!! MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
!! Lesser General Public License for more details.
!!
!! You should have received a copy of the GNU Lesser General Public
!! License along with this library; if not, write to the Free Software
!! Foundation, Inc. 51 Franklin Street, Fifth Floor,
!! Boston, MA  02110-1301  USA
!!
!!-----------------------------------------------------------------------el-
!!
!! f_cns2d.f90: Fortran compressible navier stokes 2d test
!!
!! $Id: masa.f90 13217 2010-09-11 04:30:16Z nick $
!! -------------------------------------------------------------------------
!! -------------------------------------------------------------------------

program main
  use masa

  implicit none

  ! threshold calculation
  real(8) :: thresh = 1e-15

  ! solutions
  real(8) ::ufield,ufield2,ufield3
  real(8) ::vfield,vfield2,vfield3
  real(8) ::efield,efield2,efield3
  real(8) ::rho,rho2,rho3

  real(8) ::u_an,u_an2,u_an3
  real(8) ::v_an,v_an2,v_an3
  real(8) ::p_an,p_an2,p_an3
  real(8) ::rho_an,rho_an2,rho_an3

  ! variables 
  real(8) :: u_0
  real(8) :: u_x
  real(8) :: u_y
  real(8) :: v_0
  real(8) :: v_x
  real(8) :: v_y
  real(8) :: rho_0
  real(8) :: rho_x
  real(8) :: rho_y
  real(8) :: p_0
  real(8) :: p_x
  real(8) :: p_y
  real(8) :: a_px
  real(8) :: a_py
  real(8) :: a_rhox
  real(8) :: a_rhoy
  real(8) :: a_ux
  real(8) :: a_uy
  real(8) :: a_vx
  real(8) :: a_vy
  real(8) :: Gamma
  real(8) :: mu
  real(8) :: L
  real(8) :: R
  real(8) :: k

  ! declarations
  real(8) :: value, val
  real(8) :: out,out1=1
  real(8) :: x
  real(8) :: y
  real(8) :: fsol
  ! problem size
  integer i,j
  integer ::  nx = 71
  integer ::  ny = 93  
  integer ::  lx=3
  integer ::  ly=1 
  real(8) ::  dx 
  real(8) ::  dy

  ! external functions
  real(8) :: eval_2d_u_source
  real(8) :: eval_2d_v_source
  real(8) :: eval_2d_e_source
  real(8) :: eval_2d_rho_source

  real(8) :: eval_2d_u_an
  real(8) :: eval_2d_v_an
  real(8) :: eval_2d_p_an
  real(8) :: eval_2d_rho_an

  ! initialize the problem
  dx = real(lx)/real(nx)
  dy = real(ly)/real(ny);

  call masa_init("navier-stokes-test","navierstokes_2d_compressible");

  ! initialize the default parameters
  call masa_init_param()

  ! intialize the various parameters required for Euler 2D
  u_0 = masa_get_param("u_0")
  u_x = masa_get_param("u_x")
  u_y = masa_get_param("u_y")

  v_0 = masa_get_param("v_0")
  v_x = masa_get_param("v_x")
  v_y = masa_get_param("v_y")

  rho_0 = masa_get_param("rho_0")
  rho_x = masa_get_param("rho_x")
  rho_y = masa_get_param("rho_y")

  p_0 = masa_get_param("p_0")
  p_x = masa_get_param("p_x")
  p_y = masa_get_param("p_y")

  a_px = masa_get_param("a_px")
  a_py = masa_get_param("a_py")

  a_rhox = masa_get_param("a_rhox")
  a_rhoy = masa_get_param("a_rhoy")

  a_ux = masa_get_param("a_ux")
  a_uy = masa_get_param("a_uy")

  a_vx = masa_get_param("a_vx")
  a_vy = masa_get_param("a_vy")

  Gamma = masa_get_param("Gamma")
  mu    = masa_get_param("mu")
  L     = masa_get_param("L")

  R = masa_get_param("R");
  K = masa_get_param("k");


  ! call the sanity check routine 
  ! (tests that all variables have been initialized)
  call masa_sanity_check()

  ! evaluate source terms (2D)
  do i=0, nx
     do j=0, ny
        
	x = i * dx
        y = j * dy
               
        ! evalulate source terms
        ufield = masa_eval_2d_u_source  (x,y)
	vfield = masa_eval_2d_v_source  (x,y)
        efield = masa_eval_2d_e_source  (x,y)
        rho    = masa_eval_2d_rho_source(x,y)
	
	!evaluate analytical terms
	u_an = masa_eval_2d_u_an        (x,y)
	v_an = masa_eval_2d_v_an        (x,y)
	p_an = masa_eval_2d_p_an        (x,y)
	rho_an = masa_eval_2d_rho_an    (x,y)
		  
        ! check against maple
        ufield2 = eval_2d_u_source  (%val(x),%val(y),%val(u_0),%val(u_x),%val(u_y),%val(v_0),%val(v_x),%val(v_y), &
             %val(rho_0),%val(rho_x),%val(rho_y),%val(p_0),%val(p_x),%val(p_y),%val(a_px),%val(a_py), &
             %val(a_rhox),%val(a_rhoy),%val(a_ux),%val(a_uy),%val(a_vx),%val(a_vy),%val(mu),%val(L),%val(R),%val(K))

	vfield2 = eval_2d_v_source  (%val(x),%val(y),%val(u_0),%val(u_x),%val(u_y),%val(v_0),%val(v_x),%val(v_y), &
             %val(rho_0),%val(rho_x),%val(rho_y),%val(p_0),%val(p_x),%val(p_y),%val(a_px),%val(a_py), &
             %val(a_rhox),%val(a_rhoy),%val(a_ux),%val(a_uy),%val(a_vx),%val(a_vy),%val(mu),%val(L),%val(R),%val(K))

        rho2    = eval_2d_rho_source(%val(x),%val(y),%val(u_0),%val(u_x),%val(u_y),%val(v_0),%val(v_x),%val(v_y), &
             %val(rho_0),%val(rho_x),%val(rho_y),%val(p_0),%val(p_x),%val(p_y),%val(a_px),%val(a_py), &
             %val(a_rhox),%val(a_rhoy),%val(a_ux),%val(a_uy),%val(a_vx),%val(a_vy),%val(mu),%val(L),%val(R),%val(K))
 
        efield2 = eval_2d_e_source  (%val(x),%val(y),%val(u_0),%val(u_x),%val(u_y),%val(v_0),%val(v_x),%val(v_y), &
             %val(rho_0),%val(rho_x),%val(rho_y),%val(p_0),%val(p_x),%val(p_y),%val(a_px),%val(a_py), &
             %val(a_rhox),%val(a_rhoy),%val(a_ux),%val(a_uy),%val(a_vx),%val(a_vy),%val(Gamma),%val(mu),%val(L),%val(R),%val(K))

        u_an2   = eval_2d_u_an  (%val(x),%val(y),%val(u_0),%val(u_x),%val(u_y),%val(a_ux),%val(a_uy),%val(L))
        v_an2   = eval_2d_v_an  (%val(x),%val(y),%val(v_0),%val(v_x),%val(v_y),%val(a_vx),%val(a_vy),%val(L))
        rho_an2 = eval_2d_rho_an(%val(x),%val(y),%val(rho_0),%val(rho_x),%val(rho_y),%val(a_rhox),%val(a_rhoy),%val(L))
        p_an2   = eval_2d_p_an  (%val(x),%val(y),%val(p_0),%val(p_x),%val(p_y),%val(a_px),%val(a_py),%val(L))

        ! need to add strict / non-strict regressions
        ufield3 = abs(ufield-ufield2)/abs(ufield2)
	vfield3 = abs(vfield-vfield2)/abs(vfield2)
	efield3 = abs(efield-efield2)/abs(efield2)
	rho3    = abs(rho-rho2)/abs(rho2)
	
	u_an3   = abs(u_an-u_an2)/abs(u_an2)
	v_an3   = abs(v_an-v_an2)/abs(u_an2)
	rho_an3 = abs(rho_an-rho_an2)/abs(rho2)
	p_an3   = abs(p_an-p_an2)/abs(p_an2)
 
        ! just need error checker
        if(ufield3 .gt. thresh) then
           write(6,*) "FortMASA FATAL ERROR: Navier-Stokes-2d"
           write(6,*) "U Field"
           write(6,*) "exceeded by: ", ufield3
           write(6,*) "masa:        ", ufield
           write(6,*) "maple:       ", ufield2
           write(6,*) "@ x,y:       ",x,y
           call exit(1)
        endif
        
        if(vfield3 .gt. thresh) then
           write(6,*) "FortMASA FATAL ERROR: Navier-Stokes-2d"
           write(6,*) "V Field"
           call exit(1)
        endif
        
        if(efield3 .gt. thresh) then
           write(6,*) "FortMASA FATAL ERROR: Navier-Stokes-2d"
           write(6,*) "E Field"
           write(6,*) "exceeded by: ", efield3
           write(6,*) "masa:        ", efield
           write(6,*) "maple:       ", efield2
           write(6,*) "@ x,y:       ",x,y
           call exit(1)
        endif

        if(rho3 .gt. thresh) then
           write(6,*) "FortMASA FATAL ERROR: Navier-Stokes-2d"
           write(6,*) "Rho Field"
           call exit(1)
        endif

        ! analytical terms now
        if(u_an3 .gt. thresh) then
           write(6,*) "FortMASA FATAL ERROR: Navier-Stokes-2d"
           write(6,*) "U an"
           call exit(1)
        endif

        if(v_an3 .gt. thresh) then
           write(6,*) "FortMASA FATAL ERROR: Navier-Stokes-2d"
           write(6,*) "V an"
           call exit(1)
        endif

        if(p_an3 .gt. thresh) then
           write(6,*) "FortMASA FATAL ERROR: Navier-Stokes-2d"
           write(6,*) "P an"
           call exit(1)
        endif

        if(rho_an3 .gt. thresh) then
           write(6,*) "FortMASA FATAL ERROR: Navier-Stokes-2d"
           write(6,*) "Rho an"
           call exit(1)
        endif             

     enddo
  enddo
  
  ! steady as she goes (exit with success)
  call exit(0)

end program main
