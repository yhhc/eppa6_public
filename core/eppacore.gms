* This is the static model written in MPSGE.  The model calibration is in eppacalib.gms

$ontext
$model:eppa

$sectors:
    w(r)                                                                           	  	! welfare index	   			   					                                                                 											      
    z(r)                                 			       	           	  	! consumption index   								       								      
    htrn(r)			             			       	           	  	! household transport 								       								      
    a(g,r)$((not x(g))$a0(r,g))          			       	           	  	! armington index     								       								      
    dv(g,v,r)$v_k(g,v,r)                                               	           	  	! vintage production (clay)	       	  				       	       								      
    homx(x,r)$homx0(x,r)    				       	       	           	  	! net exports of homogenous goods      						       								      
    homm(x,r)$homm0(x,r)    				       	       	           	  	! net imports of homogenous goods      						       								      
    n_e(r)$n_e0(r)						       	           	  	! nuclear electric generation	       						       								      
    h_e(r)$h_e0(r)						       	           	  	! hydro electric generation	       						       								      
    d(g,r)$xp0(r,g)         				       	       	                        ! domestic production index	       						       								      
    govt(r)                 				       	       	                        ! aggregated government consumption index	       				       								      
    inv(r)                  				       	       	                        ! investment index		       						       								      
    eb(bt,r)$active(bt,r)   				               	                        ! backstop production index            						       								      
    ebv(vbt,v,r)$active(vbt,r)$vintgbs(vbt,r)$vb_k(vbt,v,r)$vb_dk(vbt,v,r)                      ! vintaged backstop production index						       								      
    eid(e,g,r)$eind(e,g,r)                                             	           	  	! conventional intermediate energy demand					       								      
    edf(e,r)$efd(e,r)                                                  	           	  	! conventional final energy demand						       								      
    tedf(e,r)$tefd(e,r)                                                	           	  	! conventional final energy demand -- hh transport				       								      
    yt			                                               	           	  	! international transport							       								      
    eid_ghg(e,g,r)$eind(e,g,r)                                         	           	  	! energy demand inclusive of ghg -- intermediate					      								      
    efd_ghg(e,r)$efd(e,r)                                              	           	  	! energy demand inclusive of ghg -- final					       								      
    tefd_ghg(e,r)$tefd(e,r)                                            	           	  	! energy demand inclusive of ghg -- hh transport					      								      
    eqco2(ghg,r)$((ghgk(r)$ghglim(ghg,r))$ghgt)                        	           	  	! transforming carbon rights to ghg rights -- regional or regional to international					       								      
    eqghg(ghg,r)$((ghgk(r)$ghglim(ghg,r))$ghgt)                        	           	  	! transforming ghg rights to carbon rights -- regional or regional to international					       								      
    ewco2(ghg)$(wghgk$ghgt)	       	  	                                                ! transforming carbon rights to ghg rights -- international										      								      
    ewghg(ghg)$(wghgk$ghgt)	       	  	                                                ! transforming ghg rights to carbon rights -- international									      								      
    seqco2(ghg,g,r)$((sghgk(r)$(ghglimg(ghg,g,r)))$ghgt)                                        ! transform co2 to ghg permits -- sector						      								      
    seqghg(ghg,g,r)$((sghgk(r)$(ghglimg(ghg,g,r)))$ghgt)                                        ! transform ghg to co2 permits -- sector						      								      
    feqco2(ghg,r)$((sghgk(r)$ghglimg(ghg,"fd",r))$ghgt)                	           	  	! transform co2 to ghg permits -- final demand					       								      
    feqghg(ghg,r)$((sghgk(r)$ghglimg(ghg,"fd",r))$ghgt)                	           	  	! transform ghg to co2 permits -- final demand					       								      
    m(g,r)$(xm0(r,g)$(not x(g)))                                       	           	  	! imports gross of tariffs and transport cost					       								      
    bio_i(g,r)$((active("bio-oil",r) or active("bio-fg",r))$eind("roil",g,r))	                ! bio-oil for intermediates							       								      
    bio_f(r)$((active("bio-oil",r) or active("bio-fg",r))$efd("roil",r))	                ! bio-oil for final demand							       								      
    bio_t(r)$((active("bio-oil",r) or active("bio-fg",r))$teusef("roil",r))                     ! bio-oil for transportation
    biom_i(g,r)$((active("bio-oil","usa") or active("bio-fg","usa"))$eind("roil",g,r)$biot)	! net imports of bio-oil								      								      
    biom_f(r)$((active("bio-oil","usa") or active("bio-fg","usa"))$efd("roil",r)$biot)	       	! net imports of bio-oil								      								      
    biox(r)$((active("bio-oil",r) or active("bio-fg",r))$biot)				       	! net exports of bio-oil								      								      
    ngm(mkt,r)$(gmap(r,mkt)$gmarket)				       	                        ! regional gas market								       								      
    tflowm_(r,rr,g)$(wtflow0(r,rr,g) and not gmarket and not x(g))     	                        ! import from the 2nd index to the 1st index					       								      
    tflowm_(r,rr,g)$(wtflow0(r,rr,g) and gmarket and not x(g) and not gas(g))                   ! import from the 2nd index to the 1st index					       								      
    mqhom_(x,r)$homm0(x,r)                                                                      ! net imports of homogenous goods exclude transportation margin
    ccstar(g,r)$cstar(r,g)						  		        ! Stone-Geary subsistence consumption level 
									  		  	
$commodities:							       	  	       	    	       									      								      
    pu(r)                                                              	                 	! consumption price index		     					       								      
    pw(r)                   					       	  	       	    	! welfare price index			  					       								      
    pt								       	  	       	    	! international transport price		  					       								      
    ptrn(r)							       	  	       	    	! household transport price index	  					       								      
    pwh(g)$x(g)             					       	  	       	    	! world market price of homogenous goods  					       								      
    phom(g,r)$x(g)          					       	  	       	    	! domestic price of homogenous goods	  					       								      
    pr(r)$n_r0(r)						       	  	       	    	! return to nuclear resource factor	  					       								      
    pr_h(r)$h_r0(r)						       	  	       	    	! return to hydro resource factor         					       								      
    pai_c(e,g,r)$eind(e,g,r)                                           	                 	! input price gross of carbon tax -- intermediate   				       								        		   
    paf_c(e,r)$efd(e,r)          				       	  	       	        ! input price gross of carbon tax -- final      	      	 			      								      
    pai_g(e,g,r)$eind(e,g,r)     				       	  	       	    	! input price gross of ghg tax -- intermediate           	 		       								      
    paf_g(e,r)$efd(e,r)          				       	  	       	    	! input price gross of ghg tax -- final      	      	 			       								      
    paf_ch(e,r)$tefd(e,r)        				       	  	       	    	! input price gross of carbon tax -- hh transport	      	 		       								      
    paf_gh(e,r)$tefd(e,r)        				       	  	       	    	! input price gross of ghg tax -- hh transport           	   		       								      
    pa(g,r)$((not x(g))$a0(r,g))                                       	                 	! armington price           			       				       								      
    pd(g,r)$((not x(g))$xp0(r,g))      			       	       	         	       	! domestic price	       								      								      
    png(mkt)$gmarket		   			       	       	         	       	! regional gas price	       							       								      
    pk(r)$(kapital(r) gt 0)                             	     	  	     	        ! capital price	       								       								      
    pkv(g,v,r)$(v_k(g,v,r) and v_dk(r,g,v))             	          	                ! extant capital price index							       								      
    pvbk(vbt,v,r)$active(vbt,r)$vintgbs(vbt,r)$vb_k(vbt,v,r)$vb_dk(vbt,v,r)                     ! extant backstop capital price							       								      
    pf(g,r)$ffactd0(r,g)                                               	                        ! fixed factor price         			  						     				       								      
    pl(r)                   			     		       	  			! wage 			     		         		        				       								      
    pg(r)                   			     		       	  			! government output price    			         		        			       								      
    pinv(r)                 			     		       	  			! investment price	     			         		        			       								      
    scarb(g,r)$((sco2c(r)$ss(g,r))$scarblim(g,r))                      	  			! non-tradable sector-specific co2 permit price        		        				       								      
    fcarb(r)$(sco2c(r)$fdf(r))                                         	  			! non-tradable co2 permit price -- final	         		        													      
    pcarb(r)$co2c(r)                   				       	  			! non-tradable co2 emission permit price	         		        				      								      
    ptcarb$ttco2                       				       	  			! tradable co2 emission permit price		         		        			       								      
    pren(r)$srenc(r)	               				       	  			! price renewables or credits for rps		         		        			       								      
    pbf(bt,r)$(active(bt,r)$bres(bt,r)$(not(ngcap(bt) or igcap(bt))))  	  			! resource constraint on backstop		         		        			       								      
    pbf(bt,r)$(active(bt,r)$bres(bt,r)$ngcap(bt)$(not active("ngcc",r)))  			! resource constraint on backstop		         		        			       								      
    pbf(bt,r)$(active(bt,r)$bres(bt,r)$igcap(bt)$(not active("igcc",r)))  			! resource constraint on backstop		         		        			       								      
    pbo(r)$(active("bio-oil",r) or active("bio-fg",r))	       		  			! price index for biofuels (regional)  	         		        			       								      
    pwo$((active("bio-oil","usa") or active("bio-fg","usa"))$biot)	  			! price index for biofuels (international)	         		        			       								      
    pm(g,r)$(xm0(r,g)$(not x(g)))	                	       	  			! import price index			                 		   		   		       								      
    sghg(ghg,g,r)$(ghglimg(ghg,g,r)) 	       	                          			! ghg price -- sector 			  	        		        		   		       								      
    fghg(ghg,r)$(ghglimg(ghg,"fd",r)) 	       	                          			! ghg price -- final demand                            		  		    			      								      
    pghg(ghg,r)$(ghglim(ghg,r)$(not wghgk))	                          			! ghg price -- national 			         		        				      								      					       								      
    pghgw(ghg)$wghgk                            	 	          			! ghg price -- global trading			         		        			       								      							      								      
    purb(urb,r)$urblim(urb,r)		                               	  			! non-ghg gases                     		         		        	    		       								      
    pshale(r)$active("synf-oil",r)				       	  			! price index for shale oil resource                   		                                                        								      
    pd_(g,rr)$(sum(r,wtflow0(r,rr,g)) ne 0 and not gmarket and not x(g))                        ! the same as pd (used to extract tflowm)    
    pd_(g,rr)$(sum(r,wtflow0(r,rr,g)) ne 0 and gmarket and not x(g) and not gas(g))             ! the same as pd (used to get tflowm as an output variable)    
    pwh_(g)$x(g)                                                                                ! the same as pwh (used to get mqhom as an output variable) 							      
    pcafe(r)$active("cafe",r)                                             			! shadow price for cafe standard constraint		             			      
    pcstar(g,r)$cstar(r,g)						  			! price index for Stone-Geary subsistence consumption	             			        								
									  										             			      
$consumers:								  										             			      
    ra(r)                                                             			        ! representative consumer				             			      
									  										             			      
$auxiliary:								  										             			      
    nuclim			                                          			! endogenous instrument to limit nuclear		             			      
    rgdp(r)                                                               			! real gdp of region r				      	            			      
    tflowm__(r,rr,g)                                                      			! tflowm_ without dollar sign conditions		             			      
    pd__(g,r)                                                             			! pd without dollar sign conditions			             			      
    gprod(r)                                                              			! productivity index					             			      
    tlimc(e,g,r)$eid_ghg_up(e,g,r)                                        			! tax rate instrument for limiting energy use                      			      

