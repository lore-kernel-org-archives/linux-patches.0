Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C89AB18C32C
	for <patches@lists.linux.dev>; Tue, 31 Dec 2024 09:00:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735635624; cv=none; b=edCsG9RornjPEGIFL6WcO3BPIxpUsxKH4X+u45LisM1jZvcxhLN51roICJspzXBMGGXTmNrnULq27exnyUEAU/sIxhN+7yjvU+gcPF3/vLxBhM3J7qYB8Cp8HnMisCccT8ZtkYmKS6D7WFXwpQyySUyEsNN84VoeAAofqht0Z6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735635624; c=relaxed/simple;
	bh=mUaz7V+0PEjxde47ZIFLIv6+udOt71PERLcQ+z97L98=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ng6lqEShmN4k3rdm/Z133YAiVdn49xLeKothJ4pLLtI6U6xloizyI2OryxV7xGzptKZv93NZOQGCFG5sOiquw3xH1x9NndwgxJmJLQVC13nxQw+VYKJjbu757Ms1rJ84KZmp79iIEUx8hS/QqY/mEapaZ3A2HZGBvzyk8jzfSlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=s7jeuvUZ; arc=none smtp.client-ip=209.85.217.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s7jeuvUZ"
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-4aff78a39e1so2812215137.1
        for <patches@lists.linux.dev>; Tue, 31 Dec 2024 01:00:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1735635621; x=1736240421; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xV44Er4wRAXw4AQa0V8ZgmaVXCQ6ec2RCxnAf1lOfGg=;
        b=s7jeuvUZKAoLBX+IpDKxEKjG7ZBwXa7Od2Th7JJyQuN9jrE1eaTyYT6Ahg7mLX0ODQ
         52MYIGw+HOtHb74f4tx/eKIagx3YuLN7OZ4J3oV8MQ9Ugtn/ELD9YvHBvgpDJJriEQlu
         Ef/2o0H7+DTZebhvmnyrgNlwy/5eqmY+ocB949wxx7dBQNUlZNgmPCuPo/8dynWj4nK7
         h0G1IGKK+atttFBaBPZEM6avmU7IAZSuFSiTt/3/YsMOwoT43qTq6nT2ikgEI/HTHQdL
         zjjLZa2uwrmz4xVDb4iYBhEppKlZkAI4UiYC0RKZhLFXH47dfs8gFHFFLUmgEVG5wgxg
         HCvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735635621; x=1736240421;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=xV44Er4wRAXw4AQa0V8ZgmaVXCQ6ec2RCxnAf1lOfGg=;
        b=SlMBLGwOl7WXqqkjWrsl8MwHFEvr593iEKbElShpC8AsqaMsXQC2S2EO2eje3pch/F
         MQrRqGyYH3F1dZadBEjDP+gQXBnpYFxS9cLSSDnrJg8EL9x1cgMwIMBFC4YGn6Gqm55r
         upL5Q4BUSnzmpFQkq10qo3t5c1EEOnUrbSJcGsYjDBN7Un/pfeuizARtbhUjAR/s/DUm
         gm+6Rvk7hsSntMEVV+IJaTHer4T0n/+m2IodbpX4UzMI+cyKCB8abyrKDhaKW0g5SRf0
         Z+9R1YSCZm8gqGlV1vOY2gWYCSIMsYCCk5fgiJerPXMw9bxn0qUpvL/VVtIz1p527tOw
         lx7Q==
X-Forwarded-Encrypted: i=1; AJvYcCX9B6QtLuGuenVY9jEA2xq+9rDfCTyk31LSJD/JRle5gkKdb+lUgXtDCdFN+tlYNFTHDDjji03f@lists.linux.dev
X-Gm-Message-State: AOJu0YxH8tB2G1k2dcVSDpFcetvXD1EyZbV6zcSafZgA+LRx1GC8Pz0D
	YMTg7z5vTD+9xi3h7msu0c7K2vkIUUt0BZ2iNDGArl26oAhvSuXtn+4VKfb/icGEOjhjqpVU63C
	LYgGlQt6eC6au/6aavv5MDYMh+zCShAjGLumypg==
X-Gm-Gg: ASbGncthhzanApSn4/oSKz0mL8iqsGdL2Crj393KpD4aro2YdZ58u79iZeNpaR730b8
	a+vfWgUzvectLSuYrl5fGdxSsA0jKtgTYJ4NkPczFjJx6g6wdPZidpvMZIScwcxTSKAGub74=
X-Google-Smtp-Source: AGHT+IF7FaTBkk37IejVxQeRN/hYGcd8BaRyjocVh1dqULx9XFD7qpfJRznRFyLO+3//iU7WzuOKLOsz51NOc1+/604=
X-Received: by 2002:a05:6102:a47:b0:4b2:5c0a:92c0 with SMTP id
 ada2fe7eead31-4b2cc37daa1mr33432417137.13.1735635621612; Tue, 31 Dec 2024
 01:00:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241230154218.044787220@linuxfoundation.org>
In-Reply-To: <20241230154218.044787220@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 31 Dec 2024 14:30:10 +0530
Message-ID: <CA+G9fYs-YvKJsGp-7+YdWQgoxTkAh0kUsOO0aXYhLHPTZAzzyQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/114] 6.12.8-rc1 review
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

On Mon, 30 Dec 2024 at 21:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.8 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.12.8-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: ed0d55fbe89cd97180e55170f9f3907b2aa5f91d
* git describe: v6.12.7-115-ged0d55fbe89c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.7-115-ged0d55fbe89c

## Test Regressions (compared to v6.12.6-161-gc157915828d8)

## Metric Regressions (compared to v6.12.6-161-gc157915828d8)

## Test Fixes (compared to v6.12.6-161-gc157915828d8)

## Metric Fixes (compared to v6.12.6-161-gc157915828d8)

## Test result summary
total: 106218, pass: 84898, fail: 4380, skip: 16940, xfail: 0

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 143 total, 137 passed, 6 failed
* arm64: 58 total, 56 passed, 2 failed
* i386: 22 total, 19 passed, 3 failed
* mips: 38 total, 33 passed, 5 failed
* parisc: 5 total, 3 passed, 2 failed
* powerpc: 44 total, 40 passed, 4 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 26 total, 22 passed, 4 failed
* sh: 6 total, 5 passed, 1 failed
* sparc: 5 total, 3 passed, 2 failed
* x86_64: 50 total, 49 passed, 1 failed

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
