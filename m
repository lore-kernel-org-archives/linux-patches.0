Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DEB189B8B
	for <patches@lists.linux.dev>; Sat, 14 Dec 2024 10:56:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734173798; cv=none; b=dLcB5b3gIKGNHkGKlnCQiYRY7Dr1yMdWIXslm1GSL5S4Elj/Qx1jwl68YGDQgsqFJ3musp4dAMR2indkFm/4O6uGogIjHsAObdmY6Wh2TLU3B9C9dWeZVblkh+zPINYK0JczEW+9oD4FETuPEi6/u2htc0r376YFQ1c1nwub5mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734173798; c=relaxed/simple;
	bh=SwgLmHir7iw5XKBVoy6nlfxS98I0Q5lW41Q/AqTrYSY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jrwJY8cSe/LyiW+xEkad0K3fT2BHBthpG7rMYIrvMG0iJLYk5xcH6KfK2uHaBZSk1McKcGmwaWGIlk6LKuISja6RGIrkOKp8db2Cymri1+zpETA20STsoowoKgbVv8genQHr/IvwYTVKklLw+twXdgabt8CxLnEsNRNahc8ZivM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=xPFX8zg/; arc=none smtp.client-ip=209.85.217.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xPFX8zg/"
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-4afe4f1ce18so686308137.3
        for <patches@lists.linux.dev>; Sat, 14 Dec 2024 02:56:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734173793; x=1734778593; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=narLqxaJwE3g0of16nAyBHPw88Usne8YUFy2RA1V1Gs=;
        b=xPFX8zg//PmtkpbQvVBfvUlTaxS48EGtKCmI19mJrwPu5zVFRg02Mw31G0zlGRSShH
         QcAbuZkcmK0756btHq0QazVu81vUpdSmw+OUk3lNKwJ9kuiEKh2mq0vIoyn07a91eaHg
         F2tgnf84i78YspfH1TImh3XjxvxxklLSdXFHOQojgZ1EbvP/hQO4wqF0deuPeBehp/v/
         lnHGyB2QiFadGyeVOPzmMQQGpdcolI6MaeNA6goec60Eno656ZXjvZ+5F5V4jc7YyHCm
         /AUUypG2zmBir2HJP4nUkJ/ACQfPNZ3HAKtPfhCd+99nG0xNNQ2lhXqeB2OIkDNSVbU9
         9MTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734173793; x=1734778593;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=narLqxaJwE3g0of16nAyBHPw88Usne8YUFy2RA1V1Gs=;
        b=b9YmLO9GGqkCYfi7RXd/IWCg6e9WjFZPBcfmOf56t2u8Po91UknJQiy4aYOKSWEuqs
         KKkqCw2kor1raymrZC5WI6o8kxamI2r0riokA6Jl8Im48090oPiZbBA3q7h6qZMYBA7w
         fOuVHodvuah0qaXstXN4dXsGF8muphw1RDPwxVcuQGF7RA9pxI90B4ORzd7Y6jZEiBiC
         zLPLPdZcFBnAZGiU8jSbpNk6Wj+rcC78A9F57xvv4XcNNS5XijsrWvbvu02DNLnSPHIL
         /COq9RFEjhQGMvnPqOdPcBvQNCNHg4E1pe/GdYXHO0ghaE141L4FQoXiEn2+520PDL+R
         H8aw==
X-Forwarded-Encrypted: i=1; AJvYcCX9++jqNr0wpm68yYleVck2CGYlPUHlh7AQXN+B1gf0hMFTueEuEHdYgTnP+bA8HW7iwmDbdtio@lists.linux.dev
X-Gm-Message-State: AOJu0YxHA6bc/5eqnGOHYctBbJA22aLRAlsmN4DnkT05J1I8pakIgDdK
	XpTLEit6Td0o2adZacQWzUWdMk/1f/rj6pJT8Ff6yPdazgrOrGmteajzqGQ5/fLqELwgOjUYkJJ
	shSuUjoc0D3/2HcG7O6lxwA+NCI33IAle4jxNaw==
X-Gm-Gg: ASbGncuOCUtLfspEf+9EyFlNEz+8gmTyBdibQm2D/4SlC4NFsB9rGNCcgTtQoJq7Dqx
	NnFv+BlgNa/8RkBKQRBHNCNAyB6h4dkZ4RRheUlyQspjgqyVzL9G27riBoTHgpBZZLCkLmWs=
X-Google-Smtp-Source: AGHT+IEqQWhBWWG+leHF6WEWvTIhZKnROuv/ysScTSqBxjTzOD3slKUGgagixsSpZrByTkB5UBK14VZRj/ryjeEJSHE=
X-Received: by 2002:a05:6102:54a8:b0:4af:d487:45ef with SMTP id
 ada2fe7eead31-4b25d95e5ddmr6550643137.5.1734173792686; Sat, 14 Dec 2024
 02:56:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241213150009.122200534@linuxfoundation.org>
