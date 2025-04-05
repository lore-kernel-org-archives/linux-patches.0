Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DF001392
	for <patches@lists.linux.dev>; Sat,  5 Apr 2025 06:29:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743834569; cv=none; b=QECIj9lAdlx2FCZtS3V40hSbGwyJh3yMZfiJvLKbbBUZOIeF0ZN+LZ+3RrUp3hFNl/0At99kUMEh/yY35EJoPPLsIwX8c9Ag0dAK2cAGTA9nu1r8YCkCmifzelLIcG2BvzwuP/zkTThvu/K2aOWz+eIqps2x9drpUkqZCUdg79M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743834569; c=relaxed/simple;
	bh=9vqzDp7O4j3L84uAFcZIhXsaZQIhBtiKkwykBM4JOPA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Se5v4+LCt/kt3ynlt/n5B+cgnLBpn5jRM7a+Lwrml8F3OohwaeXMOVjikVPme5vrYBV8Za8gz9VLnR6VPuPJo2gbYANSBFJHar5UAN+73h/+zPaOApR3MmqaQH0JyZ5K5+pxMg2zoVrfEW4iZt0AtO+ShPO6Q8sLjdseyUVj890=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=SsGCZvlL; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="SsGCZvlL"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-86feb848764so1218509241.0
        for <patches@lists.linux.dev>; Fri, 04 Apr 2025 23:29:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1743834565; x=1744439365; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9Utl2AdZNCkcBOhv0fIljE/ZFO1pXanNvtL1Clfabdg=;
        b=SsGCZvlLmsfkFCDUe+DbduF+yfMrgms2NqXF3mzqCeprV1nqB2Iu1tJjp07g8gnFxl
         6cgXdGcKRgmt+yxpORKkmIaAnYzX50xxYGmQX1CuqssyTfLQDQmIXxTo/Abe/1FP6Sm6
         snaxrcEZpPjKyUUkBRj/RaIGleRRLL+NpuWKMH3GGeaUJVObpWYfrnuaBodmaE4xZiqa
         vTuOCZEKd06ohAbBLN33ORk6bqOacYjntKWiVMwDs0sc+ZkuV8UbItuCdBZGbK/E701W
         GpgE9P7Z7SHFlX+tTMFZPHk4D5sP48vmsH3j1MWgoP9yvnDeXyZon0odNdyBbaoSamcD
         HsTg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743834565; x=1744439365;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9Utl2AdZNCkcBOhv0fIljE/ZFO1pXanNvtL1Clfabdg=;
        b=BSeOKKPD4x9BLMTLlgqynzBW5/TCrn9Rxy3FJS+hMwmnCGLjGmfVK0ApgPTdM0krAr
         qgS/3+m801xnXToZvX+BlQKX4QtdxgTOiluWXkM8mLzqiYfPo7SS+yTbPipDnLx5oncN
         xkBSVH8arrmbkYC2Mo6fOSL3+FBHXV7i5iQkNHO4PapLxsmlNCGU6zXrLrWVHvTZadIp
         RrCK868qnEkMYGQjP0cMNFP/coAOMQxWaWnNhMUmFjymRUr3NFFaY3tgH+CgBU5vjm5g
         VP5ncTYLB0LG0rXxu34kDC+GD/uNn+h4Mnfn0MM5Jw+K2bjWs3aN8V5FfB/TWABM+1yk
         m6Sg==
X-Forwarded-Encrypted: i=1; AJvYcCWC76KT0TBWDny0tBiSVAby+fzZAa9UggaT7m1WNWXZ4T+MNpnFb6zHYcUK1Z/3hpW8nFnpJu0x@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2N4ty+E8chmlNffa1sRzyAP7CXSNvcuEH65nizSxoRBzC/Biw
	w/CZTZY4i5oIYuJVdYuJC0rAtXvJh1FxUBVrcYmTkhZQtkm5SF/lmk1zJmVZCLU+z5o+aBnnkPr
	rOE2BFoFaELk/ZAHhvddIRrntHyr9yDekhYWPKQ==
X-Gm-Gg: ASbGnctA9C+WDY3zpvAc08IlscCx5xJj7/gJGVKs4OeRmi+2zAfE6XVMqcQNZXxtUmI
	FxSpVBGg6Fpoa8D0CDvrC0xeIasDlwUJ960c3PZezhm4hN4CM7twCE815vUG3QUF4clsAVjUy7l
	Imt70AsEJiBt8DOYlPF+YCTXfJ5CTgVdU8adImj+N7qBQNxL6eS5cas8mqLigI
X-Google-Smtp-Source: AGHT+IHjXtMM0/lND/4C1YfN6pB+FvxG5xBPA1G5va8pDe8hv0DRy+KV2tjV00P9S2pdXpa/LiAKD8WE3wYP6F9oc10=
X-Received: by 2002:a05:6102:f88:b0:4c3:858:f07c with SMTP id
 ada2fe7eead31-4c856901e0dmr4370458137.14.1743834565101; Fri, 04 Apr 2025
 23:29:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250403151622.055059925@linuxfoundation.org>
In-Reply-To: <20250403151622.055059925@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 5 Apr 2025 11:59:13 +0530
X-Gm-Features: ATxdqUHtD8sJUPfm4UnmmdIUVFWTMvUomKqZ9daRtLxETGEWitzM1tdtNWpRJ2E
Message-ID: <CA+G9fYvN1TRaX4Wdu2zWcJpTJ-2FzONKdLZsamXXXpufzenakQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/22] 6.12.22-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 3 Apr 2025 at 20:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.22 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.22-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on arm, arm64 and x86_64.

