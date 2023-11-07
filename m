Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D55283158C
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 19:18:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="xiFx/fcq"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-7bae0c07007so1207667241.1
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 11:18:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699384705; x=1699989505; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xvnZXUeCL8FhD/wSOV9xBez5fYmNyK+0yuVOgsEAsH4=;
        b=xiFx/fcqhaH15R+yefrr5tKYfWgNhInzBqPLLhB60JV91SvxRWITh3l0vgiZF00mNJ
         BKGV1vIIUnOPY1feXMzpbHJV4nvZyQ7e8nafMR+0+qyi70hccdHn8VVz1yfPkb5AEuHV
         7AAlxeW3NA2D3UGHBLVau4qu8SBNL/SB/7eCTiqLs+jwdWX9/3/iQjLVTqstTcZKYF+/
         LzFh04aTkYf/q3m4DGRh28Ybn6+ej1d02wl359x5/bANh/E9CTSD1OUnOb/jLH2tf8xK
         VlqH2gxtLW8xUfiAMehy3BsQq5Vs4ki95W8S7PQLw0qA9WsTunTJCoyxqR3p3u1lu7tH
         vZ9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699384705; x=1699989505;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xvnZXUeCL8FhD/wSOV9xBez5fYmNyK+0yuVOgsEAsH4=;
        b=mXqamCmG2VDmGwpvfxBFAvt6FeerotAIKfAPqG93Zx0K9+fG5FinHTO5JqsHz6OY/3
         W5aYN9qhXmirrEcNvZWu8el0ZzlvruwOIJKXNBxZJLzrUeqIKKCAdyTw0ZyqmLBGnRrw
         gJ8fRPrZBOIy5nyOMwYwrLc9anqrcQNscuQeFPEARPQd4rzS8bqNe2vFhdkYOQBf/Ipc
         LMLz1CwrrnM8sxdo3qRdZl3RpJthFbm07U25FddGLDtJweEMrRb3wEAKsMPldB85DvUC
         0fVMYpTAkRhDmOm24Y8Ck4etTmxX0sF6kDHXsMVbNiuV6oMJSu5UsI4FioGQvvRKcpSg
         PxBA==
X-Gm-Message-State: AOJu0YxUtWQhJoUr434ixn92Y4nbyNil7suNjafOFo6trU+Nlkqd48yg
	stB0SF3+MjOXiwXvD/wOgB05h0FNtikvzYQ776nGSg==
X-Google-Smtp-Source: AGHT+IFoEKGD38ubwQjgEsqRGCuPvG0XEjqsXZTKxgTt8nqnMXUURC03MKkY+3DBZ4e23cufmAhVlSEGgsKE7bPcg+E=
X-Received: by 2002:a05:6102:3ecd:b0:45d:8b17:905b with SMTP id
 n13-20020a0561023ecd00b0045d8b17905bmr9722877vsv.26.1699384705515; Tue, 07
 Nov 2023 11:18:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231106130257.903265688@linuxfoundation.org>
In-Reply-To: <20231106130257.903265688@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 8 Nov 2023 00:48:14 +0530
Message-ID: <CA+G9fYvh7PbjPGz6AdPTzZz6_evyUjX4tedoHFb0Je6sYsYWBw@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/30] 6.6.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Nov 2023 at 18:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.1 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.1-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: ac6cb619d608d66d3624368b33cf8435168b0008
* git describe: v6.6-31-gac6cb619d608
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6-3=
1-gac6cb619d608

## Test Regressions (compared to v6.6)

## Metric Regressions (compared to v6.6)

## Test Fixes (compared to v6.6)

## Metric Fixes (compared to v6.6)

## Test result summary
total: 140959, pass: 121301, fail: 2037, skip: 17621, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 139 passed, 0 failed
* arm64: 45 total, 43 passed, 2 failed
* i386: 36 total, 36 passed, 0 failed
* mips: 20 total, 20 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 21 total, 21 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

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
