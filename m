Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A8A7199947
	for <patches@lists.linux.dev>; Fri, 18 Apr 2025 09:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744968903; cv=none; b=kwRUE5d8LoLn+SvWlxfDzebYUpaN6+P6OLMOt0SqPGR9uBpqo1XqaTm1s3Dci+LQRps2/XoRmqyzEP0gthzsHZnYEHfWYRkgNj7h7WwYXcnuwJD6Lrm19gs+cgZYK14O8F212f4LVBRlRrFSfxC07gz5qRHmMF5aP7rZqIfzR3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744968903; c=relaxed/simple;
	bh=b44pdG6dFpVeOemUl+zNHzGe7lTNRt/MyWWEo1m0xgc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=onfZJXxDN7IhRupsZ1WCIW5BTUkptf2MdPW9e0L7eCiK/y/Dg8xVVNg4Yhp/IHgYihlnLKa2iRrocZU7eIMcV3Vowvivhvc5Q8bD7CUaqBOwbCgtCiVFmy0fQsdVvSQUhNc49RWi+tfH57ahIhMBg7T8sX5cED6MkbbgG8VMXUo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=aeq/CUwE; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="aeq/CUwE"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-523d8c024dfso655216e0c.3
        for <patches@lists.linux.dev>; Fri, 18 Apr 2025 02:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744968900; x=1745573700; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=taYnZJAX9AjJqcs2xWnJr71aItbCvopiMuqAV0c83K0=;
        b=aeq/CUwEMKNInEQE0c5JUBFsEP7ZNvw3DQoIuLSGYmpyU/4qHyhl9T/kOq7FDej7Cv
         hAFmom+rxarrBv0z7qjE0WodVcXlQ97aL2b02FPucpedF51+EVhr1pSfeapxwEYf1uco
         0FxXrG0iv/ccT7k335eatIjKijRe6gm9QZVpWXD44RXBR6rsca6fuUcxgYUOzEKZsF+7
         pyHDRInsiD8qdcUOe6F1DaeJhUQTrRcZ07AoDBv4K54isY0BbF4OD1b7qdJBmhnKIE/k
         1eRgQlksN2B/Xe0zAFQjmmUClPaAwv8rCOB/21wX81ckw7/MDI1KGNMGqfhNbGJ5kwXm
         3wIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744968900; x=1745573700;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=taYnZJAX9AjJqcs2xWnJr71aItbCvopiMuqAV0c83K0=;
        b=KgW3NwvbkSfl39bIpe0tpYSPbetugJ0DM/cdPFsVTu74SKUrCWKSffo8vfZvTiBoKB
         L7awQ1/86gmrllDpQ9+OJCp3bQuq8g1YwGLwXndLeMsX3fMYgevOnguPrVNhyGqzp0SH
         XWZMZuKWDmslCQXt1lC98NFax4qKaKNq7uu5PFP39tj9HInwJA6GCH+XZIKZFPNFKTfH
         aPu/mvsYV1CNngJO6h+9ibLAkjQeqciVVY8ject9IW5EgzllM3DV1nQdW3aCRub5+xvF
         v6s8nH2c67UkSEjT2fMVvBGzHWOvs+LTD2SGQADD35vhSZNbWewGwvI+Zq4BtInwYXin
         P5cw==
X-Forwarded-Encrypted: i=1; AJvYcCXtZMLwZwsf81vOPqFr8+cHOo9Wl/Cgt33Wia4p0TfsTLArGFTQAU2QgiTGdhHXHGRnqgeXYfkc@lists.linux.dev
X-Gm-Message-State: AOJu0YzS+44ZIv25IbAlFN7DQmdmcvvPgTZmPfixrSBus/vy1ZW4kEcJ
	7TMARtQ58HPe+9afVXR+DsD/+dMu9CiTGP5GbB4tbuQp+NO/cWGtR5UKjve3w/cjAwbZZ63y0pp
	AssNJEsb6X/62VWekIxzxjOUglHUaCtsejwUuuA==
X-Gm-Gg: ASbGncuPC7mxsbUi67xFxDynutCU106A9fTTZWRXPhZ41Z+mnPwRO08uTiD0wgKlZfO
	6nY6Gsba7uWvnzaYH196fLfBch85V3Gom1KqF+Aw3OlkiSrq6frfHGz2MuSCbET38QJnB/2wcrQ
	AQV8zozuFAgg3debM+n/0JUZp9fjI0hDi0Xk6jL66oOORSIswnnz960Q==
