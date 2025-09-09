Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 388D034166D
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 13:32:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757424731; cv=none; b=uGdA7l+kCgUJPk8GaY1kMVXfwaoB06NyE6DUoul3S5vwZRbQugxPoWk9+9eA7VE3NZnUltVB9xTOOBpZrvh5AieJl/QUdbShY6rx4Bfei10aJRDCUVAvOwBRMe8710CL8n4FfSyVvGavf2aDfikkNK2qheUnxpkUPJDvHF7/1s4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757424731; c=relaxed/simple;
	bh=MomF2wyJOMwN3iFnohg1Ou+EN3lAs2/eJNhByTXiQTQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=WL8raagchw3SAj6IVfVCaz+StAVHu/WnZkcD8C4/+qNMnSq9Ox4kxlvO/xuCQbeQywBoo8agI94o/lUk7T79YynKnOti8Oyi6tzcP7uG9e4pnQpPT7XDTCdd/4dh1HNz4flg3R5ydpVptcWjiOOslcZfSYlkMbjiTVtqlXr6ifY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nRkwKLy5; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nRkwKLy5"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-24c784130e6so62314565ad.3
        for <patches@lists.linux.dev>; Tue, 09 Sep 2025 06:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757424728; x=1758029528; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=6OuPlu3XGxJLSsZ429FE9LPPsRx46iYdSpeh5oGvR2M=;
        b=nRkwKLy57EigyYHzv6yjVWyMWWTq2aOjx0eclzJSKVAYTS+HfUaIcdbZjftWC2irks
         Rt6YGf5AWz0+c0Qsdcc3rNUPdXqnawhIyEGS7D3ixixwryQm+P8Jbwqolsye0hzHMeUW
         w+9QA6s1//SizUxRdxn8ckpweytWYVz/4I4BsB9Y0YnqNvr53sd9etNHqObmkj7ULxlA
         VbNn8HHg3FwR9VdBQnGvl3TZIzLWvBIFcFWL7Z4LZdaRo7XN7M9830mIm17nQ7v+J1o9
         Uv5M3JAqBETw8w18RA+ba2Nxy6B4MTZJWmhWOYrXt2CsAl/NIir3s0HS8mfp2XwDikUt
         KMMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757424728; x=1758029528;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=6OuPlu3XGxJLSsZ429FE9LPPsRx46iYdSpeh5oGvR2M=;
        b=D9R0s2K5Ha165kxM5FQDZbn91aijNMrgJJ4VOH9dwKqXAkyy/R3dE9SsZA/XUx7CkU
         whattYQREs9pUyZ52sEj8jlCAtAl6TfGE4dHTo8ZwhvJyByYNHDNq3BB46Sfc1ZYsk3b
         pGD/J369YlWldq3or6wIK4yKPQpsgoqwxRmyhD+a01u6f/G2qtms44awsw5sDJ4Y0V3l
         YjgtcuLBTaA8mMLvPWyk7JevYhBEb1hO5+TSfPTe1CWEXOlUJSqBVK3FewSlrvSuhDw6
         ljalKo0R/tiZF9T9EYkS6iT83/Y6h1f6wFeidnCbXg3wDS1m49R6fyJUu1rOU1DFypj/
         yc9Q==
X-Forwarded-Encrypted: i=1; AJvYcCXmYMSZ/2mwUwfiUUda+8CzhYq8vEzsuslhmVvaJFWz8lBctan4m0gO33uETGPxGSDGqI408T2s@lists.linux.dev
X-Gm-Message-State: AOJu0Yxvbk69WnLwjyieQryeGAWFMyUfDfMwWLZntH5rH/Fzesx2s7B9
	hilG1v4+/Ku+/UUcTS1b5VNb9aS/ETMBT+ayQA1QMSq95LCXIS5VLpJEgYlFtqGhCPk87Sfwjdo
	EtWHT0qT8MPDHsl9ijSIfSRUYeLr5vIVLXiZZqcWIDQ==
