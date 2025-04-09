Received: from mail-ua1-f42.google.com (mail-ua1-f42.google.com [209.85.222.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2860925A2D3
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 08:07:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744186056; cv=none; b=YHoXQM2wD+oYNcgMsHi1r/V5+LdNwt9Ki8A+yuU5iu9WZImj02rd8SF24H+Q0sUDAinHyjDNqTZqrVBJw3cgsyLosEP1miLk/1Hz39TEvtBEJfhOxXDKDyyf1qHkynEcQzsc1sYNsaDnsGP8jLCTXcqs0+i4YksVu+w63AebBBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744186056; c=relaxed/simple;
	bh=LJ8VdqrBwDeVAFSf6p8TCiwf+/ow6MjEMwXoqiuQ1WM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oeT4zUYD5pHv7NLJvhnTpYAo/jwB6BIiyE49++vPdwxt+NkIpsnbjFDNWbd8V6cuvhdIJa6TBb7W1chHPIhY8/MwyC9AiIMKMwwDMOP2uOTqyRPybXvuAzG/Xj5Sg3b09L9xGraFAfXd/+u8u91fzhquFsbG1L31HiO1GDtrMzc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jXwL9a8X; arc=none smtp.client-ip=209.85.222.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jXwL9a8X"
Received: by mail-ua1-f42.google.com with SMTP id a1e0cc1a2514c-86dddba7e0eso2516102241.1
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 01:07:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744186054; x=1744790854; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JXkmBNvnOMHhHWAuvCtHYqjOtkAXTSz9hABkvsrQyCg=;
        b=jXwL9a8Xze986kKjfbd5WDuIIF4iEfNGS5hskoDJ/zzZ/82L7h2lkZdCLjGhzXIA0K
         KkXaF8+lXgwIR/kokp6bBmuaSOZRVxCKbsPO1x81pHcmY1u2YsnO2X1AhDMAMZ7eabln
         asPcAWNOYjjUTbCZTRl9uPYixi2M6FufMo+r+bkevKkRSdZcNravCyyy3LokehOefv45
         532rpGO8TBxR70ouXD+vSmFdo+OodlO38/vZNK8DReu+tnfFtMYIHYGV/NULQhgSxTZo
         2cVZROKuUonbPFYPwIEjNMYU/u52NLeeNooPTzthGkRxNR2xcTo7Mj/iP6vNT0uo3Xn8
         CYYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744186054; x=1744790854;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JXkmBNvnOMHhHWAuvCtHYqjOtkAXTSz9hABkvsrQyCg=;
        b=Ji9uYixjtA6N6L1CorbX86xTpUQ0aMyYh3I0zU11wAIy5YJNXPsr0pk+glUBoi8DSy
         0u2AF7IUBxY49rtjOCtAe3yA9aXFIxf6YAHE+q5Mg9EElaxYAl2n6Q02TO+kRdwb6/5i
         E6DN/qjKVRUfTnmpOpEHW+vE3CkZueK84IT8/VnU7Czd8PsTbyX+p62Co9RLw3/PwWjM
         VIu9Vzeft38nQrPU4Qr7Nia1mkdw+AVifLcklpyVp1m/vJ+f2iqAPid1DfWkmrBIvZ/c
         tdZfeUsXoktSfb+oiqEYO4+vXsUxKqP5v4AfWI23/gjQ1ksaY28IEs/w7z2Vr76PBwEq
         ElGA==
X-Forwarded-Encrypted: i=1; AJvYcCXNIP1l6qNs4ANRRfP2sDo/jQucTcX4jxZsXiTHDg58aC5ETT0ci2x2Ry9t+sXMnRmvoI6dskeM@lists.linux.dev
X-Gm-Message-State: AOJu0YxfhgjCZEFLkExMWc8KtaLu1sH+4k8yx6IhMbFRE8GGXoYzGbou
	X5mom/U1E9XCHFmDrInJr565lKAlKpNL0WSPaVvOjcLyWvYPeoC3amho1iLRkm7Lze8kxMMob08
	MTNRG2c53yfvfBtqTi/wxXMpjRERtJWaEwe/ZZA==
X-Gm-Gg: ASbGncubqaX1jnQigJH4GkOzey1Q12RW8u90sJxKKOTiqraZxzI3flgNcNR8fXEqHHX
	uitsns4wbJTlM6GKnNKTnG6E0yqrYvZwKZIcuSKoQ4+6LoQ4Solv1lp/vOlAFox9X2TvLyoxqWk
	WKya332Zt27BHs/pdohD6TJiFnGbvcL9O8RcNbrgDWXC4eVblb22YVMGA=
X-Google-Smtp-Source: AGHT+IGFd80pHefyWARuDC/0TA3j5rVxp1YRwgqT9bkfVwo/ArU5djEx5pO/sutri3xBssURUTwwWWmFK3A0Cxqn3Tk=
X-Received: by 2002:a05:6102:3f9f:b0:4c6:d008:7349 with SMTP id
 ada2fe7eead31-4c9c447b61bmr1417231137.21.1744186054131; Wed, 09 Apr 2025
 01:07:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408104828.499967190@linuxfoundation.org>
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 9 Apr 2025 13:37:21 +0530
X-Gm-Features: ATxdqUFaqvKK2ZPTUXJqPBxfGL-fWoHAWKFBy9DLIszM6anKNe6D_M-6Zroe8Lc
Message-ID: <CA+G9fYuY0igSO2icsycTh5yDtU79qHU21f6PYRkXo1a4i-exyg@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/268] 6.6.87-rc1 review
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

On Tue, 8 Apr 2025 at 17:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.87 release.
> There are 268 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.87-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.87-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 5c3c45826e66d7aa24ccc47998543005bc190a84
* git describe: v6.6.86-269-g5c3c45826e66
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.8=
6-269-g5c3c45826e66

## Test Regressions (compared to v6.6.83-270-g0d015475ca4d)

## Metric Regressions (compared to v6.6.83-270-g0d015475ca4d)

## Test Fixes (compared to v6.6.83-270-g0d015475ca4d)

## Metric Fixes (compared to v6.6.83-270-g0d015475ca4d)

## Test result summary
total: 93166, pass: 74695, fail: 3829, skip: 14230, xfail: 412

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 128 passed, 1 failed
* arm64: 44 total, 42 passed, 2 failed
* i386: 27 total, 23 passed, 4 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 29 passed, 3 failed
* riscv: 20 total, 20 passed, 0 failed
* s390: 14 total, 12 passed, 2 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 34 passed, 3 failed

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
