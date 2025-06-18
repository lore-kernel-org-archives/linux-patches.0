Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AF7287511
	for <patches@lists.linux.dev>; Wed, 18 Jun 2025 10:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750242029; cv=none; b=tOBjH5AyZEOScF0Qa8vgB/8CfslpG31UDdHDjK9z6H6MqbzTsygjVLc2QvmESqcOj0K5niGBN5Pz3BcujqwEpsB7CkNvRbKTgG06srbHZYdY+tnRY+RzVas5fyGNq8GyalOVCZm9psJytxOATebopn3D7XrWGkv9J2Y6cyXmWM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750242029; c=relaxed/simple;
	bh=TSkpXMUCGBLGW57RuPGfv/LqzC6cxyMmgIfCk78NNvQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=REklSft7Rk/+QLmhLXsiKGCaxO7aiJF8F2ruIKaLU09uLiddo/qasBi4GvvLFic0qUOpYfCH7/XgwDFctrInMwHHtzAUF2edQlo86Q0zae1UHhPlnhPITC25REKzboFDl+n370gQGEp/vOiPgsU5JzlgrGjWck5+Z4NRILz2VdQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wqQmhjbw; arc=none smtp.client-ip=209.85.222.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wqQmhjbw"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-87f234ba1abso893949241.1
        for <patches@lists.linux.dev>; Wed, 18 Jun 2025 03:20:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750242026; x=1750846826; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CZscgBK7vQh5GyGDP3R0SwzOToDIeiQZZam9YvCUg+A=;
        b=wqQmhjbwVWi2+6LyucP4bUR2DbxEqxJCMnyZ/ZkwtflAO2KZ3GSKVelQcyF+cWc+xn
         GePVmzDscWS5g64sKFSUTdEoZ9j/DLZLTJCduZq8jw3XvDujU/jq2DZDXcG+z1QFr+kk
         GKuV7nbvc6alhIY13pJGxvP+9D60Kb1C8lYIMtIzAWcYOX7T4RpbiJsPEmDkiUHp+R0b
         CVDflBaX8AfTE6gzs5yvVXor2QvYvqD/9hPp/x9bUBHG58T5Tb7VMxXIzEGGsnHsfpKz
         UJcPq/R1UO8SWvR1ypGq97S8e9/4sFbCBcOUgkMOFrTwFvN4tqMSqQhxGJ52fKC1JX/k
         bu/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750242026; x=1750846826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CZscgBK7vQh5GyGDP3R0SwzOToDIeiQZZam9YvCUg+A=;
        b=W7m9gpWatO90jS9mhyF3vgfkZS/hhMoUUYj5m/DKyKNSphtAdL2Z35lDgZ+OzNyHx3
         kqEBJOCm8s3cT8GrTzo6M3wDvzSJasFnmjz3FTDFd8oG23RBMVNJRsqo0rB0fszT5MK7
         0p+KTFm7P/nNtcYgnZj2Q6RNqySDf+T/CdwMtSQ7I8oKAX2pWaAYtEaszbV6C0q5kRRP
         B7Odn5V1kJNOdZ3BcjHWz1sq4tncGEYw+b/h9FIsU4pqtOpVuQmcP69dxVEKOCP6PCF2
         sIy8KdOTys4pgW+IwTW9W81UFU6OXizkpsqhKDEHe7Ua52DDxG9pdCvoRRHXZZyemSk0
         7GIA==
X-Forwarded-Encrypted: i=1; AJvYcCUDEbKYova4obc5LDrUCG8hIp577Av7eHR4pM/iqz2mKewMThiVo0p16H4jdQwGTbJIjXz5NsRP@lists.linux.dev
X-Gm-Message-State: AOJu0YyrhT7K/AYsCZSOMdjHZISVTjHj5g499GX3jaeyjvVGg+agDRbx
	JIDbMVLo0MpD/xWUCvl23qWS6sWiAWR9YNnmEdkkkW1VoFLSSrb132oHtsgXvidJpLNMrEO6AsI
	Wb/2u9NoMP3YdgZHFTJLhSstAPYqmKTbUrWNMYbha5g==
X-Gm-Gg: ASbGnctQExRji8AvEzmQ704rXDvAyQawil3ExJ4NEBsunL/WPn+wDfH6dhwP40FdbFS
	V6DOg4j7gMTu6tnP17G/BTK2S18BDOe5OGhRZ2Y0nrFPXuC2WBBdv85RC5brmYPDIKyA32BwQOR
	Mk0GYZm5DZwmLeRAbZ7DJBZmELIrt/PFPEsndvJoXU2NjAYpYoI69JFg==
X-Google-Smtp-Source: AGHT+IE3OBH47heT44z75CQFO2vVoaeyYg3Kk8JAVuB+6zADI2o9rVsm2ZYzU9bGVzLJfE7whT3gToQzdyWSK6aa+PY=
X-Received: by 2002:a05:6102:508b:b0:4e2:aafe:1bde with SMTP id
 ada2fe7eead31-4e7f61b60b9mr12500027137.9.1750242026432; Wed, 18 Jun 2025
 03:20:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250617152338.212798615@linuxfoundation.org>
In-Reply-To: <20250617152338.212798615@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 18 Jun 2025 15:50:14 +0530
X-Gm-Features: Ac12FXxVzmGim5VNLRe8LnObfmRIABb-cQ6rWKWTtElMPXcLJuXbjNGza6aHiF0
Message-ID: <CA+G9fYsda33su7S3ysR9q3TSoytpZnWtMX9jU8XXAKTTjoNz4Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/356] 6.6.94-rc1 review
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

On Tue, 17 Jun 2025 at 20:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.94 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jun 2025 15:22:33 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.94-rc1.gz
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

## Build
* kernel: 6.6.94-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 7ef12da06319e12118a7bbb823004d011c57f718
* git describe: v6.6.93-357-g7ef12da06319
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.9=
3-357-g7ef12da06319

## Test Regressions (compared to v6.6.92-445-g58cbe685685b)

## Metric Regressions (compared to v6.6.92-445-g58cbe685685b)

## Test Fixes (compared to v6.6.92-445-g58cbe685685b)

## Metric Fixes (compared to v6.6.92-445-g58cbe685685b)

## Test result summary
total: 217939, pass: 198129, fail: 4284, skip: 15211, xfail: 315

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 127 passed, 0 failed, 2 skipped
* arm64: 44 total, 43 passed, 0 failed, 1 skipped
* i386: 23 total, 23 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

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

--
Linaro LKFT
https://lkft.linaro.org
