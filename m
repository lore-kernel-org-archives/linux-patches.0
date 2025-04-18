Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCBF226A1A0
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 07:53:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744962823; cv=none; b=AHhsn/6alO+t4k3f+nxrUpZPd4w85dxK2nXcu9ryLOPrFFrnlIPu3MbAD5t2nVK6yuIySuoJ2Hep8pmHkZNED00CYKdMx6ios7cNG0weP3M00gTGZsr0vdJX4NNDTXS2/8C6BIkLK58GDx7Uh2BctzgOW0//8i37VVjzMUo4RVM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744962823; c=relaxed/simple;
	bh=Myoieq5AHAsfCkC471ftyGoDu4Wy2MzuQeBMkPKK1I4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZkmhVkMC7wtHHsknhMxARV4WOsALEAC0fnZFbhUpPrqSqs6WD13vPwVqvl1i4/LRQ/afVWaPllLLiUYRYuuS9Paj8JuRhPwDLWAL5wHTsA8pMPnX9k/jH22mO9xcElSvFutA4Uaj7qBy2mpJ0ZQrdmXpO1fheg7/MmtmOb6rjLM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=p5aWqI+U; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p5aWqI+U"
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-86fab198f8eso612070241.1
        for <patches@lists.linux.dev>; Fri, 18 Apr 2025 00:53:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744962819; x=1745567619; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XIJ0B2TMiV89VsD9zDzHfB8j6876qfCf1ZvV0jOFwPM=;
        b=p5aWqI+UKiRvKDGie8vmHs8NBtvKwREERVBk07aPquLcwjKGgQO4ZR0knILEzVX4eC
         GitBFkzg/F29/SYEZfY0k3ANeypHJhcV0WdxXrEcroHfbgP1pfbADgrR5LqFQ9QCKx0J
         05yfSfYjLieEX0Lm7o5k48JtFy14F/hY5b/hWFj0FAkqT8s3EwosCZ0gW9pEKvIlbyY8
         rI/ZyHdMt/8SMG2YNQKbk7qx4yCUyeu/nGnKDzTtB6wZcHY3SIwoni9pvg/70vLdJWsU
         IeSrAYgoYAicPK9GjTp1k2CUXM90mmTjGRG0RxiKyiVmCdzRrPZMBbWsFZ54XVeBTvVZ
         bB7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744962819; x=1745567619;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XIJ0B2TMiV89VsD9zDzHfB8j6876qfCf1ZvV0jOFwPM=;
        b=hSl5NlV0bVAuX37V+xvT0oBdm8JUaTEuGHU5IAW5AFVKoplgnFtX/Y+/HtaeaB3w6D
         n6lg7kiaCahS7Ky1TipXw7/Y7PFOjPBcvHTXG/qPTg35SdpL7+f9OFIL1wgh7HqIdbh6
         VRbTetJhnC2YzqG0wknnWrf9nimTe2Yf1hyO6CZgkFUp+rSe130E6sym+v94WZwlCQzi
         KVH6+VwTtOKnIZgGhV0JjxbU+IlZbt5EUjCcuYVut6Q407s/cFueCOOrr27DdsUh3Ffm
         8h/fUlRlAPoORxMNMBqfhuAU3VJsXT3BxIReXsmoYoVuzMkGhONuGG09eDuLxmNxx8xx
         LDuw==
X-Forwarded-Encrypted: i=1; AJvYcCXh8YlHe9Hju529Qm8aEWY86DpI0eGU7CqP8QxwXE3tX4wQYqs7xyLzNiuTYk0m3zVyuBfNj551@lists.linux.dev
X-Gm-Message-State: AOJu0YxNoGlNjzK+FdNtV8CZbWc6F0P9UKxHJS+4fQR+WNABRjFcTkki
	zGVD1GOkmtCiFRf7iqwq/gLKK8xcbiCCsEKzdEUD8HH5TQnuxjCksZW1JqM2mrZ8FX5zccjNXHG
	96IV9uEzPewq0/jaTDyJEmgmP9B+jbxPCSeIzXg==
X-Gm-Gg: ASbGncsIvDy3G1QIB9iB+W93MZpRpBM7cIVx6WZXG4FJks3e2q9gBLFTFp957D7nw0f
	Kek6V3XhE/ULjt82xXZQ9oSxV1MbT46artMp4l96j4UDXP40ObOBx3+IT6vBnm4Prd+EPjgf+bE
	asWQgp/QAeqC3WeRT57dYOjG0sNNdYleAZ6sf3KqX59WDpqD5YoSGGaQ==
