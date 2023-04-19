Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E03F2598
	for <patches@lists.linux.dev>; Wed, 19 Apr 2023 08:41:41 +0000 (UTC)
Received: by mail-ua1-f44.google.com with SMTP id ch24so1254078uab.3
        for <patches@lists.linux.dev>; Wed, 19 Apr 2023 01:41:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681893700; x=1684485700;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=emy47ve69M61/H+lOFyGeFQpmRwakkEYlvCbnQMqfZc=;
        b=ENnv+X68dCRBEv06msiX8E/szw1zR4jEO2EWzjTUvTeuOAAdhKX6tczSGLo6x3t+hv
         73PlTnk0PUtOCULsF/s9pyuiddkUrgUR1CDZWe/q1jDJbj+5WUFURaQW610rQZZ3twru
         m9Zz5oThv/KOTV+pyWaNb12SV8LTwk8dBR6WZHmIDB07gyhmOLjSptO+JCQU9vWFvfmZ
         TDc8EGRIWixLk2vKpZeEprTKhGcSJHQhdeSiZPeRKA6Zv44QDXQiKR/o/R6GH4MsZ/Lm
         UFObZ7UcA9iMzGcqC2MZfCsX8lO/APWIuo02j0lC2nlql/yBp3syxTi4bTPLp4XwwUtR
         mUoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681893700; x=1684485700;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=emy47ve69M61/H+lOFyGeFQpmRwakkEYlvCbnQMqfZc=;
        b=Pxql+t3Y8oaB5p+9Mgjealmy58ScbfWLm3Gvifgw0WeOrCBWCPxATkU80KW5giPrry
         1rMsjeL9gLbRjQASE6iR34r/mOywbuLtDZ8xCOOqAjPXfmHrNEu5MDse/2410fWTNt5Y
         X8i4ybLV2oFc1nzJ2wpEMbeVGmz0J0b5WHNqZN0tTd/bKF1LQ4nqpKroxxyBDA2ojJ6t
         MJdy9OgJ5Yv70apCqUMBLY4L+XZWILz+cLkVB9ZRzNXgVJKAF3bInTXOdTEzFeCaFitZ
         rpqQotj+lYbRQ/muzH+r7Lz9eZvZZLS4/grt+Ga/uYLv+amLCEuNVW+KEIuUcQQIn+tr
         VXCw==
X-Gm-Message-State: AAQBX9fri+hdf8DtLlwqFpltzX0lrXxjt7do67Eh4Omd1RmTnxVoCx2q
	jVpkEGqjgr+TZx1CrK/pC+/6eqDqm5O395W4PgQsaQ==
X-Google-Smtp-Source: AKy350Z3Ni0SSbMTDkN3mmzu1eRZR47Vg3M1yERQUS0xI3yjYTmv0WF06K5Cir25APo9u7T2XdG4FFNMTxTkCObeuhY=
X-Received: by 2002:a1f:6045:0:b0:432:6ec5:69a5 with SMTP id
 u66-20020a1f6045000000b004326ec569a5mr7179757vkb.3.1681893700274; Wed, 19 Apr
 2023 01:41:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230418120254.687480980@linuxfoundation.org>
In-Reply-To: <20230418120254.687480980@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 19 Apr 2023 14:11:29 +0530
Message-ID: <CA+G9fYvuJFV8bJNO5qObtZzvPDJwNdwjkgmPBo1GfCnL35GFtQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/37] 4.14.313-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, LTP List <ltp@lists.linux.it>, 
	chrubis <chrubis@suse.cz>, Petr Vorel <pvorel@suse.cz>, 
	Anders Roxell <anders.roxell@linaro.org>, Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset="UTF-8"

On Tue, 18 Apr 2023 at 17:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.313 release.
> There are 37 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.313-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Recently we have upgraded the LTP test suite version and started noticing
these test failures on 4.14, 4.19 and 5.4 only on arm64.

Need to investigate test case issues or kernel issues.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
-----
creat09.c:73: TINFO: User nobody: uid = 65534, gid = 65534
creat09.c:75: TINFO: Found unused GID 11: SUCCESS (0)
creat09.c:120: TINFO: File created with umask(0)
creat09.c:106: TPASS: mntpoint/testdir/creat.tmp: Owned by correct group
creat09.c:112: TPASS: mntpoint/testdir/creat.tmp: Setgid bit not set
creat09.c:106: TPASS: mntpoint/testdir/open.tmp: Owned by correct group
creat09.c:112: TPASS: mntpoint/testdir/open.tmp: Setgid bit not set
creat09.c:120: TINFO: File created with umask(S_IXGRP)
creat09.c:106: TPASS: mntpoint/testdir/creat.tmp: Owned by correct group
creat09.c:110: TFAIL: mntpoint/testdir/creat.tmp: Setgid bit is set
creat09.c:106: TPASS: mntpoint/testdir/open.tmp: Owned by correct group
creat09.c:110: TFAIL: mntpoint/testdir/open.tmp: Setgid bit is set

links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.311-105-gcdc53f89dfa8/testrun/16316521/suite/ltp-syscalls/test/creat09/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.311-105-gcdc53f89dfa8/testrun/16316521/suite/ltp-syscalls/test/creat09/history/

## Build
* kernel: 4.14.313-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: cdc53f89dfa8e80182c9539a962df6c330a69931
* git describe: v4.14.311-105-gcdc53f89dfa8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.311-105-gcdc53f89dfa8

## Test Regressions (compared to v4.14.311-67-gf4c3927dd933)

* qemu-arm64, ltp-cve
  - cve-2018-13405 ( creat09 )

* qemu-arm64, ltp-syscalls
  - creat09

## Metric Regressions (compared to v4.14.311-67-gf4c3927dd933)

## Test Fixes (compared to v4.14.311-67-gf4c3927dd933)

## Metric Fixes (compared to v4.14.311-67-gf4c3927dd933)

## Test result summary
total: 65426, pass: 54434, fail: 2998, skip: 7868, xfail: 126

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 106 total, 104 passed, 2 failed
* arm64: 33 total, 32 passed, 1 failed
* i386: 20 total, 19 passed, 1 failed
* mips: 21 total, 21 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 8 total, 7 passed, 1 failed
* s390: 6 total, 5 passed, 1 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 25 total, 24 passed, 1 failed

## Test suites summary
* boot
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
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-membarrier
* kselftest-net
* kselftest-net-forwarding
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
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
* ltp-fcntl-locktBroadcast
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
