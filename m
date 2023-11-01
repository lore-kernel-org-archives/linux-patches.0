Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72D9C168B0
	for <patches@lists.linux.dev>; Wed,  1 Nov 2023 17:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yYbU4BdM"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-457eebf8e01so12707137.2
        for <patches@lists.linux.dev>; Wed, 01 Nov 2023 10:29:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1698859788; x=1699464588; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NA/+KeCJBlIlbmFDBHYVaUeDP2EPvqFv8wldZntE6AM=;
        b=yYbU4BdMcq23nR8sr9bhyDHHQq3XnS45Ws2uvhj8Ga+FxuzriRy4VlNcu/70+p+nvL
         Rl9hbXmH4mHhVAWQ+F1avnTJ4wzhkL6VxFiAjg06rEduJ2A2Nb8Ldy3zU5fUgdVX/GrQ
         oWuKjRfvvbyvJLvlw4bCIUzUiqnRfdfchdQeq/tqhBAIVVz0CK1QRipJ5enGLCVfkLCf
         zUzwqV6edC8i9IwHa5aoriON6mJhKI9ZKb46tGu+rMvwDwEPF4E85XzlYaZVAQH+FW4I
         rLM1/Ww0VfcsF2jgROx2wDPI5pFBNEiOlheyl4FHfz0XO9txJSNxHunhU2zLLQ2CUf+n
         Q2kA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698859788; x=1699464588;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NA/+KeCJBlIlbmFDBHYVaUeDP2EPvqFv8wldZntE6AM=;
        b=rnjAIw5hEUjEz6tCmp90UlvD9kZBeUljS4UBhq8gRGaWqs7y92XNCEZz6cq6Klp5pM
         U5ad74IWAwMspLWisSGXG0j4o5k4aiM7z1VJ3Qe21njmb7wK0ANsAsRKGlLiZBT0MooO
         NW47xAwtfmxkGWlJLB8qaPxBnzBK0YgQ484c1LalS4YGcfcCkfzLxRwyUnJzm9pqpmJk
         FAsvdZH/RLk50HZgDD2VsRP3F0PLPujFL+T43nHym77JJhOxA52C+1BOZjJIDju43CiE
         NDJEHsWx7dMswQbGVlx+oMr4TEZ1VOrRBc884Xa71ccTQo2WO2FjTBlJ5YrYE3HsshiX
         7GAQ==
X-Gm-Message-State: AOJu0Yyah1h40QC9TDWejEcrRJWh0GvcRuSAtyfXsiOdFLVJOUiJkVNC
	gVnJ/v7khBzn1NUHZ4tmqyfgO+8FkJBhBIU+VuwInA==
X-Google-Smtp-Source: AGHT+IHPfCdUbOFuDUSF8U/w74yoOxpjhcLbjGN1thcCqeM3IP70B2YAavVsF5YXyM/F52jAkI2uWaET6xcikobleYo=
X-Received: by 2002:a67:e11c:0:b0:452:d9d4:a056 with SMTP id
 d28-20020a67e11c000000b00452d9d4a056mr14024960vsl.26.1698859787511; Wed, 01
 Nov 2023 10:29:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231101120147.190909952@linuxfoundation.org>
In-Reply-To: <20231101120147.190909952@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 1 Nov 2023 22:59:36 +0530
Message-ID: <CA+G9fYufhkTp=hzJDmMx-74sHVDeZn=ttW+d1tB1p8N9GA4YbQ@mail.gmail.com>
Subject: Re: [PATCH 6.5 000/111] 6.5.10-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 1 Nov 2023 at 17:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.5.10 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 03 Nov 2023 12:01:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.5.10-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.5.10-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.5.y
* git commit: b4d7fa7ca27816b453e17742b523f5ab9246317e
* git describe: v6.5.9-112-gb4d7fa7ca278
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.5.y/build/v6.5.9=
-112-gb4d7fa7ca278

## Test Regressions (compared to v6.5.9)

## Metric Regressions (compared to v6.5.9)

## Test Fixes (compared to v6.5.9)

## Metric Fixes (compared to v6.5.9)

## Test result summary
total: 137840, pass: 118133, fail: 2091, skip: 17499, xfail: 117

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 144 total, 144 passed, 0 failed
* arm64: 53 total, 50 passed, 3 failed
* i386: 41 total, 41 passed, 0 failed
* mips: 28 total, 28 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 13 total, 13 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 45 total, 45 passed, 0 failed

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
* kselftest-livepatch
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
* libhugetlbfs
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
