Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A60E175BF
	for <patches@lists.linux.dev>; Mon, 18 Aug 2025 19:22:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755544945; cv=none; b=A9+GS0tFyFqJA1Hg6empEaVfnlnemCwemGtnvgtdw/njoqL4wVcKn3U1FVWSXeGiC9eV5AThw/hAjrfthVzD7iwudXKfb/oWHdDRgAokySwnjsWaZzhRonEpn512UfgS+sT7eYpaJXDHwgMk2DNwMJGu/MaZqTMxkndqXR7MKbA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755544945; c=relaxed/simple;
	bh=fx5mISMkXEo1Bxd5OoP9xVO95F0DiAh3Hh+crbMmAEA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=q+tR6JHoyV0rjBqWKGn12oquKN2wiVaZQFdA1R5U+CZNytJzIyoatF0xgZvWjAaaP+nr7SSDtD9J+27/zBgOheGCly0VE9tRA/1LFOsTjhz4DXDc3J4fXZ2vjuQn6//xq1WJqw3y1Aq+x0dGnMM6rQDv3Jbw20utw+f11su6Z+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DM3PvbNu; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DM3PvbNu"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b474d0f1d5eso694682a12.2
        for <patches@lists.linux.dev>; Mon, 18 Aug 2025 12:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755544943; x=1756149743; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=toQPxHiy1KMHSW6a7UOwaU4onC0FC5huJ+T+rOz/mHw=;
        b=DM3PvbNuotyui/DV32G+DqMuFmOw2PaTPeDgfKMoql4zkHZMa/C7IOTi0FXb7xlErs
         kKf6P1ub4UAPRQhwIxHY2p15SrtlPuymPipy4ySfCJTdciJ30r3tv8tdj9YFZxc6hB9q
         38oqBt2KFKsoWdfvbZsX68Jr40SpWwzZ59SYKaChgRjZn4UDNm+WoVLx/dHCH6WZyELf
         WdUC4vB0qICd+/fryghLEGd3ISf5bNHAWaWsLtKSgJNjvxgAgvgljXgdBwGipBaVal1h
         Eh6hKOjLDW082jXlUlUt1iAmPvKCC2XCIqTTJLGRgG8mtBbVFhMVCBZiAAlIht3o1q9e
         mb5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755544943; x=1756149743;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=toQPxHiy1KMHSW6a7UOwaU4onC0FC5huJ+T+rOz/mHw=;
        b=gHAqEF9VsWP8BF5+R7WlA+T854uWzKhZ2hzhEhzq150WUEhXdHM6GQ4Q/MK2E83H3g
         BNW/z16FvEoM7y4vDeIZFSijtSddq9b9ixZ41rJj1t77/xxm6Qhpr07pQ2RRZyNxsv8S
         bKZXE1/9YH7rvi/ZLJ24mGuEExl0D7Q/RXfgQe50/qoe00OtPaxfApx9vxs5s6qvTsnJ
         AOOA2fq5DMbd1bbFz+wk1YT8lPYQQlKFo9KBUtxlModma00ZXNQIQLqC0PbMr+d/oE+6
         ySFygQ7PyW8i/5EBrR2IsZ8bOlFxmZYb3J+NCFgIiD7JH7LFC8HO+xdKTQb0sr0ur2At
         NYNQ==
X-Forwarded-Encrypted: i=1; AJvYcCXlpv6k8o+wGZd34JL4Xe80Q1WBZENJWeBmWed9Sh9+Ya3ujokBPl5GFtWROwyAORmKBTfF5GbZ@lists.linux.dev
X-Gm-Message-State: AOJu0YzS1rcHEkVRr+QR3NGheFVoVNL6IBM/nWGhHeGvafdhl/2DwB8Q
	otK16FKFQIyQ23iGGUapmaN23IBH+e80KzPhK8QjljUAT/tzaqY0uRSH/a0fxA9RLfzQvMdtwu/
	tNfuKrQOQTp2cmxdJjUGSmoYQm2jKNsV6BjAKC1k2fw==
