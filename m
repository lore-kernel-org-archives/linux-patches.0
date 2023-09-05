Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D9F1A38
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 08:15:59 +0000 (UTC)
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-44d56d26c32so889844137.3
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 01:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693901758; x=1694506558; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q54+t+GkvMz0+EsIrXlLUHC247aFke2V/z6h4/2GcDU=;
        b=W/iYfFUQha/cQFCWyChOoQ8m7Vun+PJZDLjEK+QIQmnK0rAVIOCMkr4p1SB9bST2A6
         m+esLI7nJ36MBCziynT3fa3U6llLWZREtsvDkQ8Gza4v4ovbmj+j/efWPBr8fkgNTW7s
         oxqt0U5EIB0/JKTCGO+1wd31zMcOtyACAcc0mtJZ9WoIH9l+B6vOSdGKu7vjUpQ7ubJK
         X/jFedzO31Mu4Okb+Rp0XnW1teMGvVSkINs8wXqMXElgn6XDY2A9WRGiU0+i3JjiHabY
         8QrAFtQ4W8BYYh2TGOk6GWsn4XbyHYrkh23KdzmvVff50oMtL/fxaxyP7sx7faX3t+wQ
         bqPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693901758; x=1694506558;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=q54+t+GkvMz0+EsIrXlLUHC247aFke2V/z6h4/2GcDU=;
        b=XL0A8iJishjtvrIAK4vRcKNSh0Q+xUIwjDH8Tq+4xG4yAc0wLoOLOGxeNCJof+5APd
         j3vBa1ufEIQYnvvz9Lj/h4IyadI4P4DPeSRw6rW5xh1t4hr/A8IxwdOT4gQ9Y/O+PlB1
         xpaSmTmVy/56p855BtkwMAtp19plPRpIceYwucioUS0XBcXAF3LlOWHf+zkeJLV5VVR4
         oV6Q8nYcnpkuIDuc0Ps0xj24tA3n+7Ke5M8HPztjJwgfCCC408iEvCxpmLs5u4dR66Bi
         TWU+kiqrhywL4o6GBgJF0XFDrmALV3yBm2OAYiLFnacZ/X3JfZI55x73paoFswzMiazY
         eYrA==
X-Gm-Message-State: AOJu0YwbGhO1r3PbNpRUxy7wnMe4Z91lQtgyn1p1npBpV4N4RRKV+jO5
	J1w8qL6R8M94emSqHy9Wutg5eG802WGtqhWXxMp3cA==
X-Google-Smtp-Source: AGHT+IHsKZp4iDKBLFP1UeXIV+qaRIH3SJ/11EW4C6xwXMMWSQDhVHAvHyS3ZhAORKFgZUZ/IxVjp04oYbfGd15tqds=
X-Received: by 2002:a67:e951:0:b0:44d:4aa1:9d3a with SMTP id
 p17-20020a67e951000000b0044d4aa19d3amr11478780vso.32.1693901757911; Tue, 05
 Sep 2023 01:15:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230904182948.594404081@linuxfoundation.org>
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 5 Sep 2023 13:45:46 +0530
Message-ID: <CA+G9fYv-JmXWxjTuUDGujo39xiaCg8SciMuvKCrqRie4YzA8Vw@mail.gmail.com>
Subject: Re: [PATCH 6.5 00/34] 6.5.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Sept 2023 at 00:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.5.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.5.2-rc1.gz
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

## Build
* kernel: 6.5.2-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.5.y
* git commit: 3b1345379dfa8756bebb7a0a5dcb41cf9e0ba98e
* git describe: v6.5.1-35-g3b1345379dfa
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.5.y/build/v6.5.1=
-35-g3b1345379dfa

## Test Regressions (compared to v6.5.1)

## Metric Regressions (compared to v6.5.1)

## Test Fixes (compared to v6.5.1)

## Metric Fixes (compared to v6.5.1)

## Test result summary
total: 142284, pass: 122577, fail: 2113, skip: 17398, xfail: 196

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 142 total, 140 passed, 2 failed
* arm64: 53 total, 50 passed, 3 failed
* i386: 41 total, 39 passed, 2 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 37 total, 35 passed, 2 failed
* riscv: 25 total, 22 passed, 3 failed
* s390: 16 total, 13 passed, 3 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 42 passed, 4 failed

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

--
Linaro LKFT
https://lkft.linaro.org
