Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62989239E69
	for <patches@lists.linux.dev>; Tue, 13 May 2025 10:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747132873; cv=none; b=RuH5bmeS8xUnDx1Qlhoi/Ogdp5UFtE45luFRoXfQx5/COFwJEknKdZnkGFImsspHFr3/X61c51KpdGj3UWECEG6Ss9INljMs8zpPmQwGDcQ4L8Nv3DJ0SApZ6FcGaRYfEgX7px5dNJ/tdZlFyKahNMhu5iVyl+SqiFP3pA6XkGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747132873; c=relaxed/simple;
	bh=CTQckT2HZmRFkfxw8ncpe6Y+0P+Hov7ABUwiXyl5W1U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KuIGACqAAJbHnUTuoh0nHCQWygW5wd6c09NaIcDpRbJPN+be96+lWE/SvufBl4cadf+17/qOP8Cr2yqa40/7EynMQILuZ3/Pt1VbfIgz9ELlEYo5G8K5IG5w/mRV6zgE+LCd6QFnXuT1UXCvyeHDL6u7yCFMXjpiPKF3S4yFpiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uLY9VaqA; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uLY9VaqA"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-525b44ec88aso2081462e0c.3
        for <patches@lists.linux.dev>; Tue, 13 May 2025 03:41:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747132869; x=1747737669; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mfQ9neFs/KkQwu/rsyvkIG7pZfzGZt+yMbnSNAfCILM=;
        b=uLY9VaqAVou3L0owLAJv2u4ixn9vKfBC6i/8rb8PLb3DWgt5RueCPjF5QUq6vSGz3z
         d5hggxdxr+4KIFX7TryGWQDXvhSByfdmN2CUX9JjcZD6z78CY1tAKqo1b0W356GtcsaT
         jR+AqVHvpExD7UDLIYp+qefK3gHUNzr+YgDJVeHGrYJGjJOExAPk9zQZlMLMkKPnR0+o
         df4kLpUxUqfXmJ99T/rm1oomNFN29WyN8xJ0KIkYE+Tez4Kg6ilwcd1L6EpnkwtDxahf
         Bgf2K1z+D97Rj80iYg3pQ/BaYiBpoe+J78kBhO+iE25TmRcjyEnCDCvwtvLSQ2LlFtNX
         WbJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747132869; x=1747737669;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mfQ9neFs/KkQwu/rsyvkIG7pZfzGZt+yMbnSNAfCILM=;
        b=FTzHrEmnQMmjvdvZwKjxQxApe9vNZolK2yxoKDuPMitPkWMR2c+wpqALynYLHVcU/V
         9EkemZVe2Ia7NstKmHqNN+kC/08SSlrwoSNuU0ZJd3cYljF0I8Rus85CwfcjYiz7P8My
         U98UepVG9pON/0uTZZ3w6R39ZR0eF1VBBAO9qBlf0ER/myvBKE4lhnTqm/0RoDsgS6FU
         qu/ZP/CnDJaAjoY9wUao5j6p8Pq2n6WB04rcADy2wHUsOxxm7BOQBahIsNiA/U7jrqUG
         9n86+NM0hggCstZF0bSthhrhswHWIsLz2fadi+M2f8WlhNily+r/FNqFOGhGy/c7mXaa
         iw2g==
X-Forwarded-Encrypted: i=1; AJvYcCU/x+Ce87N3A/uUGnFzhTPJyolKYLvdh8XB2q2wC7RIMg6uEKe7ZSYfNaifzYdS7aTtNdO6Dqis@lists.linux.dev
X-Gm-Message-State: AOJu0Yxw6RQz/uM/QcxdLYTmPwEJ6yFL+SnJna4TlWl2h+k0eiBK6OQZ
	w6xT6xN17uwWvCazInfdi3E82mUKgizrepNYptQxtg2DUEC7LSaQshn2IxNFkpLUhKBBvGs9Eod
	e6jqWqiEOka74yHxzRM4eyYStmWO65O8sQVj9qA==