X-Gm-Gg: ASbGncsyKlnaLgvb+elkIeq4UXEPUl6/aAOFcX/Vx1rwqMl5clrurg4rBwV+NZYzQqP
	YtoffrEozwa2DqX2kXn7486oUZ/0e5FWyKlGDDB5zA7pffW/DSrxN+YRMADZixtFkaljNf2qNrE
	SeXbXN6JHpVGioEgxp5555XtqPjTBchNKXiHAf4N4GLqMAqCg3Wg+QUMGDR+WDJ0XoOYSjxdnzo
	3gf6AfElk9wt84sW4ai5n+iMT/yY2/e+M8uUOpdWkJdchnKdIY7QkFQI8nA5e8FRDU85owm
X-Google-Smtp-Source: AGHT+IF4470W62P18nL20C13GNqlEspSADki85kwPxJ0DoiUP2tFXuHRyI6gW+cJ1UDBhG29YUl9d3C6LN7OFkt+zrw=
X-Received: by 2002:a17:902:ced0:b0:258:f033:3ff9 with SMTP id
 d9443c01a7336-258f0334136mr39169725ad.48.1757424727988; Tue, 09 Sep 2025
 06:32:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250908151836.822240062@linuxfoundation.org>
In-Reply-To: <20250908151836.822240062@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 9 Sep 2025 19:01:56 +0530
X-Gm-Features: AS18NWBQJpLqQmKFAywSu14ZRnaxv8fVCMdN_TVwE8XIfccsxJtbB8AA4L2kXAA
Message-ID: <CA+G9fYuWKxiiahB617_mQx8+FaGUqm=x1BgsrNPojDRVm8BadA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/118] 6.6.105-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, Mark Brown <Mark.Brown@arm.com>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Ben Copeland <benjamin.copeland@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	LTP List <ltp@lists.linux.it>
Content-Type: text/plain; charset="UTF-8"

On Mon, 8 Sept 2025 at 21:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.105 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 10 Sep 2025 15:18:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.105-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

While running LTP controllers cgroup_fj_stress.sh testing on Juno-r2 running the
Linux stable-rc 6.6.105-rc2 found these kernel warnings followed by
kernel panic.

Regression Analysis:
- Reproducibility? Not sure

Test regression: stable-rc 6.6.105-rc2 juno-r2 __percpu_counter_sum
(lib/percpu_counter.c:147) kernel panic

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Test log
cgroup_fj_stress_net_prio_1_200_each: start (command:
cgroup_fj_stress.sh net_prio 1 200 each)
[  896.950701] rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
[  896.956815] rcu: t3-...0: (6 GPs behind)
idle=0a4c/1/0x4000000000000000 softirq=118175/118181 fqs=2624
[  896.966146] rcu: t4-...0: (73 GPs behind)
idle=1c44/1/0x4000000000000000 softirq=135797/135789 fqs=2624
[  896.975562] rcu: t(detected by 2, t=5252 jiffies, g=292241, q=10 ncpus=6)
[  896.982362] Task dump for CPU 3:
[  896.985591] task:swapper/3       state:R  running task     stack:0
   pid:0     ppid:1      flags:0x0000000a
[  896.995532] Call trace:
[  896.997978] __switch_to (arch/arm64/kernel/process.c:559)
[  897.001478] __schedule (kernel/sched/core.c:5383 kernel/sched/core.c:6699)
[  897.004971] schedule_idle
(include/asm-generic/bitops/generic-non-atomic.h:128
include/linux/thread_info.h:192 include/linux/sched.h:2260
kernel/sched/core.c:6802)
[  897.008551] __cpu_online_mask+0x0/0x20
[  897.012398] Task dump for CPU 4:
[  897.015626] task:swapper/4       state:R  running task     stack:0
   pid:0     ppid:1      flags:0x0000000a
