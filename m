Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC26186C
	for <patches@lists.linux.dev>; Sun, 31 Dec 2023 09:19:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BOI338+i"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-7ccdb4b764cso1447163241.2
        for <patches@lists.linux.dev>; Sun, 31 Dec 2023 01:19:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704014369; x=1704619169; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=z57RM1fNbmrtEv6jg/m4997t5OrAt8z1G3Y1wCnQ9RA=;
        b=BOI338+iOdVYQbdxj2u0dJtJvQGZ+MGUfDLB5Y5B41W1eMSOMVd74Z2/vJFjodhohb
         gyBvBDfVmaDrD0d2F/pWSZQUW5pvYknszrAuQ6WxfSKjs3Sdl35xytEkmvXXWxfRJTRQ
         Ot55WIHemsAi7UcliiF0tVoFrQNvH0/MbzvazX9XR4sRo3iMUjBUIxCwXQKE++Cu+v6s
         EZtGt88vFwHmnSYY2XBk7Q6NhXVJeK7cBoS3ol2Gb+id6Ncgs3Doqh3LFmWzoaXB5253
         JSRQIk4zrd6sVBBTGkdu0vUgJcHtoIZBeErqd3EO6L/3U0cZjp022m15Pq0naZHiiPg6
         NM7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704014369; x=1704619169;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=z57RM1fNbmrtEv6jg/m4997t5OrAt8z1G3Y1wCnQ9RA=;
        b=UgBmEVxtETYhn2w90dKCLHKK7TuoogbgcPzCT2QW0Rbe4ymUeWjj8REZz2TcWYdVb9
         933MLPfWLPzr3+BdBov/jjAhrUobtNdTzSKD/pvp2hm8C6WTFHRHGU3tIpJ/8FPWsY0t
         xNQDOoXm3MjxpCG1L9z83fAqOE+usCeYP+DbKS5tUs3r/iUiNFP7OZrAVZazF43ejHy1
         48MbCbkvv26Nx8ykbr4zf1rNC8ESVvBbkGGFU1l4tNOPzu4q84a0sLpGh6eYPBVvVEpC
         AVTLx93DUAOTA010/BxWlk7umoRCLEX2uBvRYgkEPKY+n0VLSPE9wKT/QZ3Ww34P/KVC
         vUcw==
X-Gm-Message-State: AOJu0YxhE+AGLepIPSFY7mK6914v5K2esQ5ZZQqu8mLV0FsgEQ/thQG1
	uChlH+ca6zqqnhnmyYMVya6yiW9D76noK6ZwfIL4ckJr2op3Rw==
X-Google-Smtp-Source: AGHT+IFk9HuSLWUjiPPv4w/by2IqhdFrwsxlLI3rBdfNY9K7U/RdbbTmY62Mcylk/fNVU2ivAtiqk6kYIPKq4DF3r4k=
X-Received: by 2002:a05:6102:1497:b0:466:f492:9dcf with SMTP id
 d23-20020a056102149700b00466f4929dcfmr7086024vsv.23.1704014368225; Sun, 31
 Dec 2023 01:19:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231230115812.333117904@linuxfoundation.org>
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sun, 31 Dec 2023 14:49:16 +0530
Message-ID: <CA+G9fYudfiJBq4eXwnjFbTdVpPVUSUnqkaUjaLxtnRpH3o4Gmw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/156] 6.6.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 30 Dec 2023 at 17:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.9 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 01 Jan 2024 11:57:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.9-rc1.gz
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
* kernel: 6.6.9-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: ac5757a323d0d58e1e9f6a43cb374d4fbcd14db5
* git describe: v6.6.8-157-gac5757a323d0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.8=
-157-gac5757a323d0

## Test Regressions (compared to v6.6.7)

## Metric Regressions (compared to v6.6.7)

## Test Fixes (compared to v6.6.7)

## Metric Fixes (compared to v6.6.7)

## Test result summary
total: 152743, pass: 130798, fail: 2523, skip: 19299, xfail: 123

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 144 passed, 1 failed
* arm64: 52 total, 49 passed, 3 failed
* i386: 41 total, 40 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 25 total, 24 passed, 1 failed
* s390: 13 total, 13 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 45 passed, 1 failed

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
