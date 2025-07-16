Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 077F02727E1
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 09:31:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752658306; cv=none; b=Sj8VQ4Rfie+NxV+gs+sVdDQ0+yWjEr+0hWbdxN5PKvkcdaEcrZlFAE7BKI2KXksTgbtLwoVTA+Qs/SjOYKinMe3P7Ch3Eo61AAYev/dRfWdbB8G3Hn0W1driMMNK9UFdGu7W2/+8ZFuSuVo0GqGEvfL/gtx0mZsjlwVK0zdXAxA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752658306; c=relaxed/simple;
	bh=LnZtHSBOfuaGiA0+J2QyiVh2FhpEgdY39u4ISd39VwQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TZ0AXf0dckaLnNQf0omGXtgpXP7d8ybCFZvvaZ7y9l7MD9R7iQE1F+GUappXHLOWZj2LEuG1us576sO9gZwg6du2JcJt7NNXubT+oORe1LARFGWV+LPImwWAewm1UrqFJHzExm8ggQTWRQEaQD+hn3QEnHut9zupbhRFCrzstbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rEFaNsbL; arc=none smtp.client-ip=209.85.216.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rEFaNsbL"
Received: by mail-pj1-f46.google.com with SMTP id 98e67ed59e1d1-31c38e75dafso5363922a91.2
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 02:31:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752658304; x=1753263104; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4/TD0xwgjUcH0nigdFj6tR511cNw2GjnqML50p5eZPI=;
        b=rEFaNsbLIgW87iIzCtGPFUTBivi5sU46bHNfJfJVlPQDDDxm9iGr4pIgD+gYWH1Z2C
         H7Y5jfTWKT4Vi761dVwypnCPp48btWL5D+ipMkesK1xGZlE9NjEMc1Q6hCfuUaTKQRLE
         RE2uw9/7EpACnvYS6l76gbQEBqDc4UJTsC5OcKAq0+AMHOU7LyvxVBp7LTQr0oR4U6CJ
         rvCzCOBzcLQL4KC0G/g1InvxxACoARTQ61pvpR2sUcGpG+BjC5P5GprEbH+7QZeNZqHR
         Lp2RCKK1CstiLw8LPrzyCnJKJOxHj/M6xhcFyvKFB+NPUFMxFWiKNqUD01VUe7RfiIPn
         UxDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752658304; x=1753263104;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4/TD0xwgjUcH0nigdFj6tR511cNw2GjnqML50p5eZPI=;
        b=iet9Drnntmkro/Is2g5RYg7osKP33nnWY+SOcCXDfdA8+uJQB3iXx/NwdCrj238R3u
         IAhuO8e0Sfzy16VT1/MY3YMsFjMQt/tmv3iz2ujxgxRVz1sV/rywFa3ZJsfk00eF/Rvr
         TORpZM2O95Qm5bpxEPZHqZHElBo8GExYgWFPiCj1yzygpXFTZstVxXRBdQeFIQrgALFP
         vBonvFNbrXSUypXxgeMw4LdqC58PrMZYPN7Fs2e5dKptCSaKhTjre0I1NbY9RQ+MGOTe
         fvWyplEpwzVBQkXf/mzqAHJrQk49IU2JhnBryFA3jLhvlZXyLqAfGpuhVS3r3ZxnXym4
         2gjA==
X-Forwarded-Encrypted: i=1; AJvYcCWgVjhkq0DzHmT0IiJ+4NTR7ahmNOLRESVTInsybFrShwp40mRl6RuaKLhLobuSHvUfcivv2pn3@lists.linux.dev
X-Gm-Message-State: AOJu0YzZtqWNQfnhXVxT/2nWt7d5tGujdjzcXKAm49OVTzuITHFiyn7H
	nETzsfdxPklKuRutnl2CKA1ULrbHjjXd4inOs3ANaRKiI7NEk4Oq2AlXYjGm/9kzEG6PsXTP+7m
	5etlTe7bmsqrea4YFvP7qKMNNR3CQh8IxOJpa8Fex/w==
X-Gm-Gg: ASbGnctl/bsMM3Z7HTEhMxHWIi9ShLfS7bZylA5b97sVDSBj8p0Psf+PVuk9Eynfjaw
	wIW05mCQCDowt5Mj0W1yndwr8SyhDmeUwIfrBWL4LOZwYO5Qbh6cWPsHbYWxEAkZ9rYuPZ/plQO
	A9Gs+BEtX1RWJMwe3jhKYaTHMbFkcMa0dSJYg3XJ8kg7YGO3QthRwW50AFQhRt1yLJTjHtpG55h
	XJMpmGhxYx+1PXr9PI1jj2rRJAq9BRQSsJRrWPHP8WFXziy6sY=
X-Google-Smtp-Source: AGHT+IHHFBG42P6rU2Vz5RaFMP1ftBXPkAZqxVb12Un6mixuudNNh6AfVCr8p4OgBQ3GuE5bUiVIkw221QpnXt/jYX8=
X-Received: by 2002:a17:90b:5385:b0:31a:bc78:7fe1 with SMTP id
 98e67ed59e1d1-31c9f42ea51mr3362243a91.18.1752658304194; Wed, 16 Jul 2025
 02:31:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715130814.854109770@linuxfoundation.org>
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 16 Jul 2025 15:01:32 +0530
X-Gm-Features: Ac12FXxSgVANGsV-qZo2T8nhVt654kQHynZ9ySnyMDGf6j4ZzdPO2yGy7ih9qPU
Message-ID: <CA+G9fYvV0sx8g83QVOzjBhoZ77fyBWJfmLte-voa=AgLY7K4nw@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/192] 6.15.7-rc1 review
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

On Tue, 15 Jul 2025 at 19:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.7 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.7-rc1.gz
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
* kernel: 6.15.7-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: e6001d5f79448ece8e204c0df46072a010b00f6c
* git describe: v6.15.6-193-ge6001d5f7944
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.15.y/build/v6.15=
.6-193-ge6001d5f7944

## Test Regressions (compared to v6.15.5-179-gb283c37b8f14)

## Metric Regressions (compared to v6.15.5-179-gb283c37b8f14)

## Test Fixes (compared to v6.15.5-179-gb283c37b8f14)

## Metric Fixes (compared to v6.15.5-179-gb283c37b8f14)

## Test result summary
total: 306856, pass: 279725, fail: 7552, skip: 19579, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 138 passed, 1 failed
* arm64: 57 total, 56 passed, 0 failed, 1 skipped
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 27 passed, 7 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
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