$report:
  v:outg(r)                                                o:pg(r)                  prod:govt(r)
  v:outi(r)             		       	           o:pinv(r)       	    prod:inv(r)
  v:outt(g,r)           		       	           o:pa(g,r)       	    prod:a(g,r)
  v:homd(x,r)           		       	           o:phom(x,r)     	    prod:d(x,r)
  v:homa(x,r)           		       	           i:phom(x,r)     	    prod:ed(x,r)
  v:xvhom(x,r)          		       	           o:pwh(x)        	    prod:homx(x,r)
  v:xqhom(x,r)          		       	           i:phom(x,r)     	    prod:homx(x,r)
  v:mvhom(x,r)          		       	           o:phom(x,r)     	    prod:homm(x,r)
  v:mqhom(x,r)                                             o:pwh_(x)       	    prod:mqhom_(x,r)
  v:acm(r)              		       	           o:pu(r)         	    prod:z(r)
  v:aci(ne,r)           		       	           i:pa(ne,r)      	    prod:z(r)
  v:actr(r)             		       	           i:ptrn(r)       	    prod:z(r)
  v:ecir(e,r)           		       	           i:paf_g(e,r)    	    prod:z(r)
  v:ay(g,r)             		       	           o:pd(g,r)       	    prod:d(g,r)
  v:ai(g,ne,r)          		       	           i:pa(ne,r)      	    prod:d(g,r)
  v:ei(g,e,r)           		       	           i:pai_g(e,g,r)           prod:d(g,r)
  v:ei_v(g,e,v,r)$v_k(g,v,r)                   	           i:pai_g(e,g,r)  	    prod:dv(g,v,r)
  v:ai_v(g,ne,v,r)                                         i:pa(ne,r)               prod:dv(g,v,r)
  v:kv_v(g,v,r)$v_k(g,v,r)      	       	           i:pkv(g,v,r)    	    prod:dv(g,v,r)
  v:dv_v(g,v,r)$v_k(g,v,r)      	       	           o:pd(g,r)       	    prod:dv(g,v,r)  
  v:eci(e,r)                                   	           o:paf_g(e,r)    	    prod:efd_ghg(e,r)
  v:df(g,r)             		       	           i:pf(g,r)       	    prod:d(g,r)
  v:dk(g,r)             		       	           i:pk(r)         	    prod:d(g,r)
  v:nk(r)$n_e0(r)       		       	           i:pk(r)         	    prod:n_e(r)
  v:hk(r)$h_e0(r)       		       	           i:pk(r)         	    prod:h_e(r)
  v:dl(g,r)             		       	           i:pl(r)         	    prod:d(g,r)
  v:lv_v(g,v,r)$v_k(g,v,r)                     	           i:pl(r)         	    prod:dv(g,v,r)
  v:nl(r)$n_e0(r)                              	           i:pl(r)         	    prod:n_e(r)
  v:hl(r)$h_e0(r)       		       	           i:pl(r)         	    prod:h_e(r)
  v:realy(r)            		       	           d:pw(r)         	    demand:ra(r)
  v:tflowg(r,rr,mkt,g)$(gas(g)$gmap(rr,mkt))   	           i:png(mkt)      	    prod:m(g,r)
  v:eouti(e,g,r)$eind(e,g,r)                               o:pai_c(e,g,r)           prod:eid(e,g,r)
  v:eoutf(e,r)$efd(e,r)          		           o:paf_c(e,r)             prod:edf(e,r)
  v:eouthtr(e,r)$tefd(e,r)                                 o:paf_ch(e,r)            prod:tedf(e,r)
  v:ce_ghg(ghg,e,g,r)$(ghgk(r)$(not ss(g,r)))              i:pghg(ghg,r)            prod:eid_ghg(e,g,r)
  v:ce_ghg(ghg,e,g,r)$(sghgk(r)$ss(g,r))                   i:sghg(ghg,g,r) 	    prod:eid_ghg(e,g,r)
  v:cew_ghg(ghg,e,g,r)$(ghgkw(r)$wghgk)                    i:pghgw(ghg)    	    prod:eid_ghg(e,g,r)
  v:few_ghg(ghg,e,r)$(ghgkw(r)$wghgk)	                   i:pghgw(ghg)    	    prod:efd_ghg(e,r)
  v:vow_ghg(ghg,g,v,r)$((v_k(g,v,r)$ghgkw(r))$wghgk)       i:pghgw(ghg)    	    prod:dv(g,v,r)
  v:dow_ghg(ghg,g,r)$(ghgkw(r)$wghgk)                      i:pghgw(ghg)    	    prod:d(g,r)
  v:fdw_ghg(ghg,r)$(ghgkw(r)$wghgk)                        i:pghgw(ghg)    	    prod:z(r)
  v:fce_ghg(ghg,e,r)$(ghgk(r)$(not fdf(r)))                i:pghg(ghg,r)            prod:efd_ghg(e,r)
  v:fce_ghg(ghg,e,r)$(sghgk(r)$fdf(r))                     i:fghg(ghg,r)            prod:efd_ghg(e,r)
  v:vo_ghg(ghg,g,v,r)$((v_k(g,v,r)$(not ss(g,r)))$ghgk(r)) i:pghg(ghg,r)            prod:dv(g,v,r)
  v:vo_ghg(ghg,g,v,r)$((v_k(g,v,r)$ss(g,r))$sghgk(r))      i:sghg(ghg,g,r)          prod:dv(g,v,r)
  v:do_ghg(ghg,g,r)$((not ss(g,r))$ghgk(r))                i:pghg(ghg,r)            prod:d(g,r)
  v:do_ghg(ghg,g,r)$(ss(g,r)$sghgk(r))                     i:sghg(ghg,g,r)          prod:d(g,r)
  v:fd_ghg(ghg,r)$((not fdf(r))$ghgk(r))                   i:pghg(ghg,r)	    prod:z(r)
  v:fd_ghg(ghg,r)$(fdf(r)$sghgk(r))                        i:fghg(ghg,r)	    prod:z(r)
  v:do_urb(urb,g,r)$urblim(urb,r)                          i:purb(urb,r)	    prod:d(g,r)
  v:n_eout(r)                                              o:pd("elec",r)           prod:n_e(r)
  v:h_eout(r)                                              o:pd("elec",r)           prod:h_e(r)
  v:de(e,g,r)$(vintg(g,r))                                 i:pai_g(e,g,r)           prod:d(g,r)
  v:wela(r)		                                   w:ra(r)	        
  v:bbioilout(r)$active("bio-oil",r)                       o:pbo(r)                 prod:eb("bio-oil",r)
  v:bbiofgout(r)$active("bio-fg",r)                        o:pbo(r)                 prod:eb("bio-fg",r)
  v:bsolout(r)$active("solar",r)                           o:pd("elec",r)           prod:eb("solar",r)
  v:bsoilout(g,r)$active("synf-oil",r)                     o:phom(g,r)              prod:eb("synf-oil",r)
  v:bh2out(g,r)$active("h2",r)                             o:pd(g,r)                prod:eb("h2",r)
  v:bsgasout_a(g,r)$active("synf-gas",r)                   o:pd(g,r)                prod:eb("synf-gas",r)
  v:bsgasout_h(g,r)$active("synf-gas",r)                   o:phom(g,r)              prod:eb("synf-gas",r)
  v:bwout(r)$active("wind",r)                              o:pd("elec",r)           prod:eb("wind",r)
  v:bbioeleout(r)$active("bioelec",r)                      o:pd("elec",r)           prod:eb("bioelec",r)
  v:bwbioout(g,r)$active("windbio",r)                      o:pd(g,r)                prod:eb("windbio",r)
  v:bwgasout(g,r)$active("windgas",r)                      o:pd(g,r)                prod:eb("windgas",r)
  v:bngout(g,r)$active("ngcc",r)                           o:pd(g,r)                prod:eb("ngcc",r)
  v:bncsout(g,r)$active("ngcap",r)                         o:pd(g,r)                prod:eb("ngcap",r)
  v:bicsout(g,r)$active("igcap",r)                         o:pd(g,r)                prod:eb("igcap",r)
  v:bigout(g,r)$active("igcc",r)                           o:pd(g,r)                prod:eb("igcc",r) 
  v:sbout(sbt,g,r)$active(sbt,r)                           o:pd(g,r)                prod:eb(sbt,r)
  v:badvnucl_bout(g,r)$(active("adv-nucl",r))              o:pd(g,r)                prod:eb("adv-nucl",r)
  v:b_k(bt,r)$active(bt,r)                                 i:pk(r)                  prod:eb(bt,r)
  v:b_l(bt,r)$active(bt,r)                                 i:pl(r)                  prod:eb(bt,r)
  v:b_f(bt,r)$active(bt,r)                                 i:pf("crop",r)           prod:eb(bt,r)
  v:b_a(bt,g,r)$active(bt,r)                               i:pa(g,r)                prod:eb(bt,r)
  v:b_h(bt,g,r)$active(bt,r)                               i:phom(g,r)              prod:eb(bt,r)
  v:b_ff(bt,r)$active(bt,r)                                i:pbf(bt,r)              prod:eb(bt,r)
  v:b_pc(bt,r)$active(bt,r)$(co2c(r)$(not fdf(r)))         i:pcarb(r)               prod:eb(bt,r)
  v:b_ptc(bt,r)$active(bt,r)$(tco2c(r)$(not fdf(r)))       i:ptcarb                 prod:eb(bt,r)
  v:b_fc(bt,r)$active(bt,r)$(sco2c(r)$fdf(r))              i:fcarb(r)               prod:eb(bt,r)
  v:vbout(g,bt,v,r)$active(bt,r)$vintgbs(bt,r)             o:pd(g,r)                prod:ebv(bt,v,r)
  v:bv_ff(bt,v,r)$active(bt,r)$vintgbs(bt,r)               i:pbf(bt,r)              prod:ebv(bt,v,r)
  v:bv_l(bt,v,r)$active(bt,r)$vintgbs(bt,r)                i:pl(r)                  prod:ebv(bt,v,r)
  v:bv_k(bt,v,r)$active(bt,r)$vintgbs(bt,r)                i:pvbk(bt,v,r)           prod:ebv(bt,v,r)
  v:bv_a(bt,v,g,r)$active(bt,r)$vintgbs(bt,r)              i:pa(g,r)                prod:ebv(bt,v,r)
  v:bv_h(bt,v,g,r)$active(bt,r)$vintgbs(bt,r)              i:phom(g,r)              prod:ebv(bt,v,r)
  v:bv_pc(bt,v,r)$(active(bt,r)$(co2c(r)$(not fdf(r))))    i:pcarb(r)               prod:ebv(bt,v,r)
  v:bv_ptc(bt,v,r)$active(bt,r)$(tco2c(r)$(not fdf(r)))    i:ptcarb                 prod:ebv(bt,v,r)
  v:bv_fc(bt,v,r)$active(bt,r)$(sco2c(r)$fdf(r))           i:fcarb(r)               prod:ebv(bt,v,r)
  v:vrtran(r)					           i:paf_gh("roil",r)       prod:htrn(r)
  v:hcap(r)		                                   i:pk(r)		    prod:w(r)
  v:hlab(r)		                                   i:pl(r)		    prod:w(r)
  v:biodf(r)		 			           o:paf_c("roil",r)        prod:bio_f(r)
  v:biodi(g,r)		 			           o:pai_c("roil",g,r)      prod:bio_i(g,r)
  v:bioex(r)		                                   i:pbo(r)		    prod:biox(r)
  v:bioimf(r)		                                   o:paf_c("roil",r)        prod:biom_f(r)
  v:bioimi(g,r)		                                   o:pai_c("roil",g, r)     prod:biom_i(g,r)
  v:d_pghg(ghg,g,r)                                        i:pghg(ghg,r)            prod:d(g,r)
  v:d_pghgw(ghg,g,r)                                       i:pghgw(ghg)             prod:d(g,r)
  v:d_sghg(ghg,g,r)                                        i:sghg(ghg,g,r)          prod:d(g,r)
  v:d_purb(urb,g,r)                                        i:purb(urb,r)            prod:d(g,r)
  v:dv_pghg(ghg,g,v,r)                                     i:pghg(ghg,r)            prod:dv(g,v,r)
  v:dv_pghgw(ghg,g,v,r)                                    i:pghgw(ghg)             prod:dv(g,v,r)
  v:dv_sghg(ghg,g,v,r)                                     i:sghg(ghg,g,r)          prod:dv(g,v,r)
  v:dv_purb(urb,g,v,r)                                     i:purb(urb,r)            prod:dv(g,v,r)
  v:eid_ghg_pghg(ghg,e,g,r)                                i:pghg(ghg,r)            prod:eid_ghg(e,g,r)
  v:eid_ghg_pghgw(ghg,e,g,r)                               i:pghgw(ghg)             prod:eid_ghg(e,g,r)
  v:eid_ghg_sghg(ghg,e,g,r)                                i:sghg(ghg,g,r)          prod:eid_ghg(e,g,r)
  v:efd_ghg_pghg(ghg,e,r)                                  i:pghg(ghg,r)            prod:efd_ghg(e,r)
  v:efd_ghg_pghgw(ghg,e,r)                                 i:pghgw(ghg)             prod:efd_ghg(e,r)
  v:efd_ghg_fghg(ghg,e,r)                                  i:fghg(ghg,r)            prod:efd_ghg(e,r)
  v:tefd_ghg_pghg(ghg,e,r)                                 i:pghg(ghg,r)            prod:tefd_ghg(e,r)
  v:tefd_ghg_pghgw(ghg,e,r)                                i:pghgw(ghg)             prod:tefd_ghg(e,r)
  v:tefd_ghg_fghg(ghg,e,r)                                 i:fghg(ghg,r)            prod:tefd_ghg(e,r)
  v:z_pghg(ghg,r)                                          i:pghg(ghg,r)            prod:z(r)
  v:z_pghgw(ghg,r)                                         i:pghgw(ghg)             prod:z(r)
  v:z_fghg(ghg,r)                                          i:fghg(ghg,r)            prod:z(r)
  v:z_purb(urb,r)                                          i:purb(urb,r)            prod:z(r)
  v:eb_purb(urb,bt,r)                                      i:purb(urb,r)            prod:eb(bt,r)
  v:d_pcarb(g,r)$(eint(g) or agri(g))                      i:pcarb(r)               prod:d(g,r)
  v:d_scarb(g,r)$(eint(g) or agri(g))                      i:scarb(g,r)             prod:d(g,r)
  v:d_ptcarb(g,r)$(eint(g) or agri(g))                     i:ptcarb                 prod:d(g,r)
  v:dv_pcarb(g,v,r)$(eint(g) or agri(g))                   i:pcarb(r)               prod:dv(g,v,r)
  v:dv_scarb(g,v,r)$(eint(g) or agri(g))                   i:scarb(g,r)             prod:dv(g,v,r)
  v:dv_ptcarb(g,v,r)$(eint(g) or agri(g))                  i:ptcarb                 prod:dv(g,v,r)
  v:eoutb(e,bt,r)                                          i:pa(e,r)                prod:eb(bt,r)
  v:eoutbv(e,bt,v,r)                                       i:pa(e,r)                prod:ebv(bt,v,r)

  v:df_n(r)						   i:pr(r)		    prod:n_e(r)
  v:df_h(r)						   i:pr_h(r)		    prod:h_e(r)

$peps:

