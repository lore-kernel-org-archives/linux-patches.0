Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F77C1802C2
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 13:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721221247; cv=none; b=HqCorQjnSOWWeGpJjiOxspZoUbfpAnkTYEit1xPXci+StjVrETL13jOk9nAUa7rQN+GL2OOCMlGnOkjIkO30/jCE7cQx6lbEBB06D6OuJn3d2sPA+aGtQeIeiv0MUlrE2QSR2tm50S9x0rn1WuUl4XX9lERdwxqkKZn3JVgmiE0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721221247; c=relaxed/simple;
	bh=6vb13Iy5euZOR4dQ+SlApvRI6h/aNBGj1KptxzqtqHM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=admJx6mwpHnqD2epRGhnOhCDTOTwBYklLaYazZ3OxvCVvCYA0q066m/qR4XzwdgliGG/vOCl0EJxfG0jv4mGjj3Y7VfAIjBbrcORTWmvDUWgvOenn6y0Z/1yJKxQV8v30uXGGXMOY1ML8rQcuxtoW+gC8rNgawcLGa3Kqq5nGqc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=q+bYIbZh; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="q+bYIbZh"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-810177d1760so436024241.2
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 06:00:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721221243; x=1721826043; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ElVioLoyTQhlcAXqwKpNT5fstW6n6vTuxhpKut5u5V0=;
        b=q+bYIbZh/fQVk9cB2EIYhRshWV875W0inaFh4FpyyINT8sJPvW/xL5uuCP19AEU7op
         n1T/oLBSG0XMCEaqlAQusbtilt21D9FIOzwkV1wsd1MXyJZ5ISvntgkByTHilwg5gk3m
         8AhpmDMdEz78y/3ZcNlqV/lHZ3o/zA9VW1911/s6t5a/j+r7aQi4B2voUSycv6FTryAf
         gqdUoOMW56sxIxPMokqklu76ntvAwBAGzOWRvhrQI5yThU1jvyntgZjYSIvnTuuW99xs
         JwbO5sqynNXpLOuwqBpyout0zR0xd8eRumQYpT6X/FBcoMxccBvxO9CHcF6UPMEdGo0j
         PTiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721221243; x=1721826043;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ElVioLoyTQhlcAXqwKpNT5fstW6n6vTuxhpKut5u5V0=;
        b=D+7+7tDsI386IaXl0RQ+7OWPC/QDqOklfxadzTWrk5R3rDRG9UT3DxBMKy5nx1fPvo
         xlRfIZNB7n1Cg4PAsYF2yz4h5xZ5kVvZSGuga2My2ig9rAsZueTg/k6sq9pmLCvpRj3l
         ZRJj2p8NxhJyesXj9UApM+JTtKJ9EwdE3h4jyPArkrqQdfCrPM0OhcYWfhl02/Z3yksZ
         tE0XY3RCPQWcPepabO1H1bC2+7TP2k1vpVvia+GtfW74AYxq7It6pWw1e0WSQvQCnNjn
         2g02V7mcJNv+YPzCwE2eecNeuWu1aiyj/OPvMYGnmidfjMcrLNddy2YoTPPMO8h4c7nh
         Q5Rg==
X-Forwarded-Encrypted: i=1; AJvYcCU+3ysEg2+w18JKw15jzTHYs6VCWTRN0hev2FfDtbPuG7FSc6tCEj0/JowNsQhANS5daf3gfI1Loqdo18vbymeTrjuwo760LA==
X-Gm-Message-State: AOJu0YxKiy0A2YKapccQbNys1X+GxfAjPUQ+/ffQDOIImcil+wV7lDtc
	+vmnMHbMtjNH9u01eULEr2C1GMU+T81OWORnCJ5/OAlEbdd6XO6ZDjpzL5WziHPdjNXf7YX+e10
	FEwkmoelrMIJTXiuFcSY3PKe8izOjTEQ58Q0f6A==
X-Google-Smtp-Source: AGHT+IH5XgJmvEXq/L7FHOyyXK3RkpSHdXHll5ESvSvmSgTLTU4h1DT36ljkuWFPLkfK9rf8NDemDXuqK12zJjQqcyI=
X-Received: by 2002:a05:6102:3f86:b0:48f:ebb7:3919 with SMTP id
 ada2fe7eead31-4915975b217mr1698584137.7.1721221242950; Wed, 17 Jul 2024
 06:00:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240717063806.741977243@linuxfoundation.org>
In-Reply-To: <20240717063806.741977243@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 17 Jul 2024 18:30:31 +0530
Message-ID: <CA+G9fYuRu35fggLrOaXZg=ic-pFjq7DRL1moSwmwHW1qejPfuQ@mail.gmail.com>
Subject: Re: [PATCH 6.9 000/142] 6.9.10-rc2 review
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

On Wed, 17 Jul 2024 at 12:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.9.10 release.
> There are 142 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.9.10-rc2.gz
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
* kernel: 6.9.10-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 61dff568763322453e014b07c0508620052362da
* git describe: v6.9.8-338-g61dff5687633
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.9.y/build/v6.9.8=
-338-g61dff5687633

## Test Regressions (compared to v6.9.8-198-g2471237b27c6)

## Metric Regressions (compared to v6.9.8-198-g2471237b27c6)

## Test Fixes (compared to v6.9.8-198-g2471237b27c6)

## Metric Fixes (compared to v6.9.8-198-g2471237b27c6)

## Test result summary
total: 178195, pass: 154558, fail: 2462, skip: 21175, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 127 total, 127 passed, 0 failed
* arm64: 36 total, 36 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 33 total, 33 passed, 0 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

## Test suites summary
* boot
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
