Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E04262E7BAC
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 08:24:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755159886; cv=none; b=DiSwJ+IPyv6oj4L6eML2qxPNRTwNR39zZrot6MeZ2jwklpRCSn6cgcHonpa2kBYVMqstsJE62VT6P8VTHEf5dUto3n7+t9A13EpNXz+ARZVN9z4ZytL2FG4/spp55QsZp9CwSdAX9zgH/qrsvHYVeYB61lWB3cHCo+1aMsZJJ64=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755159886; c=relaxed/simple;
	bh=QRuY0xcssAqNzsjoe0+GUA8Ky7ufdADxvjC0vu3O1m4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bj9DQDm81BR8w/PXUlJtUiWtQ37qGgzfZTUoUaoc4m7CbW4qt87/3YZs44cNKSgm0PAw4FZ4zUy+y2VifsCBVNHCNq/yUJ1SaBTrX+8lbJYQDeFN3OVqvQe9VDMO5yxu/YWkQwOVtUigP3gHDO6hlHUK+5WDWf3UmjlzVzh/y9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NGPALVvN; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NGPALVvN"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b4717563599so504424a12.3
        for <patches@lists.linux.dev>; Thu, 14 Aug 2025 01:24:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755159882; x=1755764682; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PN4ndrkgVneBhF71YXNayTVC1k6fq5rxQE8AAOWHWiE=;
        b=NGPALVvNpQuD3L8vDTX5V+3up1XmCBUTeO50jA7ZuNMeT/o1ZRfMMOfDrgvDiDgWTa
         xVQqVVg17/sYlDb5YWyV3ZpLQAz5Z3GuOB1mguBqX5zpDfVSFIMivNLkyCAUkEG5k5OJ
         qHn+N7v2NWd96WKX3as+Vz595Rdy4KZVPzsaZg4bKH3y9InXDnqiLYkgpzWDyOHbRTjb
         6YXVkMvd6vMzj+4SfWslKrY0OknqdOhQ2EZ2pglFYYRDyYBvKEi1Ehs1sf470IcHLDYc
         0mbDRmi1dy+KXG0dG8ZuozBRIwRZTHkQlZKY2hLGl/BS/YL7w6eUK6hl8eXARK9dSko0
         WBDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755159882; x=1755764682;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PN4ndrkgVneBhF71YXNayTVC1k6fq5rxQE8AAOWHWiE=;
        b=O3UBwkXbB666FOIQRTMXOpfDqoAufPIselTG7wr774mvrpv8NJ0oIB/uer338iIVBG
         0E+HdsyMr+rgmVzzWwT3Nr/08VCNmVm1zZQ6JbU+k1C6Pjls7Lp23wUXKF9JZI7YYbUU
         4pbaVro6OnQKXJH0PT+NYxZTUwstXbs7uzAvTVLadfF1DTAMhU080/o3eI/fEibrxwe7
         WnNOG8UM+ceRCTZ1nTKivwEgHc9BO3X513ntnEsKwQwjwbgl3lCeBaq4VYeEVB4gIYC3
         51LkCuVPu/91iPtDwG1pTJoZuj9BTsbigfjnhMgA4Tu7kiRcRgSMiqoi/GakZffH/D48
         W3mg==
X-Forwarded-Encrypted: i=1; AJvYcCU2mvu+ffI58Hf6Npxmo2/e2O+qnGqdYufqFfZjNRAYxd8m9u+A/Qzd858fxPRav642YjeqARow@lists.linux.dev
X-Gm-Message-State: AOJu0YyBq+JUi2Rq1eRTrKOCI3EXnqedh4NORVwwYBas4MuGxD3RyjIw
	5wKa5UEnvDfk+TAbki2tY3eL2UwTDvwkTOUpKbYp17YWpoLTfBVRWtrYd6r7GUs+UrvoOmzb+dR
	lKjC9j7HB/fKG1w/6WSgWPyNB6q5p1EuY/+zRxgOwag==
X-Gm-Gg: ASbGncuSq89TMRUTvQqKsA3YQV5VK1gfReCxGCWdb3HVQc/RlGmE5g8G6vVtqynpQL4
	N4Hr8VJs4mnIVdBLoFZuzNNLN2zAL0wO8EmPrs7O94greliCxcGByE8OGxX+4NnGhcByAEEB042
	P/b97RcVuC9ztxsfW2GQ0NEUItbBmmXuGJTKWEaDyRtDpdS97lwER5d7707ITYYjCWfvrL0hnFA
	Yo+jl2MEQBitme0nw/2y4gR7uWmATaIT0KTFc+EkjkXtpfJZz8R
X-Google-Smtp-Source: AGHT+IEQ6olLFhlnuBt+suQ/HYvysyluDH8m5MsRBc9LHDFH2apZD3pSIajpR/6y6fisab/HUr4DU1uJ9Fx/39JH2o0=
X-Received: by 2002:a17:902:da92:b0:243:17a:cd48 with SMTP id
 d9443c01a7336-2445851f038mr40305795ad.17.1755159882053; Thu, 14 Aug 2025
 01:24:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250812173014.736537091@linuxfoundation.org>
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 14 Aug 2025 13:54:29 +0530
X-Gm-Features: Ac12FXyyGXeSA7vfnwGf0EzVOprDr4qz86gCpoS_15nupDMTeTdNSdzNao3uL0M
Message-ID: <CA+G9fYvMdJpO=qWHh0o0u7qeaTS3-=AF2FgtLgMbRuKQ_5vccw@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/369] 6.12.42-rc1 review
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

On Tue, 12 Aug 2025 at 23:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.42 release.
> There are 369 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Aug 2025 17:27:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.42-rc1.gz
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
* kernel: 6.12.42-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 3566c7a6291d9602f9f443a3e97340103197f811
* git describe: v6.12.41-370-g3566c7a6291d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.41-370-g3566c7a6291d

## Test Regressions (compared to v6.12.40-118-g487cdbecb4dc)

## Metric Regressions (compared to v6.12.40-118-g487cdbecb4dc)

## Test Fixes (compared to v6.12.40-118-g487cdbecb4dc)

## Metric Fixes (compared to v6.12.40-118-g487cdbecb4dc)

## Test result summary
total: 308371, pass: 287741, fail: 6222, skip: 13991, xfail: 417

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
