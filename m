Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC1E2BAEC
	for <patches@lists.linux.dev>; Mon, 15 Jan 2024 10:01:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fb5Hs+Tm"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-7ce4512d308so4659718241.1
        for <patches@lists.linux.dev>; Mon, 15 Jan 2024 02:01:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705312896; x=1705917696; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mkEfzu4mMXddQZ/Sz0Ukt1X6OmhWIm+0FNHN20uxA2Y=;
        b=fb5Hs+TmC7wUKCLeZVkofKJ+DuRAbm1138XTxlKQwxkXARw4JhCeUnivF/jeiinS+I
         ZPhpbFR3f1AUQ8g+YKQr+3m1Q36QMjM5DGpP/PvlW40Q1PgygB9ZKPWhPaMy4TDdaFWi
         HgimWm5v+J9fMpSAxlzqMYOjrtD6tIRSVmI9hbS+3OcGykV2BRVEQIKBsF9nOjZEnLt+
         WSbox2u34GUQ/BUXVjI42/HQt5Z14Jfi/q8ijp/DyUjsmahNWemjQFsCbwVDGsw2gF+7
         ZJ2Y4z3enEpsk9Bm0u0gizioOuqxjZtuSwld3YZ9rU5TjcELixXucCkXR/nzZFzpxh9P
         MmIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705312896; x=1705917696;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mkEfzu4mMXddQZ/Sz0Ukt1X6OmhWIm+0FNHN20uxA2Y=;
        b=ZJctwSS7UIWN//bxoTxUhU2fN/fdB91w1vrfS3HAcxzDgnN/FGWbPFJjnRMdpa816K
         DIe1QsERCbAxvU20y6vmd+DhrGVZI7BnwvcQVBneWBL2yEeBERhdiKrnbIDTWf40MhcQ
         XWnKZfCW6djclthXuzPpvDOX2JTnFPIC8dm73UXx7/LpWaiEsOdfMNIQjIfOBWB+AeLh
         AfOd9b8bBHMsDvt0ZQZAPvJGP/ihJfOZ14mvhNRDENyfL2oY+27M3rjIaX9IXHLWmmTL
         jCc4XbmhAgY/em6SHyAyrLJlSIavVXSsEpylWxn9FTvGElBkDPnQpJQkyh+EKPSaqK1G
         AmYQ==
X-Gm-Message-State: AOJu0YzfoNMhwB66jiOETItCU2MlXew61TLgQ4gKAJTVOATVAmIvkWcM
	SlWs+rvrqYu9FEstQQnHl4mR5OkrgEIQ4ydVOYV434exDBHK6w==
X-Google-Smtp-Source: AGHT+IF8BFiFWm3ualWb7Gjmgs5qXXzN13P12cr22iMtnJAHgVarMnIPYedgeRVyuTIDHnhg9etA9Ii1k66yE6jG/Sc=
X-Received: by 2002:a05:6102:ac6:b0:467:efd0:f0b4 with SMTP id
 m6-20020a0561020ac600b00467efd0f0b4mr3999606vsh.23.1705312896039; Mon, 15 Jan
 2024 02:01:36 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240113094209.301672391@linuxfoundation.org>
In-Reply-To: <20240113094209.301672391@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 15 Jan 2024 15:31:24 +0530
Message-ID: <CA+G9fYu9XP80HSzMBGZe2_2e-jjOb=Cbjw9QR7ajp8Ex0DEXEQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/59] 5.15.147-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 13 Jan 2024 at 15:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.147 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 15 Jan 2024 09:41:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.147-rc1.gz
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
* kernel: 5.15.147-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: f40fefd14722e8606bc4d5c3b52e22bc8d5ea362
* git describe: v5.15.146-60-gf40fefd14722
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.146-60-gf40fefd14722/

## Test Regressions (compared to v5.15.145)

## Metric Regressions (compared to v5.15.145)

## Test Fixes (compared to v5.15.145)

## Metric Fixes (compared to v5.15.145)

## Test result summary
total: 175918, pass: 139063, fail: 4306, skip: 32380, xfail: 169

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 117 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 33 total, 33 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 26 total, 26 passed, 0 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 11 total, 11 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
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
