Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3584212B2F
	for <patches@lists.linux.dev>; Tue, 24 Dec 2024 19:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735069150; cv=none; b=GCbsy+LTIjqPY3L4VZo9lIzLw2L+sU2xHNhs7pCVfJmc48Dtqd1TemmgxoOtc28GqpZVbfw1atKZJ2gsfIViI+wF6GU8UsvmIDthuYHLhFJKA/MKEo8wMVrrD2/DK4t3UvOFlXsaR/FkrHiHqyYLSpCDx05TGHdQAIZ3uVzhkaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735069150; c=relaxed/simple;
	bh=P79BEIQODNe99azMRwSsdpYNiZFg5hahoQ4kkJN7k64=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q3WRmBgcwL2hJ6VpDI+rzeVqOy6q9fbgJUBmF7lJ42hQUEv3AMUow06AijxMKSBMV1GFXhDZFyEk+Mt2Jxj1WmIx8Zk4HjihOVZJKKm7rd558besKa70iOJPKp6kMx/7BUjZJR3O8jksBkPUlPGv8O4kBqfdF/7MPe/fdTI9aQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MH3esEx9; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MH3esEx9"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-4b10dd44c8bso1419672137.3
        for <patches@lists.linux.dev>; Tue, 24 Dec 2024 11:39:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1735069148; x=1735673948; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QDU2RqYWAfV3xYeDvbcqmpikJj4/SnpfG2/BshVfimY=;
        b=MH3esEx95VfmatRV6RYHyUH22Qyj8QTXgSCNYy73SNzNrSBA1UJBUQjqEXRZos7VPy
         fiF+Lsr3N8IZ7C9YBcuKHt15hQUjSSbUNJeLkP68buLkj81SIEGKAMOSwwV+hOTx5BxR
         P6YGEUoRxgToODhUHhhOlgPvMahOsLwaGs3WfhwO9rKYiAYq6CViSU42EDen/lhdtcNS
         xe+DpMUZ4g00s5xV15VuMLenYvz484+SbIp7F4RcjwjD37pSKBqXQ3Aix1c54GW9BUCq
         li2gxj88VPbnHC/A0tI8zipWfK/ws8TmIxLlB/uiQWrI3Tky2ooU3Vx7BCIZRVf9A95O
         Qmiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735069148; x=1735673948;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QDU2RqYWAfV3xYeDvbcqmpikJj4/SnpfG2/BshVfimY=;
        b=nWQjsjlQJ1DZacp0OL297Yv1LQLL4txKRUfmGbl6clf7PgUUUh/VDiPsvWRMelI9WT
         tJkSyOjUNXbt850FIm7V0XkB5WU9Egv7yOtYPmUa9orPQORGPERq8gVIvsjuMpmv3EMP
         Ebhavjq29dJXbrOMUGmH7T4QX0bjKGw4D2n1G0DTYGbAe0x/0o3ejx0HiuR80l1Y9QlR
         627SytvqbURDIoy/ackkaYVnhYc1csMXsV7JDRpTnZSLzxU1B/AFmKDQj4Ei4OPDlAWa
         2cniIdRDxHvQLoqqTeXDeq8ZExILBpQ/iZ9L/TTJHe05h8qVDye+b+zx5l3Tii1JVTGf
         yu8w==
X-Forwarded-Encrypted: i=1; AJvYcCVI7bm2oIW/h2nOoNpoDGXDorzd7PcTuyU0/6U1cw0xBGG40lacFKsTFYzlWHn4EyZ9Jtl3LmHY@lists.linux.dev
X-Gm-Message-State: AOJu0YztGMkIxZXYZd4sqiO87wGkhiRMJtOlK5h2tvPmEt70wLHc9pTg
	3aZyBp26UUaxAcpEnjjuc8RT60i6OT5gM7UPe6ThxLZkXlZhIoUw9/1Is8HWc3c3ymt32AX9KKq
	oHMmLrVDhMgEV/0fRqNYzzu1rfcY/awHi6wtSRQ==
X-Gm-Gg: ASbGncsmZK3emHjooH+R7O6yyNt1nT86n5FJih/uqqIwAp6V216Ck2mYT/Ql6Ufuhdf
	FoAaMAWNHXNkwTQyI4vbC5iQLMB6pdbpGfaE6F/HEltIYyhPUwKBfqeucoK4ZeAtOz75pCz8=
X-Google-Smtp-Source: AGHT+IF2/qZ3gwl/ss0K6oIyCHGrgrb+OBSpU2UQ1JUhJXEq1qUVo4pv7jPdHz/VRKkbyGLYUwrPDeeeCNdDughZTmI=
X-Received: by 2002:a05:6102:b12:b0:4b2:48cc:5c5a with SMTP id
 ada2fe7eead31-4b2cc399b84mr15765409137.15.1735069147423; Tue, 24 Dec 2024
 11:39:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241223155359.534468176@linuxfoundation.org>
In-Reply-To: <20241223155359.534468176@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 25 Dec 2024 01:08:56 +0530
Message-ID: <CA+G9fYut6mGnMQWzbyhgCEgb8CTjWv7STOVkcBhsi7nk2DhJ2g@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/116] 6.6.68-rc1 review
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

On Mon, 23 Dec 2024 at 21:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.68 release.
> There are 116 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.68-rc1.gz
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
* kernel: 6.6.68-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 6a86252ba24f89c8deb21b44cb5ffc867d9ab96f
* git describe: v6.6.67-117-g6a86252ba24f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.6=
7-117-g6a86252ba24f

## Test Regressions (compared to v6.6.66-110-g584b6d5f2ac7)

## Metric Regressions (compared to v6.6.66-110-g584b6d5f2ac7)

## Test Fixes (compared to v6.6.66-110-g584b6d5f2ac7)

## Metric Fixes (compared to v6.6.66-110-g584b6d5f2ac7)

## Test result summary
total: 158707, pass: 130517, fail: 3971, skip: 24142, xfail: 77

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 132 total, 132 passed, 0 failed
* arm64: 44 total, 42 passed, 2 failed
* i386: 31 total, 28 passed, 3 failed
* mips: 30 total, 25 passed, 5 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 36 total, 32 passed, 4 failed
* riscv: 23 total, 22 passed, 1 failed
* s390: 18 total, 14 passed, 4 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 9 total, 8 passed, 1 failed
* x86_64: 36 total, 35 passed, 1 failed

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
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
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
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-hugetlb
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-sm[
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
