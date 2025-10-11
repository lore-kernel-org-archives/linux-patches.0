Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E33D3218580
	for <patches@lists.linux.dev>; Sat, 11 Oct 2025 09:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760173441; cv=none; b=bFJVHQijJe2wcWzksjAU+4eAkNSHGfARkP8RbK5SyoDI+M4HYmAFOFrZXGAGu3ZnQL5zCGe7z7N+0huwa2M7w8honLjuKPkis0IG6ZXEm68ZyC70RB4CA9iQTKkHHI0csdw/AgsbvnE5q499pl221Mg4pd59040qBYCA0zzq1vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760173441; c=relaxed/simple;
	bh=p4o0vlMg3rayPmvEZ+r6StpN2AzXfZ4MZ7VvyG5in28=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R7HwnFaWAI9Q7on0PtWYDn6P12JE+un0aofuYKJiGTuU9oc43h411E4N6Iue6svZgMnbJAl9l7KDsUsV3lDjNwouTaQvEdLdOjrAmq+J0yMexRTzshzYWlOvJ7ysr4PxK4Iyw6HaveqmHxqesUMsYyX5sThGOVu6TK02yjtGN/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V/wJsQbp; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V/wJsQbp"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-271d1305ad7so46672935ad.2
        for <patches@lists.linux.dev>; Sat, 11 Oct 2025 02:03:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760173434; x=1760778234; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=yri33TAsrDTYHqwIA4g0BnNHEsdzEHDprcYUwbRN96A=;
        b=V/wJsQbpTFBU3vGrPi6IZW7pYpWfSNGVwws+Bd7fmHvGc75f5Yt/TYec+klD8POr91
         Ph2IreKGl1doK6tWa5nNZ8K1sKWLi69aMom4Ql/I4DVeEHvEGz/jUHXKosZIhHkVgXSo
         P7JXjPDEVwY6yTxcquc24WHF1X69ZV/vr9weNkAebB7H/8oyQ3vlB0zu0lNoLIQJvu62
         4rTVnVYEo/F5uljYJri57TgK1w6sLR4CBlEwSS09OY2l2hi+VDR7AczzDvff9C5YrUfG
         QhHMQ54qVADJq+3HDkRo1i15SwKspWA1fjGvGe8/XzqW/1V9bcA4izcOAIt0xs4lh20w
         Ok3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760173434; x=1760778234;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=yri33TAsrDTYHqwIA4g0BnNHEsdzEHDprcYUwbRN96A=;
        b=Vtp8gycitLDDWUJ9NHYb2B5mi7SVe1Tr/QG8fBeg2GDFAX1rOQiEDB4YrX1SPkTiuM
         S+ZfB4IRl5OqizlUMK2aQ8bPwGD1sszyYUEzSbdwbXPHSFdRjvDFkzpcayQ8Y93LsSKa
         t43tSPeBo3FjEIUHbzqxdzI0eiBkP9xhOUzugnSRdfFiCloj4LMT4FnQF6L7I8nABHym
         elPAlF6rcWcE6OJ3DJFDCtDSKGxNqE6U1Tw0MpYIg+SnKPt60r79ppzRifST2zATPbUX
         +O87g6glCXeGAtx6uI7uRNOTeRHNi+J3+Y4vVyPy6FdE9AD4nh1e0ujUrvRoG9pRJZrf
         SaZQ==
X-Forwarded-Encrypted: i=1; AJvYcCXar/5dU6ZQzyS6sHQNmVxU4xJAzj+ICR33pqfNdpQioPPbuCx89o5aKCDOdbGbPoTfa9pL5Pdp@lists.linux.dev
X-Gm-Message-State: AOJu0YzegvufUSEoaiQpdO+k5kfdVhdGiejrFoiT0QOs0hXuKf94BPR/
	WFf8WL4c/gz9jYnHkx6/j/J7L9KSgYvcE4kLPEIEL38el0q5JxkD86lXeOUuU6hXD8dG7JHIMeL
	a4d/etZfR/DrwAMz8H1L8j6zfFM9JCBapBlNxs4hc9w==
X-Gm-Gg: ASbGncsaZKhXHcpYYG5BDxY1ZHrGWfyP5d7E0rHsPTSDo6lNc4oBHOS1oTjyJYF0K4W
	E8US7ABei7ZBr7Hllo6cMR0oenNifqPQR6neJOQu3QPOGpegeI17Fnma55JVPJzJ3AUxWMyQgxx
	Bt9uMxtzIXg39duGoDaKCnYfaA7dzN7Dd2bPPP/4gcBUpHEM5jqZDgRbr75Bwx1uYy7e8GLdUUO
	mu5Ipg9RwJ1WTot3XNCQMAMiQK+AnU3THkNTe/Cz96mpoaSa9p42mElG0UdMq5KsQ2tsOk+IdZB
	ZWQayoz4QjTKQTBuyWqnRNvwn2wL
X-Google-Smtp-Source: AGHT+IEo5Uyde0HdTIg46Mgc3EqcXiuM1A8u34PuNf1I6GxmDtVoPKQmvw+unuf5pGI573VZJcnBBhHNPh3KrFJA1Qc=
X-Received: by 2002:a17:903:2d0:b0:271:45c0:9ec8 with SMTP id
 d9443c01a7336-290273ecac2mr179583115ad.37.1760173434235; Sat, 11 Oct 2025
 02:03:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251010131333.420766773@linuxfoundation.org>
In-Reply-To: <20251010131333.420766773@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 11 Oct 2025 14:33:42 +0530
X-Gm-Features: AS18NWDBQvhzum4m4HTsjHhNVPJw2a1osUi_zNgxe-rnq14n1mvchBBU1cUGBj8
Message-ID: <CA+G9fYuSvzpfBzJJp_Y0wQL6J7qTK=0mDPpBZu1rMM5s_UhrOg@mail.gmail.com>
Subject: Re: [PATCH 6.16 00/41] 6.16.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Oct 2025 at 18:49, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.12 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Oct 2025 13:13:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.16.12-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: e006d63d59f243154aba844a31f8ac8afd93484a
* git describe: v6.16.10-57-ge006d63d59f2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.16.y/build/v6.16=
.10-57-ge006d63d59f2

## Test Regressions (compared to v6.16.10-15-g13cc90c947b1)

## Metric Regressions (compared to v6.16.10-15-g13cc90c947b1)

## Test Fixes (compared to v6.16.10-15-g13cc90c947b1)

## Metric Fixes (compared to v6.16.10-15-g13cc90c947b1)

## Test result summary
total: 166603, pass: 141637, fail: 5024, skip: 19942, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 50 passed, 7 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 23 passed, 2 failed
* s390: 22 total, 21 passed, 1 failed
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
