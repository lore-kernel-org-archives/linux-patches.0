Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B57921E0DFD
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 14:27:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734100053; cv=none; b=Cf+vOAO52U6t2XKWPwOjj4pQvLR3ewMEMiP2qfcgtQ4BDG3e5VtMZMhpQtLXbwkwd66nJKz/3O/y94JKUID12F0Cz0lyri8uZmfZmV92OE1/gccRAVtBAgn1GRkuhPuuDsCanfDZPH4dMrdPASly3BW7umz6wPGhcaebgRhV4Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734100053; c=relaxed/simple;
	bh=Mpm/LRwd7IySOim0PidDsZae2gN8BufbqTdj7uEiDdU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=B3KJkcw23roZ6ERaMmcCmZbp8nqSZuY+cJhmOBlbCAAlfX5rFyWfeW418G4InfxiTphWZU1usNMvw4P+TBdntvTu/PB2WsV07h27jvGY1BIvgqvescXmHhqfgReAb1vyOfUr/DiMLiFbL+GQ0GIopTw1quttBwoZtPTXtGVfVX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=y/i35OvO; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="y/i35OvO"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-518c46cc6e4so344373e0c.3
        for <patches@lists.linux.dev>; Fri, 13 Dec 2024 06:27:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734100049; x=1734704849; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=jDrucwrqBIUmyUbK2gTGdYC/lYz1YCAOzgB9+QZb9JQ=;
        b=y/i35OvOuWiVer278zq8Nl5OKSHuTDy2BtoV+s9XrnNU5aMlWMDZTgVFcH+NBs/cRg
         BIsQMzX7h1w7x4d+EDWgRGtv45YWkpiGptEY4KjU+EvjlOf/opXnj5vCFlEQD4+ANDMy
         NegiTmjq+SEmQof4nc4oGKvBFhNxjfW4i4v9r7LDMq/lDHZvBGi/oUjzhDxstVElCwL/
         p51OM4nve4ngi26Q4OhBVCsXhuLR4xJUOAUUtuX6gtYPV5N4BeEg4WNpYBP8rwQYzBEq
         gP59hwQbqqKu/p/fBonjcVU77t7pTd9Mxts8eY/Mr9VfE+DiowNjBQyqf966nM3wobCz
         1FhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734100049; x=1734704849;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jDrucwrqBIUmyUbK2gTGdYC/lYz1YCAOzgB9+QZb9JQ=;
        b=HaPI1Qpb9JoMaRG3xZJZ1eQOSR2+vNFSdvIHsCOl5CowbQUsGmEwjUaTKD0oDPxava
         QxcBDtwAH/x1ZuvQqYsuEazM4Cb3vwwlpp3eXz3a9WzsMLA9hyrIN6XiRuLQiFuKhr6U
         WSF8HRL0ztb1Pu0SENiI4DhCae+2+hZ5i5758hOLqV3ltbGIWGI79RqGAwSyzIf6Uw1S
         5shz04GnRKxlC+s8+OFPI1CLEUNyEYF42HXLLe0Xho7WdIhY8I/KkBre38MosxLglyE7
         VmhBOekWdMx8ubqsWw5+NZ+/W+x1oxcRAhSZwoLjkjlvY6dPKYF5misgXUFXrTvN+f4/
         kBoQ==
X-Forwarded-Encrypted: i=1; AJvYcCV91gzsIVzSQU8ZAxJlNiGEYgc/a/bf5A++ieq5JXI7f7FafZ0D2c+esNhmYEFV7NteXjTuOvHj@lists.linux.dev
X-Gm-Message-State: AOJu0YzTDAfO+QSSYOdO7cFjLTILXshxGFh3SSE/+yyc1KrwRxwgVVbd
	WtCF1hn1jUWF4nro9xryBFq5ITt3eWsVaPJwt48TIqYe00JCmE9B4KBAEJz+zNA6ZFCUGA2VFaV
	zVD0DhfD+PlodSaZ9wG5zFUfEisg8XvPg1DyQGA==
X-Gm-Gg: ASbGncuaWtrl/cinOOy9ArOd/yMbrL4yBhDoL47lC28t+DG9DV2h3rY2k4F7Gsby1gI
	tIeiUt89GHKudkU7Imhp9E3dC7n4MQKqOAIbBRMk=
X-Google-Smtp-Source: AGHT+IF9Zpfo6h5y90m06XlevNuAJRPH+b8VWzhOQ2n7NHbhAbY4bKoFRFrDeNJvMZVeIv6vbwAbVLbWpFW8tTRxZf8=
X-Received: by 2002:a05:6122:a0e:b0:518:a261:adca with SMTP id
 71dfb90a1353d-518ca460b50mr2578122e0c.8.1734100049567; Fri, 13 Dec 2024
 06:27:29 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241212144311.432886635@linuxfoundation.org>
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 13 Dec 2024 19:57:18 +0530
Message-ID: <CA+G9fYtbkj_VWQYjPsojO66rRgbcovrWSCDsgcp6PGqWEzGxgw@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/565] 5.15.174-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Dec 2024 at 22:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.174 release.
> There are 565 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.174-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following build warnings were noticed on Linux stable-rc linux-5.15.y
while building parisc.

* parisc, build
  - gcc-11-allnoconfig
  - gcc-11-defconfigcd
  - gcc-11-tinyconfig

Build log:
-----------
arch/parisc/include/asm/cache.h:28: note: this is the location of the
previous definition
   28 | #define ARCH_KMALLOC_MINALIGN   16      /* ldcw requires
16-byte alignment */
      |
In file included from include/linux/skbuff.h:31,
                 from include/net/net_namespace.h:42,
                 from init/main.c:104:
include/linux/dma-mapping.h:546:47: error: macro "cache_line_size"
passed 1 arguments, but takes just 0
  546 | static inline int dma_get_cache_alignment(void)
      |                                               ^

Links:
  - https://storage.tuxsuite.com/public/linaro/lkft/builds/2q7pt39eCahVwI49vKMQD6qe12I/
  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.173-566-g4b281055ccfb/testrun/26287983/suite/build/test/gcc-11-defconfig/log
  - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.173-566-g4b281055ccfb/testrun/26287983/suite/build/test/gcc-11-defconfig/history/

 Steps to reproduce:
  - # tuxmake --runtime podman --target-arch parisc --toolchain gcc-11
--kconfig defconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.174-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 4b281055ccfba614e9358cac95fc81a1e79a5d7e
* git describe: v5.15.173-566-g4b281055ccfb
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.173-566-g4b281055ccfb

## Test Regressions (compared to v5.15.171-100-g056657e11366)

## Metric Regressions (compared to v5.15.171-100-g056657e11366)

## Test Fixes (compared to v5.15.171-100-g056657e11366)

## Metric Fixes (compared to v5.15.171-100-g056657e11366)

## Test result summary
total: 54603, pass: 38929, fail: 2776, skip: 12823, xfail: 75

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 101 total, 101 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 22 total, 22 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 22 total, 22 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
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
