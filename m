Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C922564
	for <patches@lists.linux.dev>; Sat, 31 Dec 2022 09:43:15 +0000 (UTC)
Received: by mail-vs1-f54.google.com with SMTP id x65so9882944vsb.13
        for <patches@lists.linux.dev>; Sat, 31 Dec 2022 01:43:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KUHzJPivSYkoSKk7/BszI2rb7/a++4r23bXKXJQyalk=;
        b=Z77WbFj1n+mP6hWxI2pZUFjCsU4Shh+doZDgnhymxNkLnZxKuI2nX5a0F9k8BvwlQA
         1vPv32jixPXBC9uL2VXmCDOduvMthIAn52IhBZy9ZPiUDJrMZCfPXJErjn24Ozps83Ty
         8kKzOC+eOeA8zV/eSfbLsaZvuxj3ODsd5sxzRHrojnacfHBRTAL21dfx3rxLIJJOAVan
         QCPeB+rN+2rqal5KjtPG9udt6IsAXDRGgb4K2lxemHDeORfHxl77hOWe1y6o/Gxz5VZf
         I3bla3MSbHBGaE4By+WXQvg+Eexe7cdgo/Z9oT+A7Gm+ZTCFScV4Rh7zQfM1bLiwFnuM
         +S8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KUHzJPivSYkoSKk7/BszI2rb7/a++4r23bXKXJQyalk=;
        b=jbqDqW2Ybl0fkg649elhKYyGhef44trCC4l6AjW5f2ksfHvvlrAEsG3bDfkyU0Auny
         jUmgNtOqodc05JfCfb5pozVEVQjmEWrX0Zaxs77U+S2M2ocsq4Nf/HmHrYI7jfceNrcV
         CE9zVE3eWu2mZ1J9WK+p+uCr7LIFHE+MMVewkUhOsfSlqmJRaU4MitgocGOrtRWz3MSa
         WmNJcTNfRr2ItCHFNmm7ziiEjGeNURVim9+m23AytZ9DJDYLM+smK5jiCFg2hBhvemf1
         WCE1UvRUj/GY2v3+40hPyKBAchRLuibIrttRE8+MSpAZbH/x9Ui7cURiaVxo1R2NxB+n
         7dqQ==
X-Gm-Message-State: AFqh2krsP4rdouhyCeSK7XRO9epyPEEh7flih5q3tq7ittp/PnZzXQMO
	QPtpSUuPAy9oVJjLD3acpmfTFRFoFm+1wdcqCMGraQ==
X-Google-Smtp-Source: AMrXdXtjF15kV8Ipy8gA4oLc16rYWjg0mqiwtoH0uD0FRorfiOu15S8AXAmVQrh49Tmxtru+Sm4FgXRFX9FGfR7K/aw=
X-Received: by 2002:a05:6102:c4e:b0:3c8:c513:197 with SMTP id
 y14-20020a0561020c4e00b003c8c5130197mr1989630vss.9.1672479794147; Sat, 31 Dec
 2022 01:43:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221230094107.317705320@linuxfoundation.org>
In-Reply-To: <20221230094107.317705320@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 31 Dec 2022 15:13:03 +0530
Message-ID: <CA+G9fYuNoor9tmoj5pm9yHGCbH_Ljh=LiipZ3CmqWrzSXsj1Cw@mail.gmail.com>
Subject: Re: [PATCH 6.1 0000/1140] 6.1.2-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 30 Dec 2022 at 15:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.2 release.
> There are 1140 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 01 Jan 2023 09:38:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.2-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.2-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 9c94d2e408abdf4ca5bdc1d79598dc6cbfab7345
* git describe: v6.1.1-1141-g9c94d2e408ab
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
-1141-g9c94d2e408ab

## Test Regressions (compared to v6.1-26-g4478ff938eb5)

## Metric Regressions (compared to v6.1-26-g4478ff938eb5)

## Test Fixes (compared to v6.1-26-g4478ff938eb5)

## Metric Fixes (compared to v6.1-26-g4478ff938eb5)

## Test result summary
total: 165215, pass: 147553, fail: 3250, skip: 14412, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 146 passed, 5 failed
* arm64: 51 total, 50 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 44 passed, 0 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
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
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
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
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
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
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
