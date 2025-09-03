Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCF22DF140
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 08:16:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756887382; cv=none; b=Kk66dy9hoFQP//Ulg49Bk/imMZfjqxEAgWS2sAIQb+Trl0qJmkMP8AWVm5RnuGHLmzA8BY+vhgLMJv13hrd1ckWeaYcEdVvmpXIeVjjv1ir0ttPwrAgU1pCS/OHchcVuVwuPl3khjrYDSz+QBVLwGM6TJ1tpxNLKCABagc84xTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756887382; c=relaxed/simple;
	bh=W7FUojUFnzxGTg8A+tqGW/iXc3ML/j8Xn4Q+Vbq/A34=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YFsWtr1Gz7dt+ZkeysVgOK+ve/0Lae5FRg6QApbAxOZv3phiLWTK3mpLChR2TCrpmfmqk/YRfqydDRJeO6CjxOahxKBeJsVOGymBpV0ZJB5FwodV6gvpO3DPREmhmA/cysX9+Lq8tas9u6V20dj67zFF4veQVBwIktcHaX1j0DY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AEOY1Jfc; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AEOY1Jfc"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-24c786130feso10326085ad.2
        for <patches@lists.linux.dev>; Wed, 03 Sep 2025 01:16:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756887380; x=1757492180; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kYJgan4idEGWGAUXtzh/kv+BKTRh2JOtbApGJr0y8I0=;
        b=AEOY1JfcC+8c1HVtTld0wFP7X9WofQCW1wkm7kRdA0bNsw8p1raBNpH/zv7sA+mNd+
         t776icBhpAzm6e0jIC/BwMir24l1U0dL0+q4quoDxOlSy3TGWcQ+Lp92ddbOw1qgfAca
         4cyt5JVZMpwh002SW3Eyfwqpn0xHJdy772jQtQbNMnst/cS2E5I30MO/JrhkdPZltXdQ
         Kybc8fku7T7i6BIlN82BwC0Io6CdC5x1RRVUIbBCw3ygHPoI6KFBVpf3tCFKuIBoPobq
         aFLRBqPcqLSr3xpkZS7okPfYPh3ID2JEBsa1BArLYwexUodkRXjecZGgjrLa7txfRClf
         OenA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756887380; x=1757492180;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kYJgan4idEGWGAUXtzh/kv+BKTRh2JOtbApGJr0y8I0=;
        b=K6PHGfn/8Z4ovTCeZVwxirLZXK1eJ1ZYKs8ERzouhQlnh7qm/EmuiQJioNHGUiFAUd
         kBcsVzVqufi/LINiSDHFwBSEsqKDBI6zdH6sDvDbpo37u4jTB7nQp4+E9FC5NSAkiFoU
         kfeZNdaxIGhGA620LXaWYjXarh6cJG1f8c9/SUcl3HCaRo1k3UKV1IsA/hC10oQf31Ds
         Xc7uKxGAvOPKL/ZKaPYHFGg7qRsPIuWIPOPXv/yZVv/GViBoHS5vLHbCyX+VgQSLVz8k
         U7Tz5fg2U/STLeICqLi29e88IpTTav4ZrfuCSo1hh6pnX7qim10lLIMaDPTbdOvTtiYP
         4rfg==
X-Forwarded-Encrypted: i=1; AJvYcCXAo6lqMwwys27kGToduT3MDr6aTwDC6yVhFfmFDCObluYr+hsLVk2IBJeXyE6QylCCKuWe+TuV@lists.linux.dev
X-Gm-Message-State: AOJu0Yw1d0GwS9UHdRP5ETUoCckshySyNtAPTM7d3aDWLemHdBNOT+dO
	euHUcuQpI3k66XM5tmiGz20YypbkOuoQi2VEqcAYFUHf/sdTTQGX2ipRgkfXGNPWuyKpqSN0uA9
	2dlJh6wwWZy7URk0Xzom4ARywNGVhskqmaeIx4O9gAcHGYLuX+oRgvIM=
X-Gm-Gg: ASbGncu8aKhX8wHPK8YuX9wiLRhoTQKwF9SXaZrQT2bf1R090SVvN/8rKWgptnE6kGe
	3GDeTvXdiRbWiAsc7xRs9PaCGmgKHWLkgIrrddr17qnhQVJUP4MJLIBUjCheq0yD87lLegUyCd+
	lNO8FpoqbS87SF9pTdMOPge6ZgeZjLyhyF9oil0sW9UAfJaOGB/KRpd77Ue1+MhTk1SHz/OJsZ6
	IskYiyEW2k+LoFeZXB+pRNKw3iuKIM7X0LBdWP5
X-Google-Smtp-Source: AGHT+IHotd1w9hgcJaMKlGGOglODYjS7R49yIJBnZVxlXGew4GiiU6D6repM/2G+4YASZCQw7uWImmyPlSqOToqx6T4=
X-Received: by 2002:a17:902:f642:b0:240:11ba:3842 with SMTP id
 d9443c01a7336-24944a9a70emr181326735ad.35.1756887380252; Wed, 03 Sep 2025
 01:16:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250902131939.601201881@linuxfoundation.org>
In-Reply-To: <20250902131939.601201881@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 3 Sep 2025 13:46:08 +0530
X-Gm-Features: Ac12FXxkjRNh-TPz8gdmB62ta4_Qq5beeBKaO__NWn-nGW7c-Cjby8qjDju_5Wg
Message-ID: <CA+G9fYvEyFjh6k02caEL5JYd56A0Xv5e_RSRxkDZeX3A17UTGg@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/95] 6.12.45-rc1 review
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

On Tue, 2 Sept 2025 at 19:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.45 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.45-rc1.gz
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
* kernel: 6.12.45-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 4459b7afd68d8c7f767bfedcb8ce7b7973caee3a
* git describe: v6.12.44-96-g4459b7afd68d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.44-96-g4459b7afd68d

## Test Regressions (compared to v6.12.43-323-gc7e1bbb35205)

## Metric Regressions (compared to v6.12.43-323-gc7e1bbb35205)

## Test Fixes (compared to v6.12.43-323-gc7e1bbb35205)

## Metric Fixes (compared to v6.12.43-323-gc7e1bbb35205)

## Test result summary
total: 323915, pass: 299363, fail: 6744, skip: 17352, xfail: 456

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