* domestic production index
* note the negation of aenoe.  set aenoe = {crop live fors coal oil roil gas elec eint}
* so this block is for {food othr serv tran dwe}
$prod:d(g,r)$xp0(r,g)$(not aenoe(g))  s:sigu(g,r)               hfc:sigg("hfc",g,r) pfc(hfc):sigg("pfc",g,r) ch4(pfc):sigg("ch4",g,r)  n2o(ch4):sigg("n2o",g,r)
+	                              sf6(pfc):sigg("sf6",g,r)  b(ch4):esup(g,r)    a(b):pnesta(g,r)   ee(a):selas(g,"e_kl",r)   va(ee):selas(g,"l_k",r)  en(ee):selas(g,"noe_el",r)  
+                                     en1(en):esube(g,r)        oil(en1):0          gas(en1):0         coal(en1):0               roil(en1):0

    o:pd(g,r)$(not x(g))                                    q:xp0(r,g)                                                   a:ra(r) t:td(r,g)        									
    o:phom(g,r)$x(g)                                        q:xp0(r,g)                           	                 a:ra(r) t:td(r,g)	       		 					
    i:pa(ne,r)                                              q:((xdp0(r,ne,g)+xmp0(r,ne,g))*sa(r,ne,g))                   p:pi0(ne,g,r)    a:ra(r) t:ti(ne,g,r)           a:	 					
    i:pl(r)                                                 q:labd(r,g)                          	                 p:pf0("lab",g,r) a:ra(r) t:tf("lab",g,r)        va: 					
    i:pk(r)                                                 q:kapd(r,g)                          	                 p:pf0("cap",g,r) a:ra(r) t:tf("cap",g,r)        va: 					
    i:pai_g(enoe,g,r)                       		    q:((xdp0(r,enoe,g)+xmp0(r,enoe,g))*aeei(r,g)*sa(r,enoe,g))   p:pi0(enoe,g,r)  a:ra(r) t:ti(enoe,g,r)         enoe.tl:
    i:purb(urb,r)#(enoe)$urblim(urb,r)			    q:curb_(urb,enoe,g,r)                                        p:(1/gu(urb))   	                         enoe.tl:
    i:pai_g(elec,g,r)                                       q:((xdp0(r,elec,g)+xmp0(r,elec,g))*aeei(r,g)*sa(r,elec,g))   p:pi0(elec,g,r)  a:ra(r) t:ti(elec,g,r)         en:         
    i:pf(g,r)                                               q:ffactd(r,g)                                                                                   b:
    i:pghg(ghg,r)$((not ss(g,r))$ghglim(ghg,r)$(not wghgk)) q:oghg_(ghg,g,r)	                                         p:(1/gu(ghg))                                   ghg.tl:$oghg_(ghg,g,r)									     									   
    i:pghgw(ghg)$(ghglim(ghg,r)$wghgk)                      q:oghg_(ghg,g,r)	             	       	                 p:(1/gu(ghg))                                   ghg.tl:$oghg_(ghg,g,r) 							      							   
    i:sghg(ghg,g,r)$(ghglimg(ghg,g,r)$oghg_(ghg,g,r))       q:oghg_(ghg,g,r)	             	       	                 p:(1/gu(ghg))                                   ghg.tl:$oghg_(ghg,g,r) 							      							   
    i:purb(urb,r)$urblim(urb,r)	                            q:ourb_(urb,g,r)	             	       	                 p:(1/gu(urb))                                                          							      							      

* set eint = {eint}
$prod:d(g,r)$xp0(r,g)$eint(g) s:sigu(g,r)              ch4:sigg("ch4",g,r)  n2o(ch4):sigg("n2o",g,r)  pfc(n2o):sigg("pfc",g,r)
+	                      sf6(pfc):sigg("sf6",g,r) b(sf6):esup(g,r)     a(b):pnesta(g,r)          ee(a):selas(g,"e_kl",r)   va(ee):selas(g,"l_k",r)  en(ee):selas(g,"noe_el",r)
+                             en1(en):esube(g,r)       oil(en1):0           gas(en1):0                coal(en1):0               roil(en1):0  

    o:pd(g,r)$(not x(g))                                    q:xp0(r,g)                                                            a:ra(r) t:td(r,g)            	  							
    o:phom(g,r)$x(g)                                        q:xp0(r,g)                           	                          a:ra(r) t:td(r,g)	     	   					
    i:pa(ne,r)                                              q:(xdp0(r,ne,g)+xmp0(r,ne,g))        	       p:pi0(ne,g,r)      a:ra(r) t:ti(ne,g,r)         a:	 					
    i:pl(r)              				    q:labd(r,g)                          	       p:pf0("lab",g,r)   a:ra(r) t:tf("lab",g,r)      va: 					
    i:pk(r)              				    q:kapd(r,g)                          	       p:pf0("cap",g,r)   a:ra(r) t:tf("cap",g,r)      va: 					
    i:pai_g(enoe,g,r)                       		    q:((xdp0(r,enoe,g)+xmp0(r,enoe,g))*aeei(r,g))      p:pi0(enoe,g,r)	  a:ra(r) t:ti(enoe,g,r)       enoe.tl:
    i:purb(urb,r)#(enoe)$urblim(urb,r)			    q:curb_(urb,enoe,g,r)                              p:(1/gu(urb))   	                               enoe.tl:
    i:pai_g(elec,g,r)                                       q:((xdp0(r,elec,g)+xmp0(r,elec,g))*aeei(r,g))      p:pi0(elec,g,r)	  a:ra(r) t:ti(elec,g,r)       en:         
    i:pf(g,r)            			   	    q:ffactd(r,g)                                                                                      b:
    i:pcarb(r)$(cflag(r)$co2c(r)$(not ss(g,r)))             q:outco2(r,g)
    i:scarb(g,r)$(cflag(r)$sco2c(r)$ss(g,r))                q:outco2(r,g)
    i:ptcarb$(cflag(r)$tco2c(r)$(not ss(g,r)))              q:outco2(r,g)
    i:pghg(ghg,r)$((not ss(g,r))$ghglim(ghg,r)$(not wghgk)) q:oghg_(ghg,g,r)	                               p:(1/gu(ghg))                                   ghg.tl:$oghg_(ghg,g,r)									     									   
    i:pghgw(ghg)$(ghglim(ghg,r)$wghgk)                      q:oghg_(ghg,g,r)	             	       	       p:(1/gu(ghg))                                   ghg.tl:$oghg_(ghg,g,r) 							      							   
    i:sghg(ghg,g,r)$(ghglimg(ghg,g,r)$oghg_(ghg,g,r))	    q:oghg_(ghg,g,r)	             	       	       p:(1/gu(ghg))                                   ghg.tl:$oghg_(ghg,g,r) 							      							   
    i:purb(urb,r)$urblim(urb,r)	                            q:ourb_(urb,g,r)	             	       	       p:(1/gu(urb))                                                          							      							    

* set agri = {crop live fors}
$prod:d(g,r)$xp0(r,g)$agri(g)  s:sigu(g,r)                ch4:sigg("ch4",g,r)  a(ch4):pnesta(g,r) va(a):selas(g,"l_k",r) n2o(a):sigg("n2o",g,r) fx(n2o):esup(g,r)  e(fx):selas(g,"e_kl",r) ne(e):0
+                              en(e):selas(g,"noe_el",r)  en1(en):esube(g,r)   oil(en1):0         gas(en1):0             coal(en1):0            roil(en1):0 

    o:pd(g,r)$(not x(g))                                    q:xp0(r,g)                                                            a:ra(r) t:td(r,g)            	  							
    o:phom(g,r)$x(g)                                        q:xp0(r,g)                           	                          a:ra(r) t:td(r,g)	     	   					
    i:pa(ne,r)                                              q:(xdp0(r,ne,g)+xmp0(r,ne,g))        	       p:pi0(ne,g,r)      a:ra(r) t:ti(ne,g,r)         ne: 					
    i:pl(r)                                                 q:labd(r,g)                          	       p:pf0("lab",g,r)   a:ra(r) t:tf("lab",g,r)      va: 					
    i:pk(r)                                                 q:kapd(r,g)                          	       p:pf0("cap",g,r)   a:ra(r) t:tf("cap",g,r)      va: 					
    i:pai_g(enoe,g,r)                       		    q:((xdp0(r,enoe,g)+xmp0(r,enoe,g))*aeei(r,g))      p:pi0(enoe,g,r)	  a:ra(r) t:ti(enoe,g,r)       enoe.tl:
    i:purb(urb,r)#(enoe)$urblim(urb,r)			    q:curb_(urb,enoe,g,r)                              p:(1/gu(urb))   	                               enoe.tl:
    i:pai_g(elec,g,r)                                       q:((xdp0(r,elec,g)+xmp0(r,elec,g))*aeei(r,g))      p:pi0(elec,g,r)	  a:ra(r) t:ti(elec,g,r)       en:                 
    i:pf(g,r)                                               q:ffactd(r,g)                                                                                      fx:
    i:pcarb(r)$(cflag(r)$co2c(r)$(not ss(g,r)))             q:outco2(r,g)												   
    i:scarb(g,r)$(cflag(r)$sco2c(r)$ss(g,r))                q:outco2(r,g)												   
    i:ptcarb$(tco2c(r)$(cflag(r)$(not ss(g,r))))            q:outco2(r,g)												   
    i:pghg(ghg,r)$((not ss(g,r))$ghglim(ghg,r)$(not wghgk)) q:oghg_(ghg,g,r)	                               p:(1/gu(ghg))		                       ghg.tl:$oghg_(ghg,g,r)									   
    i:pghgw(ghg)$(ghglim(ghg,r)$wghgk)                      q:oghg_(ghg,g,r)	             	       	       p:(1/gu(ghg))                                   ghg.tl:$oghg_(ghg,g,r) 							   
    i:sghg(ghg,g,r)$(ghglimg(ghg,g,r)$oghg_(ghg,g,r))	    q:oghg_(ghg,g,r)	             	       	       p:(1/gu(ghg))                                   ghg.tl:$oghg_(ghg,g,r) 							   
    i:purb(urb,r)$urblim(urb,r)	                            q:ourb_(urb,g,r)	             	       	       p:(1/gu(urb))     	                                                      							    									   
																						   
* set elec = {elec}																				   
$prod:d(g,r)$xp0(r,g)$elec(g)  s:enesta(g,r)  sc(s):sigg("sf6",g,r) uc(sc):sigu(g,r) bc(uc):0.6 ac(bc):pnesta(g,r)  eec(ac):selas(g,"e_kl",r)   vac(eec):selas(g,"l_k",r)							   
+                                             sg(s):sigg("sf6",g,r) ug(sg):sigu(g,r) bg(ug):0.6 ag(bg):pnesta(g,r)  eeg(ag):selas(g,"e_kl",r)   vag(eeg):selas(g,"l_k",r)
+                                             so(s):sigg("sf6",g,r) uo(so):sigu(g,r) bo(uo):0.6 ao(bo):pnesta(g,r)  eeo(ao):selas(g,"e_kl",r)   vao(eeo):selas(g,"l_k",r)

																						   
    o:pd(g,r)$(not x(g))                                    q:xp0(r,g)                                         a:ra(r) t:td(r,g)	      
    o:phom(g,r)$x(g)                                        q:xp0(r,g)                                         a:ra(r) t:td(r,g)	              
    													     
    i:pa(ne,r)                                              q:((xdp0(r,ne,g)+xmp0(r,ne,g))*fps(r,"coal")*emkup("coal",r))    p:pi0(ne,g,r)      a:ra(r) t:ti(ne,g,r)      ac:
    i:pl(r)                                                 q:(labd(r,g)*fps(r,"coal")*emkup("coal",r))                      p:pf0("lab",g,r)   a:ra(r) t:tf("lab",g,r)   vac:
    i:pk(r)                                                 q:(kapd(r,g)*fps(r,"coal")*emkup("coal",r))                      p:pf0("cap",g,r)   a:ra(r) t:tf("cap",g,r)   vac:
    i:pai_g("coal",g,r)                                     q:((xdp0(r,"coal",g)+xmp0(r,"coal",g))*aeei(r,g))                p:pi0("coal",g,r)  a:ra(r) t:ti("coal",g,r)  eec:
    i:pf(g,r)                                               q:(ffactd(r,g)*fps(r,"coal")*emkup("coal",r))                                                                 bc:
    i:pghg(ghg,r)$((not ss(g,r))$ghglim(ghg,r)$(not wghgk)) q:(oghg_(ghg,g,r)*fps(r,"coal")*emkup("coal",r))	             p:(1/gu(ghg))			          sc:		     
    i:pghgw(ghg)$(ghglim(ghg,r)$wghgk)                      q:(oghg_(ghg,g,r)*fps(r,"coal")*emkup("coal",r))	             p:(1/gu(ghg))			          sc:		     
    i:sghg(ghg,g,r)$(ghglimg(ghg,g,r)$oghg_(ghg,g,r))	    q:(oghg_(ghg,g,r)*fps(r,"coal")*emkup("coal",r))	             p:(1/gu(ghg))			          sc:		     
    i:purb(urb,r)$urblim(urb,r)	                            q:(ourb_(urb,g,r)*fps(r,"coal")*emkup("coal",r))	             p:(1/gu(urb))                                uc:
    i:pren(r)$srenc(r)	                                    q:((phi(r)*xp0(r,g))*fps(r,"coal")*emkup("coal",r))                                                           sc:
    							
    i:pa(ne,r)                                              q:((xdp0(r,ne,g)+xmp0(r,ne,g))*fps(r,"gas")*emkup("gas",r))      p:pi0(ne,g,r)      a:ra(r) t:ti(ne,g,r)      ag:
    i:pl(r)                                                 q:(labd(r,g)*fps(r,"gas")*emkup("gas",r))                        p:pf0("lab",g,r)   a:ra(r) t:tf("lab",g,r)   vag:
    i:pk(r)                                                 q:(kapd(r,g)*fps(r,"gas")*emkup("gas",r))                        p:pf0("cap",g,r)   a:ra(r) t:tf("cap",g,r)   vag:
    i:pai_g("gas",g,r)                                      q:((xdp0(r,"gas",g)+xmp0(r,"gas",g))*aeei(r,g))                  p:pi0("gas",g,r)   a:ra(r) t:ti("gas",g,r)   eeg:
    i:pf(g,r)                                               q:(ffactd(r,g)*fps(r,"gas")*emkup("gas",r))                                                                   bg:
    i:pghg(ghg,r)$((not ss(g,r))$ghglim(ghg,r)$(not wghgk)) q:(oghg_(ghg,g,r)*fps(r,"gas")*emkup("gas",r))	             p:(1/gu(ghg))			          sg:		     
    i:pghgw(ghg)$(ghglim(ghg,r)$wghgk)                      q:(oghg_(ghg,g,r)*fps(r,"gas")*emkup("gas",r))	             p:(1/gu(ghg))			          sg:		     
    i:sghg(ghg,g,r)$(ghglimg(ghg,g,r)$oghg_(ghg,g,r))	    q:(oghg_(ghg,g,r)*fps(r,"gas")*emkup("gas",r))	             p:(1/gu(ghg))			          sg:		     
    i:purb(urb,r)$urblim(urb,r)	                            q:(ourb_(urb,g,r)*fps(r,"gas")*emkup("gas",r))	             p:(1/gu(urb))                                ug:
    i:pren(r)$srenc(r)	                                    q:((phi(r)*xp0(r,g))*fps(r,"gas")*emkup("gas",r))                                                             sg:
    							
    i:pa(ne,r)                                              q:((xdp0(r,ne,g)+xmp0(r,ne,g))*fps(r,"roil")*emkup("roil",r))    p:pi0(ne,g,r)      a:ra(r) t:ti(ne,g,r)      ao:
    i:pl(r)                                                 q:(labd(r,g)*fps(r,"roil")*emkup("roil",r))                      p:pf0("lab",g,r)   a:ra(r) t:tf("lab",g,r)   vao:
    i:pk(r)                                                 q:(kapd(r,g)*fps(r,"roil")*emkup("roil",r))                      p:pf0("cap",g,r)   a:ra(r) t:tf("cap",g,r)   vao:
    i:pai_g("roil",g,r)                                     q:((xdp0(r,"roil",g)+xmp0(r,"roil",g))*aeei(r,g))                p:pi0("roil",g,r)  a:ra(r) t:ti("roil",g,r)  eeo:
    i:pf(g,r)                                               q:(ffactd(r,g)*fps(r,"roil")*emkup("roil",r))                                                                 bo:
    i:pghg(ghg,r)$((not ss(g,r))$ghglim(ghg,r)$(not wghgk)) q:(oghg_(ghg,g,r)*fps(r,"roil")*emkup("roil",r))	             p:(1/gu(ghg))			          so:		     
    i:pghgw(ghg)$(ghglim(ghg,r)$wghgk)                      q:(oghg_(ghg,g,r)*fps(r,"roil")*emkup("roil",r))	             p:(1/gu(ghg))			          so:		     
    i:sghg(ghg,g,r)$(ghglimg(ghg,g,r)$oghg_(ghg,g,r))	    q:(oghg_(ghg,g,r)*fps(r,"roil")*emkup("roil",r))	             p:(1/gu(ghg))			          so:		     
    i:purb(urb,r)$urblim(urb,r)	                            q:(ourb_(urb,g,r)*fps(r,"roil")*emkup("roil",r))	             p:(1/gu(urb))                                uo:
    i:pren(r)$srenc(r)	                                    q:((phi(r)*xp0(r,g))*fps(r,"roil")*emkup("roil",r))                                                           so:
								  
