Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EE75450FE
	for <patches@lists.linux.dev>; Thu,  8 May 2025 12:46:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746708387; cv=none; b=JpOIGbUZ6PvISSoMQb5FwHEH4UXyLrq5yNfAfrgrc9TzD5eL33e/uh9Idv5mnajsVt+T6eQZWfU14gNFxYrzfcpku0GjkQiicZu/3s2FGLwwY7PTtygMULhs1ViQ/RkIk12J9/ykY2iFYedb7JDZqBuyBj3FEQ4Oo+GZUsTq54Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746708387; c=relaxed/simple;
	bh=vLN5n2hNo5eOWSuE3Ijv35O1O0lrmdP/iNolJY2Xm4I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tOZ6JtmD3r7S9sLG2E6Z4mpJdvhBRfX1VrmohWkx6A7r1SUM6XRydu+cmWXLn5K6lDduDvemXO3wL2rr2wKyJCtRSZsF7CZwcQmCL0KJUeM+2Uu48/5Qj0L7YRHNkiwZ9gLe0QADCc6YNqq7etJU6OA9bZiJOlAo/zDntBK/rhg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=E+UYv+xw; arc=none smtp.client-ip=209.85.221.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="E+UYv+xw"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-528ce9730cfso238986e0c.3
        for <patches@lists.linux.dev>; Thu, 08 May 2025 05:46:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746708384; x=1747313184; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=GxhL21BMpd7ZCe+Gl4Bl8PbrN0Fr94zagNOX3ZIRJuo=;
        b=E+UYv+xwn5IHlTNAV/9ZlzSPWwwv463Lb2x9pdu1hM70DQYN3R+Hi/jbGuecA6ZL2Y
         57UpbgZwjVjDHiH23kwu3RlHVAC55h+APFgevZRbmMVirNTXKlU6OJLZSc0BZSo4IDGk
         m7fmvTQ00tgL5+Mkr0k1TUZyekx5fg+roVze+sm+Wss4WjKWI334ybdcaCLeQqWFCsb4
         gzOmlZjiV7AQETnYI4Rbmf8AM+0wwwdzYVPU0IhJiJvNuXrjLqOi38QKhpMHTjaJdt1J
         mhK5ss4rNyUlso55ww/dX7qHiLsBOfmMMSORlJqNT2Oy1B995lsi+TH1t/EhV9He2XX6
         3NhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746708384; x=1747313184;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=GxhL21BMpd7ZCe+Gl4Bl8PbrN0Fr94zagNOX3ZIRJuo=;
        b=Tp/boyeXHkDa4gLychMiahVu4c9IDead20frDxsaSHFmOTmMPT5hSiyJtdQgkYKuk8
         HXkMi+o2HYuNoVfxipb+CLQ6KFzaYxrODblrXLfLys/nvWNhg9F4wdd9SGPmDyq4bSC0
         yHxwTpwOtskS5E6euN542sah8Zk4Sbbbd+AprmDRVKsH8GDkEDGVmJp8lip7OyxDce8Z
         i1L3vNunZnMnkmJ7AvZcwYvrq10iAXHh/RNFLkb8KSeQwyv+zJelW7gtILuC318Wmxek
         jmehA94I5bGhg0MblzxLBplrNAEYJKNMBCttuNy4tpiAGyXHxge8KS4MaDpk63Ell/ls
         nQeQ==
X-Forwarded-Encrypted: i=1; AJvYcCVceL7ROJ3yHzJRhwNpYwJ5NjaxFmKPFt9ywHb4fG2XF6Zjc8Hbdm20CpOBTx/c5lESdVKu8LC7@lists.linux.dev
X-Gm-Message-State: AOJu0YxayeMkrbRt5zISv0fnp68+A7jcMRuqzH7dd4X2xe/T9XqJVhw6
	Sj6nppDkJOR3vMuxTCSZrSxbiqfsylZBclFnvkViMaVa2s2IIHnnddmasmRC6YSUIUA8kwYSkfh
	4NpPZ5L5K9C1lMpoD6FDYaq/YmIJFMWr+JZfXEA==
