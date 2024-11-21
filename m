Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76FED15CD42
	for <patches@lists.linux.dev>; Thu, 21 Nov 2024 07:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732174652; cv=none; b=UFKm9AkMqgVIfb8Byn2FckgQX/3+e0cfq+YPTkkA5Tk38C2XGlaE1LV2RKup1j6bAlXvX665b9O2oDbOJ04kf19HxtYNaKYqJvINvryHp93AgFTsoZd3bJsoBGAqEgKPJpsUJqYgzD8u7VjVMsnVcQwlTJEuo255eO8oW7a2210=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732174652; c=relaxed/simple;
	bh=epdwONRPQzvG4Ng2ew7SNAGEQ2TwjDGwbwUNkeG6kjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ITabANvB/T66k4ZW5yfnF1lZ68pyxSQwRTt+GIaEsCgbkSDM6OxDep/VA5yxcr749d0JX2fPbhAd6EwINjauJwWpE3g6TlRbcXs41IEyZtrweIfzyX5fXpUsTSuSJ7/k6Ola1ZGYNzRqAdXpDMW3iW3pNW720dhUEZXDgBjnQr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=KVulS2HA; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="KVulS2HA"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-856caa64d39so150504241.2
        for <patches@lists.linux.dev>; Wed, 20 Nov 2024 23:37:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1732174649; x=1732779449; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=p1ZLoH1smfbg7/BsnIAPQu/7wAAnykIMDtQj2EWHt+Q=;
        b=KVulS2HAR1ZfnULF3fG1HkF5Y5lfu4SsEwt3M9hfUQsKprLtvjDJ0w7KWTG156NSOS
         0ej7MPPGrWDK+8Z3zIpdQPxrg25gc1miTFOvnEzfwh0qoxu17+Y07mboSBJZne9bRZDl
         qGOqPA+OmYGN3Sfacah/wMIfnKNnWii7X6DVJjWP6YVMoVbDUStnwNYNQFXnyN0Zwh92
         MgtrYwgWJn+C0wnhdOUe5x+BIbc0gHLR+sC8HBWXw/hNZ6f1TQHUE2tOIjxxByE81ynx
         jmMwcuYX1m2Zjho1TSC45cyQNXmh9T8l2qMidbH2lgSbEqnj45cSvumvF7ClAOewZ8iz
         nXFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1732174649; x=1732779449;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p1ZLoH1smfbg7/BsnIAPQu/7wAAnykIMDtQj2EWHt+Q=;
        b=wKdEN9DTj2kof4MjnjCZm5mdIigSxNfBqzLDNHlhfzAmB4kZAXRhuRAEt6qXGKAS+F
         6dhBL13ZUGpPjKEyC09MvlhFUp0sPDKEk5UyeuGwOo9IbxeIiABBUE2N4MM3WyFKR9zh
         zOdVv/xb4yrVY+bf+rsmJTH5e2V4c89TCtf8O4q0sHvurWSc9J6djX807Gx7NoHqqhRq
         MWG+R0rlLeoQvPf73EfWo2iYTP6u1tLgg32xbAL0/6h60F7hcLJJkCxKO56gKe6soTTT
         7Om12TskELyy75NOg9JxeHxd3X6mc/R2Lx+usZmH7TVUaaEKyu77pKbI2dWCGD+HpWNs
         +dUg==
X-Forwarded-Encrypted: i=1; AJvYcCVRRAeKiFH6n6N124lkfsH0Xi0N23EooAJfmjqgzEMJYlQZ7lFyiRLtQdLLwMrAjzSUt8gNVDw6@lists.linux.dev
X-Gm-Message-State: AOJu0YzxM+67ZEN5RgULD0pmj3HBnqIVRejB2w+nUTGxCsAd8uhb7NyO
	jJwc1hr3gNy41Fz8XvTzYypx8zh77rZoX1UIvPV1aX32wo5s9FofqEGkNIYUM472MzZRvqIi75g
	CDWH43RgpyXg99SPepB3pcd2Z/O1MxScfIVawew==
X-Google-Smtp-Source: AGHT+IFd6DL09qqOh0gqlQXz8TrLBH2u7Br0PkOW53eLUM5unHdRAV9q+AYPrDsgcccR079NbH6OS/M8xAa1v+t5gQI=
X-Received: by 2002:a05:6102:91b:b0:4ad:595f:bebb with SMTP id
 ada2fe7eead31-4adaf6203d8mr6231578137.27.1732174649280; Wed, 20 Nov 2024
 23:37:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241120125629.623666563@linuxfoundation.org>
In-Reply-To: <20241120125629.623666563@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 21 Nov 2024 13:07:17 +0530
Message-ID: <CA+G9fYvy3d162b99zNCXug+m=AUGJ7hhoeDNrOFDjHcxqm_XJQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/82] 6.6.63-rc1 review
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

On Wed, 20 Nov 2024 at 18:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.63 release.
> There are 82 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 Nov 2024 12:56:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.63-rc1.gz
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
* kernel: 6.6.63-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 2c6a63e3d044aa21274c98760650830a22b5d54c
* git describe: v6.6.62-83-g2c6a63e3d044
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.6=
2-83-g2c6a63e3d044

## Test Regressions (compared to v6.6.60-169-g68a649492c1f)

## Metric Regressions (compared to v6.6.60-169-g68a649492c1f)

## Test Fixes (compared to v6.6.60-169-g68a649492c1f)

## Metric Fixes (compared to v6.6.60-169-g68a649492c1f)

## Test result summary
total: 120020, pass: 98405, fail: 1453, skip: 20080, xfail: 82

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 128 total, 128 passed, 0 failed
* arm64: 40 total, 40 passed, 0 failed
* i386: 27 total, 25 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 19 total, 19 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 32 total, 32 passed, 0 failed

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