X-Google-Smtp-Source: AGHT+IHfOCaePsw2Sbbpw78y+pQq5k7hKID3jpJta4FUo5a06bGc5ZvelJDseHPqpVe/Tynq2MzmGaog2gfZnR8ubuM=
X-Received: by 2002:a05:6122:884:b0:51f:405e:866e with SMTP id
 71dfb90a1353d-529253b90dfmr1198298e0c.1.1744968900238; Fri, 18 Apr 2025
 02:35:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250417175107.546547190@linuxfoundation.org>
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 18 Apr 2025 15:04:48 +0530
X-Gm-Features: ATxdqUH1lSys9th2G6SO6a8njOOZsyTXkvrwZQazamKi0EdyXXgNru7FWs-QWgs
Message-ID: <CA+G9fYtaRQhArip=UYkLt864AnXBD6Y07-06CjOJZYSDZ858SQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/393] 6.12.24-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 18 Apr 2025 at 00:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.24 release.
> There are 393 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 19 Apr 2025 17:49:48 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.24-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following two regressions found on stable-rc 6.12.24-rc1 review,

1)
Regressions on arm64 allmodconfig and allyesconfig builds failed
on the stable rc 6.12.24-rc1.

2)
Regressions on arm64 dragonboard 410c boot failed with lkftconfig
on the stable rc 6.12.24-rc1.

First seen on the 6.12.24-rc1
Good: 6.12.23-rc3
Bad:  6.12.24-rc1

Regressions found on arm64:
- build/gcc-13-allmodconfig
- build/gcc-13-allyesconfig
- build/clang-20-allmodconfig
- build/clang-20-allyesconfig

Regressions found on arm64 dragonboard-410c:
- boot/clang-20-lkftconfig

Regression Analysis:
- New regression? Yes
- Reproducibility? Yes

Build regression: arm64 ufs-qcom.c implicit declaration 'devm_of_qcom_ice_g=
et'

Boot regression: arm64 dragonboard 410c WARNING regulator core.c regulator_=
put

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build log arm64
drivers/ufs/host/ufs-qcom.c: In function 'ufs_qcom_ice_init':
drivers/ufs/host/ufs-qcom.c:121:15: error: implicit declaration of
function 'devm_of_qcom_ice_get'; did you mean 'of_qcom_ice_get'?
[-Werror=3Dimplicit-function-declaration]
121 |         ice =3D devm_of_qcom_ice_get(dev);
|               ^~~~~~~~~~~~~~~~~~~~
|               of_qcom_ice_get
drivers/ufs/host/ufs-qcom.c:121:13: error: assignment to 'struct
qcom_ice *' from 'int' makes pointer from integer without a cast
[-Werror=3Dint-conversion]
121 |         ice =3D devm_of_qcom_ice_get(dev);
|             ^
cc1: all warnings being treated as errors


