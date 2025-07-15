Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4500924A046
	for <patches@lists.linux.dev>; Tue, 15 Jul 2025 16:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752596431; cv=none; b=Rkv+94ZXm1vMygmLx3tPF4wSnLre1EjTiAdzio+x6cQ0kczsfHYlqJ3fqHc6/63cddELEM6db990T/wGHzPVezuzYtYl1/ll/0XVgSLAzVwow55LflgMOjPLM+AhGYjSC47wGvRKMrbR1avBy531J5k2ged2XnFHj2oHvo6rHaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752596431; c=relaxed/simple;
	bh=9wSSUd17eYyPmNDRinebEKNm6MjrslPLoHBitNTSmDE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=arrRvd4n3ZTIfy9oLA4iNI2jjJ+iOqNJtR6nt4yOU0qenNMl8LlibyO/Mq+0T0Dqzboloz1qy3MFQn3yKbHYFknqnZRHfh5uHCKfZKTsynI39gIgR0hoqvmXPvdnwpmgfhW6EKmzYGbdP3aC1w3UD2naGzGZNhBmlPnZ0d41hgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=bkl3Ll7W; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="bkl3Ll7W"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-b2c2c762a89so4650049a12.0
        for <patches@lists.linux.dev>; Tue, 15 Jul 2025 09:20:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752596428; x=1753201228; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=uJBpvy5JQXqvDU6BUB39eR+t4AzacJq68M/ewvrrxLQ=;
        b=bkl3Ll7W7VhF4gMPvifV/Z00GzkSY7lPTCkUMJFJR6Mosn47khPq7LnZZVB5ZRd5we
         JDxkE3ksa5Ufsk2P/kapM+hyyJS+fSE7ahIl8f1CTocNeYzDTXbScVuOTj2tBlUoBtQv
         nNOOFN3zSTVdmT2nW4vITQpoLVRmz6Ah3d3L6z7gjrnR8MoGs2OCFEGCdnL69M6hHIQk
         OKt1uXcPq5Sj96jmL9UDiJFMNIWzBWhcn10rGJXBtvz2RVIXTei6V0j2lxyrf+3o72U6
         IELRf6XrZuGQW9pd+pzbXt1Fs+BKfCzL1gLJXSdYdyED5SJSF/wM9JXBY+DCLfCfHE0b
         qJ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752596428; x=1753201228;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uJBpvy5JQXqvDU6BUB39eR+t4AzacJq68M/ewvrrxLQ=;
        b=mTgcMfPXDCR+bamOVP2izGE8gYGxJc0l+TuHfT2f+VtXykCKURPVBjWvMM+vcrn05z
         vZHkUpnI/V990UXQZtjoqUw+h0q8ssGRis0NFvTqd9XmNXCyC3BOrKn66FFfxZ+lmgjk
         X2hq+AlntctF4ZqG2Dr6rEZ8FXqFeuVmQDFHjzJvCm81x6Kx6+euXu36wkvSfWpIJ34f
         RAN+2l8MgHmLzf3pTxQmsMk6vXomGbuPuWcTth3eo+0+63zZM0kDSwZj3V5PkY5c2cZz
         dppd+vVwxC19qROwwgMl1HMNoQ9goms3zbzYR28sAAolzGD6Upn324/lAdnAJ9kOoL6Z
         p4Hw==
X-Forwarded-Encrypted: i=1; AJvYcCUFQyD+1Qg42/iv8MlwlzQrd1RsjtJcom9tu3Vvbdj1qxGS7M3QjqGBeHx4ijQloWBiJIys0ISB@lists.linux.dev
X-Gm-Message-State: AOJu0YyEowENvqnIH/LYHNGz6AJe8+otSwmT4mzchkdrIQSUeodmHQzZ
	RVq/hXoVUY16rRpqTzS6jyf8dB2POIWDP8tLwIw0AHLhv5NzbZwCATz0GxRT7mL28xrp5mAROwF
	Bu4ghVjsbClV8HFpgY7Uuigqcljlxdu7c21Bx5kq/YQ==
