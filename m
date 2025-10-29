Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CF6730F818
	for <patches@lists.linux.dev>; Wed, 29 Oct 2025 07:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761722274; cv=none; b=L9SkbrfJcHiu5PiCkfZBZkCda0hjEQhczMemGiEZpk9wkVAmXCIcSoRzCs4+pXSEYARtWijXkLe3QTdaApmsx7oheFiqm2lMjW+/40bh/v8onWky/4YVZ5ha7EnRMvrb2p71KdTmrkQXj/taES5sdwbhNGHpP7uklVbnplDV5IE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761722274; c=relaxed/simple;
	bh=ykaaT6YbiADc9d9+kOXprtiOstIf3n6+rKFwjMr8+qw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mDwxhFCC5sxD1205uZANmt7dNsZnP5TmLYWKJNnNYBMfZ/t0MGak0txhuoeRliWanBCmCWdO8mYXiJUNCk1M8Ky9epSzOwLcK1E++Tlaz7mZLluojE3n6UKMvkifQCXX8B8U+BNo4jvXOuZG+vfPKlpWIOZyHxPBJ4bA9VVSDiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=airUCa+9; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="airUCa+9"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b6cea7c527bso6768110a12.3
        for <patches@lists.linux.dev>; Wed, 29 Oct 2025 00:17:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761722271; x=1762327071; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EuUZCRhhNRXWt6XeO4ZvYFEtD1drRmJ0SlQlWn1fteY=;
        b=airUCa+989c26Jluq+LOT1ozffYAKnytrWgVxoIjSqLLWsRKx+is5efRnnU1BASygX
         pKNAIqkelSJr7Nliqe+F66uuzMCx59Fb5UwOVNK+AEHmxu0pXJDJ2urvlxHcmRu5/Pj8
         KMDDYYn3tXMgN+FvTkCOUHOUoPv9mR0yYlRb1qsMb189qgMajiibarb3dVutLTGoE6x3
         W+MCLN5CS7RPiDKYwvgJQV42pdNSQCdF+yWqnEUZ/72BKLuJ5tBgYDStjMhmAUHRf5eV
         YhwPq6wy9mVk9c/rQqggKzS+HrVetoM0kXeowUJ0YhJ2ggH3E2HvYR5JHY5yjDdTGvp3
         L65g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761722271; x=1762327071;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EuUZCRhhNRXWt6XeO4ZvYFEtD1drRmJ0SlQlWn1fteY=;
        b=hrTDARwEYV0BoCHytBozwJYb1SWvLENp+6Bujt71NXOW6eHjOStaiua1T05+IoeEoH
         sfHGjBc7AC0/VjMWcPow1zrlNO+DyTxm2UhRfPeWPxlF3jBj1QCFdXbp084XOUR7gQv2
         ab6Hoqdr6VXcigf3pKHoY8UmqL5EWIYP6n3tKtuMo59XpCtmy4lj//XgFUXJTCTWZ8F5
         LoxKaLN76fs8OA8DZC4qMWa5Iff+uADhihSpAPPgCcPrPA13R4Lhr/7aaOQka+z8fdqe
         zG5fTbvEt4vbGcspPpGH+ZFHrVvM2fYTbRxdDcrcXHAZrxln37g8Z4Zzx03j/slCisMi
         t7KQ==
X-Forwarded-Encrypted: i=1; AJvYcCUkVZEezZSkvNINaKytsazDecFwgNoXCRzu6pZBGPS9jgzjJOGaMn9Z3U1ULbicah8iGTKB1E+z@lists.linux.dev
X-Gm-Message-State: AOJu0Yzzw2m9R3XDxDmuE2hbuQYz6w0CiG/7nzPURkci9oVHO+JMLL+y
	AtETgUvHI8/10GRqMiJrj14OOPUwyUn9voh0bNAU7fMiBU/Tvyt8AytF7J3fF1mmnHghXaihddi
	6sYF5CZjW+OJEH6jB4iJNDPzt4juTZGrrzeLD9pw0OA==
X-Gm-Gg: ASbGncviusjHWwSTHsVPBnubnpBpL1Z9tdx47S26HfZRISVZARVsqt4NY2evcWcXVhz
	WH9A2vLImkSm57p/lBwTk8Ee/WEMZKu2iTeFLSe+lMO2y7faMPZlT9TlaUF9PwRkMsX66FwIUml
	lwSleDqfIVUTFycSvQHjGHMTynjFmU9oMWxw+COI5ykPHzh4dEshAzV+ZxXHLstckVTs6Z9evCB
	UoPv3cgd6/7RnnJAJ/ZWRFjTbyYGfD5jeFvP5OXjkNkSpX0Uy1N1fzyZZqSYAcYRTmlhhFLkheh
	5PMa0bq85Ou6jvxwDr1d7ljjXfYE1+WPYnrPBkxbQAcfojvrMQ==
X-Google-Smtp-Source: AGHT+IEvVzT4l6WFVgzJ3FSYoGb6uLgtVt2W5+fZOIl+K9OXMvI8F6nvkIt0kMi83P4QMS0RYXvro6p5vHwDzAUVI2I=
X-Received: by 2002:a17:903:18d:b0:293:623:3262 with SMTP id
 d9443c01a7336-294deec517fmr29410295ad.36.1761722271261; Wed, 29 Oct 2025
 00:17:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251028092823.507383588@linuxfoundation.org>
In-Reply-To: <20251028092823.507383588@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 29 Oct 2025 12:47:38 +0530
X-Gm-Features: AWmQ_bkhsv_CfXE6-NmxcSUE1G28maRQK_zSuM7gYEAFQhEmOG1vtJliOgdNvmk
Message-ID: <CA+G9fYvNF1b+5u_ppt+9K4wDD_hNLNfDn9x5V+KnuR1BXDzG_A@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/117] 5.15.196-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Oct 2025 at 14:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.196 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 30 Oct 2025 09:28:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.196-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.196-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 59a59821e6b5c0c51b329271616457c39cccc07e
* git describe: v5.15.195-118-g59a59821e6b5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.195-118-g59a59821e6b5

## Test Regressions (compared to v5.15.194-277-g06cf22cc87e0)

## Metric Regressions (compared to v5.15.194-277-g06cf22cc87e0)

## Test Fixes (compared to v5.15.194-277-g06cf22cc87e0)

## Metric Fixes (compared to v5.15.194-277-g06cf22cc87e0)

## Test result summary
total: 62494, pass: 51282, fail: 2472, skip: 8394, xfail: 346

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 101 total, 101 passed, 0 failed
* arm64: 28 total, 27 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 22 total, 22 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 24 total, 24 passed, 0 failed

## Test suites summary
* boot
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-futex
* kselftest-intel_pstate
* kselftest-kcmp
* kselftest-livepatch
* kselftest-membarrier
* kselftest-mincore
* kselftest-mm
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
