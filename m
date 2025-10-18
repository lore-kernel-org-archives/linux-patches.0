Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 367A83BB5A
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 09:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760778540; cv=none; b=c8YnLuniJOEyOHMjsIdPwgsMQtNvMT402jjof/HTbJsBZJb+WYedbKEb4D8wnZaebylovCNziL/PKvmgTSmz1u9XbaTnxTBa+o7HtDiGA3TNBQtx0VZQqx1n5qOjOkQ4NJpmQqPL3ak31O1Ecc2/ekfJRJqNtcxRJKHM9BQLesU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760778540; c=relaxed/simple;
	bh=/FYWQzbOzvoClNNL0BIFiHpFJ4T8coSYDyWOiKJ8bcs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dkR5PEuo1yepWlXkt7caxkNmYq+CbOhWmIrzs9uO1WYCfruQm0M3sLxY2l6+xibkvKIk/l9d/9p6WId/wUt7QNYrNC2XV/n0XryT3NY+hRn3KS6Cmnm83YO7qSQ13/ZAQltk8VqFkb6+duLNwfQdroSQHzPxkoLIh4yAHI0g9Wk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=PJLTH9au; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="PJLTH9au"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-267facf9b58so19074465ad.2
        for <patches@lists.linux.dev>; Sat, 18 Oct 2025 02:08:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760778537; x=1761383337; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oQVK5cROH6bxNTSxavoBpXRZvMfmTRCZy1DV7Locyhs=;
        b=PJLTH9auf5Xw3pW5zUpCEWFCGalR7yPlerh+Z/GSB1YIKRmI+DFOTU5P2wXKR5fO1D
         +trQKhQMkFLqP3qOALtnmb5SOLwYuCvOt16cdgeJbha885tTrNJGcibry+PP0Rh4eGMZ
         rPVzX858WI94zIud0g4953bBoL5CD0ag8z0RhcHvC+H99YQb3lHrX1bfYBuvd/40Bxoa
         vH6j43VYDCCShG1P247q0Y7QEdz3RMYOXeGH+I3bzdVeLR+DMfYMtWJkq8HlOhWm5umq
         a3/GHdvXyNCFrMG04iTqeV6wER3KSEBfbkYE3R6q7/VQYEaeQkkUKUl6C7D5wb5ONv+z
         8iIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760778537; x=1761383337;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oQVK5cROH6bxNTSxavoBpXRZvMfmTRCZy1DV7Locyhs=;
        b=Rkv004Yz/EHxpTsAwGtUQL3e2DVlpGBovVtEAxIuiAypbxqBGm/51/5FQHlaICFudU
         hi2ngIJnLyEn4XGuopBirYLLkzMzqupx9OM033PVXFWBhxQeGnIl2P3PuhW7a90YFUKs
         p5mMwxSBzoKRFdnBX8n28fIWV7oDSOJEuW2XatkFtREmDykmzu1N6ljD8QkhoOPt/tmE
         RHSAmkm46PSnCGx2+g/ej047r3soDI0EQXFnXtd80vjNIw5S8xPT+Vgjr+uTJhtCURdl
         jkcucLr/s2d39LkYcQnSFFVWalHITU5iGLQGXQNPLVCnNJtOpCJKN3JdGLgOV1baB4eK
         6yAg==
X-Forwarded-Encrypted: i=1; AJvYcCVvQ3DufK4ODwVoyAAfNKF/iGwL+16SRgreWcpz1e3QgiosyGmL2AWhQIvNB7Ax9ALbtD0dYJaa@lists.linux.dev
X-Gm-Message-State: AOJu0YwHPcaDjjQgdlUg/KIjYaD2gn33jZkJYV7VTYvgzInc589T1pQK
	ffyrQNm3gqxrVU5VK0gspj4jYyn4x+mjxCYGngbNS5tHp07q+xFsMvNVNHm1PV4FHy432Jjd2PY
	ltDabc8i5ggsihXBGWjTMr+61rCUoomZIo2UOmgN9Cw==
X-Gm-Gg: ASbGncuDgVTsYR8rTvl3KMH6Fjyv0AqhDLGnNugqvroJUqtaJclQMhCskCkAxnn3L3b
	P+dc7ZkjUBHRZIvoIG0RVToPD5kc6mFOBK4hsuIVF/DnlReOmJHdMmFCqFYMCPM2dGOt8riNCaP
	vIyycWKsyXgogtBVwmkH7xu6ah4fLiml4aa9JzMyvnjJXdNC8ix2nY2+HF7sR7OMZsXVHgt3I5T
	UaeOZTTe2zOj1li/NDQ1GvK+evPSyINqPNkg55DYWg25hdK0EF1K3baqVonj4wbmpT2NJz4kwVZ
	850Y7ZPI1ODVep8VJ+y6ecrX5WBcDWQR3wqmmByttWtCQIlQ
