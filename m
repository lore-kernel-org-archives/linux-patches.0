Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 740061C5D64
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 15:34:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738337691; cv=none; b=BYxQtntVRGwezcOLtS1iy6Icp572D3Hedu5ZrqxjaBRB8a5HRFI+qdH1C6JcGze/2iSsWjoPNQDHHEVbtSKFGdP0xOn1EqhIXBYGjJUalsNSensj6lFTCKv3xfmPB1TI0o0bQSEsZrH4JQW/5u4FsRI9YTWjHjKFRSU1mKl4hTo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738337691; c=relaxed/simple;
	bh=qNsYthABkFQQSgwYIQHT21jbO3CPtzOZZjoN/bl36Qc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bwYOaBF3Yr5iU5J5oh+ZMWB7NlVNPLIZAnKdGrsPYosUI8oA2BPfal6GEenUS2jsWOeTnq2Td0Az7EeiLfHT/2U1fhdo2xf247rKJOecAgjgpAHeTFJo+4lwWjAN/elIk96gQNgqMBbdQ06f/f0XtesHH3ewMxH1Xl75/w59yy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=qpb7mDKF; arc=none smtp.client-ip=209.85.221.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="qpb7mDKF"
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-5188b485988so728751e0c.3
        for <patches@lists.linux.dev>; Fri, 31 Jan 2025 07:34:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738337687; x=1738942487; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=prgxnisBvFfnEWdw5tyPUtrfBlX1TpjjhLA4brULRjY=;
        b=qpb7mDKFN3ZcHYABOa9D99Bwwq8/Bd5INIiGjWnWPcAjNaX4/cGdNFjJTbBtVCZLcp
         lyVsZtFd1ApoZND7RI5CvcvtlDErFFsJkOQ543rLrd3Hql9bEGcN4W9jnE1/LQW9lUZ3
         Qo+W2UnFH8lk5hA2EiCtA0yUyrp0hGDoOxTGcl2Z4Ak1ANuTwkaAmgDsZKdg3R8FlVXu
         LpLSO/ZTvZGDQE0GRsP6Q0ZTxrb+toZ1XzcUA9ftN3oex0S5qMZeE5ZyQrq5IFWHdWac
         KSUAI4RR4v1+E6CWF08FGkU+ICYacrnhf8aUWl1XzbTmfF1T3v5FcuSIZcBZ36S3z1O/
         rvZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738337687; x=1738942487;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=prgxnisBvFfnEWdw5tyPUtrfBlX1TpjjhLA4brULRjY=;
        b=s6NTxYV21sixT8o6PHR2u3VJr4HZ5HDFkNXzwget5aIs0IfFSN7+2ckI7YQ7bwh4sv
         Dc7+RzzEtFaofAQOPc9nw62UQ+2ZJG+rkEXTyo2jc38fIE1Ir8KS3FMtL5LQLjwYL0ZX
         3cRXH6PAgbOGGkrpiH7nq9fBOw8FOZJm3pBYCgWppxg7tnKuxG2SOQgcI7ivG6w8xS8t
         PNxdUpQRKibhya23H1s8bE0KT4YjmQ2aVr/yeKSjR8T92McXnJ1GMdqA3XXFx0OkjPUC
         2VIDx7u8H5jfhqd+8m+pVUU6nKVHLyUte1La4VmSt9Ey3pIkiO4Ugznck/v4PXC1j5pJ
         baLw==
X-Forwarded-Encrypted: i=1; AJvYcCV6zAcWDs9RdMIvVhnVGtXRGD8amFogyU2e7ESXC4j22+phyOZCo9UMr85Pd7EYepKb61lr5S/V@lists.linux.dev
X-Gm-Message-State: AOJu0YzdQ9Gtld3Ri/EAuGmS91adWJ3Igo13WH5m//dW5P3XmxZVxPl3
	OCHpYaU9jUUmVSkRm8GyocUCShZqJBS79YqF/ztlpipLQwOGFATsYNnFL0mBBszTyVtMMOANtHT
	M/dIvyrtUqhX75JOmzwgvKvAiHZ0eGspYpZ0fPg==
X-Gm-Gg: ASbGnctaY6H6ZK6bn4IAmSagwZWsY5mPf37FEISqXx8kZu0+aD7RgTKUKEJDmhSooBD
	Pcv29nIC4+co6Ro34I9Iz/Gl9U30rUxSYV1YlbM4bT/cEeY5/2gMrb2ZT7jCnHtutbYk/HIm6KN
	fk7dL2OQsjRGiIjG0b2oZKSnSGqmfhqg==
X-Google-Smtp-Source: AGHT+IEcuOjLHChntviHsLyxu1HHbE+nT93cERhYpqS+zXeePjyRJ4FeC6SHl5QPHU+jGeBW7A/pjPZDIy8u0ifh0jk=
X-Received: by 2002:a05:6122:6609:b0:515:3bfb:d421 with SMTP id
 71dfb90a1353d-51e9e4fe79amr11782098e0c.6.1738337687295; Fri, 31 Jan 2025
 07:34:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250130144136.126780286@linuxfoundation.org>
In-Reply-To: <20250130144136.126780286@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 31 Jan 2025 21:04:35 +0530
X-Gm-Features: AWEUYZna_5UTEAqDsa6Zes8ttM2Eyuaf61E3lIwkRn4YU-BA0AEgG6OZbMC_U4A
Message-ID: <CA+G9fYuWfSwyKLugpo3WsU2gvgaBKD99i8JR1YM8oUZ8EAdm6Q@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/41] 6.12.12-rc2 review
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

On Thu, 30 Jan 2025 at 20:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.12 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Feb 2025 14:41:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.12-rc2.gz
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
* kernel: 6.12.12-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 4d14e2486de5514e8267e9061685a372056a2b94
* git describe: v6.12.11-42-g4d14e2486de5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.11-42-g4d14e2486de5

## Test Regressions (compared to v6.12.10-122-g0bde21f27343)

## Metric Regressions (compared to v6.12.10-122-g0bde21f27343)

## Test Fixes (compared to v6.12.10-122-g0bde21f27343)

## Metric Fixes (compared to v6.12.10-122-g0bde21f27343)

## Test result summary
total: 137811, pass: 91565, fail: 28303, skip: 17859, xfail: 84

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 143 total, 137 passed, 6 failed
* arm64: 58 total, 56 passed, 2 failed
* i386: 22 total, 19 passed, 3 failed
* mips: 38 total, 33 passed, 5 failed
* parisc: 5 total, 3 passed, 2 failed
* powerpc: 44 total, 40 passed, 4 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 26 total, 22 passed, 4 failed
* sh: 6 total, 5 passed, 1 failed
* sparc: 5 total, 3 passed, 2 failed
* x86_64: 50 total, 49 passed, 1 failed

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