X-Google-Smtp-Source: AGHT+IFTGbVZZetUE9HCWSO8w/F4KeChmScmnZ5AZgW3i5eFumiq5KR6/6167HsmhF0YKOkb6owXP8U1NAq00FSYTwA=
X-Received: by 2002:a05:6102:1165:b0:4c1:86ff:4af7 with SMTP id
 ada2fe7eead31-4cb80213764mr1187463137.21.1744962819474; Fri, 18 Apr 2025
 00:53:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250417175117.964400335@linuxfoundation.org>
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 18 Apr 2025 13:23:27 +0530
X-Gm-Features: ATxdqUHwgzDJJgGMq17txYu0twdBZhINNv85OP_bUXu-SObSGKCfhxX_v8A_V7E
Message-ID: <CA+G9fYs+z4-aCriaGHnrU=5A14cQskg=TMxzQ5MKxvjq_zCX6g@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/449] 6.14.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Arnd Bergmann <arnd@arndb.de>, Liam Girdwood <lgirdwood@gmail.com>, 
	Frieder Schrempf <frieder.schrempf@kontron.de>, Marek Vasut <marex@denx.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 17 Apr 2025 at 23:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.3 release.
> There are 449 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 19 Apr 2025 17:49:48 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.3-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on arm64 dragonboard 410c boot failed with lkftconfig on
the stable rc
6.14.3-rc1. While booting, the following kernel warnings were noticed
and boot failed.

First seen on the 6.14.3-rc1
Good: v6.14.2
Bad:  v6.14.2-450-g0e7f2bba84c1

Regressions found on arm64 dragonboard 410c:
- Boot/clang-20-lkftconfig

Regression Analysis:
- New regression? Yes
- Reproducibility? Yes

