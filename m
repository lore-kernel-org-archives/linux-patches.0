Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF9020E00E
	for <patches@lists.linux.dev>; Fri,  7 Mar 2025 11:53:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741348416; cv=none; b=T8+No94OcFFqm4XY3fGAj+CIZV9sgW6hUdtpqXNeC9ScOt2ViMcwut7srS5Pbfi8NMYVjdZO6wKtrAMcavRbuTgT3NSPsGacR7I+1yDTH4cnwOj/stHW79dovcHo7ged5R0FDDHt073kDIUlruof7qNh1Z5E/bWgED6OaUTayjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741348416; c=relaxed/simple;
	bh=xE747tlTQLAxgh8NtAjUgxI+rHa9+PyveNJeB4853TU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qwh9VpBGgZS7cdY5UH8TvQM83V205OERbj9zmsWwbn572VM1bwzNTBir7LHBrH8+SnH+QhyR8uQslQKxrJWnRNdZv9IykZVFuUtSBMiyfgNkajn79G8WNIyG88bj97QFtLpZnWKYnKa3T6FnPXyMW11+Cb/xcoY31SlD3eTiYhM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EJg4Z3AX; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EJg4Z3AX"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-86d2fba8647so1584400241.0
        for <patches@lists.linux.dev>; Fri, 07 Mar 2025 03:53:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741348412; x=1741953212; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0WD9jmJaU5i8Pw2RiIsBAgARfcboGYACiY1rTXf4iik=;
        b=EJg4Z3AXq0knNXm93sfu8V6Ga9JI9ObYaeQMnzPkf1vNrAqOhuUws//W6jc73tgS7G
         +zxprRZc9Lkz5nYiKotuzu1tmawrSi87SWWV5lWdRK57kpOcEh4cjSiK0SEFnQZjfLcS
         WLZpcoAts9xVD01U+RzKlOviHMJM7diyVYfFBA0X2Q+MMk6kJ+XTmcWWST61ySewfCNQ
         eIeWFLmnbQG6dmQSK04LmG4iyN2uDqEieMPm6Kt7/o3wGWF1ASpnqPNsi4BLe07R/Df6
         andtfO7TynuxqKWzKtv/Q9XSUQSHt3NYxvZgZ6P81c0sKOptvKJrWQrHw3ZHID6SQe3X
         wX1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741348412; x=1741953212;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0WD9jmJaU5i8Pw2RiIsBAgARfcboGYACiY1rTXf4iik=;
        b=Q6elXF0raAf0jARjh7XBUngq0mKTIG4b00VZ+0Bsb6CPUNXoM2/WYzio9kLbiul6Rl
         bWysV5HTJtNQ0BGNI7wp7awFCwm3ZHyshswQgZVFu6XRgmtp9ucYn9E29GnQIvmDRl4h
         x/qwhOXkqQqILcjFDoB1Uhc+luYttWmXA91IkYr+X22T+d7y7quL+DN6D0+cIfOlck7M
         Lz3oc7qmSrgBYDrsvNUVuvzDk5+EJ+e7i1K+zWbjTiIFyHFWWJqJ05S9pJRZF1u7Hluk
         bn2I5BWl99dKoTASdW0t22kPNuJP+dPfKGI6Q5nCSOuTDv8Qkor6Se+aaQ+XaN3aQtTW
         yjWA==
X-Forwarded-Encrypted: i=1; AJvYcCViXj+RUelAWEGZQcYxxhAIlpIktL8R1cN+tff9WOSXEszW5inuR5ftcaFcLKMh1mLxYrTc5Hh4@lists.linux.dev
X-Gm-Message-State: AOJu0Yy19J6uxbe2hHw4rG9K2rdaerHoIV9fizomqDo4iDqZDqnx4AGM
	lPnZTW62kKYHhbq2U5O/AcSwR5yngxUhIM93PXc38aNUwclugeqZg+UoYATMZ0TeJfqgGd71Hai
	tHlip9zN/gItk1csmiWNN4OWkNaaLiYsXfyZ+utpmHEhgSI7AAaw=
X-Gm-Gg: ASbGncuSSG28YpZK8P24WqRZyUS9LIUfc0xJ5OTsfHy+cfReuFMtLxMmS2IVlDAd5+8
	LuGQj1FTkYtImSkgaNVoIJXsewUfmPecf7wd1lb7Ob7m44GdznFA90VKiSkNKe7anCAtyZ/B01m
	TpouaHSN2rtmg7DapfiZ2TzregaUREBfb9Oj3kKReKPKHdP1V1WZgUAkHpCiI=
X-Google-Smtp-Source: AGHT+IEok70NVqqxgLDMVhU3m5iaGPJbZFbySmXavI+i0nsu6a0PolvKnH3i/MkXFm3c1wuurNezwxl6ZQGmpGANcr4=
X-Received: by 2002:a05:6102:3caa:b0:4c1:9b88:5c30 with SMTP id
 ada2fe7eead31-4c30a6ad49emr1719230137.19.1741348412369; Fri, 07 Mar 2025
 03:53:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250306151414.484343862@linuxfoundation.org>
In-Reply-To: <20250306151414.484343862@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 7 Mar 2025 17:23:20 +0530
X-Gm-Features: AQ5f1Joffh2sqUY2oqDqeKH0v9gxxZrKALDccy4nN82WMvdcgJzBgWa4l53hDcE
Message-ID: <CA+G9fYsOasubSbr1G3p=zu7vVGSCacEK-fJteJFSK_3NXUddkA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/161] 6.1.130-rc2 review
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

On Thu, 6 Mar 2025 at 20:50, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.130 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.130-rc2.gz
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
* kernel: 6.1.130-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 029e90ee47c2263f170d2a45370a7785d00ca34f
* git describe: v6.1.128-732-g029e90ee47c2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
28-732-g029e90ee47c2

## Test Regressions (compared to v6.1.128-570-gfdd3f50c8e3e)

## Metric Regressions (compared to v6.1.128-570-gfdd3f50c8e3e)

## Test Fixes (compared to v6.1.128-570-gfdd3f50c8e3e)

## Metric Fixes (compared to v6.1.128-570-gfdd3f50c8e3e)

## Test result summary
total: 103810, pass: 80922, fail: 3936, skip: 18501, xfail: 451

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 139 total, 139 passed, 0 failed
* arm64: 46 total, 42 passed, 4 failed
* i386: 31 total, 25 passed, 6 failed
* mips: 30 total, 25 passed, 5 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 36 total, 33 passed, 3 failed
* riscv: 14 total, 13 passed, 1 failed
* s390: 18 total, 15 passed, 3 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 9 total, 8 passed, 1 failed
* x86_64: 38 total, 34 passed, 4 failed

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
