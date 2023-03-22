Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 856CC1365
	for <patches@lists.linux.dev>; Wed, 22 Mar 2023 10:38:49 +0000 (UTC)
Received: by mail-vs1-f53.google.com with SMTP id x2so709113vss.10
        for <patches@lists.linux.dev>; Wed, 22 Mar 2023 03:38:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679481528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xOiN5G93WrfPsM2Jecc460dR5iDLmqy+gypXlUAZy1I=;
        b=YgvfzYUFqiy+iTf/4sQOI8uimJZzDdgLb0I+xiSlbKQFvwZQdBd1U9a9mgJLdNcfmn
         YtUeNoB4MAAteN80DI9FOuSQGcLPpv6nQg5CZCAXGw2gYcjbAH9+QSXKFu78bfPzkULu
         QL7m2RDBluTSLxLpw8ZA19xh4t7w5U3hE85C0xvQcsv5LfNWxObiEGlqrpMygsO8YkM4
         pRNaRmxuZ7eOWi40H7zFSBO4000wQaH+u/PM6FheQrqeVfodpn31DCgLT8V+QsUvfzVH
         5CxR8QEX9p/XxyDwj9LBSVheqrinTKuRmt674zHopPFtYrSAohdh/aIjc0933ohGBEh6
         pyUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679481528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xOiN5G93WrfPsM2Jecc460dR5iDLmqy+gypXlUAZy1I=;
        b=QmchMtsWSeU2gp5O6AbX6DyBxYKpJD1xaW4wwHsGOFtntwrJ58PJemh4aieJmBroC5
         QP5i+C3cziRlJ2lqaw+WuYk4cNXxCKkZxAYXiXXSzkXheX4IxwGRXYCjjUTwf0poPNMK
         TS3m2Scrdjxg5tco0B00WhRV6txk4mx2ZUbtZFMTh5jAdgJHqYnLCpSXFVoIwXii9vFI
         8GGR6YekP4RiVnAv+LQUaORyzvB8moekhXJCJ35TX7egPaEoU4rqe3wLsd2mpj68xata
         /lHb8GCWGtkuKl5sxfbdrTwUgw0uSgKLH2Pz5UE0++MUxx9zXc7Q2yZsNfqAtH/7D7lL
         ZZmQ==
X-Gm-Message-State: AO0yUKVGM2HrExcq555GR7AIGUfG7BfEn1Z33bpkFborLs1a3FQZqHcM
	C7eAUe4c3Xz6TrD6vT7XwsakyMavIpBzUo3idtZIzQ==
X-Google-Smtp-Source: AK7set/5W/bqhxB0kdyABAYudu1GFKIqmHXPZv3ZQNcZ8b6LlpKu4UCO7huf6zKH+hNmbM6D0gBh5fEtpcymadeipcE=
X-Received: by 2002:a67:e00b:0:b0:425:d255:dd38 with SMTP id
 c11-20020a67e00b000000b00425d255dd38mr3313118vsl.1.1679481528233; Wed, 22 Mar
 2023 03:38:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230321180749.921141176@linuxfoundation.org>
In-Reply-To: <20230321180749.921141176@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 22 Mar 2023 16:08:35 +0530
Message-ID: <CA+G9fYsG6d_A_yGQAixYTA2Wh2cowf-UQJAY=RRWnEzFcLAHCQ@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/214] 6.2.8-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 21 Mar 2023 at 23:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.8 release.
> There are 214 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 23 Mar 2023 18:07:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.8-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.2.8-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.2.y
* git commit: d9c239ae1a56ba4b39f4783b8d025cb7a75b2751
* git describe: v6.2.7-215-gd9c239ae1a56
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.2.y/build/v6.2.7=
-215-gd9c239ae1a56

## Test Regressions (compared to v6.2.7)

## Metric Regressions (compared to v6.2.7)

## Test Fixes (compared to v6.2.7)

## Metric Fixes (compared to v6.2.7)
s
## Test result summary
total: 196699, pass: 168689, fail: 4397, skip: 23223, xfail: 390

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 143 passed, 6 failed
* arm64: 58 total, 55 passed, 3 failed
* i386: 45 total, 40 passed, 5 failed
* mips: 34 total, 30 passed, 4 failed
* parisc: 10 total, 9 passed, 1 failed
* powerpc: 42 total, 39 passed, 3 failed
* riscv: 30 total, 28 passed, 2 failed
* s390: 20 total, 17 passed, 3 failed
* sh: 16 total, 12 passed, 4 failed
* sparc: 10 total, 7 passed, 3 failed
* x86_64: 50 total, 49 passed, 1 failed

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
* kselftest-vm
* kselftest-watchdog
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
