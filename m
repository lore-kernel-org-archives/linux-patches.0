Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7237CA51
	for <patches@lists.linux.dev>; Wed, 26 Jul 2023 14:20:04 +0000 (UTC)
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-4813422f311so2514125e0c.2
        for <patches@lists.linux.dev>; Wed, 26 Jul 2023 07:20:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690381203; x=1690986003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XuNc2mBif+BIOHURuwHXxEfwwUubFU0eTRxo/J2Xwpo=;
        b=NgAq6jTZRRUWgC9KwhgNd4VCGwpjlUXNLlWg3/b8GQcdidBn4j/KphpHayQVGb4Pas
         pjoRK0loIAm1WNcE2WhzIENBnygJgddqYQUZU7/Ewit4BolBS++Uk/wQeT0NhFAXNFe/
         2WirQoG+RKGmIU2+c2WqZEqhY02GAXwIrHhNINWNuLzOyJIEMwOmjI3CGb33mvvzZLfl
         6W+PCe7IRhII+crLls1eXvFyOGBknTST1hQIfNc0ZmVOobLm9Lada6jKMr99cyfJ7QbQ
         Ehd5dPNKuyaxRoy8TlaQPsjizsN/pZEgOj8S7Rx8bDtjSLdVqu/MWi5jMfZ5H/Ok8VX2
         qvtQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690381203; x=1690986003;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XuNc2mBif+BIOHURuwHXxEfwwUubFU0eTRxo/J2Xwpo=;
        b=FQS9n8azlvrF0s8sjSNdCUQ9LSE+v4Qj8LbpR/5BSmY0ckpNdIvz3xKUnJysZVQe77
         5lteUCASOr2FYpnjvy4NIIhlW9xgjdbImeqGOC1Ej0U8l5juGdyv2/NjYPh4a5s0G+zH
         DqkYPu5XREiu1yvqV7//oD0etX6C+5cGG37+yGLwvWI4aswPSO0uqd538FG4AooGAoXg
         e4F5X4kFh4uL1j9iQwMOMF4IWgLFyPtcD9tOmiyv+6mIFyhJ59lmDBx77ufLwXcPefjO
         xaRkni4h9Jdy12V7UZ0XqRzUp4FqhYGXSGpYC7BSj6YhQ7CSJEdqG2Vbf8afa0iqA6Uk
         kryA==
X-Gm-Message-State: ABy/qLYiOGWihQnnssP2ffAg6gJDvt4tbQy0BHI62ViLycnG8Hoktj4K
	iY4XIIMHGURCiZj8mwAU5wl7abclUuDF8wvN04Bx2Q==
X-Google-Smtp-Source: APBJJlE3pdkBqKvbvyhlZC3z8P845HDU/BelwH4LpjEKE7V+540n769YZU7DhB1GE07skqLUqDBCTIlapB2gEGwv40I=
X-Received: by 2002:a1f:3d8b:0:b0:471:5427:39a5 with SMTP id
 k133-20020a1f3d8b000000b00471542739a5mr1460808vka.10.1690381203231; Wed, 26
 Jul 2023 07:20:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230725104451.275227789@linuxfoundation.org>
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 26 Jul 2023 19:49:51 +0530
Message-ID: <CA+G9fYvKc0eAvrt8oN7TY2UaEWxnM1Me16vaAjCpyR36gABw1Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/78] 5.15.123-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 25 Jul 2023 at 16:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.123 release.
> There are 78 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Jul 2023 10:44:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.123-rc1.gz
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
* kernel: 5.15.123-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 3bef1500d246a00c075b244b6bb5849082569081
* git describe: v5.15.122-79-g3bef1500d246
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.122-79-g3bef1500d246

## Test Regressions (compared to v5.15.121)

## Metric Regressions (compared to v5.15.121)

## Test Fixes (compared to v5.15.121)

## Metric Fixes (compared to v5.15.121)

## Test result summary
total: 108059, pass: 88081, fail: 2274, skip: 17614, xfail: 90

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 114 total, 113 passed, 1 failed
* arm64: 42 total, 40 passed, 2 failed
* i386: 32 total, 30 passed, 2 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 24 total, 24 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 35 total, 33 passed, 2 failed

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
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