1)
The selftests rseq failed across the boards and virtual environments.
These test failures were also noticed on Linux mainline and next.

We will bisect these lists of regressions and get back to you.

* kselftest-rseq
  - rseq_basic_percpu_ops_mm_cid_test
  - rseq_basic_percpu_ops_test
  - rseq_basic_test
  - rseq_param_test
  - rseq_param_test_benchmark
  - rseq_param_test_compare_twice
  - rseq_param_test_mm_cid
  - rseq_param_test_mm_cid_benchmark
  - rseq_param_test_mm_cid_compare_twice

2)
 The clang-nightly build issues reported on mainline and next.

 * S390, powerpc, build
  - clang-nightly-defconfig
  - clang-nightly-lkftconfig-hardening
  - clang-nightly-lkftconfig-lto-full
  - clang-nightly-lkftconfig-lto-thing

 clang-nightly: ERROR: modpost: "wcslen" [fs/smb/client/cifs.ko] undefined!
  - https://lore.kernel.org/all/CA+G9fYuQHeGicnEx1d=XBC0p1LCsndi5q0p86V7pCZ02d8Fv_w@mail.gmail.com/

3)
 The clang-nightly boot regressions with no console output have been
 reported on mainline and next.

 * boot
  - clang-nightly-lkftconfig-hardening
  - clang-nightly-lkftconfig-kselftest
  - clang-nightly-lkftconfig-lto-full
  - clang-nightly-lkftconfig-lto-thing
  - gcc-13-lkftconfig-debug

  v6.14-12245-g91e5bfe317d8: Boot regression: rk3399-rock-pi-4b
     dragonboard-410c dragonboard-845c no console output
  - https://lore.kernel.org/all/CA+G9fYve7+nXJNoV48TksXoMeVjgJuP8Gs=+1br+Qur1DPWV4A@mail.gmail.com/

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.12.22-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 03f13769310a6563393c6bbbf9466936b50d5b0e
* git describe: v6.12.19-371-g03f13769310a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.19-371-g03f13769310a

## Test Regressions (compared to v6.12.19-348-gf5ef0867777d)
* arm, build
  - clang-nightly-nhk8815_defconfig

* dragonboard-410c, boot
  - clang-nightly-lkftconfig-hardening
  - clang-nightly-lkftconfig-lto-full
  - clang-nightly-lkftconfig-lto-thing
  - gcc-13-lkftconfig-no-kselftest-frag

* dragonboard-410c, kselftest-rseq
  - rseq_basic_percpu_ops_mm_cid_test
  - rseq_basic_percpu_ops_test
  - rseq_basic_test
  - rseq_param_test
  - rseq_param_test_benchmark
  - rseq_param_test_compare_twice
  - rseq_param_test_mm_cid
  - rseq_param_test_mm_cid_benchmark
  - rseq_param_test_mm_cid_compare_twice

* dragonboard-845c, boot
  - clang-nightly-lkftconfig-hardening
  - clang-nightly-lkftconfig-lto-full
  - clang-nightly-lkftconfig-lto-thing
  - gcc-13-lkftconfig-debug

* dragonboard-845c, kselftest-rseq
  - rseq_basic_percpu_ops_mm_cid_test
  - rseq_basic_percpu_ops_test
  - rseq_basic_test
  - rseq_param_test
  - rseq_param_test_benchmark
  - rseq_param_test_compare_twice
  - rseq_param_test_mm_cid
  - rseq_param_test_mm_cid_benchmark
  - rseq_param_test_mm_cid_compare_twice

* e850-96, kselftest-rseq
  - rseq_basic_percpu_ops_mm_cid_test
  - rseq_basic_percpu_ops_test
  - rseq_basic_test
  - rseq_param_test
  - rseq_param_test_benchmark
  - rseq_param_test_compare_twice
  - rseq_param_test_mm_cid
  - rseq_param_test_mm_cid_benchmark
  - rseq_param_test_mm_cid_compare_twice

* powerpc, build
  - clang-nightly-defconfig
  - clang-nightly-lkftconfig-hardening
  - clang-nightly-lkftconfig-lto-full
  - clang-nightly-lkftconfig-lto-thing
  - clang-nightly-ppc64e_defconfig

* rk3399-rock-pi-4b, boot
  - clang-nightly-lkftconfig-hardening
  - clang-nightly-lkftconfig-lto-full
  - clang-nightly-lkftconfig-lto-thing

* x86, kselftest-rseq
  - rseq_basic_percpu_ops_mm_cid_test
  - rseq_basic_percpu_ops_test
  - rseq_basic_test
  - rseq_param_test
  - rseq_param_test_benchmark
  - rseq_param_test_compare_twice
  - rseq_param_test_mm_cid
  - rseq_param_test_mm_cid_benchmark
  - rseq_param_test_mm_cid_compare_twice

* x86_64, build
  - clang-nightly-allyesconfig

## Metric Regressions (compared to v6.12.19-348-gf5ef0867777d)

## Test Fixes (compared to v6.12.19-348-gf5ef0867777d)

## Metric Fixes (compared to v6.12.19-348-gf5ef0867777d)

## Test result summary
total: 126487, pass: 100173, fail: 7402, skip: 18837, xfail: 75

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 136 passed, 3 failed
* arm64: 57 total, 54 passed, 3 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 3 passed, 1 failed
* powerpc: 40 total, 35 passed, 5 failed
* riscv: 25 total, 23 passed, 2 failed
* s390: 22 total, 17 passed, 5 failed
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