X-Google-Smtp-Source: AGHT+IE7ExrY3OVIoQB83N9TwSHawvzsErqOIigCljvk7FolrFSc88sMzVtkF59NgvcU+Q0F92YmHusU7wsTlGLSEM4=
X-Received: by 2002:a17:902:ea03:b0:28e:7567:3c45 with SMTP id
 d9443c01a7336-290c9c897damr96864885ad.9.1760778537482; Sat, 18 Oct 2025
 02:08:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251017145142.382145055@linuxfoundation.org>
In-Reply-To: <20251017145142.382145055@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 18 Oct 2025 14:38:46 +0530
X-Gm-Features: AS18NWD0KnBH7UJI41xuDQpsLXOxSTkkZzLKu0UMG6njeRrDPLXw0BTSVYr9tqQ
Message-ID: <CA+G9fYvRHXOJUfKqxj9MNA1ax1i2xCrazh0x9b3QvrXLm+N+qQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/276] 5.15.195-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, Peter Oberparleiter <oberpar@linux.ibm.com>, 
	Vineeth Vijayan <vneethv@linux.ibm.com>, Heiko Carstens <hca@linux.ibm.com>, linux-s390@vger.kernel.org, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 17 Oct 2025 at 21:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.195 release.
> There are 276 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.195-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The S390 build failed on stable-rc 5.15.195-rc1 with gcc-12, gcc-8
and clang-21 due to following build warnings / errors.

### Build error:
drivers/s390/cio/device.c: In function 'purge_fn':
drivers/s390/cio/device.c:1330:23: error: passing argument 1 of
'spin_lock_irq' from incompatible pointer type
[-Werror=incompatible-pointer-types]
 1330 |         spin_lock_irq(&sch->lock);
      |                       ^~~~~~~~~~
      |                       |
      |                       spinlock_t ** {aka struct spinlock **}
In file included from drivers/s390/cio/device.c:16:
include/linux/spinlock.h:387:55: note: expected 'spinlock_t *' {aka
'struct spinlock *'} but argument is of type 'spinlock_t **' {aka
'struct spinlock **'}
  387 | static __always_inline void spin_lock_irq(spinlock_t *lock)
      |                                           ~~~~~~~~~~~~^~~~
drivers/s390/cio/device.c:1353:25: error: passing argument 1 of
'spin_unlock_irq' from incompatible pointer type
[-Werror=incompatible-pointer-types]
 1353 |         spin_unlock_irq(&sch->lock);
      |                         ^~~~~~~~~~
      |                         |
      |                         spinlock_t ** {aka struct spinlock **}
include/linux/spinlock.h:412:57: note: expected 'spinlock_t *' {aka
'struct spinlock *'} but argument is of type 'spinlock_t **' {aka
'struct spinlock **'}
  412 | static __always_inline void spin_unlock_irq(spinlock_t *lock)
      |                                             ~~~~~~~~~~~~^~~~
cc1: some warnings being treated as errors
make[3]: *** [scripts/Makefile.build:289: drivers/s390/cio/device.o] Error 1

### Suspecting patches
Suspecting commit,

  s390/cio: Update purge function to unregister the unused subchannels
  [ Upstream commit 9daa5a8795865f9a3c93d8d1066785b07ded6073 ]


Build regressions: 5.15.195-rc1: S390: cio/device.c:1330:23: error:
passing argument 1 of 'spin_lock_irq' from incompatible pointer type

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* Build log: https://storage.tuxsuite.com/public/linaro/lkft/builds/34CVOf1lD7sJImDyWLFpIY7OBMW/build.log
* Build details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-5.15.y/v5.15.194-277-g06cf22cc87e0/build/gcc-12-defconfig/
* Build plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/builds/34CVOf1lD7sJImDyWLFpIY7OBMW
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/34CVOf1lD7sJImDyWLFpIY7OBMW/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/34CVOf1lD7sJImDyWLFpIY7OBMW/config

### Steps to reproduce
 - tuxmake --runtime podman --target-arch s390 --toolchain gcc-12
--kconfig defconfig

## Build
* kernel: 5.15.195-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 06cf22cc87e00b878c310d5441981b7750f04078
* git describe: v5.15.194-277-g06cf22cc87e0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.194-277-g06cf22cc87e0

## Test Regressions (compared to v5.15.193-152-g2e59a3f5f544)

* s390, build
  - gcc-12-allnoconfig
  - gcc-12-defconfig
  - gcc-12-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-defconfig-fe40093d
  - gcc-8-tinyconfig

## Metric Regressions (compared to v5.15.193-152-g2e59a3f5f544)

## Test Fixes (compared to v5.15.193-152-g2e59a3f5f544)

## Metric Fixes (compared to v5.15.193-152-g2e59a3f5f544)

## Test result summary
total: 54723, pass: 44299, fail: 2433, skip: 7666, xfail: 325

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 101 total, 101 passed, 0 failed
* arm64: 28 total, 27 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 22 total, 22 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 0 passed, 9 failed
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
