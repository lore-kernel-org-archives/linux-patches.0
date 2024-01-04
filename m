Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8464B2136A
	for <patches@lists.linux.dev>; Thu,  4 Jan 2024 11:28:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Pvnowrrp"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-46788b25f95so123908137.0
        for <patches@lists.linux.dev>; Thu, 04 Jan 2024 03:28:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704367719; x=1704972519; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tweg/D/5XWVwQJcIsArKsHkePEu/CHILd8GCHNr9cnk=;
        b=PvnowrrpoQBzE6DA0mcx/Gp0GYNSaiUDhv8wwYGIqjJenCsxzZorl6ow2Qowf/oQdv
         hh65G6d1X+hC+S2tNU9eE3yddt1j8GKRPEdUBAy9vTg8QNAx4k0MRQH40uzS9VhmLUCy
         8tZGaDpoYNNCZ0u/0CsceKvkOyDBnCJaBppG55R9xXIbRdVf5WonCgJ3c8wezDd9Zoyy
         I4hnxiWkFwco7dARxavQv262rBn7VtSk6HBSvKH84Gg9GrZgp7bR/hIxTN3TPAFuafhO
         SyjqKkKNFhP9ohgemP1BTi5xprFWo8yzjlZ2+LVX7/eSjL/f0SgpkC/DW0cTdoPBY12J
         cDrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704367719; x=1704972519;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tweg/D/5XWVwQJcIsArKsHkePEu/CHILd8GCHNr9cnk=;
        b=xVfoj36OSdzcvkwh1XPUHUUDB2D08bPAc1JOb59bT6qWlGhvgxa3BvX9qjaJx1Tj3M
         Ld5Udh6SWZqNYZfEniuLDj7Xw7B5PHX0r5dwo2gWxQrb4o1WFPxc31Iw6+A/AaVMHLct
         OAI50p0a5B34DKdiqPw6zruUKmjxapLasLdEw95Ovl6l7zV/bPHH8Xtq00Y6qPrytvrv
         X1SOQiT8bOEXHXUzuOJKHDqmh0vLJv2x0zeVI8q7MmX8yjIZk52G7fkyhc7f7Q4wsDUw
         QjLEEwqmNspHrxaf18gme+wO2nnV9e717twom1YtaUB58IA51yR7csQy/M2ofZWxa/3D
         PbJA==
X-Gm-Message-State: AOJu0Yxmqg5XhCl4+pYLqPq7TOglPgJanRz1yAQpqSHFZjwzpKu50o4t
	z0BCLv4JdJTP9U9arAVwxuOXcPFY+Oh8dznVk/jGbEk1xAXg+w==
X-Google-Smtp-Source: AGHT+IEU2rSSQg/onyItb6pGiOtsfeAw8aUXOzj0XpNDIE+pMquEBDh+i2TfRqP7hH6b2oqlUZZB8s95rgLwdJE51Ts=
X-Received: by 2002:a05:6102:3eca:b0:466:60a0:ca74 with SMTP id
 n10-20020a0561023eca00b0046660a0ca74mr374339vsv.10.1704367719386; Thu, 04 Jan
 2024 03:28:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240103164853.921194838@linuxfoundation.org>
In-Reply-To: <20240103164853.921194838@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 4 Jan 2024 16:58:27 +0530
Message-ID: <CA+G9fYvfo1Sr8fBYd=oDkG19Z0O5+z4mnonPvXyhNnhPBdbGUg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/95] 5.15.146-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 3 Jan 2024 at 22:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.146 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Jan 2024 16:47:49 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.146-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.146-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 927631a7bbf09d5c91bd27dc5c660eaff4c67b06
* git describe: v5.15.145-96-g927631a7bbf0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.145-96-g927631a7bbf0

## Test Regressions (compared to v5.15.145)

## Metric Regressions (compared to v5.15.145)

## Test Fixes (compared to v5.15.145)

## Metric Fixes (compared to v5.15.145)

## Test result summary
total: 96922, pass: 76690, fail: 2639, skip: 17532, xfail: 61

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 117 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 33 total, 33 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 26 total, 26 passed, 0 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 11 total, 11 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

## Test suites summary
* boot
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
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
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
* libgpiod
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
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
* ltp-fsx
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
