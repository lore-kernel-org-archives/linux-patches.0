Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F02C2F60B3
	for <patches@lists.linux.dev>; Wed, 27 Aug 2025 09:30:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756287041; cv=none; b=td4NndSklv8LNqxMfiJCUWNV26ejsmi7uvsODy5PbrCElZPIaVWAXHEGD6TI8QQxqujqIGjODaVcTlyEsbhKwNWAgxalxmqIsLQqj43iwp75c4tEkK+Di+9nS5yuuhxXgVq6DnmRxGqh/VLR0S5GKxTQ0CSj9O9cDi8lmHhcphU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756287041; c=relaxed/simple;
	bh=tdG6lwDqbuZN/AVud6hb++JrEIXzuwXpSeTEcSPRwQs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=b0Xv8FEtp2muOjAY8SqoQkLzoauOQLTB9/SwkyeZ8TROVA0ed95rIibP0GRGeGAgFjkmovLIDFHdoAS3GIeuBhHqXNwV4q12Z2G5nA2ZUIfEmD444jscGq1m4p4xBxGJtKY9YiR5wIxXTo90ZThmyxzLlghPXRm2JUkWist8JPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=G1FLVl6N; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="G1FLVl6N"
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-70d9b07e163so13160826d6.2
        for <patches@lists.linux.dev>; Wed, 27 Aug 2025 02:30:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756287038; x=1756891838; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=p00Dt79OtqQoegFZ5bdUUNG94Edo0Rx/ZyhTvrQlI1M=;
        b=G1FLVl6N73eZmelzqxg1sb1Swjzh/i9ZJtTvL7d1ZBsVQ9TjwlLfVFIJzKNJ83Bvjq
         6HA7yPBdgb4MoUcw3RYU0aB2S/Kl/SKSwuAZYb2RSZoJaLnWFoYGfiWNNkhvJypoFSuL
         WWjre7FNTh49BvEb6SkILXnAQzYXIC7RmYT3Hk5yiSP22Cuby8cFh/qPvbZjr8fWD5Tw
         htzPEIi4AJMWM4/48ySRcSpMwoXQa2SE6vIozPMFcKC++62cTkLMx1uB+wxXJmiXXF3Q
         hgxbvBQWWT2LMIEp2nwXX+885zYdfajmFHlTIdOsI970oL9grC95nEOV+sZOymDm9lVD
         6WHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756287038; x=1756891838;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p00Dt79OtqQoegFZ5bdUUNG94Edo0Rx/ZyhTvrQlI1M=;
        b=IYybCZMN/Ho6c79hO9he+VmkEE6L9JiDCJ8L2EnPoz5rbz9lGYPhvBbzJI6tJekB+a
         TS5fTUSraSbVbGfv2YqRQOQZBlUewwCS8soe7gKWAALhvORH+Dipd6BU91rwIdXEUa8C
         r02ujogS88zHgCmPHGD71udSbXRYURI3OCIFH+RQqxHyaqfrMXNuvHp6mXhGVCvDyu3Y
         c+GY4OXig9mRB70PevvMxNbJ+j+49Y8AwOxEo7+43/9Zrv3cvmOAOhZo3J+QAh6TTWQQ
         wI1odi1wLRlBQlR5KeNI9SPnHiK6krBU6Sa/PXG9/jkP3wzu0Pj08Dj3wDjM8v7IZsL+
         SwcA==
X-Forwarded-Encrypted: i=1; AJvYcCUW2PtrvaeQLng35F/SlMv8XLSS1toM3j4FVujlXCZphTLXLTtWzhorFeG2ZKD+TFkwVlNrw+k8@lists.linux.dev
X-Gm-Message-State: AOJu0Yyj6ivkBaNJj0BNhVyHQQXXE76D024edvmxI7g7/NO9n1ELKMJt
	65Noidsu72ycOh1wPn7prp7NWzJv+6KcaxEgtoU0qzWcKJDe4/f5a6Nrn4t+1b4ysrVg80my8lQ
	noc6n64S+1aKgNgCYMivj0vc3Py0iPC/dYo8exg+oZw==
X-Gm-Gg: ASbGncsatIdPHqx2GDHUzEHwzrSNXiUWMTSrpjBthlE5FOZ9Is9b8YrpNHTtOKzoADk
	a+2L1yYhv4yeGgf0AjziKevIwRx1E5+spAxXuGuUgszwAS1IW8Df4buL7DnO9ykfTtJFytg+cfo
	OKxfDrHXCzTSB8ljwdySAkS6GpJg0Az/0x1KZ/QMnjDDyiik8eEQruASKMdwAzc6jcN6wOGW3Jc
	ryUqP2n3fEWZzs1
X-Google-Smtp-Source: AGHT+IEwdIexP0HA2vYtTuFG+cmWr0/asWhdvS54qUEB5cX1KpPDhRdmpS66B3nEu6uVhib5L2CvrhCMss7o7yDziw4=
X-Received: by 2002:a05:6214:3003:b0:70d:c054:9320 with SMTP id
 6a1803df08f44-70dc054964bmr76720416d6.3.1756287038013; Wed, 27 Aug 2025
 02:30:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250826110915.169062587@linuxfoundation.org>
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Wed, 27 Aug 2025 11:30:26 +0200
X-Gm-Features: Ac12FXxJh0tPtMslPn4Ikgd1vLpYMc-s1M_Anx8mniQakPdgUznCnVh2ZgFl6zs
Message-ID: <CADYN=9JmvSQOxp7TtLj1UgrYQzb2k8tLz_V2sN7OS4wNLVG_Qg@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/322] 6.12.44-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 26 Aug 2025 at 13:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.44 release.
> There are 322 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Aug 2025 11:08:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.44-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


## Build
* kernel: 6.12.44-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: c7e1bbb3520545aac86b8bcdb924cd3a7d200bc8
* git describe: v6.12.43-323-gc7e1bbb35205
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.43-323-gc7e1bbb35205

## Test Regressions (compared to v6.12.41-808-ge80021fb2304)

## Metric Regressions (compared to v6.12.41-808-ge80021fb2304)

## Test Fixes (compared to v6.12.41-808-ge80021fb2304)

## Metric Fixes (compared to v6.12.41-808-ge80021fb2304)

## Test result summary
total: 333492, pass: 308486, fail: 6580, skip: 17877, xfail: 549

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 22 passed, 3 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 48 passed, 1 failed

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
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* modules
* perf
* rcutorture
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
