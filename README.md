# SarqXReporter

SarqXReporter ծրագիրը նախատեսված է համակարգչի տվյալների ստացման և նրանց դեպի 
SarqX կայք ուղարկելու համար։

## Տեղադրում

SarqXReporter ծրագիրը ներկա պահին հասանելի է Git և AUR(Arch User Repository):

```
yay -S sarqx-reporter
```

## Ներքին կազմվածք

Ծրագիրը տեղադրվում է հետևյալ տեղերում

`/usr/bin/sarqx-reporter` \
`/opt/sarqx-reporter` \
`/var/opt/sarqx-reporter` \
`/etc/opt/sarqx-reproter` \
`/etc/systemd/system/sarqxd.service`

Այսպիսի ֆայլային ժանում ունի մեր ծրագիրը։ Այս բաժանումը հիմնված է 
[Filesystem Hierarchy Standard](https://en.wikipedia.org/wiki/Filesystem_Hierarchy_Standard)
վրա։

Պետք է նաև նշել, որ `/usr/bin/sarqx-reporter` ֆայլը իրենից ներկայացնում է հղում
`/opt/sarqx-reporter/bin/sarqx-reporter` ֆայլի վրա։ Պատճառը այն է, որ Linux
կատարում է միայն այն ծրագրերի, որոնց ֆայլերը առկա են `/usr/bin`-ի մեջ, իսկ
քանի որ այս ծրագրի կատարվող ֆայլը այդտեղ առկա չէ, ապա հետևյալ հրամանը չեր աշխատի, եթե չլիներ հղվող ֆայլը
```
sarqx-reporter
bash: command not fount: sarqx-reporter
```

## Կիրառում

Առաջին հերթին օգտատերը պետք է գրի հետևյալ հրամանը, որպեսզի գրանցի իր տվյալները SarqX մեջ
```
sarqx-reporter --register
``` 

Այս հրամանից հետո ծարագիրը ստեղծում է `/etc/opt/credentials.json` անունով ֆայլ և ուղարկում տվյալները SarqX-ին։

Մայն այս հրամանից հետո կարելի է մեկնարկել դեմոնին, որը գտնվում է `/etc/systemd/system/sarqxd.service`
```
sarqx-reporter --start
```

Դեմոնը կստանա և կուղարկի համակարգչի տվյալները։
Ստացված տվյալները պահվում են `/var/opt/sarqx-reporter/logs`-ում։