Received: from mail-pf1-f174.google.com (mail-pf1-f174.google.com [209.85.210.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63FFD42056
	for <patches@lists.linux.dev>; Mon, 18 Aug 2025 19:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755545699; cv=none; b=o7a47jbuSV7BUFTsFCWANDRkLnK/rxKPQaKbBn8ujhu9C5yhnaMhrA/80KgObWVkSRLYtWunCsOghhFPdBd/+2vvfWr0rwUelrjpLPEvTV99jN1UwrjXQZOOID9OMvBc3ftLt+8y4u4XAP1qa3AF4QeCvSvkXTqI5UOrudSz3mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755545699; c=relaxed/simple;
	bh=fJVgysxWJtebeZkRpkEKP+ZTzL2YFsbUmhTBeevlDH0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uQUtdHzqrzkPwI5rKInw0e6rp8HfcGqBFA+LNGsC6ImkEZ15bhcezPfYz0nT8WT84O6aALbJSslsAnxdIiklP/t0/Gf/3TccJuDT1nMyVGrOE/pBAsOgIc2l+GZWKjpKmYXTwXvM8p0auCrAcEM6gPwUUyDmWbXLPicd+6v6SZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sdhz6X5e; arc=none smtp.client-ip=209.85.210.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sdhz6X5e"
Received: by mail-pf1-f174.google.com with SMTP id d2e1a72fcca58-76e39ec6f30so3522840b3a.2
        for <patches@lists.linux.dev>; Mon, 18 Aug 2025 12:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755545697; x=1756150497; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sk4g/V8NvBfNXQ3D3vbeKt4dIWO1NyjBCxlvh1AtG00=;
        b=sdhz6X5eN8in3xkyUVaPMfYg58xreLcM9HOpa+4amBzrN0TOjBU+tunEwAzX1XbT6t
         wLgXrvOlmuWlAHn5bqYrTY0HJZLGTNYcaEeymKlDdwENovSzJcrbd+tYMSMtfOEToKAr
         0MhZWVr2eW/pHJyPKrGPbgT1t3V/RpitqBjo2rqWGJUxGQGi3F8wimcfT5JLfle0fvjV
         UkijL5LO6a5A5UKgIV+2NgLqa60W5WLCvh4nsQn7DNbdAzeNfNNQ7Tael6DVBfhOv6SD
         +qvjjFiPRoXlrujns5ylGh02AMnNZ704zF9mJJ5mSEVAFwTf3C/UKNOOu6LGZ9Dmh+Xn
         LLgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755545697; x=1756150497;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sk4g/V8NvBfNXQ3D3vbeKt4dIWO1NyjBCxlvh1AtG00=;
        b=IIz6/jZWdXe3xB2Xe48XSusTcLX4gHHWn2CAU5issEqQWuEzvepbMQkV5R+NmjL/5c
         z24umDj/cBDNrK5TWChHS6AeP2rXeqtssg1jEj0uRjWvtLwDwxIUJgV7fWEqujbrEhOp
         mCkftKqpqGO0XHyKK83AjVQVqGNxOemnILRZ/yKb6VR23NedF039KOh82o1skoAlch2W
         o+SRoGyNHYDboiRx7GjMd9F63wngmZFXC35iv6Qbnuu/3L9m44k1rtvAENL0FugTlqyd
         ry9VyxbMWTMcgZhZUzVeu8CTrlMBdv/sh5ep5mGOnZ9srht3GERVw0ZzFe24PinyUVkd
         khMw==
X-Forwarded-Encrypted: i=1; AJvYcCVWPZA8Kk+CSJfZd7hYrAjWT/ZHirZ1Sg6BexCcgpiPrMLa9x7Srisw5YKnXn/VZtGahLny7l5h@lists.linux.dev
X-Gm-Message-State: AOJu0YwGpSgwmzu++PxsEmp+EOOT7jFENDjxsoFVwH7tNyetKpUwYz05
	dKiVK+siGaMtiK/3mO4bEeAK5Syq8nRTgv70p6Ax2Jzqse6XCR1sB59YiIg7ydZq01Lp/E72+2l
	P5d5GcebHFHiiZN4SqHf/3q00rinl0O+fAgjL/GEh0g==
X-Gm-Gg: ASbGncvrTOghHf67GSk4fsjIRRlBINqPiJSozyZ9NI05KRX2wQRNaP1qg2YTQ+tIgmG
	SDehnA0glrMSpbKg3ekXdWL/UB6oWpSVSbxa0cEUeXeRFTsljgnvZduPr9Cjoc4LOsN1c+0dXGx
	TarcfKXb2hGhGZdewLfIYBVXIRjn1WcebdbIrm7ganl19UvuadSanrPItzx3vYFQAoGXGw6y12W
	1INwzyueKGgy9TqDacdb5+MShByDCjJFCizNzqo
X-Google-Smtp-Source: AGHT+IGD+22SoOjTZ/FihjINPgZbyDR9tilIU2io9YzP5E/2FmaTF0iTg1KKmWTZa6umDawDeEhyqZj2WXxqG1b0GLs=
X-Received: by 2002:a17:902:f707:b0:240:3b9e:dd65 with SMTP id
 d9443c01a7336-2447902c839mr167746595ad.38.1755545696560; Mon, 18 Aug 2025
 12:34:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250818124448.879659024@linuxfoundation.org>
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 19 Aug 2025 01:04:44 +0530
X-Gm-Features: Ac12FXyjNRdpUahtphWIIZFImuMzxQuvbQbDP7xtaevXbgmxzYAExeWGREkRos8
Message-ID: <CA+G9fYtuPjHbz_-sJtQHn+JjaVosBRcncZnqT+wgXEvRGc=cfg@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/444] 6.12.43-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, 
	Ben Copeland <benjamin.copeland@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Bjorn Andersson <andersson@kernel.org>, Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, 
	srinivas.kandagatla@oss.qualcomm.com
Content-Type: text/plain; charset="UTF-8"

On Mon, 18 Aug 2025 at 18:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.43 release.
> There are 444 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Aug 2025 12:43:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.43-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Boot regression occurs on the Qualcomm DragonBoard 410c (arm64) with
stable-rc 6.12.43-rc1. The kernel crashes during early boot with a
NULL pointer dereference in the Qualcomm SCM/TZMEM subsystem.

The crash originates in qcom_scm_shm_bridge_enable()
(drivers/firmware/qcom/qcom_scm.c) and is invoked by
qcom_tzmem_enable() (drivers/firmware/qcom/qcom_tzmem.c).
This happens while probing SCM during platform initialization, preventing
the board from reaching userspace due to kernel panic.

Regression Analysis:
- New regression? yes
- Reproducibility? yes

Boot regression: stable-rc 6.12.43-rc1 arm64 Qualcomm Dragonboard 410c
kernel NULL pointer dereference qcom_scm_shm_bridge_enable
qcom_tzmem_enable

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Test log
[    1.136454] scmi_core: SCMI protocol bus registered
[    1.138666] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000000
[    1.142955] Mem abort info:
[    1.151940]   ESR = 0x0000000096000004
[    1.154445]   EC = 0x25: DABT (current EL), IL = 32 bits
[    1.158283]   SET = 0, FnV = 0
[    1.163744]   EA = 0, S1PTW = 0
[    1.166596]   FSC = 0x04: level 0 translation fault
[    1.169654] Data abort info:
[    1.174508]   ISV = 0, ISS = 0x00000004, ISS2 = 0x00000000
[    1.177627]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[    1.182937]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[    1.188062] [0000000000000000] user address but active_mm is swapper
[    1.193447] Internal error: Oops: 0000000096000004 [#1] PREEMPT SMP
[    1.199761] Modules linked in:
[    1.205740] CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted 6.12.43-rc1 #1
[    1.208875] Hardware name: Qualcomm Technologies, Inc. APQ 8016 SBC (DT)
[    1.215733] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[    1.222676] pc : qcom_scm_shm_bridge_enable
(drivers/firmware/qcom/qcom_scm.c:1378)
[    1.229356] lr : qcom_tzmem_enable
(drivers/firmware/qcom/qcom_tzmem.c:97
drivers/firmware/qcom/qcom_tzmem.c:474)
[    1.234561] sp : ffff80008002b720
[    1.238984] x29: ffff80008002b7b0 x28: 0000000000000000 x27: 0000000000000000
[    1.242294] x26: 0000000000000000 x25: 0000000000000000 x24: ffff00003fafaf18
[    1.249412] x23: ffff00003facfc98 x22: 0000000000000000 x21: ffff0000036b2410
[    1.256531] x20: ffff0000036b2400 x19: ffff800083031000 x18: ffff0000036e8000
[    1.263649] x17: 0000000000000100 x16: 0000000000000160 x15: fffffffffffffffe
[    1.270767] x14: ffffffffffffffff x13: ffff800080028000 x12: ffff80008002c000
[    1.277885] x11: 0000000000000000 x10: 0000000000000019 x9 : ffff80008136164c
[    1.285002] x8 : 0000000000000000 x7 : 7f7f7f7f7f7f7f7f x6 : fefefeff35302f37
[    1.292121] x5 : 8080808000000000 x4 : 0000000000000020 x3 : ffff80008002b710
[    1.299240] x2 : 000000000000001c x1 : 000000000000000c x0 : 0000000000000000
[    1.306359] Call trace:
[    1.313462] qcom_scm_shm_bridge_enable
(drivers/firmware/qcom/qcom_scm.c:1378)
[    1.315726] qcom_tzmem_enable
(drivers/firmware/qcom/qcom_tzmem.c:97
drivers/firmware/qcom/qcom_tzmem.c:474)
[    1.320584] qcom_scm_probe (drivers/firmware/qcom/qcom_scm.c:2009)
[    1.324663] platform_probe (drivers/base/platform.c:1405)
[    1.328309] really_probe (drivers/base/dd.c:581 drivers/base/dd.c:657)
[    1.332128] __driver_probe_device (drivers/base/dd.c:0)
[    1.335777] driver_probe_device (drivers/base/dd.c:829)
[    1.340116] __driver_attach (drivers/base/dd.c:1216)
[    1.344107] bus_for_each_dev (drivers/base/bus.c:369)
[    1.347928] driver_attach (drivers/base/dd.c:1233)
[    1.352094] bus_add_driver (drivers/base/bus.c:676)
[    1.355653] driver_register (drivers/base/driver.c:247)
[    1.359212] __platform_driver_register (drivers/base/platform.c:867)
[    1.363035] qcom_scm_init (drivers/firmware/qcom/qcom_scm.c:2115)
[    1.367891] do_one_initcall (init/main.c:1269)
[    1.371538] do_initcall_level (init/main.c:1330)
[    1.375097] do_initcalls (init/main.c:1344)
[    1.379262] do_basic_setup (init/main.c:1367)
[    1.382563] kernel_init_freeable (init/main.c:1584)
[    1.386384] kernel_init (init/main.c:1471)
[    1.390722] ret_from_fork (arch/arm64/kernel/entry.S:846)
[ 1.393940] Code: a905ffff a904ffff a903ffff f9001bff (f9400100)
All code
========

Code starting with the faulting instruction
===========================================
[    1.397767] ---[ end trace 0000000000000000 ]---
[    1.403793] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x0000000b
[    1.408446] SMP: stopping secondary CPUs
[    1.415825] ---[ end Kernel panic - not syncing: Attempted to kill
init! exitcode=0x0000000b ]---

Please refer the full test log information in the below links.

## Source
* Kernel version: 6.12.43-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git describe: v6.12.41-814-gd65072433784
* Git commit: d6507243378459e7fbd4a142a0b195f4cd3f713b
* Architectures: arm64 Dragonboard 410c
* Toolchains: gcc-13, clang-20
* Kconfigs: defconfig+lkft

## Test
* Boot log: https://qa-reports.linaro.org/api/testruns/29585571/log_file/
* Boot lava log: https://lkft.validation.linaro.org/scheduler/job/8407180#L2638
* Boot details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.12.y/v6.12.41-814-gd65072433784/log-parser-boot/panic-multiline-kernel-panic-not-syncing-attempted-to-kill-init-exitcode/
* Boot plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/31SgOm3HeBT4mwsDOOESkOLRK93
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/31SgLgEU5QMBwix6uJ2Xzs56tq3/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/31SgLgEU5QMBwix6uJ2Xzs56tq3/config

--
Linaro LKFT
https://lkft.linaro.org
