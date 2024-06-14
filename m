Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C2F1147C96
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 06:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718345671; cv=none; b=E6hY2LcElmTvHq7bF3oVIg4pHPQRt/oGBs1ptk8Q2O9nRl5qkdxEF3Ru2OK+1Qa4gXxTOX4NdBIMXoq24eQkskZpLxDlkJVAMAzR9CxbEUq9XVvBbGEiuDv7Z+sRgKraIlWsjRZitcaGBVrxOUzJ6zlpDwgFNwcaGLGrXTPS0nA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718345671; c=relaxed/simple;
	bh=MytOr15lMP9zYsxVhkxbv0AtZvnkkeakkDkldFUcRxU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZwiZzVbpz+uWnXUguOjGLRUHAFvSC+oJk/g5Asrc89kOywNSVKhdO2oBew3EfuFN0QIa6rusNjYed1MVXUva5LW5f1xNlkilPUblUWflzpoOHv3bDa+zdBuhMCYrkNA5R6G5Nd4lT/HYXrMpW0MtByTcNNLK7zz9nKMQ3GxEu9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=brMWsW7j; arc=none smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="brMWsW7j"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-48c39fe4ee3so450944137.1
        for <patches@lists.linux.dev>; Thu, 13 Jun 2024 23:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718345668; x=1718950468; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BoQCHg8nTsh29WFdq4yg901so4FoHg732Ietl0cilNY=;
        b=brMWsW7jGeDQuD1/tpYhsnaVWA3YBJX6YcsxKq0oM91u/0I32TH9+eDhCNidUJr9/N
         z/LdBaTnlNuqCmyno1+ho3loGSO0z7LKnPEoBpbPVXxuP3ADZ6OWvN8vIJaKHwJtKJGS
         os1N63Kac7Au5FJumaK2v7gIE5WysE4IoxZQ2KhILSwL9ebPwJXyT0j263U80QWZSpME
         PhOOjf1z59uh/LJUYlaRAPFAvJu1FoRtmI8DenB4qoscvip5EpGkhT5P6/oz56yNlcuC
         ILvCyKcKLFeRvKhIy7Z/X7AtTkbcwA2AsOmW775D3AQBkCkgLGk4UTvtphll3awxlkng
         66KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718345668; x=1718950468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BoQCHg8nTsh29WFdq4yg901so4FoHg732Ietl0cilNY=;
        b=bG9V7JWhQtH5GS5FDViLZHklk27GFSipDx793ilVj1zX7Mxa06iT6PbECGqhsiLZyc
         KCFA9PnDIfwhet77izn0I2ldRQC9w6ha15Fe69hcBgj6QO/RsCcqvN1cVlHeJweNtb9q
         nUZ3R5fNXj1yLk7SHlD1do0V09FXdmjPCBNqE5XYaE3ZJ+hLFdYQ1aPQF1xrY4MYqtWj
         5NDofGlBIQ2Qtk+X6h1jo3KCCmJKfNPkpE1GFexDJaeQxe2rl1tu5MFdsBRJI2B9ix05
         5pEaGl92Maar/UMbkGiCP48EDHLowY+HNNp006sM4Bak0draHYaVdzu0PEJEaxZTjLAX
         jjrg==
X-Forwarded-Encrypted: i=1; AJvYcCWZ/uODZK2LaiiqVBYGMDq7ISSIG/Gi7KKIp7DdNl/vlPnQTo3wny1wHHrxgoeGgKyAqnWLfAUDgVpLPly6plJfpsqcVjCk6Q==
X-Gm-Message-State: AOJu0YzMsd9pjb14rI/PX3WgryY1XWW2CZqKb2Pq95prucuCAQN4X7Yv
	XHecGZYZXI6y2f8dvwv6/echPIWK1YfvmXrlAR+q0sH9JL44EO+7iYVnq9sQL/OvO8VJOJ5Tn32
	d/ebbAHS8b9URt0mlI2yzCkRsN7fp7U/KqpKMOA==
X-Google-Smtp-Source: AGHT+IEVZCYAAQG7nnH9roHg5Tyj8jl++9tnhsT+t3AfgbA2BKnr0VLls1SY6LHX7bDPAF2WAjTvShgUu929VcT/WkU=
X-Received: by 2002:a05:6102:124f:b0:48c:368c:3673 with SMTP id
 ada2fe7eead31-48dae404fe1mr1824714137.28.1718345667916; Thu, 13 Jun 2024
 23:14:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240613113227.389465891@linuxfoundation.org>
In-Reply-To: <20240613113227.389465891@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 14 Jun 2024 11:44:16 +0530
Message-ID: <CA+G9fYsPRCZY+n3iJfLj-KhWzNHaG7q8198F+okV7zKPR9NVjA@mail.gmail.com>
Subject: Re: [PATCH 6.9 000/157] 6.9.5-rc1 review
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

On Thu, 13 Jun 2024 at 17:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.9.5 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.9.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.9.5-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.9.y
* git commit: 3fc8ec8cbfb63bed37f4702410201c973a690450
* git describe: v6.9.2-957-g3fc8ec8cbfb6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.9.y/build/v6.9.2=
-957-g3fc8ec8cbfb6

## Test Regressions (compared to v6.9.2-797-g4aee3af1daf2)

## Metric Regressions (compared to v6.9.2-797-g4aee3af1daf2)

## Test Fixes (compared to v6.9.2-797-g4aee3af1daf2)

## Metric Fixes (compared to v6.9.2-797-g4aee3af1daf2)

## Test result summary
total: 163101, pass: 141914, fail: 2059, skip: 19128, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