* set enoe = {coal oil roil gas}
$prod:d(g,r)$xp0(r,g)$enoe(g)  s:sigu(g,r)        b(s):esup(g,r)  a(b):pnesta(g,r)  n2o(a):sigg("n2o",g,r) va(a):selas(g, "l_k",r) ch4(a):sigg("ch4",g,r)  en(a):selas(g,"noe_el",r)
+                              en1(en):esube(g,r) oil(en1):0    gas(en1):0        coal(en1):0            roil(en1):0 
    o:pd(g,r)$(not x(g))                                    q:xp0(r,g)                                                                       a:ra(r) t:td(r,g)             						    
    o:phom(g,r)$x(g)                                        q:xp0(r,g)                           		                             a:ra(r) t:td(r,g)	     	    				    
    i:pa(ne,r)                                              q:((xdp0(r,ne,g)+xmp0(r,ne,g))*mkup(g,r))        	        p:pi0(ne,g,r)        a:ra(r) t:ti(ne,g,r)         a: 				    
    i:pl(r)                                                 q:(labd(r,g)*mkup(g,r))                          		p:pf0("lab",g,r)     a:ra(r) t:tf("lab",g,r)      va:				    
    i:pk(r)                                                 q:(kapd(r,g)*mkup(g,r))                          		p:pf0("cap",g,r)     a:ra(r) t:tf("cap",g,r)      va:				    
    i:pai_g(enoe,g,r)                       		    q:((xdp0(r,enoe,g)+xmp0(r,enoe,g))*aeei(r,g)*mkup(g,r))     p:pi0(enoe,g,r)	     a:ra(r) t:ti(enoe,g,r)       enoe.tl:
    i:purb(urb,r)#(enoe)$urblim(urb,r)			    q:(curb_(urb,enoe,g,r)*mkup(g,r))                           p:(1/gu(urb))   	                          enoe.tl:
    i:pai_g(elec,g,r)                                       q:((xdp0(r,elec,g)+xmp0(r,elec,g))*aeei(r,g)*mkup(g,r))     p:pi0(elec,g,r)	     a:ra(r) t:ti(elec,g,r)       en:         
    i:pf(g,r)                                               q:(ffactd(r,g)*mkup(g,r))               					                                  b:
    i:pghg(ghg,r)$((not ss(g,r))$ghglim(ghg,r)$(not wghgk)) q:(oghg_(ghg,g,r)*mkup(g,r))	                        p:(1/gu(ghg))	                                  ghg.tl:$oghg_(ghg,g,r)   									   
    i:pghgw(ghg)$(ghglim(ghg,r)$wghgk)                      q:(oghg_(ghg,g,r)*mkup(g,r))		     		p:(1/gu(ghg))   		     		  ghg.tl:$oghg_(ghg,g,r)						   
    i:sghg(ghg,g,r)$(ghglimg(ghg,g,r)$oghg_(ghg,g,r))	    q:(oghg_(ghg,g,r)*mkup(g,r))		     		p:(1/gu(ghg))   		      		  ghg.tl:$oghg_(ghg,g,r)						   
    i:purb(urb,r)$urblim(urb,r)		                    q:(ourb_(urb,g,r)*mkup(g,r))		     		p:(1/gu(urb))                                                       						                        

* nuclear electric generation
$prod:n_e(r)$n_e0(r)  s:sigma(r)  a:pnesta("nucl",r)  kl(a):selas("elec","l_k",r)
    o:pd("elec",r)		                            q:n_e0(r)	                                                   a:ra(r) t:td(r,"elec")                       
    i:pl(r)						    q:n_l0(r)                               p:pf0("lab","elec",r)  a:ra(r) t:tf("lab","elec",r)         kl:     									     
    i:pk(r)						    q:n_k0(r)       			    p:pf0("cap","elec",r)  a:ra(r) t:tf("cap","elec",r)         kl: 				     
    i:pr(r)			                            q:n_r0(r)       			    p:pf0("cap","elec",r)  a:ra(r) t:tf("cap","elec",r)	     	 				     
    i:pa("serv",r)					    q:n_s0(r)	    			    p:pi0("serv","elec",r) a:ra(r) t:ti("serv","elec",r)        a:  				     
    i:pa("othr",r)					    q:n_ot0(r)	    			    p:pi0("othr","elec",r) a:ra(r) t:ti("othr","elec",r)        a:  				     
																			     
* hydro electric generation																     
$prod:h_e(r)$h_e0(r)  s:hsigma(r)  a:pnesta("hydr",r) kl(a):selas("elec","l_k",r)									     
    o:pd("elec",r)		                            q:h_e0(r)	                                                    a:ra(r) t:td(r,"elec")			     
    i:pl(r)						    q:h_l0(r)                               p:pf0("lab","elec",r)   a:ra(r) t:tf("lab","elec",r)        kl: 									 
    i:pk(r)						    q:h_k0(r)   			    p:pf0("cap","elec",r)   a:ra(r) t:tf("cap","elec",r)	kl:     						 
    i:pr_h(r)		                                    q:h_r0(r)           		    p:pf0("cap","elec",r)   a:ra(r) t:tf("cap","elec",r)		     						 
    i:pa("serv",r)					    q:h_s0(r)   			    p:pi0("serv","elec",r)  a:ra(r) t:ti("serv","elec",r) 	a:	     						 
    i:pa("othr",r)					    q:h_ot0(r)  			    p:pi0("othr","elec",r)  a:ra(r) t:ti("othr","elec",r)  	a:      						 

* aggregated government consumption:
$prod:govt(r)             s:esubg
    o:pg(r)                                                 q:g0(r)
    i:pa(ne,r)        					    q:(xdg0(r,ne)+xmg0(r,ne))            p:pg0(ne,r)        a:ra(r) t:tg(ne,r)

* investment index
* based on eppa5, ne = {crop, live, fors, food, eint, othr, serv, tran, cgd}
* based on eppa4, ne = {agri,                   eint, othr, serv, tran, cgd}
* but both have xmi0(r,i) = 0, and xdi0(r,i) <> 0 only if i = "cgd" => xdi0 is total investment in r
* in eppa6, both xdi0(r,i) and xmi0(r,i) are sectoral investments and they may have values

$prod:inv(r)              s:5
    o:pinv(r)                                                   q:inv0(r)
    i:pa(g,r)$(not x(g))    					q:(xdi0(r,g)+xmi0(r,g))
    i:phom(g,r)$(x(g))      					q:(xdi0(r,g)+xmi0(r,g))

* international transport
$prod:yt s:1
    o:pt		                                        q:(sum((g,r), vst(g,r)))
    i:pd(g,r)	                                                q:vst(g,r)

* household transport (including both purchased plus own-supplied transportation)
* pa("tran",r) represents "purchased transport"
$prod:htrn(r)  s:tnests(r)   a:tnesta(r)   b(a):1.0
    o:ptrn(r)			                                q:tottrn(r)
    i:paf_gh("roil",r)						q:tro(r)	                     p:pc0("roil",r)  a:ra(r)    t:tp("roil",r)    a:
    i:pa("othr",r)						q:toi(r)	                     p:pc0_("othr",r) a:ra(r)    t:tp_("othr",r)   b:
    i:pa("serv",r)						q:tse(r)	                     p:pc0("serv",r)  a:ra(r)    t:tp("serv",r)    b:
    i:pa("tran",r)			                        q:purtrn(r)	                     p:pc0("tran",r)  a:ra(r)    t:tp("tran",r)

* conventional intermediate energy demand
$prod:eid(e,g,r)$(eind(e,g,r)$(not x(e)))  s:0
    o:pai_c(e,g,r)                                              q:eusep(e,g,r)
    i:pa(e,r)                          				q:eusep(e,g,r)                                        a:ra(r) t:co2tax(e,r)
    i:pcarb(r)$(co2c(r)$(not ss(g,r)))                          q:(eind(e,g,r)*cj(e,r)*epslon(e))
    i:ptcarb$(tco2c(r)$(not ss(g,r)))  				q:(eind(e,g,r)*cj(e,r)*epslon(e))
    i:scarb(g,r)$(sco2c(r)$ss(g,r))    				q:(eind(e,g,r)*cj(e,r)*epslon(e))

$prod:eid(e,g,r)$(eind(e,g,r)$x(e))  s:0
    o:pai_c(e,g,r)                                              q:eusep(e,g,r)
    i:phom(e,r)                        				q:eusep(e,g,r)                                        a:ra(r) t:co2tax(e,r)
    i:pcarb(r)$(co2c(r)$(not ss(g,r)))                          q:(eind(e,g,r)*cj(e,r)*epslon(e))
    i:ptcarb$(tco2c(r)$(not ss(g,r)))  				q:(eind(e,g,r)*cj(e,r)*epslon(e))
    i:scarb(g,r)$(sco2c(r)$ss(g,r))    				q:(eind(e,g,r)*cj(e,r)*epslon(e))

* conventional final energy demand
$prod:edf(e,r)$(efd(e,r)$(not x(e)))  s:0
    o:paf_c(e,r)                                                q:heusef(e,r)
    i:pa(e,r)                         				q:heusef(e,r)                                         a:ra(r) t:co2tax(e,r)
    i:pcarb(r)$(co2c(r)$(not fdf(r)))                           q:(hefd(e,r)*cj(e,r)*epslon(e))
    i:ptcarb$(tco2c(r)$(not fdf(r)))  				q:(hefd(e,r)*cj(e,r)*epslon(e))
    i:fcarb(r)$(sco2c(r)$fdf(r))      				q:(hefd(e,r)*cj(e,r)*epslon(e))

$prod:edf(e,r)$(efd(e,r)$x(e))  s:0
    o:paf_c(e,r)                                                q:heusef(e,r)
    i:phom(e,r)                       				q:heusef(e,r)                                         a:ra(r) t:co2tax(e,r)
    i:pcarb(r)$(co2c(r)$(not fdf(r)))                           q:(hefd(e,r)*cj(e,r)*epslon(e))
    i:ptcarb$(tco2c(r)$(not fdf(r)))  				q:(hefd(e,r)*cj(e,r)*epslon(e))
    i:fcarb(r)$(sco2c(r)$fdf(r))      				q:(hefd(e,r)*cj(e,r)*epslon(e))

* conventional final energy demand -- hh transport
$prod:tedf(e,r)$(teusef(e,r)$(not x(e)))  s:0
    o:paf_ch(e,r)                                               q:teusef(e,r)
    i:pa(e,r)                                 			q:teusef(e,r)                                         a:ra(r) t:co2tax(e,r)
    i:pcarb(r)$(ftrn(r)$co2c(r)$(not fdf(r)))                   q:(tefd(e,r)*cj(e,r)*epslon(e))
    i:ptcarb$(ftrn(r)$tco2c(r)$(not fdf(r)))  			q:(tefd(e,r)*cj(e,r)*epslon(e))
    i:fcarb(r)$(ftrn(r)$sco2c(r)$fdf(r))      			q:(tefd(e,r)*cj(e,r)*epslon(e))

$prod:tedf(e,r)$(teusef(e,r)$x(e))  s:0
    o:paf_ch(e,r)                                               q:teusef(e,r)
    i:phom(e,r)                               			q:teusef(e,r)                                         a:ra(r) t:co2tax(e,r)
    i:pcarb(r)$(ftrn(r)$co2c(r)$(not fdf(r)))                   q:(tefd(e,r)*cj(e,r)*epslon(e))
    i:ptcarb$(ftrn(r)$tco2c(r)$(not fdf(r)))  			q:(tefd(e,r)*cj(e,r)*epslon(e))
    i:fcarb(r)$(ftrn(r)$sco2c(r)$fdf(r))      			q:(tefd(e,r)*cj(e,r)*epslon(e))

