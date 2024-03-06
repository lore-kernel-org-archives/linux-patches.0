Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D15F8289A
	for <patches@lists.linux.dev>; Wed,  6 Mar 2024 12:56:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709729769; cv=none; b=c7M+rQ+5IHy9OgOrw/7p+/w5gi4xruRlklU46Vbv3DqIv+lmt6W08U37YD6X8Z9kLxy2CWCwEqK3CySp+9u2GPXvFGjL1N5aMVrIt4w2ybHrmA+44NjhBxpBvpAQwKdH9f9iU+XZGPrT2x2lxrxkGT569y0sBIgbfTDAA/64YRs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709729769; c=relaxed/simple;
	bh=PgHt/os8BmHr6ku0XPfx09raukbvgI1JM8YKUigkwqI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fyw92gs8px1qPNCr5gkaruxk2KSZ0eBVES2D3Xk4JQ+SRR4jTXXFgBy46biIR20UQAeZVwZooSpAchvMtwVSs99M/avjGlYPnLpxIOljwFeEy05cHtZwsUdKWviCqlUCL6FKVDcnezZWv2RR9cn32rpild9PdtJJcT34TNToW7Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jpXw8xkt; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jpXw8xkt"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-7d130979108so3707103241.1
        for <patches@lists.linux.dev>; Wed, 06 Mar 2024 04:56:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709729766; x=1710334566; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mF51TmcU3SYCWdS+xut7sKhWkD9/Cw1BL/jjWneKjIw=;
        b=jpXw8xktG5CBTCG9AhQBNoDKW/CK1rwwk8EXKWRs5QHrzwLIKTkenp31Z4zyrwRPv9
         XCjPG18olGGA0UQRKkKvGY62UQLNmaVnO2xtHKVs+RBeEZJrk9gwq5FhyCL9YX52u49m
         iW563bqb0W+63viigBBqvuE+NluM2NPfCXa+jkHfKdAPKE9gy+grI3CoEt0pI8qTScaK
         x4H/P5azPWt8X9BY7qMSbWw+pKaa/l/8nbeTrqzJvad6ncZ+sv+2t1m0CCvqxshdh945
         xK3EAqcE2tGLEKx+4KYVcAUf2JdUfY9T8av+SRN92yU3hOBz/2ILBFQrLpWF9Yf0xA9F
         jXSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709729766; x=1710334566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mF51TmcU3SYCWdS+xut7sKhWkD9/Cw1BL/jjWneKjIw=;
        b=YjOtuGn9ARkeziIBXOYLZx6LRGovuJLgQJy1qYmeYkEZuxk672nWfJgB7ugO08hCrG
         wNqnEkjBqDWbazy+PWpjP2N1qFPRWQu4zVEoph4ieod10RIPyueB7D0NkdnYPp66kQXP
         dSiDH0adeuFdfemT4il4jsm4mRWfVDAPJP4rMMJ4n6IKyO7ul0zZ6JbO2wyx2By9OkkF
         0il9XZYb/8KuLodhPevTW6Px21i24FLKLo5kVSM6Yba95iEJkwfhuyIrs2r3Mw+XB8e5
         m716P3Fj0CCoRjnHwEohVUR6jh07Lgq8eS1c2ekt6geJDibwC7rUIBSB6PYWFzFes0MO
         zIIQ==
X-Forwarded-Encrypted: i=1; AJvYcCUE3qXhGtQdh56QczwABlCEU3KwJRsfVZD9gYqZbrVacj9VbeWJoNCZCo/H48nzkP/Lpi/7POw5kHFChJ60z2wgqfd/kTF5Tw==
X-Gm-Message-State: AOJu0YxHIm26a/WBfflBH5RHyfxGHsepfgZ8BL6U65UiDDJywq/SDvuu
	V1+dvfSCY4gzN0UccUIksf/tIchGWS7LqbCMtYTepbAW4g360f6K/cXIZDnKs8gRhmH81rNq+g7
	+WmIEwGUS2hKniyJSXr6qEVp5h+y30aI9aeMV2w==
X-Google-Smtp-Source: AGHT+IGYfA7GXwmmA55ca5fewYia6cPXDbMo0V4xJFmtFcpijfX6V7O8HrKJ4j/b4c4yZ/koOoyYa9hnBv9GtCTyue0=
X-Received: by 2002:a05:6122:3683:b0:4cd:b55a:bb0d with SMTP id
 ec3-20020a056122368300b004cdb55abb0dmr5608477vkb.2.1709729765868; Wed, 06 Mar
 2024 04:56:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304211549.876981797@linuxfoundation.org>
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 6 Mar 2024 18:25:54 +0530
Message-ID: <CA+G9fYvTnAyEt-Cn7fmXQ2FK3+xLyOULmcxhrk7dMTypckDEsA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/143] 6.6.21-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Mar 2024 at 03:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.21 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.21-rc1.gz
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
* kernel: 6.6.21-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: 5f9255b6ac459ba1b98dfffa0680a5700447d28c
* git describe: v6.6.18-445-g5f9255b6ac45
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
8-445-g5f9255b6ac45

## Test Regressions (compared to v6.6.18)

## Metric Regressions (compared to v6.6.18)

## Test Fixes (compared to v6.6.18)

## Metric Fixes (compared to v6.6.18)

## Test result summary
total: 168781, pass: 145491, fail: 2395, skip: 20734, xfail: 161

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 132 passed, 3 failed
* arm64: 43 total, 41 passed, 2 failed
* i386: 35 total, 30 passed, 5 failed
* mips: 26 total, 23 passed, 3 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 28 passed, 8 failed
* riscv: 18 total, 18 passed, 0 failed
* s390: 13 total, 13 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 39 total, 34 passed, 5 failed

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
* kselftest-mm
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
