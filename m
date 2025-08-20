Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4872DCF51
	for <patches@lists.linux.dev>; Wed, 20 Aug 2025 12:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755693933; cv=none; b=JoKeGFtro6JxgoTUy8o2AWl257RMSzt2MBmc6W7LLC0knwn6Kh2gkuXtzEMvQ7VvItntpdPvd8aVnNa15a4KtM2qdkei7l2eMFZv00kL1HyShQ8aeBe9/2aP9g5ntKr9ck9UvNJjcQDMR+09hy27pIMrfzRkkB0/8vU822xykFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755693933; c=relaxed/simple;
	bh=XGZNUyGClMBZ53/9M+WiiYZ3hnA8W8MXcf7Y6tflI0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PKqd13naRB/BQDz7xmA4Na4FFq4vG5aT8+Uz3ZPa87HGuQoANtS/hcBrMW+Oy7T9uxH4ML6HjU4wsyM/vZttu2BRLlKVJE4QRN/cNq6xCKksz8yu7Ds6HvEVVCIQXeFPzE2LuxU7MNg9YLXBmCGlZLjPmLi2APawHkLbktsmfD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Y+AnEs6w; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Y+AnEs6w"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b4756244423so1262247a12.1
        for <patches@lists.linux.dev>; Wed, 20 Aug 2025 05:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755693931; x=1756298731; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+gRhe9SO61ZZX3zSeOGc3YYqkcNZ6w6+wJsLaFnopq8=;
        b=Y+AnEs6wecTPg0EyslJEkbte7hnW5ZeNthWPv1lWWoBIOpRHlxMCR33pHLYU+qXINF
         hbx6BUfppCJUyZdaq/sI8VmDuu+mAvEaS2upvJAS18H35DeSOAWZpqal9deaDIMVXY21
         eZTghWgGTSzE26JCv9Fi1wYQ9ulQLUgtf6MdRhZRd3MTpkHz51YHK+G2RY3/VLoNJURM
         TvEOgUERsRJ1gf6sTNyOczQ2YloCVAouWr6bM8QmJIaL5x2GU9zlDkqnwBbrCoWcOXa+
         l7U8kkDzTIl0KKQC0YF+uRjOZ87ctHuo2ZOR96oHF6PTMEutfF0U6RYHwgTkcA5akFQb
         cdRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755693931; x=1756298731;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+gRhe9SO61ZZX3zSeOGc3YYqkcNZ6w6+wJsLaFnopq8=;
        b=IhV2om2LGN1Rk9MeBv7EzD4iCoSrLJD3+9BPWknhSSd0yeUC7jB7SIlKOSAmXBgMMF
         fIcYRyyMgumgShmT5W/jHNrDTDEWvAe3cTRAgOxN8BvycHika3S7HLd6vDbWg3WKtPnp
         lOVOw5l8iXpUKfkuMdcIe3+vdpSseRLWpq1e20pPhUfNTA/IsPVzV13fE1tKPWHaVesh
         MBUrvRYzrZYT+dysVviMo3He44hBaXRtQfyCkQSxZtNiMAN2y/d5vujZIc+Cq7SUNNQW
         Psx4QX2w374YucafJhw6hthYILqhwXv4eF0KOFUuWMCuG0atWjKl3OKY/2TClREzdah2
         Z4aA==
X-Forwarded-Encrypted: i=1; AJvYcCVSowwGYAEQQXIkRhSlSpAhiYuOgI8IYFHN7joD1BkjduXatHEWl7Hb9XmNkc36hI2C7PWD+oqU@lists.linux.dev
X-Gm-Message-State: AOJu0Yzs9V4kRB8jcWIROkrmhl2eOrfJqwX2DgBmQuvoVQU+rWtYt0IJ
	PT5viJNyt3pO6SJjsbK05mcLieyKYV+xLna6vIFO8RWgYYYcM6Ijk6X2ELKdRGUCyKzVZqeHcao
	GBGKzSXjggQUco5+5h07pI7zkhqvjJ3+2npgw8avQqg==