X-Gm-Gg: ASbGncu0uSd0eE5snLxu25vFozHl0F0Hqd6aM+Ck1RtUChf82bgP/ghnfx3Vp0cY2a5
	fVCJ7sQSBny58gU1JelkGpY1TBFszN+uzVkqObXZhS6SyqRC9OfU3kDS13OSopHBpjOOxqKYTym
	WH9oefpkseDQbrqoNmIiZzxYU0zA984LKA4cAWs6mWyLkz6XDQYn5yvMw=
X-Google-Smtp-Source: AGHT+IFbvVLt60GR/D06kXgXguRPxKyPhSA1l9Mw/CXrZpcupzwQrtjV+ttTgDBVDbqFZyYz6tmMEWUoqdrcuK9JqVw=
X-Received: by 2002:a05:6122:d0c:b0:52a:c0db:29e3 with SMTP id
 71dfb90a1353d-52c37adcb5bmr4445788e0c.10.1746708384263; Thu, 08 May 2025
 05:46:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250508112618.875786933@linuxfoundation.org>
In-Reply-To: <20250508112618.875786933@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 8 May 2025 18:16:12 +0530
X-Gm-Features: AX0GCFv8JbrdwShAXY5M9k1TMxLoslym5xx2qqXHrMOUjCEEzcClWt3y2dmQbkc
Message-ID: <CA+G9fYsKqxUExVW1rEhU8_5pYOuhkzXyeL9TmTyGVsV2-C-PFQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/129] 6.6.90-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>, 
	Anders Roxell <anders.roxell@linaro.org>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Palmer Dabbelt <palmer@rivosinc.com>, 
	linux-riscv <linux-riscv@lists.infradead.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 8 May 2025 at 17:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.90 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 10 May 2025 11:25:47 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.90-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on riscv with allyesconfig and allmodconfig builds failed with
clang-20 and gcc-13 toolchain on the stable-rc 6.6.90-rc1 and 6.6.90-rc2

* riscv, build
  - clang-20-allmodconfig
  - gcc-13-allmodconfig
  - gcc-13-allyesconfig

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: riscv uprobes.c unused variable 'start'

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build error riscv
arch/riscv/kernel/probes/uprobes.c: In function 'arch_uprobe_copy_ixol':
arch/riscv/kernel/probes/uprobes.c:170:23: error: unused variable
'start' [-Werror=unused-variable]
  170 |         unsigned long start = (unsigned long)dst;
      |                       ^~~~~
cc1: all warnings being treated as errors

## Build riscv
* Build log:  https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.89-130-ga7b3b5860e08/testrun/28376898/suite/build/test/gcc-13-allmodconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.89-130-ga7b3b5860e08/testrun/28376898/suite/build/test/gcc-13-allmodconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.89-130-ga7b3b5860e08/testrun/28376898/suite/build/test/gcc-13-allmodconfig/details/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2woO9vttziZGlSKcBdoVu2LZm8Q/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2woO9vttziZGlSKcBdoVu2LZm8Q/config
* Toolchain: gcc-13 and clang-20

## Steps to reproduce
 -  tuxmake --runtime podman --target-arch riscv --toolchain gcc-13
--kconfig allmodconfig

## Build
* kernel: 6.6.90-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: a7b3b5860e08c3b29b4a004562b9691d7c25a2f3
* git describe: v6.6.89-130-ga7b3b5860e08
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.89-130-ga7b3b5860e08

## Test Regressions (compared to v6.6.87-586-gda7333f263c3)

* riscv, build
  - clang-20-allmodconfig
  - gcc-13-allmodconfig
  - gcc-13-allyesconfig

## Metric Regressions (compared to v6.6.87-586-gda7333f263c3)

## Test Fixes (compared to v6.6.87-586-gda7333f263c3)

## Metric Fixes (compared to v6.6.87-586-gda7333f263c3)

## Test result summary
total: 112131, pass: 91642, fail: 4421, skip: 15654, xfail: 414

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 27 total, 20 passed, 7 failed
* mips: 26 total, 22 passed, 4 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 20 total, 17 passed, 3 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* riscv: 37 total, 33 passed, 4 failed

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

--
Linaro LKFT
https://lkft.linaro.org
