Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26673487B2
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 18:23:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SdnUDPgC"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-45f0e332d6bso385106137.2
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 10:23:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700158995; x=1700763795; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mJMcVGwV0ZhksPb/kb7ya6aQUsXCXgCzibgQas3bEBg=;
        b=SdnUDPgCGB1sIEi9DjC4Q0XdxQsdoV2qYhdxFCjorW/kbO0vZdAJ/5EGRJQg9tIoQ+
         aoqI/2HY0J4m13lZFeQ4Iik5W5T3r8TQvQTzwiuuHcumSMvuAJM3BV4dL2fuQRQV92Os
         LMt3kp7xaSVgT4a8TqlnO6IH/OKM9/064fO1MsWX6vQrfg2Xvo+31TjzGaXbUjqZEYeM
         yEFVWHLNwmmVqXVTA07R94e52TrVsr47x4XWm/DSec9Qlf11ZUPbDcCph8ktN4ZV+4nn
         nUN6VPcCZwcINdn9g/5y39tEKjtsSFA/X4mgknxIUzZeoZH6wmZWm2N45jH6VIEeq0zQ
         DKFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700158995; x=1700763795;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mJMcVGwV0ZhksPb/kb7ya6aQUsXCXgCzibgQas3bEBg=;
        b=XTGMcJWhJwfFsfN/PqZR/8/bmLGusZr59hItKnudIRPaGq8Ocemg5mCxONknfZbKQ/
         dnp+LFtNq1cnAZePKJGmZWDirxoIg/4bbRZ2TvdoC8VZLl57W8RDh5U/hjjmgrVPG1Pa
         A7DmPEfWwZw1g4vMqD3qr+vn4aiKd9zV5R4FgYtdu9iT4RRQfUHnchANV2yFUPhgtUBt
         sEzB0B0VzqyeZKPpqANDBZ4y7IlSuZKLQz0GzBV3u3uZ6HpZbvgpABRvhwmICnPRMRw3
         viGb+JZ3m4gJtar82YP8jRCNA2ShiV03klt/lOXXjnEzUUUpbesy0yr0+RIRv/EPVUz0
         vGNw==
X-Gm-Message-State: AOJu0YydkeCuSxSQMiPT4uJpE7nIBaBieaOBnprVxobiFLJeqRHopPXh
	WC5yuyF3YcbRst+MAZ61t5V3sVOXRIPrtFnNGMugkg==
X-Google-Smtp-Source: AGHT+IEcMaXkeuHVRU3ZX/vb++TMtypZamKx9CSfQP8ESngpYGE22btaobl4qjxySaHBxzo5pYhEzgxe3DEwurxJIeA=
X-Received: by 2002:a67:c29a:0:b0:45f:9fd2:71e0 with SMTP id
 k26-20020a67c29a000000b0045f9fd271e0mr17352673vsj.30.1700158994973; Thu, 16
 Nov 2023 10:23:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231115192645.143643130@linuxfoundation.org>
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 16 Nov 2023 23:53:03 +0530
Message-ID: <CA+G9fYukdu+JryZd7yubwZYddrDNpDZyQXA772PisHiBvU77+A@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/379] 6.1.63-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Nov 2023 at 01:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.63 release.
> There are 379 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Nov 2023 19:25:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.63-rc1.gz
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

## Build
* kernel: 6.1.63-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 505b91175bcfcf16c4adc437901109bee0ab649f
* git describe: v6.1.62-380-g505b91175bcf
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.6=
2-380-g505b91175bcf

## Test Regressions (compared to v6.1.62)

## Metric Regressions (compared to v6.1.62)

## Test Fixes (compared to v6.1.62)

## Metric Fixes (compared to v6.1.62)

## Test result summary
total: 126938, pass: 108065, fail: 2482, skip: 16277, xfail: 114

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 147 passed, 0 failed
* arm64: 52 total, 52 passed, 0 failed
* i386: 37 total, 33 passed, 4 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 36 total, 32 passed, 4 failed
* riscv: 14 total, 14 passed, 0 failed
* s390: 16 total, 15 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 44 total, 44 passed, 0 failed

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
