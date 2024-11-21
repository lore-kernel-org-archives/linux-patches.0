Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B07541C3046
	for <patches@lists.linux.dev>; Thu, 21 Nov 2024 11:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732189107; cv=none; b=uV1V1opgIASsLdbt0oAoVpV0n3EgSqLHeIb1f9g07LrBZnnvMpk3b9uUey8+teF++UCoi1Q0+Z6jyd3LSZkl+7mQGnDFaRw1WBoCpOXqWfy0yANUWWGpj0MAXW3w+gor8eieySopkq3BKeVWGTp2dN/QLdRdBA+Ti3fEZFRPv0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732189107; c=relaxed/simple;
	bh=GoTq39iPiD/MsBXuMgTX/y+bT00dhL9Tn6diA5FsVT0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nZiXBcbNHkWYguKW7Z+3J3EiIWhJKCy5MKd8y8mEq4w6NIZF45p8kkZsuXWxOcJna/eSc4+QJ+6haOKQ8LZcqNwjEJPr4gD/03eS8CIpCe7Ki92w3e5wqdYZ2qSXmVx+79os2RWCBIz9j0AuEObjL67QQ14tGM9AFLK0j5rsGlc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uYKtuvsJ; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uYKtuvsJ"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-8570543feaaso300778241.2
        for <patches@lists.linux.dev>; Thu, 21 Nov 2024 03:38:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732189104; x=1732793904; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=F7ukX8ZlTj96KIQhfZzpEJEoiPzLwIJpbM5cfdfMhxs=;
        b=uYKtuvsJ8w44CVLvOY0Tc+SQ7hHHk6L3BgkxKEG1TcXwkQHYTQqS4Q4U5F82eocsju
         9Mv/zTDYq30BmRncxdml1bhmd8WP6Wd+USaLHFPhCzQvnxPIbCayOsCcmguWScaM2fr6
         /YnDJ0Udq2Iw+WgnJXZTBGClEUsH3GTuAzOk4TaVLmtg2w/NJc9RQD7bT1wb8tV5R8xv
         3oC1tn3rci4/LvcNsVjbqoLBKmAho19nqAqMqL/H7X3SMJaTe3e7dc5zKJwIGkKqOUn9
         sEN5FMKNjX3psyvWMXLd/IXCjZck5RXLbPgqly/2PdjqJZOw+/KdriBVY+O9fL8OlKiJ
         jf7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732189104; x=1732793904;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=F7ukX8ZlTj96KIQhfZzpEJEoiPzLwIJpbM5cfdfMhxs=;
        b=A3y8EKRjhQ2vvOFp7J6mhhmizJM2D98YJIuy405rGn3lcCmNc+mYIGWCf+osjcTwz9
         g40u5YpJd/qD1nkO52foPZrkAfY+uS9cyuLw4d29TBPWSuE6NOyan5qoJI6niHlp2Opl
         4/NSy+P4cXOEQPQQu3lMCZBDpndCmu/dtOg5s5l+Vs9cwywRi+V7/Nc1FI76iZtnjmwR
         QCSQJNBaPD+Uo/Z1NMWZg6YFBernk58UIgFReu15AFxhdGU9egGW5bMUhyx957wMuv3i
         bURADs7veQh2WQe15Lb95Evwuz0brwz64x8RTO4Pt/kbn2LXh37+ro93mMogx/4tucxM
         CiZQ==
X-Forwarded-Encrypted: i=1; AJvYcCUKd6TjEKbcSR7R08fcNLXV73bHM8gbNprvlCmXB2MTMYdYV260ORWB5ug/TyN+IjRGKKMRgxvV@lists.linux.dev
X-Gm-Message-State: AOJu0YxApSFnFMJf4RYUL1p6Itvh/ahChQvGBVzxHEueWZrVGDSroIZf
	wFmsdCYgjZLnFUVVB2WpiigpgZi2wpT1ODuf4rw9AqSK/qQBgNGOxPhIAW0VVV6JOqu1oBieh/A
	h0yMQTbt2MwlYMGBpAaTTR5+lEZzvM4/KZvVfQg==
X-Gm-Gg: ASbGncvPfOdL0twW/ZPQ9cT96HW6K/F/NROs/VZpvFb21kbfIpKWliYKqBWX1m53vg5
	1u52jzdAZrkF83+xE9YfP6BuJ2AWcVZbcLa0vpDb6hE86PBYfSuPxHzgCnNu+T0Op
X-Google-Smtp-Source: AGHT+IEmTnYwUS/GoFS5lHtmsk6MPCKN7/BBErYWheG+A2g8DHXNCtrFTmlMdEgbpvkK0+ZlnzCUB4v1D+drV8T/SYU=
X-Received: by 2002:a05:6122:640c:20b0:514:ea11:4ee5 with SMTP id
 71dfb90a1353d-514ea11529fmr708139e0c.1.1732189104384; Thu, 21 Nov 2024
 03:38:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241120125629.681745345@linuxfoundation.org>
In-Reply-To: <20241120125629.681745345@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 21 Nov 2024 17:08:12 +0530
Message-ID: <CA+G9fYsaZNm2VKnm10tR4dy0DfnE3_FQtkj-E9-SPR-RacXxcw@mail.gmail.com>
Subject: Re: [PATCH 6.11 000/107] 6.11.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Nov 2024 at 18:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.11.10 release.
> There are 107 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 Nov 2024 12:56:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.11.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.11.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.11.10-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: c9b39c48bf4a40a9445a429ca741a25ba6961cca
* git describe: v6.11.9-108-gc9b39c48bf4a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.11.y/build/v6.11=
.9-108-gc9b39c48bf4a

## Test Regressions (compared to v6.11.7-249-g0862a6020163)

## Metric Regressions (compared to v6.11.7-249-g0862a6020163)

## Test Fixes (compared to v6.11.7-249-g0862a6020163)

## Metric Fixes (compared to v6.11.7-249-g0862a6020163)

## Test result summary
total: 154549, pass: 128415, fail: 1847, skip: 24287, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 130 total, 128 passed, 2 failed
* arm64: 42 total, 42 passed, 0 failed
* i386: 18 total, 16 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 30 passed, 1 failed, 1 skipped
* riscv: 16 total, 15 passed, 1 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 34 total, 34 passed, 0 failed

## Test suites summary
* boot
* commands
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
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
* kselftest-kcmp
* kselftest-kvm
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-mincore
* kselftest-mqueue
* kselftest-net
* kselftest-net-mptcp
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-rust
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-fs
* ltp-fs[
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-hugetlb
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-syscalls
* ltp-tr[
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