* energy demand inclusive of ghg -- intermediate
$prod:eid_ghg(e,g,r)$eind(e,g,r)
    o:pai_g(e,g,r)		                                q:eusep(e,g,r)                                        a:ra(r) n:tlimc(e,g,r)$eid_ghg_up(e,g,r)                                                                           
    i:pai_c(e,g,r)		                                q:eusep(e,g,r)
    i:pghg(ghg,r)$((not ss(g,r))$ghglim(ghg,r)$(not wghgk))     q:cghg_(ghg,e,g,r)
    i:pghgw(ghg)$(ghglim(ghg,r)$wghgk$(not ss(g,r)))            q:cghg_(ghg,e,g,r)
    i:sghg(ghg,g,r)$(ghglimg(ghg,g,r)$cghg_(ghg,e,g,r))         q:cghg_(ghg,e,g,r)

* energy demand inclusive of ghg -- final
$prod:efd_ghg(e,r)$efd(e,r)
    o:paf_g(e,r)		                                q:heusef(e,r)
    i:paf_c(e,r)		                                q:heusef(e,r)
    i:pghg(ghg,r)$((not fdf(r))$ghglim(ghg,r)$(not wghgk))      q:hcghg_(ghg,e,"fd",r)
    i:pghgw(ghg)$(ghglim(ghg,r)$wghgk$(not fdf(r)))             q:hcghg_(ghg,e,"fd",r)
    i:fghg(ghg,r)$(ghglimg(ghg,"fd",r)$hcghg_(ghg,e,"fd",r))    q:hcghg_(ghg,e,"fd",r)

* energy demand inclusive of ghg -- hh transport
$prod:tefd_ghg(e,r)$teusef(e,r)     s:0
    o:paf_gh(e,r)		                                     q:teusef(e,r)
    i:paf_ch(e,r)		                                     q:teusef(e,r)
    i:pcafe(r)$active("cafe",r)                                      q:(teusef(e,r)*cshr(r))
    i:pghg(ghg,r)$(ftrn(r)$(not fdf(r))$ghglim(ghg,r)$(not wghgk))   q:tcghg_(ghg,e,"fd",r)
    i:pghgw(ghg)$(ftrn(r)$ghglim(ghg,r)$wghgk)                       q:tcghg_(ghg,e,"fd",r)
    i:fghg(ghg,r)$(ftrn(r)$ghglimg(ghg,"fd",r)$tcghg_(ghg,e,"fd",r)) q:tcghg_(ghg,e,"fd",r)

* regional gas market
$prod:ngm(mkt,r)$(gmap(r,mkt)$gmarket)
    o:png(mkt)	                                                     q:1
    i:pd("gas",r)	                                             q:1

* Armington index
$prod:a(g,r)$((not x(g))$a0(r,g))  s:selas(g,"sdm",r)  s1(s):3
    o:pa(g,r)                                                       q:a0(r,g)
    i:pd(g,r)$((not gas(g))$gmarket)                                q:d0(r,g)
    i:png(mkt)$(gmap(r,mkt)$gas(g)$gmarket)                         q:d0(r,g)
    i:pd(g,r)$(not gmarket)                                         q:d0(r,g)                                 s1:
    i:pm(g,r)                                                       q:xm0(r,g)
*   i:p_e(r)$(elec(g)$(active("wind",r)) or active("solar",r) or active("bioelec",r))  q:(rsize(r)*a0(r,g))   s1:

* imports gross of tariffs and transport cost: note: wtflow0(r,s,i) = vxmd(i,s,r) = bilateral exports at market prices
* pt itself doesn't have a rr dimension, but for every rr there will be a pt generated.
$prod:m(g,r)$(xm0(r,g)$(not x(g))) s:selas(g,"smm",r)  rr.tl:0
    o:pm(g,r)                                                       q:xm0(r,g)
    i:png(mkt)#(rr)$(gmap(rr,mkt)$gas(g)$gmarket)  		    q:wtflow0(r,rr,g)                p:pmx0(g,rr,r) a:ra(rr) t:tx(g,rr,r)  a:ra(r) t:(tm(g,rr,r)*(1+tx(g,rr,r))) rr.tl:
    i:pd_(g,rr)$((not gas(g))$gmarket)             		    q:wtflow0(r,rr,g)  	             p:pmx0(g,rr,r) a:ra(rr) t:tx(g,rr,r)  a:ra(r) t:(tm(g,rr,r)*(1+tx(g,rr,r))) rr.tl:
    i:pd_(g,rr)$(not gmarket)                      		    q:wtflow0(r,rr,g)  	             p:pmx0(g,rr,r) a:ra(rr) t:tx(g,rr,r)  a:ra(r) t:(tm(g,rr,r)*(1+tx(g,rr,r))) rr.tl:
    i:pt#(rr)                                      		    q:(sum(j,vtwr(j,g,rr,r)))        p:pmt0(g,rr,r) a:ra(r)  t:tm(g,rr,r)                                        rr.tl:


* net imports of homogenous goods
* vhomm0(x,r) = (homm0(x,r)+homt0(x,r))*(1+tmhom(x,r))
* homt0: value of homogenous goods transport cost; tmhom: tariff on homogenous goods
$prod:homm(x,r)$homm0(x,r)
    o:phom(x,r)                                                     q:vhomm0(x,r)
    i:pwh_(x)                				            q:homm0(x,r)  a:ra(r)  t:tmhom(x,r)
    i:pt	                 				    q:homt0(x,r)  a:ra(r)  t:tmhom(x,r)

* net exports of homogenous goods
* vhomx0(x,r) = homx0(x,r)/(1+txhom(x,r))
* txhom: export tax on homogenous goods
$prod:homx(x,r)$homx0(x,r)
    o:pwh(x)                                                        q:homx0(x,r)
    i:phom(x,r)              				            q:vhomx0(x,r)  a:ra(r)  t:txhom(x,r)


* net imports of bio-oil
$prod:biom_f(r)$((active("bio-oil","usa") or active("bio-fg","usa"))$efd("roil",r)$biot)
    o:paf_g("roil",r)                                               q:1
    i:pwo                          				    q:1
    i:pt	                       				    q:0.02

* net imports of bio-oil
$prod:biom_i(g,r)$((active("bio-oil","usa") or active("bio-fg","usa"))$eind("roil",g,r)$biot)
    o:pai_g("roil",g,r)                                             q:1
    i:pwo                          				    q:1
    i:pt	                       				    q:0.02

* net exports of bio-oil
$prod:biox(r)$((active("bio-oil",r) or active("bio-fg",r))$biot)
    o:pwo                                                           q:1
    i:pbo(r)                    				    q:1


* consumption index
* ence(e,r) = xdc0(r,e)+xmc0(r,e);
$prod:z(r)	s:sigg("ch4","fd",r) un:sigtrn    u(un):delas     a(u):d_elas(r)  dw(u):0.3     en(dw):selas("hh","noe_el",r)
+               oil(en):0            gas(en):0    coal(en):0      roil(en):0      elec(en):0

    o:pu(r)                                                         q:(cons0(r)-sum(g,cstar(r,g)*(1+tp(g,r))))
    i:ptrn(r)	               	                                    q:(tottrn(r)-cstar(r,"tran"))		                                           un:
    i:pa(nend,r)                                                    q:(xdc0(r,nend)+xmc0(r,nend)-cstar(r,nend))      p:pc0(nend,r) a:ra(r) t:tp(nend,r)    a:
    i:pa(dwe,r)                                                     q:(xdc0(r,dwe)+xmc0(r,dwe)-cstar(r,dwe))         p:pc0(dwe,r)   a:ra(r) t:tp(dwe,r)    dw:
    i:paf_g(e,r)                                                    q:((ence(e,r)-cstar(r,e))*aeei(r,"fd"))          p:pc0(e,r)	    a:ra(r) t:tp(e,r)      e.tl:$(not refo(e))  roil:$refo(e)

    i:pghg(ghg,r)$((not fdf(r))$ghglim(ghg,r)$(not wghgk))          q:fcghg_(ghg,"fd",r)                             p:(1/gu(ghg))
    i:pghgw(ghg)$(ghglim(ghg,r)$wghgk)	                            q:fcghg_(ghg,"fd",r)                             p:(1/gu(ghg))
    i:fghg(ghg,r)$(ghglimg(ghg,"fd",r)$fcghg_(ghg,"fd",r))          q:fcghg_(ghg,"fd",r)                             p:(1/gu(ghg))
    i:purb(urb,r)#(e)$urblim(urb,r)	                            q:curb_(urb,e,"fd",r)	                     p:(1/gu(urb)) 	                   e.tl:$(not refo(e))  roil:$refo(e)

* Stone-Geary subsistence consumption:
$prod:ccstar(g,r)$(cstar(r,g) gt 0)	s:0
    o:pcstar(g,r)			                            q:(cstar(r,g)*(1+tp(g,r)))
    i:pa(g,r)			                                    q:cstar(r,g)		p:pc0(g,r)  a:ra(r) t:tp(g,r)

$prod:ccstar(g,r)$(cstar(r,g) lt 0)     s:0
    o:pa(g,r)	                                                    q: (-cstar(r,g))	
    i:pcstar(g,r)	                                            q:(-cstar(r,g)*(1+tp(g,r)))	p:(1/(1+tp(g,r)))

$prod:w(r)  s:0
    o:pw(r)                                                         q:(w0(r)-sum(g,cstar(r,g)*(1+tp(g,r))))
    i:pu(r)                 		  		            q:(cons0(r)-sum(g,cstar(r,g)*(1+tp(g,r))))
    i:pinv(r)               		  		            q:inv0(r)

* vintage production (clay)
$prod:dv(g,v,r)$v_k(g,v,r)   s:siggv(g,r) a:0 oil(a):0 gas(a):0 coal(a):0  roil(a):0  elec(a):0

    o:pd(g,r)                                                       q:1                                             a:ra(r)  t:td(r,g)
    i:pa(ne,r)                                                      q:((xdp0(r,ne,g)+xmp0(r,ne,g))/xp0(r,g))        a:ra(r)  t:ti(ne,g,r)       a:
    i:pl(r)                                                         q:v_dl(r,g,v)                  p:pf0("lab",g,r) a:ra(r)  t:tf("lab",g,r)    a:
    i:pkv(g,v,r)                                                    q:v_dk(r,g,v)                  p:pf0("cap",g,r) a:ra(r)  t:tf("cap",g,r)    a:
    i:pf(g,r)                                                       q:v_df(r,g,v)				                                a:
    i:pai_g(e,g,r)                                                  q:v_de(r,e,g,v)                p:pi0(e,g,r) a:ra(r)  t:ti(e,g,r)            e.tl:$(not refo(e))   roil:$refo(e)
    i:purb(urb,r)#(e)$urblim(urb,r)	                            q:(curb_(urb,e,g,r)/xp0(r,g))  p:(1/gu(urb)) 		                e.tl:$(not refo(e))   roil:$refo(e)
    i:pren(r)$elec(g)$srenc(r)	                                    q:phi(r)		       
    i:pghg(ghg,r)$((not ss(g,r))$ghglim(ghg,r)$(not wghgk))	    q:(oghg_(ghg,g,r)/xp0(r,g))    p:(1/gu(ghg))
    i:pghgw(ghg)$(ghglim(ghg,r)$wghgk)                              q:(oghg_(ghg,g,r)/xp0(r,g))    p:(1/gu(ghg))
    i:sghg(ghg,g,r)$(ghglimg(ghg,g,r)$oghg_(ghg,g,r))	            q:(oghg_(ghg,g,r)/xp0(r,g))    p:(1/gu(ghg))
    i:purb(urb,r)$urblim(urb,r)	                                    q:(ourb_(urb,g,r)/xp0(r,g))    p:(1/gu(urb))                                a:
    i:scarb(g,r)$(cflag(r)$sco2c(r)$ss(g,r))                        q:(outco2(r,g)/xp0(r,g))      	                                        a:
    i:pcarb(r)$(cflag(r)$co2c(r)$(not ss(g,r)))                     q:(outco2(r,g)/xp0(r,g))      	  			                a:
    i:ptcarb$(cflag(r)$tco2c(r)$(not ss(g,r)))                      q:(outco2(r,g)/xp0(r,g))      	  			                a:

$prod:eb("ngcc",r)$active("ngcc",r) s:0  sa(s):bsf("ngcc",r)  fva(sa):0.0  va(fva):0.5  f(fva):0
    o:pd(g,r)$(not x(g))                                            q:bsout("ngcc",g)           a:ra(r) t:td(r,g)
    i:pbf("ngcc",r)         	   				    q:(bsin("ngcc","ffa",r)*bmkup("ngcc","f",r))	                                                sa:    											   
    i:pl(r)                 	   				    q:(bsin("ngcc","l",r)*bmkup("ngcc","l",r))                                                          va:    										   
    i:pk(r)                 	   				    q:(bsin("ngcc","k",r)*bmkup("ngcc","k",r))                    	       	                        va:           										   
    i:phom("gas",r)$(x("gas"))         				    q:(bsin("ngcc","gas",r)*bmkup("ngcc","e",r))                  	  	                        f: 									    
    i:pa("gas",r)$(not x("gas"))       				    q:(bsin("ngcc","gas",r)*bmkup("ngcc","e",r))                  	  	  		        f: 									   
    i:fcarb(r)$(sco2c(r)$fdf(r))       				    q:(ej_use("gas",r)/euse("gas",r)*epslon("gas")*bsin("ngcc","gas",r)*bmkup("ngcc","e",r))           	f: 									   
    i:pcarb(r)$(co2c(r)$(not fdf(r)))  				    q:(ej_use("gas",r)/euse("gas",r)*epslon("gas")*bsin("ngcc","gas",r)*bmkup("ngcc","e",r))           	f: 									   
    i:ptcarb$(tco2c(r)$(not fdf(r)))   				    q:(ej_use("gas",r)/euse("gas",r)*epslon("gas")*bsin("ngcc","gas",r)*bmkup("ngcc","e",r))           	f: 									   
    i:pk(r)                            				    q:(bsin("ngcc","ktd",r)*bmkup("ngcc","k",r))                                                       	va:									   
    i:pl(r)                            				    q:(bsin("ngcc","ltd",r)*bmkup("ngcc","l",r))                                                       	va:									    
    i:pren(r)$srenc(r)	                                            q:phi(r)                                                                                       										    

