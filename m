Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C41AC1E1C3A
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 14:49:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734101370; cv=none; b=Q7S6VGKLQTqqsMCd0/eJkyTpQGxXD65qV7dbZtXZ61N+FCUvSbjH6KlUz6hE7o/36QuxNDUvTz6ULqy7uV8IbdxgWKEmiRLuukawPGQ04lO5MGP+V1AZ1M2kiClIrm2ZDla1lqEJR2mid3ki81kfYgaVNwX1aZ86cVRryYsCaaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734101370; c=relaxed/simple;
	bh=hByqeNYL+TZV1cYmgGYkHNhMiCkV4v9idGQn3nu0lpU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=o/lWTVYV4k0Ra9nzR+Am55Zrgbcpm3lHu/FVQU3e2DOZghEsSVedWrULLVKmuYj90JW0QFD2Ym3hPzlyy2YVOb8UrXKrhCzuLgnpMJaYe9b7a6L2F9vmdRsJyfrk3030PDgZrlkrPvRd/OL6L3mpfVdHF8bj/VTMq18MNdafLdU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=L3dVxN3E; arc=none smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="L3dVxN3E"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-85c61388e68so392558241.3
        for <patches@lists.linux.dev>; Fri, 13 Dec 2024 06:49:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734101368; x=1734706168; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7bKxIAldnf2WV3uWw0aRPXep5q1Q5wgQLNkyd2UuYH8=;
        b=L3dVxN3EGY76lBindafT5atacYfXcWXcWIWXgYSkA6oQE6WWkNLi9IBNdTsTA/LB1k
         x6ytdntVuB0VKHWkMW9ktlrIw6sKNZcsecRD8TPpL2oeK7r5L8yWKORpHxceke3QuX6f
         POVwBk4BgvYAol2Grdj40yRe+mKeTJzWv3FV7oy0+RvbntwQ8YvDeYrP/T7n4ke3HBJ8
         xwdQRqQh+uk+d7obyjDVNtUe6gAjK+giyM9UVKqkcAT7tU8gKIPJhvFYPDuw89iCJvZE
         BhEsGoGe7vsOAaOBiw8ClikwuR9XweUUlZ9zXQx/Gij8GycAEkp3MVO0hFopv/rGjQp4
         ZI1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734101368; x=1734706168;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=7bKxIAldnf2WV3uWw0aRPXep5q1Q5wgQLNkyd2UuYH8=;
        b=V0uN/cipiucLzRZ/QvIe/apJHGj77GdQd6DveWaTmIVW1R7erwq5iCGvIxutuVuLv1
         sYWST/mDMEaS6iRFBP9BP3r1jpw3MmBFvosAlBy63AaC3g1scRW6YIUQ7I9BMG5IyA0l
         Mg/KBhejhr4dfScTsM92SW5kQXspXGi2sjUh2NfL9IDWHXusWrvke5ypkdPpUFksBw6k
         20Vkhjygrk8a0y9k00YDhUeDsF05Qku5qxcsiIoTtzgzd7npx6cRbLQRsno9ub+AO0Kb
         SXqAXSyUQ54M74HNXwIR5vFzoUC9t6hReh0fxo5Uh4+FIM3QXdxQxR6greQgeSlZVljD
         QStQ==
X-Forwarded-Encrypted: i=1; AJvYcCWf7uGLPRKYPmunrQIzftww9VZJQnmvy+OdCskxOjPgRavWnYNqFvH/Jhp9POlu0O83rLos5k/3@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6BvSOSGNFRjw1G5abMafvUqf6SeHVLkwk+eAcMlpgJDCm5kza
	gT7fDhzKJskHlKZW4U4cJ6w+UQPY6b1h5uy9DQrJPKLpAVc/Q30PT8sYtH/S7MeYHjz4sVMh/5g
	GjQWYXUmZyNB3uZGG2knC02mHFcWaKEdBp5OBr/iCSn5OKGWx5OA=
X-Gm-Gg: ASbGncsc/xodPB/BLlHtJ3AWh3iNyhAU2y02kkb3OIvMhTtCSyzQ27DBFcESwNcpwRR
	LdtI2Vx1ZA8gLBMoZRqJi3CbhLF7CL9ZEdldsBEo=
X-Google-Smtp-Source: AGHT+IFvRz6amg0/LCv795PFdcXSwZFAuHmhc08GDUubo7a8UJkjnqdzDOeeViMLb5gcFryVLpGHBJmY4rTH42n0lRA=
X-Received: by 2002:a05:6122:8c12:b0:515:c769:9d32 with SMTP id
 71dfb90a1353d-518ca399ec3mr3099699e0c.4.1734101367579; Fri, 13 Dec 2024
 06:49:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241212144244.601729511@linuxfoundation.org>
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 13 Dec 2024 20:19:16 +0530
Message-ID: <CA+G9fYv-qg_TbgP9o_VyBcBAYfecxFvRPjq0w3SFX_PvJWDbkw@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/356] 6.6.66-rc1 review
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

On Thu, 12 Dec 2024 at 21:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.66 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.66-rc1.gz
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
* kernel: 6.6.66-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: ae86bb742fa81e7826a49817e016bf288015f456
* git describe: v6.6.65-357-gae86bb742fa8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.6=
5-357-gae86bb742fa8

## Test Regressions (compared to v6.6.63-677-g1415e716e528)

## Metric Regressions (compared to v6.6.63-677-g1415e716e528)

## Test Fixes (compared to v6.6.63-677-g1415e716e528)

## Metric Fixes (compared to v6.6.63-677-g1415e716e528)

## Test result summary
total: 130339, pass: 106681, fail: 3098, skip: 20494, xfail: 66

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 128 total, 128 passed, 0 failed
* arm64: 40 total, 40 passed, 0 failed
* i386: 27 total, 25 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 19 total, 19 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 32 total, 32 passed, 0 failed

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
* kselftest-x86
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
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
