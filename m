Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D957328CF
	for <patches@lists.linux.dev>; Mon, 27 Nov 2023 19:25:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CIrGjU+Y"
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-462c6f436e4so1410534137.2
        for <patches@lists.linux.dev>; Mon, 27 Nov 2023 11:25:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701113128; x=1701717928; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rWvLywTZl/AzgupL0ve4QzZYltpdTRKU7Vk2WwU9NPg=;
        b=CIrGjU+YxR74PswP6tGJ8Bfg8iIdGp4OmAKyp+OOfxqyL3TmoqYJilwQUuHwOchYfd
         hf3FcdOLRl/9KGXNxsrn+uCNa8o79/xGmBdcEayjCjG4z9ijsbqyJqJso4XnJS89ip3m
         f9uxeHmrZzjp4XQ+Bn6yBszvvgvNYchEuCRvPqY56ll83CDmJTaDkNXnaokzfp7nQEQR
         +TBxQ3q03Z64Ff/xe9s3k3FkuSiG0CYCkzYk5wh3kSqhHLC7bQ8OTsLd73HdWR/lPPUq
         5nPtSKC0rnJArsB9Aw/XtKFRLcjl+Q8YH6xQK0neCtKVvrX6mZlMscWG+aZVESneHyMJ
         iG3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701113128; x=1701717928;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rWvLywTZl/AzgupL0ve4QzZYltpdTRKU7Vk2WwU9NPg=;
        b=Ad2KtYHsVHu5dq9NLqpKVvpSBYKVx9/Z4nqq0DJTgGLD3h2LokLUapQk+/8qtSy8VP
         AjYXDvLPx1ar+0jX7sZQrcGiO27TJGaP1eOkKjD4uF8Vnt0dgRXzzdxTynV0L9nbJafD
         dBFZu027zvpEF3oO3yzxkz6E3HBSQLD3iniQyMmz0Gt79o7dQr4SN50EVfcTu8sFTV6D
         ymOKNInM/ZBVlDmvmVOkgBowmGAxBVIxA9DD5V+8TiBLfbGtwAClnqOVhSxkRsYNN6W6
         J4LQwKOToRGMIbCMWXUiKa52pcRqzlpdumxOPIqfGTAftlfedTbiMGuTj9nUaxUHR/4B
         c6hw==
X-Gm-Message-State: AOJu0YyVWdswo6CkePv/5co5U+X+LHSb7xxMSXqQj7LPcBgH3gbRqqxr
	tX7VLKf7IqQwifY5faDKxXpRRww8BoSrWTmRVdoHjQ==
X-Google-Smtp-Source: AGHT+IEGj660LiB8XKcoucFwevwVLaXtfLc0H4IiLj8q4ydm0m1X6sG1ekgRhjIlHCGDQdesoJK+miLgdCGeZCayg6Y=
X-Received: by 2002:a67:fa1a:0:b0:462:fa4f:f6d9 with SMTP id
 i26-20020a67fa1a000000b00462fa4ff6d9mr4518319vsq.26.1701113127702; Mon, 27
 Nov 2023 11:25:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231126154359.953633996@linuxfoundation.org>
In-Reply-To: <20231126154359.953633996@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 28 Nov 2023 00:55:16 +0530
Message-ID: <CA+G9fYsk_5WxkeQHqh_5McrkOBGW+4yF81=TdrNyPQOSZxz7Rg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/366] 6.1.64-rc4 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Sun, 26 Nov 2023 at 21:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.64 release.
> There are 366 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.64-rc4.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
LTP syscalls preadv03 fails on 6.1.64-rc4 on all devices.

As Daniel bisection reports on stable-rc linux.5.15.y review thread.
The LTP syscalls preadv03 test regression is due to following commit

ext4: properly sync file size update after O_SYNC direct IO
  commit 91562895f8030cb9a0470b1db49de79346a69f91 upstream.

Link:
 - https://lore.kernel.org/stable/81a11ebe-ea47-4e21-b5eb-536b1a723168@linaro.org/

NOTE:
Latest kselftests and perf from latest stable-rc testing on the older
stable-rc branches are reasons for these failures.

1) selftests: seccomp: seccomp_bpf - fails on all arm64 devices.

2) Perf: PMU_events_subtest_1 / 2  - fails on all qemu-armv7 and TI x15 devices
These perf failures are also noticed on the mainline / vanilla kernel on 32-bit

Links:
 - https://lore.kernel.org/stable/CA+G9fYsUXnx4HWyBOGMi3Ko_jT6Y_ejp5ZhcsU+8+_8NUsd=vA@mail.gmail.com/

## Build
* kernel: 6.1.64-rc4
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 40fd07331b8798ff5e5aca3ae85946c5c74ac226
* git describe: v6.1.63-367-g40fd07331b87
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.63-367-g40fd07331b87

## Test Regressions (compared to v6.1.63)

* bcm2711-rpi-4-b, ltp-syscalls
  - preadv03
  - preadv03_64

* qemu-arm64, ltp-syscalls
  - preadv03
  - preadv03_64

* qemu-armv7, ltp-syscalls
  - preadv03
  - preadv03_64

* qemu-armv7, perf
  - PMU_events_subtest_1
  - PMU_events_subtest_2

* qemu-i386, ltp-syscalls
  - preadv03
  - preadv03_64

* qemu-x86_64, ltp-syscalls
  - preadv03
  - preadv03_64

* x15, perf
  - PMU_events_subtest_1
  - PMU_events_subtest_2

* x86_64-clang, ltp-syscalls
  - preadv03
  - preadv03_64

* bcm2711-rpi-4-b, kselftest-seccomp
  - seccomp_seccomp_bpf

* juno-r2, kselftest-seccomp
  - seccomp_seccomp_bpf

* dragonboard-410c, kselftest-seccomp
  - seccomp_seccomp_bpf

## Metric Regressions (compared to v6.1.63)

## Test Fixes (compared to v6.1.63)

## Metric Fixes (compared to v6.1.63)

## Test result summary
total: 136417, pass: 115381, fail: 2897, skip: 18004, xfail: 135

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 151 passed, 0 failed
* arm64: 52 total, 52 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 46 passed, 0 failed

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
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kunit
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
