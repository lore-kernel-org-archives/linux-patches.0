Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C8A825D8FC
	for <patches@lists.linux.dev>; Wed, 21 May 2025 12:39:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747831185; cv=none; b=Te/KPihz4NTWwN5twoLEEhkJJpQCtHh481EvJMvzmgES5FeocC9+Radbsr2AY7FoZm00hGw1BDjH3vXHbr6igWlPjxU1I/Ssbr10nVsmsRfjWfzLw2uXpFpcNJ/bv8Ps43oSpug8npaeIoCGllQPczHNFOtrNtnXaYAfnY4BivE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747831185; c=relaxed/simple;
	bh=Ol3SYDgilOShW+o1WFJFj1f/kRmxH278HUmeGyLC5/E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=d5UEZi4147rM8dJLBTvmqTZzerBIectEhvB43ELu5PjLOz1b/u6kuFz4lGZXPDvleDGsFuaXBj+mxWRCpjYM9u2DxhMUhLGkvCjA5r18Xq0TeUXX27Kmo4R8fD2UVUGlp5K40/jvbVO3g5ueU7w+e9eY6UW12wjieHRRgmAu/90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=K9zdPGEz; arc=none smtp.client-ip=209.85.217.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="K9zdPGEz"
Received: by mail-vs1-f52.google.com with SMTP id ada2fe7eead31-4dfa0f6127dso2278994137.1
        for <patches@lists.linux.dev>; Wed, 21 May 2025 05:39:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747831180; x=1748435980; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oKupp8/Fu+Q/fXSbeFEKEO8KyFhdMTZOQBPN0yqnh3Y=;
        b=K9zdPGEzmUYTVKr0yCYaTL3kSbzqqLXQCpa36Yg6nP8V6vmPOCYXD354cHXDZ5N6zE
         bYiEzvLzKQDkttTtqJ97NjeiIqJoF/GLd1ZVJTjNW4LC0eIVhVBsxXPZ1Qbbfp8ycrZZ
         xsi9D9Z5hqVLVL6CNaCJ8gDH/q/6AxOiowLzr8T/UV+RBxIT9jrUFmodqMxsm02UY6wH
         kAXrObuICoVKwFYCjAN+/5AkX9FPaiiemN8vcnInNqy9GrdJ6fAiYsHqoUvdXf1oyvCG
         +H9dlH2b0AX33cxTa7Mh5H6Fwxg3zkg8MVU/so8F2FViCKQvcVItrDAhq01gweBDTZ6T
         1wLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747831180; x=1748435980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oKupp8/Fu+Q/fXSbeFEKEO8KyFhdMTZOQBPN0yqnh3Y=;
        b=Rw4FwUUncT5P0HnzmSAkNJPRLPzooBFErjnQMPFJSE0YA1IyFwIEHSgC5ljm1r0Iw6
         wZ9/c67QG6tmwOk1p465/5r7CRSaUySqh64aHtG1F2p92Q5ScH0/Mea8meizKMC8DiJ7
         yMM+xwdy09E3EpmZxWykWHXDc62tV8+BWHnnqx6Mt81h0IFgn5PvgDqbY+pbb+eKuuH/
         kaiJWRvK56C3uWdQYQCyvkt3aUj3abzSLOaItmZXTqzSkgqgdxm8vqGM/8Hvtxt4gjuv
         WHOE95OfQzyLJ7ztbj2IdPiutuSQcl8KFA0ZSeD+zciAcj4i1K5vGdpoDjevDfQcdTsH
         V49g==
X-Forwarded-Encrypted: i=1; AJvYcCV9/AHoPCdyV3fn6lF8hDjrGLYt/bE3HYr0K0PX5AxUW4wEBwv728TpsDbhRlUUuNrmvjguIPLb@lists.linux.dev
X-Gm-Message-State: AOJu0Yyhuou59lg3XP2TxdpYAZuVoANH4SIVdPU8pW+MsTZKsKyY+5Ch
	UrL6q9lpEk2ihu6cxclw0G9BjKn8ocwic0KoaQaze2IC0NR056IGCeRAPcUUEzhq7JGQdXC/N6w
	xCEBurKT6M9IWZ1Ty0zbgbYZmoagqQyc+9XQ9Y72vbg==
X-Gm-Gg: ASbGncuC1TyjkIkrpw9k9HKAJhK84/GfcLvXjOSm3XLZGyBkkBL25K5uo/MywuEgmsV
	VQpNSaVtVctjoG5lrPk0h2lbJP83oJauXx1aNFTooDhCQ7S6EgxxT8hBmVDO0mQ1OD+0fQ2mV9h
	/3Z0vwt4vYWk4eYmIWK30lk7/95e5frB9HF0cFskv01YtRHSkeGstu0zBlNlOmeMNiBw==
X-Google-Smtp-Source: AGHT+IG+EBWrQ9MFOPu2a53gcTca8fxH4g1iNDKit/DXzpT0QHLt9dTkLmNlN0hCtGWDXBUx7uKx49arXcF4HdQ2RIE=
X-Received: by 2002:a05:6102:1593:b0:4c4:fdb9:2ea with SMTP id
 ada2fe7eead31-4e049d5c1ecmr20292772137.7.1747831180485; Wed, 21 May 2025
 05:39:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250520125753.836407405@linuxfoundation.org>
In-Reply-To: <20250520125753.836407405@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 21 May 2025 18:09:29 +0530
X-Gm-Features: AX0GCFu6fLUPi2-ImLv8oVSMddRz_eslZAtfN0laHVarrqF2gfvQcjhr5N7sgAI
Message-ID: <CA+G9fYtpC-uB9wCf=ZYRDF-YrP5WGMU1Y-4TcR+PKjNa97o5Ug@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/59] 5.15.184-rc1 review
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

On Tue, 20 May 2025 at 19:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.184 release.
> There are 59 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.184-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.184-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: ba6ee53cdfadb92bab1c005dfb67a4397a8a7219
* git describe: v5.15.183-60-gba6ee53cdfad
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.183-60-gba6ee53cdfad

## Test Regressions (compared to v5.15.182-55-g5aa355897d1b)

## Metric Regressions (compared to v5.15.182-55-g5aa355897d1b)

## Test Fixes (compared to v5.15.182-55-g5aa355897d1b)

## Metric Fixes (compared to v5.15.182-55-g5aa355897d1b)

## Test result summary
total: 60301, pass: 46648, fail: 2204, skip: 11039, xfail: 410

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 101 total, 101 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
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
