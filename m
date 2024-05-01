Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1A9D47A70
	for <patches@lists.linux.dev>; Wed,  1 May 2024 05:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714541122; cv=none; b=Q/VxYoWU4T0UMOMEl7Hd2Q8/2OV7iRzXiDTnWEvQjrNyltZSAkIB7EmG+9/x1y9DBuZ2NfhhQpTHpmncTuSx9NN/SGnx31R3kgk+HiqY4tZUUdmzrqLu2y/phit4MTD71snT8eBXAxydTjOnswOghVdfyqUD7NfqOOiWWJUgAXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714541122; c=relaxed/simple;
	bh=XYEu0XIuOSc0LaJT7C2brLowA3qUmNusleJOEIspl+4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fSfkJAvuC6aM+5JWHKbzveDA/HpiwlGmcv0icDLzFU29zq/GY3ygYxdd4z20lvJ54ZChgd3ThkQwV0374vVQPMTAYZcSXshS41dZeyxeXIPgrIhanUy3Oi73ueWQlVROJ7VsTIs995YKx0kZspNdR/Xe6EeMDOPyN4afreoN3RI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nUqSJdN8; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nUqSJdN8"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-7f34ebbcde4so202834241.3
        for <patches@lists.linux.dev>; Tue, 30 Apr 2024 22:25:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714541119; x=1715145919; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IKAyEdFLTMYMkl+qSVoB2MJ6thzzQhoOyIz3GNSqdnM=;
        b=nUqSJdN8SB5UMR0IuKT+5XTMAy4NW9o2pBDUsv1fAgQGlh1iGjO8gRp2SdfsqJx0Ll
         sWW3bZVcV5aR+4a5iMsZ5S/hVBdl1KXzZYBZkkjI1+2nh8BFVerFnLEEIKvb5Tcb4ViO
         4Kmj6c/o8gejO69ksd5WyhgobTiqxyqZEudAmh78k0/Ex5q9dOswKQrFo+9aYJ5vjTu4
         W38AvCMEzZmnWTXO1316HanV9x9sCBsww9QEhTw2/MUyL9I4As1oAbUFrOQrwBYFW394
         //CPbH9hSi9K9s/RAREI3ABr2SSbSXZpJznM5iWXmi2q9m4l+G69bPpaXK9Yg11YrUVa
         8nOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714541119; x=1715145919;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IKAyEdFLTMYMkl+qSVoB2MJ6thzzQhoOyIz3GNSqdnM=;
        b=kJ6/d0V7/fsaxEMuS1z8L/XU04kuwHcD61g9JRqHozsdi3XmuESE9ta7fRwoGzauqr
         9H/pa43QvPbSejPumgzuVp3r9GAwzRo5b2Did0zzKTqGU9HZeAlqPfhX9xj52RQM7LUx
         X3Jok/JGllphLlIUMT/vIiRNKit+hscdePkK8EcbsxKwg71MUbPZJCGH19DHHknC5C43
         ji0C9ofImb6AxGonCwCsGHwRHvV1vo7T7XJHg0y6tPvp0cG45Uo8q/3iqxHP13fvSX16
         pENKHCLx2aQI/o44BHhKIvjjz6NeJOHIqwFQ5p3bhgftGf+srjVpAH20KVrqWIJQfkBg
         CaRQ==
X-Forwarded-Encrypted: i=1; AJvYcCWGES10RoWA/OemA4FwKYJj9KrkVWfyqiQTE7qDwl6Oug39kMRvn4pSxkGuFQZKB4fh4uSFgmsG0dOZ8nO+l8w2mwClfCxKVA==
X-Gm-Message-State: AOJu0YxgFZy5QRx5DwXzow1MuJJ8jJHGNOQFuwEbL+/bpf1EmP1+IuOf
	YrKWuUL3BsEokKBT10LyA9cu7QV0fNdBfYBAAlkNS96xcbfwr1kGqSYc9fyh+duxJlSKnt8MsQ8
	zKF4KC5+GvRPDrfGOGewGTvwPcOof5KkaxNJh+A==
X-Google-Smtp-Source: AGHT+IFaTwbAOGGQgTMTWh5C4q1xJ0CQP0io+qNF6sfe6mCxfRvM40+XEe7ALLxyceaH9yvTKgHEi63DC1Eqs61SBzk=
X-Received: by 2002:a05:6102:364f:b0:47a:2f1b:f54b with SMTP id
 s15-20020a056102364f00b0047a2f1bf54bmr1860316vsu.22.1714541118704; Tue, 30
 Apr 2024 22:25:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240430103103.806426847@linuxfoundation.org>
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 1 May 2024 10:55:06 +0530
Message-ID: <CA+G9fYtBaczXNRZuCRc=_qVs5Nd_Je6QP2uLi8p6Rw9hv2ue8A@mail.gmail.com>
Subject: Re: [PATCH 6.8 000/228] 6.8.9-rc1 review
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

On Tue, 30 Apr 2024 at 16:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.8.9 release.
> There are 228 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 May 2024 10:30:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.8.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.8.9-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.8.y
* git commit: f9518a4bb35acff7e26782f5951a06e7b8fd18ed
* git describe: v6.8.8-229-gf9518a4bb35a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.8.y/build/v6.8.8=
-229-gf9518a4bb35a

## Test Regressions (compared to v6.8.7)

## Metric Regressions (compared to v6.8.7)

## Test Fixes (compared to v6.8.7)

## Metric Fixes (compared to v6.8.7)

## Test result summary
total: 262953, pass: 228626, fail: 3434, skip: 30557, xfail: 336

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

## Test suites summary
* boot
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
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
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mm
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpu[
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
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
