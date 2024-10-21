Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 596901C7B68
	for <patches@lists.linux.dev>; Mon, 21 Oct 2024 19:57:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729540649; cv=none; b=esddLAy4uM1ExXcO62A5NO8SCIU8Y7uB8a+ltFdALqXxpS5cOVGOmTM+xKYUTaBbT7QDxtX68itgUeBfhpPAkimSyPjq14VIAPrxzGUm+9T/S58TID0fOolnUQLTMvXfxWb68UqmbWlR6clGonIj//MFd+jhcYbfqId3UYONAS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729540649; c=relaxed/simple;
	bh=qOutugFCpepW8u5UYINmN7xH5gJdHqlJntLv8cxtA44=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hJIsz1ERH7yJsGL/Rhl+byGAhP759l+HlxxmDG/gxcWXihrGNMzDsC7hjKInIxAGLLCRNeBdjFMU/q/vl1lQYClR2CLgap+YRg3acmBNcf8+R7q/0fDhEalqBframx5YiFqe8BM83M9yHXJeFnQxrQWP8kVIPwDAXqKAfbn0cXs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ZUcMMI+1; arc=none smtp.client-ip=209.85.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ZUcMMI+1"
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-84fb86af725so1348149241.0
        for <patches@lists.linux.dev>; Mon, 21 Oct 2024 12:57:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1729540646; x=1730145446; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cH/iMGwmL8zueR5LtHUH4E+NzMcpI4d6jTgQKxN0ldQ=;
        b=ZUcMMI+10a5uypPL4gU+Az+8Kg82R9jSAQ+oFZ3itZARk6bDUJudD1y6O0nNNrPb17
         IVU4q8Oj2XDRmztSVQ9TtvbD/Z82dSTlfVqOPkEHgR6Q98aPpFSlWfWHC3JHjTfINGJ7
         v14nLZgkvXmrCnHIADs3JBZqJReXdli+PY+8roQPimqma+uxqfzNJdbe7Kty3xDOW/tJ
         RsUdGWPaPHyqLJvUdtPDwz5wfI+vqLz3+cf2efrWeLY+EHZ2BeEZUboNZfrjbbGGPJye
         WM3QPWheXH2WnsaGT6KEz2GIR16A0xW26w5Yp8rS+7eO0bKO0Ebwscz9lRk+yY3Pwtzw
         4iUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1729540646; x=1730145446;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cH/iMGwmL8zueR5LtHUH4E+NzMcpI4d6jTgQKxN0ldQ=;
        b=NsLwlGMXVEiifBjnmP/TfVctDfFvriG1KfZlsfcbljxSlU3vLWa5lAVcSrkWHNyJlM
         Utj4RBlnvdZdxmaJBPjSsToO1pNHI+pIEZkRZjvvOeDr+CU2C4Zp9TyIgZlnirdcW2jO
         oiqv8hq0x3XrZOliCHOz6lF7GqdRPHI0ElfhQSn/K08M8hRF+mSoZZ8dDfYWxLsHGLpR
         mnqQi8G+50TW+tjMuriaZnJSBWN6eW7A0/5r9lWJ8Oied6qeBK2ipIiNYvkk4VC4lsWP
         DsP+YDxiioSfQ7sEbkSjkufgGBeGorfdarkF8DE6gpNpFJVnL1JJn8EjBHHlMhjEupsI
         ZCyg==
X-Forwarded-Encrypted: i=1; AJvYcCV4cFOKVjGe+8WotGeoblpRmrB76CQ+xJIxpJgLXyxVlQqXVtr6xlTojajLqIQkgtwSStSrZ7PL@lists.linux.dev
X-Gm-Message-State: AOJu0YyloOi/4BWlTTT7dfG/6zYxKEiw+NfOP9TgGbuq9PTgZWyUGauY
	gTZlpGLMzOoh9IixiKzWBm0FRLzcoiCZGjnvTolDBAbJqVnCjXXHVbIId8sYIk2L0mtl2tD+37/
	cFHQPgrZWirMmGyPdky25MmU8sTs7vqL+0cHmuA==
X-Google-Smtp-Source: AGHT+IEAxK901tOLYft3Q6FSmittxptvWwx8UI67LGet/0+2dqQn/zWS1SdC2S2Ep467Qgo3yOephfFiNjAr5nswFs4=
X-Received: by 2002:a05:6122:65a2:b0:50d:2769:d741 with SMTP id
 71dfb90a1353d-50dda3a0fe4mr9320092e0c.11.1729540646150; Mon, 21 Oct 2024
 12:57:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241021102256.706334758@linuxfoundation.org>
In-Reply-To: <20241021102256.706334758@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 22 Oct 2024 01:27:15 +0530
Message-ID: <CA+G9fYsZboqX-V7-uyuSHH9FpOQXX4ZKH=0hXq0nea61tPNN2Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/124] 6.6.58-rc1 review
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

On Mon, 21 Oct 2024 at 16:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.58 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Oct 2024 10:22:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.58-rc1.gz
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
* kernel: 6.6.58-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 6cb44f821fff24ed5cca1de30a2acc48ec426f1e
* git describe: v6.6.57-125-g6cb44f821fff
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.5=
7-125-g6cb44f821fff

## Test Regressions (compared to v6.6.56-212-ga3810192966c)

## Metric Regressions (compared to v6.6.56-212-ga3810192966c)

## Test Fixes (compared to v6.6.56-212-ga3810192966c)

## Metric Fixes (compared to v6.6.56-212-ga3810192966c)

## Test result summary
total: 111049, pass: 90448, fail: 1389, skip: 19120, xfail: 92

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 19 total, 19 passed, 0 failed
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
