import matplotlib
matplotlib.use('Agg')
import matplotlib.pyplot as plt 

tnp= 0.15294
tp = 0.10083

Qp=int(100*tp/(tp+tnp))
etichetta="Amdahl  %d%% parallelizzabile " % (Qp)

N=[1,2,4,8,16,32]  # numero processori
Samdahl=[(tnp+tp)/(tnp+tp/n) for n in N]

plt.title('Progettazione - "Legge di Amdahl"  Federico Becchi 12-06-2026')
plt.grid()
plt.xlabel('Processors')
plt.ylabel('Speedup')
plt.plot(N,Samdahl,'g-o',label=etichetta)
plt.plot(N,N,'r-',label='ideal')
plt.legend(shadow=True)
plt.savefig('cpi+amdahl.png')
