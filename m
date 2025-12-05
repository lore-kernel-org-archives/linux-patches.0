Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6297935C1BD
	for <patches@lists.linux.dev>; Fri,  5 Dec 2025 07:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764919806; cv=none; b=s6aFwwItK/NmdWoLCBkrKwAXCb0V/TGhZo/lAcBntQ8Lzwe4WX7IIy3TMRSi7+DaLcXTysjnBa9i1ELdzdrRlFtXw8sxwUZkl3Md/LMaLY+iKRYJywMTyM/YpNL+qq8xd8U5ZamrU6Fm4spkmfTpgMUkEGz4sqryM/Nj5nHVd1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764919806; c=relaxed/simple;
	bh=bu3z0sYuFgAI3jnyoHwx9hy3reIbpBfRjF6TOJos6zo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l9EanWzW5ij8O6VA/9SGDTNgao5mGB6RRihOMRwMwPVbmc//U8TRtAoBblbX1b8b59WCXq1R10ns61+1OIb6FbXThDJP72zQG41WdkTMKVvqwNeLXMcinNF04qYif5rFGaYoOXe1qjUFoLl4b66uGrD3F7M2Ui4oL6AyxG3oPBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gWEIPyr1; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gWEIPyr1"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-bdde8f1814fso1389718a12.2
        for <patches@lists.linux.dev>; Thu, 04 Dec 2025 23:29:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764919789; x=1765524589; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UahO3NU1ywZFNUrFNPD9TI07fUnqlVn56j/RsJpQWL4=;
        b=gWEIPyr1ld143pU9wmifIqsDBAxHXzEaQmPo06YEpRcSL7p4gkTyLv6+ccly/ZhI8U
         lN+Sny17hIWjCKzlX+uWozh9KEy2fF8BZ5szCJX9isAlrSM/J8I9FqQ5+gXpot8wx4+C
         lgkpKKvNJIZ0LSAnmkbl3fbmpNq5O1cqku9XJAYvxV9Z+Imf06yftdIXfyeTacvWZrBB
         4tAwzrNMePLqRDGIIPQTGmJYmxKr6cgPc+0O2SArLU4wvEOqOj8FkaWZMaH3stHyEXCg
         EPcl2Pqz9JN8+ykH9hGxQjfxkVsu3jAe9nTd45oU3DJxf369xwWVtoKbkbOYjA0DMY4S
         rKMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764919789; x=1765524589;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UahO3NU1ywZFNUrFNPD9TI07fUnqlVn56j/RsJpQWL4=;
        b=P4oPt10lWvj3zDbXc3UBuz99fQGPfygnvWzyyEw6faNu3AaRt6wzEy04JhrQnKvNy9
         YbUDUERZKIIVunteHcuE90aKpteKdG7INpQ2MGUQBPHeijxrMIqZbMBwgsvLYHvtngr4
         7NvGE+vG54y4+UZe+IMI5VhRfl1K6VV7Lczg7rifVyFe2nzFDjMg/H2AtIBX8qLI5k/C
         Nu4+weO5vg1W2p0bvvLco9MusFM9ZU49jfCSuBJCrqyzY1MA4BolLFVz4bMqmldmh2nA
         qMx+RrZXvrWarLyjVSriMpqiDCOj89fUiVYSIqbaClJ+zGv3tF4JcxCHTbSVqfMXYsNT
         ZjHw==
X-Forwarded-Encrypted: i=1; AJvYcCWDOvNobi0S6I7WwL3VKPQI/jkT5Z6LUj6Usgh1E2QjTr52FJZ0VkIyqSJYpU6XGKKT8B8DeO6+@lists.linux.dev
X-Gm-Message-State: AOJu0YzU0yBDrvZdQu9fu/+DwXgysteB/Z7c7EhASghkbJBUtMjvPJFo
	xm49rFjAi+rcP2yijof9LDeCvWgEqXc7jEJ4YBrEcdvi9RhFphAd0E5vwYnPSRZzMqUPQZmMd33
	1Hn9zhboO2n1X5yZx5vPKdFb6AYiCLoCG47J0IFQmOQ==
