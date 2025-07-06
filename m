Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56B61F30AD
	for <patches@lists.linux.dev>; Sun,  6 Jul 2025 10:20:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751797216; cv=none; b=AUBjkHhH7uRayY4Fh0Alo3LHWxLC2bXIGRApLaGrEGOdh7lJm5uwpIsjFNYLuEXJf56YrcJahRXXKDX1C6hYdis2wTuA5HD+O5Ucaogg0R4tFeCrQjkQHMkk4Gi/ChZVLcPNi0WlI9D/LNaLrCMBun4FMOy6ClwJ00d6B/DvQoI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751797216; c=relaxed/simple;
	bh=3i4oNzoxPApaR7jJuESFYKij3qYI8FDE7ecJ4O4s6v4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iiRnbIr6sVOD9KA8KTurg7Qm6gbd/OQ4VV7bs+gLRLrtXmBdRL6UZQcJMIo7nI7AK4KGywE/dnftyB44Kn1tstTYYN3XQSPp0HHKeOn9VqrM4o0010WSABQhiFnf/Q2fNTqKhOL24ZWL7V0AdE/VORHzCAd25k9lZjnz+jxhs0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NSLw3A+v; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NSLw3A+v"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-3138e64b42aso2981090a91.0
        for <patches@lists.linux.dev>; Sun, 06 Jul 2025 03:20:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1751797213; x=1752402013; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nJC1YnqRsI/+BxDwAPn1fBTIKeVMKtwCwKSxFcD1Pmc=;
        b=NSLw3A+vOhJ8pvYCKBT854scfq4prKtXXGwi62FM/c40j2UN919fdWTR+vjsWkVW/C
         wxEGuR0aoGrc0LPAjp+Do0ejoLbO2dnybj8oXIiTRfu6IEWwIK4lN52xpUQljhbnb+AU
         SLgcwwV1Pt0eBqUIlCUg/1MvrHaSfK+7/pnlW9pSniGkmbz6Fyij7XE4EjdBT2CjOp72
         wr62xATdwcWG7ZMmHpqgthsmLMxVMRWNmXVlI4hpiXrpoPD1bn6eHUD9fAoHn/g+vp6Q
         qpHl4zbVHZqRrBIrzQTtxfGeC6+lDMgfWrSz48P9orn8DOiUSi8IGasHXK5ZoLDpzUxs
         5vxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1751797213; x=1752402013;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nJC1YnqRsI/+BxDwAPn1fBTIKeVMKtwCwKSxFcD1Pmc=;
        b=QLTjl3j25T/+ODhG8p6/Vr4/K+4MxEq3WyXBA5iMVxR3nlWQs/mElf5g2hiVSn1Vcd
         RhqZ1bHLTMtvUh6g2Hs3exstZHwWWiChQX4UgBqR+qq7iXZyKrN445Ep/JxHcbjGmkM3
         clu5usbz0aQp8ueYAlIg79rA/lXrO2nq6XCEsdxDrd9b/RTgz39jxp/B2WeVU4FhCY41
         BArps1ea9slCoPDoNItM+hTwvE7yh8CGI69j7vr8VwCO6AHm2EDtia7M3VpFTWsgYLzj
         Elm65fBXjYLlS8T6+TzNXQPA5pwi2l0t1qLoR/JxLf+xnPVCJB0pS2K7hB3jR7364+w1
         X5jQ==
X-Forwarded-Encrypted: i=1; AJvYcCWnIE0YWP/loZbw03otK4+ZfAXWs0tf8wnuRYvg2afqbXgzTs8ZtTVf8vSZ+ljVBz3rRK7JLIp2@lists.linux.dev
X-Gm-Message-State: AOJu0YyPMTr6A20NYpeg+BBE6PzsNHbmKGL1+cw/E8UeayEuhxdhnIfK
	OtS4nw1opynyuD/esM3Pv10+O7b77JARnlCmnL9ht3ox6/0GIDEnQh6GIEs3+2eaapMyLgGdF5i
	S9LxHE58mZqSo55f7yLyDM0kneD+cS7kIVVhgbLK3cA==
X-Gm-Gg: ASbGnct3gCivAP7tjp7v4RAE+4222T8CF36a0f/syU5rxCVxhDZVirnJ8NIeqJtsF9D
	xTnMRuOfiMKuC3D6Bg8/5Q9yzgQ97xs0pBc0Mbyna9zH7JTjS8sHXRf+2HKtJBAlHVQCHDPRdLa
	UCHb6y2WVeVw64RCLdnjg200ZeeXBBZb6XxuJVaAGwfH8OIA==
