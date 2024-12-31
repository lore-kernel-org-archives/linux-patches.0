Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACCAF199938
	for <patches@lists.linux.dev>; Tue, 31 Dec 2024 09:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735638307; cv=none; b=HlA7rdCniAoMLmN/EN7Ngl1ENYVMEHkPRXTZJyUxdkQNo46wwSwmz84jMLiyhFXLqeAfKoOfkVsC7IttbJTouOYE2NojSeXhxg14Fo5kJAY2Jfm9cKSKeN9LnTREqa7XlwvWW+TAjzM1oiVNlmKxjjdMTJd1rToCIgGg1YToDys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735638307; c=relaxed/simple;
	bh=vZzXRSW8LNmKF7shAa0pA4su8bnEZsaXYeuxwqbkaOQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nPap6VgqJxaVQOcMMoqVOZf3DCXxFfGcY+v4hJBg0rGkM3fwVAzIC1PwqbdpWXg60iwS1LtzO8nR2pzaO21JCtLuHvpJtc9/fM0r5PeTjSvXsL2nGUvITkZlUMOECP7t14AGG7GuUNuuQRP/GGIEi8NfS52EDjVyn8Tu2p541Xs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wgNmH9/w; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wgNmH9/w"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-4afe1009960so2890987137.0
        for <patches@lists.linux.dev>; Tue, 31 Dec 2024 01:45:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1735638304; x=1736243104; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vJ1YfmX2yTTzmASmFkNHi9BM3gjTBDFTOWrs3hxm6Rk=;
        b=wgNmH9/wFAJPilZI+as05j0XYO8PQxuLDwMS2f11aIXQE838My03uDwb0IDll29SUy
         OgX8T56R6RHG7OgWP65LsKxCxw8GYUBtAzda7JKefZLkA86352T2gSwKx18bixvc1LaV
         l8ZiDyk+o/jjs5yxBTYx1Bha2uMqzhc6AKtJlxNQ6uUjVlfza1Z6SInye89zGu62xZ4P
         p1GJWRh4eZj/OJAcjXFmeqbYfErB1HOrL/a7LZjx73NVGoDL8f5p2/a/bDWagB2iTi7S
         24bcCKtelINCxG0uu8A36sqdIQ94LoL3AtKkZp5nNm20PyiW857qLfiAurxy0h7x6Qur
         JrDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735638304; x=1736243104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vJ1YfmX2yTTzmASmFkNHi9BM3gjTBDFTOWrs3hxm6Rk=;
        b=SeLfzricFhrb8dUXWAxCGQJoaThXeedwzmuZcADC+1NOMgr4c+Y/Sw7a426sVL23yu
         xHwXolwQSdKhFexPV5wdRXIuEFCPKnH1t4QYekcaf0Ce4eVcIVSkjEhzhDjqTjQbI/lP
         2rFdDdIMVEafQGHHljHB4hyjFeUM118o0DU27fkxO0KX8Mw5Uh2x3VSeO9vYkgRhAA6Q
         rm07Lzs+k4IipLJdMbokIkFu/JlUF2qBwdsgqrhq3mBG7kE8foYehEe3e+s+efOXLoXX
         Cad1xA57uQwA+uV2kFmJnNDvhBg/WwnSVNYaknuh0bfOXfKvw6blq5NJkPxdsefyxhhE
         LV5A==
X-Forwarded-Encrypted: i=1; AJvYcCVQgXLMPVSWgPHbmzF/bQs5ltWUJdBC/HJxjCfGc/ueYfpExzu6m/1FvhLEQ23SUvq3xFSBp5cF@lists.linux.dev
X-Gm-Message-State: AOJu0YxZDdakokp0dkzB56Agl/VJuXy6rvZdTDyZT72OdlRKbJoX2Aev
	zIAsMtZnhVPm9yasAj92uzMGKHhldT2Y98/q9eh68r8pKTyMiBZDLhflZxQsmY6TBxj8IzqXvCy
	xotgJDeMysK3sXHEczZVSJfOO68turyocuazE2w==
X-Gm-Gg: ASbGncuIOXkANYmwuKPNFegTi1XH4luDzkdGK8eDdVXaVqOIg4XUSUeu7IdHbKpRgWX
	vNdh0B1ZCaTUq59mY0h0oU8tJlIPbbtv9LgMf+UuOwkKiCX81si01BTKtg+5EEAvYLHEw0nY=
X-Google-Smtp-Source: AGHT+IFDThRheLm9ugI2RUUmmJkz1dEPU+7fmTpZGyI2alfuX0n1UnJfxN9nHjSlRuvd4Y/HRRLdxaes2sAGfoYOlRo=
X-Received: by 2002:a05:6102:5123:b0:4b1:ed1:569d with SMTP id
 ada2fe7eead31-4b2cc4afcd4mr29331894137.27.1735638304569; Tue, 31 Dec 2024
 01:45:04 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241230154207.276570972@linuxfoundation.org>
In-Reply-To: <20241230154207.276570972@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 31 Dec 2024 15:14:53 +0530
Message-ID: <CA+G9fYvTpk-FRH1Su1C=YGrz_Lihi1UONjUOJL4zTsJgco4JjA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/60] 6.1.123-rc1 review
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

On Mon, 30 Dec 2024 at 21:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.123 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.123-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.123-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 519f5e9fdadee615a2a0e2f03840ddc2c938c9c4
* git describe: v6.1.122-61-g519f5e9fdade
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
22-61-g519f5e9fdade

## Test Regressions (compared to v6.1.121-84-g7823105d258c)

## Metric Regressions (compared to v6.1.121-84-g7823105d258c)

## Test Fixes (compared to v6.1.121-84-g7823105d258c)

## Metric Fixes (compared to v6.1.121-84-g7823105d258c)

## Test result summary
total: 113502, pass: 88713, fail: 4842, skip: 19868, xfail: 79

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 138 total, 138 passed, 0 failed
* arm64: 44 total, 42 passed, 2 failed
* i386: 31 total, 27 passed, 4 failed
* mips: 30 total, 25 passed, 5 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 36 total, 33 passed, 3 failed
* riscv: 14 total, 13 passed, 1 failed
* s390: 18 total, 17 passed, 1 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 9 total, 8 passed, 1 failed
* x86_64: 36 total, 36 passed, 0 failed

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