X-Gm-Gg: ASbGncuDt1Yw8kSKOByMhRSllN+1P0HhDOXvrOw3k30hX4IdgqNJ7zNEglFfg67lB3u
	OqZmbUx5AcIZVoCycsVC2soklQJcT7nF2UYADyLq6eLlSSKEKWtpH+uZB/MSEN8rbKjzFEPPlGf
	dRtEeze7T+nl+RdnwP2GhEAhn8x17RwFuQj5/R6UPhJd1D9ZhERiUugIFcA3dVU6pGXp/nDZIgt
	A4Fam2npFDNQupjNUqNPsEfaZjP5SMj6IXYNjB3
X-Google-Smtp-Source: AGHT+IEmT9JahDOkC74B3Pqp8ah2Yah70/5PySO3L+OPWgorWZGMS06WD2aO5z6rH42UWi9E3kpv8e8DX87h0P58J7Q=
X-Received: by 2002:a17:90b:2c85:b0:312:f263:954a with SMTP id
 98e67ed59e1d1-31c50d5c3e0mr24316850a91.5.1752596428308; Tue, 15 Jul 2025
 09:20:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715130754.497128560@linuxfoundation.org>
In-Reply-To: <20250715130754.497128560@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 15 Jul 2025 21:50:14 +0530
X-Gm-Features: Ac12FXyQIhd8J5AV4_ejOchW88TIcZ9UEHIA5WNbxuNAxq5FLkivns_cnl92TYs
Message-ID: <CA+G9fYtuwziF5cg0AwpMiB7Q4HC7fvOpJfNskKrUEQA89GZ9yQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/88] 6.1.146-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

On Tue, 15 Jul 2025 at 19:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.146 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.146-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The following boot regressions were noticed on the stable-rc 6.1.146-rc1
with clang-20 toolchains for the qemu-i386.

First seen on the tag  6.1.146-rc1
Good: 6.1.145
Bad:  6.1.146-rc1

Regression Analysis:
- New regression? Yes
- Reproducibility? Intermittent ( occurrence 2% )