$prod:eb("ngcap",r)$active("ngcap",r)                s:0  sa:bsf("ngcap",r)  gtd(sa):0 tdva(gtd):0.5 pfva(gtd):0.0 fva(pfva):0 gva(fva):0.5 sva(fva):0.5  cva(fva):0
    o:pd(g,r)$(not x(g))                                            q:bsout("ngcap",g)           a:ra(r) t:td(r,g)
    i:pbf("ngcc",r)$active("ngcc",r)                   		    q:(bsin("ngcap","ffa",r)*bmkup("ngcap","f",r))	                                                                      sa: 	       															   
    i:pbf("ngcap",r)$(not active("ngcc",r))                         q:(bsin("ngcap","ffa",r)*bmkup("ngcap","f",r))	                                                                      sa: 	       															   
    i:pl(r)                            				    q:(bsin("ngcap","l",r)*bmkup("ngcap","l",r))                                                  			      gva:         														   
    i:pk(r)                            				    q:(bsin("ngcap","k",r)*bmkup("ngcap","k",r))                                                  			      gva:         														   
    i:phom("gas",r)$(x("gas"))         				    q:(bsin("ngcap","gas",r)*bmkup("ngcap","e",r))                                                	                      fva:	  		           														   
    i:pa("gas",r)$(not x("gas"))       				    q:(bsin("ngcap","gas",r)*bmkup("ngcap","e",r))                                                	      	  	      fva:             														   
    i:pk(r)                            				    q:(bsin("ngcap","kseq",r)*bmkup("ngcap","k",r))                                                                           sva:     														   
    i:pl(r)                 	   				    q:(bsin("ngcap","lseq",r)*bmkup("ngcap","l",r))                                      	             		      sva: 	           														   
    i:pk(r)                 	   				    q:(bsin("ngcap","ktd",r)*bmkup("ngcap","k",r))                                       	        		      tdva:         														   
    i:pl(r)                 	   				    q:(bsin("ngcap","ltd",r)*bmkup("ngcap","l",r))                                       	        		      tdva:         														   
    i:fcarb(r)$(sco2c(r)$fdf(r))       				    q:(ej_use("gas",r)/euse("gas",r)*epslon("gas")*(1-bsin("ngcap","frseq",r))*bsin("ngcap","gas",r)*bmkup("ngcap","e",r))    cva:     														   
    i:pcarb(r)$(co2c(r)$(not fdf(r)))  				    q:(ej_use("gas",r)/euse("gas",r)*epslon("gas")*(1-bsin("ngcap","frseq",r))*bsin("ngcap","gas",r)*bmkup("ngcap","e",r))    cva:     														   
    i:ptcarb$(tco2c(r)$(not fdf(r)))   				    q:(ej_use("gas",r)/euse("gas",r)*epslon("gas")*(1-bsin("ngcap","frseq",r))*bsin("ngcap","gas",r)*bmkup("ngcap","e",r))    cva:     														   

$prod:eb("igcc",r)$(active("igcc",r))  s:0  sa:bsf("igcc",r) gtd(sa):0 tdva(gtd):0.5 pfva(gtd):0.0 fva(pfva):0 gva(fva):0.5 cva(fva):0
    o:pd(g,r)$(not x(g))                                            q:bsout("igcc",g)         a:ra(r) t:td(r,g)
    i:pbf("igcc",r)        	   				    q:(bsin("igcc","ffa",r)*bmkup("igcc","f",r))                                                                           sa:      															      
    i:pl(r)                 	   				    q:(bsin("igcc","l",r)*bmkup("igcc","l",r))                                         			        	   gva:      	      														      
    i:pk(r)                 	   				    q:(bsin("igcc","k",r)*bmkup("igcc","k",r))                                         			        	   gva:     	      														      
    i:pa("coal",r)$(not x("coal"))     				    q:(bsin("igcc","coal",r)*bmkup("igcc","e",r))                                      			                   fva:     	      														         
    i:phom("coal",r)$(x("coal"))       				    q:(bsin("igcc","coal",r)*bmkup("igcc","e",r))                                      			     		   fva:     	      														      
    i:pk(r)                 	   				    q:(bsin("igcc","ktd",r)*bmkup("igcc","k",r))                                       	        			   tdva: 	      														      
    i:pl(r)                 	   				    q:(bsin("igcc","ltd",r)*bmkup("igcc","l",r))                                       	        			   tdva: 	      														      
    i:fcarb(r)$(sco2c(r)$fdf(r))       				    q:(ej_use("coal",r)/euse("coal",r)*epslon("coal")*bsin("igcc","coal",r)*bmkup("igcc","e",r))                           cva:     														      
    i:pcarb(r)$(co2c(r)$(not fdf(r)))  				    q:(ej_use("coal",r)/euse("coal",r)*epslon("coal")*bsin("igcc","coal",r)*bmkup("igcc","e",r))                           cva:     														      
    i:ptcarb$(tco2c(r)$(not fdf(r)))   				    q:(ej_use("coal",r)/euse("coal",r)*epslon("coal")*bsin("igcc","coal",r)*bmkup("igcc","e",r))                           cva:     														      

$prod:eb("igcap",r)$(active("igcap",r))  s:0  sa:bsf("igcap",r) gtd(sa):0 tdva(gtd):0.5 pfva(gtd):0.0 fva(pfva):0 gva(fva):0.5 sva(fva):0.5  cva(fva):0
    o:pd(g,r)$(not x(g))                                            q:bsout("igcap",g)         a:ra(r) t:td(r,g)
    i:pbf("igcc",r)$active("igcc",r)        	   		    q:(bsin("igcap","ffa",r)*bmkup("igcap","f",r))                                                                               sa:      															      
    i:pbf("igcap",r)$(not active("igcc",r))        	   	    q:(bsin("igcap","ffa",r)*bmkup("igcap","f",r))                                                                               sa:      															      
    i:pl(r)                 	   				    q:(bsin("igcap","l",r)*bmkup("igcap","l",r))                                         			        	 gva:      	      														      
    i:pk(r)                 	   				    q:(bsin("igcap","k",r)*bmkup("igcap","k",r))                                         			        	 gva:     	      														      
    i:pa("coal",r)$(not x("coal"))     				    q:(bsin("igcap","coal",r)*bmkup("igcap","e",r))                                      			                 fva:     	      														         
    i:phom("coal",r)$(x("coal"))       				    q:(bsin("igcap","coal",r)*bmkup("igcap","e",r))                                      			     		 fva:     	      														      
    i:pk(r)                            				    q:(bsin("igcap","kseq",r)*bmkup("igcap","k",r))                                                                              sva:     														      
    i:pl(r)                 	   				    q:(bsin("igcap","lseq",r)*bmkup("igcap","l",r))                                      	             			 sva:      	      														      
    i:pk(r)                 	   				    q:(bsin("igcap","ktd",r)*bmkup("igcap","k",r))                                       	        			 tdva: 	      														      
    i:pl(r)                 	   				    q:(bsin("igcap","ltd",r)*bmkup("igcap","l",r))                                       	        			 tdva: 	      														      
    i:fcarb(r)$(sco2c(r)$fdf(r))       				    q:(ej_use("coal",r)/euse("coal",r)*epslon("coal")*(1-bsin("igcap","frseq",r))*bsin("igcap","coal",r)*bmkup("igcap","e",r))   cva:     														      
    i:pcarb(r)$(co2c(r)$(not fdf(r)))  				    q:(ej_use("coal",r)/euse("coal",r)*epslon("coal")*(1-bsin("igcap","frseq",r))*bsin("igcap","coal",r)*bmkup("igcap","e",r))   cva:     														      
    i:ptcarb$(tco2c(r)$(not fdf(r)))   				    q:(ej_use("coal",r)/euse("coal",r)*epslon("coal")*(1-bsin("igcap","frseq",r))*bsin("igcap","coal",r)*bmkup("igcap","e",r))   cva:     														      

$prod:eb("adv-nucl",r)$active("adv-nucl",r)  s:0 sa(s):bsf("adv-nucl",r) va(sa):0.5
    o:pd(g,r)					                    q:bsout("adv-nucl",g)
    i:pl(r)							    q:(bsin("adv-nucl","l",r)*bmkup("adv-nucl","l",r))		                va:
    i:pk(r)							    q:(bsin("adv-nucl","k",r)*bmkup("adv-nucl","k",r))		                va:
    i:pk(r)							    q:(bsin("adv-nucl","ktd",r)*bmkup("adv-nucl","k",r))		        va:   
    i:pl(r)							    q:(bsin("adv-nucl","ltd",r)*bmkup("adv-nucl","l",r))		    	va:
    i:pbf("adv-nucl",r)					            q:(bsin("adv-nucl","ffa",r)*bmkup("adv-nucl","f",r))		    	sa:
    i:pren(r)$srenc(r)	                                            q:phi(r)

$prod:eb("wind",r)$active("wind",r)  t:0  s:wsigma(r) a:bsf("wind",r) b(a):1.0
*    o:p_e(r)                                                       q:bsout("wind","elec")  a:ra(r) t:windsub(r)
    o:pren(r)$srenc(r)	                                            q:1
    o:pd("elec",r)                                                  q:bsout("wind","elec")  a:ra(r) t:windsub(r)
    i:pa(g,r)$(not (enoe(g) or elec(g)))               		    q:(bsin("wind",g,r)*bmkup("wind","o",r))                                    b:	 
    i:pa(g,r)$(enoe(g) or elec(g))               		    q:(bsin("wind",g,r)*bmkup("wind","e",r))                                    b:	 
    i:pl(r)                 				            q:(bsin("wind","l",r)*bmkup("wind","l",r))     	 			b:
    i:pk(r)                 				            q:(bsin("wind","k",r)*bmkup("wind","k",r))     	 			b:
    i:pf("crop",r)          				            q:(bsin("wind","lnd",r)*bmkup("wind","d",r))   	 				 
    i:pbf("wind",r)         				            q:(bsin("wind","ffa",r)*bmkup("wind","f",r))   	 			a:

$prod:eb("bioelec",r)$active("bioelec",r)  t:0 s:bsigma(r) a:bsf("bioelec",r) b(a):1.0
*    o:p_e(r)                                                        q:bsout("bioelec","elec")					       								   
    o:pd("elec",r)                                                  q:bsout("bioelec","elec") a:ra(r) t:bioesub(r)			       							   
    o:pren(r)$srenc(r)	                                            q:1                                                                    							      
    i:pa(g,r)$(not (enoe(g) or elec(g)))               		    q:(bsin("bioelec",g,r)*bmkup("bioelec","o",r))                              b:      							   
    i:pa(g,r)$(enoe(g) or elec(g))               	            q:(bsin("bioelec",g,r)*bmkup("bioelec","e",r))                              b:      							   
    i:pl(r)                 				            q:(bsin("bioelec","l",r)*bmkup("bioelec","l",r))                           	b:						   
    i:pk(r)                 				            q:(bsin("bioelec","k",r)*bmkup("bioelec","k",r))                           	b:						   
    i:pf("crop",r)          				            q:(bsin("bioelec","lnd",r)*bmkup("bioelec","d",r))		               	  						   
    i:pbf("bioelec",r)      				            q:(bsin("bioelec","ffa",r)*bmkup("bioelec","f",r))                         	a:						   

$prod:eb("solar",r)$active("solar",r)  t:0  s:bsf("solar",r)    a:1  
*    o:p_e(r)                                                        q:bsout("solar","elec")  a:ra(r) t:solarsub(r)
    o:pd("elec",r)                                                  q:bsout("solar","elec")  a:ra(r) t:solarsub(r)
    o:pren(r)$srenc(r)					            q:1
    i:pa(g,r)$(not (enoe(g) or elec(g)))               		    q:(bsin("solar",g,r)*bmkup("solar","o",r))                                  a:      							   
    i:pa(g,r)$(enoe(g) or elec(g))               	            q:(bsin("solar",g,r)*bmkup("solar","e",r))                                  a:      							   
    i:pl(r)                 				            q:(bsin("solar","l",r)*bmkup("solar","l",r))                                a:
    i:pk(r)                 				            q:(bsin("solar","k",r)*bmkup("solar","k",r))                                a:
    i:pbf("solar",r)        				            q:(bsin("solar","ffa",r)*bmkup("solar","f",r))   

$prod:eb("windbio",r)$active("windbio",r)  a:bsf("windbio",r)  fva(a):0  va(fva):1  f(fva):bsigma(r)   b(f):1
    o:pd(g,r)$(not x(g))                                            q:bsout("windbio",g)
    i:pl(r)                 					    q:(bsin("windbio","lwind",r)*bmkup("windbio","l",r))	                va:									    
    i:pk(r)                 					    q:(bsin("windbio","kwind",r)*bmkup("windbio","k",r))	                va:	    							    
    i:pl(r)                 					    q:(bsin("windbio","lbio",r)*bmkup("windbio","l",r))		                b:     							    
    i:pk(r)                 					    q:(bsin("windbio","kbio",r)*bmkup("windbio","k",r))		                b:     							    
    i:pf("crop",r)          					    q:(bsin("windbio","lndbio",r)*bmkup("windbio","d",r))                       f:     							    
    i:pbf("windbio",r)      					    q:(bsin("windbio","ffa",r)*bmkup("windbio","f",r))		                a:     							    
    o:pren(r)$srenc(r)	                                            q:1                                                                     							        

