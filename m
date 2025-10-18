Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EAA52F3C0E
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 10:51:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760784680; cv=none; b=lev7MNOmj6F2uiERUANpwxdIXp29glQi3ZN9kvlDbQVPzTHvXgXQHsNvwSsI8DLm0bYi4QpBHIsySkG97qIrDVYPK9nBrHaqy8Pmyv4KoKsPZvs6X6z12LUYQwjW+bECEDxATHksbA+OqlCZymjKquAWTCLJYQSH1P6rkrAIXgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760784680; c=relaxed/simple;
	bh=WC8GTwJNYnj3usj7cIM+YsEpKdRoUi/csrfUvlElHJ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UuK2eQD0mnng63cgSzS/tuk2jbk41c1PyOO7+RJbReO7Sqx0JMK77nQqdgd+vwZVgt2WdYhe3le5c6ulT9KJEkG91XuK1FiDDp5CXy/DMOjWZU1lMLm8lsSijyujJAQkf0rTP6tZPo+gIJXEJ9gBNrB3H1Pi6Lu0N+dSirAgGro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yuLxMROq; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yuLxMROq"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-26d0fbe238bso20817195ad.3
        for <patches@lists.linux.dev>; Sat, 18 Oct 2025 03:51:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1760784678; x=1761389478; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UN99AxvttZDth2AwLZ86dPMNpsRX4UzdoMclz90QAQM=;
        b=yuLxMROq4quZAyW47LWUc563P0BdIhztTWrd+CLk1Ni2kVyhDMG94AUFPxC+XtQChm
         nPiUQd5LQcNdLPoMdUR+S42mqVAmtuWQV1v5E7Qmw3G3GWaQQQKJ8FlrYFxRFTNkwurN
         K4tviFD9v01aUlKxSYtAHNLxIuoi7i0dDpyKVDZuaRr8IfFHrGGsEI4NBSZOXGiwTj3R
         OWd7OF0PULTVQKQiD65hvKXfLzTdzbGumDTw2C2SUFtfv8M/blQ4l6CqQp4mBFVS0xvh
         g5LUPUv3DkujZqV8G9bMK8yamG2vJrVTx9AIC5QZEC5EchoeSqjhaP+f+b7mhZA0rKfF
         cJHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760784678; x=1761389478;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UN99AxvttZDth2AwLZ86dPMNpsRX4UzdoMclz90QAQM=;
        b=Pxi335UFj2o2+8OeKeM2p2QxUd22LiP5yN9DxSQbaEnjvqdV+BOjDG77s+l0SL9kLL
         Tp/+y4R2pHYRfH8Htru6WXC0imq2fOJtPFBp4v0v/VufNOevMlYUI/WgD0s5XmXcryqG
         TIvOPDCfEFMm5ylnZWDd7vudtFVDJGRrVb6mnrlZbuAnFKoY1zGlQJQCMY5JKi+RTuQA
         b9+L7kQcFy0aKzk+LDrVSIx/k8CJbacg3hGrS9uj2M6NvpflANXfMCbKgRniW6n41UfP
         Vchc+vbV/vNXnXeLV1aVqs71d7mkngaVvhCFCGozrVVfhVJTY+JrSqCVHoUj/uULg98Y
         923g==
X-Forwarded-Encrypted: i=1; AJvYcCVOHxVG2I8HAbBMY6q5CoLNA6KDZhsB0eWZt3BryngWkBBN48S5f6LoUmd9ZiqVBR/4ePNUVnPT@lists.linux.dev
X-Gm-Message-State: AOJu0Yz57SqsON0F2cPgi2Ja6CIxIIUa1/NdOzX7amkdi/70vNVQH/qm
	60o7oD6dWFHQvJzsW5yvPyRYm6yOS/XW+I2GaVDw064GfTBpRVEt0jRmenXQ2Z47/YL2l9+l/Ci
	n2hDOj8v5Q5kN2/3z7ozUpqDHgjfwQpx82mux1xF2DQ==
X-Gm-Gg: ASbGncvzeWB+qD5in9c4ou2yzkj7ZxQPcf/fbD4EIlf3MVoT9AH5DHbV84tcOSgasqQ
	5zOAP0rsbucatLaSs435GrpqWK0xK5QyJO1l4S6QhSyeT6u1AzTcWF8tG+/v2IeFLrxOV9FW999
	o7SyEYIvKI2WMBFfQskt3LF9oLh5ye0TkaLMLGKDjis09nstnD1q24u9RoaNf/b1HgMdDprUysw
	q/s/BU4f65/qI5xNAkvAkrPZfzs3I3i4+lHE7OAnybDJue6P0Fopc9GvCu2qvDDT8/rj7taI4sD
	fjqpSsTPlE6aVFgHSpRXDX9GHBEWoKYKh6Sbz1+OsPeJ1M5W
X-Google-Smtp-Source: AGHT+IFkT3kKTmUh/7GkVZYVCfgDYzDpIIGMg58YcOd/EEbkE748tHWMyqEw12UQqPbUB2qFf0oLHod08OnPQNgKv0s=
X-Received: by 2002:a17:902:f78f:b0:290:af0e:1183 with SMTP id
 d9443c01a7336-290cb65c5e7mr64027955ad.51.1760784678388; Sat, 18 Oct 2025
 03:51:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251017145129.000176255@linuxfoundation.org>