Boot regression: qemu-i386 Kernel panic not syncing stack-protector
Kernel stack is corrupted in do_one_initcall

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Boot log
<6>[    5.529679] fuse: init (API version 7.38)
<0>[    5.535360] Kernel panic - not syncing: stack-protector: Kernel
stack is corrupted in: do_one_initcall+0x243/0x310
<4>[    5.536353] CPU: 1 PID: 201 Comm: modprobe Not tainted 6.1.146-rc1 #1
<4>[    5.536728] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
BIOS 1.16.3-debian-1.16.3-2 04/01/2014
<4>[    5.537072] Call Trace:
<4>[    5.537284]  __dump_stack+0x18/0x1b
<4>[    5.537437]  dump_stack_lvl+0x56/0x86
<4>[    5.537537]  dump_stack+0xd/0x15
<4>[    5.537631]  panic+0xd7/0x280
<4>[    5.537714]  ? _raw_spin_unlock_irqrestore+0x23/0x40
<4>[    5.537857]  __stack_chk_fail+0x10/0x10
<4>[    5.538515]  ? do_one_initcall+0x243/0x310
<4>[    5.539530]  do_one_initcall+0x243/0x310
<4>[    5.540213]  ? fuse_dev_init+0x54/0x54 [fuse]
<4>[    5.540696]  ? trace_hardirqs_on+0x30/0xc0
<4>[    5.541093]  ? ___slab_alloc+0x7a0/0x850
<4>[    5.541763]  ? mutex_lock+0x10/0x30
<4>[    5.542300]  ? kernfs_xattr_get+0x28/0x50
<4>[    5.542925]  ? mutex_lock+0x10/0x30
<4>[    5.543494]  ? kernfs_xattr_get+0x28/0x50
<4>[    5.544034]  ? selinux_kernfs_init_security+0x6f/0x1d0
<4>[    5.544626]  ? idr_alloc_cyclic+0xb8/0x190
<4>[    5.545144]  ? trace_preempt_on+0x1f/0xa0
<4>[    5.545703]  ? security_kernfs_init_security+0x32/0x40
<4>[    5.546323]  ? __kernfs_new_node+0x192/0x200
<4>[    5.546826]  ? up_write+0x30/0x60
<4>[    5.547169]  ? up_write+0x30/0x60
<4>[    5.547666]  ? up_write+0x30/0x60
<4>[    5.548180]  ? trace_preempt_on+0x1f/0xa0
<4>[    5.548577]  ? up_write+0x30/0x60
<4>[    5.548671]  ? up_write+0x30/0x60
<4>[    5.548874]  ? preempt_count_sub+0x50/0x60
<4>[    5.549591]  ? up_write+0x30/0x60
<4>[    5.550036]  ? trace_hardirqs_on+0x30/0xc0
<4>[    5.550508]  ? put_cpu_partial+0x8f/0xc0
<4>[    5.550625]  ? __slab_free+0x140/0x250
<4>[    5.550810]  ? __kmem_cache_alloc_node+0xc5/0x190
<4>[    5.551453]  ? do_init_module+0x21/0x1c0
<4>[    5.551792]  ? kmalloc_trace+0x27/0x90
<4>[    5.551928]  ? do_init_module+0x21/0x1c0
<4>[    5.552034]  do_init_module+0x43/0x1c0
<4>[    5.552137]  load_module+0x13f7/0x16e0
<4>[    5.552241]  __ia32_sys_finit_module+0x9c/0xf0
<4>[    5.552560]  ia32_sys_call+0x22c7/0x27e0
<4>[    5.553363]  __do_fast_syscall_32+0x86/0xd0
<4>[    5.553868]  ? trace_hardirqs_on_prepare+0x2f/0x90
<4>[    5.554443]  ? irqentry_exit_to_user_mode+0x14/0x20
<4>[    5.555070]  do_fast_syscall_32+0x29/0x60
<4>[    5.555515]  do_SYSENTER_32+0x12/0x20
<4>[    5.555644]  entry_SYSENTER_32+0x98/0xfb
<4>[    5.556403] EIP: 0xb7fb7509
<4>[    5.556873] Code: b8 01 10 06 03 74 b4 01 10 07 03 74 b0 01 10
08 03 74 d8 01 00 00 00 00 00 00 00 00 00 00 00 00 00 51 52 55 89 e5
0f 34 cd 80 <5d> 5a 59 c3 90 90 90 90 90 90 90 58 b8 77 00 00 00 cd 80
90 90 90
<4>[    5.558029] EAX: ffffffda EBX: 00000003 ECX: 004a6332 EDX: 00000000
<4>[    5.559007] ESI: 01277410 EDI: 012773c0 EBP: 00000000 ESP: bf83340c
<4>[    5.559196] DS: 007b ES: 007b FS: 0000 GS: 0033 SS: 007b EFLAGS: 00200296
<0>[    5.560690] Kernel Offset: disabled
<0>[    5.561095] ---[ end Kernel panic - not syncing:
stack-protector: Kernel stack is corrupted in:
do_one_initcall+0x243/0x310 ]---

## Source
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Project: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.144-91-gcb3da7d94d12/
* Git describe: v6.1.144-91-gcb3da7d94d12
* kernel version: 6.1.146-rc1
* Architectures: i386
* Toolchains: clang-20
* Kconfigs: defconfig + lkftconfigs
* qemu-version: 10.0.0

## Build
* Test details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.1.y/v6.1.144-91-gcb3da7d94d12/log-parser-boot/panic-multiline-kernel-panic-not-syncing-stack-protector-kernel-stack-is-corrupted-in-do_one_initcall/
* Test run: https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.1.y/v6.1.144-91-gcb3da7d94d12/boot/clang-20-lkftconfig/
* Test plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/tests/2zuky3NIcL74EompcUsLcll9dsr
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2zukvDombE6lLJ5nUkH55G7hMhh/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2zukvDombE6lLJ5nUkH55G7hMhh/config

--
Linaro LKFT
https://lkft.linaro.org
