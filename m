Received: from mail-ua1-f51.google.com (mail-ua1-f51.google.com [209.85.222.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A47342AB4
	for <patches@lists.linux.dev>; Wed, 11 Sep 2024 10:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726049521; cv=none; b=f2kUMZiq/wZ2iGwW++VK1TT3cScAtIGsXBwyCpaU1BF1FOMka5JOSw7psXR9WndNW1MLLB7XJI+pNRW32mUfONYxiKmmLPH4SzH2Bchvgvb56vHVxyXO6Xe4hRpWrttf4klBi3tyXVOc0okVt2dbrr8z/rNWf0McqwayG1zi+Ok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726049521; c=relaxed/simple;
	bh=3sEkgfpHqduntg6RFgeF+3GTSNXSlv6Xw1++UeZWWec=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JC048KMPULlB3amtC1g4BNMgJEEslrnmbphGGHV/1OMyGVXvg//zr2e+v3gIHv3HQWZfGf3tHrx0ezz9XMB9jHW3hlb5HhIwj9lQRHtp2UojMUnS9pirXcOWt3rHx4ZbyNW/wt0uUBQn9abcBAo1MIqbdkA6/CM/eyCMq4Etn/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nfrKi754; arc=none smtp.client-ip=209.85.222.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nfrKi754"
Received: by mail-ua1-f51.google.com with SMTP id a1e0cc1a2514c-848769482c9so1854586241.0
        for <patches@lists.linux.dev>; Wed, 11 Sep 2024 03:11:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726049519; x=1726654319; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SGukwIE6cAR699ZYbN5V3VRAP5k9uAR/UmdbxaN8ew0=;
        b=nfrKi754r5hFV7HL2baeV//U3C45+GzuUXxdeqrD4kEqd3vG+HmJH/aito29u1iIsy
         OUjcTsm8P6tWQ28POwYqHhiLPB0PCO4k4ciDVAVRXH6cjMHh6NyfdT8tlQmA+QX0jTqu
         QGS+9EHylaK7jnjuXuzbLkNkCPCF13W718hcwr4RsOmQHXfiIoN6WsH5fagvjm0a7x/Y
         OCT3DxwiTfN3qGtypf68NVz2W/wfDBUlj6+txipj0QwYRUg5G8IpcE5eFjhSm3LMAf+I
         foVmOEOXwlzaI3GG3gIcaF3vn+zpDLumGkgWUWPvBtXf3uk884AK1HAF6Hsdf2Mw/xMC
         YfpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726049519; x=1726654319;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SGukwIE6cAR699ZYbN5V3VRAP5k9uAR/UmdbxaN8ew0=;
        b=Cn0nZxI+Ya2B/mqiBCzLWIytfKCyKkHC4j3pHi1vDizQuZEPPrHQyr2sPArKGtyem0
         9cVjhE3TBY/05GZJgFnR1lLHIwMcRZu24QIJZoVgkiJe5E+AyXKJ0QW9qwN4pIT4ok+R
         nVk3kTEpoeNfzG6PpFQ0AitCdIIXdIKAOFZwmJ3V6oaY42DKXz3tm3wWXQV3bvLoDLm4
         bPesLiDV8Vg/R85C1SUKJFZfBS+is6pKf8YgorrMiz/xElzcz3T9c11sfrst9sZoYcqc
         c6Icb3oFhrpVdKkERSq3W35NELYOIMm9NqLJk93XkduBnN1z0EJOKOkVs374hwqDm2ag
         233g==
X-Forwarded-Encrypted: i=1; AJvYcCWEfvgm29dVHoMb27k15Lz8xLAPM717gqaloz2OGND9tOR/j0qtmLfZjysRy/2brm12S8ceGH6u@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8VJ7NrDoKKf1swVErlXsA8zi/NsMnGYU7W8YjhZ8TNgj1qMMF
	n9BaDULYdxU3MB4Go2j39EFNIiOWY+VFRxjk4NRbhTcUB7OaDUVMV+Gv1KJXusRw/mU/TSxkkhA
	aH1IYNCh2Op9Th0/ye7ctYKG8ccNgB+vAG1TjSA==
X-Google-Smtp-Source: AGHT+IHRN4JqoqecYOHU2H9OFVhpfgeJvKKrYv6fpeH1guztQzOfvPFcs24x7GWZWm9uOMxyFjtddi3otYcynPDQJuU=
X-Received: by 2002:a05:6102:3a0a:b0:48f:ebc3:a006 with SMTP id
 ada2fe7eead31-49bedbf6adbmr10542424137.15.1726049519036; Wed, 11 Sep 2024
 03:11:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240910092608.225137854@linuxfoundation.org>
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 11 Sep 2024 15:41:47 +0530
Message-ID: <CA+G9fYuJF11wVcMyUX6HL6T7OiMf3X_RFrMgpv808KH=UYGA9A@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/269] 6.6.51-rc1 review
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

On Tue, 10 Sept 2024 at 15:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.51 release.
> There are 269 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Sep 2024 09:25:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.51-rc1.gz
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
* kernel: 6.6.51-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 415df4b6a669c6801631bcf697d2e0d8dc171476
* git describe: v6.6.50-270-g415df4b6a669
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.5=
0-270-g415df4b6a669

## Test Regressions (compared to v6.6.49-132-g89740cbd04a6)

## Metric Regressions (compared to v6.6.49-132-g89740cbd04a6)

## Test Fixes (compared to v6.6.49-132-g89740cbd04a6)

## Metric Fixes (compared to v6.6.49-132-g89740cbd04a6)

## Test result summary
total: 232275, pass: 203695, fail: 1992, skip: 26335, xfail: 253

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 10 total, 10 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

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
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