$prod:eb("windgas",r)$active("windgas",r)  a:bsf("windgas",r)  fva(a):0  va(fva):1  f(fva):0   b(f):0.5   c(f):0
    o:pd(g,r)                                                       q:bsout("windgas",g)
    o:pren(r)$srenc(r)	                                            q:0.83
    i:pl(r)                              			    q:(bsin("windgas","lwind",r)*bmkup("windgas","l",r))		                             va:    												
    i:pk(r)                              			    q:(bsin("windgas","kwind",r)*bmkup("windgas","k",r))		                             va:           												
    i:pl(r)                              			    q:(bsin("windgas","lgas",r)*bmkup("windgas","l",r))		                                     b:        												
    i:pk(r)                              			    q:(bsin("windgas","kgas",r)*bmkup("windgas","k",r))		                                     b:        												
    i:pbf("windgas",r)                   			    q:(bsin("windgas","ffa",r)*bmkup("windgas","f",r))		                                     a:        												
    i:pa("gas",r)         			                    q:(bsin("windgas","gas",r)*bmkup("windgas","e",r))                                               c:	    												
    i:fcarb(r)$(sco2c(r)$fdf(r))         			    q:(ej_use("gas",r)/euse("gas",r)*epslon("gas")*bsin("windgas","gas",r)*bmkup("windgas","e",r))   c:	    												
    i:pcarb(r)$(co2c(r)$(not fdf(r)))    			    q:(ej_use("gas",r)/euse("gas",r)*epslon("gas")*bsin("windgas","gas",r)*bmkup("windgas","e",r))   c:	    												
    i:ptcarb$(tco2c(r)$(not fdf(r)))     			    q:(ej_use("gas",r)/euse("gas",r)*epslon("gas")*bsin("windgas","gas",r)*bmkup("windgas","e",r))   c:     												  

* 2nd generation biofuels
$prod:eb("bio-oil",r)$active("bio-oil",r)  s:boilsig(r) a(s):bsf("bio-oil",r)  b(a):1  va(b):0.5
    o:pbo(r)		                                            q:bsout("bio-oil","roil")			      	  						      
    i:pa(g,r)$(not (enoe(g) or elec(g)))               		    q:(bsin("bio-oil",g,r)*bmkup("bio-oil","o",r))                                               b:      							   
    i:pa(g,r)$(enoe(g) or elec(g))               	            q:(bsin("bio-oil",g,r)*bmkup("bio-oil","e",r))                                               b:      							   
    i:pl(r)                 					    q:(bsin("bio-oil","l",r)*bmkup("bio-oil","l",r))              				 va:     
    i:pk(r)                 					    q:(bsin("bio-oil","k",r)*bmkup("bio-oil","k",r))              				 va:         
    i:pbf("bio-oil",r)                                              q:(bsin("bio-oil","ffa",r)*bmkup("bio-oil","f",r))        					 a:     
    i:pf("crop",r)          					    q:(bsin("bio-oil","lnd",r)*bmkup("bio-oil","d",r))            					      

* 1st generation biofuels (simplified representation)
$prod:eb("bio-fg",r)$active("bio-fg",r)    s:boilffg(r)  a(s):bsf("bio-fg",r)  b(a):1  c(b):0.1 va(c):0.5 en(c):1.5  fen(en):0 
    o:pbo(r)		                                            q:(bsout("bio-fg","roil")) a:ra(r) t:biofgsub(r)          							    															    						    															    
    i:pa(g,r)$(not (enoe(g) or elec(g)))               		    q:(bsin("bio-fg",g,r)*bmkup("bio-fg","o",r))                                                 b:      							   
    i:pai_g("elec","roil",r)               			    q:(bsin("bio-fg","elec",r)*bmkup("bio-fg","e",r))                                            en: 	        	        													    
    i:pai_g("coal","roil",r)               			    q:(bsin("bio-fg","coal",r)*bmkup("bio-fg","e",r))                                            fen:       													    
    i:pai_g("roil","roil",r)               			    q:(bsin("bio-fg","roil",r)*bmkup("bio-fg","e",r))                                            fen:       													    
    i:pai_g("gas","roil",r)               			    q:(bsin("bio-fg","gas",r)*bmkup("bio-fg","e",r))                                             fen:       													    
    i:pl(r)                 					    q:(bsin("bio-fg","l",r)*bmkup("bio-fg","l",r))                                               va:		        													    
    i:pk(r)                 					    q:(bsin("bio-fg","k",r)*bmkup("bio-fg","k",r))                                               va:		        													    
    i:pbf("bio-fg",r)          					    q:(bsin("bio-fg","ffa",r)*bmkup("bio-fg","f",r))                                             a:		        													    
    i:pf("crop",r)                                                  q:(bsin("bio-fg","lnd",r)*bmkup("bio-fg","d",r))                                                                        													     

* oil shale production.  Note that shale oil/gas (cheaper to produce) has been considered in conventional resource base.
$prod:eb("synf-oil",r)$(active("synf-oil",r))  s:0 b:0.5 a(b):0.2
    o:phom(g,r)                                                     q:bsout("synf-oil",g)
    i:fcarb(r)$(sco2c(r)$fdf(r))       				    q:(ej_95d("usa","oil")*epslon("oil")*bsout("synf-oil","oil")*0.2)				       	   												       
    i:pcarb(r)$(co2c(r)$(not fdf(r)))  				    q:(ej_95d("usa","oil")*epslon("oil")*bsout("synf-oil","oil")*0.2)				       	       											       
    i:ptcarb$(tco2c(r)$(not fdf(r)))   				    q:(ej_95d("usa","oil")*epslon("oil")*bsout("synf-oil","oil")*0.2)				       	       											       
    i:purb(urb,r)$urblim(urb,r)        				    q:(curb_(urb,"roil","elec","usa")/xp0("usa","elec")*bsout("synf-oil","oil")*0.2)  p:(1/gu(urb))	           											       
    i:pa(g,r)$(not (enoe(g) or elec(g)))               		    q:(bsin("synf-oil",g,r)*bmkup("synf-oil","o",r))                                                   a:      							   
    i:pa(g,r)$(enoe(g) or elec(g))               	            q:(bsin("synf-oil",g,r)*bmkup("synf-oil","e",r))                                                   a:      							   
    i:pl(r)                            				    q:(bsin("synf-oil","l",r)*bmkup("synf-oil","l",r))                                                 a:    											       
    i:pk(r)                            				    q:(bsin("synf-oil","k",r)*bmkup("synf-oil","k",r))                                                 a:    											       
    i:pshale(r)                        				    q:(bsin("synf-oil","shale",r)* bmkup("synf-oil","e",r))                                            b:    											       

* Synthetic gas from coal
$prod:eb("synf-gas",r)$active("synf-gas",r)  s:0.0 b:0.0 a:0.5
    o:phom(g,r)$x(g)                                                q:bsout("synf-gas",g)
    o:pd(g,r)$(not x(g))               				    q:bsout("synf-gas",g)										       												       
    i:fcarb(r)$(sco2c(r)$fdf(r))       				    q:(ej_95d("usa","coal")*epslon("coal")*bsout("synf-gas","gas")*0.73)				           											       
    i:pcarb(r)$(co2c(r)$(not fdf(r)))  				    q:(ej_95d("usa","coal")*epslon("coal")*bsout("synf-gas","gas")*0.73)				           											       
    i:ptcarb$(tco2c(r)$(not fdf(r)))   				    q:(ej_95d("usa","coal")*epslon("coal")*bsout("synf-gas","gas")*0.73)				           											       
    i:purb(urb,r)$urblim(urb,r)        				    q:(curb_(urb,"coal","elec","usa")/xp0("usa","elec")*bsout("synf-gas","gas")*0.73) p:(1/gu(urb))	           											       
    i:pa(g,r)$(not (enoe(g) or elec(g)))               		    q:(bsin("synf-gas",g,r)*bmkup("synf-gas","o",r))                                                   b:    											       
    i:pa(g,r)$(enoe(g) or elec(g))               		    q:(bsin("synf-gas",g,r)*bmkup("synf-gas","e",r))                                                   b:    											       
    i:pl(r)                            				    q:(bsin("synf-gas","l",r)*bmkup("synf-gas","l",r))                                                 a:    											       
    i:pk(r)                            				    q:(bsin("synf-gas","k",r)*bmkup("synf-gas","k",r))                                                 a:    											       

$prod:eb("h2",r)$active("h2",r)  s:0.1    a:0.2
    o:pd(g,r)$(not x(g))                                            q:bsout("h2",g)
    i:fcarb(r)$(sco2c(r)$fdf(r))       				    q:(-ej_95d("usa","roil")*epslon("roil")*bsin("h2","roil",r))			  										  
    i:pcarb(r)$(co2c(r)$(not fdf(r)))  				    q:(-ej_95d("usa","roil")*epslon("roil")*bsin("h2","roil",r))			      									  
    i:ptcarb$(tco2c(r)$(not fdf(r)))   				    q:(-ej_95d("usa","roil")*epslon("roil")*bsin("h2","roil",r))			      									  
    i:pa(g,r)$(not (enoe(g) or elec(g)))                            q:(bsin("h2",g,r)*bmkup("h2","o",r))                                                      a:  	          									  
    i:pa(g,r)$(enoe(g) or elec(g))                          	    q:(bsin("h2",g,r)*bmkup("h2","e",r))                                                      a:  	          									  
    i:pl(r)                		   			    q:(bsin("h2","l",r)*bmkup("h2","l",r))                                  		      a:						  
    i:pk(r)                		   			    q:(bsin("h2","k",r)*bmkup("h2","k",r))                                  		      a:						  
    i:pbf("h2",r)          		   			    q:(bsin("h2","ffa",r)*bmkup("h2","f",r))                                              									    

$prod:bio_i(g,r)$((active("bio-oil",r) or active("bio-fg",r))$eind("roil",g,r))
    o:pai_g("roil",g,r)	                                            q:1
    i:pbo(r)		   				            q:1

$prod:bio_f(r)$((active("bio-oil",r) or active("bio-fg",r))$efd("roil",r))
    o:paf_g("roil",r)	                                            q:1
    i:pbo(r)		   					    q:1

$prod:bio_t(r)$((active("bio-oil",r) or active("bio-fg",r))$teusef("roil",r))
    o:paf_gh("roil",r)                                              q:1
    i:pbo(r)                                                        q:1

$prod:ebv(bt,v,r)$active(bt,r)$(vintgbs(bt,r)$vb_k(bt,v,r)$vb_dk(bt,v,r))     s:0
    o:pd(g,r)$(not x(g))                                            q:bsout(bt,g)         a:ra(r) t:td(r,g)
    o:pren(r)$windbio(bt)$srenc(r)	               	            q:1
    o:pren(r)$windgas(bt)$srenc(r)		       	            q:0.83
    i:pren(r)$ngcc(bt)$srenc(r)		       		            q:phi(r)
    i:pren(r)$ngcap(bt)$srenc(r)		       	            q:phi(r)
    i:pren(r)$igcap(bt)$srenc(r)		       	            q:phi(r)
    i:pbf(bt,r)$(not(ngcap(bt) or igcap(bt)))                       q:(vb_dff(bt,v,r)*bmkup(bt,"f",r))
    i:pbf("ngcc",r)$(ngcap(bt) and active("ngcc",r))                q:(vb_dff(bt,v,r)*bmkup(bt,"f",r))
    i:pbf(bt,r)$(ngcap(bt) and not active("ngcc",r))                q:(vb_dff(bt,v,r)*bmkup(bt,"f",r))
    i:pbf("igcc",r)$(igcap(bt) and active("igcc",r))                q:(vb_dff(bt,v,r)*bmkup(bt,"f",r))
    i:pbf(bt,r)$(igcap(bt) and not active("igcc",r))                q:(vb_dff(bt,v,r)*bmkup(bt,"f",r))
    i:pl(r)                 		       		            q:(vb_dl(bt,v,r)*bmkup(bt,"l",r))
    i:pvbk(bt,v,r)          		       		            q:(vb_dk(bt,v,r)*bmkup(bt,"k",r))
    i:pa(g,r)$(not x(g) and not (enoe(g) or elec(g)))    	    q:(vb_da(bt,g,v,r)*bmkup(bt,"o",r))
    i:pa(g,r)$(not x(g) and (enoe(g) or elec(g)))    		    q:(vb_da(bt,g,v,r)*bmkup(bt,"e",r))
    i:phom(g,r)$(x(g) and not (enoe(g) or elec(g)))        	    q:(vb_dh(bt,g,v,r)*bmkup(bt,"o",r))
    i:phom(g,r)$(x(g) and (enoe(g) or elec(g)))        		    q:(vb_dh(bt,g,v,r)*bmkup(bt,"e",r))

    i:fcarb(r)$(sco2c(r)$fdf(r)$ngcc(bt))          	    	    q:(ej_use("gas",r)/euse("gas",r)*epslon("gas")*vb_da(bt,"gas",v,r)*bmkup(bt,"e",r))			       											   
    i:pcarb(r)$(co2c(r)$(not fdf(r))$ngcc(bt))     	    	    q:(ej_use("gas",r)/euse("gas",r)*epslon("gas")*vb_da(bt,"gas",v,r)*bmkup(bt,"e",r))			       											   
    i:ptcarb$(tco2c(r)$(not fdf(r))$ngcc(bt))      	    	    q:(ej_use("gas",r)/euse("gas",r)*epslon("gas")*vb_da(bt,"gas",v,r)*bmkup(bt,"e",r))			       											   

    i:fcarb(r)$(sco2c(r)$fdf(r)$ngcap(bt))       	            q:(ej_use("gas",r)/euse("gas",r)*epslon("gas")*(1-bsin(bt,"frseq",r))*vb_da(bt,"gas",v,r)*bmkup(bt,"e",r))     													       														   
    i:pcarb(r)$(co2c(r)$(not fdf(r))$ngcap(bt))  	    	    q:(ej_use("gas",r)/euse("gas",r)*epslon("gas")*(1-bsin(bt,"frseq",r))*vb_da(bt,"gas",v,r)*bmkup(bt,"e",r))         											       														   
    i:ptcarb$(tco2c(r)$(not fdf(r))$ngcap(bt))   	    	    q:(ej_use("gas",r)/euse("gas",r)*epslon("gas")*(1-bsin(bt,"frseq",r))*vb_da(bt,"gas",v,r)*bmkup(bt,"e",r))         											       														   
 
    i:fcarb(r)$(sco2c(r)$fdf(r)$igcc(bt))          	    	    q:(ej_use("coal",r)/euse("coal",r)*epslon("coal")*vb_da(bt,"coal",v,r)*bmkup(bt,"e",r))			       											   
    i:pcarb(r)$(co2c(r)$(not fdf(r))$igcc(bt))     	    	    q:(ej_use("coal",r)/euse("coal",r)*epslon("coal")*vb_da(bt,"coal",v,r)*bmkup(bt,"e",r))			       											   
    i:ptcarb$(tco2c(r)$(not fdf(r))$igcc(bt))      	    	    q:(ej_use("coal",r)/euse("coal",r)*epslon("coal")*vb_da(bt,"coal",v,r)*bmkup(bt,"e",r))                        											     
							    	    													       											   
    i:fcarb(r)$(sco2c(r)$fdf(r)$igcap(bt))       	    	    q:(ej_use("coal",r)/euse("coal",r)*epslon("coal")*(1-bsin(bt,"frseq",r))*vb_da(bt,"coal",v,r)*bmkup(bt,"e",r))      											          														   
    i:pcarb(r)$(co2c(r)$(not fdf(r))$igcap(bt))  	    	    q:(ej_use("coal",r)/euse("coal",r)*epslon("coal")*(1-bsin(bt,"frseq",r))*vb_da(bt,"coal",v,r)*bmkup(bt,"e",r))      											          														   
    i:ptcarb$(tco2c(r)$(not fdf(r))$igcap(bt))   	    	    q:(ej_use("coal",r)/euse("coal",r)*epslon("coal")*(1-bsin(bt,"frseq",r))*vb_da(bt,"coal",v,r)*bmkup(bt,"e",r))      											          														   
							    	    													       											   
    i:fcarb(r)$(sco2c(r)$fdf(r)$windgas(bt))       	    	    q:(ej_use("gas",r)/euse("gas",r)*epslon("gas")*vb_da(bt,"gas",v,r)*bmkup(bt,"e",r))				       											   
    i:pcarb(r)$(co2c(r)$(not fdf(r))$windgas(bt))  	    	    q:(ej_use("gas",r)/euse("gas",r)*epslon("gas")*vb_da(bt,"gas",v,r)*bmkup(bt,"e",r))				       											   
    i:ptcarb$(tco2c(r)$(not fdf(r))$windgas(bt))   	    	    q:(ej_use("gas",r)/euse("gas",r)*epslon("gas")*vb_da(bt,"gas",v,r)*bmkup(bt,"e",r))				       											   
							    	    													       											   							    	    													       											  