In-Reply-To: <20251017145129.000176255@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 18 Oct 2025 16:21:06 +0530
X-Gm-Features: AS18NWC_DJVK9ZCYaqrdWG1cdi0bKv8YI7U-NQXI-lxxQ95eDn7YGRPBlXVGB0A
Message-ID: <CA+G9fYvaa6UHXqbCGTrn8ocJ842gH0VQyEKcJ-C8gXOPtm2NNA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/168] 6.1.157-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, linux-s390@vger.kernel.org, 
	Heiko Carstens <hca@linux.ibm.com>, Peter Oberparleiter <oberpar@linux.ibm.com>, Arnd Bergmann <arnd@arndb.de>, 
	Vineeth Vijayan <vneethv@linux.ibm.com>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Fri, 17 Oct 2025 at 20:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.157 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.157-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The S390 builds failed on stable-rc 6.1.157-rc1 with gcc-14, gcc-8
and clang-21 due to following build warnings / errors.

This reported regressions also found on
  - 5.15.195-rc1
  - 6.6.113-rc1

### Build error:
drivers/s390/cio/device.c: In function 'purge_fn':
drivers/s390/cio/device.c:1316:23: error: passing argument 1 of
'spin_lock_irq' from incompatible pointer type
[-Wincompatible-pointer-types]
 1316 |         spin_lock_irq(&sch->lock);
      |                       ^~~~~~~~~~
      |                       |
      |                       spinlock_t ** {aka struct spinlock **}
In file included from drivers/s390/cio/device.c:16:
include/linux/spinlock.h:374:55: note: expected 'spinlock_t *' {aka
'struct spinlock *'} but argument is of type 'spinlock_t **' {aka
'struct spinlock **'}
  374 | static __always_inline void spin_lock_irq(spinlock_t *lock)
      |                                           ~~~~~~~~~~~~^~~~
drivers/s390/cio/device.c:1339:25: error: passing argument 1 of
'spin_unlock_irq' from incompatible pointer type
[-Wincompatible-pointer-types]
 1339 |         spin_unlock_irq(&sch->lock);
      |                         ^~~~~~~~~~
      |                         |
      |                         spinlock_t ** {aka struct spinlock **}
include/linux/spinlock.h:399:57: note: expected 'spinlock_t *' {aka
'struct spinlock *'} but argument is of type 'spinlock_t **' {aka
'struct spinlock **'}
  399 | static __always_inline void spin_unlock_irq(spinlock_t *lock)
      |                                             ~~~~~~~~~~~~^~~~
make[4]: *** [scripts/Makefile.build:250: drivers/s390/cio/device.o] Error 1

### Suspecting patches
Suspecting commit,

  s390/cio: Update purge function to unregister the unused subchannels
  [ Upstream commit 9daa5a8795865f9a3c93d8d1066785b07ded6073 ]

Build regressions: 6.1.157-rc1: s390/cio/device.c:1316:23: error:
passing argument 1 of 'spin_lock_irq' from incompatible pointer type

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* Build log: https://storage.tuxsuite.com/public/linaro/lkft/builds/34COEro5epq7T4CfI69lXe4c1ZJ/build.log
* Build details:
https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.1.y/v6.1.156-169-gec44a71e7948/log-parser-build-kernel/gcc-compiler-_drivers_s_cio_device_c_error_passing_argument_of_spin_lock_irq_from_incompatible_pointer_type/
* Build plan: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/builds/34COEro5epq7T4CfI69lXe4c1ZJ
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/34COEro5epq7T4CfI69lXe4c1ZJ/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/34COEro5epq7T4CfI69lXe4c1ZJ/config

### Steps to reproduce
 - tuxmake --runtime podman --target-arch s390 --toolchain gcc-12
--kconfig defconfig

## Build
* kernel: 6.1.157-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: ec44a71e7948d92858fec8b3fbefb7638144f586
* git describe: v6.1.156-169-gec44a71e7948
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.156-169-gec44a71e7948

## Test Regressions (compared to v6.1.155-197-gb9f52894e35f)
* s390, build
  - clang-21-allnoconfig
  - clang-21-defconfig
  - clang-21-tinyconfig
  - clang-nightly-allnoconfig
  - clang-nightly-defconfig
  - clang-nightly-tinyconfig
  - gcc-14-allmodconfig
  - gcc-14-allnoconfig
  - gcc-14-defconfig
  - gcc-14-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-defconfig-fe40093d
  - gcc-8-tinyconfig

## Metric Regressions (compared to v6.1.155-197-gb9f52894e35f)

## Test Fixes (compared to v6.1.155-197-gb9f52894e35f)

## Metric Fixes (compared to v6.1.155-197-gb9f52894e35f)

## Test result summary
total: 87986, pass: 72984, fail: 2700, skip: 12061, xfail: 241

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 132 passed, 1 failed
* arm64: 41 total, 38 passed, 3 failed
* i386: 21 total, 21 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 11 total, 10 passed, 1 failed
* s390: 14 total, 0 passed, 14 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 33 total, 32 passed, 1 failed

## Test suites summary
* boot
* commands
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
* kselftest-kvm
* kselftest-livepatch
* kselftest-membarrier
* kselftest-mincore
* kselftest-mqueue
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-sigaltstack
* kselftest-size
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
