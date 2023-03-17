Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFC30377
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 02:02:11 +0000 (UTC)
Received: by mail-ua1-f48.google.com with SMTP id n17so2432712uaj.10
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 19:02:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679018530;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zuQS+IqfIFU2bMpQvvRcDBiPpn6HUMH1Idu185oetYQ=;
        b=g5TQGM1U2g04r0O36hQ2Ds1XKfbNyLjuS8QjAJ7kAP3kNtLJ2teR90AF5Izf05llbv
         3KpuoVfdPJ1aJBZwmlNs4Fy43Re45JBKiY7xkzuGi/FiBu23NW4LlSRbHWEuFD2Fo0mg
         jsF8A1MMIA3+/+AalNoGi4SFWV8AfsQQQlmPOxxz4c3Alt9kZLQU7cXxjS1xPiml1/+j
         KeBTKzg+IGipArtro5crTPz5HiC+KisfVCakfqIRK+QajHqSPXQ1MqGELBJM8bN3hJi6
         SDbyaUPhHH8eEEv+X6s00uqe3GsVGJlLU6It8LunzlddFX5+rt5a1+aRCN9Dr2iH+iGZ
         gOwA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679018530;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zuQS+IqfIFU2bMpQvvRcDBiPpn6HUMH1Idu185oetYQ=;
        b=tVuf1KVhqZ5pCT2Aj9jhpI0sV1bDgEShZlgqApiKOQ10cSKz7Va5bwS4Tec0AGLjvc
         4Wud8LtTPGj3PgLlAWaqUX0s9LwP82StUER4PSxjwLt3FnVutwU4JMO+3XKeC4DvSlxU
         kvv5uXq7rB78DRxTIFj0UFLBxQUlkUWerVXFQK8EDdrmr3LIKhb51BKgqJG+ZHc2akWu
         Wr4Dv8i5B/nI/b4sFKeg+KGwA/657g/6we0OGAI051MsXisbY3F8mfufDZPFa3KcA4C2
         iNH4uzs6IAsKAG9OxmgfhuzCPVicCLqsSevGvwGgWpD0TQN0AHgZvYSwQZzDkSyRbWPD
         fvRQ==
X-Gm-Message-State: AO0yUKUwfrAm4b6zZ4XLdJdPqI1E/kc2Zh3z5Wz1wVlKgohlhkroCV4r
	J2uqv59lBT9d4PyvZ2KkmSaMzxPB7ya5sWhCkjsCKw==
X-Google-Smtp-Source: AK7set/f1LUOJk3hFjvAj8zmDpRufQDm4er3XvnhFis3CHXbEQ1bV74440MmUDPxIOuq0EzlIs+Fwj65uH1YK6iocpY=
X-Received: by 2002:a1f:9817:0:b0:400:ea69:7082 with SMTP id
 a23-20020a1f9817000000b00400ea697082mr28160316vke.0.1679018530392; Thu, 16
 Mar 2023 19:02:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230316083403.224993044@linuxfoundation.org>
In-Reply-To: <20230316083403.224993044@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 17 Mar 2023 07:31:59 +0530
Message-ID: <CA+G9fYtTBW_BvHwyASUPJUw8QT-PX1pcroWsnQ658FSxj1YsTQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/55] 5.4.237-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Mar 2023 at 14:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.237 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Mar 2023 08:33:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.237-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.237-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 1baba0e91ac5e439c0e58b2d241a6aac8d50191c
* git describe: v5.4.235-60-g1baba0e91ac5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
35-60-g1baba0e91ac5

## Test Regressions (compared to v5.4.235)

## Metric Regressions (compared to v5.4.235)

## Test Fixes (compared to v5.4.235)

## Metric Fixes (compared to v5.4.235)

## Test result summary
total: 117469, pass: 95900, fail: 2961, skip: 18470, xfail: 138

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 146 total, 145 passed, 1 failed
* arm64: 46 total, 42 passed, 4 failed
* i386: 28 total, 22 passed, 6 failed
* mips: 30 total, 29 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 33 total, 32 passed, 1 failed
* riscv: 15 total, 12 passed, 3 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 39 total, 37 passed, 2 failed

## Test suites summary
* boot
* fwts
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
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
