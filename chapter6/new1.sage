def coppersmith_howgrave_univariate(pol, modulus, beta, mm, tt, XX):
    
    dd = pol.degree()
    nn = dd * mm + tt

    if not 0 < beta <= 1:
        raise ValueError("beta should belongs in (0, 1]")

    if not pol.is_monic():
        raise ArithmeticError("Polynomial must be monic.")
    
    polZ = pol.change_ring(ZZ)
    x = polZ.parent().gen()
    gg = []
    for ii in range(mm):
        for jj in range(dd):
            gg.append((x * XX)**jj * modulus**(mm - ii) * polZ(x * XX)**ii)
    for ii in range(tt):
        gg.append((x * XX)**ii * polZ(x * XX)**mm)

    BB = Matrix(ZZ, nn)

    for ii in range(nn):
        for jj in range(ii+1):
            BB[ii, jj] = gg[ii][jj]

    # LLL
    BB = BB.LLL()

    # transform shortest vector in polynomial
    new_pol = 0
    for ii in range(nn):
        new_pol += x**ii * BB[0, ii] / XX**ii

    # factor polynomial
    potential_roots = new_pol.roots()

    # test roots
    roots = []
    for root in potential_roots:
        if root[0].is_integer():
            result = polZ(ZZ(root[0]))
            if gcd(modulus, result) >= modulus^beta:
                roots.append(ZZ(root[0]))

    
    return roots
e = 5
N =  4307292380039002410360902869181807255795053946883588694366858522121669049734222928623830773568763601308880398818736877042747592457120347560540668931211009114604019210255540558518510112360292627499953842345027865424021233278309432596599486965092869604630940211039715226931526379503376304488452132515003
C=3026027697934387148825084632647408300472315053265041027032279421565504382275782534127485147470034921139073833470540210871191764552648506732712839838227027176204900443910220194144361508943314777946460204381449109915459903608520381717165005118672786578192698858480077659626354051681694304835580301011182
# RSA known parameters
ZmodN = Zmod(N);

def break_RSA(M_str, max_length_x):
    global e, C, ZmodN

    print len(M_str), ' ' + M_str
    binary_padding = ''.join(['{0:08b}'.format(ord(x)) for x in M_str])
    print(int(binary_padding, 2))

    for length_x in range(0, max_length_x+1, 4):         

        # Problem to equation (default)
        P.<x> = PolynomialRing(ZmodN) #, implementation='NTL')
        pol = ((int(binary_padding, 2)<<length_x) + x)^e - C
        dd = pol.degree()

        # Tweak those
        beta = 1                                
        epsilon = beta / 7                      
        mm = ceil(beta**2 / (dd * epsilon))     
        tt = floor(dd * mm * ((1/beta) - 1))    
        XX = ceil(N**((beta**2/dd) - epsilon))  

        roots = coppersmith_howgrave_univariate(pol, N, beta, mm, tt, XX)

        # output
        if roots:
            print "Size of solution", length_x
            print "solution found :", ' {0:b}'.format(roots[0])
            print "\n"
            return

    print 'No solution found\n'

#if __name__ == "__main__":
with open('paddings.txt','r') as f:
    padding_list = f.readlines()
for M in padding_list:
    break_RSA(M.strip(), 300)
