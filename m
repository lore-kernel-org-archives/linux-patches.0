Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD1B75E0AB
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 14:01:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zTTBPX4z"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-58d06bfadf8so4043686eaf.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 06:01:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701784909; x=1702389709; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q2QEf/lBr77RbAJvG5vi7959AaVxlYnauTCXxwH58FY=;
        b=zTTBPX4zqYiked8zcHJdBFy9Bh0IOBAP71mlGhjd32fEKuX6p+yAynSwIUnYMHhvim
         dGdKn3p8EYjgrq6znfO+4fCLfaprtt7KpJQ0ht1dMiWMxMVxlaf+no67g3aOklfCUnms
         Ixwpa0PmdoqYQ5dwz4Syay1HLVaZvvTFIDydncSG6DAHCtSDP+SOgddu1BtkeXTLzpBI
         fv85E/K2RkSIdgTd/OUe8ngfviiwwvkm0J8f+wnHr+J085/HnvDbaYNr8c/7LUdPVdsK
         T1zjompWthia0UcYAfqI+0kjSuPrq2RGyHFWZvazrr/cSDN2ZVrXgFZp7r9ayAk3t1JP
         qFcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701784909; x=1702389709;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q2QEf/lBr77RbAJvG5vi7959AaVxlYnauTCXxwH58FY=;
        b=TBWjtUJAU1AJEPz5NGqWklsIFowvEdv+wjxqSiq53Pmgkr3aeRbAfhErNAcvNsKmMv
         73yvTjZIEwchtl6MmCtY7TwnRvXRTRcjdVmlXkmalus36IKJhV78+10gI67UE9zm42mI
         JsGv80QsrD5BS1pk4cXs8Gktcqcpr0js2Ox6ResTk7My1quBCVYzA6zCqVT9RcbYXeJE
         nAjKQH+FdqlpXxHz6rW3xMUSHbTQxPwCZ3v4BLRHmhyxFNQioHX2iIieI0qciYYQE7o+
         s2uoLq1pOvJm2ie828ixEYtQyFgOqvA+aIIMApBH3iEIMwN1SyEVCjA+NhJotiQX04OX
         NlfA==
X-Gm-Message-State: AOJu0Yz8P+aQjwpAraOwPw1paolKqYtGjG0IuUYK5h/2hVY4ycrTFHKz
	l626NgVhxBZYFaFfgpuTlB1OUxc0o97B1ly16VRrXA==
X-Google-Smtp-Source: AGHT+IH2y23DiNViv19gr+3P2n07qqR3+HXI5Ll8OTrQ10bG9dd7fvVIWWaEEK3HDN+3LbzRokbZo1i9HVtKRs33mNc=
X-Received: by 2002:a05:6358:71cd:b0:170:3f9f:b367 with SMTP id
 u13-20020a05635871cd00b001703f9fb367mr2362102rwu.26.1701784909498; Tue, 05
 Dec 2023 06:01:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231205031511.476698159@linuxfoundation.org>
In-Reply-To: <20231205031511.476698159@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 5 Dec 2023 19:31:38 +0530
Message-ID: <CA+G9fYuGmAStz97QEyPj+pg6Pu0zmffx1Y4NWpd76Kt=tH4t2A@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/30] 4.14.332-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Dec 2023 at 08:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.332 release.
> There are 30 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.332-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.332-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 4937f1b0d0b4f85ff80f69a662a98e03626a7005
* git describe: v4.14.331-31-g4937f1b0d0b4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.331-31-g4937f1b0d0b4

## Test Regressions (compared to v4.14.331)

## Metric Regressions (compared to v4.14.331)

## Test Fixes (compared to v4.14.331)

## Metric Fixes (compared to v4.14.331)

## Test result summary
total: 52878, pass: 44955, fail: 1219, skip: 6659, xfail: 45

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 108 total, 103 passed, 5 failed
* arm64: 35 total, 31 passed, 4 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 19 total, 19 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 8 total, 7 passed, 1 failed
* s390: 6 total, 5 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 27 total, 23 passed, 4 failed

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
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
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
* kselftest-user
* kselftest-vm
* kselftest-zram
* kunit
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
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
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
