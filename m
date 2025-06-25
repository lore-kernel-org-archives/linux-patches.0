Received: from mail-pg1-f173.google.com (mail-pg1-f173.google.com [209.85.215.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D4B29AAEC
	for <patches@lists.linux.dev>; Wed, 25 Jun 2025 10:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750847001; cv=none; b=RKVaj/ddO2IlddT7SiyA+B7JWW5+n5VIeOJzVI32nppHWz8CvASS1Ho+HiVW5qd08toXFg5eRtsCdJ/RJg/0ct/XwYnEt7SLN12KIGVWTfIN7Y/nhND2B/Zn/6Cm2OQyWXK6EwBy2+kctwF9dqKGwQ4n0QMIcoXs7W4rporNizM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750847001; c=relaxed/simple;
	bh=sLOlO6Ct98dqJEhk/xCShrWRV5yesUPYrAQDpxALhR8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tDmDc2oCA3vCP3e/cQjDP2prfNKYmm/fjzYt5k3fQkzSeotstDU/dRbw9UDMbigw2jMuWPejEH8LfEVWg6WIqx2y/dcy3YCxLmHbEWbt0inyp0M+31UAl2k3wL98wmGr+yVAWt3LEkAqDvhX50NMnz/qU/mu26R7IA8AIr6EuTQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=IY9vWzvF; arc=none smtp.client-ip=209.85.215.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="IY9vWzvF"
Received: by mail-pg1-f173.google.com with SMTP id 41be03b00d2f7-b3182c6d03bso1862952a12.0
        for <patches@lists.linux.dev>; Wed, 25 Jun 2025 03:23:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1750846998; x=1751451798; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lov9+Zjt7YEZlzXRaxLC1dZ0shHTHM8AduhB9Li5azE=;
        b=IY9vWzvFtRbF5peJNJkAewkLwJQ7Mt3fStKQf37Oo53A8JOKSZnIyf9CH/s+EtLxbl
         4oGJRMRPqEU9WW8NrmWGiYOewRNgJkj78BL8Oh4Son8PVCJHoA0kXiyLdBYvEf93rzJs
         IKZ6VpkRGPBWOO1f08cgEVY7fp0ZeNA3ogISTXwOEyKiLbW3rB8eFwY2hGAOIqkLUhGK
         4V4Ew66p7175M95thx6iR2lulM2cfP/evkiw4kHCDkOj9VmFmGCFo+ZPGXSHIApZ1teW
         ry7dMdAk7v/7boG925pjAIda60nUah5y/wFtDwex61tFsFku1hCzh1UVnqNgFAJR2vyM
         v55w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750846998; x=1751451798;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lov9+Zjt7YEZlzXRaxLC1dZ0shHTHM8AduhB9Li5azE=;
        b=GGD1/DwaULPe6Pp58z30qX/dQazYMHpEXuscI604nn7saBdVkivxvNumm/Q1XV9cM5
         pazZlRCi0DuknnotzZMnZRuIf+6mJRe0KEoTV/0a795dQdgZvUPRP/1W7qGwbYhsw3rt
         auJdcmwvqACXnVJtCnuYv3L6a+u7ZwA8H/omztY8LPjPj8BSZvaahppAqzTdGLhogKuo
         jmkeud6RrmMlrNEaPi9W+3vbyM2gB8jQ3Cpzc2JXSe47M7MTxSOM3H6q/7PjucqSvTVk
         erCjTytge7Z2JsnL4lCug3bG7tGf8EdV1ETyGspZY3RvXh1hMsPl0WjfhZGwGVtdvH5T
         UxEA==
X-Forwarded-Encrypted: i=1; AJvYcCWJr1svME33j5KQTOgmeNr4CYoSoK8J7NRyWH0VxK0tTxQgzHd1+6FAaRL+hC+YP97agcQGV6fb@lists.linux.dev
X-Gm-Message-State: AOJu0YywcWjGEqFHIIZt/ErM1Cc+oSAe4SH06syeiKYoY/bbEOf2Ecjk
	iCSKOT5qDHf1YYyhVCpEj31vC1cUR3vHmKq8xZbghWh9A3jKuPXx/Rk2Qg0cT9twViIA1484GT2
	baIga0dzuTIIZ7yN/eF+ENf7HeMiOIbaJVMoxp1tOLA==
X-Gm-Gg: ASbGncvpLXVp+HwSUtWeg7J+PnUg3E5RRWsER7getl76wWatlCpYyLpaXRzTGXMPTRa
	naPLbT82QWqDuM2swbfAJWy7c2SiPy41cqynaaFIgf6G8pMM8ljW9rXGDTD1dm9LB8in1W1KPQg
	H1j1mDNpTKAIECYx7S2f4kIKDHe9O8kX7GrLAuwBWyhcqJRXcA9zRvMIUyGIGy2hLwh9enMIN1A
	AhG
X-Google-Smtp-Source: AGHT+IH8cFi7RC794dO0rUm/Wn+Xr5iwFFDk6akyxaGbFcCJoypTD1oROTeezbQ4/XAXXAvVlHuTWvMZwirdDT+JzDc=
X-Received: by 2002:a17:90b:2c85:b0:30e:8c5d:8ed with SMTP id
 98e67ed59e1d1-315f2671f79mr3611427a91.19.1750846998623; Wed, 25 Jun 2025
 03:23:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250624121426.466976226@linuxfoundation.org>
In-Reply-To: <20250624121426.466976226@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 25 Jun 2025 15:53:07 +0530
X-Gm-Features: Ac12FXzbsG8H9f0gjBaNzcKx6GHqgVhEAS62P31OdpnQXr-HJ4E-WlndR7XAnXE
Message-ID: <CA+G9fYuQBPF6C1oJLWrrcjvn6FNqjh0oxcJqJNxe85XtrDNSjA@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/413] 6.12.35-rc2 review
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

On Tue, 24 Jun 2025 at 18:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.35 release.
> There are 413 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.35-rc2.gz
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
* kernel: 6.12.35-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 7ea56ae300ce5b67804c356ef4c7dbac6b00241b
* git describe: v6.12.34-414-g7ea56ae300ce
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.34-414-g7ea56ae300ce

## Test Regressions (compared to v6.12.32-538-g519e0647630e)

## Metric Regressions (compared to v6.12.32-538-g519e0647630e)

## Test Fixes (compared to v6.12.32-538-g519e0647630e)

## Metric Fixes (compared to v6.12.32-538-g519e0647630e)

## Test result summary
total: 218983, pass: 198252, fail: 5262, skip: 15116, xfail: 353

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 134 passed, 2 failed, 3 skipped
* arm64: 57 total, 46 passed, 0 failed, 11 skipped
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 21 passed, 2 failed, 2 skipped
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 49 passed, 0 failed

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