X-Google-Smtp-Source: AGHT+IFQ/yDgnJfWcTEvzzr/hLpoYvYM+BA8AZGWWKSHWa4EZGYJ4x258RaKhie34g761N9q4rOdXTFzMTulgstLuuc=
X-Received: by 2002:a17:90b:2f43:b0:311:9c1f:8516 with SMTP id
 98e67ed59e1d1-31aba85c314mr8110906a91.15.1751797212944; Sun, 06 Jul 2025
 03:20:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250704125604.759558342@linuxfoundation.org>
In-Reply-To: <20250704125604.759558342@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sun, 6 Jul 2025 15:50:01 +0530
X-Gm-Features: Ac12FXyH1VcLc-KLE5gEDuJ2sOEzP3oBxjxO9umnS5MCIQGy6hwVYE4nMG3n24Q
Message-ID: <CA+G9fYvidpyHTQ179dAJ4TSdhthC-Mtjuks5iQjMf+ovfPQbTg@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Dan Carpenter <dan.carpenter@linaro.org>, 
	Arnd Bergmann <arnd@arndb.de>, Anders Roxell <anders.roxell@linaro.org>, jakub.lewalski@nokia.com, 
	Elodie Decerle <elodie.decerle@nokia.com>
Content-Type: text/plain; charset="UTF-8"

On Fri, 4 Jul 2025 at 20:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.5 release.
> There are 263 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 06 Jul 2025 12:55:09 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.5-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Approximately 20% of devices are experiencing intermittent boot failures
with this kernel version. The issue appears to be related to auto login
failures, where an incorrect password is being detected on the serial
console during the login process.

We are investigating this problem.

Test environments:
 - dragonboard-410c
 - dragonboard-845c
 - e850-96
 - juno-r2
 - rk3399-rock-pi-4b
 - x86

Regression Analysis:
- New regression? Yes
- Reproducibility? 20% only

Test regression: 6.15.5-rc2 auto login failed Login incorrect

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## log in problem

runner-ns46nmmj-project-40964107-concurrent-0 login: #
Password:
Login incorrect
runner-ns46nmmj-project-40964107-concurrent-0 login:

* log 1: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.15.y/build/v6.15.4-264-gf6977c36decb/testrun/29021685/suite/boot/test/clang-20-lkftconfig/log
* log 2: https://qa-reports.linaro.org/api/testruns/29021720/log_file/
* Boot test: https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.15.y/v6.15.4-264-gf6977c36decb/boot/clang-20-lkftconfig/
* LAVA jobs 1: https://lkft.validation.linaro.org/scheduler/job/8344153#L1186
* LAVA jobs 2: https://lkft.validation.linaro.org/scheduler/job/8343870#L1266

## Build
* kernel: 6.15.5-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: f6977c36decb0875e78bdb8599749bce1e84c753
* git describe: v6.15.4-264-gf6977c36decb
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.15.y/build/v6.15.4-264-gf6977c36decb

## Test Regressions (compared to v6.15.3-590-gd93bc5feded1)
* dragonboard-410c, boot
  - clang-20-lkftconfig
  - clang-nightly-lkftconfig-kselftest
  - gcc-13-lkftconfig-debug

* dragonboard-845c, boot
  - clang-20-lkftconfig
  - korg-clang-20-lkftconfig-lto-thing

* dragonboard-845c-compat, boot
  - gcc-13-lkftconfig-compat

* e850-96, boot
  - gcc-13-lkftconfig-no-kselftest-frag

* juno-r2, boot
  - clang-20-lkftconfig
  - gcc-13-lkftconfig-debug
  - gcc-13-lkftconfig-kselftest

* rk3399-rock-pi-4b, boot
  - clang-20-lkftconfig

* x86, boot
  - clang-20-lkftconfig
  - clang-20-lkftconfig-no-kselftest-frag
  - clang-nightly-lkftconfig-kselftest
  - clang-nightly-lkftconfig-lto-thing
  - gcc-13-defconfig-preempt_rt
  - gcc-13-lkftconfig-no-kselftest-frag

## Metric Regressions (compared to v6.15.3-590-gd93bc5feded1)

## Test Fixes (compared to v6.15.3-590-gd93bc5feded1)

## Metric Fixes (compared to v6.15.3-590-gd93bc5feded1)

## Test result summary
total: 259237, pass: 235906, fail: 6376, skip: 16955, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 138 passed, 1 failed
* arm64: 57 total, 57 passed, 0 failed
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
