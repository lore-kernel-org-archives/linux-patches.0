Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD1B28DF3E
	for <patches@lists.linux.dev>; Tue, 13 May 2025 12:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747140942; cv=none; b=as4GzjLRBgLuVbysC4xdb4ULVAV9IkPhlL35+/pY63xJzZ5TkJj5q43qd9Cy79TVSIffyAki1I1lG/H4mtNbcx857R7yG+5XbeX+zkHRE2MqFQCbLLiuN0dKMWGr2yvGBb6PiCReJiRdRX2PbK7JKLlpf046giGmdT2Qimf+uOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747140942; c=relaxed/simple;
	bh=NlJ/Fp92upe1PHTUxI10oRYp7XkaSCcUunuBq9RDqtA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X3rGa8mA4jTgWv2xLantvhZV+xuUGdNNjC9WbAQgFRGBkC9J0jEHytNKqlpCJcZs5TQ8aSVKOZeiO/Q+V7BC8tmkusd5rnCPQkYHh19a7VZ+DSrIp6hFo/8gLarST5NmkLkDbOgzpgGnq/k4F0Us/BrDDMzUzoPfoBtTdCgEK4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cJpAe3iB; arc=none smtp.client-ip=209.85.217.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cJpAe3iB"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-4c34dcdaf88so2048413137.2
        for <patches@lists.linux.dev>; Tue, 13 May 2025 05:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747140940; x=1747745740; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Nry7u6hfWQwQzzFrNP3dV55JxQ3yh9zE6gPBoBNYa8E=;
        b=cJpAe3iB+RNFK2hBQXBD6c1qtDB6hM3Wv1Glj6crhVFszWjwg531vTI+/x18ns0vXg
         fveX08SFmLRq4TMhJg5MRuG6ft7lTXgZJuj5aENXQiIF/gfh97q3uerpJVnDsqe3XaNa
         ZU2zn6kXtwmnuI8OZxX1guvFJZxFXPrLxdZVbhzzEMTHbJ/IwpcW/+EQdjsoTiGAMuJu
         J16gKf2d0mXimIiWQxaYQEf7I45UCtZbCXcLLkoSGdABi5/HQtv+AfFyIAfafedPahC5
         pKJvZGdtumFOlRWwn/PwRj3OVOEDntW6tmUBQtrp3x/T2M2oRK3ldG3ljw94lfJd6NA7
         HkBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747140940; x=1747745740;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Nry7u6hfWQwQzzFrNP3dV55JxQ3yh9zE6gPBoBNYa8E=;
        b=RVDKJatvpFYYbGmyg7O4Fy+vREytfv8V79h04SXjfpM5QsSULfV8IcySI9zVoMinCy
         w0jMCxNGVaYFqS6TxJ/d3a82qXv2X994McwD8AAN7PK/YESw9L4JfT79mLgBTcQCoR8I
         o61Q+wL8kdNNUgCsL1pHhRffSorLa6WxzldhOE86I6V6o3nxv3/rWXpXmCenrhrIgCnD
         uIcRi9kHIw/dEYzPuHRJS02knAamrJHdKxKyCyBPQREosmuuzP5naog1sByuW9EiiGe1
         sCFLVse0ExQZiOAAPdIUSuYyKtZ2wztktJi7MsOSHHLsmIswJueSUCDZTAFi0OTjZCW2
         ak3Q==
X-Forwarded-Encrypted: i=1; AJvYcCVplzAnkLloRedxTEJRb3XQRdTmZrCuG5JuqV3Lpv7ahL1BaNLKv6fy+ickGXAKMhl7ePswFtcj@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3XgiHQwU3tefFFryt9YFro9M9KLHKCMOOmn9ngZJ3fSCsXlac
	u9+WAqodW6ARWtZ+HKwSrP5Vw13NXUhEuFjb4wYPKORO5o3N2EoU9DStpNbvuOfNm3K0AzKGgtD
	bEJECVLQt+OUtb/iLLKAiIJ3eB5pB5ML329WgcQ==
