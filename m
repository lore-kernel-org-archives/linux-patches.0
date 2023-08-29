Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299F1154AA
	for <patches@lists.linux.dev>; Tue, 29 Aug 2023 11:42:55 +0000 (UTC)
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-7a2c1ae77b3so729513241.2
        for <patches@lists.linux.dev>; Tue, 29 Aug 2023 04:42:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693309375; x=1693914175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FjXbT/a0xHRm9c9x7EvHrfCZN66X8G6z+25kkauygmk=;
        b=vW6VfetGzHK5OQ4USA5TAXpHGzjtiYvx3W7w7A3M84sJYBH1LG+ba4VCzIpCSEvuec
         x1UOPERyejBHAIfwkfiCFNZ62gZM/M70nAO57/qLdJog6wuOBTC3KiP0H6v2q9EtAdvO
         B1/X2bf6qnehTGwMXa7gWuo3VaVq+GK+TMXPRqJptpSWdxI7Se7EaZbm8EnOaGu6FdtB
         XFuyzgfoht92DXqLO4S9lziZ0JWU7cZcDnC2PSxO8C7DYOIH7XxUEAmMuaWdBLcM+L1t
         cpPX8EjTXJr19IvdamaLMAp+6Yq1O8poyY05hrNzNA8XGrYASblUcvQVoN+0qIi1HTZC
         ov4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693309375; x=1693914175;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FjXbT/a0xHRm9c9x7EvHrfCZN66X8G6z+25kkauygmk=;
        b=K3Hl4jIVul77TePqXNfPW9UPCmVWuXIfWuMgluR/ynAvAVDzGpSccNpRrWTeiSKmyu
         qjMmOq951XpXPoJo44nAaroV7sFznyMR2XosdarIGtYk145aFy9sjPY0tT9YYtujhcMI
         lODqR+ZSpTVCWo7rQWnUbx7VsR4gPhtP/vDUb+FiakbyZElvb9YTRU+ny6vxWvaEpx14
         6a/IjRleTOksCl3E01e0xzzn5Ndkj+s0kLYX9iA0qA4bBdolNAHKoq03hx2vYH5f/Quh
         NLbEDCsQtn5XMRxWwG7oXXB7m1OJbyUzdTT+eA6w02l72XsxefjTlm/4mVijLIWXDovy
         Jfeg==
X-Gm-Message-State: AOJu0YwCF14ZqWGd2s1su14W5zuTyOb9/zyF6tL+gkwAaUhtGrrDVNY+
	aqRd44z7MGDjKZ2bVJzt8wwX4EF2VOJ59PPGk4E9qg==
X-Google-Smtp-Source: AGHT+IEqwgF0DWSG6YZ9Tc02rmL3QOKlELSwvyU2H0JG+WFHKy5oPxVl+qtqdOxKpckIw+QwMGsC5RWepg+jz7kq8YU=
X-Received: by 2002:a67:f848:0:b0:446:9cc3:ccf with SMTP id
 b8-20020a67f848000000b004469cc30ccfmr16275407vsp.28.1693309374727; Tue, 29
 Aug 2023 04:42:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230828101157.322319621@linuxfoundation.org>
In-Reply-To: <20230828101157.322319621@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 29 Aug 2023 17:12:43 +0530
Message-ID: <CA+G9fYtTu6nfWQaazN=axeK+RFu-Tem3_SvpRfuz=dWdaz8wtQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/158] 5.4.255-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 28 Aug 2023 at 16:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.255 release.
> There are 158 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.255-rc1.gz
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
* kernel: 5.4.255-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: f1f9b3b66b45473d0deff05b1506393d60f850bb
* git describe: v5.4.254-159-gf1f9b3b66b45
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
54-159-gf1f9b3b66b45

## Test Regressions (compared to v5.4.254)

## Metric Regressions (compared to v5.4.254)

## Test Fixes (compared to v5.4.254)

## Metric Fixes (compared to v5.4.254)

## Test result summary
total: 119930, pass: 97361, fail: 2421, skip: 20062, xfail: 86

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 143 total, 143 passed, 0 failed
* arm64: 47 total, 45 passed, 2 failed
* i386: 29 total, 24 passed, 5 failed
* mips: 30 total, 29 passed, 1 failed
* parisc: 4 total, 0 passed, 4 failed
* powerpc: 33 total, 32 passed, 1 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

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
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timens
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
