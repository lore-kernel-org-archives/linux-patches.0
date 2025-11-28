Received: from mail-pg1-f175.google.com (mail-pg1-f175.google.com [209.85.215.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF27C2D6E60
	for <patches@lists.linux.dev>; Fri, 28 Nov 2025 07:26:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764314802; cv=none; b=rd814cuOYeFSaGWJYfHW5YiUEU2S+O6aMmbYk3uzUzynT2pD4oap2MNNeLtMkVd4z73YtfPuYgqHUIfyrNTaB84MKM1P+/IIJnCqKf7fjV9AJuFbtfkklU47OiqlF6zLaaYLKNAz3h1lthEh/lz6O8YZ+ZAyY63gA4NyX3Ggc6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764314802; c=relaxed/simple;
	bh=Onl2TpckQ9ttyuBj5wfEDD4O9I9DGA0NOljfyU3CtDQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=t4mpdLRY5a3V8wLt3lO6H5iFhF9BEQTZBPyzwQuzD2B7mIYsU8s8TrNGGSpzoMdcV3azK4ILF7C8mgTgIldNjtdmx8vZHgTxBmQB6FMUgDusgsoc/4ckyf/qQ1wSom3eeuicdUN/IpR+kiJ+eph0j+tyGDJ9ta1uJggd0rv8qps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kIXQgvtC; arc=none smtp.client-ip=209.85.215.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kIXQgvtC"
Received: by mail-pg1-f175.google.com with SMTP id 41be03b00d2f7-bc17d39ccd2so840781a12.3
        for <patches@lists.linux.dev>; Thu, 27 Nov 2025 23:26:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764314799; x=1764919599; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=157z9r7viSF7Wrf9hRXSEg3ckRXmsCSwlbd23w9qPsw=;
        b=kIXQgvtC9uIXttUTZ6ZnOpczX1tMoxDRaJctrzG8IvUB4UOPV5gRsLfLlHDcus5gpo
         vqBaJ4G8ikXtl3m1XWriz2lagqA5SxRHGMyDFAd9ndFR054sBR1D1vcmBctlafuVd5I6
         NIBvLGzuavfM9g87e99NKoa/XN9vjDo0gicFWwVMTYvsPbrk8+Kefnuy6OFmGo/GBqUs
         r0ha/iYEddnQaypwALISFL4bmOQm1dSzWvy4fFeXtbfd255D//OG1UFNx+Qjhn7BY4YF
         JS3WvATpgCLR2hucRjNXweRaLswR3A3Bg+3PxwoIaYIZMs1By7SbRPRknfoIZMlpgaUa
         lJXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764314799; x=1764919599;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=157z9r7viSF7Wrf9hRXSEg3ckRXmsCSwlbd23w9qPsw=;
        b=Lp65OTQGch/6n1rMDlq5IhFQ5Cs3rkVXGW+Rh8/R5M1U1gBJjPsn2A0gBfA/2PjiXP
         2u23rW51yvGJFXuhxWEbb5kWJ2eyFMcw3qPoMY/fuoKgZKTs0asSK2MEGmMle4qlHA/X
         DsroO05Tzeqk1uyuzmngNlvLR+946oYO7Xq+j6ImNakr0LyevA4rTCfw+BnORo1MrI5w
         +qL1xIkpWYIy4jyRcHZA0MjK5sVcvLQVft+62wDsplSf0YhbY4PeohyMKKPu08qHlcH3
         u98GYkk0DEtssBvFiPpg0VTZpUg/svQDNRu4iEjd9NTdRq68j1GyI0HtNiP3cjFw3vfy
         9IGw==
X-Forwarded-Encrypted: i=1; AJvYcCWgxs9Q/VUP2rv/6f2d1V2rvh8uBzpEWLScIOutX1JIRfReyqdfEjZfd+E+XfBfupgrbC2p9tpf@lists.linux.dev
X-Gm-Message-State: AOJu0YxDmkqjfnoInBW9ETQAFj6gDSNb+pLVyOOSiEdOqW/3auvRppDL
	0O5IH3cPdBebbK5cKODacbpVFtCbzGbUpLm5Ex1LG4MNiXGlXPrcdMmrbkU+2rGFeALlcQftKpS
	3+tgVS5wAUuMyukevPzEUkM/seYbEI9Aqks9HVvFL6bWh9uqrP4fqPqY=
X-Gm-Gg: ASbGncumYgFq93xdyysuTVClNJLKQJfVNxCqdXG99gTPfPX5vU9niQVvQgLjnRgAFAM
	ZqRFuZmYri/ac2RpZsCbD+kSVnW7rt8lh2+hbJvKYUEyMFm7+T0L1QBRpp+GrciaXvJZ4fVNJd4
	AI8SdLBxPiuNCKR3IMrKCc57ll83zYF2mUcaa8cuHSFSC+c3E+nmevLBL7eSrjK7/7BbmPD0x+9
	DEACCFMVXJbbEeZJ+kHiv2l/95IqBYbK3ELuEGZh933Y8o3TNAQgOuehJWWvBfvsaS/JuwlHBez
	IeuZ4fLI0b8wa0jPX8ZMGQ/ke+2K
X-Google-Smtp-Source: AGHT+IFcY1dlpiXsopK0jfaJYLRaV4SWNTp+pKmhuz3ErQ5moUPBqoFQtpnwhvEKy2niLlNGiEvAotewGPcCwtByltc=
X-Received: by 2002:a05:7300:e827:b0:2a4:41c3:3a45 with SMTP id
 5a478bee46e88-2a9415736femr9201430eec.2.1764314798914; Thu, 27 Nov 2025
 23:26:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251127150348.216197881@linuxfoundation.org>
In-Reply-To: <20251127150348.216197881@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 28 Nov 2025 12:56:27 +0530
X-Gm-Features: AWmQ_bl4SIEOduO2IiuVY2QQXbLBZd6DDREJVut88Ph1ndilRzlaVsup6M2cG24
Message-ID: <CA+G9fYsXLTzLQBMu7LuqXUTfJyB121qX8bD2jYAYEikGSsfiaA@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/176] 6.17.10-rc2 review
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

On Thu, 27 Nov 2025 at 20:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.10 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Nov 2025 15:03:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.10-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.17.10-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 6c8c6a34f51808e7b3dedc4227e8bd060559a0e2
* git describe: v6.17.9-177-g6c8c6a34f518
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.17.y/build/v6.17=
.9-177-g6c8c6a34f518

## Test Regressions (compared to v6.17.6-1131-gddfe918dc24b)

## Metric Regressions (compared to v6.17.6-1131-gddfe918dc24b)

## Test Fixes (compared to v6.17.6-1131-gddfe918dc24b)

## Metric Fixes (compared to v6.17.6-1131-gddfe918dc24b)

## Test result summary
total: 126087, pass: 106603, fail: 4209, skip: 15275, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 139 passed, 0 failed
* arm64: 57 total, 54 passed, 3 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 48 passed, 1 failed

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
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
