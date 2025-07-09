Received: from mail-pf1-f170.google.com (mail-pf1-f170.google.com [209.85.210.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C51B12367AF
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 18:20:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752085261; cv=none; b=kAFl9hFsQdXZKSWMHDRx5ZVV30fmBseJ8r3hlEkGi9d4zDu8tlzJ0TKarTKyE+Bdu9Toeg+pXsQNPHwT4H3jQOuBaiuXKw35JEkR8LERdXCXC3nNlAlKR1AjbTccN1BBLek0V5nRQXGx9Vz5iqUDqwGqcS2rHed5fqVp54ttx0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752085261; c=relaxed/simple;
	bh=p/dryZ6QebmaRczj3TL88LA+dB1lAU1RoZmnGtOYz/w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EpDoYO5QBkkWuaanyaUkI0OV096awP7dxCQWaYx1maI7C4Z76CcLiWS58Z5B10pCInwd4Qn91PpwrKoUooiVsr8pafMN6688eXuq2ksbV3pKbAkzhshCoDrX8Srdu86URXjP8Omazq8QQ5tD9FV7jOr6C71GcVX/pxWJjEbdIy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NFpA8/Mt; arc=none smtp.client-ip=209.85.210.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NFpA8/Mt"
Received: by mail-pf1-f170.google.com with SMTP id d2e1a72fcca58-74b56b1d301so124905b3a.1
        for <patches@lists.linux.dev>; Wed, 09 Jul 2025 11:20:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752085259; x=1752690059; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cfJ8WRoLWUtG9c45B73F5HHWKfasYMw8IzOoWgo2CnQ=;
        b=NFpA8/Mtu0s+POaWAriZCN6ccurS5Clv5ltDzM7lFpfr8K8S8ojTncRDP8kdlTUYeC
         zOMTYbRWmAEWqvqHwAJCphzTpgg7MGAZusoIUlfgctH0brftOkMO8TY9hp0WCo2slQOs
         rbVFajAOf+9Davvn+X29y8VPvfP7zqLf9h8oOrhdn6Jnp5jlZH1FnSdJpP7jCK1XlmOZ
         NDwTJ+xdXGSuNKaxs3EydQll7uBPZwDtU6squBNK773QG0BkPLLKaYLbh96liddoEpCe
         VR/5l6RltpLXqRsZWkmbAAAMzTmOsmmKz7UQDu70s6mexI8+D3WcYpN0adYCrH0Jb/lV
         bgKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752085259; x=1752690059;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cfJ8WRoLWUtG9c45B73F5HHWKfasYMw8IzOoWgo2CnQ=;
        b=Bk8mwvMm9iJOWFHpnlOxUhQegoD0sI7Mj75RpXGr9BjqCdTyjlsNGKMXs0nTDhYhvI
         frUN9jHcHdqhgc5sa6AY3Ba5mdNEN3x5FAqbCqbH+Jg4kijtbt9yNgOAqDgJUD14TNQS
         wE4nWcQpGMzvNl1hq0v+m8cJE+n43mrRkMJ9CgGn5KaPe5iyS3J9pL5S9NmdJ4LjzvDA
         d0uglhkhqd/7ow5mapR2eemD1VVEjxiVJ4FZjOvyBu1hNjhuhMomBR1EnbtswtGzBLx4
         NL/ITaC4wfQxD8IO06OHOwDBhp0Tbni3C9KS101XOsNt953A4RBpwvdSC4bUVz1s28nr
         XEfg==
X-Forwarded-Encrypted: i=1; AJvYcCUf6n6SvOL+/+zc1kROx5xhrEpFDgqldfQMTZ8I5tSdr6fz0tXCECd5/CV0A5X3vQ22r9v/7113@lists.linux.dev
X-Gm-Message-State: AOJu0YwwZeP+eC3tnljFzsVH6UWK0+17fpVJFUr9JUiXwOOpH8Jvaiqd
	Lhz4BpUkPAsjMzsKV2Um1hgP1st07Gzk+umgjDV3RLusgEBt84y4xmAVjiuO8tfNdx4y2sS9/sK
	gqfu45RdMKZA3mGPOw/qoxIgn3IhtxZpGWgzilDHyUw==
X-Gm-Gg: ASbGncth0hzdQ0dLYksu4cKnfPd8+Gu4dZiPPxTbnsZOpK8QKkl+TMg0hzh7JT53RuL
	YH249aathG7xk7RVC43f3l+z3qeNwg8pcswy8jti5trougURloeinBNGXreue7liIorg3Lb7nBH
	pSi4XvUWZ0LZfmPdma/J6VHEX6FMMPJAsGTZLdjIC+0tLTCf4ZXbw+jqHttKKVTxGRoTL5QwBO6
	oZ/
X-Google-Smtp-Source: AGHT+IExtmaIL44BvbpJdzDSJVsuTq7I6JM0TtX20i4Aie0oZ22OIY5PQzXS82OR66MKRFgXdL2GskM0SUmBd4l2sOU=
X-Received: by 2002:a17:90b:55d0:b0:31c:3c45:87c with SMTP id
 98e67ed59e1d1-31c3c45088cmr1108278a91.13.1752085257282; Wed, 09 Jul 2025
 11:20:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250708162236.549307806@linuxfoundation.org>
In-Reply-To: <20250708162236.549307806@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 9 Jul 2025 23:50:45 +0530
X-Gm-Features: Ac12FXxsOjG8FsT_QU-sc7atBK_FHtnYoeDJkzlyKoxOjVhpVN_VdRKDkXaICsc
Message-ID: <CA+G9fYsxQLykV7qgHoLRz2xnGrYzoFEbSKM1Nm4m9q5EVeSnig@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/178] 6.15.6-rc1 review
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

On Tue, 8 Jul 2025 at 21:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.6 release.
> There are 178 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Jul 2025 16:22:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.15.6-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: b283c37b8f144465ae3c78397ae2e9414ca53288
* git describe: v6.15.5-179-gb283c37b8f14
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.15.y/build/v6.15=
.5-179-gb283c37b8f14

## Test Regressions (compared to v6.15.4-264-gf6977c36decb)

## Metric Regressions (compared to v6.15.4-264-gf6977c36decb)

## Test Fixes (compared to v6.15.4-264-gf6977c36decb)

## Metric Fixes (compared to v6.15.4-264-gf6977c36decb)

## Test result summary
total: 339648, pass: 311820, fail: 7773, skip: 20055, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 138 passed, 1 failed
* arm64: 57 total, 54 passed, 0 failed, 3 skipped
* i386: 18 total, 17 passed, 0 failed, 1 skipped
* mips: 34 total, 26 passed, 7 failed, 1 skipped
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 24 passed, 0 failed, 1 skipped
* s390: 22 total, 22 passed, 0 failed
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
