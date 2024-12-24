Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93E6115B102
	for <patches@lists.linux.dev>; Tue, 24 Dec 2024 19:49:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735069794; cv=none; b=dR5TCOXk3P8TjID/nertXlGBuS4/9uCYdueI6PXB3oB93o0VddC+uhk9w/koQ+8SkBOO4yMjdISnPZzK7PwKxahLjtXgG+/jzwlUlF79O0dp6d63IM0NwIvMW0AhpFfv7zP9Xs0eHMWycgpROIufGyvM7491Wh77SkUKehR3I4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735069794; c=relaxed/simple;
	bh=EooV5dRH1VomQVwWesRF5UOBj081lQuMZ5xzC2esV3w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X3h3M/jLUI/16KYEnbcD4l29N1GvLvc7OFi8leM0vQSs2E3DQrt266TP9+itOzrqnt6yzgu6bRySEBUq0Kcwy4SDSTfeTPrZ7VttbEAKMzISg/80MwyWoZ3+q7CM3WDyRIQc7i6xu1o3fvC6UaUJiIbIRWjirRArPcAuT5pyqEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KzMjd6tv; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KzMjd6tv"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-517aea3ee2aso2819530e0c.2
        for <patches@lists.linux.dev>; Tue, 24 Dec 2024 11:49:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1735069791; x=1735674591; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rAhTCxY2E8GbbXq8t2noXElW7YamRqwknMMlRfdq3q4=;
        b=KzMjd6tvS2s8c41yTJeLAsfxIaVZM2Sfgikvnl9KGEDRrO74AnY4AH0pYf5zS2n9ue
         uoiz9C4Qq/oNS1Ry3tlbNem9ChWkbdSuowVjhpM3dyru6khOYIoFfjmldofLFZW3pOYY
         B4Yn2xZwMdUOceNGCiLeqTu7KjBQT06i/9uJeeDJCRvfQ6BQz9Lq7BEKwtqPu6wBHLdm
         R8iFPTnzr26JOjK+sVqC1TDUfLLKwel9S8VCExW+PUtYhMIpjB0qMvA9CVBd+kero5Gn
         p13eeansy3LCXbDF062xf2s8dfBv4vd1TcNpFVzPtxk0tO6VPpD3CvfgEfl2AvTeHYtz
         RSxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735069791; x=1735674591;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rAhTCxY2E8GbbXq8t2noXElW7YamRqwknMMlRfdq3q4=;
        b=plvjB+dJBd4SrTwemqSdHpFhNNjtBiUT42ODAhXNI6VnpkHJV80riUurCPArW2vkvH
         h+VvW2BhbIZMhA0NeJCdu34daR1FD+fcWol//P/KF09eydusvtoxEks1GtZvycsWaI2D
         J8fPjH20cHBPcWJ1C57RnsSLjWkCb8RPqpmENe6OYOOiM6DQU/07dbsjHWtennCRzYQ8
         XscRoVhJhE9Q054Zsv0FfAH4gESTnuGSTmrRqtq29EPrhoY/Vs6AsyPDj21YdwSCktze
         do3pQ0kDPRd3lzhNIS9Fge6+CpfR9SQCYy21eqODxbwD8qdtp2Ur7YRI1T8g9TSoiiGd
         a+Jg==
X-Forwarded-Encrypted: i=1; AJvYcCX+Y7f8ZEKzpULa0g7/EGD5ZwSJOOM7qXuTDj0ZJloT7G+TP/zmbXo5kiLqlXWtbvCrR+1fYUkq@lists.linux.dev
X-Gm-Message-State: AOJu0YwxxYjTUGfePZuCzlpCYnY9nNX4Lr87iZvE7gO1nBph2pcHe9FU
	6ZvPdsEXaPsVcIc1U5g5Pf/Wd7cjfMvQ9YgQ3ZjAHr5JQAqyueIH4xGRVH6F7dYAxp7nUoylzZi
	nzWhbgytHJ0Hee/uIaTApMgQWOIwoGYyFAxr32g==
X-Gm-Gg: ASbGncum1HLW0Zt094LNZ7O7w3YhFf+Ywa/U0/AajjiGNU4nWZdRITipUU70xuulaZf
	kNpqrYyB6PR5h2q40WcX8zSlzrzw/x/NcZblk22+w3L/vllwRO9o2L6w1+0SUI+FCHLDPvd4=
X-Google-Smtp-Source: AGHT+IFXZOp/aPyL2HKTjIsaxhiaUUMaP9Lfk3DUJnOyaEnrBQoiZcjTjC61Pc9/2k80o6cYY6ruMMKiWz7F8XVSb0Y=
X-Received: by 2002:a05:6122:1d0d:b0:50d:35d9:ad60 with SMTP id
 71dfb90a1353d-51b75c6b632mr14745628e0c.5.1735069791462; Tue, 24 Dec 2024
 11:49:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241223155353.641267612@linuxfoundation.org>
In-Reply-To: <20241223155353.641267612@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 25 Dec 2024 01:19:40 +0530
Message-ID: <CA+G9fYsEhViu4e24r+atZA7ideY+n=k=gtGGXkQXJtaVOckp7w@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/83] 6.1.122-rc1 review
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

On Mon, 23 Dec 2024 at 21:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.122 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 27 Dec 2024 15:53:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.122-rc1.gz
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
* kernel: 6.1.122-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 7823105d258c4486e4f3d63c075edb7c91052bf2
* git describe: v6.1.121-84-g7823105d258c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
21-84-g7823105d258c

## Test Regressions (compared to v6.1.120-77-g1855e5062cab)

## Metric Regressions (compared to v6.1.120-77-g1855e5062cab)

## Test Fixes (compared to v6.1.120-77-g1855e5062cab)

## Metric Fixes (compared to v6.1.120-77-g1855e5062cab)

## Test result summary
total: 116739, pass: 91216, fail: 5085, skip: 20365, xfail: 73

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 138 total, 138 passed, 0 failed
* arm64: 44 total, 42 passed, 2 failed
* i386: 31 total, 27 passed, 4 failed
* mips: 30 total, 25 passed, 5 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 36 total, 33 passed, 3 failed
* riscv: 14 total, 13 passed, 1 failed
* s390: 18 total, 17 passed, 1 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 9 total, 8 passed, 1 failed
* x86_64: 36 total, 36 passed, 0 failed

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
* kselftest-x86
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-capability
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
