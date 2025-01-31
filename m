Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E5161E2847
	for <patches@lists.linux.dev>; Fri, 31 Jan 2025 15:26:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738337195; cv=none; b=iH/Vt8FrqY0oq5dzjZmASB/PT65YUTWI2nwyiCd/QSXIiQXW4Nnu4TsOm89sgOBXpMmXefULfNjSxz3seK46ZcJKp1ypUp1/NyS9uUcPldVVCHoRWjHLnutC/ytb+9NzYSpguD/vjVkDWUkhbk3ORtgT9CYaBOTgsGoiVHOSmgU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738337195; c=relaxed/simple;
	bh=3/0Z77qweBYXBX/5/H9DIfK+cyaNahHPlntmh0VmQWI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pKWsfNiGayQxSNHovfpSvs5xVRdht8uik9NOcxoPUDxaK/3C+RqmZOELi+FhRhRi/lnczwjFMQzQlWoEJ/dC0m59R6+t8WN2TEJblzx/E/GvDTA7PDde7keRggGjNrEEjHOEUB2BacyrqmHy6YyS2EqJLGDx3d3MXnnXc11jN70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WADzsuOQ; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WADzsuOQ"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-51eb1818d4fso1090408e0c.1
        for <patches@lists.linux.dev>; Fri, 31 Jan 2025 07:26:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738337191; x=1738941991; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oP02GWgqIHMyU6iy1+uU8QTBLlREt7y8gx/+g2WeozM=;
        b=WADzsuOQfNAG5My6ZR9e/vT+QLsNWhwAKsHTSTkDNKMjE4hJYJlw1DQbkh19s50pV1
         LelVc12B5yWTpZtDj7TOOEJgtQ9kCr/YCxPXtLodXTJsG9rDR3WJ/dbmqIFRmn7emH0n
         rBy5CZWGcKF/BiFrxBhmaJX8gZZktJjdS6UyMLB2kmRO0QQ3d9l0VgrVmafyuZIIdsb1
         ls8YNFhnNWXru4jYAzeHfZavlhYeQ6AAodEczkZA6FpEVNlbgJsNdXiKO1Dg+TJQjA06
         jS3LHK2QSpXd93hWc2iZhUS76+yxPAWwCEmKEk10y3pYdvBqMTNiKKifbOccCbtNiV2b
         9n5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738337191; x=1738941991;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oP02GWgqIHMyU6iy1+uU8QTBLlREt7y8gx/+g2WeozM=;
        b=J5f3RxriTN9mDA/4hZX6Ph/hP2BDgJ25JDyVlFTQTUIPZn/5okm9Yid27+1Exmt/XM
         rUj/81Mt6li9hrJ5TFtQtWFm8Ilf8u2sg5yUwNVP9aSIu8BT2hyTA/ENdseEETlS5oWt
         tgWIeLVeCWrTgvdbT8vWb3yUYTt5oZ5+3M0LPlL9NAPYJ2fYIFj3RLf/w6Cj+jphRPw6
         FKxP29rgva/4qSYeGBNfwa26wv0yU+wvdIvlimoK7F4S3wiGG9YGpdYzx+FRKVhRE9bl
         Hg0dAgsYQTc34kIwkKQLLle57VGgRC8rhHG5s94ZDJJ2J0v+hamlFGNFe+xieC3woP/i
         CB7g==
X-Forwarded-Encrypted: i=1; AJvYcCV04ciU2Hv9zAORvSq682xm6TC17i0HqJrsLetZ/XARIj3QE07mA1DAxIhlPBYvAslxZEtOfFID@lists.linux.dev
X-Gm-Message-State: AOJu0YyKsWye+uPF3BImtxpMcn59f0eNRymj8uB/NT1I4voNfyLIhk4a
	/e3aeZi9Ljatvy16QAtnsv7IjJn4tEeuNBT4J67rsTB37849XGruek3KyvSPwL7bJhMVSDj5b85
	ZC+ZRJzUEv9EJf9bSXjcApn1dEUnLbS2kBlfLrw==
X-Gm-Gg: ASbGncvKDHpYYQmFYTPjEtenouapURKWtJv4nQDmg5+ZZnMewj1fjpN+0QdM5xer1MF
	CYS2piZ7yCj7vW2hP0GcEOX04g+cGvT+1xkkJ+gFwfr0LnSx19MX2dMPaRqTOL3Gwtek60mXugu
	f8NkZr9XiY+EyKTcqXU1O9inEetXXjuw==
X-Google-Smtp-Source: AGHT+IFgSGqRhIR5UDkU4uXh2hescc5V5Oe2OHITJF+o8P44rEboqOBh7//gL+OkBKaqq4UvEZ+nHMcZU6F/+DOPZa0=
X-Received: by 2002:a05:6122:3181:b0:51b:8949:c9a7 with SMTP id
 71dfb90a1353d-51e9e5161abmr9914263e0c.8.1738337191443; Fri, 31 Jan 2025
 07:26:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250130140133.825446496@linuxfoundation.org>
In-Reply-To: <20250130140133.825446496@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 31 Jan 2025 20:56:20 +0530
X-Gm-Features: AWEUYZmkQ1oz6UEbIN2VKYgUkkC8BVz0VFI7lE0Z7qDu76LAGPpLTFiEEL0CivQ
Message-ID: <CA+G9fYtVGFBb0tZzOYSuF_V7xmij7GUZi5Sk6L_h0nOh4G7MNg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/49] 6.1.128-rc1 review
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

On Thu, 30 Jan 2025 at 20:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.128 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 01 Feb 2025 14:01:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.128-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.128-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: da19df6ebb6c09ded78f67e201f202979c1a5727
* git describe: v6.1.127-50-gda19df6ebb6c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
27-50-gda19df6ebb6c

## Test Regressions (compared to v6.1.126-65-gad6747190c53)

## Metric Regressions (compared to v6.1.126-65-gad6747190c53)

## Test Fixes (compared to v6.1.126-65-gad6747190c53)

## Metric Fixes (compared to v6.1.126-65-gad6747190c53)

## Test result summary
total: 108475, pass: 71884, fail: 19274, skip: 16867, xfail: 450

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 139 total, 139 passed, 0 failed
* arm64: 46 total, 44 passed, 2 failed
* i386: 31 total, 27 passed, 4 failed
* mips: 30 total, 25 passed, 5 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 36 total, 33 passed, 3 failed
* riscv: 14 total, 13 passed, 1 failed
* s390: 18 total, 17 passed, 1 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 9 total, 8 passed, 1 failed
* x86_64: 38 total, 38 passed, 0 failed

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
