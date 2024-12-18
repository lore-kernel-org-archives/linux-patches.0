Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 688201FA8DA
	for <patches@lists.linux.dev>; Wed, 18 Dec 2024 17:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734544537; cv=none; b=cx0xaXI7/GiS1coVsjgwn/M/FnrCke/khpimAuwv3SdCHSRT8JhtORimUeSjotgv76aOXJASYf+BSKrbimgeHV0dYFpW8YqO3Beu6qgpMGwPZy1CRKCLr4G7JBw34nzq7uHXSE87joQsLMuLPyrbZefr7SyddoHV+422H69T+7w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734544537; c=relaxed/simple;
	bh=1fkc7nikI9BL9Vpy6dN8PYFjwbzoeCT/uR15Wpdt4gc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oQNkxhQ/v7uhJAoqQWmzAXFs0uAg+4kPFL6gWR9d1dNB4q/QImA0IaCZ1Mu5bDeG8+CJKGlGtefvrPtke6z7t3PEJTRb5JI9MoMQkAA/9lkr1RbwCDoVFGFOwLVwR9TidDPHqxxQIq+YvtRG58o7AyunQN76xN5zKpdwa5t/LZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=J3PRcbl1; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J3PRcbl1"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-5174db4e34eso617676e0c.0
        for <patches@lists.linux.dev>; Wed, 18 Dec 2024 09:55:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734544534; x=1735149334; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=zxLa6N0s8/8I31GT13Dejz5oUFgro38O/kMhW3m5z2k=;
        b=J3PRcbl1PTK6K42En6OlBONPYLEJ0KbB8ZTNJ0MLmZLlwhx8T6GRl23WMH1HlAfy2B
         dI/ghmjLuM//yuR5tWZohSVy6T8/T5NMWNGeHBvBsf/0Jd9Q9EYADBey2eWMEojszH0c
         qlq81bTWkQUny1q49NZ329wrSjadXhepkgcs099ZOkF4Igragtvtx7OPkkvnbGH6dn63
         dOlWyERc9/S6cXDhbr3nWaCI+k2H7+pyDYjWijrxNuIT0ukHoWTUkkAh8GgP0szDmKr2
         YEa3+ym36NZwnuX+rRUAU/sPVx+6NBNJrRW+1vDo7REWWDGIVuVprqpnJRw71OS0XQOj
         HyLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734544534; x=1735149334;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=zxLa6N0s8/8I31GT13Dejz5oUFgro38O/kMhW3m5z2k=;
        b=MYUSXglRXdb4huw9tuvw6lA/z+GJe+yK8eh1puIto9suKK5s/wSKRKS+Dr+23MGLoE
         VDRCwIci+VvNF1r2AnDA9HTTStv06GfwJOtfIWORnnnzYk9cQmnzsWs1VK+dlWSenLwo
         vdXELbDeoWRTk02TyvjmmGo0kbHgQvgpOL5qBXY7WD84WcDrRjFe1/ABX1GyGuGlJSvP
         dYUGcb2dafJFtlf6+gbybQ/EEV+A+Ha13Vgi1p10PqPraL6n/GzkXt4LW6UattYxiD2B
         dLj5FtM5kxri8PUR+7RMvXvpECS0u7qnMIur2oU/yDCKfTMDBZ/1Y+e7q4DiFYCHcH1D
         7hyA==
X-Forwarded-Encrypted: i=1; AJvYcCVkDI+J8Vj7P560kwXusyFh8iL/dUMFqbH0ALTluj7ypE/bd5OeZFmuFOEB2Fp6KFFOqQhCIOsA@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6YxzGy/ixP5wDp6F3K9Mkn0wob72EOGSt/UkQndok25EmJ9Xt
	5P+ExmTGUohNuPO8QetNsBcE05pjLDwNAKqXS1VZ+/t8l7kTkGwG4ofRs4urRjk1PhNmicw0KNK
	PTkgug/YZFTt/3QnJB3fCKpu7YKepHy6/K5rMIA==
X-Gm-Gg: ASbGncsOnPyHRTTWMcY+UXltny9VxXyp77ZliyBX7n9s1kRXqCLR+5lRQV0PdjCeZpU
	oq81ZV+RrfZCh6mjEXhzsbdtwo5MsUHo0IkSZFmc=
X-Google-Smtp-Source: AGHT+IFqRvqnqWJ1jd/PevedQX2jc68TXErACDNjxzhdRH7HlNsSyrNrB+808c8lEaAcezLrIXaWYtwNNJ+tsuNu+Pg=
X-Received: by 2002:a05:6122:3c89:b0:50d:39aa:7881 with SMTP id
 71dfb90a1353d-51b649a7444mr390997e0c.0.1734544534354; Wed, 18 Dec 2024
 09:55:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241217170520.459491270@linuxfoundation.org>
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 18 Dec 2024 23:25:23 +0530
Message-ID: <CA+G9fYvWDOkOn2n6n1fasib6g-nEH3Ev88eZfM3mwjr+=f8-XA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/43] 5.10.232-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 17 Dec 2024 at 22:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.232 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Dec 2024 17:05:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.232-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The all i386 builds failed with the gcc-12 and clang-19
toolchain builds on following branches,
 - linux-6.12.y
 - linux-6.6.y
 - linux-6.1.y
 - linux-5.15.y
 - linux-5.10.y

* i386, build
  - clang-19-defconfig
  - gcc-13-defconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
-------------
ld.lld: error: undefined symbol: static_call_initialized
>>> referenced by static_call.c
>>> kernel/static_call.o:(__static_call_update_early) in archive arch/x86/built-in.a

The recent commit on this file is,
  x86/static-call: provide a way to do very early static-call updates
  commit 0ef8047b737d7480a5d4c46d956e97c190f13050 upstream.

js wrote:
Yes, the fix is at (via one hop):
- https://lore.kernel.org/all/aec47f97-c59b-403a-bf2a-d8551e2ec6f9@suse.com/

## Build
* kernel: 5.10.232-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 238644b47ee3440015a824c17a271f482d551c13
* git describe: v5.10.231-44-g238644b47ee3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.231-44-g238644b47ee3

## Test Regressions (compared to v5.10.230-460-g2146a7485c27)
* i386, build
  - clang-19-allnoconfig
  - clang-19-defconfig
  - clang-19-lkftconfig
  - clang-19-lkftconfig-no-kselftest-frag
  - clang-19-tinyconfig
  - clang-nightly-lkftconfig-kselftest
  - gcc-12-allnoconfig
  - gcc-12-defconfig
  - gcc-12-lkftconfig
  - gcc-12-lkftconfig-debug
  - gcc-12-lkftconfig-kselftest
  - gcc-12-lkftconfig-kunit
  - gcc-12-lkftconfig-libgpiod
  - gcc-12-lkftconfig-no-kselftest-frag
  - gcc-12-lkftconfig-perf
  - gcc-12-lkftconfig-rcutorture
  - gcc-12-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-i386_defconfig
  - gcc-8-tinyconfig

## Metric Regressions (compared to v5.10.230-460-g2146a7485c27)

## Test Fixes (compared to v5.10.230-460-g2146a7485c27)

## Metric Fixes (compared to v5.10.230-460-g2146a7485c27)

## Test result summary
total: 34331, pass: 23179, fail: 2919, skip: 8221, xfail: 12

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 101 total, 101 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 22 total, 0 passed, 22 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 21 total, 21 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 24 total, 24 passed, 0 failed

## Test suites summary
* boot
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
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-kcmp
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
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
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
