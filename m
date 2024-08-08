Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81343186E24
	for <patches@lists.linux.dev>; Thu,  8 Aug 2024 06:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723098134; cv=none; b=q7eIgdKNbE/GrW+dcajcUJeTPHfCl6dMP7VB/m5sUC4bOEWaNguXlEkieTvDAHwjdKueHSzbAN+ZTjRM4Owf07opEi5Q8F6agjHGEfOwwzHQFtYOg7hQFBwL/McnEW0RenPi0u7xaoMwNLxJPrYRoMeV+TtghU1Zp6SkJb8mYNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723098134; c=relaxed/simple;
	bh=xTFaZBInnZdFMYLZ8EW2UVlC21HUX6w8UgJuLGOuq5Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nkk36RopMnjWLRzcOgn74lmjdTbUjFWYsed/xdtJqFZnQ0SwIgtRh4oW9dypzdJroDrIsY2NkaFc3hqSGxiT+gbhlcWG+j9yfBuXQPJeM9DGVjZuedo+N2Iv5wYsQ/y6wa/2xChYTmEai7IxnMODPe1UEziNxpf851NsHOzj1+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=jl+KZeXh; arc=none smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="jl+KZeXh"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-6b79fc76d03so3697366d6.1
        for <patches@lists.linux.dev>; Wed, 07 Aug 2024 23:22:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723098131; x=1723702931; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TOOhv84e3ci/vLSPiNDKUpx9o0VYySHRWy5UX3V564o=;
        b=jl+KZeXhptLIwmkFvZNKJIiqXPLiTLYYCnFLGd1KXt4wbRvdMMal0cu3sANNK7Y6eJ
         X9x5U/HG/ApxA27cRd93Om1j1m/6La00El/FEyajt/W/rxD/IpDsy8iq0u21tP+ea2g8
         iCMvNpkRD1hSxVHvttNXjj5catEYFd5WYLNAg+d/201tz7iH9b6iBt9Y5CUR7kmp5Drk
         +JNtnqQvahj+c7gzm3OaiIcMOjzVZQeHChU4Oblv23v2AM2Hi8j1LC6+TRf1qo+vI7yN
         4Y9D7wJ4/BbGiJaMmH/2bXeq5VmTMZXrmZooTBll15aFXRyUCzdqlrrloY5fwpAhhQRq
         j0+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723098131; x=1723702931;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TOOhv84e3ci/vLSPiNDKUpx9o0VYySHRWy5UX3V564o=;
        b=OKVnP0YcFfJAGk69SIW4Io504RLTu9oPp/JmBpCA5sxUvaqAstyrUCpmjm+M/H7GVb
         YRInLuvrwyNW9h2RXaVtoHSfYVWg/d/ngckOe8k0sKgEfZJJvPNXob1KQGR4FwPC1Cqz
         HEtp1TWlJf3HQ2SQowO0R1ewq0MMARE3JV9EfalznI+btx7+3dYowaNInlliGbu8N4mL
         3fQA4cm8hnle8Q9sc5lYN+H7hfWxV2dWFXvXLYxRj+v87Z4PMj/1jRMY+FYZrtRpsrFh
         QUEFIYZXN2p8fyAt4OAGdwz8sdBmS+VAXA1647TcA9vI2xWld2u5A7D+rswiCJATIvTk
         fEZg==
X-Forwarded-Encrypted: i=1; AJvYcCWr4NG+fRmJ5jE7BIirctNpxEhe8wupSN+YsY0FM9wmVbrVMe9Du77wsm8O2F3By93UEyg+ri/ddwcQJ+gVOcNxHO9yQHh+WA==
X-Gm-Message-State: AOJu0YzEudc+XqE5trArBS1geZ+pMzQ+1B00DayxcClLykddi1Bbf6e8
	KbpG8R3Gs5VFvuQE8XEToQvx8hek2oE6uQOg+ud81iq1QSNG84l7WUeZXq6ykYse9B0UZVlFAi/
	Z8yZYKk6yXtbz1AJrqJHs5KHrJ5LYAKtXzB9t4Q==
X-Google-Smtp-Source: AGHT+IH5KoM2u7VQ6jDkwosjxY5EgRMw/ISeIfmQGJMZ8QOd0mef+mRK+wZeu0cD6dP7nWhCg2PiXqLKb+bL4+9Ynfk=
X-Received: by 2002:a05:6214:4198:b0:6b5:ea0e:98f with SMTP id
 6a1803df08f44-6bd6bbd2bd4mr9490626d6.0.1723098131507; Wed, 07 Aug 2024
 23:22:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240807150020.790615758@linuxfoundation.org>
In-Reply-To: <20240807150020.790615758@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Thu, 8 Aug 2024 08:22:00 +0200
Message-ID: <CADYN=9Jb=OEFnYiT7_p+51YASv=53_FSBZVTfRSi==QUx8ZKeg@mail.gmail.com>
Subject: Re: [PATCH 6.10 000/123] 6.10.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 7 Aug 2024 at 17:02, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.10.4 release.
> There are 123 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 Aug 2024 14:59:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.10.4-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 83c63da99a0354220230896215375e1c622a9f18
* git describe: v6.10.3-124-g83c63da99a03
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.10.y/build/v6.10.3-124-g83c63da99a03

## Test Regressions (compared to v6.10.2-810-gdf6b86a465e8)

## Metric Regressions (compared to v6.10.2-810-gdf6b86a465e8)

## Test Fixes (compared to v6.10.2-810-gdf6b86a465e8)

## Metric Fixes (compared to v6.10.2-810-gdf6b86a465e8)

## Test result summary
total: 254582, pass: 222506, fail: 3789, skip: 27800, xfail: 487

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
* x86_64: 31 total, 31 passed, 0 failed

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