X-Gm-Gg: ASbGncuc5BXKhNmHYFh8S59MpgPZj8Y3PVLTjliTWUzjMYAqhhubPd13EfdeigG9Q7A
	93kiKVikTO3wJ8lx0aPnZjp7GSIXC1GP83Qrj53E1Kij2GrDNUrzD8b0DhJZbNf8GNASGeyfUF/
	f9c/sGYuM0vS5QDVV+/qvwrIF+1cDRa6/Q7hIJ/zjUuAerPh7ItMNYxniHdDrkOsXdq+1z6Dszo
	LJW+nwdeRtVJ8B1kakLBKMkarOIbsilcHYKMfXnMjIfOI/WrsY=
X-Google-Smtp-Source: AGHT+IEo6AZMHBNfNm+wGuts2E1fjpomh+rCZIxZABpTnRUGW4TVydP8e55fzi6K1vdQKBnAE9C73PQOIe+rJ5ddIZo=
X-Received: by 2002:a17:902:ebd1:b0:234:9375:e07c with SMTP id
 d9443c01a7336-245ef2716c0mr38415775ad.46.1755693931471; Wed, 20 Aug 2025
 05:45:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250819122820.553053307@linuxfoundation.org>
In-Reply-To: <20250819122820.553053307@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 20 Aug 2025 18:15:19 +0530
X-Gm-Features: Ac12FXzNj44omXAfHJgi9bZ51uoRtB8H1kwROfJrlwowrwNPU6U7fIeg-6nxe0Q
Message-ID: <CA+G9fYuQ_eHhoWsVdQpbmOSS-e_5BQzpar8Sjvtps41fUbknzA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/438] 6.12.43-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, LTP List <ltp@lists.linux.it>, 
	Jan Kara <jack@suse.cz>, linux-ext4 <linux-ext4@vger.kernel.org>, Jann Horn <jannh@google.com>, 
	Jan Stancek <jstancek@redhat.com>, linux-fsdevel@vger.kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Tue, 19 Aug 2025 at 18:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.43 release.
> There are 438 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 21 Aug 2025 12:27:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.43-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

As we discussed from the last time LTP syscalls epoll_ctl04 is a known issue
on the Linus master and Linux next.

* ltp-syscalls
  - epoll_ctl04

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

1)
The bisection results pointing to

First bad commit,
eventpoll: Fix semi-unbounded recursion
commit f2e467a48287c868818085aa35389a224d226732 upstream.

2)
A patch has been proposed to update the LTP test case to align with
recent changes in the Linux kernel code.

[LTP] [PATCH] syscalls/epoll_ctl04: add ELOOP to expected errnos
- https://lore.kernel.org/ltp/39ee7abdee12e22074b40d46775d69d37725b932.1754386027.git.jstancek@redhat.com/
- https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.12.y/v6.12.41-808-ge80021fb2304/ltp-syscalls/epoll_ctl04/

## Build
* kernel: 6.12.43-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: e80021fb2304b3e1f96e7b9a132e69d2c1d022f1
* git describe: v6.12.41-808-ge80021fb2304
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.41-808-ge80021fb2304

## Test Regressions (compared to v6.12.41-370-g3566c7a6291d)
* ltp-syscalls
  - epoll_ctl04

## Metric Regressions (compared to v6.12.41-370-g3566c7a6291d)

## Test Fixes (compared to v6.12.41-370-g3566c7a6291d)

## Metric Fixes (compared to v6.12.41-370-g3566c7a6291d)

## Test result summary
total: 284700, pass: 268768, fail: 4803, skip: 10936, xfail: 193

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 22 passed, 3 failed
* s390: 22 total, 21 passed, 1 failed
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
* kselftest-fpu
* kselftest-futex
* kselftest-intel_pstate
* kselftest-kcmp
* kselftest-kvm
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