## Boot log arm64 dragonboard 410c:
[    3.956824] s3: Bringing 0uV into 1250000-1250000uV
[    3.958010] PM: genpd: Disabling unused power domains
[    3.961581] s3: failed to enable: (____ptrval____)
[    3.966149] qcom-rpmpd
remoteproc:smd-edge:rpm-requests:power-controller: failed to sync cx:
-1431655766
[    3.971325] ------------[ cut here ]------------
[    3.976053] qcom-rpmpd
remoteproc:smd-edge:rpm-requests:power-controller: failed to sync
cx_ao: -1431655766
[    3.985511] WARNING: CPU: 3 PID: 61 at
drivers/regulator/core.c:2395 regulator_put
(drivers/regulator/core.c:2418 drivers/regulator/core.c:2416)
[    3.985536] Modules linked in:
[    3.985549] CPU: 3 UID: 0 PID: 61 Comm: kworker/u16:3 Not tainted
6.12.24-rc1 #1
[    3.990154] qcom-rpmpd
remoteproc:smd-edge:rpm-requests:power-controller: failed to sync
cx_vfc: -1431655766
[    3.992895] sdhci_msm 7864900.mmc: Got CD GPIO
[    3.999579] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    3.999587] Workqueue: async async_run_entry_fn
[    3.999609] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[    3.999619] pc : regulator_put (drivers/regulator/core.c:2418
drivers/regulator/core.c:2416)
[    3.999631] lr : regulator_put (drivers/regulator/core.c:2389
drivers/regulator/core.c:2416)
[    3.999640] sp : ffff8000833aba50
[    3.999645] x29: ffff8000833aba50 x28: 0000000000000000 x27: ffff800081b=
1e530
[    3.999661] x26: ffff800081b1e4f0
[    4.008278] qcom-rpmpd
remoteproc:smd-edge:rpm-requests:power-controller: failed to sync mx:
-1431655766
[    4.011121]  x25: 0000000000000001 x24: 00000000aaaaaaaa
[    4.011132] x23: ffff00000967e080 x22: ffff0000055e2800
[    4.018702] qcom-rpmpd
remoteproc:smd-edge:rpm-requests:power-controller: failed to sync
mx_ao: -1431655766
[    4.028477]  x21: ffff0000055e2800
[    4.028485] x20: ffff0000051f1d40 x19: ffff0000051fac00 x18: 00000000000=
00002
[    4.032760] ALSA device list:
[    4.039587]
[    4.039590] x17: 0000000000000000 x16: 0000000000000001 x15: 00000000000=
0010b
[    4.043862]   No soundcards found.
[    4.050785] x14: 0000000000100000 x13: ffff8000833a8000 x12: ffff8000833=
ac000
[    4.127727] x11: 0000000000000000 x10: 0000000000000000 x9 : 00000000000=
00000
[    4.127743] x8 : 0000000000000001 x7 : 0000000000000003 x6 : 00000000000=
00000
[    4.127758] x5 : 0000000000000000 x4 : 0000000000000002 x3 : ffff8000833=
ab630
[    4.127772] x2 : ffff0000045e0000 x1 : ffff8000801cf41c x0 : ffff0000051=
fac00
[    4.127787] Call trace:
[    4.127793] regulator_put (drivers/regulator/core.c:2418
drivers/regulator/core.c:2416)
[    4.127805] regulator_register (drivers/regulator/core.c:5858)
[    4.127817] devm_regulator_register (drivers/regulator/devres.c:477)
[    4.127827] rpm_reg_probe
(drivers/regulator/qcom_smd-regulator.c:1425
drivers/regulator/qcom_smd-regulator.c:1462)
[    4.127839] platform_probe (drivers/base/platform.c:1405)
[    4.127851] really_probe (drivers/base/dd.c:581 drivers/base/dd.c:658)
[    4.185179] __driver_probe_device (drivers/base/dd.c:0)
[    4.188819] driver_probe_device (drivers/base/dd.c:830)
[    4.193158] __device_attach_driver (drivers/base/dd.c:959)
[    4.197152] bus_for_each_drv (drivers/base/bus.c:459)
[    4.201664] __device_attach_async_helper
(arch/arm64/include/asm/jump_label.h:32 drivers/base/dd.c:988)
[    4.205834] async_run_entry_fn
(arch/arm64/include/asm/jump_label.h:32 kernel/async.c:131)
[    4.210866] process_scheduled_works (kernel/workqueue.c:3234
kernel/workqueue.c:3310)
[    4.214773] worker_thread (include/linux/list.h:373
kernel/workqueue.c:946 kernel/workqueue.c:3392)
[    4.219544] kthread (kernel/kthread.c:391)
[    4.223102] ret_from_fork (arch/arm64/kernel/entry.S:861)
[    4.226491] ---[ end trace 000000000000=C3=AF=C2=BF=C2=BD[    4.234746] =
s4: failed
to enable: (____ptrval____)
[    4.234881] ------------[ cut here ]------------
[    4.238442] WARNING: CPU: 3 PID: 61 at
drivers/regulator/core.c:2395 regulator_put
(drivers/regulator/core.c:2418 drivers/regulator/core.c:2416)
[    4.243226] Modules linked in:
[    4.251634] CPU: 3 UID: 0 PID: 61 Comm: kworker/u16:3 Tainted: G
    W          6.12.24-rc1 #1
[    4.254514] Tainted: [W]=3DWARN
[    4.263433] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    4.266397] Workqueue: async async_run_entry_fn
[    4.273162] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[    4.277421] pc : regulator_put (drivers/regulator/core.c:2418
drivers/regulator/core.c:2416)
[    4.284357] lr : regulator_put (drivers/regulator/core.c:2389
drivers/regulator/core.c:2416)
[    4.288522] sp : ffff8000833aba50
[    4.292427] x29: ffff8000833aba50 x28: 0000000000000000 x27: ffff800081b=
1e550
[    4.295651] x26: ffff800081b1e4f0 x25: 0000000000000001 x24: 00000000aaa=
aaaaa
[    4.302768] x23: ffff00000967e280 x22: ffff0000055e2800 x21: ffff0000055=
e2800
[    4.309885] x20: ffff0000051f1d40 x19: ffff0000051facc0 x18: 00000000112=
04d65
[    4.317003] x17: 0000000000000000 x16: 0000000000000001 x15: 00000000000=
00003
[    4.324123] x14: ffff8000827de540 x13: 0000000000000003 x12: 00000000000=
00003
[    4.331239] x11: 0000000000000000 x10: 0000000000000000 x9 : 00000000000=
00000
[    4.338357] x8 : 0000000000000001 x7 : 0720072007200720 x6 : 07200720072=
00720
[    4.345477] x5 : ffff000003201f00 x4 : 0000000000000000 x3 : 00000000000=
00000
[    4.352594] x2 : 0000000000000000 x1 : ffff8000801cf41c x0 : ffff0000051=
facc0
[    4.359713] Call trace:
[    4.366817] regulator_put (drivers/regulator/core.c:2418
drivers/regulator/core.c:2416)
[    4.369077] regulator_register (drivers/regulator/core.c:5858)
[    4.372899] devm_regulator_register (drivers/regulator/devres.c:477)
[    4.376806] rpm_reg_probe
(drivers/regulator/qcom_smd-regulator.c:1425
drivers/regulator/qcom_smd-regulator.c:1462)
[    4.381317] platform_probe (drivers/base/platform.c:1405)
[    4.385050] really_probe (drivers/base/dd.c:581 drivers/base/dd.c:658)
[    4.388783] __driver_probe_device (drivers/base/dd.c:0)
[    4.392430] driver_probe_device (drivers/base/dd.c:830)
[    4.396769] __device_attach_driver (drivers/base/dd.c:959)
[    4.400764] bus_for_each_drv (drivers/base/bus.c:459)
[    4.405277] __device_attach_async_helper
(arch/arm64/include/asm/jump_label.h:32 drivers/base/dd.c:988)
[    4.409447] async_run_entry_fn
(arch/arm64/include/asm/jump_label.h:32 kernel/async.c:131)
[    4.414479] process_scheduled_works (kernel/workqueue.c:3234
kernel/workqueue.c:3310)
[    4.418387] worker_thread (include/linux/list.h:373
kernel/workqueue.c:946 kernel/workqueue.c:3392)
[    4.423158] kthread (kernel/kthread.c:391)
[    4.426717] ret_from_fork (arch/arm64/kernel/entry.S:861)
[    4.430104] ---[ end trace 0000000000000000 ]---
[    4.435585] l2: Bringing 0uV into 1200000-1200000uV
[    4.438347] qcom_rpm_smd_regulator
remoteproc:smd-edge:rpm-requests:regulators: l2:
devm_regulator_register() failed, ret=3D-517
[    4.443414] Unable to handle kernel paging request at virtual
address ffffffffaaaaae6a
[    4.454358] Mem abort info:
[    4.462236]   ESR =3D 0x0000000096000005
[    4.464916]   EC =3D 0x25: DABT (current EL), IL =3D 32 bits
[    4.468754]   SET =3D 0, FnV =3D 0
[    4.474215]   EA =3D 0, S1PTW =3D 0
[    4.477066]   FSC =3D 0x05: level 1 translation fault
[    4.480123] Data abort info:
[    4.484980]   ISV =3D 0, ISS =3D 0x00000005, ISS2 =3D 0x00000000
[    4.488109]   CM =3D 0, WnR =3D 0, TnD =3D 0, TagAccess =3D 0
[    4.493413]   GCS =3D 0, Overlay =3D 0, DirtyBit =3D 0, Xs =3D 0
[    4.498527] swapper pgtable: 4k pages, 48-bit VAs, pgdp=3D000000008245a0=
00
[    4.503913] [ffffffffaaaaae6a] pgd=3D0000000000000000,
p4d=3D0000000082e0d003, pud=3D0000000000000000
[    4.510605] Internal error: Oops: 0000000096000005 [#1] PREEMPT SMP
[    4.519001] Modules linked in:
[    4.525244] CPU: 3 UID: 0 PID: 61 Comm: kworker/u16:3 Tainted: G
    W          6.12.24-rc1 #1
[    4.528383] Tainted: [W]=3DWARN
[    4.537304] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    4.540268] Workqueue: async async_run_entry_fn
[    4.547032] pstate: 80000005 (Nzcv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=
=3D--)
[    4.551292] pc : regulator_unregister (drivers/regulator/core.c:5885)
[    4.558230] lr : devm_rdev_release (drivers/regulator/devres.c:453)
[    4.563090] sp : ffff8000833abaf0
[    4.567340] x29: ffff8000833abb10 x28: ffff0000045e0000 x27: 00000000000=
001c8
[    4.570563] x26: ffff00000455e040 x25: ffff00000967e200 x24: ffff0000045=
e0000
[    4.577682] x23: ffff80008279ecb0 x22: ffff80008236b82e x21: ffff0000051=
fac00
[    4.584799] x20: ffff000005601010 x19: ffff8000833abbb8 x18: 00000000000=
00002
[    4.591916] x17: 6f74616c75676572 x16: 3a73747365757165 x15: 00000000000=
03730
[    4.599036] x14: ffff83ffffffffff x13: ffff8000833a8000 x12: ffff8000833=
ac000
[    4.606152] x11: 0000000000000000 x10: 0000000000000000 x9 : ffff800080b=
14828
[    4.613272] x8 : d8b163d50d526200 x7 : 3d4e5f454c424954 x6 : 000000004e5=
14553
[    4.620390] x5 : 0000000000000008 x4 : ffff8000821e9c67 x3 : ffff8000833=
aba30
[    4.627508] x2 : ffff0000045e0000 x1 : ffff0000051fac80 x0 : ffffffffaaa=
aaaaa
[    4.634626] Call trace:
[    4.641732] regulator_unregister (drivers/regulator/core.c:5885)
[    4.643993] devm_rdev_release (drivers/regulator/devres.c:453)
[    4.648505] release_nodes (drivers/base/devres.c:506)
[    4.652410] devres_release_all (drivers/base/devres.c:0)
[    4.655970] really_probe (drivers/base/dd.c:551 drivers/base/dd.c:724)
[    4.659963] __driver_probe_device (drivers/base/dd.c:0)
[    4.663610] driver_probe_device (drivers/base/dd.c:830)
[    4.667863] __device_attach_driver (drivers/base/dd.c:959)
[    4.671858] bus_for_each_drv (drivers/base/bus.c:459)
[    4.676370] __device_attach_async_helper
(arch/arm64/include/asm/jump_label.h:32 drivers/base/dd.c:988)
[    4.680541] async_run_entry_fn
(arch/arm64/include/asm/jump_label.h:32 kernel/async.c:131)
[    4.685578] process_scheduled_works (kernel/workqueue.c:3234
kernel/workqueue.c:3310)
[    4.689481] worker_thread (include/linux/list.h:373
kernel/workqueue.c:946 kernel/workqueue.c:3392)
[    4.694251] kthread (kernel/kthread.c:391)
[    4.697810] ret_from_fork (arch/arm64/kernel/entry.S:861)
[ 4.701203] Code: d5384108 f9430508 f81f83a8 b4000bc0 (f941e014)
All code
=3D=3D=3D=3D=3D=3D=3D=3D