X-Gm-Gg: ASbGnct+3/Qjl78l2ri1aO8Ot67U9pO6kkfTwmAeB72c/IxlNNYSlVZN5oma8KGWAYz
	gz2ytxCohcTEaaSoRXxKSr3LMu1Sn/EcwD43yUMonDBLo8Y9BEIKH5cu12DMZDf9DYsu+JZEkQt
	jawAFPaj09SPs17xsL2maKsGunSEFHE9UPpaGcVNwWVjfY4kzRiZ4TjBouHJH9eOUa2WIwxiKpa
	AJXDbS861RIGNybTy8ayye9/CB408P9KE8FE77FrqtGlfbrAQHfkkqCE/IYkQ==
X-Google-Smtp-Source: AGHT+IHS9gRRUinlegBP/u/axpgH2+HbfQ/LUYof3SDqB39/z9xyiC0/E6Z/XZ7VMjN7bYH5hslQ9igO/RaNQuVAvKU=
X-Received: by 2002:a17:902:db03:b0:240:8f4:b36e with SMTP id
 d9443c01a7336-2446d8b67eamr205261235ad.34.1755544942812; Mon, 18 Aug 2025
 12:22:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250818124505.781598737@linuxfoundation.org>
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 19 Aug 2025 00:52:11 +0530
X-Gm-Features: Ac12FXwVOEvsYKs2Hj_OhG9gGnWNHFXCh_3DRHC0oFh_uKaf6Yom4JJ2icGbgRA
Message-ID: <CA+G9fYs014sj_hmcu5pROEQoC-bvk3UNcZDHEezsrmcRkzKf8A@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/570] 6.16.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, 
	Ben Copeland <benjamin.copeland@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, Bjorn Andersson <andersson@kernel.org>, 
	srinivas.kandagatla@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 18 Aug 2025 at 19:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.2 release.
> There are 570 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Aug 2025 12:43:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.2-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Boot regression occurs on the Qualcomm DragonBoard 410c (arm64) with
stable-rc 6.16.2-rc1. The kernel crashes during early boot with a
NULL pointer dereference in the Qualcomm SCM/TZMEM subsystem.

The crash originates in qcom_scm_shm_bridge_enable()
(drivers/firmware/qcom/qcom_scm.c) and is invoked by
qcom_tzmem_enable() (drivers/firmware/qcom/qcom_tzmem.c).
This happens while probing SCM during platform initialization, preventing
the board from reaching userspace due to kernel panic.

Regression Analysis:
- New regression? yes
- Reproducibility? yes

