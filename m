Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3310D320C
	for <patches@lists.linux.dev>; Fri, 28 Apr 2023 22:06:35 +0000 (UTC)
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-43f9c6767e8so182197e0c.3
        for <patches@lists.linux.dev>; Fri, 28 Apr 2023 15:06:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682719594; x=1685311594;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y9K80hMY7rCwgO/zSjWmhZpx2GzE+k3UH+Jmat1R7EM=;
        b=eUdmhOS79VIY5PrysVQqlPafNuT/qALkQnqdcWynQ67fm1IZQ1W7ies/ytItECnulr
         fxyFIxIQoYh34/d2eAfy14S9vgM7Ln5iWH61RDHu1z2eYTNInmszAeKKPoPUw36F1ns8
         Emw5rl7DGmCe9P2aHSKvzH4WTCt/g406DTlkTQY1S51pCzTku9khoiAgNT/yRTahDlrR
         8w1yrQceLKbB/OupRj5WzNCfIzE5XTlHjwG3nZotpEI23CFb8ys3pgEz20z7V2nch59L
         XYpL0J82kvlJ5kdUlcLJVf1K3a/QMz6PJ7ags7OEPUVLTRV0FaqhVKnySx+mnsLv0gSd
         6USQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682719594; x=1685311594;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y9K80hMY7rCwgO/zSjWmhZpx2GzE+k3UH+Jmat1R7EM=;
        b=HV3LmyvU4fHKsUQSJRZtGNIxWqJR7OLQGa3P6klKPgU41XaiI64J2rwrgFh+KmUrEx
         xaGBtIwABiqdFWhZJqOE13eIrQUmeJoEBkNCZ9s9ENMM2TGJzEaZS8GkTrXsA2VDLHsj
         pADVqQeoB4UGIB0a+YwpO9jxgGlqcow2k3CDeMOlaxEiJ4nmuXHSzLRzxGcbBOBHpRxg
         f9xCrpx2dAmULDk6nDq6U5LviMFthCkkpitqrwNepUN2ICLboVqy5yFA132hniBigUuA
         /xqeM2YCe5/FKfn6XdsuYJF8P8ZW812GYkYGMUXRBfswwDbFOKNM8gH6DZJeLKObHwC9
         xvfw==
X-Gm-Message-State: AC+VfDxzRjs3cKDHWn+JIEhsGYhJGyjOpzRchR5VeH1VpiKwSuOo6k6V
	XtK00U9MeKsKWeBTNbnVpoxX820eC0MAL/1HLXZurA==
X-Google-Smtp-Source: ACHHUZ5U9duRLvzuJpV5ogK40dUyZPN2Ti0VROanHSH27hht8Wm1VUbD5/57xwqbIsd/Qby3+Apina5jK2QL792Wv1s=
X-Received: by 2002:a1f:4ac4:0:b0:43f:bcad:db6b with SMTP id
 x187-20020a1f4ac4000000b0043fbcaddb6bmr2810332vka.10.1682719593906; Fri, 28
 Apr 2023 15:06:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230428112040.063291126@linuxfoundation.org>
In-Reply-To: <20230428112040.063291126@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 28 Apr 2023 23:06:22 +0100
Message-ID: <CA+G9fYtLzqqLrr45dO5NS=AQar1P+zeNa4puGwALU-BVeoqChw@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/16] 6.1.27-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 28 Apr 2023 at 12:29, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.27 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 30 Apr 2023 11:20:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.27-rc1.gz
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
* kernel: 6.1.27-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 58b654bf36db7c89178300adbb034ce63301b685
* git describe: v6.1.22-591-g58b654bf36db
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.2=
2-591-g58b654bf36db

## Test Regressions (compared to v6.1.22-574-ge4ff6ff54dea)

## Metric Regressions (compared to v6.1.22-574-ge4ff6ff54dea)

## Test Fixes (compared to v6.1.22-574-ge4ff6ff54dea)

## Metric Fixes (compared to v6.1.22-574-ge4ff6ff54dea)

## Test result summary
total: 158499, pass: 138000, fail: 3707, skip: 16470, xfail: 322

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 144 passed, 1 failed
* arm64: 48 total, 48 passed, 0 failed
* i386: 35 total, 34 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 40 total, 40 passed, 0 failed

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
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
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