In-Reply-To: <20241213150009.122200534@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 14 Dec 2024 16:26:21 +0530
Message-ID: <CA+G9fYv6RgaCka6p7-wcsFaOfjEXDeXWNCpYP0T8aGjSiyOK+A@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/772] 6.1.120-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Luo Qiu <luoqiu@kylinsec.com.cn>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>, 
	Ard Biesheuvel <ardb@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 13 Dec 2024 at 20:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.120 release.
> There are 772 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 15 Dec 2024 14:57:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.120-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The Dragonboard 845c boot failed on the Linux stable-rc linux-6.1.y
due to the following boot crash log.

This issue is observed exclusively when the kernel is built with GCC-13.
However, the same kernel built with Clang-19 and Clang-nightly
successfully boots.

First seen on 6.1.120-rc1
Good: v6.1.119
BAD: 6.1.120-rc1 and 6.1.120-rc2
Toolchain: gcc-13

Boot log:
----------
[    0.000000] Booting Linux on physical CPU 0x0000000000 [0x517f803c]
[    0.000000] Linux version 6.1.120-rc2 (tuxmake@tuxmake)
(aarch64-linux-gnu-gcc (Debian 13.3.0-5) 13.3.0, GNU ld (GNU Binutils
for Debian) 2.43.1) #1 SMP PREEMPT @1734104611
[    0.000000] Machine model: Thundercomm Dragonboard 845c
[    0.000000] efi: UEFI not found.
[    0.000000] earlycon: qcom_geni0 at MMIO 0x0000000000a84000
(options '115200n8')
[    0.000000] printk: bootconsole [qcom_geni0] enabled
[    0.000000] NUMA: No NUMA configuration found
[    0.000000] NUMA: Faking a node at [mem
0x0000000080000000-0x000000017df9ffff]
[    0.000000] NUMA: NODE_DATA [mem 0x17d5a2a00-0x17d5a4fff]
[    0.000000] Zone ranges:
[    0.000000]   DMA      [mem 0x0000000080000000-0x00000000ffffffff]
[    0.000000]   DMA32    empty
[    0.000000]   Normal   [mem 0x0000000100000000-0x000000017df9ffff]
[    0.000000] Movable zone start for each node
[    0.000000] Early memory node ranges
[    0.000000]   node   0: [mem 0x0000000080000000-0x00000000856fffff]
[    0.000000]   node   0: [mem 0x0000000085700000-0x0000000085cfffff]
[    0.000000]   node   0: [mem 0x0000000085d00000-0x0000000085dfffff]
[    0.000000]   node   0: [mem 0x0000000085e00000-0x0000000085efffff]
[    0.000000]   node   0: [mem 0x0000000085f00000-0x0000000085fbffff]
[    0.000000]   node   0: [mem 0x0000000085fc0000-0x00000000890fffff]
[    0.000000]   node   0: [mem 0x0000000089100000-0x000000008aafffff]
[    0.000000]   node   0: [mem 0x000000008ab00000-0x000000008c416fff]
[    0.000000]   node   0: [mem 0x000000008c417000-0x000000008c4fffff]
[    0.000000]   node   0: [mem 0x000000008c500000-0x0000000097bfffff]
[    0.000000]   node   0: [mem 0x0000000097c00000-0x000000009d3fffff]
[    0.000000]   node   0: [mem 0x000000009d400000-0x000000009f7fffff]
[    0.000000]   node   0: [mem 0x000000009f800000-0x000000017df9ffff]
[    0.000000] Initmem setup node 0 [mem 0x0000000080000000-0x000000017df9ffff]
[    0.000000] On node 0, zone Normal: 8288 pages in unavailable ranges
[    0.000000] cma: Reserved 32 MiB at 0x00000000fe000000
[    0.000000] psci: probing for conduit method from DT.
[    0.000000] psci: PSCIv1.1 detected in firmware.
[    0.000000] psci: Using standard PSCI v0.2 function IDs
[    0.000000] psci: MIGRATE_INFO_TYPE not supported.
[    0.000000] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000d7c
[    0.000000] Mem abort info:
[    0.000000]   ESR = 0x0000000096000004
[    0.000000]   EC = 0x25: DABT (current EL), IL = 32 bits
[    0.000000]   SET = 0, FnV = 0
[    0.000000]   EA = 0, S1PTW = 0
[    0.000000]   FSC = 0x04: level 0 translation fault
[    0.000000] Data abort info:
[    0.000000]   ISV = 0, ISS = 0x00000004
[    0.000000]   CM = 0, WnR = 0
[    0.000000] [0000000000000d7c] user address but active_mm is swapper
[    0.000000] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[    0.000000] Modules linked in:
[    0.000000] CPU: 0 PID: 0 Comm: swapper Not tainted 6.1.120-rc2 #1
[    0.000000] Hardware name: Thundercomm Dragonboard 845c (DT)
[    0.000000] pstate: 600000c5 (nZCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    0.000000] pc : arm_smccc_version_init (drivers/firmware/smccc/smccc.c:31)
[    0.000000] lr : psci_probe (drivers/firmware/psci/psci.c:597
drivers/firmware/psci/psci.c:642)
[    0.000000] sp : ffffabcd52e33ce0
[    0.000000] x29: ffffabcd52e33ce0 x28: 0000000081000200 x27: ffffabcd51fe4930
[    0.000000] x26: ffffabcd52029280 x25: ffffabcd53237d60 x24: ffffabcd51c084c0
[    0.000000] x23: ffffabcd53437318 x22: 0000000000000001 x21: ffffabcd52e5abd8
[    0.000000] x20: ffffabcd53437000 x19: 0000000000010002 x18: 0000000000000006
[    0.000000] x17: 6666663966643731 x16: 3030303030303078 x15: ffffabcd52e337c0
[    0.000000] x14: 0000000000000000 x13: 2e646574726f7070 x12: 757320746f6e2045
[    0.000000] x11: 5059545f4f464e49 x10: ffffabcd52ebb878 x9 : ffffabcd52e63878
[    0.000000] x8 : ffffabcd52e33ca8 x7 : 0000000000000000 x6 : 0000000000000000
[    0.000000] x5 : ffffabcd53437000 x4 : ffffabcd52207000 x3 : 0000000000000000
[    0.000000] x2 : 0000000000000000 x1 : 0000000000000001 x0 : 0000000000000000
[    0.000000] Call trace:
[    0.000000] arm_smccc_version_init (drivers/firmware/smccc/smccc.c:31)
[    0.000000] psci_0_2_init (drivers/firmware/psci/psci.c:675)
[    0.000000] psci_1_0_init (drivers/firmware/psci/psci.c:720)
[    0.000000] psci_dt_init (drivers/firmware/psci/psci.c:758)
[    0.000000] setup_arch (arch/arm64/kernel/setup.c:354)
[    0.000000] start_kernel (init/main.c:278 init/main.c:476 init/main.c:963)
[    0.000000] __primary_switched (arch/arm64/kernel/head.S:469)
[ 0.000000] Code: 1a9f97e0 14000002 52800000 b0fff644 (b94d7cc2)
All code
========
   0: 1a9f97e0 cset w0, hi // hi = pmore
   4: 14000002 b 0xc
   8: 52800000 mov w0, #0x0                    // #0
   c: b0fff644 adrp x4, 0xffffffffffec9000
  10:* b94d7cc2 ldr w2, [x6, #3452] <-- trapping instruction

Code starting with the faulting instruction
===========================================
   0: b94d7cc2 ldr w2, [x6, #3452]
[    0.000000] ---[ end trace 0000000000000000 ]---
[    0.000000] Kernel panic - not syncing: Attempted to kill the idle task!
[    0.000000] ---[ end Kernel panic - not syncing: Attempted to kill
the idle task! ]---

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Links:
-------
Boot failed with gcc-13:
-----------------
- https://lkft.validation.linaro.org/scheduler/job/7998804
- https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.119-773-gcb4fbe91b7b2/testrun/26315180/suite/boot/test/gcc-13-lkftconfig/log
- https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.119-773-gcb4fbe91b7b2/testrun/26315180/suite/boot/test/gcc-13-lkftconfig/history/
- https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.119-773-gcb4fbe91b7b2/testrun/26315180/suite/boot/test/gcc-13-lkftconfig/details/

Boot pass with clang-19:
------------------
- https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.119-773-g9f320894b9c2/testrun/26290281/suite/boot/test/clang-19-lkftconfig/history/


metadata:
----
Linux kernel version: 6.1.120-rc2 and 6.1.120-rc1
git describe: v6.1.119-773-gcb4fbe91b7b2
git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
git sha: cb4fbe91b7b21057b4bc23c91e5fd87c0fb79e47
kernel config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2qATClPBY52T2swKNeLeVQtyyS1/config
build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2qATClPBY52T2swKNeLeVQtyyS1/
toolchain: gcc-13
config: gcc-13-defconfig
arch: arm64
device: Dragonboard-845c


--
Linaro LKFT
https://lkft.linaro.org
