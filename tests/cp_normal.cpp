// -*-c++-*-
//
//-----------------------------------------------------------------------bl-
//--------------------------------------------------------------------------
//
// MASA - Manufactured Analytical Solutions Abstraction Library
//
// Copyright (C) 2010,2011,2012,2013 The PECOS Development Team
//
// This library is free software; you can redistribute it and/or
// modify it under the terms of the Version 2.1 GNU Lesser General
// Public License as published by the Free Software Foundation.
//
// This library is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
// Lesser General Public License for more details.
//
// You should have received a copy of the GNU Lesser General Public
// License along with this library; if not, write to the Free Software
// Foundation, Inc. 51 Franklin Street, Fifth Floor,
// Boston, MA  02110-1301  USA
//
//-----------------------------------------------------------------------el-
// $Author: nick $
// $Id: 
//
//
//--------------------------------------------------------------------------
//--------------------------------------------------------------------------

#include <tests.h>

using namespace MASA;
using namespace std;

template<typename Scalar>
int run_regression()
{  
  int err = 0;
  Scalar x;
  Scalar likelyhood,loglikelyhood,prior,posterior,first_moment;
  Scalar mean, variance;

  int nx = 115;  // number of points
  int lx = 2;  // number of points
  Scalar dx=Scalar(lx)/Scalar(nx);

  std::vector<Scalar> data;

  // initialize the problem
  err += masa_init<Scalar>("smasa-example-gaussian","cp_normal");

  // call the sanity check routine 
  // (tests that all variables have been initialized)
  //err += masa_sanity_check<Scalar>();

  // grab the default data vector:
  //masa_get_vec<Scalar>("vec_data",data);

  // change the data vector to new values:
  //masa_set_vec<Scalar>("vec_data",data);

  // evaluate likelyhood, prior, posterior
    for(int i=0;i<nx;i++)
      {  
	x=i*dx;
	
	likelyhood   = masa_eval_likelyhood<Scalar>(x);	
	loglikelyhood= masa_eval_loglikelyhood<Scalar>(x);	
	prior        = masa_eval_prior<Scalar>(x);	
	posterior    = masa_eval_posterior<Scalar>(x);
	first_moment = masa_eval_central_moment<Scalar>(1);
	if(first_moment != 0)
	  {
	    cout << "error in first moment";
	    return 1;
	  }
	mean = masa_eval_posterior_mean<Scalar>();
	variance = masa_eval_posterior_variance<Scalar>();

	nancheck(mean);
	nancheck(variance);
	nancheck(likelyhood);
	nancheck(loglikelyhood);
	nancheck(prior);
	nancheck(posterior);

      }

    return err;
}

// queue
int main()
{
  int err=0;

  err += run_regression<double>();
  err += run_regression<long double>();

  return err;
}
