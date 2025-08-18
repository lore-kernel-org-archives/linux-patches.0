Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089E126FA70
	for <patches@lists.linux.dev>; Mon, 18 Aug 2025 18:48:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755542927; cv=none; b=XPQfdVjEu7VbgA+YQJXtaQVpP0h1PdUayB/3y1VWmx2yb6G/N1/TsGokr8ETsSVy7ysfvWXU9YAE1qxDsbFrqyUVXCVguHZI62T3yXTwzJ+S3hLKOBRrXz27XWhgPk+1RcS3iKo/6J9NXLAdCEAm99+s17Tu13I0ww+ZfM5nLts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755542927; c=relaxed/simple;
	bh=pcQbWfmvaZOJq8LTxdPwJOEnZsClRjrrGSQ0kCojTns=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TVCU+kRiGfx6VWYhGR4P/gzdbuuG1Z4Zru2RgE6abVJivZYp7eQwZ83ngyph6unfYO1roIvOKYjultCh5bnR+QiJ86btCIhW66611BBryQjEhEg2v7DHZl1RAJrBmYJFsiN8d7zAdv5S4HLJi3GGjIbEEFwhHrb24UB2ErA7Y3Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=zKM00YE/; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zKM00YE/"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-24458317464so49485765ad.3
        for <patches@lists.linux.dev>; Mon, 18 Aug 2025 11:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755542925; x=1756147725; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O1Na1G1GEfTB1Z7+rFe2hu/qJ/LK+DYFvyX3BQfjabc=;
        b=zKM00YE/xTY+VRODgDE+NsNygXMAQsF4oonTj/SHw25vc/s/eabfjRRFyQqM6gpVg/
         t1dg85BLRvvEcqLVUydo2QggmxS7WQ9Ib+H/w4pJVGP1Sr47RABhk6SCebSzI74Su8bm
         HyhGn8IJpFdeYCi+bp0tiNHlNXZI67R4n3CqkmZp414oHMKGn6wRTpqwGXx6fzeETRh2
         dpNARdZuMUnXxUo5pKPgDhq3jpic/PIu+kJJBNkcgb/9HkhJE9xnNtevj7b4GUx/hIr+
         +AvTbyj2uG0kJtObtH79OB94c015pc5ywKcFa2eFPgXvJQn89J2LylY0BCxw8n+fuP7f
         NNzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755542925; x=1756147725;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O1Na1G1GEfTB1Z7+rFe2hu/qJ/LK+DYFvyX3BQfjabc=;
        b=Lac6BP2csQDMQ0yWP301CjBP1/YNuQdUhM1symWL2QDyn+/PFjDu7ovvn4V3Oj+G1i
         TQKixEXXwZFxZaus1M5BWpNPRsLDIg7CjKHDND25snPJJ0/5ie3f73kv9zvO9fJvmFtR
         D2YTH7ILu1hBHtisxDXKiPDYsi0l2Pl9LA7Lbe+rqKL8Vt9YMvqVOXJbTDGpf6rTi1Qb
         0MyIKA3owdEd6rpWvzWcjI9WUKIxMaBPetNXXTTW+y5j96waqTMl5BdnvIw2cfw4+20w
         LnuljnbyAF3tQSNst856JjyNrU3rHOLZp9SqtmpOTJYv0ZfDyRepIg193yHmrby5pkIk
         b4fw==
X-Forwarded-Encrypted: i=1; AJvYcCXOSKw8neiyua6ilodKJw2fZ603rx4oOZhEuTLtrsDIt4W2DqMpiyVszCM6x/Ekz4S+iDc1D8Uy@lists.linux.dev
X-Gm-Message-State: AOJu0YxJsTBFmt+l6FxAP+cbiGcSXb5dF/IRMvp7LY0fv13LhOcZwlRX
	1cZWjJAFK3Xk71b95a1vbANKTxkFD2uyqygsWMx+kB6CGmF6SJxoVTWbQaPbrnzgiqkHnWiWfEO
	v6oT6SnLPVgTkMyqh/66nszr9iX7FSa2WhEShkmuB5A==
