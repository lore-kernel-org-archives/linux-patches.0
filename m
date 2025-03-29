Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2066B70807
	for <patches@lists.linux.dev>; Sat, 29 Mar 2025 08:14:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743236048; cv=none; b=j7yewkt0jZNu0WwCtLda7bELcwPDtm4xNdF98Ch6mSiSIas0cjrmGRDLAkWWPfmRcuQ7ffeT6ASetLDD7Qf4hvL51OBW3gNqZx3oiFIvu2VSceBCAKJDdY9B5CwkBM36SIuzDpv91c2vM7Hcb/1izCPSmFrG/3IDBZC4HSC1lG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743236048; c=relaxed/simple;
	bh=8GiND8jOfRRGd/cKIqYAgbzQPkMK0kvc1rafMvZ3PM4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H7pjE3ahFfxhtzj5pMC3Aml9olsb4atiST1hXcdMUQ0YiXroBnb7HAPjuiixDTCQVIPqws6rIszJVr5VBGOsydGXeNs9RPXYBYStwVYbwUTK5n9FBQFg/PIEiJ3g9ZCEht1vRPpqs/PTbYrCQXIF7ICPLukmu4Vu5GB5qTz8pxM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fgMWGFlG; arc=none smtp.client-ip=209.85.222.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fgMWGFlG"
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-86718c2c3b9so1244457241.2
        for <patches@lists.linux.dev>; Sat, 29 Mar 2025 01:14:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743236046; x=1743840846; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OV53tHVbf628erFwveMgJYR6DPNsKo+lGKHmW34PwcA=;
        b=fgMWGFlGXtOsuo1uhG5luMQCYhauwcUfZ9MezbwRuMsgTTVvwTDYo+iYOuJFUzQ1yq
         J+uILhiLFnkbWMVCzfNq200DxQdZFq0NX2fKjT3ceiGMFZn05lm/k9okA7hKDy1+uMAD
         qb7ro6ZIrbL1Lt7JLJeEqtym1TyYTLecBlUnp5Ir/rtLU7Kn29zWqBDfTO/uIjZSjQoR
         MU6xcUAzhViefkpMPL3LvM1949PF6C610ZqDjr/wzvM39hbaCkMEiGuRm1iGGKRS6Rmy
         +7JlOSu0SD/DU9mw+E2oDj3OzAwWzRBLEeRJ/BQLK3eqw+HdR8ZziolcSO9Ogj1FJc2a
         gDVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743236046; x=1743840846;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OV53tHVbf628erFwveMgJYR6DPNsKo+lGKHmW34PwcA=;
        b=L7s/0YPukBTULms/ieCry+WCWfLvCAW9rUB27eQ/yceq7p9iJHhuktH+2dQjB5TqU9
         3mWYlxwBhQRV1obS+rLUduNrpTg9R6IUKz+gQl8bw6szD5Z4Lk2KL7ZYPRV5IzY//sBW
         /Npmg8ati2hCZ45/Rhf5bB/zdnPqd4k/baUIb5EbG7/zlP9mE4DEkUr6NFcTg7xgmoQZ
         lZfcCozMpgYx4hcfQTfEorh9go9lxxvGH3+w2zAyDmdpSLbMH5+HbNrEfzbTuiNKns7n
         8/funVYSjaM3l8C+ik68U8g1wVIjl5Z6p1L9bnrNEEC5Y753/m//m6FUjrLEJfBnf00h
         PDEA==
X-Forwarded-Encrypted: i=1; AJvYcCXi1UZpjmYkJnQarU7Cr0DR+tklFr753RaXpxeAijO3W+2XdXjoLHaRB5dDUy+/FYFhv9S23gS5@lists.linux.dev
X-Gm-Message-State: AOJu0YzDrcyd8w6jChbb84aq0sy+D+XhnhvIY1FULoOQ2wZFBGQNH4Oe
	TbDHNia/pwchuwbEeH0G4W3y/jptT5k11Mds0FBqwKY7PbJX8lvZG3ITemi3PnUF1fvuiGCwKLR
	ql58QEkp4kVJkwaxsJyhEJ+ywqbKvZtSErwAtLQ==
X-Gm-Gg: ASbGncs/rfMjXlwywN+dBq9KD0SdT+8RBOn4vXIH6CUz5ZtaxPYEeY8bglyTlYh0sVd
	HX+tKEwk6xwFLXOAhoqdaIcDAy2bfQ/Jc/z1Yj1/i0W3pb3x6eyFByvliq7LWsIS/N4QLkXnOPZ
	2jXN7KJOEG2dg3l5MrrFb4vsEUJtqZ6TW7SuVlFU6R0RsCEIhbk2WZldINKsI=
X-Google-Smtp-Source: AGHT+IHEtKCRNGj8GhmMQq+ZmsGVrBipDX2oWXka5tkbki1LML5Ps2Wrr39RT3XHXSBqLlr2M3yMmr17er9cOu8+i8I=
X-Received: by 2002:a05:6102:2ad3:b0:4c1:a448:ac7d with SMTP id
 ada2fe7eead31-4c6d3881b78mr1432023137.10.1743236045813; Sat, 29 Mar 2025
 01:14:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250328145011.672606157@linuxfoundation.org>
In-Reply-To: <20250328145011.672606157@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 29 Mar 2025 13:43:54 +0530
X-Gm-Features: AQ5f1JrhUEGT2ZlSUHwliccXNJOe-vPWvTNmSHrnFCqn8yijxsLxRCCNICwZY7Y
Message-ID: <CA+G9fYuSxke1pLM2yPkijXuXQbyY-B3nQKa8rxdWxSL7nZ3YfA@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/75] 6.6.85-rc3 review
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

On Fri, 28 Mar 2025 at 20:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.85 release.
> There are 75 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 30 Mar 2025 14:49:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.85-rc3.gz
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
* kernel: 6.6.85-rc3
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 1a8546896fa3161eaf3b65771fdfc55241cc9efe
* git describe: v6.6.83-243-g1a8546896fa3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.8=
3-243-g1a8546896fa3

## Test Regressions (compared to v6.6.83-167-gbddc6e932207)

## Metric Regressions (compared to v6.6.83-167-gbddc6e932207)

## Test Fixes (compared to v6.6.83-167-gbddc6e932207)

## Metric Fixes (compared to v6.6.83-167-gbddc6e932207)

## Test result summary
total: 114024, pass: 92211, fail: 2845, skip: 18530, xfail: 438

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 46 total, 36 passed, 3 failed, 7 skipped
* i386: 31 total, 26 passed, 5 failed
* mips: 30 total, 25 passed, 5 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 36 total, 33 passed, 3 failed
* riscv: 23 total, 22 passed, 1 failed
* s390: 18 total, 14 passed, 4 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 9 total, 8 passed, 1 failed
* x86_64: 38 total, 37 passed, 1 failed

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
