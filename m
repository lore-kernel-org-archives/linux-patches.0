Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AABA1922DD
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 05:48:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748929729; cv=none; b=ZNxZGKeuELDVIsKhxFoCCZ11XgHM7Z1JNG/oXJqv+OP7l5h6HDWidy48Grk0eCRQhZ/kvKrg1h3zjD2P4OTm2q1ga3sJzSr7+nJ3ujZQQOTimGRGDZJRzxBTx39h2duuFI63Wtr6jzX6XX7YaCfrugbpxuxX3icGgkqXe6UKxHw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748929729; c=relaxed/simple;
	bh=7jWU94ik0QbWpSiooVhPx/UIP9kCzHJhH1gbv4/E8qw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VNkFZVaWAxUWVA0rTW5TAtT4B8HwP1hkBWKtmkrzpuK+BFTkGhTqKGQgiOIi4dzzOy7VjK6X0PARGXlmNNhEAyMWjKpb/Oxt+F1YSknfBhrYQOaWXT/lvGF/jKZgBcVBPlvvZ/0pBQIIVS/XrhrQQOZMMsQcA4RWbs7EaV/CgBQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=NWl896T8; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="NWl896T8"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-530bdd90964so45459e0c.1
        for <patches@lists.linux.dev>; Mon, 02 Jun 2025 22:48:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748929726; x=1749534526; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=CaaJTsDGCShy9NH8Xsdsynpcxp9Oj/lPPlRCEtkrCPY=;
        b=NWl896T8snl/cypckpBZZZypgrL1/bvHvEJDYBsPDgqayhiBK+YsiFnStu7n2XvpwQ
         fuw7oP5GV5F+Vb4qSgUuftkatICYbuHmpwzDGDeYHgCSKl5aY4h1nBm+DrWBLSSkI0m0
         RprjviPJCJpuh2S5CgiI8sDnhqpTAevSEDeWxJI8xvapMJu5E8Hbz3leCInUKIHuom5Q
         XS4e/iD2ihuhlYkY8jCSOh+8REYhIeCZjBTlGpuxhCNHaCk2vpmlGNGDv9UXuZ6+2m7G
         EO7ASGzf5dd4wbWy0nJYdrkFijAPJ+nbVgnu+NoSxtfI839AU1AJ83xcdtpueqSzUuWD
         85dA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748929726; x=1749534526;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CaaJTsDGCShy9NH8Xsdsynpcxp9Oj/lPPlRCEtkrCPY=;
        b=dhPN2H5/hFtXkuK42NuJwWFJflxOUM45WFfBrOKA/ZjtN2PeKwavexEDwMnfqUgBqf
         pg2oSfYfPpHBdOfb8fG/eKEFwVWln4/YABV8/+OCgzVDipkpwylaYL07Hco+FhBmqNrQ
         2VJgCWpxmRv+lj7Htfdl+IA+lxgVxCLPzbHBx51nlqBZAZ3VMLNyKMR8DtMmSPJAtZja
         lP0DqSYIXZRMVoI7U+MBP/CtXK2JMIipeIGavozRF0KdEah60297SAFjV5ZgrOHUl5mA
         Zw7260tPplpZsI9Xl93Uf3bIr8lYJv6UpvAqdF0JyURCHV/jPC/1aHz0Uz0JQtqha7bH
         tVNQ==
X-Forwarded-Encrypted: i=1; AJvYcCV1NOPwCpURxo/0MwnUIR3KmUUYkMleKJRxHmK+T15ryYN9a5ZFNfLatW3bB0PIfqAKskDedXd3@lists.linux.dev
X-Gm-Message-State: AOJu0Yy9jYTaSYCkHb8Z9dG8S3RPpUpt+GqC/qdFk/eMvTmWuQFKOMfG
	hzg7DQEWDwCIBWaXtOVVu+w7UZSHXRe9xfZ1b2UApERV+q74xN71XC6ZJZnY4L+1rG4mCq16CB5
	n9sKJ/9kuyVChk9Cf1/BrgiZNWIeOJuu1c8ufQnqcaw==
X-Gm-Gg: ASbGncuH82CKT8bj6EKTqjvXOrWrfK7OrBwVz88JY4izUsyNo4Oo3us99LH1L4kzPWh
	j0QIJgIFd5ubScQOeTln04JvIACkxxUOvaYOqDRso0XDjuY5C4xRAFq6663HH8S8FL+9+ygdELf
	ITvWGyoYmJY3EEgZP7jiVwnzkP1gnO+ow=
X-Google-Smtp-Source: AGHT+IEE/W3g2hwG4gBEVSF+Iek3RiiwVhogHCqvDg/sShN7bI2AYBy6Y0DQ9iTRS3tglw6ByUzvKUeEdmZvkZarTk0=
X-Received: by 2002:a05:6122:a2a:b0:530:5a43:db61 with SMTP id
 71dfb90a1353d-53080f59017mr14951319e0c.2.1748929725864; Mon, 02 Jun 2025
 22:48:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250602134307.195171844@linuxfoundation.org>
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 3 Jun 2025 11:18:34 +0530
X-Gm-Features: AX0GCFu7rs0fy7qq0P5qjPajChCgj4kaqGSHnyRwSFbbdU0gilubxy8DH1XzJEY
Message-ID: <CA+G9fYvkMUv4vFcde9A_chiiKOSkRiydGwnahgZauGExdmWEtQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/270] 5.10.238-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Mon, 2 Jun 2025 at 20:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.238 release.
> There are 270 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.238-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