Boot regression: arm64 dragonboard 410c WARNING regulator core.c regulator_=
put

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Boot log arm64 dragonboard 410c
[    3.924339]  remoteproc:smd-edge: failed to parse smd edge
[    4.051490] msm_hsusb 78d9000.usb: Failed to create device link
(0x180) with supplier remoteproc for /soc@0/usb@78d9000/ulpi/phy
[    4.055155] qcom-clk-smd-rpm
remoteproc:smd-edge:rpm-requests:clock-controller: Error registering
SMD clock driver (-1431655766)
[    4.062274] qcom-clk-smd-rpm
remoteproc:smd-edge:rpm-requests:clock-controller: probe with driver
qcom-clk-smd-rpm failed with error -1431655766
[    4.091319] sdhci_msm 7864900.mmc: Got CD GPIO
[    4.101827] s3: Bringing 0uV into 1250000-1250000uV
[    4.101935] s3: failed to enable: (____ptrval____)
[    4.105657] ------------[ cut here ]------------
[    4.110395] WARNING: CPU: 3 PID: 14 at
drivers/regulator/core.c:2450 regulator_put
(drivers/regulator/core.c:2473 drivers/regulator/core.c:2471)
[    4.115181] Modules linked in:
[    4.116774] input: gpio-keys as /devices/platform/gpio-keys/input/input0
[    4.123575] CPU: 3 UID: 0 PID: 14 Comm: kworker/u16:1 Not tainted
6.14.3-rc1 #1
[    4.123587] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    4.123593] Workqueue: async async_run_entry_fn
[    4.123608] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[    4.123619] pc : regulator_put (drivers/regulator/core.c:2473
drivers/regulator/core.c:2471)
[    4.124148] sdhci_msm 7864900.mmc: Got CD GPIO
[    4.128587] clk: Disabling unused clocks
[    4.133299] lr : regulator_put (drivers/regulator/core.c:2444
drivers/regulator/core.c:2471)
[    4.133312] sp : ffff80008300ba40
[    4.133317] x29: ffff80008300ba40 x28: 0000000000000000 x27: ffff800081b=
850f8
[    4.141083] PM: genpd: Disabling unused power domains
[    4.147271]
[    4.147274] x26: ffff800081b850b8 x25: 0000000000000001 x24: 00000000aaa=
aaaaa
[    4.147288] x23: ffff000009d64480 x22: ffff000005b10000
[    4.151676] qcom-rpmpd
remoteproc:smd-edge:rpm-requests:power-controller: failed to sync cx:
-1431655766
[    4.158467]  x21: ffff000005b10000
[    4.158474] x20: ffff0000044e41c0 x19: ffff0000055f00c0 x18: 00000000000=
00002
[    4.158488] x17: 0000000000000000
[    4.162763] qcom-rpmpd
remoteproc:smd-edge:rpm-requests:power-controller: failed to sync
cx_ao: -1431655766
[    4.166888]  x16: 0000000000000001 x15: 0000000000000003
[    4.166898] x14: ffff8000828ad200 x13: 0000000000000003 x12: 00000000000=
00003
[    4.171011] qcom-rpmpd
remoteproc:smd-edge:rpm-requests:power-controller: failed to sync
cx_vfc: -1431655766
[    4.174872]
[    4.174876] x11: 0000000000000000 x10: 0000000000000000 x9 : 00000000000=
00000
[    4.174889] x8 : 0000000000000001
[    4.178116] qcom-rpmpd
remoteproc:smd-edge:rpm-requests:power-controller: failed to sync mx:
-1431655766
[    4.185205]  x7 : 0720072007200720 x6 : 0720072007200720
[    4.185216] x5 : ffff000003201f00 x4 : 0000000000000000 x3 : 00000000000=
00000
[    4.190259] qcom-rpmpd
remoteproc:smd-edge:rpm-requests:power-controller: failed to sync
mx_ao: -1431655766
[    4.191806]
[    4.191809] x2 : 0000000000000000
[    4.198858] ALSA device list:
[    4.203876]  x1 : ffff800080201224 x0 : ffff0000055f00c0
[    4.203888] Call trace:
[    4.203893] regulator_put (drivers/regulator/core.c:2473
drivers/regulator/core.c:2471) (P)
[    4.213658]   No soundcards found.
[    4.216808] regulator_register (drivers/regulator/core.c:5964)
[    4.216819] devm_regulator_register (drivers/regulator/devres.c:477)
[    4.329706] rpm_reg_probe
(drivers/regulator/qcom_smd-regulator.c:1425
drivers/regulator/qcom_smd-regulator.c:1462)
[    4.329719] platform_probe (drivers/base/platform.c:1405)
[    4.329730] really_probe (drivers/base/dd.c:581 drivers/base/dd.c:658)
[    4.329743] __driver_probe_device (drivers/base/dd.c:0)
[    4.329755] driver_probe_device (drivers/base/dd.c:830)
[    4.329768] __device_attach_driver (drivers/base/dd.c:959)
[    4.329780] bus_for_each_drv (drivers/base/bus.c:462)
[    4.329791] __device_attach_async_helper
(arch/arm64/include/asm/jump_label.h:36 drivers/base/dd.c:988)
[    4.329804] async_run_entry_fn
(arch/arm64/include/asm/jump_label.h:36 kernel/async.c:131)
[    4.329814] process_scheduled_works (kernel/workqueue.c:3243
kernel/workqueue.c:3319)
[    4.329827] worker_thread (include/linux/list.h:373
kernel/workqueue.c:946 kernel/workqueue.c:3401)
[    4.375850] kthread (kernel/kthread.c:466)
[    4.379397] ret_from_fork (arch/arm64/kernel/entry.S:863)
[=C3=AF=C2=BF=C2=BD+HH=C3=AF=C2=BF=C2=BD=C3=AF=C2=BF=C2=BD4.387392] s4: Bri=
nging 0uV into 1850000-1850000uV
[    4.387486] s4: failed to enable: (____ptrval____)
[    4.391254] ------------[ cut here ]------------
[    4.395957] WARNING: CPU: 2 PID: 14 at
drivers/regulator/core.c:2450 regulator_put
(drivers/regulator/core.c:2473 drivers/regulator/core.c:2471)
[    4.400742] Modules linked in:
[    4.409148] CPU: 2 UID: 0 PID: 14 Comm: kworker/u16:1 Tainted: G
    W          6.14.3-rc1 #1