[  897.025564] Call trace:
[  897.028009] __switch_to (arch/arm64/kernel/process.c:559)
[  897.031502]  0xffff000800b70080
[  902.513737] Unable to handle kernel paging request at virtual
address ffff8008fc7c9000
[  902.521671] Mem abort info:
[  902.524464]   ESR = 0x0000000096000005
[  902.528215]   EC = 0x25: DABT (current EL), IL = 32 bits
[  902.533534]   SET = 0, FnV = 0
[  902.536588]   EA = 0, S1PTW = 0
[  902.539729]   FSC = 0x05: level 1 translation fault
[  902.544612] Data abort info:
[  902.547490]   ISV = 0, ISS = 0x00000005, ISS2 = 0x00000000
[  902.552982]   CM = 0, WnR = 0, TnD = 0, TagAccess = 0
[  902.558038]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[  902.563356] swapper pgtable: 4k pages, 48-bit VAs, pgdp=00000000824a9000
[  902.570067] [ffff8008fc7c9000] pgd=10000009fffff003,
p4d=10000009fffff003, pud=0000000000000000
[  902.578792] Internal error: Oops: 0000000096000005 [#1] PREEMPT SMP
[  902.585070] Modules linked in: tda998x onboard_usb_hub cec
crct10dif_ce hdlcd drm_dma_helper drm_kms_helper fuse drm backlight
ip_tables x_tables
[  902.598177] CPU: 2 PID: 276 Comm: cron Not tainted 6.6.105-rc2 #1
[  902.604282] Hardware name: ARM Juno development board (r2) (DT)
[  902.610208] pstate: 200000c5 (nzCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  902.617182] pc : __percpu_counter_sum (lib/percpu_counter.c:147)
[  902.621729] lr : __percpu_counter_sum (lib/percpu_counter.c:145
(discriminator 3))
[  902.626267] sp : ffff800083723b40
[  902.629583] x29: ffff800083723b40 x28: ffff0008268b3180 x27: ffff0008268b3828
[  902.636739] x26: 0000000000000000 x25: 0000000000000000 x24: ffff8000826434a8
[  902.643893] x23: ffff80008263eac0 x22: ffff80008263ea80 x21: ffff80008263ed00
[  902.651048] x20: ffff0008268a5368 x19: 0000000000000000 x18: ffff8000881c3be8
[  902.658202] x17: 000000040044ffff x16: 00500074b5503510 x15: 0000000000000000
[  902.665356] x14: ffff00080037e300 x13: ffff8008fc807000 x12: 0000000034d4d91d
[  902.672510] x11: 00000000000000c0 x10: 0000000000000c20 x9 : ffff8000815ab818
[  902.679664] x8 : ffff8000837239f8 x7 : 0000000000000000 x6 : 0000000000000000
[  902.686818] x5 : 0000000000000000 x4 : 0000000000000000 x3 : 0000000000000001
[  902.693972] x2 : 0000000000000006 x1 : ffff80008263eac0 x0 : ffff8008fc7c9000
[  902.701126] Call trace:
[  902.703570] __percpu_counter_sum (lib/percpu_counter.c:147)
[  902.707762] __mmdrop (kernel/fork.c:833 (discriminator 1)
kernel/fork.c:928 (discriminator 1))
[  902.710996] finish_task_switch.isra.0 (include/linux/sched/mm.h:54
include/linux/sched/mm.h:82 include/linux/sched/mm.h:109
kernel/sched/core.c:5279)
[  902.715798] __schedule (kernel/sched/core.c:6705)
[  902.719291] schedule (kernel/sched/core.c:6774)
[  902.722522] do_nanosleep (kernel/time/hrtimer.c:1386
kernel/time/hrtimer.c:1513 kernel/time/hrtimer.c:2116)
[  902.726104] hrtimer_nanosleep (kernel/time/hrtimer.c:2163)
[  902.730121] common_nsleep (kernel/time/posix-timers.c:1354)
[  902.733701] __arm64_sys_clock_nanosleep
(kernel/time/posix-timers.c:1397 (discriminator 1)
kernel/time/posix-timers.c:1374 (discriminator 1)
kernel/time/posix-timers.c:1374 (discriminator 1))
[  902.738587] invoke_syscall (arch/arm64/include/asm/current.h:19
arch/arm64/kernel/syscall.c:56)
[  902.742344] el0_svc_common.constprop.0
(include/linux/thread_info.h:127 (discriminator 2)
arch/arm64/kernel/syscall.c:142 (discriminator 2))
[  902.747058] do_el0_svc (arch/arm64/kernel/syscall.c:154)
[  902.750378] el0_svc (arch/arm64/include/asm/daifflags.h:28
arch/arm64/kernel/entry-common.c:133
arch/arm64/kernel/entry-common.c:144
arch/arm64/kernel/entry-common.c:702)
[  902.753525] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:721)
[  902.757890] el0t_64_sync (arch/arm64/kernel/entry.S:599)
[ 902.761559] Code: 52800003 14000005 f860db00 f9401284 (b8a46800)
All code
========
   0: 52800003 mov w3, #0x0                    // #0
   4: 14000005 b 0x18
   8: f860db00 ldr x0, [x24, w0, sxtw #3]
   c: f9401284 ldr x4, [x20, #32]
  10:* b8a46800 ldrsw x0, [x0, x4] <-- trapping instruction

Code starting with the faulting instruction
===========================================
   0: b8a46800 ldrsw x0, [x0, x4]
[  902.767660] ---[ end trace 0000000000000000 ]---
[  902.772281] note: cron[276] exited with irqs disabled
[  902.777363] note: cron[276] exited with preempt_count 2
[  902.786025] ------------[ cut here ]------------
[  902.790650] WARNING: CPU: 1 PID: 1 at kernel/sched/fair.c:5259
place_entity (kernel/sched/fair.c:5259 (discriminator 1))
[  902.798681] Modules linked in: tda998x onboard_usb_hub cec
crct10dif_ce hdlcd drm_dma_helper drm_kms_helper fuse drm backlight
ip_tables x_tables
[  902.811785] CPU: 1 PID: 1 Comm: systemd Tainted: G      D
 6.6.105-rc2 #1
[  902.819456] Hardware name: ARM Juno development board (r2) (DT)
[  902.825383] pstate: 200000c5 (nzCv daIF -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  902.832357] pc : place_entity (kernel/sched/fair.c:5259 (discriminator 1))
[  902.836375] lr : place_entity (kernel/sched/fair.c:5185)
[  902.840304] sp : ffff800082cfbb80
[  902.843619] x29: ffff800082cfbb80 x28: ffff0008002a0000 x27: 0000000000000000
[  902.850775] x26: 0000000000000000 x25: 0000000000000000 x24: 0000000000000001
[  902.857930] x23: 0000000000000400 x22: 0000000000000001 x21: ffff00097edb3780
[  902.865084] x20: 0000003bc78205b3 x19: ffff0008216bf000 x18: ffff800082cfbb08
[  902.872239] x17: ffff000832834408 x16: ffff800081b8d668 x15: 00000000000000dc
[  902.879393] x14: 0000000000000411 x13: 0000000000000000 x12: 0000ffffb41bdbb8
[  902.886547] x11: 0000000000000040 x10: ffff000800883628 x9 : ffff8000800fcb60
[  902.893701] x8 : ffff0008216bf400 x7 : ffff00097edb4170 x6 : 0000000000000400
[  902.900854] x5 : 0000000000000400 x4 : 0000000000000400 x3 : 0000000000000400
[  902.908008] x2 : 0000000000000000 x1 : 0000000000200b20 x0 : 0000000000000000
[  902.915162] Call trace:
[  902.917607] place_entity (kernel/sched/fair.c:5259 (discriminator 1))
[  902.921277] enqueue_entity (kernel/sched/fair.c:188
kernel/sched/fair.c:3644 kernel/sched/fair.c:5324)
[  902.925033] enqueue_task_fair (kernel/sched/fair.c:6768 (discriminator 1))
[  902.929050] activate_task (kernel/sched/core.c:2133)
[  902.932717] wake_up_new_task
(arch/arm64/include/asm/jump_label.h:22 include/linux/jump_label.h:207
include/trace/events/sched.h:185 kernel/sched/core.c:4873)
[  902.936732] kernel_clone (kernel/fork.c:2948 (discriminator 1))
[  902.940401] __do_sys_clone (kernel/fork.c:3058)
[  902.944069] __arm64_sys_clone (kernel/fork.c:3025)
[  902.947998] invoke_syscall (arch/arm64/include/asm/current.h:19
arch/arm64/kernel/syscall.c:56)
[  902.951754] el0_svc_common.constprop.0
(include/linux/thread_info.h:127 (discriminator 2)
arch/arm64/kernel/syscall.c:142 (discriminator 2))
[  902.956468] do_el0_svc (arch/arm64/kernel/syscall.c:154)
[  902.959789] el0_svc (arch/arm64/include/asm/daifflags.h:28
arch/arm64/kernel/entry-common.c:133
arch/arm64/kernel/entry-common.c:144
arch/arm64/kernel/entry-common.c:702)
[  902.962936] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:721)
[  902.967301] el0t_64_sync (arch/arm64/kernel/entry.S:599)
[  902.970967] ---[ end trace 0000000000000000 ]---
[  902.976118] Unable to handle kernel NULL pointer dereference at
virtual address 0000000000000009
[  902.984965] Mem abort info:
[  902.987773]   ESR = 0x0000000096000044
[  902.991538]   EC = 0x25: DABT (current EL), IL = 32 bits
[  902.996869]   SET = 0, FnV = 0
[  902.999936]   EA = 0, S1PTW = 0
[  903.003090]   FSC = 0x04: level 0 translation fault
[  903.007985] Data abort info:
[  903.010876]   ISV = 0, ISS = 0x00000044, ISS2 = 0x00000000
[  903.016380]   CM = 0, WnR = 1, TnD = 0, TagAccess = 0
[  903.021449]   GCS = 0, Overlay = 0, DirtyBit = 0, Xs = 0
[  903.026779] user pgtable: 4k pages, 48-bit VAs, pgdp=00000008a1c7f000
[  903.033242] [0000000000000009] pgd=0000000000000000, p4d=0000000000000000
[  903.040064] Internal error: Oops: 0000000096000044 [#2] PREEMPT SMP
[  903.046341] Modules linked in: tda998x onboard_usb_hub cec
crct10dif_ce hdlcd drm_dma_helper drm_kms_helper fuse drm backlight
ip_tables x_tables
[  903.059444] CPU: 1 PID: 1 Comm: systemd Tainted: G      D W
 6.6.105-rc2 #1
[  903.067114] Hardware name: ARM Juno development board (r2) (DT)
[  903.073040] pstate: 20000005 (nzCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
[  903.080013] pc : xprt_alloc_slot (include/linux/list.h:195
include/linux/list.h:218 include/linux/list.h:229
net/sunrpc/xprt.c:1727)
[  903.084212] lr : xprt_alloc_slot (include/linux/list.h:373
(discriminator 2) net/sunrpc/xprt.c:1725 (discriminator 2))
[  903.088403] sp : ffff800082cfb700
[  903.091718] x29: ffff800082cfb700 x28: ffff000821bd0c00 x27: 0000000000000001
[  903.098873] x26: 0000000000440100 x25: 0000000000000000 x24: ffff800081508198
[  903.106028] x23: ffff80008253b008 x22: ffff000824e99200 x21: ffff000800b644c4
[  903.113182] x20: ffff000832834700 x19: ffff000800b64000 x18: 0000000000000000
[  903.120336] x17: 0000000000000000 x16: 0000000000000000 x15: 0000000000000000
[  903.127490] x14: 0000000000000000 x13: 0000000000000000 x12: 0000000000000000
[  903.134644] x11: 0000000000000000 x10: 0000000000000000 x9 : ffff8000815ab504
[  903.141797] x8 : ffff800082cfb5e8 x7 : 0000000000000000 x6 : 0000000000000001
[  903.148951] x5 : ffff80008263f000 x4 : dead000000000122 x3 : 0000000000000001
[  903.156105] x2 : 0000000000000000 x1 : ffff000824e992c8 x0 : dead000000000100
[  903.163259] Call trace:
[  903.165703] xprt_alloc_slot (include/linux/list.h:195
include/linux/list.h:218 include/linux/list.h:229
net/sunrpc/xprt.c:1727)
[  903.169546] xprt_reserve (net/sunrpc/xprt.c:1898 net/sunrpc/xprt.c:1920)
[  903.173038] call_reserve (net/sunrpc/clnt.c:1755)
[  903.176531] __rpc_execute
(include/asm-generic/bitops/generic-non-atomic.h:128
net/sunrpc/sched.c:954)
[  903.180200] rpc_execute (include/linux/sched/mm.h:368
(discriminator 1) net/sunrpc/sched.c:1026 (discriminator 1))
[  903.183780] rpc_run_task (net/sunrpc/clnt.c:1234)
[  903.187448] rpc_call_sync (net/sunrpc/clnt.c:1262 (discriminator 1))
[  903.191029] nfs3_rpc_wrapper (fs/nfs/nfs3proc.c:37)
[  903.194873] nfs3_proc_getattr (fs/nfs/nfs3proc.c:123)
[  903.198803] __nfs_revalidate_inode (fs/nfs/inode.c:1231 (discriminator 2))
[  903.203254] nfs_access_get_cached (fs/nfs/dir.c:3033 (discriminator
1) fs/nfs/dir.c:3093 (discriminator 1))
[  903.207707] nfs_do_access (fs/nfs/dir.c:3221)
[  903.211376] nfs_permission (fs/nfs/dir.c:3335)
[  903.215132] inode_permission (fs/namei.c:530 fs/namei.c:504)
[  903.219061] link_path_walk.part.0.constprop.0 (fs/namei.c:1724
fs/namei.c:2271)
[  903.224557] path_openat (fs/namei.c:2254 (discriminator 1)
fs/namei.c:3785 (discriminator 1))
[  903.228050] do_filp_open (fs/namei.c:3816)
[  903.231630] do_sys_openat2 (fs/open.c:1419)
[  903.235383] __arm64_sys_openat (fs/open.c:1445)
[  903.239397] invoke_syscall (arch/arm64/include/asm/current.h:19
arch/arm64/kernel/syscall.c:56)
[  903.243153] el0_svc_common.constprop.0
(include/linux/thread_info.h:127 (discriminator 2)
arch/arm64/kernel/syscall.c:142 (discriminator 2))
[  903.247866] do_el0_svc (arch/arm64/kernel/syscall.c:154)
[  903.251187] el0_svc (arch/arm64/include/asm/daifflags.h:28
arch/arm64/kernel/entry-common.c:133
arch/arm64/kernel/entry-common.c:144
arch/arm64/kernel/entry-common.c:702)
[  903.254333] el0t_64_sync_handler (arch/arm64/kernel/entry-common.c:721)
[  903.258699] el0t_64_sync (arch/arm64/kernel/entry.S:599)
[ 903.262367] Code: f2fbd5a0 91008804 d1032036 a9400823 (f9000462)
All code
========
   0: f2fbd5a0 movk x0, #0xdead, lsl #48
   4: 91008804 add x4, x0, #0x22
   8: d1032036 sub x22, x1, #0xc8
   c: a9400823 ldp x3, x2, [x1]
  10:* f9000462 str x2, [x3, #8] <-- trapping instruction

Code starting with the faulting instruction
===========================================
   0: f9000462 str x2, [x3, #8]
[  903.268468] ---[ end trace 0000000000000000 ]---
[  903.273113] note: systemd[1] exited with preempt_count 1
[  903.278453] Kernel panic - not syncing: Attempted to kill init!
exitcode=0x0000000b
[  903.286120] SMP: stopping secondary CPUs
[  904.397045] SMP: failed to stop secondary CPUs 0-1,3-5
[  904.402191] Kernel Offset: disabled
[  904.405679] CPU features: 0x0,8000020c,3c020000,0000421b
[  904.410998] Memory Limit: none
[  904.414054] ---[ end Kernel panic - not syncing: Attempted to kill
init! exitcode=0x0000000b ]---

- https://qa-reports.linaro.org/api/testruns/29825073/log_file/
- https://lkft.validation.linaro.org/scheduler/job/8440380#L2148
- https://storage.tuxsuite.com/public/linaro/lkft/builds/32QPM3xxbSmOi7BTNwtgC47Erjg/config
- https://storage.tuxsuite.com/public/linaro/lkft/builds/32QPM3xxbSmOi7BTNwtgC47Erjg/
- https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.6.y/v6.6.103-195-ga13907443c81/log-parser-test/panic-multiline-kernel-panic-not-syncing-attempted-to-kill-init-exitcode/

## Build
* kernel: 6.6.105-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: a13907443c81b8a2c0032ca5303ab97ba8e99753
* git describe: v6.6.103-195-ga13907443c81
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.103-195-ga13907443c81

## Test Regressions (compared to v6.6.103-76-g12cf6be144d1)

## Metric Regressions (compared to v6.6.103-76-g12cf6be144d1)

## Test Fixes (compared to v6.6.103-76-g12cf6be144d1)

## Metric Fixes (compared to v6.6.103-76-g12cf6be144d1)

## Test result summary
total: 288386, pass: 268054, fail: 6579, skip: 13280, xfail: 473

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 36 passed, 1 failed

## Test suites summary
* boot
* commands
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-efivarfs
* kselftest-exec
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-kcmp
* kselftest-kvm
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-mincore
* kselftest-mm
* kselftest-mqueue
* kselftest-net
* kselftest-net-mptcp
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-x86
* kunit
* kvm-unit-tests
* lava
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-capability
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-hugetlb
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* modules
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
