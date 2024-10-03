Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F31016E886
	for <patches@lists.linux.dev>; Thu,  3 Oct 2024 14:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727966592; cv=none; b=rHglssKqzz8gSAKhK6g00rBnYQu/I7Gp46nPi8yTEX1CSzhjtf0vS9ZfBx5hJl+c3gjq1MNqYN1sxHKRyC1Yizly6WeU01ytq1JCEbG/4r0No5nHgakwfG08GoQIOnJK50jfYvaLtcgSjEp2WUOqAYeDDEddByz5QRmrJjgMHqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727966592; c=relaxed/simple;
	bh=nzrT9txoUNm2tCbFCELuiWr769P/fLWk67w2gdUIfNg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oEdAEWigjb4ziDJcmOp2FTS7tRZeO8Oeew+VadvbYrdUOfVqQbLPfmeT50/p28GYUFPMqkcZz8tGaJUDZrvF/c8qkEtG8WPzEWf/tZAg3hr+tMMs8s+gsko5LOf1C0awMrJGzjdCwuZb+1yRLn3XUNhKeIoGubiB2p5FIJknOgQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YiaLC0m7; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YiaLC0m7"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-4a3a77d435fso266717137.3
        for <patches@lists.linux.dev>; Thu, 03 Oct 2024 07:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1727966589; x=1728571389; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KzPMIwM47GdFMCQF2aB/8Fmv8rw2SCurIv7fQEUearg=;
        b=YiaLC0m7flvCAf9DcWezYFBB9yfP2OXW2tpoU/HJn2TdPqAybAD+sKQAsk+GMJyVqh
         KnurbEVQo5+ALUfxgqXpq3M6B5+Z9bTLb2jiuY6BULt9FUJI+uohHVeovMPBWgzCNOBE
         BYkZ6OvE8lcoggWYquuaM9KEh0CUI/Kh1cqLWh6VYdlStVi7Nh+yVV2RB+cmX7FSsb7i
         ZBciie28vVtffmu7GqCyWZpmGa1chzVq95JarkrbKYRNQAKDtOxK74ZdAL80YFKzU5Zd
         4GJN5shiutTp8wptIJAQx/edU640xIo2MxXRbzb6DXcuX/6C3Wa95lJH3dlk/2c9Unsc
         FwEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727966589; x=1728571389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KzPMIwM47GdFMCQF2aB/8Fmv8rw2SCurIv7fQEUearg=;
        b=M3zSHd8xbgvDNf6kXsWlL5lsQZG61vb3tyy8rKHSqMcCaQ3CVdpZuQWP3ggH1EBDn0
         fwzEJinBaWOApVfB2vGhOlEc24dFJBh0c7YHAtyzE5Qhpp8kQOO92VgLI/ATZ5Q717u5
         B1ii09xMMHSCmGGg51ZeqCSgCYrfCzPBxe9G4IBTD5Ibw9r9G97n/CbYwfnMqoymCGUq
         z5H2MZ/H1DcQ7bHDC8mTzLBu2JgrFVX0Gymu5uw7U8LKh7hOMx5DLyMwoIaCws/HAcBJ
         h6lWlBBfw6KwJ7hjVxw1/z5adc0YBu/fFzCUqfWyAIhGVa4M2yxzyQOXe4m5PqM507kR
         ENUA==
X-Forwarded-Encrypted: i=1; AJvYcCV+dfaIn6KFdzCLY3FvRmOCHDXwWycKU3s4ERx1TzLsS9GkWT3yIQcfqOhlM+3ED7+poXlkQN2e@lists.linux.dev
X-Gm-Message-State: AOJu0YwLTQhlgcqM81MnL3yVCKDvEuqvMGA7uTo5A4rOUW/O5TCg/Vx8
	i/xhDzAyN/V4FFeMdSG01MXTjSH6cXXODLJJmptEusBnrE2qyjoJjAO/1YUidFz+Obd/MI8X9R4
	lep+iNHmN9KYP3jmuBhCUQVsl8Uy9MCOeF0PA+A==
X-Google-Smtp-Source: AGHT+IHeWg3AMl+TwKVwk49s+iH8ah5Trk6MJpXj/71J6Q2kfTA+Kfp/l/dkdK73jpJ/mQ6L4Jh9SUs/ymqKlo/mYG0=
X-Received: by 2002:a05:6102:c46:b0:4a3:d8ab:8938 with SMTP id
 ada2fe7eead31-4a3e6852752mr5954103137.12.1727966589244; Thu, 03 Oct 2024
 07:43:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241003103209.857606770@linuxfoundation.org>
In-Reply-To: <20241003103209.857606770@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 3 Oct 2024 20:12:56 +0530
Message-ID: <CA+G9fYvAAKwe_LMb+cXnLoDE1a_Ji2o+C6j=ud64ET3wbiZTBA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/533] 6.6.54-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 3 Oct 2024 at 16:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.54 release.
> There are 533 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Oct 2024 10:30:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.54-rc2.gz
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
* kernel: 6.6.54-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 28c7e30f3bb639399f5f62ae5f201bba7dd69e55
* git describe: v6.6.53-534-g28c7e30f3bb6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.5=
3-534-g28c7e30f3bb6

## Test Regressions (compared to v6.6.51-145-g3ecfbb62e37a)

## Metric Regressions (compared to v6.6.51-145-g3ecfbb62e37a)

## Test Fixes (compared to v6.6.51-145-g3ecfbb62e37a)

## Metric Fixes (compared to v6.6.51-145-g3ecfbb62e37a)

## Test result summary
total: 169067, pass: 148166, fail: 1582, skip: 19133, xfail: 186

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 40 total, 40 passed, 0 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 10 total, 10 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

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
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
