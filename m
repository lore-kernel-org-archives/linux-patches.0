Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E64E38479
	for <patches@lists.linux.dev>; Tue, 22 Aug 2023 10:55:34 +0000 (UTC)
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-79a2216a22fso1438421241.0
        for <patches@lists.linux.dev>; Tue, 22 Aug 2023 03:55:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692701733; x=1693306533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gZMqQg+WqkFqVJ7xaGvwvq6OH3n+pw7uOTJ04+AOO/Q=;
        b=ZfFG+rgg4zpMViPqU7vYL8qWi3C2R7TUzw0DarIEfNnAgTVJw6K80AUqVcvSZTvNWg
         evkJfRDmIrRQJP15ATdlQIT9SLCyWOVKPZ0S2L3bHa14d5VGP4pzbhtJYYyYy+WKC1cx
         PnRFqoVJoFw2bwLeq7ogfzrcgLd9ycp0X0xeTCwPdkn7ROCQjHNCZT+0fiwyfk26+UJF
         dTHUZBUTG7Ug5zaFOfyK1hXvZ5FWUNZvlViVPrJJFdmKm0IPuLfm88HIj7J9bJ76v3Fe
         no70Umd0uhZIEChtwR6F23b7Fo0XDfPefeI04LPRF9dU8xIyqHQm3gNy2tLdp4AWzgho
         nrVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692701733; x=1693306533;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=gZMqQg+WqkFqVJ7xaGvwvq6OH3n+pw7uOTJ04+AOO/Q=;
        b=h6nCvEk0pJv+AiPWO/JE3tmcILrhbRfgkVN8UPAA8r/5/5ZI5VNVuggzbENQEgQ81Z
         Z/kDke2vQLmabfvPBdL6mFcIQvEmTTo46TvdoqLLhwq6f7Tt0Z2MvUK6wHm46XBjmy6D
         M9b6rKKkLQa37/JgScBbS/UGcYsPYZtgBPRviYJyOYYfxZFc6biFp/EJSrsee9YHAeJZ
         asLIBw92ZEl//KsOUL8qznnV4Xe+SzlS017yQo+C7egRamh0UfS2C+ssCYfEUNttjoev
         5jDqwRjs5aDnSzyEhgAuoEppK/Sw4Gsi7BYhlU/SaZbgxb9NpjvaA6VpRFl+gNBQZcZb
         9NUQ==
X-Gm-Message-State: AOJu0YwNMBEKJz4CYFCloRHMYsY2rpohJ6NUdbwtuO9lRUs6dZvPtJ6t
	/wuXErJiswMg2lG/DALYdMN6gQVuepsuVlzrwUlbkw==
X-Google-Smtp-Source: AGHT+IEFhM0p81jw/VTueQS9XS+WUVCmo+vBGgPkXZmupnTOLkBZmVBb0pFqkBj6e1Tew4KZrQk+awkp2Bi/XERwNqE=
X-Received: by 2002:a05:6102:2852:b0:443:51a7:b63d with SMTP id
 az18-20020a056102285200b0044351a7b63dmr7557710vsb.23.1692701733568; Tue, 22
 Aug 2023 03:55:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230821194122.695845670@linuxfoundation.org>
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 22 Aug 2023 16:25:22 +0530
Message-ID: <CA+G9fYvkBSb-i_6unB3bRLwRibVtZ3snYDe_gG+bsZehu3Hv3w@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/194] 6.1.47-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, "Paul E. McKenney" <paulmck@kernel.org>, 
	Borislav Petkov <bp@alien8.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 22 Aug 2023 at 01:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.47 release.
> There are 194 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Aug 2023 19:40:45 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.47-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


NOTE:
Kernel warnings noticed on x86_64 while booting the kernel.
Paul E. McKenney reported this last week [1] and discussions email
thread provided here.

 [1] https://lore.kernel.org/lkml/4dc3d0ec-b827-4bce-8927-cfa5d837fd03@paul=
mck-laptop/T/


------------[ cut here ]------------
[    1.395392] missing return thunk: __ret+0x5/0x7e-__ret+0x0/0x7e: e9
f6 ff ff ff
[    1.395399] WARNING: CPU: 0 PID: 0 at
arch/x86/kernel/alternative.c:574 apply_returns+0x1c0/0x3d0
[    1.397391] Modules linked in:
[    1.398392] CPU: 0 PID: 0 Comm: swapper/0 Not tainted 6.1.47-rc1 #1
[    1.399391] Hardware name: Supermicro SYS-5019S-ML/X11SSH-F, BIOS
2.5 11/26/2020
[    1.400392] RIP: 0010:apply_returns+0x1c0/0x3d0



## Build
* kernel: 6.1.47-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 5165f4e9738c48a220a13b073c6ccc24824aeb74
* git describe: v6.1.46-195-g5165f4e9738c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.4=
6-195-g5165f4e9738c

## Test Regressions (compared to v6.1.46)

## Metric Regressions (compared to v6.1.46)

## Test Fixes (compared to v6.1.46)

## Metric Fixes (compared to v6.1.46)

## Test result summary
total: 150677, pass: 127511, fail: 4079, skip: 18915, xfail: 172

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 145 passed, 2 failed
* arm64: 49 total, 46 passed, 3 failed
* i386: 39 total, 37 passed, 2 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 36 total, 34 passed, 2 failed
* riscv: 16 total, 13 passed, 3 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
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
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
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
