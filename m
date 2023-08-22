Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0996FA2
	for <patches@lists.linux.dev>; Tue, 22 Aug 2023 09:19:24 +0000 (UTC)
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-7919342c456so972790241.2
        for <patches@lists.linux.dev>; Tue, 22 Aug 2023 02:19:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692695963; x=1693300763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8nvpdjKXSBqBHYloPrbuamz5gPPZpwYPPdcO5Rimn7Y=;
        b=lIjIfbtmR2VfB302I98ZJVNqp8a2UmqgCeTfRrQHGpTBh1hkST42i+4CP7DQ7beo+a
         Vg9R122jgeKQ+Z54bDkkTzdqZ1/ktQTcuSqRs14YQuyJeAFMrQsYhGgWZ6QBs5j2/iYy
         nzG7XSTari2xKqVkqrwum0qKfE5H6wjG6NUcRC0zv1OegYgo9gLL8sXROClOtsS9ZaaQ
         f6Wg5tkDT9TyXptAlOG5D3Hk+nDkb2JZmdC6Wh7ipw1BkLaH/6YhYGLCl5nBqv8s3Br4
         oWTUEbs9V6aEdtBiqMs9rjUTutSjh9w0pgRqSef8CcYDfFSB8lpCERxAEtqZBadT1N1r
         yenA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692695963; x=1693300763;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=8nvpdjKXSBqBHYloPrbuamz5gPPZpwYPPdcO5Rimn7Y=;
        b=KW2/Dk3oMiSes4j4pPmhz1j6h90gytmYb/zM3neO8525uw8vkOtCcpt+k2mBa9gPYb
         eSmitijyCreLdKpgm6DCmp61NGMp+TbpgBFia1g7cdL0uJaJNuCh4W4UuvoWXeP/CFA+
         m9Dw3fVGGAZX89ueNjs44AF/SFxxSDUaRUSQ53eZXYD8kOpBcuO7H51tdEnTwBxdKLJ7
         NyW774oJxFLLjJW2Ab7ISIKnfs8NwyOZfAn1u0xlb5OyKQBmMK97+x42Dxt8gUJiHP4V
         tJjT1bFK/ezyfEGnP1iz6nZpvx5PNf/ZizsI4oiRXyauQzZzhDJTijA4WN3qFNMkCmrG
         PwXg==
X-Gm-Message-State: AOJu0YyZLo7pyZKo+2gP+DzM+ztAKIC2WguLaeOBK6FkJ9X0ZWfqJxrE
	5h4FKxQK6BNwf8/ty5HbjzPD7haInegS9msivHSxYg==
X-Google-Smtp-Source: AGHT+IFniA3ENsW+7fd9ZvvNB/PCzGmL1RKQj7BUmj8xkYjGOWdrte3GnZTJFLPiQlit6Yo34ynWmAN0u450b+Rt400=
X-Received: by 2002:a05:6102:2446:b0:44d:521b:8ec with SMTP id
 g6-20020a056102244600b0044d521b08ecmr3144126vss.20.1692695962948; Tue, 22 Aug
 2023 02:19:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230821194128.754601642@linuxfoundation.org>
In-Reply-To: <20230821194128.754601642@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 22 Aug 2023 14:49:11 +0530
Message-ID: <CA+G9fYsbpcnnN2O2eF0TJkz=9xdbtmpA1V9yKaPPrXC1izgPUA@mail.gmail.com>
Subject: Re: [PATCH 6.4 000/234] 6.4.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Aug 2023 at 01:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.4.12 release.
> There are 234 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Aug 2023 19:40:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.4.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.4.12-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.4.y
* git commit: 2a85de3fab437809a8c511762a7ef4d75db71585
* git describe: v6.4.11-235-g2a85de3fab43
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.4.y/build/v6.4.1=
1-235-g2a85de3fab43

## Test Regressions (compared to v6.4.11)

## Metric Regressions (compared to v6.4.11)

## Test Fixes (compared to v6.4.11)

## Metric Fixes (compared to v6.4.11)

## Test result summary
total: 153971, pass: 133147, fail: 1667, skip: 18988, xfail: 169

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 141 total, 139 passed, 2 failed
* arm64: 52 total, 49 passed, 3 failed
* i386: 39 total, 37 passed, 2 failed
* mips: 28 total, 26 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 37 total, 35 passed, 2 failed
* riscv: 26 total, 23 passed, 3 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 44 passed, 2 failed

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
