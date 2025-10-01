Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A210119DF5F
	for <patches@lists.linux.dev>; Wed,  1 Oct 2025 08:49:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759308575; cv=none; b=GgQlzVBa0n/7t4PjkyTy0cpz37TvR/P2wP0b8A+3vH4bOPGoFxFhLEHh+cRxsMY3FmKse6lxFKuq9AMc1JULc1fNe4V+M+rOm+YyayBBdYsFF216ggqUd/4CoxM4efSFeZ9VokJtX0eousAQ06ZtNdAIUQlcdHoajglWTh6+TcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759308575; c=relaxed/simple;
	bh=QRJ9liXxFkfG7M561OyeuFb7bBN/oesi5Tc/NH8DBeY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XbyuoHle1US2Zgy1hG8tlYQ+nk4YPVRshH4mx+SP+h6t0DilR8WBj2IrJwqTX3aAp9BBP+qPaLYxWAIeofKj8+CwM3KtUBRXo68JkMNe+F3+bhbOUDwtRzR7rMJp6SqnOfsSOlnyqRFRZAHoe1WlsXs2rHE6xkE/5gJDUwkEf34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=W6FX4J+/; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="W6FX4J+/"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-77f1f29a551so9257446b3a.3
        for <patches@lists.linux.dev>; Wed, 01 Oct 2025 01:49:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1759308573; x=1759913373; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5lUFEDOlwk0GibJmBfeInBIlGX8sUYIM/tZA+M7nygI=;
        b=W6FX4J+/KvGoDpV9+g8b6wDHwIs7pjZ4zoHtx4Jo7U2Esb3oK/027q4V5U3+OZFQ7+
         bx9w+k27hABcXmvnY6YG3qOWbAIvqbAa1XtamkLNsUkdTAORAEuI3lAvAOVgEAP3c782
         s/0yOuHc4rtrY21SUpPlfNX+r+adJG9AQduyc0Ez4doaiGF6DE0qz/5rBgey9GNbAJR7
         vorOQRfiF89mxFIiTvP/rPN8+XyuKXUg7Fcpv6yJfLdVm1sDgMkvNBTU+gAPuEwGkKj8
         sVee5kYqGTj85HENpDuRfWwJjwzR6NLskPy0+0BkJ1MSHlWo9lhXN0TdbzXyUVhxsJC3
         WrHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759308573; x=1759913373;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5lUFEDOlwk0GibJmBfeInBIlGX8sUYIM/tZA+M7nygI=;
        b=ilz4LKyxk1cF35uCsxmHVXDdAv355+DgoddX0+aYtryNhV7pwELUYnbaR9Mxp0n779
         Mz5idVX8RJbJK1EctjDYCc1uOEZJ36iMeg0hp6UpLzBIJ57BMvzjMuXssPwVzT1cflcA
         dMH13ongjRCR/216wH+wrC5hiaORilg+eQJtpjaIWOVq1omBylFT4I6M7Xv4ntdJrejN
         Q8Lb+1eJude1D3dj6nAXytgO8oUt/nwn9SIGzO0+N7hR8xG8RNUQ8A5i63+PL3Wm9khC
         dHG3cyHByi2VLu7Vg0rzuE6SSyB7/2LeSRBVAsSPg9cvPGQrojAQM6qbfc546QIQDh18
         ipgg==
X-Forwarded-Encrypted: i=1; AJvYcCWl2JvVggPBPCCMr6H+VCrhq3iJSPOhrPTAlBC1SKsqROUaKwtAFvHDmqt4DDqVHCXXyvuS8z5D@lists.linux.dev
X-Gm-Message-State: AOJu0YwLpXwt69Bn9/DqsLHXfjXn1FPLCl0GbfDKR3SM+4ROTJ794LeL
	yb2EJwKpz5Zztmdqh2UnEYnvzTkg3xEWzsV1Lt/s5iU34R64l+D1rl/mPQ4fnDkXJ6doqdiX+yD
	JC9GtLZuyeDiQLVDTkdnos13/gLOvUV7zzaQuvDyQqg==
X-Gm-Gg: ASbGncu177IC4d7ArPI+X44kWfKCgsEWbLVmTqp66uwto/JCZZkkimMUkNKGjPbfRf1
	L8Ix2jtwvNoNlvUIaHYltlm5aA8TzpP0wheBJkVo0EnLRdxY8D6RiSQ4nnrFwtlUfQTiCFi1MRf
	s8mrtDOi9bHE4WraxQOhPXxnLnR7RjVOeMAy6T4iL9vw3S7+jUXXks9Z+55lbXtGCVu10mfwo9o
	i2fgkudI0/hCjsQhmcj9XQTg+R6zgscMGk4KF9UsdtJXRJhweoa/pdR+4tt9KAMsZKGDr5OfaI6
	4lFv1IgUudnmxzO/gPteXfWJU3fXiek=
X-Google-Smtp-Source: AGHT+IHXdQvGj6eUadzCY2tlzRyfpnMGPewfjVo1faJS14ozece7Ob1BLBpJl8+EOXhQG2U/4x219HPYP7/eaFUDrEs=
X-Received: by 2002:a17:903:b85:b0:25d:5b09:a201 with SMTP id
 d9443c01a7336-28e7f2c6207mr36488825ad.27.1759308572985; Wed, 01 Oct 2025
 01:49:32 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250930143831.236060637@linuxfoundation.org>
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 1 Oct 2025 14:19:21 +0530
X-Gm-Features: AS18NWCvl1H8hhR2E11ihfNR1mldgcGLnS6MK4rJ4AfPqydTb0hfPaefWVGOAA0
Message-ID: <CA+G9fYvN7QxsZqQhHKqw-K4kn=rby4HmEyn=zhN-M_7uk=qLKA@mail.gmail.com>
Subject: Re: [PATCH 6.16 000/143] 6.16.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 30 Sept 2025 at 20:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.16.10 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 Oct 2025 14:37:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.16.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.16.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.16.10-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: e1acc616e91adfbab433eb599e00d88f0bcdb07f
* git describe: v6.16.9-144-ge1acc616e91a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.16.y/build/v6.16=
.9-144-ge1acc616e91a

## Test Regressions (compared to v6.16.8-150-gfef8d1e3eca6)

## Metric Regressions (compared to v6.16.8-150-gfef8d1e3eca6)

## Test Fixes (compared to v6.16.8-150-gfef8d1e3eca6)

## Metric Fixes (compared to v6.16.8-150-gfef8d1e3eca6)

## Test result summary
total: 351365, pass: 323894, fail: 6740, skip: 20731, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 138 passed, 1 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 27 passed, 7 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 47 passed, 2 failed

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
