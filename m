Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D69B2BF009
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 10:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750848864; cv=none; b=FMprDU738f+w99hRPWi1HUKYT4atyjHrWTB6FmnvOv7Lq2ihki/Ga1uNxOVh1SsE6A6CRGEupd/UUuS3pjUKCTmlAotH02/1/OQxnntFAX+krcgi8D9NZXfRIJV3UgEhr1j8ctwuHRekPap5MZcHJCGhNngNZSq/KB8AAO/mQJE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750848864; c=relaxed/simple;
	bh=oWw3YvvIIyZMO9LMr45beiGm0PsyuB9vcsoRXkosJKM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CqaY/CdsN27LzhYjKmCvxlTcvFXuASfpDkBZpYXDLHwaISawmVnUG74Y0eUjHEtlF5/vrJ9jNtA5eBvlBJ6eIS6Ex/LqKdJvkst5PU+Gs+mycOZwYBY8x5VORX3DrYkNsx0pp12RbaJhI8h+H5Mcl0yz3C3ksSNcfb86IWLZqes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=H/2rYjFi; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H/2rYjFi"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-b3182c6d03bso1888973a12.0
        for <patches@lists.linux.dev>; Wed, 25 Jun 2025 03:54:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750848862; x=1751453662; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fMQOsT+mdqoi8lnfK5N5XyAR9UzojfvCMCTObb86FVk=;
        b=H/2rYjFimnUT2QUo1s9ScdybU6ucFNDLtkotBJ3qlNqxNVjsWXac6lj6lLadqGqAVH
         Yd/JlJU/Dpge0UoCPXyRx//H+sqjE7cuqZPrFE59/yWPY0dXMsJwp3kTSkJHzoe33tI4
         1Z6ccahEsRxaTCdfdIYGQ2Cs9SuhXTH/XGJeldmkxkyNVBKN27rDLvrF5p+AIpgw+Qr9
         xEgIvXBMhwtTa0D7O0repyv1hXMHv4tuw9OEdzCH1HM25BJoyPAbBTljyJwJ1DNehF7C
         lu+8mQKjgagRxJstklfXo3zNBPLMwqn8Ix79H4FOY6n7esrX9PHU0Q1cY9DH62t8jok8
         S/iA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750848862; x=1751453662;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fMQOsT+mdqoi8lnfK5N5XyAR9UzojfvCMCTObb86FVk=;
        b=PMo4gSiq4VXGInb3kKE+lTJSeu1OOtpArMyR2I49wiAPo4qWlrl6QAhpol2i0Qpuzt
         ROAjXl6XBqc/crMk9L5Y4nXwrbLvDsUuVwA9/SqQ3k7MYHfvbaIrQS4l7XQSv25RmzH4
         ig140tx2tGOjhFvyYGN/EC0QEDTk8ll3sCge8YXwnQN10yOy/hnWvwo7vCwHMFbacltp
         MKAjIt7jA9YXyHsycqCOQZJ3LeXE8VGOwwgBPd2PIP/uz26cNqruQAUVPFtZDexZfCge
         Y/kjWcUhhpzswQv/HuCT4rH5E8owVbbGWMSvakWF6Ic3k/uXkAasNI9LoZXTA70Q83KA
         Oo8A==
X-Forwarded-Encrypted: i=1; AJvYcCXqq7N46lawGrj8oOLF4dPWZZvlJaA7n3gQmHNNqFf5DlS2bHcSczdbKLS7SJSA4uvlbvQiNI2Y@lists.linux.dev
X-Gm-Message-State: AOJu0YxWCZuQrcHKy9cIAp9vCfIviD2HbMDksIuaMq/Ar+7ysK6mkkc4
	Rx8L8Bfps6sDC57I9Ux6rthaFCYn8gD6Uu2+zpBauN6nA/LzPGmcxqNW2GSyQ63jbYuUfh5XWMY
	TF4NszKPGL1EmEVCgukW/4McWFoisy70zpW24NXJEgQ==
X-Gm-Gg: ASbGncu5AdxzyMbeG4ZJhFTaYJtp3tW9X2M21SKiDKVllgrQme/bDCNHDxl/krRGX3C
	33a6ing2QZSEeqXY5p0mscNNTDbX4m+j+NK0iDHZ0UTylB2eTa1wzN86IXSvLpvBxjJxEcFE4lF
	ovr3SbqBZ3kZHWMaVGH/JadoQUichT9v72W95Z671M3moY1PgPnwjCQKpDt5nW/ewmahhRBiq8/
	6iy
X-Google-Smtp-Source: AGHT+IHiEEGI2cB5HHq+2rW2I162fZGpGjKdx9vFcpygnRYRBtx9ITlyUhy0ssBTVpCEGfR518CwQjoRlvHR7iSKwUs=
X-Received: by 2002:a17:90b:1d05:b0:311:9c1f:8516 with SMTP id
 98e67ed59e1d1-315f26192efmr4507300a91.15.1750848861645; Wed, 25 Jun 2025
 03:54:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250624121409.093630364@linuxfoundation.org>
In-Reply-To: <20250624121409.093630364@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 25 Jun 2025 16:24:10 +0530
X-Gm-Features: Ac12FXz97GBM2balbdrYLnqrqpEMD_cJZ26q0A3b3jEWkftx66qzM1sifzdDU30
Message-ID: <CA+G9fYt_Z-Vtoan2z-OEoArWuNy=A9wwAoTyRF=G8zobZBaDvA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/288] 6.6.95-rc2 review
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

On Tue, 24 Jun 2025 at 17:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.95 release.
> There are 288 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.95-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.95-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 33e06c71265b793ab2b3f3358952f6995d09e793
* git describe: v6.6.94-289-g33e06c71265b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.9=
4-289-g33e06c71265b

## Test Regressions (compared to v6.6.93-357-g7ef12da06319)

## Metric Regressions (compared to v6.6.93-357-g7ef12da06319)

## Test Fixes (compared to v6.6.93-357-g7ef12da06319)

## Metric Fixes (compared to v6.6.93-357-g7ef12da06319)

## Test result summary
total: 233901, pass: 212419, fail: 5723, skip: 15315, xfail: 444

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 128 passed, 0 failed, 1 skipped
* arm64: 44 total, 41 passed, 0 failed, 3 skipped
* i386: 23 total, 23 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 30 passed, 1 failed, 1 skipped
* riscv: 15 total, 14 passed, 0 failed, 1 skipped
* s390: 14 total, 12 passed, 1 failed, 1 skipped
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

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
