Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3460223B3
	for <patches@lists.linux.dev>; Sun,  4 Jun 2023 10:06:53 +0000 (UTC)
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-75d4b85b3ccso112897185a.2
        for <patches@lists.linux.dev>; Sun, 04 Jun 2023 03:06:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685873213; x=1688465213;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rhU1FXPYdlb9iSGIG8lbwlkpDKW5OB+bZCuIFDtfOH0=;
        b=ZFx8crT94NKZi4I9tmzDHfjH8nYA3swSeX4joFcSey82kc3U7POrEeaOBZuBRZ0yub
         iW5ZN5axLu7eABFoZdBp/V/YSaowA5sH17fWsNetUVi3zao8d8pYBLr/lEBTYH8xTX9l
         ll7hIBn2ULGfFJ6wObVju4/++j/cTP50lfj75deRaiYISLmWd+EM+1sF6giThW1WFV7P
         FCYCuB7JH2tBOv4I60hzVXEGWpiGkCOczzeBATUPn21lckRvVMhmOsGQOiTv4ioYgHjE
         OUw9e8GN57z8BqO+jSqgCbs4rVnv5ylWPPzPj7VIPEtYFcqXSin7nvAlrcmAIKJ1GBvJ
         jpEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685873213; x=1688465213;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rhU1FXPYdlb9iSGIG8lbwlkpDKW5OB+bZCuIFDtfOH0=;
        b=DgWCT6iYbrrdeBOjWCKO9UN9inu8836pPCYNjTnnGGlUwx0BTDcu0O7S2R6Mtzimob
         wG5jqdseykihvlxyh/PRCCgBkSCsluB60ti2CjiZV1FYeOyS9e+dL0nYiMG7fM8t04Q3
         q8RIs7cAJ3hjKa8lRYsaeViMhTwzVGEtqb+zDWOz7hNGvS9FQLJ6D3XDx5sqPRXcj637
         CeP1v8jFWaBoqXTlMzPXmXbpRMFyfEhzWYR506ACcYgYy4dQXDHHV/aa8O4LQzNEPJy/
         HRZz/9J76i+4KBTQUiXTLoZ4Jq4bQGnOBiGnm0f2POpfRnEwxdMzj8bz9NMsNCPmEBSo
         c31g==
X-Gm-Message-State: AC+VfDyKMn3+xvNQzOzTSmogHu8D1PGMGRmGgU+1ZRJu4yfDRhjf+wdz
	rpLJkIscOzh3NXuwxZTmgX5C2Nl3POI2gky9y2CqWKifJacNxSn8lic=
X-Google-Smtp-Source: ACHHUZ4eTcpeyy75bxMkt02Ojc6r+CM5ClNVt0Ig5+uPMTs5U21Lbl+XNdZDsHiFKaLgwpXATl38jV/DfHEBdA+C1A4=
X-Received: by 2002:ac8:5a12:0:b0:3f2:ba:62b3 with SMTP id n18-20020ac85a12000000b003f200ba62b3mr4880854qta.32.1685872739202;
 Sun, 04 Jun 2023 02:58:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230603143543.855276091@linuxfoundation.org>
In-Reply-To: <20230603143543.855276091@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sun, 4 Jun 2023 15:28:48 +0530
Message-ID: <CA+G9fYvNK=g4GKPD+OFhDbOUEn-cHeqgKOuUYceVHwb79=s9RA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/35] 5.15.115-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 3 Jun 2023 at 20:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.115 release.
> There are 35 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 05 Jun 2023 14:35:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.115-rc3.gz
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
* kernel: 5.15.115-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: e43ef124b08b3125f1560d34f33fe33bce33c1ce
* git describe: v5.15.114-36-ge43ef124b08b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.114-36-ge43ef124b08b

## Test Regressions (compared to v5.15.114)

## Metric Regressions (compared to v5.15.114)

## Test Fixes (compared to v5.15.114)

## Metric Fixes (compared to v5.15.114)

## Test result summary
total: 133100, pass: 110484, fail: 4281, skip: 18135, xfail: 200

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 116 passed, 1 failed
* arm64: 45 total, 43 passed, 2 failed
* i386: 35 total, 32 passed, 3 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 27 total, 26 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 36 passed, 2 failed

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
* kselftest-exec
* kselftest-filesystems
* kselftest-filesystems-binderfs
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
* kselftest-watchdog
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
