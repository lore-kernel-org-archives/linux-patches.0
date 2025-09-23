Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7461F4297
	for <patches@lists.linux.dev>; Tue, 23 Sep 2025 06:54:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758610446; cv=none; b=f/Ba6sVvaRYyfvg+p5LjzgpUwV/SDgXVa8Du4X1O3gTzgKWrTUG/dl2uqCM+BPH4IvLKB6HVB0feUiR7udl5SBvI9z9KZ/uHe60xN9bNWMTcRki1fmzrRfFOCslXcxMLQ0YrfNh8yDirBoKa2223B4Fb8MIjAsxwBWERUiTk6yU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758610446; c=relaxed/simple;
	bh=PecQcC4+BQ71O05AhvWFsvUVyIVtp/6jKO4vNBvVtow=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EoaD36wsyXOmBLFOvdV+HU2lj5eoW3qxbw9Pf/LfPbncj231TZh3n8dyNxeY7SQUZDAABy0hMBtSL7A1BF9B5OZm2tWplxxy3pDaaFIeyO0RtvJe5lyYtw2zaOEoEv1BsOFEfs3k26GrZf7WpwcN3gbWlEPiSBCF6hoHXnYvzGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tjJm8LeK; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tjJm8LeK"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-27d4d6b7ab5so3772855ad.2
        for <patches@lists.linux.dev>; Mon, 22 Sep 2025 23:54:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1758610444; x=1759215244; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=quv8k6pC8nE0ORHmfxh5FwNCkCgEWH1STYAQdnqAQ6g=;
        b=tjJm8LeK1rTr+VvOz5Vx8TnlQK9dEnVgN4pRQ4HjSlHV6d2g7+d34SBOoEWitFB3SE
         Bj651TDJ+m2XWfXNczRLQ8d84RMyRMhyyGgVRZhjCuyetCRZriYLMOW/CnwQvdxIBW09
         O3xRrsgENbz1qnhpD803O36omtssQcXUhV/o+a0zYe9OezXSuf/2rre2HvzDK1++8hLa
         nz8G46WsXECCL7pQR8OdHS5WdYCMa42RZ03FJsnxrXEIWdexzcT8q9He47lyDI4TQhH4
         idXyVD2LH6vhn+143I88ueavMThBe1t/ysMwx73JhfO3ofSogKMcagXSg6jVRaQvQUsl
         gr0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758610444; x=1759215244;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=quv8k6pC8nE0ORHmfxh5FwNCkCgEWH1STYAQdnqAQ6g=;
        b=barD771whwbxCK6cslTEP1yWEZmsmZLsAE6wqBbGdzRAlb/2YORSQ6Y1pXLzx0Ab1l
         u4FhDqvW/mRc/knOFRbXzOSwEu2pSo4xKpj89s0ZZebjb+7IXZnLDQP7F2cJp4/IfLy2
         qRTjSHdjPfxzMHTe6cKlG8ZfbOs0wrcbSCdL/9AvdMnMnJ/doUbPKq834hziyg8fJXkq
         /Unp7/mfAMUiAh1SBnLXQi/40JALirXcygFYeng7U9hYq5ywBkMcgn/2vNqzT8TaVKHJ
         aTgkqn7ifUHO6598h606x6uwH7fGgwKU9J7jtGDb7g/XFba/EE4g1nSN0OIeV8R2NZdU
         lATA==
X-Forwarded-Encrypted: i=1; AJvYcCVo/rEOw6gA74kC1bKshu4WehhvyB4nN+YWnGeMntzBbjmKg+FTFG6JiWBA0SXbB+6bbBeIs3VP@lists.linux.dev
X-Gm-Message-State: AOJu0YydKLQh/L78Hovk92aK+N3X7Jf5yU2Ubu7XpQCxmMzYKt4A/pRb
	0c7CPAXxGmylV4g5WrzM0W9FcY5ydZA0y1chYnhhm+Ewo5uQwNNtXrzJtrWuoXnDPkPzRJ/ntqm
	kKvrFQFnuEPsluFQL4NQYdrSG5AkJOU6k94QGbRZ+eDlpPgkULuC/QetSXg==
X-Gm-Gg: ASbGncuvvX0H+FDIdVEojd5m094zTTjH0qN2tN5HSqxo3HCNPc6XORnraRXgDdyR8gG
	9JUiNXWo+0aFzIY4igJXja7zk40L/I8rP9z0QVGe3CkgsAIjI//u9CtgHY/Zh6njikV+U0P77zl
	2q/Cp7W4t/pt48N/EXML9td9+6qaQPc+sJhdZZMBrf1LP9qj8eiJt31LpS2iBijt2TC6Dzc0yvM
	8Tyykrxhwn21bToJiBkjML1/fwq/yjduJsq1iXi
X-Google-Smtp-Source: AGHT+IFZS84i47apfj07NDSNB5OlTx6jsX675G3VHWBcxqxxMy1Hh3VbasuQ4IRSHg/XZUTRQHb9JUEfx8v0gq96qyA=
X-Received: by 2002:a17:903:46cd:b0:24d:f9f:de8f with SMTP id
 d9443c01a7336-27cc21f8272mr23361255ad.17.1758610443986; Mon, 22 Sep 2025
 23:54:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250922192404.455120315@linuxfoundation.org>
In-Reply-To: <20250922192404.455120315@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 23 Sep 2025 12:23:52 +0530
X-Gm-Features: AS18NWA_NdAUcwHvfO7RUgz8JOg6_pm8wUdc7xt68AD3PFrIDqYjdPrecl-sjG0
Message-ID: <CA+G9fYuAtATgt4RLzPnVUeyK+4Xdu3u0GPUYqAQSH-904eFwSw@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/70] 6.6.108-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Sept 2025 at 01:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.108 release.
> There are 70 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.108-rc1.gz
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
* kernel: 6.6.108-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 6bd7f2a12b28f0583cde5d70941e17ef05e62d17
* git describe: v6.6.107-71-g6bd7f2a12b28
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
07-71-g6bd7f2a12b28

## Test Regressions (compared to v6.6.105-110-g08094cf55442)

## Metric Regressions (compared to v6.6.105-110-g08094cf55442)

## Test Fixes (compared to v6.6.105-110-g08094cf55442)

## Metric Fixes (compared to v6.6.105-110-g08094cf55442)

## Test result summary
total: 279461, pass: 260568, fail: 5659, skip: 12881, xfail: 353

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 36 passed, 1 failed

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

--
Linaro LKFT
https://lkft.linaro.org