Code starting with the faulting instruction
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
[    4.704767] ---[ end trace 0000000000000000 ]---
[   14.260348] amba 802000.stm: deferred probe pending: (reason unknown)


## Source
* Kernel version: 6.12.24-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-st=
able-rc.git
* Git sha: dacb3f332e4ba2858eafa0751719b49210dd42b0
* Git describe: v6.12.23-394-gdacb3f332e4b
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.23-394-gdacb3f332e4b
* Architectures: arm64
* Toolchains: clang-20, gcc-13
* Kconfigs: allmodconfig, allyesconfig

## Build arm64
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.=
y/build/v6.12.23-394-gdacb3f332e4b/testrun/28151361/suite/build/test/gcc-13=
-allmodconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.23-394-gdacb3f332e4b/testrun/28151361/suite/build/test/gcc-13-allmodconfig=
/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.23-394-gdacb3f332e4b/testrun/28151361/suite/build/test/gcc-13-allmodconfig=
/details/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2vrxJK=
d5cYfMrf4mhq0ZAf3TEkr/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2vrxJKd5cYfMrf4mhq0Z=
Af3TEkr/config

## Steps to reproduce on arm64
- tuxmake --runtime podman --target-arch arm64 --toolchain gcc-13
--kconfig allmodconfig

## Boot arm64 dragonboard-410c
* Boot log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y=
/build/v6.12.23-394-gdacb3f332e4b/testrun/28151352/suite/boot/test/clang-20=
-lkftconfig/log
* Boot history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.23-394-gdacb3f332e4b/testrun/28151352/suite/boot/test/clang-20-lkftconfig/=
history/
* Boot details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.23-394-gdacb3f332e4b/testrun/28151352/suite/boot/test/clang-20-lkftconfig/=
details/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2vrxIB=
P42aRa8k5i0MyTK2ZgRA8/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2vrxIBP42aRa8k5i0MyT=
K2ZgRA8/config

--
Linaro LKFT
https://lkft.linaro.org
