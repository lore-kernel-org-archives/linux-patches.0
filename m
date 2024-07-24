Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DD5316A38B
	for <patches@lists.linux.dev>; Wed, 24 Jul 2024 17:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721843535; cv=none; b=UB0UFHZUBy5qCRkSo3PmaDNB+KD59YUeRUiONpTPj/4uOCDVCN2qn/ZEnkbkYr5elaRshkc5EzUBhqUL/DejT8WZ1boJlir36hPuNpWeGpDyUUPrwc28tL2+ZcIMf6vB+HtFTfvVGxY6ZY46d+eU8Rvet3ab/9M+uQ2YIw3TR3M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721843535; c=relaxed/simple;
	bh=sDqEtWlJep7UpmEpWBsJ6/EhrdvHDu2nMmYUG7ZwuPY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AQAcBHL3nvYjt+GhWlzy1kSK2tfmVPMh+1Oa8E6ZLpCE/sATXKGcUSFYX3MAJXi4CTiynLZH0MewYcAAYrQfL1iaCXNgeAOUziLi6CnKCXdlx8L7RfDmyzACCMPCnTiNNrSqU0Gruh36ZRHZt+K+eb8BH/yfC5cqdLHmdIxIa5M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=gne0erEw; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gne0erEw"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-4f6abcf0567so54202e0c.0
        for <patches@lists.linux.dev>; Wed, 24 Jul 2024 10:52:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721843531; x=1722448331; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3adP2UhJX5T3M5okoFY956EupvDoXGJ8C47+StOUW2A=;
        b=gne0erEwjVAeykwVjRv1O8th7bIj1lcJHHMrB71Q14InGwFMeY3/NjpRD/xXKnK2fc
         XPAvnunhjCRlZaG5gRsW6Igp6a3EAPWs6HeCRBFOHvTrm4Mg+XM1DkG+9WYE4eBX/7dT
         g6LQcWN/fgizFMmjPcKXQHLxAAFvjZ70F9kW+N8UArBKivj9/j5pQE1OcV6o8XbvRcqf
         2lrw1MBYK0AfsqPLa7/A+OovGlJaSaRYNs8wMik2WZgjA5lwxzV2vrxzks7wa540NSzZ
         GAropfax9efggiuHFXx4+tZemoiLqua5qtPKAOgSrCYioytiDwoePYAYERSWruhSIQeh
         1e0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721843531; x=1722448331;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3adP2UhJX5T3M5okoFY956EupvDoXGJ8C47+StOUW2A=;
        b=JUi15DqqXhyL2SjiDYvGFA8VBBJT9aq1K+jJ90F5HIq4hDpMfC6zT6+qYsHEh+zMjd
         zvMM2csUS87IfIy0kx5VB/dcyzzqrj0HZWpzE44dfsU33OXg1LbcWDMa5BKFTeS+44qy
         ZtMNfK+tXjGNs3ZJn+hou+gxhZqaGj4Bj/hqN/sPOU0Qzre6HI248MjDGweIKVNgE/4K
         uPvA9M/ovpktuNbhjOh1EZTDbfXxG+HBhXLEvC8Xk66+XcMmdRJ+H6JG2fUkpsGJXwWB
         /NDOd1/h2wuCVXXSIWY9Y+wDjfn53R4yVON6LZE+TIC8tGsVwI3Nh+TTUjE1NDz2ZBo9
         F++g==
X-Forwarded-Encrypted: i=1; AJvYcCUAvV1JZEdd3OEtMWYX4q5L2ZCQUwtUQktlUsYDKkM0Tgx9VDLUxToga2ujnspyflpo/GN40+n0hLcK5B1gHjtPNsmKh+ey8g==
X-Gm-Message-State: AOJu0Yxj/f/KmV+ejuc84rxkFYgos6iYvH3hQOfwc7g6FDVAnEPxdpyN
	snLi2NzaXn/nJGovuzulIIEvKgdslEuxQriUQEc0LvW3+MhH/L5HYmdS9+nCnSri3Rd7cPB96Lj
	1OiqUVqgw81/ioOQbectuDOAZL1GERhDWm0PhPQ==
X-Google-Smtp-Source: AGHT+IHDm4xN+JjWbVMfPd/q71cCC0mZwVm59ulmwBR9BIVHJjfHQ8SmfOsC5ukZRzHyTX2Y4vFe6RWDk3SgDvFSXQI=
X-Received: by 2002:a05:6122:4599:b0:4f5:1363:845b with SMTP id
 71dfb90a1353d-4f6c5c49043mr948024e0c.9.1721843531425; Wed, 24 Jul 2024
 10:52:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240723180404.759900207@linuxfoundation.org>
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 24 Jul 2024 23:21:59 +0530
Message-ID: <CA+G9fYv0KBij75t=mCJ82C8-Mzv_gFXTEqUFUZvtvCzA4D2d5Q@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/129] 6.6.42-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 24 Jul 2024 at 00:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.42 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Jul 2024 18:03:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.42-rc1.gz
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
* kernel: 6.6.42-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: c74fd6c58fb18e0bab49dfb540cb0a9b3bbddc7e
* git describe: v6.6.41-130-gc74fd6c58fb1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.4=
1-130-gc74fd6c58fb1

## Test Regressions (compared to v6.6.38-261-g6b4f5445e6e6)

## Metric Regressions (compared to v6.6.38-261-g6b4f5445e6e6)

## Test Fixes (compared to v6.6.38-261-g6b4f5445e6e6)

## Metric Fixes (compared to v6.6.38-261-g6b4f5445e6e6)

## Test result summary
total: 220969, pass: 191018, fail: 3225, skip: 26302, xfail: 424

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 127 total, 127 passed, 0 failed
* arm64: 36 total, 36 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 30 passed, 1 failed

## Test suites summary
* boot
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
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
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
* kselftest-watchdog
* kselftest-x86
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
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
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
