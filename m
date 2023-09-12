Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3135615495
	for <patches@lists.linux.dev>; Tue, 12 Sep 2023 08:03:05 +0000 (UTC)
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-490cd6db592so1863765e0c.1
        for <patches@lists.linux.dev>; Tue, 12 Sep 2023 01:03:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1694505785; x=1695110585; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IcYYrVUsshmH5A6TR+yYvs3OB8iN1jYR1U1q6ihQM5s=;
        b=bkLNhZP3tbPz9o+x28sd+exbGhHY/l2Yw5Lca53diKR+L3e4NY8qSjvKwLkndsgZPR
         0vJqaDG5Vj455AYM/uKiFw7S1HbIC5vC4WAHKhn+lzYIfWelYmRmixAKiChJ5YMblNan
         Pp2gUwH24OzHPkWKGTXKxjC/E3lONccaOc0VWkmzXkmYY5hIophV1HEJdWwbNDaveSN7
         ZdU0CdGEcV9BTXY7grGIB/TcAH9yv1r6kTH+TnI2v5Rm9+crcF5Y91iNZcMafs/sRGZS
         lFiJYeQfcQjZwStkUBWICJITV3OJO2g3ZQIqMTKBFzpxEGz+r7Vi2g/ixoAyeAQc1iEg
         pVQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694505785; x=1695110585;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IcYYrVUsshmH5A6TR+yYvs3OB8iN1jYR1U1q6ihQM5s=;
        b=vfLdSI1Prab3Ky+u7kMc3ldfnJRLe33W/bjJyiXnUu7PGb3s1modRJsxrE8Sn1M+0g
         23jz8fPaMYHpMAiJBb5Sgr2AoYWXvx8+b/hlYkiM2JP3AFl9RByP2IfewwQSJLl5RtEo
         PnrjhfJEsJM+qweoLW3Y78Zlwk9SqICRzmCJBUGObUIyNDBp+ppEetyWnz2Q7FMmQMzK
         oG6DOb/LqbQ/SpoLMN3AKt7wTdpup/54zgzmoD9vo8V8W1eP65Jbt9cQwkndB1EwtmR2
         cG8Kn2zRlwTSWrBpErVycIpC+E+J0NLrFiBfZ/Y8I0pLxIZhJPRKV0PCWT+Vnete+zA8
         f3ug==
X-Gm-Message-State: AOJu0YyV4PJClhjiXwvV2+EGH85n0e46G8yFWO+3yoCNu6lb6yMz9vUM
	X2RfB/A3Z8jNTyvQmMU22D4kOTgjHarpR+GNry6Lsg==
X-Google-Smtp-Source: AGHT+IFLm2Dmj+RMHkOiznh51B2T48mFLnh4UugXX6gsnZIP6rRqLe64+INTDKxRcRy4pjA9xUYD3jS0nlbs8Ah1t4g=
X-Received: by 2002:a1f:e6c3:0:b0:48f:e0c4:1a1 with SMTP id
 d186-20020a1fe6c3000000b0048fe0c401a1mr10652871vkh.12.1694505784949; Tue, 12
 Sep 2023 01:03:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230911134650.921299741@linuxfoundation.org>
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 12 Sep 2023 13:32:53 +0530
Message-ID: <CA+G9fYv7PymkiagSGFU-BXG43gHm2NYDd2CNJw26C52EGhjpig@mail.gmail.com>
Subject: Re: [PATCH 6.5 000/739] 6.5.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 11 Sept 2023 at 19:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.5.3 release.
> There are 739 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 13 Sep 2023 13:44:56 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.5.3-rc1.gz
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

NOTE:
Kernel crash noticed on Linux stable-rc 6.5.3-rc1 on qemu-arm64 while
running LTP sched tests cases have been reported on other threads.
Since this crash is not always reproducible it is hard to bisect.
Link:
 - https://lore.kernel.org/ltp/CA+G9fYvHhiiGKhNd=3DL9+xYFVwv0Q8k6gUBeFQGWCW=
w1cWhb50Q@mail.gmail.com/T/#u

## Build
* kernel: 6.5.3-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.5.y
* git commit: 7bfd1316ceae2dc3bf962695aafe5f1d0f5bb4a5
* git describe: v6.5.2-740-g7bfd1316ceae
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.5.y/build/v6.5.2=
-740-g7bfd1316ceae

## Test Regressions (compared to v6.5.2)

## Metric Regressions (compared to v6.5.2)

## Test Fixes (compared to v6.5.2)

## Metric Fixes (compared to v6.5.2)

## Test result summary
total: 138096, pass: 119333, fail: 2020, skip: 16565, xfail: 178

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 142 total, 140 passed, 2 failed
* arm64: 52 total, 49 passed, 3 failed
* i386: 41 total, 39 passed, 2 failed
* mips: 29 total, 27 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 26 total, 23 passed, 3 failed
* s390: 16 total, 13 passed, 3 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 45 total, 41 passed, 4 failed

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

--
Linaro LKFT
https://lkft.linaro.org