X-Gm-Gg: ASbGnct7v7ejSZZnuQv/ZwnFA6p93oTiV57SUBjEveaBVytOqc5yXl06fzyl9CsHaaF
	+SsvfmrQDZUsG6TtzfksJKvc2bUxeVjUoLuCbCZb0A+vvNx3CcjkvCSqzxToYhH8LceOZpDoLYE
	Z7PHFnN6V1MPgXgxtekL4nQCRpo8ccoOA=
X-Google-Smtp-Source: AGHT+IGFcHp5JvTFATrGpVvnOd6CO2iyeKzv73ghvBmScpT3is0UNci+6dQ/KgknaFzY+U4cPmuhRe+a6b3XtqCIY5k=
X-Received: by 2002:a05:6102:1521:b0:4de:81a:7d40 with SMTP id
 ada2fe7eead31-4deed357904mr13690723137.9.1747140939905; Tue, 13 May 2025
 05:55:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250512172041.624042835@linuxfoundation.org>
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 13 May 2025 13:55:28 +0100
X-Gm-Features: AX0GCFth71TY2p9GdRVKCuaaW-FDb23AYXLI8pnuI3D_eyoXuasH5z7h8h0Z8N0
Message-ID: <CA+G9fYsnfsB+NVwntOVVH8KuaZ-TffKiejsFFTVmk-TCNeSy9Q@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/184] 6.12.29-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 12 May 2025 at 18:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.29 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.29-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on mips defconfig tinyconfig and allnoconfig builds failed with
clang-20 toolchain on stable-rc 6.12.29-rc1, 6.14.7-rc1, and 6.6.91-rc1.
But, builds pass with gcc-12.

* mips, build
  - clang-20-allnoconfig
  - clang-20-defconfig
  - clang-20-tinyconfig
  - korg-clang-20-lkftconfig-hardening
  - korg-clang-20-lkftconfig-lto-full
  - korg-clang-20-lkftconfig-lto-thing

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: mips defconfig clang-20 instantiation error expected
an immediate

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build error mips
<instantiation>:7:11: error: expected an immediate
 ori $26, r4k_wait_idle_size - 2
          ^
<instantiation>:10:13: error: expected an immediate
 addiu $26, r4k_wait_exit - r4k_wait_insn + 2
            ^
<instantiation>:10:29: error: expected an immediate
 addiu $26, r4k_wait_exit - r4k_wait_insn + 2
                            ^
<instantiation>:7:11: error: expected an immediate
 ori $26, r4k_wait_idle_size - 2
          ^
<instantiation>:10:13: error: expected an immediate
 addiu $26, r4k_wait_exit - r4k_wait_insn + 2
            ^
<instantiation>:10:29: error: expected an immediate
 addiu $26, r4k_wait_exit - r4k_wait_insn + 2
                            ^
## Build mips
* Build log: https://qa-reports.linaro.org/api/testruns/28410167/log_file/
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.28-185-gd90d77b7ffdf/testrun/28410167/suite/build/test/clang-20-defconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.28-185-gd90d77b7ffdf/testrun/28410167/suite/build/test/clang-20-defconfig/details/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2x0STWrUibOnjQLcSDWp3b7iEHf/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2x0STWrUibOnjQLcSDWp3b7iEHf/config
* Toolchain: clang-20


## Build
* kernel: 6.12.29-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: d90d77b7ffdf042185947a9671131e657003287a
* git describe: v6.12.28-185-gd90d77b7ffdf
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.28-185-gd90d77b7ffdf

## Test Regressions (compared to v6.12.26-167-g483b39c5e6de)
* mips, build
  - clang-20-allnoconfig
  - clang-20-defconfig
  - clang-20-tinyconfig
  - korg-clang-20-lkftconfig-hardening
  - korg-clang-20-lkftconfig-lto-full
  - korg-clang-20-lkftconfig-lto-thing

## Metric Regressions (compared to v6.12.26-167-g483b39c5e6de)

## Test Fixes (compared to v6.12.26-167-g483b39c5e6de)

## Metric Fixes (compared to v6.12.26-167-g483b39c5e6de)

## Test result summary
total: 148229, pass: 122716, fail: 6415, skip: 18536, xfail: 562

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 56 total, 55 passed, 1 failed
* i386: 18 total, 16 passed, 2 failed
* mips: 34 total, 27 passed, 7 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 23 passed, 2 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 42 passed, 7 failed

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
* ltp-di[
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
