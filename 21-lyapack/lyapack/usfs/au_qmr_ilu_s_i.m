function au_qmr_ilu_s_i(p)
%
%  Generates the data used in 'au_qmr_ilu_s'. Data are stored in global
%  variables.
% 
%  NOTE that 'au_qmr_ilu_m_i' must be called before calling this routine.
% 
%  Calling sequence:
%
%    au_qmr_ilu_s_i(p)
%
%  Input:
%
%    p         vector containing the ADI shift parameters p(i).
%
%  Remarks:
% 
%    This routine has access to the matrix A and some other data, which 
%    must be provided by the routine 'au_qmr_ilu_m_i',
%
%    The real parts of the entries of p must be negative.
%
%
%  LYAPACK 1.0 (Thilo Penzl, August 1999)

if nargin~=1
  error('Wrong number of input arguments.');
end

if any(real(p)>=0)
  error('Real parts of entries of p must be negative!');
end

l = length(p);

global LP_A LP_P LP_MC LP_TOL_ILU LP_INFO_QMR

if ~length(LP_A) | ~length(LP_MC) | ~length(LP_TOL_ILU) | ~length(LP_INFO_QMR)
  error('This routine needs global data which must be generated by calling ''au_qmr_ilu_m_i'' first.');
end 

n = size(LP_A,1);

LP_P = p;
   
if LP_MC=='C' 

  for i = 1:l

    eval(lp_e( 'global LP_L',i,' LP_U',i ));

    eval(lp_e( '[LP_L',i,',LP_U',i,'] = luinc(LP_A+p(i)*speye(n),LP_TOL_ILU);' ));
 
%
%  This shows the amount of fill-in created by the ILU preconditioner:
%

    if LP_INFO_QMR >= 5
      nnA = nnz(LP_A);
      eval(lp_e( 'nnLU = nnz(LP_L',i,')+nnz(LP_U',i,');'  ));   
      disp(sprintf('ILU-Ratio (nnz(L)+nnz(U))/nnz(A) = %6g',nnLU/nnA)); 
    end
  end

end