* To facilitate model solve, the quantity of pghg is amplified by a factor of "gu", and so the benchmark price is recalibrated
$prod:eqco2(ghg,r)$((ghgk(r)$ghglim(ghg,r))$ghgt)
    o:pghg(ghg,r)		                                    q:gu(ghg)   p:(1/gu(ghg))
    i:pcarb(r)$co2c(r)                           	            q:gwp(ghg)
    i:ptcarb$tco2c(r)                            	            q:gwp(ghg)
							    		
$prod:eqghg(ghg,r)$((ghgk(r)$ghglim(ghg,r))$ghgt)	    		
    o:pcarb(r)$co2c(r)                                              q:gwp(ghg)
    o:ptcarb$tco2c(r)                            	            q:gwp(ghg)
    i:pghg(ghg,r)		                     	            q:gu(ghg)   p:(1/gu(ghg))
							    		
$prod:ewco2(ghg)$(wghgk$ghgt)				    		
    o:pghgw(ghg)	                                            q:gu(ghg)   p:(1/gu(ghg))
    i:ptcarb                 	             		            q:gwp(ghg)
							    		
$prod:ewghg(ghg)$(wghgk$ghgt)				    		
    o:ptcarb                 	                                    q:gwp(ghg)
    i:pghgw(ghg)	  	                     	            q:gu(ghg)   p:(1/gu(ghg))
							    		
$prod:seqco2(ghg,g,r)$((sghgk(r)$(ghglimg(ghg,g,r)))$ghgt)  		
    o:sghg(ghg,g,r)			                            q:gu(ghg)   p:(1/gu(ghg))
    i:scarb(g,r)$(sco2c(r)$ss(g,r))              	            q:gwp(ghg)
							    		
$prod:seqghg(ghg,g,r)$((sghgk(r)$(ghglimg(ghg,g,r)))$ghgt)  		
    o:scarb(g,r)$(sco2c(r)$ss(g,r))                                 q:gwp(ghg)
    i:sghg(ghg,g,r)		                     	            q:gu(ghg)   p:(1/gu(ghg))
							    		
$prod:feqco2(ghg,r)$((sghgk(r)$ghglimg(ghg,"fd",r))$ghgt)   		
    o:fghg(ghg,r)			                            q:gu(ghg)   p:(1/gu(ghg))
    i:fcarb(r)$(sco2c(r)$fdf(r))                 	            q:gwp(ghg)
							    		
$prod:feqghg(ghg,r)$((sghgk(r)$ghglimg(ghg,"fd",r))$ghgt)   		
    o:fcarb(r)$(sco2c(r)$fdf(r))                                    q:gwp(ghg)
    i:fghg(ghg,r)		                     	            q:gu(ghg)   p:(1/gu(ghg))

* extract the bilateral trade flows as an output variable
$prod:tflowm_(r,rr,g)$(wtflow0(r,rr,g) and not gmarket and not x(g))
    o:pd_(g,rr)$(not x(g))                                          q:wtflow0(r,rr,g)
    i:pd(g,rr)$(not x(g))                                   	    q:wtflow0(r,rr,g)

$prod:tflowm_(r,rr,g)$(wtflow0(r,rr,g) and gmarket and not x(g) and not gas(g))
    o:pd_(g,rr)$(not x(g))                                          q:wtflow0(r,rr,g)
    i:pd(g,rr)$(not x(g))                                   	    q:wtflow0(r,rr,g)

$prod:mqhom_(x,r)$homm0(x,r)
    o:pwh_(x)                                                       q:homm0(x,r)
    i:pwh(x)                                                	    q:homm0(x,r)

* representative consumer
$demand:ra(r)
    d:pw(r)                                                                             q:(w0(r)-sum(g,cstar(r,g)))		 					
    e:pcstar(g,r)							                q:(-cstar(r,g)*(1+tp(g,r)))		        			
    e:pt			                                	                q:(sum(x, trnadj(x,r)))			       			
    e:phom(x,r)		                                 		                q:homadj(x,r)				        			
    e:pk(r)$nugm                                                	                q:(kapital(r)*kprod_f(r))   r:gprod(r)	       			
    e:pk(r)$(not nugm)                                          	                q:kapital(r)		    r:gprod(r)	        			
    e:pkv(g,v,r)                                             		                q:v_k(g,v,r)                                   			
    e:pvbk(bt,v,r)$active(bt,r)$vintgbs(bt,r)$vb_k(bt,v,r)$vb_dk(bt,v,r)                q:vb_k(bt,v,r)
    e:pl(r)$nugm                                                  	                q:(labor(r)*lprod_f(r))     r:gprod(r)
    e:pl(r)$(not nugm)                                             	                q:labor(r)	            r:gprod(r)
    e:pf(g,r)$(not ff(g) and nugm)                                                      q:(ffact(g,r)*fprod_f(r))   r:gprod(r)$(not ff(g))	   							   
    e:pf(g,r)$(not ff(g) and not nugm)                              	                q:ffact(g,r)		    r:gprod(r)$(not ff(g))	       					   
    e:pf(g,r)$(ff(g) and nugm)                                                          q:(ffact(g,r)*fprod_f(r))    
    e:pf(g,r)$(ff(g) and not nugm)                                                      q:ffact(g,r)		     
    e:pr(r)					                 	                q:n_r(r)	            r:nuclim$jpn(r)
    e:pr_h(r)				                                                q:h_r(r)
    e:pu("usa")				                 	                        q:savf(r)
    e:pcarb(r)$(co2c(r)$(not ctaxf(r)))                                                 q:carblim(r)   			         									 					             			     
    e:ptcarb$(tco2c(r))                         		                        q:tcarblim(r)				             			     
    e:scarb(g,r)$(sco2c(r)$ss(g,r))                             	                q:scarblim(g,r)				            			     
    e:fcarb(r)$(sco2c(r)$fdf(r))                             		                q:fcarblim(r)				             			     
    e:pg(r)                                                  		                q:(-grg(r))				             			     
    e:pshale(r)$active("synf-oil",r)		         		                q:shale(r)				             			     
    e:pghg(ghg,r)$(ghglim(ghg,r)$(not wghgk))	         		                q:ghglim(ghg,r)              		             			     
    e:pghgw(ghg)$(ghglim(ghg,r)$wghgk)			 		                q:ghglim(ghg,r)				            			     
    e:sghg(ghg,g,r)$(ghglimg(ghg,g,r))	                 		                q:ghglimg(ghg,g,r)			             			     
    e:fghg(ghg,r)$(ghglimg(ghg,"fd",r))	                 		                q:ghglimg(ghg,"fd",r)			             			     
    e:purb(urb,r)$urblim(urb,r)		                        	                q:urblim(urb,r)				            			     
    e:pcafe(r)$active("cafe",r)                                 	                q:(teusef("roil",r)*cshr(r)*cafelim(r))             			                     
    e:pbf(bt,r)$(active(bt,r)$lcbt(bt)$bres(bt,r)$(not (ngcap(bt) or igcap(bt))))       q:bres(bt,r)				             			     
    e:pbf(bt,r)$(active(bt,r)$lcbt(bt)$bres(bt,r)$ngcap(bt)$(not active("ngcc",r)))     q:bres(bt,r)				             			     
    e:pbf(bt,r)$(active(bt,r)$lcbt(bt)$bres(bt,r)$igcap(bt)$(not active("igcc",r)))     q:bres(bt,r)				             			     

$constraint:nuclim
  n_e("jpn") =e= ntarget;

$constraint:rgdp(r)
  pu(r)*rgdp(r) =e= pu(r)*(cons0(r)-sum(g,cstar(r,g)*(1+tp(g,r))))*z(r)
                   + sum(g,pcstar(g,r)*cstar(r,g)*(1+tp(g,r))*ccstar(g,r))
	           + inv0(r)*pinv(r)*inv(r) + g0(r)*pg(r)*govt(r)
                   + sum((g,rr),(1+tx(g,r,rr))*pd__(g,r)*tflowm__(rr,r,g)*wtflow0(rr,r,g))
                   - sum((g,rr),(1+tx(g,rr,r))*pd__(g,rr)*tflowm__(r,rr,g)*wtflow0(r,rr,g))
                   + sum(x, pwh(x)*homx0(x,r)*homx(x,r))
                   - sum(x, pwh(x)*homm0(x,r)*mqhom_(x,r))
                   + pwo*(1*biox(r)$((active("bio-oil",r) or active("bio-fg",r))$biot))
                   - pwo*(1*biom_f(r)$((active("bio-oil","usa") or active("bio-fg","usa"))$efd("roil",r)$biot)
                   + sum(g,1*biom_i(g,r)$((active("bio-oil","usa") or active("bio-fg","usa"))$eind("roil",g,r)$biot)))
;

$constraint:gprod(r)$(simu eq 0)
  rgdp(r) =g= rgdp0(r);

$constraint:gprod(r)$(simu ne 0)
  gprod(r) =e= gprod0(r);

$constraint:tflowm__(r,rr,g)
  tflowm__(r,rr,g) =e= tflowm_(r,rr,g)$(wtflow0(r,rr,g) and not gmarket and not x(g))
                      +0$(not (wtflow0(r,rr,g) and not gmarket and not x(g)));

$constraint:pd__(g,r)
  pd__(g,r) =e= pd(g,r)$((not x(g))$xp0(r,g)) + 0$(not((not x(g))$xp0(r,g)));

$constraint:tlimc(e,g,r)$eid_ghg_up(e,g,r)
  eid_ghg_up(e,g,r) =g= eid_ghg(e,g,r);

$offtext
$sysinclude mpsgeset eppa

* Set the initial values or upper/lower bounds for variables

nuclim.l                        = 1;
tflowm__.l(r,rr,g)              = 1$(wtflow0(r,rr,g) and not gmarket and not x(g)) + 0$(not (wtflow0(r,rr,g) and not gmarket and not x(g)));
pd__.l(g,r)                     = 1$((not x(g))$xp0(r,g)) + 0$(not((not x(g))$xp0(r,g)));
rgdp.l(r)                       = rgdp0(r);
gprod.l(r)                      = 1;
pghg.lo(ghg,r)                  = 0.00001;
gprod.lo(r)                     = 0;
rgdp.lo(r)                      = 0;
tflowm__.lo(r,rr,g)             = 0;
pd__.lo(g,r)                    = 0;

* Initalize the sets for controling policies
co2c(r)                         = no;
sco2c(r)                        = no;
tco2c(r)                        = no;
srenc(r)                        = no;

* When needed, this block can adjust investment and consumption of othr in China:

xdi0_(r,g)                      = xdi0(r,g);
xdc0_(r,g)                      = xdc0(r,g);
inv0_(r)                        = inv0(r)  ;
cons0_(r)                       = cons0(r) ;
tp_(g,r)                        = tp(g,r)  ;
pc0_(g,r)                       = pc0(g,r) ;

xdi0("chn","othr")              = xdi0("chn","othr")-0;
xdc0("chn","othr")              = xdc0("chn","othr")+0;
inv0("chn")                     = inv0("chn")-0;
cons0("chn")                    = cons0("chn")+0;
		               
tp("othr","chn")                = tp_("othr","chn")*(xdc0_("chn","othr")+xmc0("chn","othr"))/(xdc0("chn","othr")+xmc0("chn","othr"));
pc0("othr","chn")               = pc0_("othr","chn")-tp_("othr","chn")+tp("othr","chn");

* Set the price numeraire of the model: all prices are measured relative to the numeraire

pw.fx("usa")                    = 1;

* Check if the base year calibration is correct by solving the model with iterlim = 0

eppa.iterlim                    = 0;
eppa.optfile                    = 1;

$include EPPA.GEN
option mcp                      = path;
option solprint                 = on;
solve eppa using mcp;
display eppa.objval;

