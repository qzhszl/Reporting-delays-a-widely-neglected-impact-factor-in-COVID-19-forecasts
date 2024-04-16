import numpy as np
import matplotlib.pyplot as plt
import matplotlib.lines as mlines
import pandas as pd

# Scatter plot for plotting the relation between I, delta R and delta D

# Input: spain_ID.xlsx: the first row is I, the second row is delta D. Similarly, the relation between I, delta R and delta D can be obtained
df1 = pd.read_excel('synethic_ID.xlsx')
wuhanR = df1.to_numpy()

mark = ['d', 'o', '>', '<', '*', '^', 'v', 'p', 's', 'D']
co = ['royalblue','darkorange','limegreen','red','darkorchid','chocolate','hotpink','gray','gold','deepskyblue']
cc = ['Orange','Green','royalblue','Grey','Red','Purple']
camp = ['Oranges','Greens','Blues','Greys','Reds','Purples']
#co_sequence = range(1,10)
co_sequence = range(0,len(wuhanR[0]))
"""Scatter Plot + add color bar"""
#X = np.arange(1,10)
#Y = np.arange(1,10)
# X = wuhanR[0]/10607700
# Y = wuhanR[1]/10607700
X = wuhanR[0]/1
Y = wuhanR[1]/1

# X = wuhanR[0]/58438200  #hubei
# Y = wuhanR[1]/58438200  #hubei

# X = wuhanR[0]/51640000 #korea
# Y = wuhanR[1]/51640000 #korea
plt.scatter(X,Y,s=30,zorder=3,marker=mark[1],c=co_sequence, cmap=camp[1])
#plt.plot(X, Y,zorder=2,c=cc[1],alpha=0.3)
cb = plt.colorbar()
font_size = 28

ax = plt.gca()
ax.yaxis.get_major_formatter().set_powerlimits((0,1))
ax.xaxis.get_major_formatter().set_powerlimits((0,1))
ax.tick_params(labelsize=18)


plt.savefig('spain_ID.eps', format='eps')


#plt.savefig('wuhan_hubei_death.eps', format='eps')
#plt.savefig('korea_recovered.eps', format='eps')
#plt.savefig('wuhan_recovered.eps', format='eps')
#plt.savefig('wuhan_death.eps', format='eps')
#plt.savefig('hubei_recovered.eps', format='eps')
#plt.savefig('hubei_death.eps', format='eps')
#plt.setp(legend1.get_title(),fontsize=16)


#'''Figure Parameters'''
#plt.xlabel(r'$w_{GPE \rightarrow \alpha}$', fontsize=18)
#plt.ylabel(r'$w_{\alpha \rightarrow GPE}$', fontsize=18)
#plt.xticks(X,fontsize=16)
#plt.yticks(Y,fontsize=16)
#plt.text(8.5, 1, r'(b)', fontsize=16,weight='semibold')

plt.show()
