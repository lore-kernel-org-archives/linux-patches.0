Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7F51624F8
	for <patches@lists.linux.dev>; Thu,  6 Feb 2025 14:57:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738853823; cv=none; b=NnN9JlNAj69qwrUzpCRvXhnD+Kt7AcqrIMmlQ+s7somFrfiZcBs3g+aT6cZcPIx9TIRD+4qk8McdgP58y3VMmA7yHXrQafbpUfEZquQ1XGq43XYxewDIFlySmUYHyst7IvKVYfQKvKoeiS9mb4e34Np0T7xQ36f9Q0YJbr8QWXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738853823; c=relaxed/simple;
	bh=6uq0mAsPLJS8exNPPFK8GwkvG8bs5kLtKrK6eAgoTqM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eC/grWf7W+jiXMqyB9mYkH2f25uDm0ql3JXbJ+umuduWJrD3QFiGq9vQEkz90cKDVkNk22fv2wN3Z8A9kKwuqkLmh021M/WWVgqY6EmpDM7QYcT7oby5HWc2HKBJFfnaIBB/o13BolLTLifpAnZPrD9RN6I9lWIwJTDuzUGZLgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IexZVOck; arc=none smtp.client-ip=209.85.217.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IexZVOck"
Received: by mail-vs1-f54.google.com with SMTP id ada2fe7eead31-4ba7d79cb57so139825137.2
        for <patches@lists.linux.dev>; Thu, 06 Feb 2025 06:57:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738853820; x=1739458620; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jfnsTMmEDZLdDZKD5lXbIllWt+t0HFZbbF8QjtXMaKs=;
        b=IexZVOckbaJca0c0VIfrVHlHloV/0j0ezeX8LvYEhOX/YYPSyfw3tVypVY0rQK5l1m
         FINC/xZlYKrTGKObD0buAmVAxPqgzbyfhuth2m5vjmFZJWAQrnCjI+S/O+lcoOD07ryc
         nT/rXeUtxMxBGuKVhM0r3FgnTuvfF3G5akzSYG0PCzTuJX56l7sLIido4P9E5DL3CeWB
         yUyQFFvW38zUjlCwS3x0ynq5KPTdNIN/HiI067i0zFwTW6oqHGHlKZbFunxpTgPfNBR6
         urCFLcJaN2jesGDMjcU3VjlyFz2sJiTC0oGojUgVtegoaFYKxBcYM05QhkVf8634SChW
         QOfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738853820; x=1739458620;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jfnsTMmEDZLdDZKD5lXbIllWt+t0HFZbbF8QjtXMaKs=;
        b=UP8aYhYqeSGX6o7UpDL4I5SOSwWdrWAYipZv6ZCVcBvCuSfV9mg5WGpElaV/w4sX5Y
         s+4cqiYNvHd6fhYnT+OdVG7Xwn4EyRCy7qtRtFWeT4GTRJvjoLpQlP2q313GY08eG9L+
         8J+EoKF0GhsGq0j4S+DxdAH6ZrAKzJ81VpNMu6TsjQokbB883vS5y3XmX8JiQhG/qnHi
         cWNZ6ou1UYfRJB1WOIXHNX7j45mwwDlCTIGoKv8ChVubmmUVHSyAHUE093G1SBziUEg8
         k/Zp//4HSun+hIiL0qF0GK0j3+fKCXBtnW0/pG2s3puooMjNBPwW7bL9KqiBQF8xIehf
         628g==
X-Forwarded-Encrypted: i=1; AJvYcCXa7ZWb2/E5HQvsX++NU1ZJaHFpqYr7guUJ48u+QeV+us2XUMaofm6NFZ3lQq+vAJPlkKTjKsA6@lists.linux.dev
X-Gm-Message-State: AOJu0YwqbdfG1QM1YPJIjpuspt9a1Abi26k52YZiqlidphnuboSw3/M7
	6OFO/DT1MWeFoez0zdENDN0qIAimkITYfLO/OGp5Wfn797Zr3vr1ttKy863fGHN475/4iSNArPe
	xFeNrBrBV78/49eUJA1uQON//ne6JBtlUSIMXDg==
X-Gm-Gg: ASbGncskrxtuogtMSQFBerb40OJJzF7xPQR496/QZgkib8W4t1FimDGFAQN1dPFveDI
	yWnZtT4b82EIzGI5pcyG/Rp2Vwbk/SVbq9eVEaMZx4yL2IIa5sYBu3IYvdjAAsyZPIJagz0hpD7
	wZkvMz2DxiAywLVW2zn7dzz1+rDMDiDA==
X-Google-Smtp-Source: AGHT+IF1gfa+n/8OkVpzIpcr7+uOCYLCT1ZeK9A33AjOH/LYrvhC5X9BjSQGBsh4TdmE2VYnL17ZPfLGRnsQkuzHtR4=
X-Received: by 2002:a05:6102:2b8d:b0:4af:ed5a:b697 with SMTP id
 ada2fe7eead31-4ba478e696cmr4806047137.13.1738853820234; Thu, 06 Feb 2025
 06:57:00 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250205134420.279368572@linuxfoundation.org>
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 6 Feb 2025 20:26:47 +0530
X-Gm-Features: AWEUYZlyhthLvcxBuYa3QMp3qch5FNwA3x567X5JSJFQpCw9jy_XQspq4Iungu8
Message-ID: <CA+G9fYtCam8wR6Z-Agx6vaQOtXcomc_PaM+TX6QFY9BOFzk0oQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/393] 6.6.76-rc1 review
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

On Wed, 5 Feb 2025 at 19:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.76 release.
> There are 393 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Feb 2025 13:43:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.76-rc1.gz
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
* kernel: 6.6.76-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 3b8d2f9dc632278f4bc3589b49712b752cb93654
* git describe: v6.6.74-439-g3b8d2f9dc632
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.7=
4-439-g3b8d2f9dc632

## Test Regressions (compared to v6.6.74-44-g2c44b59139a8)

## Metric Regressions (compared to v6.6.74-44-g2c44b59139a8)

## Test Fixes (compared to v6.6.74-44-g2c44b59139a8)

## Metric Fixes (compared to v6.6.74-44-g2c44b59139a8)

## Test result summary
total: 71538, pass: 42664, fail: 17801, skip: 10732, xfail: 341

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 46 total, 44 passed, 2 failed
* i386: 31 total, 28 passed, 3 failed
* mips: 30 total, 25 passed, 5 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 36 total, 32 passed, 4 failed
* riscv: 23 total, 22 passed, 1 failed
* s390: 18 total, 14 passed, 4 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 9 total, 8 passed, 1 failed
* x86_64: 38 total, 37 passed, 1 failed

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
* kselftest-ipc
* kselftest-kcmp
* kselftest-kvm
* kselftest-membarrier
* kselftest-memfd
* kselftest-mincore
* kselftest-mqueue
* kselftest-net
* kselftest-net-mptcp
* kselftest-openat2
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
