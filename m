Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E09723A9
	for <patches@lists.linux.dev>; Sun,  8 Jun 2025 06:45:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1749365102; cv=none; b=AE4mUwWRfm9RnAopL3weQxruRcKEsR1OLlFtDR6cIFhDucUUwr5S6W0gKw5F23u3Bs4/ussfEUlfIihTxfVzgjFVlOtMlXzN+op/C8O33q0YXfhV7rkKpquQ4SlH7A5K9slHUlT8Swcqe2gHTEgTmTVI0qzFCRg0lNIS3mIeaiM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1749365102; c=relaxed/simple;
	bh=C+RNxggqN2QjbPJ9FTlgd8P1BsnmUQvdpu2uGyhkwQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p79HXtmd51TqFBJO/aVUampujxuBA4RLXPgyk+dHbY3CzVFAQgxz6wfUFmRlMHXF2Zmzy8TzRkbYmwJL9i9gIUEJUFYp6b9TyD/GJ+jpQT4JpM7icft9ynRZ2dz4idZZmIL4uCVqdiJsNIaYtUxDyuWHuLwZvb36P3SRWVd/ESI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=koHQQ/Po; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="koHQQ/Po"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-4e592443229so1106241137.1
        for <patches@lists.linux.dev>; Sat, 07 Jun 2025 23:45:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1749365099; x=1749969899; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5+TMvdbUNerpyH8sJEZRNYZgyFmQavgKhbR7MC4e4Bc=;
        b=koHQQ/Pozfb6qxVOyuOcxzlgacNUF8aD7jWUKN1Ci5T3Xq1Ds/zdFe2hpBa3GDcnCI
         8sAqsrkb6Fc6P1HBHWiMPUkIPCJQpdzAKxLcxtPzxCUKsid8PakZ6o0Kh/950elFHrAR
         JnqnBo/ck2H8eWA+UGx+PshNJi2OFw09ocHvqApxBoEQ1b6EIkuWQb3EC910CwhkdW8z
         WXo9QrIqFt2iHNI5cD0xIxKFIm0PnRmz4XH/s+2H6/9vfoBaWICQQXZ0VAOnSyAPh8lO
         3VdbWoSS+hUhyOYe4GVSJ15W8bp4T6310FYzWWJ8Vr2lj7PiSmT+cTzz/qQvSRZGRaPu
         Hp8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1749365099; x=1749969899;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5+TMvdbUNerpyH8sJEZRNYZgyFmQavgKhbR7MC4e4Bc=;
        b=W04IwgU830GCDJxcwaKViO0/xtsXPIdZKmr4C8tehEQMYWjYDmA4NOTXiVs+gjDQAx
         vcuo2VaNJ/JxqeEYxIB17MC4DTSPVxxgQBZeGEjhYwIY9BGj8yqqxeJcltZbZr9W5XkG
         g8JyJL3MdpM9q5LUZeo8mwQBBgnViYj61ZM7GL249E9XQ31cDQ84Rc7B+XD/OJaJ+I/i
         JyM5PxUGNVrvbLakuS5B1dmEV9lKxJE+zsnZGeV9wAmsi2kwpheiCG0aMd7rZjpnytAy
         hV1z3w9KH7udKAmHK18kKl9AFVaruWsLyUERBBMmFNmYMQowX0ADFawLzS1JamwI1jkn
         u5vQ==
X-Forwarded-Encrypted: i=1; AJvYcCW63SNqWtIM2ASTWAB1uQy+q97s4awuk2QS+yRAY8ZvW1Qygco4GcWyosVWarvntNSezRBcGtnR@lists.linux.dev
X-Gm-Message-State: AOJu0Yzgk1yn4xMW5uZZBSLpqaM75nYQUevfm0CtmKxVfG+QPjAzEybS
	Qpr1l3sgEKyBIO/c6AA7KPabl6Oz+kLLIrH08b408dR93Rrpj5E3yMwwGrQCm7yIcALUKB9OT2k
	VixIeqY8hKZXqjikybf1swNGQJ3VsN5nQzxX05FPPtQ==
X-Gm-Gg: ASbGnctLmfG2uJ2nch+aas/Z66VMMEWS8Q1Y0oGV2IfMYm3zZXwmCiFOfsHP3QOIF/s
	zgGpGpQ33VK/pgPog2DH/DiOdopdAwSIBVyiF0MyPl+yKFuNXESz3aMgVM3jkoC/LNE07ceBi8+
	24VhAbFN90kKF9wCHD4kkg+6/b3Mv+MDOMkn5PCooxFN5jq8GDJuXsIWOGw7Aso4dLwG2lpC608
	1Gq
X-Google-Smtp-Source: AGHT+IHLa/yHhkPSfcyx1hKMa6syQe3C0UX3pgVWBFkb1l/f8WChidJTzsKbqoK0sorDh7BtZ1JkYL+c0MZNTNe9gP0=
X-Received: by 2002:a05:6102:a4d:b0:4e6:f86b:a715 with SMTP id
 ada2fe7eead31-4e7729dc77emr7919545137.13.1749365099319; Sat, 07 Jun 2025
 23:44:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250607100717.706871523@linuxfoundation.org>
In-Reply-To: <20250607100717.706871523@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sun, 8 Jun 2025 12:14:48 +0530
X-Gm-Features: AX0GCFs4rHgJPJiFvVM86gqPeYrxTo-ECIBTxC4hkOtMqhkYsoHvI40OXDuMNTk
Message-ID: <CA+G9fYsY7DFXk6=L93QasmVR_3-FsyPMWjv-hMbW3HcnZEHifw@mail.gmail.com>
Subject: Re: [PATCH 6.14 00/24] 6.14.11-rc1 review
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

On Sat, 7 Jun 2025 at 15:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.11 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 09 Jun 2025 10:07:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.14.11-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 1927b72132dad3de52539a325870bb7257258f73
* git describe: v6.14.10-25-g1927b72132da
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14=
.10-25-g1927b72132da

## Test Regressions (compared to v6.14.9-74-gd9764ae24926)

## Metric Regressions (compared to v6.14.9-74-gd9764ae24926)

## Test Fixes (compared to v6.14.9-74-gd9764ae24926)

## Metric Fixes (compared to v6.14.9-74-gd9764ae24926)

## Test result summary
total: 256049, pass: 234537, fail: 3929, skip: 17018, xfail: 565

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 22 passed, 3 failed
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
* modules
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
