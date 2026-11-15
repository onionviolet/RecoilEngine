import re,sys
for p in sys.argv[1:]:
    t=open(p,errors='replace').read()
    i=t.find('Benchmark Results')
    if i<0: print(p.split('/')[-1],'NO RESULT'); continue
    blk=t[i:]
    out=[]
    for k in re.finditer(r'\n[^\n]*?\s(\w+)=\{\n',blk):
        name=k.group(1)
        if name in ('buckets','percentiles'): continue
        m=re.search(r'count=(\d+),\s*\n[^\n]*mean=([\d.]+)',blk[k.end():k.end()+3000])
        if m: out.append(f"{name} mean {float(m.group(2)):.2f}ms n={m.group(1)}")
    print(p.split('/')[-1][:40],' | '.join(out))