Boot regression: stable-rc 6.16.2-rc1 arm64 Qualcomm Dragonboard 410c
kernel NULL pointer dereference qcom_scm_shm_bridge_enable
qcom_tzmem_enable

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Test log
[    1.011897] scmi_core: SCMI protocol bus registered
[    1.014070] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000000
[    1.018776] Mem abort info:
[    1.027774]   ESR = 0x0000000096000004
[    1.030282]   EC = 0x25: DABT (current EL), IL = 32 bits
[    1.034116]   SET = 0, FnV = 0
[    1.039581]   EA = 0, S1PTW = 0
[    1.042433]   FSC = 0x04: level 0 translation fault
[    1.045486] Data abort info:
[    1.050341]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[    1.053464]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[    1.058768]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[    1.063891] [0000000000000000] user address but active_mm is swapper
[    1.069276] Internal error: Oops: 0000000096000004 [#1]  SMP
[    1.075601] Modules linked in:
[    1.081240] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted
6.16.2-rc1 #1 PREEMPT
[    1.084114] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    1.091663] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    1.098607] pc : qcom_scm_shm_bridge_enable
(drivers/firmware/qcom/qcom_scm.c:1618)
[    1.105285] lr : qcom_tzmem_enable
(drivers/firmware/qcom/qcom_tzmem.c:98
drivers/firmware/qcom/qcom_tzmem.c:475)
[    1.110491] sp : ffff80008002b730
[    1.114916] x29: ffff80008002b7c0 x28: 0000000000000000 x27: 0000000000000000
[    1.118226] x26: 0000000000000000 x25: 0000000000000000 x24: ffff00003fcf2028
[    1.125343] x23: ffff00003fcc1798 x22: 0000000000000000 x21: ffff000002cdf410
[    1.132460] x20: ffff000002cdf400 x19: ffff80008288a000 x18: ffff8000813951f0
[    1.139579] x17: 0000000000000000 x16: 00000000ffffffff x15: fffffffffffffc00
[    1.146696] x14: ffffffffffffffff x13: 0000000000000020 x12: 0000000000000002
[    1.153814] x11: 0000000000000000 x10: 0000000000000019 x9 : 0000000000000001
[    1.160932] x8 : 0000000000000000 x7 : 7f7f7f7f7f7f7f7f x6 : fefefeff35302f37
[    1.168052] x5 : 8080808000000000 x4 : 0000000000000020 x3 : 0000000036313038
[    1.175169] x2 : 000000000000001c x1 : 000000000000000c x0 : 0000000000000000
[    1.182289] Call trace:
[    1.189393] qcom_scm_shm_bridge_enable
(drivers/firmware/qcom/qcom_scm.c:1618) (P)
[    1.191658] qcom_tzmem_enable
(drivers/firmware/qcom/qcom_tzmem.c:98
drivers/firmware/qcom/qcom_tzmem.c:475)
[    1.196862] qcom_scm_probe (drivers/firmware/qcom/qcom_scm.c:2259)
[    1.200941] platform_probe (drivers/base/platform.c:1405)
[    1.204587] really_probe (drivers/base/dd.c:581 drivers/base/dd.c:657)
[    1.208408] __driver_probe_device (drivers/base/dd.c:0)
[    1.212055] driver_probe_device (drivers/base/dd.c:829)
[    1.216394] __driver_attach (drivers/base/dd.c:1216)
[    1.220299] bus_for_each_dev (drivers/base/bus.c:369)
[    1.224118] driver_attach (drivers/base/dd.c:1233)
[    1.228285] bus_add_driver (drivers/base/bus.c:679)
[    1.231844] driver_register (drivers/base/driver.c:250)
[    1.235403] __platform_driver_register (drivers/base/platform.c:867)
[    1.239225] qcom_scm_init (drivers/firmware/qcom/qcom_scm.c:2365)
[    1.244083] do_one_initcall (init/main.c:1252 init/main.c:1275)
[    1.247730] do_initcall_level (init/main.c:1335)
[    1.251289] do_initcalls (init/main.c:1349)
[    1.255455] do_basic_setup (init/main.c:1372)
[    1.258666] kernel_init_freeable (init/main.c:1588)
[    1.262488] kernel_init (init/main.c:1476)
[    1.266826] ret_from_fork (arch/arm64/kernel/entry.S:848)
[ 1.270045] Code: a904ffff a903ffff a902ffff a900ffff (f9400100)
All code
========

Code starting with the faulting instruction
===========================================
[    1.273870] ---[ end trace 0000000000000000 ]---
[    1.279875] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x0000000b
[    1.284550] SMP: stopping secondary CPUs
[    1.291930] ---[ end Kernel panic - not syncing: Attempted to kill
init! exitcode=0x0000000b ]---

Please refer full test log information in the below links.

## Source
* Kernel version: 6.16.2-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git describe: v6.16-1192-g7439b60c7df9
* Git commit: 7439b60c7df9cf7683dbfe417d128304e34a4f22
* Architectures: arm64 Dragonboard 410c
* Toolchains: gcc-13, clang-20
* Kconfigs: defconfig+lkft

## Test
* Boot log: https://qa-reports.linaro.org/api/testruns/29589924/log_file/
* Boot lava log: https://lkft.validation.linaro.org/scheduler/job/8407950#L2304
* Boot details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.16.y/v6.16-1192-g7439b60c7df9/log-parser-boot/panic-multiline-kernel-panic-not-syncing-attempted-to-kill-init-exitcode/
* Boot plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/31SnSReSLRhyKacT9vTgYiE9GRJ
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/31SnQ9iEVyT81yLXvTtUzBV7I4A/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/31SnQ9iEVyT81yLXvTtUzBV7I4A/config

--
Linaro LKFT
https://lkft.linaro.org
