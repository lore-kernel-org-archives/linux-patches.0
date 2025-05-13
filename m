Received: from mail-pg1-f180.google.com (mail-pg1-f180.google.com [209.85.215.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 884011531E9
	for <patches@lists.linux.dev>; Tue, 13 May 2025 17:33:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747157591; cv=none; b=HjxDznK5e0hhxd2qbgyGorsirCmWRq4Egx3ONi+kISzWwYMgC1uOLlbqp/mWpl3/CUX4oUKYaUSaqyv7yd74LXuioOmUfc3SFASPcBWxfJhFnNdxW547Eizy1YXJYtKutzfgh9D6Tisq0LIpAyZP3p5hXYiRUoHu83AJ5puPqPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747157591; c=relaxed/simple;
	bh=181/6XfkiZiDiaZQFYts1ypmeeCj9Bxgoo5NUHCw1xA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NrulIE8tIHQ3JYtxSSCLIgsjysEjgA2mxQHLQsxUS+xz4ARyHONy9UIE3AGH0b9U//aP4TPLknGcWumyursLjRw1xy1LyjYFr54XJ6L+B4GvrppzUl3XjqMCIsXp97IcHSjONLeWv4xRB2ycXfa51x+JQIGHtce7pLJ5f4ZErjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OFIDi8yF; arc=none smtp.client-ip=209.85.215.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OFIDi8yF"
Received: by mail-pg1-f180.google.com with SMTP id 41be03b00d2f7-b0b2d1f2845so4106215a12.3
        for <patches@lists.linux.dev>; Tue, 13 May 2025 10:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747157589; x=1747762389; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=FZ78LRASepbKRHv+EBFpcortTEBtcfFbz829Py5N4Fg=;
        b=OFIDi8yFVxrJP/C/gJrtTRfhGmS+7VZcTMqfRZpx369K7hSGlp1nWlYq3Jk5w12wzD
         3NqecMerxjeMuURrqQiRbugrrGyLpaggYvHK16myxnuc6zbiILaaiEorS5bWlRxu8/oe
         iajgwxMVxw7lgV7gYD9n5+YGRSoxX6cAga4HfbLC57q40EAc2WCDm6L0EgdTET0lxdgt
         08WLgN/72C0/wYVlpWSliCoEQksxvFwTFkqJkmmGhvMyckBIbvRJ6dnBs3wVv1QxQzFf
         2YLNO47s3bjKamsSpeG5GHZM93lkJI9ZnpiBMZDzTdQ5PMPEfhsHliEou9/G3HI9P0jO
         caBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747157589; x=1747762389;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=FZ78LRASepbKRHv+EBFpcortTEBtcfFbz829Py5N4Fg=;
        b=dx/bIt6Sm6Ciq9xRkb4vp/HKxlJLpBzEcO6D9f/Qo+sUjjmW3znje51nPIfhWdSj6H
         9YnutzDLi9FgJEwYm6swcikhe2TgboyXiUNi6ODqcxPmQBhV8XlgcnlAyEZ+fLM0iqqG
         i4ppF6hTnY2UqUeF8X1sYbcKpJFF5q1Zge7A2rE4WipZbacOcSKDF+twb4LQsitvNQVC
         It+VGL/ElrUUx8VhqmnxTrcVTA8XX56Sd6PKAhQNQacboVrIOW0MiNDGyGRmIyVNWOHq
         gJjbi1IRzkOBE6+0dfuZwJ8IcOK/iNAnfhZYNzNwrPoz+hehTFMZwKFTKJVRnGk9LX3N
         UUZA==
X-Forwarded-Encrypted: i=1; AJvYcCUGwTcs1lKdnc1y/x77ZsSfHF3aVnFfW/grhvQ5H7ZahPolgFdr7U5ev9gBtiSHFZpxnPS/PTGa@lists.linux.dev
X-Gm-Message-State: AOJu0YxHEXWi8id1+HcOx1kgg7eZJCeim/OQrubGRETXcqoH97F4f+H0
	I7K1QQWSgzH9V+9Z4TbSjrI1/Ud408/YMEGwmF5Wc0D6/d5cR8IYSYAtFFmygRyOEwTBuAnSztI
	/cU1jJUVPl0wv8+UZ6VU3/ujAGQQGyXpRMMuGTA==
X-Gm-Gg: ASbGncsi5JeIeyJoS65kpuNy4oDFl7gDZ5hCCjkNA2KJqxNmQMnyYlkNeDFTwZChZr+
	2ApxVY/nKVZ6165CmJrIXOo2OoLONYBtGejoE1dQ37TlPVqxvKMnyfEMZcsyb4bmFLNf26PzyTS
	qU/KfX6Yl5b2ycHyLPQi0logxrHRea2Co=
X-Google-Smtp-Source: AGHT+IHaSraNc4If8Dzd5YNvgi4mmUzyWm2Z50NAMbHyNH0U41IN9l6+nuCKoX1UgOAsxQqPQJFcK8/TocEH3Gv7YUE=
X-Received: by 2002:a17:903:1a2e:b0:225:abd2:5e4b with SMTP id
 d9443c01a7336-23198127775mr4086715ad.16.1747157588769; Tue, 13 May 2025
 10:33:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250512172027.691520737@linuxfoundation.org>
In-Reply-To: <20250512172027.691520737@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 13 May 2025 18:32:57 +0100
X-Gm-Features: AX0GCFv3ol3ofoxdFfKQkwZwmjcTr6QqYSytm9VmW8NQd-dGeucGQGrJiJFq2Gk
Message-ID: <CA+G9fYsQTEcYgaBP8L2+ypF2KRszCUWiPSc8kpxZwcQ00HYzGw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/113] 6.6.91-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 12 May 2025 at 19:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.91 release.
> There are 113 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.91-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on mips defconfig tinyconfig and allnoconfig builds failed with
clang-20 toolchain on stable-rc 6.6.91-rc1, 6.14.7-rc1 and 6.12.29-rc1.
But, builds pass with gcc-12.

* mips, build
  - clang-20-allnoconfig
  - clang-20-defconfig
  - clang-20-tinyconfig

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

The bisection found this as first bad commit,

    MIPS: Fix idle VS timer enqueue
    [ Upstream commit 56651128e2fbad80f632f388d6bf1f39c928267a ]


## Build mips
* Build log: https://qa-reports.linaro.org/api/testruns/28415740/log_file/
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.90-114-gbb031f5ca8bd/testrun/28415740/suite/build/test/clang-20-defconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.90-114-gbb031f5ca8bd/testrun/28415740/suite/build/test/clang-20-defconfig/details/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2x0VamyqibDAUz06y5ot4qMwMFU/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2x0VamyqibDAUz06y5ot4qMwMFU/config
* Toolchain: clang-20

## Build
* kernel: 6.6.91-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: bb031f5ca8bd915d7802486e59e860738824e535
* git describe: v6.6.90-114-gbb031f5ca8bd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.90-114-gbb031f5ca8bd

## Test Regressions (compared to v6.6.89-130-ga7b3b5860e08)
* mips, build
  - clang-20-allnoconfig
  - clang-20-defconfig
  - clang-20-tinyconfig


## Metric Regressions (compared to v6.6.89-130-ga7b3b5860e08)

## Test Fixes (compared to v6.6.89-130-ga7b3b5860e08)

## Metric Fixes (compared to v6.6.89-130-ga7b3b5860e08)

## Test result summary
total: 119656, pass: 98071, fail: 4521, skip: 16650, xfail: 414

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 44 total, 43 passed, 0 failed, 1 skipped
* i386: 27 total, 20 passed, 7 failed
* mips: 26 total, 19 passed, 7 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 20 total, 20 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 33 passed, 4 failed

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
