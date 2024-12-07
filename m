Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294B11509A0
	for <patches@lists.linux.dev>; Sat,  7 Dec 2024 19:50:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733601033; cv=none; b=t6Jtxh2Zr6msyZMXltkXt+xR6hUi+aEO0Rl8WRiaDtF/nOFNBfYm8rXDBB3Uf0jQVFuql7YgArRb7Gkcciz14CjsaN+SqCQ+MUUMBRzsZEg+Eg7ftJNQFt6wxfavEqdgy3sm+vYetirIT1qRHUQ42iTw1neewblOa20Ol98xZoo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733601033; c=relaxed/simple;
	bh=LasN9bNIN9EL+ojIMojzUljyOQcpwv3EZmeltoqkT3E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iIbdqlQeP+wZDZoBuVZ+5QuzO0Atz4kSsqJWmIU5qFl6A/NmbOrAcsKHLU4V/D/pIOZEPBv7VDbB20AG+jhIAXydnKLm351wVNo4mx6eaacnSdmTVpmdKzw0JoA/wCLfoyCdQ/+M3f3yAEq4W0YrgnD/Qw1Yt1lzr5olwxRXYcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Sonl40/E; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Sonl40/E"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-4af3bfbb721so976812137.3
        for <patches@lists.linux.dev>; Sat, 07 Dec 2024 11:50:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733601031; x=1734205831; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6pMemEtN4tM9lGXkUkEycvngJOia/lhXbbiYY9m4/38=;
        b=Sonl40/EgB7dwQm9dBxmA4heuDKNeA1x6Bes4OPHYEAIXJL9fBSXFMzMULnC0SZ80r
         sjA1lXBvE3eGlUyUMJHA2MiVe+DglFvqMM34sNirH7lzelB6jj+lX3xgtM25V7oqw+5t
         Nf4MdM7GIgNnjtUbE98g6sl4DKdJ74AMRBQBDLZpjvHQuPZ69cucNB1781QXOFU5qHf0
         ZPhpBIfwIqw/s0l95mwymer84AJOleU49+niifbIz+zNlX3meNEMetA3oLdLat+hNosM
         tt3F3Hm6tLYhcXblsOglZl1WS2ZWODt5YaNgkHW87Lo1u7BzNml7DEShEgFVmG3dMazr
         cJVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733601031; x=1734205831;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6pMemEtN4tM9lGXkUkEycvngJOia/lhXbbiYY9m4/38=;
        b=VhOCkuc2jKXvDPyq3jT0JW7Pe50NKVNtPYpdSuwc7+if1EXJJ97n1m/w3p8mXCaoiZ
         pIpOJPyP5O9hUziSP2/R00LsNlfHRYb2VSahgUaaEO+/JctQwI9Hyn8h/EJ6/oaf+9Vl
         ta+rLHO8zI5mO5pwPFxZC2okps4MDjttCz8CcXgjpgdqwg4KHeru/iAY7UC0bN8uHV+i
         6I6+WFhlM2ozuOFTMuwMI3xxCRvPjzwD8SBgg7bwld2nXbUhGIqfh6uWV7VSnEVyM1Ds
         b4hj1lOGzPUug1Y35hHFGanRunL2yVoX1fQy9OsE7vehTuhUXVcXEIX2MpJV9GT8zJ4I
         /xrA==
X-Forwarded-Encrypted: i=1; AJvYcCVJvOWo+1QOEDTJSVGn+LBE2oNlKDG/kdazEI4HUter4uWM9yyFhmqnKC86tzeOdI0tg2AEyxIq@lists.linux.dev
X-Gm-Message-State: AOJu0YzenzGXUAoCYIfClMtBAK64s1li5GoyDZ7jlVZRdlMHD68iyfYd
	xEOQlCu6UbIrNB9MQ6xkyC13d6EIUgUlgB7WPY+SDLA8yU9dlVNfEZcm2WSp9casApHxvnTQ7bS
	upezbh61EKGTgxN1jplfPdvi4YRpN6CHwk+Nwxg==
X-Gm-Gg: ASbGncsHIAHIE5lpz8tH2DCeubae5tTrMOHXHCOQ4VNZMG3P1no+1Q2m0cABNJG6PLP
	CQKdBHOaxDufRe+x6Z4bn/jG7iYwOEaG+yPN+x8rDVEsMQz00eU3aExdRxf2qr7Ng
X-Google-Smtp-Source: AGHT+IE2gENhy12bTe+/tsKANEZuiXJ3HVZ8w1wx43rB+V8qnuRXNZgT7/Z0ACMbIPN2eLAYuSn5mRKpOP10D8Fn0qc=
X-Received: by 2002:a05:6102:5094:b0:4af:bf62:ff4a with SMTP id
 ada2fe7eead31-4afcaaa4539mr7391371137.16.1733601030992; Sat, 07 Dec 2024
 11:50:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241206143653.344873888@linuxfoundation.org>
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sun, 8 Dec 2024 01:20:19 +0530
Message-ID: <CA+G9fYtsYhXwhewSJUnGAwFmSa5AnOvuREZiOGRCsOUWb6Kx3Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/676] 6.6.64-rc1 review
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

On Fri, 6 Dec 2024 at 20:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.64 release.
> There are 676 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 08 Dec 2024 14:34:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.64-rc1.gz
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

NOTE:
[Not a kernel regressions]
Powerpc clang nightly defconfig builds are failing on stable-rc linux-6.6.y
clang: error: invalid value 'r13' in 'mstack-protector-guard-reg=3D',
expected one of: r2
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2pqeSKGTShWpi3PB2=
dFTogUwhpJ/

## Build
* kernel: 6.6.64-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 1415e716e528f373c2804c2209aa7af6706f1e71
* git describe: v6.6.63-677-g1415e716e528
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.6=
3-677-g1415e716e528

## Test Regressions (compared to v6.6.62-83-g2c6a63e3d044)
* powerpc, build
  - clang-nightly-cell_defconfig
  - clang-nightly-defconfig
  - clang-nightly-ppc64e_defconfig

## Metric Regressions (compared to v6.6.62-83-g2c6a63e3d044)

## Test Fixes (compared to v6.6.62-83-g2c6a63e3d044)

## Metric Fixes (compared to v6.6.62-83-g2c6a63e3d044)

## Test result summary
total: 157880, pass: 131063, fail: 2706, skip: 24032, xfail: 79

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 128 total, 128 passed, 0 failed
* arm64: 40 total, 40 passed, 0 failed
* i386: 27 total, 25 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 28 passed, 4 failed
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
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs[
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-hugetlb
* ltp-ip[
* ltp-ipc
* ltp-ma[
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