X-Gm-Gg: ASbGncvCXvuw5uSpoA6mYhdFLsk2kynVM5xLTaPR68OgjaB9PJoDQM0xjFCUcTwcUaY
	YlPX08jjScLbBu93v5a9b0K6mxLM2pHwE3+QG9RDIUjC6gTCut3siz48rOOyFZZJDMzUA6IUlS0
	lg1ffnHVzz6vCOmFw8J5A7vnpydgSD149Oh1hgL8MbcNMxCfy4dkDkVgOcg4VnAz+gtdtPFi3MG
	qKSHzQeHwyoCSeBPOYL5ENytrG8JmKQmPkxnGfhbFWpp9EPVUM=
X-Google-Smtp-Source: AGHT+IHmOMJz7nCYS/tZ+DC/rzqutFB5PsuRPGV79kAw2iKn1BK0MGU5HrYZKUaPZJ8Wp385fx6Fyv1c//DR81jG32o=
X-Received: by 2002:a17:902:f78a:b0:240:84b:a11a with SMTP id
 d9443c01a7336-2449cf43f7fmr5618825ad.17.1755542925263; Mon, 18 Aug 2025
 11:48:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250818124458.334548733@linuxfoundation.org>
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 19 Aug 2025 00:18:33 +0530
X-Gm-Features: Ac12FXy3q6ijpYJlZM9lDBDRg0-eeJWhMQBu6-QX-xroiq3SJXWRlW-B4Umf5T8
Message-ID: <CA+G9fYt5sknJ3jbebYZrqMRhbcLZKLCvTDHfg5feNnOpj-j9Wg@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/515] 6.15.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, 
	Ben Copeland <benjamin.copeland@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Bjorn Andersson <andersson@kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, 
	Linux ARM <linux-arm-kernel@lists.infradead.org>, srinivas.kandagatla@oss.qualcomm.com, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 18 Aug 2025 at 18:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.11 release.
> There are 515 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Aug 2025 12:43:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Boot regression occurs on the Qualcomm DragonBoard 410c (arm64) with
stable-rc 6.15.11-rc1. The kernel crashes during early boot with a
NULL pointer dereference in the Qualcomm SCM/TZMEM subsystem.

The crash originates in qcom_scm_shm_bridge_enable()
(drivers/firmware/qcom/qcom_scm.c:1618) and is invoked by
qcom_tzmem_enable() (drivers/firmware/qcom/qcom_tzmem.c:97 and :474).
This happens while probing SCM during platform initialization, preventing
the board from reaching userspace due to kernel panic.

Regression Analysis:
- New regression? yes
- Reproducibility? yes

