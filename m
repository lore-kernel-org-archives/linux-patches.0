Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEE8323A8
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 11:37:05 +0000 (UTC)
Received: by mail-vs1-f45.google.com with SMTP id k4so31859497vsc.4
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 03:37:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VaBARMjpHLCg71S89gFKXXuk3yU1Q4mT9f4dqR54T5k=;
        b=ZJ7Lmoe3CKPDdSMOe9rydQOPkdUw0lb/i3rJXqfd0qX8VDLzoBYos9bJqGCfMHN030
         rNtQ9Fex2hZJIXdEzsXy8zn6iEv0uAtZf/FNCNVtCgbtixkYkN8pDUWAGh6RczNv7PRU
         +XuKD/yg72yQqZmt6CM+yXi8jFc1yDBLsf6YCi6cr1bhaaLRPCRjpocAyacuKv/ceczx
         VEmemQ3J7/xN8PQF86Wy8Byha+GA89hCiiBrfSWj6s1U7McS9+iG8EoUIVfT44TAOCIL
         J9rrzwE62s17h7aSVfzkFqAocwKxhSliRcuNLJx64lB9ipgmf00tZKSh1TGtytJLqnnX
         wRJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VaBARMjpHLCg71S89gFKXXuk3yU1Q4mT9f4dqR54T5k=;
        b=m2wIqQT5MSLqCSc51/gTQ4WNAQbxSxUQpJBTkkIomj1vPM+UrwcIYvTJJQOyWpWNVj
         q7k13E1HdLDZUopg/14uOchGdJ+/yGrVB1N33KE5puhBmUEzKco7xx4hZ3Mj+EfTUw/9
         6eoQIvelt51En/YKFBbs296/HwlKRJk7XTy9gHWd9umvUAyfIgKyhwZcHvVWwOEPIUPx
         TqTpYkSQqFtSbb0K7pnTkdxelx+ckx7ywg3jynAnVlWZ9cQ6L1S/s1ssNd2vh8MdNy/M
         MaSPziU57MU2MblQOHHYzIrI0NNtJvrJAh5qH8pM9r3ycVjGGCcR+2BX+uY/PkxFP1VO
         Z2Bg==
X-Gm-Message-State: AFqh2krxG0evwHCH2aJnIPa2RINxN5B3zaa6D62zXWm1rvmjC7zXKHY/
	OlVCGBFtuo7s527PULTvKBwX0UfjRESebK1SVe9wjQ==
X-Google-Smtp-Source: AMrXdXtF7NQk756FsKReh68o9pgSyVt8T9SubaH1paYO0hOEpyXebuWnDIVMln9zChgH6WzNSS+bw9KAeFJ9ZgoCHSA=
X-Received: by 2002:a67:f2c2:0:b0:3d3:fdf4:9d30 with SMTP id
 a2-20020a67f2c2000000b003d3fdf49d30mr143897vsn.34.1673955424378; Tue, 17 Jan
 2023 03:37:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230116154820.689115727@linuxfoundation.org>
In-Reply-To: <20230116154820.689115727@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 17 Jan 2023 17:06:53 +0530
Message-ID: <CA+G9fYvsLz+S==o7rfcPq0Bq=WSaCi=EfEb=4TcAsJ3mpPebhg@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/338] 4.14.303-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 16 Jan 2023 at 22:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.303 release.
> There are 338 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.303-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
clang-nightly x86_64 build failed,
arch/x86/kernel/fpu/init.c:180:2: error: 'struct (unnamed at
arch/x86/kernel/fpu/init.c:180:2)' cannot be defined in
'__builtin_offsetof'
        CHECK_MEMBER_AT_END_OF(struct fpu, state);

https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.302-339-g4e9c6da20b2b/testrun/14191782/suite/build/tests/

## Build
* kernel: 4.14.303-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 4e9c6da20b2bb77a60e70689d2f196e534548f08
* git describe: v4.14.302-339-g4e9c6da20b2b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.302-339-g4e9c6da20b2b

## Test Regressions (compared to v4.14.302)

## Metric Regressions (compared to v4.14.302)

## Test Fixes (compared to v4.14.302)

## Metric Fixes (compared to v4.14.302)

## Test result summary
total: 61609, pass: 54639, fail: 1816, skip: 4854, xfail: 300

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 313 total, 304 passed, 9 failed
* arm64: 53 total, 48 passed, 5 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 51 total, 46 passed, 5 failed

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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
