Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B41E71D63E4
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 12:14:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748952879; cv=none; b=Ui1FA/K5P7fYSz0GLaEliYIrz/2jL8UcoPdmeFjJLmk/6JBdtIT7LlV4PkGkRMcly/y3XvVKQ+3EiFGhUZpYynWurRlHKS9gvycRFZzrPHCearjCilqNveQMm0V0TKOebYHx7c1vJ6HSKccnImQqrYUWd65mvsi0Sm6ZJjK/rhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748952879; c=relaxed/simple;
	bh=t6VACjOwekeSdoTcNJF/T+YgRqCVuvNSNERLhcOem5Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d2O4dC9mc9pfMPLg3MaH4MH7L6GA/UBHQYJRNzJgKloyv587MSKt8OqPHm3s9/kzL06aCe6833Dos58ZSicfvEU1S5K2CoILjtaZ+0FsrA0VPm+vsqMji6OGXjz18rGGqU6lOFQaPxvvNkKekvBot5i2DzdmvPssjrXpa7GUHNg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TKepFSI5; arc=none smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TKepFSI5"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-4e5aa697e7eso3307851137.1
        for <patches@lists.linux.dev>; Tue, 03 Jun 2025 05:14:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748952876; x=1749557676; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ekMu844lc62J2cT/hTWiYp5z39/Arp1wDxCaIiaTRQ8=;
        b=TKepFSI57kxXyeb5fYqFW+YfvgImcvm//QUshEvMeSJ2LJttdeFwfROkxU6YOjf6op
         8ADavN87RO3Td9Le+vbshXsroU5kciDZUHWfSlSasB6uvg8x4LTeuZPNDYlrZ6nftND5
         ADZHDPHr6VtR4F/rWXTZFNLz5aQusDySKYsOuAqU0qurIRZNfEvcZ/ccRQpmZWz6UBEt
         GsJ6tJWyV+RelXM4dmNd89nFxJ0FC6QN1qm6pLTfG4/+R7xmz4E8UfjbHlgd8OYGu623
         gn+M0czZNSV60PIIRvJk8Ha005KIDM9q14Tuf4YmETkkBj2aE1YoZNXVr6LlX5qjcwr4
         KIQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748952876; x=1749557676;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ekMu844lc62J2cT/hTWiYp5z39/Arp1wDxCaIiaTRQ8=;
        b=OAm/cxYeNN6CXmVAMOhzcNhhDEdTTNFCDR+/oJgJJcCdJ1Ojt5H8Y9ypokRR28/0OS
         H3EH6xptCrZW7h6bQF01OzuKiedlh2qGZBHqUqwpdJOMsBcd7d2d9uCuzcyfda2y+Ar8
         +U3h6B0WvRV3o3XjVIDhoPKz/N6Q0qzTB8a6DgE44SvIEU27avXl3nMDDWGWQkHaQeXe
         EQsQjK+ZHgpnOnjUmvZmeHJxARxA/b7Q3s4s42sBAadp1aQCXCVqGheCBqCX7EK1alu+
         idJjj3OEv0BjdfkAPXiKcYQj+7LiQNYvx+b3y1Z8IdoWIHGL+PKNOK4AfYSDua7ZsvLb
         CFMg==
X-Forwarded-Encrypted: i=1; AJvYcCWIpT3C9FSj5zqnW4GPGud6UGyPLs3GQvGAOFH/YvPy92tnQGf87CIfXWVGHH1eTBuPYmKC/2mf@lists.linux.dev
X-Gm-Message-State: AOJu0YyefJEYId7vWVUyaIVnpXWCj88iPUDcdw+Rf1BJa432hP1Zy/8A
	q4n4RODSFW2PiNtBr61iHZahS5x2DG3urNHGzeeGi+yrEfouY1MkAFyPwXE5DlK+avWHstdCWQr
	7sQxSZR1UmvQs+M3q6H/Dz3YnJOsYIiD1J44EtePnjQ==
X-Gm-Gg: ASbGncsXaXUs0s8lOo4FQf+ThChxrD2U1O65kw4i0xgEliM/KlOR3bBSlA0SEC4MYol
	tA9NkCOKP38fPt1SgUiX++DIiJlzjYrgli/VWzLs99ZorSLbkRLbmoVrmQfryZMclCc25ZbVBg8
	oOhuhyLi4EgB9s5d1mRhT2rwx3I8sBgsBrlVc3iQNa4w==
X-Google-Smtp-Source: AGHT+IHiguH/q/uOG6AU4kDV0YQqPceDg6Ud9t4FMNb+4rqbBbm2F1nz7LfKFd2Q4SlCoMcQHCIYagI1s9WlCBukVG0=
X-Received: by 2002:a67:eb0f:0:b0:4e1:441d:be9f with SMTP id
 ada2fe7eead31-4e736014deamr1157543137.2.1748952876505; Tue, 03 Jun 2025
 05:14:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250602134237.940995114@linuxfoundation.org>
In-Reply-To: <20250602134237.940995114@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 3 Jun 2025 17:44:25 +0530
X-Gm-Features: AX0GCFtcVR-C4Oy5JyTm99FTojQYH7IOaO2ypXBtQVxYm4_OVJOIEFtSBGiuXhg
Message-ID: <CA+G9fYtv6GPx0guY03DXBwoCcM-VdWHwUy5mScP=cP2g7zzo0g@mail.gmail.com>
Subject: Re: [PATCH 6.15 00/49] 6.15.1-rc1 review
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

On Mon, 2 Jun 2025 at 19:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.1 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.1-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.15.1-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 86677b94d603c727f6b88b4b77bfce2601aa4465
* git describe: v6.15-50-g86677b94d603
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.15.y/build/v6.15=
-50-g86677b94d603

## Test Regressions (compared to v6.15)

## Metric Regressions (compared to v6.15)

## Test Fixes (compared to v6.15)

## Metric Fixes (compared to v6.15)

## Test result summary
total: 321892, pass: 296354, fail: 6075, skip: 19463, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 136 passed, 3 failed
* arm64: 57 total, 55 passed, 1 failed, 1 skipped
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 27 passed, 7 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 46 passed, 3 failed

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
* kselftest-mm
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
* kselftest-x86
* kunit
* kvm-unit-tests
* lava
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
* modules
* perf
* rcutor[
* rcutorture
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
