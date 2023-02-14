Received: from mail-vs1-f43.google.com (mail-vs1-f43.google.com [209.85.217.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716143C02
	for <patches@lists.linux.dev>; Tue, 14 Feb 2023 08:26:49 +0000 (UTC)
Received: by mail-vs1-f43.google.com with SMTP id g8so15747999vso.3
        for <patches@lists.linux.dev>; Tue, 14 Feb 2023 00:26:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tGXSaHCOyaOCnpjYa4V9CEu2AkvGXvwVHSjPt+4qogw=;
        b=XPYEe7G/FTp4FxGYqHj/dtIed22QmirPDPAju753f8FG+U8OkW2dXzI9RKNK1pcJSH
         J0MZyweL+wVnLB5Sm/3INsPz8Skt/RAbvE2VXxBtn8ya+AmepnkFSB2mfWnJdXAAXIQ5
         NrJqcS+MCQAIN9yMeBSrWvVmugMStxyrN3GvyN3kGbmk9HeKC71XYu1W5i0HMKksZM+D
         58d9XzQ17MM8zVp1heVX595ynmTkVUlXNRW42j5ozlUO4SGFTbGgGIesyYrQpoOoAv+y
         qANTUyb8HItxF2XC3ZIUEK7Mn3ixt2oTLcy8gxa+Li2G6gBjpG+Or392PQhJza5wvEdf
         sHuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tGXSaHCOyaOCnpjYa4V9CEu2AkvGXvwVHSjPt+4qogw=;
        b=5fWzFbnXgHh2AOKgakbkZ0zlRe5H2TxNcSbjRT0WwcvXIdZM0OjutN/8WVUxkKlt2Y
         as0aO3/Xx6aMmYM8GeUUbJ2VgdmKXqLe4ObJR3nJvV6t6vYR++l2SSGBkyRKILuvemh2
         2RzKwyYWTTbBsDdy9i513Rz+zfGwnYqtuQzuRqRnaY48pAI03WMhEsjSTOe4fEFod6bf
         xx023N66cv8wuFSt8KGoGsWaeSSwZmoql0yU0goZvVbJH0WChbRieEjlHEOQNWKGQmQy
         XaN3ER83Pe2svdHFQREkYVi413QnecdTemdrHr/HcQIwHZse69541+TE6sAonuimvDE3
         U8zA==
X-Gm-Message-State: AO0yUKV4q33HbOo0Iu04R57OErej83w3IoUR794m+szi2u0i2RM5xeZs
	xWRdrJV5RQNuLU0CF4YGvHnRMIL4R7dE3AtxSw5ADA==
X-Google-Smtp-Source: AK7set+0XHvRyXtDFgzucww00jiJ9CiTYvEPANkgFUfnvRP0R7kWGHQfI6w485Y1Pggr4fWsJDyDi1Bp6S9usdCUbDI=
X-Received: by 2002:a67:dc83:0:b0:3f6:4d32:127b with SMTP id
 g3-20020a67dc83000000b003f64d32127bmr223128vsk.63.1676363208138; Tue, 14 Feb
 2023 00:26:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230213144732.336342050@linuxfoundation.org>
In-Reply-To: <20230213144732.336342050@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 14 Feb 2023 13:56:37 +0530
Message-ID: <CA+G9fYsrengkVDZnhjvq-XoTODVTTSgF-H-YUYxv_x0xiHnu2Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/67] 5.15.94-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 13 Feb 2023 at 20:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.94 release.
> There are 67 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.94-rc1.gz
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
* kernel: 5.15.94-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 2bf3e29e9db2a8b1c8bc73dab34b09b09991ad11
* git describe: v5.15.93-68-g2bf3e29e9db2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.93-68-g2bf3e29e9db2

## Test Regressions (compared to v5.15.93)

## Metric Regressions (compared to v5.15.93)

## Test Fixes (compared to v5.15.93)

## Metric Fixes (compared to v5.15.93)

## Test result summary
total: 162222, pass: 135364, fail: 4592, skip: 21911, xfail: 355

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 49 total, 47 passed, 2 failed
* i386: 39 total, 35 passed, 4 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 34 total, 32 passed, 2 failed
* riscv: 14 total, 14 passed, 0 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

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
* kselftest-firmware
* kselftest-fpu
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
