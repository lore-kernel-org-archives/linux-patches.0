Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14D2C2192F5
	for <patches@lists.linux.dev>; Fri,  4 Apr 2025 17:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743789236; cv=none; b=QU3/4AEuUQkJxkr33Y4+eLt8AghCqIvsh570igMFHRsQa/X918rGcSd6K/yHpBtOaNLaFvMoW6WwKGnIFAyfkOKIrK91Kh1SQShwHDBk+jsZxMBVKLcLwOahpUDsTyE9DTl/KYoLtGtk2PH2xXBV7hx10LShXFRXDBvaOWd8rAA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743789236; c=relaxed/simple;
	bh=w6XLZQZ7SxQAxIlopsBskwMTuttUnj6XdCz/qeLI9Fo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Kx+URmWof/WEjF3X3VO/cAE7AK2fbFRQj5ehWHhB9DkJLZzyJWdYl8BO6GAmxP9p5wUdXdB3pSIhepzOmwN7jmkOIRp+iumJE14yEBUgK3d+dzykXhKdgPKm9qk0m5ZUoQdj4TNy9S04v4Z7r65gQm56xEBruEF6fU8+nsoQOeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gjRX9OZ1; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gjRX9OZ1"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-523f670ca99so1065240e0c.1
        for <patches@lists.linux.dev>; Fri, 04 Apr 2025 10:53:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743789234; x=1744394034; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=y/QkejiZqG1AwqRbXs+dWYNpxR/iWqIC5Zwh4CzRL48=;
        b=gjRX9OZ1BbR20jC+6Y9dgrPjOYmKQ0YlSGgNm9zYhB9HBloHMQcy7uZJBkKje1toWx
         15HOzuiB8/OQiq55uFqGk8NIVQF8pUMxNdno+qsHx3eLjPplX2pkqh3IYyLioCH6LG8/
         tVBzR7s2svvUnnhkJzQi7uAs54Ztgyq9Et1jtgSuIGc9U8ZsBcBleqU14DgOynA2ExY3
         3lSu6EgYEZn8UMcxVceHM5Vccmh3MGfX1EVIi68md30MM4lMBQEluU/ivdqL/PFpGyIb
         0rDgTT/d1ykr+NTb4NUqzHbxK1JW2xTtwxqcDzzNnNlzvGS6+QtybGhDBXTlMrmQRYZn
         K7gw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743789234; x=1744394034;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=y/QkejiZqG1AwqRbXs+dWYNpxR/iWqIC5Zwh4CzRL48=;
        b=msHnXu3aGMsqbqlQvXQCNKX/ldj9ksq17ROGh+W5LNrRlAKIX+tHkbE2bPsUkAoO7g
         7SA0erp2wK7Vg4rZPQoco3ZTE312wW5BlZoZxjSRjAsnjDUoIfv0CbMtMvGaht8MP54+
         gnhVoOxE1TJ5G1DCIs/sbVbCVByDKdbixcXeBxAZhr8RR/+VvNicLmWAzAgCh2xUCz8z
         cBUP5d5SLB0Qfaa9ToUuwHh2uhU1OCUNUgzJNCe8CAy/0HA+xebImaVJYvonM3VIP/1F
         oTh9C3Ze/XmIZYYIkb6j5MnZEos+gcyIHX8hMlJyYzvbSzsQkjqfD7ObfzOjnvmKZzY3
         lMjQ==
X-Forwarded-Encrypted: i=1; AJvYcCUV8X1qKoLJVf7ou/dFl0+wiviHj17fbWA1xEDxsVWjZ5jFysamqinwD/+CetrZvLkfsDv3fbGL@lists.linux.dev
X-Gm-Message-State: AOJu0YybkLcB8HE9RJuy5b4u/d5PsxIjlhCUYqjmlQDdtDgUM2R2Ku7H
	R+qc3DyiegTYWtZ5DvYMUsZROVgkjUDf9VqWi6F/AhNk8MARuJX8dszn1IlONDpcRC8wJ7Z5Pt+
	kinEnTQhz6VGoHHXRXvasV9tazZCzybP64y5eHA==
X-Gm-Gg: ASbGncsfJ1CyhAJWmX/dZ5XTLUtHOaPKFwKDh8ZqJVg50V5zVXVN2GjG9Rgq3pnqNGU
	Oe0CEruhZLL93sn91q7a96TQOXloWOyMyJLh16T1ONI0as+vkBSOPY2kBdXj6+v0FWpNa9/7iQV
	G7Lynaq34dWY7k8ngIDnatz5Lk9AWyjfaJEEiY8VtVvITTXxfXK/HNADqkdxW7dynMrz4a4g==
X-Google-Smtp-Source: AGHT+IHb0kf0KwRowiN1++/tNtzAOf06R1sEJzd3+qIJSrUlcgjsj9QhFya2h5gmYkdwJlrbxqRyKZFKlVdDC+1LPu0=
X-Received: by 2002:a05:6122:a09:b0:520:42d3:91c1 with SMTP id
 71dfb90a1353d-527645a5e5dmr3682982e0c.10.1743789233728; Fri, 04 Apr 2025
 10:53:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250403151620.960551909@linuxfoundation.org>
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 4 Apr 2025 23:23:42 +0530
X-Gm-Features: ATxdqUFpk3ftm-esTm2WI6L89CtrJ8-6rIhluVCmpjNB4EDEzoJu5oFlJFgC-ms
Message-ID: <CA+G9fYuixzW3nkcp_2mPwZnFkDSgDRietB=-Dc=7QZP3KKTCKg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/22] 6.1.133-rc1 review
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

On Thu, 3 Apr 2025 at 20:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.133 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.133-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
The following build issues reported on mainline and next,
* arm, build
  - clang-nightly-nhk8815_defconfig
  - clang-nightly-s3c2410_defconfig

* powerpc, build
  - clang-nightly-defconfig
  - clang-nightly-ppc64e_defconfig

clang-nightly: ERROR: modpost: "wcslen" [fs/smb/client/cifs.ko] undefined!
 - https://lore.kernel.org/all/CA+G9fYuQHeGicnEx1d=3DXBC0p1LCsndi5q0p86V7pC=
Z02d8Fv_w@mail.gmail.com/

## Build
* kernel: 6.1.133-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 819efe388d47dcb84a834dbbe01d7bd2c120053d
* git describe: v6.1.131-221-g819efe388d47
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
31-221-g819efe388d47

## Test Regressions (compared to v6.1.131-198-g0c858fc73636)

## Metric Regressions (compared to v6.1.131-198-g0c858fc73636)

## Test Fixes (compared to v6.1.131-198-g0c858fc73636)

## Metric Fixes (compared to v6.1.131-198-g0c858fc73636)

## Test result summary
total: 89322, pass: 68357, fail: 4336, skip: 16301, xfail: 328

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 133 passed, 2 failed
* arm64: 43 total, 42 passed, 1 failed
* i386: 27 total, 23 passed, 4 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 29 passed, 3 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 14 total, 12 passed, 2 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 35 total, 35 passed, 0 failed

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