X-Gm-Gg: ASbGncv0Niv46bifJtxCdp/207QaTeDz1eUHdnAMzUujSq1kk1MG+IkimW3cjG4hpG+
	BUDYMDj2Pla+bnW7ouSYAPlDQLN2/MN8u0qEHto8NSCU5/iaNPuUId1Tsj6pKaipZf3TxSbE12w
	Y+0H3jwHKfbgWZyqA90bQow+6Al8awHtDQQ92FUyVNZw==
X-Google-Smtp-Source: AGHT+IEaQC1x5Zb/J9SdhWkKAIbBENy/MyS503LgRLTtCaHBPpm2j0RzkOlAC+ryGomdrOxBtkoL+cOeZMHd5BxZ2s8=
X-Received: by 2002:a05:6122:3d0d:b0:52b:789:cf93 with SMTP id
 71dfb90a1353d-52c53c769a4mr9774991e0c.5.1747132869155; Tue, 13 May 2025
 03:41:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250512172044.326436266@linuxfoundation.org>
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 13 May 2025 11:40:57 +0100
X-Gm-Features: AX0GCFvABlwvpsFejGmvR-D-CDsu0dVnQstgEoue8lMI6NadE8n39FU2E5xrTaQ
Message-ID: <CA+G9fYuO5m0EgOAbytJv2Ytp9uj-0jHVUGddaXHLckHk+ZLEHA@mail.gmail.com>
Subject: Re: [PATCH 6.14 000/197] 6.14.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, clang-built-linux <llvm@lists.linux.dev>, 
	Anders Roxell <anders.roxell@linaro.org>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Nathan Chancellor <nathan@kernel.org>, 
	Marco Crivellari <marco.crivellari@suse.com>, Thorsten Blum <thorsten.blum@linux.dev>, 
	linux-mips@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 12 May 2025 at 18:43, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.7 release.
> There are 197 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.14.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on mips defconfig tinyconfig and allnoconfig builds failed with
clang-20 toolchain on stable-rc  6.14.7-rc1, 6.12.29-rc1 and 6.6.91-rc1.
But, builds pass with gcc-13.

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
arch/mips/kernel/genex.S:531:2: warning: macro defined with named
parameters which are not used in macro body, possible positional
parameter found in body which will have no effect
 .macro __BUILD_verbose nexception
 ^

## Build mips
* Build log: https://qa-reports.linaro.org/api/testruns/28409657/log_file/
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.6-198-g4f7f8fb4f8e3/testrun/28409667/suite/build/test/clang-20-defconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.6-198-g4f7f8fb4f8e3/testrun/28409657/suite/build/test/clang-20-defconfig/details/
* Build link: https://tuxapi.tuxsuite.com/v1/groups/linaro/projects/lkft/builds/2x0SR9ZL9r6xvF3HT3UgkQA9ebC
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2x0SR9ZL9r6xvF3HT3UgkQA9ebC/config
* Toolchain: clang-20

## Steps to reproduce
 -  tuxmake --runtime podman --target-arch mips --toolchain clang-20
--kconfig defconfig LLVM=1 LLVM_IAS=1

## Build
* kernel: 6.14.7-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 4f7f8fb4f8e35798b197be0b6b13229aa1864da1
* git describe: v6.14.6-198-g4f7f8fb4f8e3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14.6-198-g4f7f8fb4f8e3

## Test Regressions (compared to v6.14.5-184-ga33747967783)
* mips, build
  - clang-20-allnoconfig
  - clang-20-defconfig
  - clang-20-tinyconfig
  - korg-clang-20-lkftconfig-hardening
  - korg-clang-20-lkftconfig-lto-full
  - korg-clang-20-lkftconfig-lto-thing


## Metric Regressions (compared to v6.14.5-184-ga33747967783)

## Test Fixes (compared to v6.14.5-184-ga33747967783)

## Metric Fixes (compared to v6.14.5-184-ga33747967783)

## Test result summary
total: 155299, pass: 129321, fail: 5951, skip: 19411, xfail: 616

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 56 total, 55 passed, 1 failed
* i386: 18 total, 16 passed, 2 failed
* mips: 34 total, 27 passed, 7 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 22 passed, 3 failed
* s390: 22 total, 22 passed, 0 failed
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
