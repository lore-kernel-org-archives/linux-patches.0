Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25BBD79E6
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 11:03:29 +0000 (UTC)
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-6bcae8c4072so1331313a34.1
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 04:03:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693566209; x=1694171009; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Aq1ZaWWf0e+kQmfjLlwO4x0N0Tvm+qnXrgEAdGFsh0Q=;
        b=ezUb60aSjwazwTQUGYQs5XPKzMCWqqm/VJBafYDtiQa1OKdTWiWcwE2BvRY6END/nx
         Gh3YDFOk5L7pQ4dyHecuPuwm5FHGkER5Kx/2Ltv2saOO/P9sb58vIlGg+oAXCzpXPZdR
         +VeJTTR1CS14k2JGb1ZzubrbcUFaa9+IsMeoAcccM8nK37B01paj+FYuyOk5WbMtX607
         8QSJ+agPXVSWQcFfcX5Peu/cKh/+fdv3etSnenPwZ8carj2B1Q5AFGMZwIKM4s4etSgS
         kwPBNX491ykWb6Lur+PWBocsQyie1FehUb5m0shIn98ipjarWSvK1lK8HAOgR030uA2Q
         2Dpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693566209; x=1694171009;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Aq1ZaWWf0e+kQmfjLlwO4x0N0Tvm+qnXrgEAdGFsh0Q=;
        b=D71GlkAgiLjQwWerai8cmncQnP3n4mqD8XoVW8fbib0sM/gDoBoFJ2LT5hz+CSD7V1
         iJDQmsbjJu67Ae4qbIhhy+HJB19FYwZf0lO4+XVklhrVyN+WKe5RaNxO3iC1UTgfDJiV
         ns+dOW+gVgf3MQvN56bu6JV30KwbrFruriguiPLnj35MgJCB9OnHf4d1hY33Vpqc+wNn
         XlRzyt0cHZArAth/iXT067rSrd4QJpZWRBPIsIXymYMoc+6X6+eR1mE+4rj0qB5uOR0m
         WFd022UdFIx7a1Eyrb28dIlDqoW3Z3SQTLstTv0ZPSUFvZ3rn7SYcOsgNWB3TdgzP2qu
         yaRg==
X-Gm-Message-State: AOJu0YwkOAeMeU9jVCoFel2tJpV9XGEuVFzNUVqJGd0IRx98B9Ue/qTe
	bsIvzuhlYf021oFO3HSZwJR0aVIYiRxTCOO01/tbwA==
X-Google-Smtp-Source: AGHT+IH+FF4GMpw1VoOqKIBZO2COOZg4+mIhgkTcIF/4QH3pFNYeRnK8MhX46khpI2kPHcg/XJO7aGlmHgcbZRxdDmI=
X-Received: by 2002:a05:6358:9182:b0:139:d4f9:b7a with SMTP id
 j2-20020a056358918200b00139d4f90b7amr1509836rwa.26.1693566208754; Fri, 01 Sep
 2023 04:03:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230831110830.039135096@linuxfoundation.org>
In-Reply-To: <20230831110830.039135096@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 1 Sep 2023 16:33:17 +0530
Message-ID: <CA+G9fYvAny1qNkCBMRSLZCyy37Lr32CV1xs3V2mzV-0URDAHCg@mail.gmail.com>
Subject: Re: [PATCH 5.15 0/9] 5.15.130-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Aug 2023 at 16:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.130 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.130-rc1.gz
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
* kernel: 5.15.130-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 46b26da4b8729ab6a0bd90326cf182a2535d938e
* git describe: v5.15.129-10-g46b26da4b872
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.129-10-g46b26da4b872

## Test Regressions (compared to v5.15.129)

## Metric Regressions (compared to v5.15.129)

## Test Fixes (compared to v5.15.129)

## Metric Fixes (compared to v5.15.129)

## Test result summary
total: 98073, pass: 79708, fail: 2412, skip: 15861, xfail: 92

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 114 total, 113 passed, 1 failed
* arm64: 43 total, 42 passed, 1 failed
* i386: 34 total, 33 passed, 1 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 26 total, 25 passed, 1 failed
* riscv: 11 total, 10 passed, 1 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 37 total, 36 passed, 1 failed

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