X-Gm-Gg: ASbGncsTaVFAQv77ua5I397JHw+WiZBMtzAzENN70iNKV3SEKO9WdPIB2ZpzoF2Ddxd
	8S6xQcG8nTXGhh6+zTGNcbwdkSdMRxlnFm5PPphASMKi/Jzu3p8LP4QiJEWZtXp6fja6uD7cLLt
	V20jvjL2ufLK18H0A1hEB1uC3PtKCRqunEQkTpNdCYri0piGkJvZqMu9a1k3ok5xjPaR+y0sa2d
	PEPi/R5UgDk9Co1BDw4+dCt+F6j72KOm9uji8/e8kCllU9VbO4YeNCqfHLc8gQDKHkVZfun2blh
	gA8Vnfy0dZuQDfXpmzhcWLbddXql
X-Google-Smtp-Source: AGHT+IHuL+oIcjQZ4wcxldh0cmXKonJ+cSVNcTlZOBGSI7LHuQ3p6WyyrJz/Vvr0NtdfDBhEDzBs3U9jWqBlQ1QbjpA=
X-Received: by 2002:a05:7300:2a8e:b0:2a4:3593:6476 with SMTP id
 5a478bee46e88-2ab92ed29bdmr4438176eec.38.1764919788530; Thu, 04 Dec 2025
 23:29:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251204163821.402208337@linuxfoundation.org>
In-Reply-To: <20251204163821.402208337@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 5 Dec 2025 12:59:37 +0530
X-Gm-Features: AQt7F2p61xA3vxDJr5nQjj2q6XgpicN80z9X8VqKCA8Ij1U1GuY_k5HOmUEJ-rw
Message-ID: <CA+G9fYvz4R6SRM0ZZ6xDtnFcHo-RdQkrE3b9WTM0RCgWNiuieQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/387] 5.15.197-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com, 
	Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, Nathan Chancellor <nathan@kernel.org>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 4 Dec 2025 at 22:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.197 release.
> There are 387 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 06 Dec 2025 16:37:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.197-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The powerpc allnoconfig failed with gcc-8 but passed with gcc-12.

Build regression: powerpc: allnoconfig: gcc-8: Inconsistent kallsyms data

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

### Build error Powerpc
Inconsistent kallsyms data
Try make KALLSYMS_EXTRA_PASS=1 as a workaround
make[1]: *** [Makefile:1244: vmlinux] Error 1

### Commit pointing to,
  Makefile.compiler: replace cc-ifversion with compiler-specific macros
  commit 88b61e3bff93f99712718db785b4aa0c1165f35c upstream.

### Build
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/36OCnVeYGpKUCXtxVdz6gezHjcQ/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/36OCnVeYGpKUCXtxVdz6gezHjcQ/config

### Steps to reproduce
 - tuxmake --runtime podman --target-arch powerpc --toolchain gcc-8
--kconfig allnoconfig

## Build
* kernel: 5.15.197-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 19afef1f91d735ad63a7caa2e406e6379ede166b
* git describe: v5.15.196-388-g19afef1f91d7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.196-388-g19afef1f91d7

## Test Regressions (compared to v5.15.195-118-g59a59821e6b5)
* powerpc, build
  - gcc-8-allnoconfig

## Metric Regressions (compared to v5.15.195-118-g59a59821e6b5)

## Test Fixes (compared to v5.15.195-118-g59a59821e6b5)

## Metric Fixes (compared to v5.15.195-118-g59a59821e6b5)

## Test result summary
total: 32860, pass: 25148, fail: 2537, skip: 4848, xfail: 327

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 101 total, 101 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 22 total, 21 passed, 1 failed
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
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-futex
* kselftest-intel_pstate
* kselftest-kcmp
* kselftest-livepatch
* kselftest-membarrier
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
