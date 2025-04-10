Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E39A18FC9D
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 06:25:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744266339; cv=none; b=rWxWBybo21RS+8VTr/50fVXxEJh4nGNctfFf+6s0wfBxmYdURKVTPP4qY4o7AuYSl7lUZvd/mCyLkvGiqBrHY2LfN4MgZCsucpGE6G25Q12rkQUHe8M7SbfYYU34tLzY8VZcxewbfHZ51sJLnnRwtFV6vB/uWBxBZ/54KoVTS6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744266339; c=relaxed/simple;
	bh=aGpkY4O/3TbhmrBDujSrzkv1VCnxkOFYrMxit4qRUFw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nu82EBKW4n1HF8xrdfjIRqLjk23eohWbQtYfLZ2M1RzyU0mUYNWbEJoAhGXNyNjtT2qaVrD+hhYAyRTUrShTb50rSr89VE1bIVgWrXaHgcC3PAeV0ql4mjuqnC/vxnn0Ir64Z8RJ9ZXTK3dQ2v+YCVD/802mzZnz092T/YywyIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=K3+nqn2y; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="K3+nqn2y"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-86d3ac0fec0so423337241.1
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 23:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744266336; x=1744871136; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zyNWqPKOQ9/3oQt9wRtOOs4tLD3TZ787ZZ5Pjy8pmfA=;
        b=K3+nqn2yF1B8NrtXI9la9e4iOvG392r4pC7uK7AiUdckkcxqevaCGB7ZRoTwPKO57J
         bkWXWTu0Uloi40DuElaC39l5ZNJHVC4P62+f/8CrwMOF7vPLZtZcTzF8vGbpFqf+Wqoh
         4ZbdraC+zH+cJCVddJaI8NXF75I4nck873KeVzVnb1EVP3oO5OYBb6RzyZ73QUTVPcUi
         XW2xk31h8BlhGsBfWnebgpmPNwiohM2OJTv1trQd/345gn+yp8sa8fuqsL561QnOkm8o
         4lT2e4XiRbEk4sks1agjwc92YkF46XUhSbmhlte/Um2I61blhBqqk19SDD2twx+DnNdv
         OqyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744266336; x=1744871136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zyNWqPKOQ9/3oQt9wRtOOs4tLD3TZ787ZZ5Pjy8pmfA=;
        b=AhKgvCGHAbqCNZIu9CV8i12OY+t7c/HrZ9ix5bJ/Z75pFiSpNE647S4au+Pja+c2tA
         snWmtLXAT5ZzjQLNtfKzQFCNoRsi827vuNJazFo8PAoIViblvEXIy2koR0wstBTVKhE9
         a6VnlHFuKzXtdbnyGWFpJNSKCCT60YEIAC93mTkwGNzyr1/kzTMz8g5hcl5VQr//+S4Z
         8I5j9iT+jlP9vOMDP82wUXG6u12Ok5yrH+4aJW7aMt5XRBTMqKfFDY2bhUgDMod2oYN8
         hdJSco0Kwv8j7NUyGrNJ7PqReJcSPuSSTiMWQ8wkSPAkeUMPhbiKDfr2NJ6VUpQq0Fln
         pclA==
X-Forwarded-Encrypted: i=1; AJvYcCWcqIoeTnHzI7qNctV+y0N/UqOhIINQqr68lqgMTSJk4Kr2LfpKUDB70w5efzIxQ14JPO2+cxtf@lists.linux.dev
X-Gm-Message-State: AOJu0YxDGB4OIYXSXcwrFQSyfDfAjTU2FSCdQ7mHUuNbZnPk3mIZZza5
	DvB2qZoS+LCGJECOwOQDCzVxX2bLzexb6amK9QqMOJv0iSLtNfgAewqYb8oR9qv7ajNhHRxePju
	KcKMFZzzNlH/64WFq0+6rANbbElMZsqdo5jj6WQ==
X-Gm-Gg: ASbGncvJXm5bhr4NOM/RdlW8INrIGx1NXLOJCuR+m1TSZoEYsUEeSxvxpLBfHWOYwzR
	wVm65wovKozU/kGYA8eYshAgvTOct/LhQbZbg6df4/W6Q3bmlIKhJV1r+mX6huQRv19HKD0XOlI
	uI7FAvR5c25b+Hn589+ntb+aAMDuDCprOVO84zuyx4ZSAnRb2GDuJf5UKecSD2TH9XuQ==
X-Google-Smtp-Source: AGHT+IG2aNdsOXAjNvzpg7zSgl4b9ctMJGLb+z8eiGPuyFdtc8URMDmcUMZ8aMiJWyf0izLJvmAFLXZo1jsBoBoZ+OI=
X-Received: by 2002:a05:6102:5615:b0:4c1:83c4:8562 with SMTP id
 ada2fe7eead31-4c9d629409bmr371847137.13.1744266336159; Wed, 09 Apr 2025
 23:25:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250409115907.324928010@linuxfoundation.org>
In-Reply-To: <20250409115907.324928010@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 10 Apr 2025 11:55:24 +0530
X-Gm-Features: ATxdqUGwvc_wcV22L39WBJ0l-_5Wti_pClWG4Nk2KEj2x_9XnIDbIyGu4SQml3A
Message-ID: <CA+G9fYt18c-W0d2aZOt3_=pryrmp211F-HFUdmHNb-Ew8DQjWg@mail.gmail.com>
Subject: Re: [PATCH 6.13 000/502] 6.13.11-rc3 review
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

On Wed, 9 Apr 2025 at 17:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.13.11 release.
> There are 502 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Apr 2025 11:58:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.13.11-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.13.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.13.11-rc3
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: b51363104424dfb8b160270333b1af3057374b28
* git describe: v6.13.10-503-gb51363104424
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.13.y/build/v6.13=
.10-503-gb51363104424

## Test Regressions (compared to v6.13.7-385-g8cbfaadfa0ec)

## Metric Regressions (compared to v6.13.7-385-g8cbfaadfa0ec)

## Test Fixes (compared to v6.13.7-385-g8cbfaadfa0ec)

## Metric Fixes (compared to v6.13.7-385-g8cbfaadfa0ec)

## Test result summary
total: 130642, pass: 103832, fail: 6766, skip: 19617, xfail: 427

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 136 passed, 3 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 35 passed, 5 failed
* riscv: 25 total, 23 passed, 2 failed
* s390: 22 total, 18 passed, 4 failed
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
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
