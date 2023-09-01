Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20169AD37
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 12:00:13 +0000 (UTC)
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-44e86f3e4b6so742426137.0
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 05:00:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693569613; x=1694174413; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YHw6XaswM8esmLx/zeyirf/pGRYiAdZHmM1feVEP6W8=;
        b=V3aRDyupE8mg4E9WA2/ThngCunPoEiuyDh1Zpd0EyOn6MWqLuRSlrfMsFqZPF/pCuV
         y5Zo0TZndbcXHGV5W6JZ4EoJp/TAWiGC1QSKerCLyvoolSc/E2jqcPFKJiq9vXNTzATV
         jq713jhsemtaHyooHWd8OSM/bnotsX2EdhCK0FUiPVfYFwmRdwRFhjusC088ZpfX8+Li
         2NdvmSqLj9wpaUQ/Fh2crP2UHQcYydhUvjiUADXExCXQyGbgfjcjVkGegvSsBo/8KScw
         6RWnzpWrT4tl9fvE9u3TjXDVWCuh4K0p9pWsfLLgAI8CRiRboW8p2wvitg/8i5Wx2QG9
         Bavg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693569613; x=1694174413;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YHw6XaswM8esmLx/zeyirf/pGRYiAdZHmM1feVEP6W8=;
        b=jtJhGm7dZeZ8/pPKj3SBTUKtIcm2CyY9pfHZ6Fouitd327BZ4B2a/yPfR+53/PQx9j
         6eICtLI+QNHTxMMFptNbA1xTBPkWqr0SKwkQKQ+n+Ch1QgJv41thVqpem3efCn7q3a2s
         eRJEIcnKOprj0cyhCmaMlf+2BSigDZXVe+/+eNSweeJi8dqi0eKWTjmSStUuB8km1mtU
         WGORjIxq9ugN0wfjNaiG/edv9WJlMgNAqhvYoMA3jSSeOOMtlMvQDp5aRLikEW+jj1Hq
         aqQRgYdZK16JUNLqxdOdAF8n1ZoFSBfs8JzjX393wiPppVkbl390V+00txX8lmeFzXjX
         ahAA==
X-Gm-Message-State: AOJu0YzQEiEGRl9j8yVvsCU7QuvadBa6hr5hoxu0c5VcousMpNbECqNG
	836yvRN1Hk6QvPRkIBN3FZnV/P8Lc8k/6b3YfK0hgQ==
X-Google-Smtp-Source: AGHT+IGhXJSN1UgVgDAZll/j1teCja74pG32QkE2Muh5/UofETl+DKWR0YQRsNVLQm2SPh/gTTGhLsPGLhQa7L0zghU=
X-Received: by 2002:a67:f955:0:b0:44d:44bb:1f60 with SMTP id
 u21-20020a67f955000000b0044d44bb1f60mr2017758vsq.19.1693569611481; Fri, 01
 Sep 2023 05:00:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230831110830.455765526@linuxfoundation.org>
In-Reply-To: <20230831110830.455765526@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 1 Sep 2023 17:29:58 +0530
Message-ID: <CA+G9fYu3ick7NcMgkVdQA=ujkLs0guAuWezWv7HcYF9rrtnYhg@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/11] 5.10.194-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Aug 2023 at 16:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.194 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.194-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.194-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: e25611a229ff9e907889923c2702d817003bc228
* git describe: v5.10.193-12-ge25611a229ff
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.193-12-ge25611a229ff

## Test Regressions (compared to v5.10.193)

## Metric Regressions (compared to v5.10.193)

## Test Fixes (compared to v5.10.193)

## Metric Fixes (compared to v5.10.193)

## Test result summary
total: 97983, pass: 79078, fail: 2772, skip: 16068, xfail: 65

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 112 total, 112 passed, 0 failed
* arm64: 43 total, 43 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 4 total, 0 passed, 4 failed
* powerpc: 25 total, 24 passed, 1 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

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
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timens
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
* kvm-unit-tests
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
