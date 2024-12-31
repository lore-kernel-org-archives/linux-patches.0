Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63BA7194147
	for <patches@lists.linux.dev>; Tue, 31 Dec 2024 09:39:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735637954; cv=none; b=hsppPwIuWHabu9I+MwA/su0bzbAYGgv9FDwGeAhnvdoRtBZKl0B8eNVkW3ptBanTCpp7ijIp0JDsdbLTfAqcRY6Kvm8j/DokkzdqfA2/dMXjCu6oGmLDz4Xa9FFMRXcNu81IQE1oykzQnIaB8z2MgbyRoqqmzTuD3ZCtt26kv2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735637954; c=relaxed/simple;
	bh=JubYt5Kao1ifQYg6uWKODwQ7U5Ert4I76DkK/0dNFPY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=PqZn/cDAHEhKAQ4qtI5IIgvrwt5uYE1fj/rGm3kfTfi/kLTdGA+9nSZAxfpesj0tPuXsKEIbd/itQclD8Ya88JmTc3DOcmtI/06oi31mPkZkDtGXCvddYidbdjyGlLmQdxyUpST3keoqgg7PcK95GwZfND0N0Vt7cAn53myUrWo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=EetqdMB/; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="EetqdMB/"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-4affd0fb6adso2684405137.1
        for <patches@lists.linux.dev>; Tue, 31 Dec 2024 01:39:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1735637951; x=1736242751; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tSAlkebACWYAyq4hv5CuWrWBuC4EK+CgRnFsGwGaXCU=;
        b=EetqdMB/XnOXyCYWC1+Ii6PGKZnzXFhB9fFbY4dX+ZHGkH/AzFRD0jiX2RiAzDuk2N
         gPgBzaE/SDqTVjhKFIXD9rtQHoUQbg0UX4u1dIzM9eoyQRj/6iLStBYfKxtXZTeI+w9C
         P+m4ZZSPktmch0XoSPAXl4zmpZZnWBJe8PuQ8tmcwfNvJcs7s1Vt504HmNF9TbRNuz3n
         mu1VxL6fft0RN0xCx8nge/nURgxn8BRIDUSJhglDLdn+qS01++f2iKPTWjskqyaTYlGJ
         1nEqUoKLKYTWTByax2EST/L9r0RdlqxP8d0C55dGF3b8y5kS5Jl7DRoLXf1mdzuJP7GB
         lAVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1735637951; x=1736242751;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tSAlkebACWYAyq4hv5CuWrWBuC4EK+CgRnFsGwGaXCU=;
        b=YhJfiwIxH4c3ynlEhKLU3NR9ljGrFT6tqMpkGGL1njCHDAf4wJzYGYiIaPjazFKnbB
         Oxal3T29WRSgX2RcAgPR4XOOrA/UpWpPtDUiS+j1Fu3hLeEpUafFNZVFL03XEzizoNyA
         ovPw82JGp0uIvLIL+FO7KopXLmBJRHF3Xf37G4w+ZvoMsW1wLQrndZRmi5mUDtPC9+Po
         wKbrDqETYiw0rVnN7qo8GrOMacA383XIF9XcBmEwx5JlMwjr4FOP588dU0TNpusnqXp3
         PHQ5zCwoLJN8Hui9De3Fg7s9XZWJco10AiqacaY4uS5B6vvV8tngVP4qDoFJGzdkDLA3
         qWpg==
X-Forwarded-Encrypted: i=1; AJvYcCV5tztBU3o/wARQ1naVKiP+mLxgsf8AfM4dcqnN8+WeE015jPoQCksgK5Zz1W4Za8arU5CFKlLW@lists.linux.dev
X-Gm-Message-State: AOJu0Ywop8ZRbLkF481OaobGYzxeNqG4urtmjF14BBHVWA6aN7O9wRzw
	UGPPx3ryH7Qd2K5FVlAAHcP8af0V60AyAAKjzGVKyI3erc6KTu5pm1vPvUKKYKSciMfXwI9kO3G
	JaMjEu5JKiUCVKk1b22I79D8HmJIwzGW8qjZNrg==
X-Gm-Gg: ASbGncsYsjkN7Zr0Oy+wnCyJowhrwkoyDb9ZsbIxWnoyFUSWpGIBWchYSLnReF2tuDv
	AwmN1nEPaHlhbUnsGlqPrAwMNAQC4N6wD1mGCwlXkCdbECj+PeM4d/79kkQ1DcpTgwbKBU30=
X-Google-Smtp-Source: AGHT+IG6JtQQYGEhtHg+sejplvyBFrH64R0XhcG9R43DjsnokYo3SQZfkEyKgw9EUEajCF9/J2ghflLjB5Cflu60NZg=
X-Received: by 2002:a05:6102:3f0f:b0:4af:f275:e747 with SMTP id
 ada2fe7eead31-4b2cc45dc5fmr30675406137.22.1735637951195; Tue, 31 Dec 2024
 01:39:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241230154211.711515682@linuxfoundation.org>
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 31 Dec 2024 15:09:00 +0530
Message-ID: <CA+G9fYu+yy9g1McuZmB0TfCOAQBg3XiS=eo9Cm=21imciqFvMw@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/86] 6.6.69-rc1 review
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

On Mon, 30 Dec 2024 at 21:19, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.69 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 01 Jan 2025 15:41:48 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.69-rc1.gz
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
* kernel: 6.6.69-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 159cc5fd9b139e65594480f46bd2c71c7caa9f19
* git describe: v6.6.68-87-g159cc5fd9b13
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.6=
8-87-g159cc5fd9b13

## Test Regressions (compared to v6.6.67-117-g6a86252ba24f)

## Metric Regressions (compared to v6.6.67-117-g6a86252ba24f)

## Test Fixes (compared to v6.6.67-117-g6a86252ba24f)

## Metric Fixes (compared to v6.6.67-117-g6a86252ba24f)

## Test result summary
total: 147184, pass: 120768, fail: 3602, skip: 22739, xfail: 75

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 132 total, 132 passed, 0 failed
* arm64: 44 total, 42 passed, 2 failed
* i386: 31 total, 28 passed, 3 failed
* mips: 30 total, 25 passed, 5 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 36 total, 32 passed, 4 failed
* riscv: 23 total, 22 passed, 1 failed
* s390: 18 total, 14 passed, 4 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 9 total, 8 passed, 1 failed
* x86_64: 36 total, 35 passed, 1 failed

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
* ltp-capability
* ltp-commands
* ltp-containers
* ltp-control[
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