Boot regression: stable-rc 6.15.11-rc1 arm64 Qualcomm Dragonboard 410c
Unable to handle kernel NULL pointer dereference
qcom_scm_shm_bridge_enable

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Test log oom03
[    1.191790] scmi_core: SCMI protocol bus registered
[    1.194074] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000000
[    1.198306] Mem abort info:
[    1.207295]   ESR = 0x0000000096000004
[    1.209796]   EC = 0x25: DABT (current EL), IL = 32 bits
[    1.213635]   SET = 0, FnV = 0
[    1.219095]   EA = 0, S1PTW = 0
[    1.221945]   FSC = 0x04: level 0 translation fault
[    1.225004] Data abort info:
[    1.229874]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[    1.232977]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[    1.238286]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[    1.243409] [0000000000000000] user address but active_mm is swapper
[    1.248798] Internal error: Oops: 0000000096000004 [#1]  SMP
[    1.255110] Modules linked in:
[    1.260744] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted
6.15.11-rc1 #1 PREEMPT
[    1.263622] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    1.271517] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    1.278199] pc : qcom_scm_shm_bridge_enable
(drivers/firmware/qcom/qcom_scm.c:1618)
[    1.284878] lr : qcom_tzmem_enable
(drivers/firmware/qcom/qcom_tzmem.c:97
drivers/firmware/qcom/qcom_tzmem.c:474)
[    1.290085] sp : ffff80008002b720
[    1.294508] x29: ffff80008002b7b0 x28: 0000000000000000 x27: 0000000000000000
[    1.297819] x26: 0000000000000000 x25: 0000000000000000 x24: ffff00003faf6128
[    1.304937] x23: ffff00003fac6c68 x22: 0000000000000000 x21: ffff0000036ba410
[    1.312055] x20: ffff0000036ba400 x19: ffff8000831a4000 x18: 0000000000000352
[    1.319173] x17: 0000000000000000 x16: 0000000000000001 x15: 0000000000000002
[    1.326292] x14: ffffffffffffffff x13: 0000000000000000 x12: 0000000000000002
[    1.333410] x11: 0000000000000000 x10: 0000000000000019 x9 : ffff8000813e6d74
[    1.340527] x8 : 0000000000000000 x7 : 7f7f7f7f7f7f7f7f x6 : fefefeff35302f37
[    1.347645] x5 : 8080808000000000 x4 : 0000000000000020 x3 : 0000000000000010
[    1.354763] x2 : 000000000000001c x1 : 000000000000000c x0 : 0000000000000000
[    1.361882] Call trace:
[    1.368986] qcom_scm_shm_bridge_enable
(drivers/firmware/qcom/qcom_scm.c:1618) (P)
[    1.371251] qcom_tzmem_enable
(drivers/firmware/qcom/qcom_tzmem.c:97
drivers/firmware/qcom/qcom_tzmem.c:474)
[    1.376455] qcom_scm_probe (drivers/firmware/qcom/qcom_scm.c:2256)
[    1.380534] platform_probe (drivers/base/platform.c:1405)
[    1.384180] really_probe (drivers/base/dd.c:581)
[    1.387998] __driver_probe_device (drivers/base/dd.c:?)
[    1.391647] driver_probe_device (drivers/base/dd.c:829)
[    1.395987] __driver_attach (drivers/base/dd.c:1216)
[    1.399978] bus_for_each_dev (drivers/base/bus.c:369)
[    1.403798] driver_attach (drivers/base/dd.c:1233)
[    1.407965] bus_add_driver (drivers/base/bus.c:679)
[    1.411523] driver_register (drivers/base/driver.c:250)
[    1.415083] __platform_driver_register (drivers/base/platform.c:867)
[    1.418905] qcom_scm_init (drivers/firmware/qcom/qcom_scm.c:2362)
[    1.423763] do_one_initcall (init/main.c:1257)
[    1.427409] do_initcall_level (init/main.c:1318)
[    1.430969] do_initcalls (init/main.c:1332)
[    1.435134] do_basic_setup (init/main.c:1355)
[    1.438434] kernel_init_freeable (init/main.c:1571)
[    1.442254] kernel_init (init/main.c:1459)
[    1.446593] ret_from_fork (arch/arm64/kernel/entry.S:865)
[ 1.449810] Code: a905ffff a904ffff a903ffff f9001bff (f9400100)
All code
========
   0: a905ffff stp xzr, xzr, [sp, #88]
   4: a904ffff stp xzr, xzr, [sp, #72]
   8: a903ffff stp xzr, xzr, [sp, #56]
   c: f9001bff str xzr, [sp, #48]
  10:* f9400100 ldr x0, [x8] <-- trapping instruction

Code starting with the faulting instruction
===========================================
   0: f9400100 ldr x0, [x8]
[    1.453637] ---[ end trace 0000000000000000 ]---
[    1.459661] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x0000000b
[    1.464318] SMP: stopping secondary CPUs
[    1.471696] ---[ end Kernel panic - not syncing: Attempted to kill
init! exitcode=0x0000000b ]---

Please refer full test log information in the below links.

## Source
* Kernel version: 6.15.11-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git describe: v6.15.9-993-g1cf711608500
* Git commit: 1cf71160850064e9e506eda37e0386948bedd6b4
* Architectures: arm64 Dragonboard 410c
* Toolchains: gcc-13, clang-20
* Kconfigs: defconfig+lkft

## Test
* Boot log: https://qa-reports.linaro.org/api/testruns/29589408/log_file/
* Boot lava log: https://lkft.validation.linaro.org/scheduler/job/8407660#L2708
* Boot details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.15.y/v6.15.9-993-g1cf711608500/log-parser-boot/panic-multiline-kernel-panic-not-syncing-attempted-to-kill-init-exitcode/
* Boot plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/31SjnwYvj7Mmcay6Qa54CFbNfP9
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/31SjkxSlW3Ssjf1eGdFHJPPU4Yw/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/31SjkxSlW3Ssjf1eGdFHJPPU4Yw/config

--
Linaro LKFT
https://lkft.linaro.org