There are two issues,

1)
Regressions on riscv defconfig builds failing with gcc-12, gcc-8 and
clang-20 toolchains on 5.10.238-rc1.

Regression Analysis:
 - New regression? Yes
 - Reproducible? Yes

Build regression: riscv defconfig timer-riscv.c:82:2: error: implicit
declaration of function 'riscv_clock_event_stop'

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
---------
drivers/clocksource/timer-riscv.c:82:2: error: implicit declaration of
function 'riscv_clock_event_stop'
[-Werror,-Wimplicit-function-declaration]
   82 |         riscv_clock_event_stop();
      |         ^
1 error generated.

This patch caused the build error,

  clocksource/drivers/timer-riscv: Stop stimecmp when cpu hotplug
  [ Upstream commit 70c93b026ed07078e933583591aa9ca6701cd9da ]

## Steps to reproduce
 - tuxmake --runtime podman --target-arch riscv --toolchain clang-20
--kconfig defconfig LLVM=1 LLVM_IAS=1

## Build riscv
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.237-271-g8bfb88108193/testrun/28635871/suite/build/test/clang-20-defconfig/log
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.237-271-g8bfb88108193/testrun/28635871/suite/build/test/clang-20-defconfig/details/
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.237-271-g8bfb88108193/testrun/28635871/suite/build/test/clang-20-defconfig/history/
* architecture: riscv
* toolchain: gcc-8, gcc-12, clang-20
* config : defconfig
* Build config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2xxPulf5bqlsj7nSlN9PnLY9NXG/config
* Build: https://storage.tuxsuite.com/public/linaro/lkft/builds/2xxPulf5bqlsj7nSlN9PnLY9NXG/


2) The following build warnings were noticed on arm with clang-20.

Build regression: arm at91_dt_defconfig warning comparison of distinct
pointer types ('typeof (nblocks) *' (aka 'unsigned int *') and 'typeof
(num_node_state(N_ONLINE) * ((1UL) << 12) / locksz) *' (aka 'unsigned
long *')) [-Wcompare-distinct-pointer-types]

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build warnings on arm:
---------
net/ipv4/inet_hashtables.c:946:12: warning: comparison of distinct
pointer types ('typeof (nblocks) *' (aka 'unsigned int *') and 'typeof
(num_node_state(N_ONLINE) * ((1UL) << 12) / locksz) *' (aka 'unsigned
long *')) [-Wcompare-distinct-pointer-types]
  946 |         nblocks = max(nblocks, num_online_nodes() * PAGE_SIZE / locksz);
      |                   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
1 warning generated.

This commit is causing build warnings,
  tcp: bring back NUMA dispersion in inet_ehash_locks_alloc()
  [ Upstream commit f8ece40786c9342249aa0a1b55e148ee23b2a746 ]

# Steps to reproduce
 - tuxmake --runtime podman --target-arch arm --toolchain clang-20
--kconfig at91_dt_defconfig LLVM=1 LLVM_IAS=0

## Build arm
* architecture: arm
* toolchain: clang-20
* config: at91_dt_defconfig
* Build config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2xxPtpUSdrY70QnawZR0ftSwhPt/config
* Build: https://storage.tuxsuite.com/public/linaro/lkft/builds/2xxPtpUSdrY70QnawZR0ftSwhPt/

## Build
* kernel: 5.10.238-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 8bfb881081935b7a621f358516e28f4470af3296
* git describe: v5.10.237-271-g8bfb88108193
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10.237-271-g8bfb88108193

## Test Regressions (compared to v5.10.236-287-gce0fd5a9f1a4)
* riscv, build
  - clang-20-defconfig
  - gcc-12-defconfig
  - gcc-8-defconfig


## Metric Regressions (compared to v5.10.236-287-gce0fd5a9f1a4)

## Test Fixes (compared to v5.10.236-287-gce0fd5a9f1a4)

## Metric Fixes (compared to v5.10.236-287-gce0fd5a9f1a4)

## Test result summary
total: 36900, pass: 27422, fail: 1956, skip: 7366, xfail: 156

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 100 total, 100 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 20 total, 20 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 21 total, 21 passed, 0 failed
* riscv: 9 total, 6 passed, 3 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 24 total, 24 passed, 0 failed

## Test suites summary
* boot
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-futex
* kselftest-intel_pstate
* kselftest-kcmp
* kselftest-membarrier
* kselftest-mincore
* kselftest-mqueue
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-sigaltstack
* kselftest-size
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-x86
* kunit
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
* ltp-crypto
* ltp-cve
* ltp-fcntl-locktests
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