[    4.412028] Tainted: [W]=3DWARN
[    4.420949] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    4.421397] sdhci_msm 7864900.mmc: Got CD GPIO
[    4.423810] Workqueue: async async_run_entry_fn
[    4.434842] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[    4.439274] pc : regulator_put (drivers/regulator/core.c:2473
drivers/regulator/core.c:2471)
[    4.446210] lr : regulator_put (drivers/regulator/core.c:2444
drivers/regulator/core.c:2471)
[    4.450376] sp : ffff80008300ba40
[    4.454281] x29: ffff80008300ba40 x28: 0000000000000000 x27: ffff800081b=
85118
[    4.457503] x26: ffff800081b850b8 x25: 0000000000000001 x24: 00000000aaa=
aaaaa
[    4.464622] x23: ffff00000459ae80 x22: ffff000004510800 x21: ffff0000045=
10800
[    4.471739] x20: ffff0000038e3180 x19: ffff0000055f1000 x18: 00000000000=
00068
[    4.478857] x17: 0000000000000000 x16: 0000000000000024 x15: 00000000000=
00301
[    4.485976] x14: 0000000000000024 x13: 00000000150d0cc9 x12: fffffffffff=
ffff0
[    4.493093] x11: 0000000000000000 x10: 0000000000000000 x9 : 00000000000=
00000
[    4.500211] x8 : 0000000000000001 x7 : 0720072007200720 x6 : 07200720072=
00720
[    4.507328] x5 : ffff000003201f00 x4 : 0000000000000000 x3 : 00000000000=
00010
[    4.514446] x2 : ffff80008300b6d0 x1 : ffff800080201224 x0 : ffff0000055=
f1000
[    4.521566] Call trace:
[    4.528671] regulator_put (drivers/regulator/core.c:2473
drivers/regulator/core.c:2471) (P)
[    4.530931] regulator_register (drivers/regulator/core.c:5964)
[    4.535099] devm_regulator_register (drivers/regulator/devres.c:477)
[    4.539006] rpm_reg_probe
(drivers/regulator/qcom_smd-regulator.c:1425
drivers/regulator/qcom_smd-regulator.c:1462)
[    4.543518] platform_probe (drivers/base/platform.c:1405)
[    4.547249] really_probe (drivers/base/dd.c:581 drivers/base/dd.c:658)
[    4.550983] __driver_probe_device (drivers/base/dd.c:0)
[    4.554630] driver_probe_device (drivers/base/dd.c:830)
[    4.558970] __device_attach_driver (drivers/base/dd.c:959)
[    4.562965] bus_for_each_drv (drivers/base/bus.c:462)
[    4.567477] __device_attach_async_helper
(arch/arm64/include/asm/jump_label.h:36 drivers/base/dd.c:988)
[    4.571646] async_run_entry_fn
(arch/arm64/include/asm/jump_label.h:36 kernel/async.c:131)
[    4.576679] process_scheduled_works (kernel/workqueue.c:3243
kernel/workqueue.c:3319)
[    4.580586] worker_thread (include/linux/list.h:373
kernel/workqueue.c:946 kernel/workqueue.c:3401)
[    4.585358] kthread (kernel/kthread.c:466)
[    4.588915] ret_from_fork (arch/arm64/kernel/entry.S:863)
[    4.592304] ---[ end trace 0000000000000000 ]---
[    4.597057] l2: Bringing 0uV into 1200000-1200000uV
[    4.600531] qcom_rpm_smd_regulator
remoteproc:smd-edge:rpm-requests:regulators: l2:
devm_regulator_register() failed, ret=3D-517
[    4.605612] Unable to handle kernel paging request at virtual
address ffffffffaaaaae6a
[    4.616566] Mem abort info:
[    4.624438]   ESR =3D 0x0000000096000005
[    4.627130]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
[    4.630953]   SET =3D 0, FnV =3D 0
[    4.636417]   EA =3D 0, S1PTW =3D 0
[    4.639281]   FSC =3D 0x05: level 1 translation fault
[    4.642325] Data abort info:
[    4.647183]   ISV =3D 0, ISS =3D 0x00000005, ISS2 =3D 0x00000000
[    4.650313]   CM =3D 0, WnR =3D 0, TnD =3D 0, TagAccess =3D 0
[    4.655606]   GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0
[    4.660730] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D00000000824f10=
00
[    4.666115] [ffffffffaaaaae6a] pgd=3D0000000000000000,
p4d=3D0000000082f1c403, pud=3D0000000000000000
[    4.672816] Internal error: Oops: 0000000096000005 [#1] PREEMPT SMP
[    4.681201] Modules linked in:
[    4.687443] CPU: 2 UID: 0 PID: 14 Comm: kworker/u16:1 Tainted: G
    W          6.14.3-rc1 #1
[    4.690584] Tainted: [W]=3DWARN
[    4.699505] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    4.702381] Workqueue: async async_run_entry_fn
[    4.709147] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[    4.713405] pc : regulator_unregister (drivers/regulator/core.c:5991)
[    4.720342] lr : devm_rdev_release (drivers/regulator/devres.c:453)
[    4.725203] sp : ffff80008300bae0
[    4.729454] x29: ffff80008300bb00 x28: ffff000003301340 x27: 00000000000=
001c8
[    4.732683] x26: ffff000003231a00 x25: ffff00000459ae00 x24: ffff0000033=
01340
[    4.739794] x23: ffff80008286ed00 x22: ffff8000823fc4a1 x21: ffff0000033=
aac00
[    4.746913] x20: ffff000005ac7410 x19: ffff80008300bba8 x18: 00000000000=
00002
[    4.754030] x17: 6f74616c75676572 x16: 3a73747365757165 x15: 00000ff0000=
3fd36
[    4.761148] x14: 000000000000ffff x13: 0000000000000020 x12: 00000000000=
00003
[    4.768267] x11: 0000000000000000 x10: 0000000000000000 x9 : ffff800080b=
59fe0
[    4.775384] x8 : 06678d1f10cf8900 x7 : 3d4e5f454c424954 x6 : 000000004e5=
14553
[    4.782502] x5 : 0000000000000008 x4 : ffff800082276255 x3 : 00000000000=
00010
[    4.789620] x2 : ffff80008300ba60 x1 : ffff0000033aac80 x0 : ffffffffaaa=
aaaaa
[    4.796740] Call trace:
[    4.803845] regulator_unregister (drivers/regulator/core.c:5991) (P)
[    4.806108] devm_rdev_release (drivers/regulator/devres.c:453)
[    4.810966] release_nodes (drivers/base/devres.c:506)
[    4.814872] devres_release_all (drivers/base/devres.c:0)
[    4.818432] really_probe (drivers/base/dd.c:551 drivers/base/dd.c:724)
[    4.822423] __driver_probe_device (drivers/base/dd.c:0)
[    4.826072] driver_probe_device (drivers/base/dd.c:830)
[    4.830324] __device_attach_driver (drivers/base/dd.c:959)
[    4.834317] bus_for_each_drv (drivers/base/bus.c:462)
[    4.838831] __device_attach_async_helper
(arch/arm64/include/asm/jump_label.h:36 drivers/base/dd.c:988)
[    4.843001] async_run_entry_fn
(arch/arm64/include/asm/jump_label.h:36 kernel/async.c:131)
[    4.848032] process_scheduled_works (kernel/workqueue.c:3243
kernel/workqueue.c:3319)
[    4.851941] worker_thread (include/linux/list.h:373
kernel/workqueue.c:946 kernel/workqueue.c:3401)
[    4.856713] kthread (kernel/kthread.c:466)
[    4.860270] ret_from_fork (arch/arm64/kernel/entry.S:863)
[ 4.863661] Code: d5384108 f9430d08 f81f83a8 b4000bc0 (f941e014)
All code
=3D=3D=3D=3D=3D=3D=3D=3D

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    4.867227] ---[ end trace 0000000000000000 ]---
[   14.238655] sdhci_msm 7864900.mmc: Got CD GPIO

## Source
* Kernel version: 6.14.3-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
* Git sha: 0e7f2bba84c1f492e15812fade27cc0a697f3cb6
* Git describe: v6.14.2-450-g0e7f2bba84c1
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/Boot/v6.14.=
2-450-g0e7f2bba84c1/
* Architectures: arm64 dragonboard 410c
* Toolchains: clang-20
* Kconfigs: lkftconfig

## Boot
* Boot log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y=
/build/v6.14.2-450-g0e7f2bba84c1/testrun/28150326/suite/boot/test/clang-20-=
lkftconfig/log
* Boot history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14=
.2-450-g0e7f2bba84c1/testrun/28150326/suite/boot/test/clang-20-lkftconfig/
* Boot details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14=
.2-450-g0e7f2bba84c1/testrun/28150326/suite/boot/test/clang-20-lkftconfig/d=
etails/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2vrqGz=
3vUNvc2w9PJfCD1r7ChKx/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2vrqGz3vUNvc2w9PJfCD=
1r7ChKx/config

--
Linaro LKFT
https://lkft.linaro.org
