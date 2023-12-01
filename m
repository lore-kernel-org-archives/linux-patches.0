Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76E14CE15
	for <patches@lists.linux.dev>; Fri,  1 Dec 2023 16:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="eQ+b2Sgf"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-3b845ba9ba9so462126b6e.3
        for <patches@lists.linux.dev>; Fri, 01 Dec 2023 08:30:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701448212; x=1702053012; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=s1IKxbEKchkGY10bHUOXRHh40Wu4gUJp6JDz6WOLnHc=;
        b=eQ+b2SgfHIvXBMsStnDEOdfwBLNi34NgpMNsipQvXRQwCsNx0w9hese5zN9wDJfzSQ
         +pHiYFBVR5sF3+nip1kaJJe8QwnI3mv1nOyyWVyFyAlO8voCbtXxtpyjbm4CRpC20Kce
         fx3krAV0OxPRiNJNYEqSezgoutTz3Fs4KWf4OqD0MFYrBPWoUdJxZMdPlcBISE9L2VL9
         9cqBOeHh+XYx57WJAjWL8RLN33xG2B6YtTLFzi6qX3MCMXLyKCYo8UWUw1OhhWi+6thz
         YxsaqoULTbZpVtwXEk/VLj4D/nT3LZ3lU5jQ6GoCLbANcCrwsuVPHCT/DZGqLh+WqJzS
         mCgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701448212; x=1702053012;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=s1IKxbEKchkGY10bHUOXRHh40Wu4gUJp6JDz6WOLnHc=;
        b=drPpmH9QV1Jyvng3f3eR/KoS63crI69KC7KeNT+mjn6QFe5yX7YJe3J1CO5dmBUey3
         y3FvK5oEIxjqOf1uESIfzcH3xA7JNuO/e6Q1PkLw3bV3RrufPTjQzQwRBrR81PYxeKfB
         VKCxbq7ZmoH8fdCLIB6mI3agmdpjbOlAJa9jNKyRVOO2UeIuaKCXzr/NXHZiQYI5TFOp
         ivI+RMjWMM2Ez1U5BTvP7fZymS4AuaKMFtf/NrY57cUGgLc9JxBz0ht6KSapmuidKa0o
         yWvclugb3KaNHJAyXH65+E/Ry1ScFV3TCipXPJX9HBm0giOzvxVDsKoNJwvoybXzLuz3
         CvyA==
X-Gm-Message-State: AOJu0YzeE6/hx0sqjoT8QEsMIaO7swG8b/7cfL1voTfkzsVSlipWgYH/
	1kJVnPkTq5opFnxHm2y3nAkhmPO9qMUZ9fWkEni7aQ==
X-Google-Smtp-Source: AGHT+IFX1vzfFj7K/cg97S6DjsFNL4lBnCxrlnYaZ8OqvBggz5dA/XjA/JyN1jjGB6r+U0Cplz/gNqwkrzZ1/ZQovPc=
X-Received: by 2002:a05:6808:144b:b0:3b8:5e09:8c40 with SMTP id
 x11-20020a056808144b00b003b85e098c40mr4232097oiv.2.1701448211817; Fri, 01 Dec
 2023 08:30:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231201082345.123842367@linuxfoundation.org>
In-Reply-To: <20231201082345.123842367@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 1 Dec 2023 22:00:00 +0530
Message-ID: <CA+G9fYtgTskS4Ar2caWymBrBSaiuoZ3zSOU_OwLPbcKyVEaPuA@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/68] 5.15.141-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Fri, 1 Dec 2023 at 13:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.141 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 03 Dec 2023 08:23:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.141-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.141-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: c66b1a8641b02e3543acc999034525d742f66f6e
* git describe: v5.15.140-69-gc66b1a8641b0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.140-69-gc66b1a8641b0

## Test Regressions (compared to v5.15.140)

## Metric Regressions (compared to v5.15.140)

## Test Fixes (compared to v5.15.140)

## Metric Fixes (compared to v5.15.140)

## Test result summary
total: 96752, pass: 76379, fail: 2787, skip: 17516, xfail: 70

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 114 total, 114 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 32 total, 32 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 24 total, 24 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 35 total, 35 passed, 0 failed

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
