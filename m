Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C864B1E50E
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 12:30:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748953854; cv=none; b=KhJQtNuFRQVQ/rJZzT6dscvgGtBSBFa5b10IqRUNGRw1tbieXgxDu71M9ofnzwl+QXZr8oeUs4FqXrrgkYjTva22FvV0HKC1tyzs95PCuWuXiqwS6+NRZgGMXGbT1wRhmeR7lTLz7Cb0xNZ9TgXxbQ7rx70uqQrdTszMzwD2S5I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748953854; c=relaxed/simple;
	bh=EmQ/A9vSfKWWPB/K/T8g8cr639C8K9rcW3d2OXMslYI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aesNTVU8rmMRXDLz3ICXbmtQaXxjMSDAwjOllsG9Opn6U6vY99YLD+WXHCROSFl2C4LxTfPuAmdASt9g2mosN3tgS/+s1/zfDieaLQTr3ZOa4axJVWNVUxju1sAWX01eg0QwSgnMnZg/j+KK8R5amLLqIItHqekU6MToP/w+VbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WSQpRvew; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WSQpRvew"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-52617ceae0dso1954202e0c.0
        for <patches@lists.linux.dev>; Tue, 03 Jun 2025 05:30:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748953850; x=1749558650; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LY/1nUmGBa6dpDChrxvy7BQ7e4yIy3xA/coyZFocW/0=;
        b=WSQpRvewFw02h+P+4BmYCnuGYZWKbUpduDn1s3lzO3z9PHZQfVP66ilmYYMCHngVPA
         IXt8CGqOzUoTPVm1PDrZK7QjNPSVyQJ49UVl333I7PVOn2UcZHKXywYsRZMaMI1hN/VR
         oJCKZfZweV4poRQIzXtO9v4M+HzTBsd6L+67QmckO2ATzvzBzI5cuO6EVkeGf7Nov9Ol
         yIAFdNOn5g05ikYvGiJytogqJpPyEitIGRHXul+sRejTSiXe7Ie5OK8S25WFIPuYiKZd
         6TGqvfoA6ewVmFjJfz9qTnnqHpL3lCpEaSs/eMm4qumtCCn4eaL0aaCmju+YEW2grCPK
         PIsA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748953850; x=1749558650;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LY/1nUmGBa6dpDChrxvy7BQ7e4yIy3xA/coyZFocW/0=;
        b=B/Let5m+gqE3NoLva1/h2m+K6/11BHmYjSpHTEF2zM5ZaXj/UEH+22Xt2gu1uekf4H
         hBY4Rpkb5EGuT+/7uFXq4CBh4tUlYcn2hNTbjnwj9kCoLs4ZokqaPuWgXEEcGtrOOZQ3
         hHGJaAAmLnouj6z6o4UVxlYY9Y+CQZ+nemZIO2TGkMp5w1Nu+Yfyn4yJUEMh7GACEmSM
         oW+fnp/TCEyKoaL0nH9zLPDlYuz+GPZVQulOwsAT1XRO2WZEOU2rpYM14bEw/Ky9kT+9
         QWsLtGsccshlUcboBKnT65+dDGvGwrGnrCHwRImPEZ9/8qcvM5ejGyeuQpSYWpE/kszZ
         T7Jw==
X-Forwarded-Encrypted: i=1; AJvYcCXCrMfOXLVEhz9W1JuxsZGHzDjnEgl7IVK5bF+IhbfPNNPsKSLimd6062aqEmy5eiM05w9wE4XT@lists.linux.dev
X-Gm-Message-State: AOJu0Yx/U1lntQb9eXXuYBaWhOZDNHUuS8nmuvlEdNVI5GJbK6AhdJeh
	XWsQi3E4Uq6oKQSz7IBXeUQJVF+8TC0R+4lQPJgjPdoesq1Vqu9rS6voTL/6FHichyScDj99Zyh
	BiX4Fc0fej/kXjkV151vxHW/a6RFBSeo1fFu4FWd5BA==
X-Gm-Gg: ASbGncsGW64T0d7GPJfcYenoGAz/huk0RPLN3bGo7pmFrQJiZ6/8KNOS8FamSGPQbKz
	zaY3pDbCAE81roayVp/qjZeLXB2TQeRrJdF2U29fuaaoSTxbuh4DVNqkleeONrVMz2DnXAqRbuz
	eaEl6z52OymcsbBYJuvntaVNS8ZldNR+8=
X-Google-Smtp-Source: AGHT+IHTosQvOBKF0L3D0Inb+MoWZZ3cSRXCp014dL+KqAo8fezAvJU5scdjR5Ga9Sawg0g6JBdjG2QGVG+FJzLfAfg=
X-Received: by 2002:a05:6122:1ad4:b0:52c:4eb0:118d with SMTP id
 71dfb90a1353d-53084be0280mr12838886e0c.4.1748953849537; Tue, 03 Jun 2025
 05:30:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250602134241.673490006@linuxfoundation.org>
In-Reply-To: <20250602134241.673490006@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 3 Jun 2025 18:00:38 +0530
X-Gm-Features: AX0GCFumOsdVyieNJlmgoVB__zbTkcpeuCdAKy4COLBbvEc6SfoIbneNR7OPeWM
Message-ID: <CA+G9fYtrUYsAtZgJg4b8ZxCUzWmekp9v0USDVC5dKgZ3XNe7UA@mail.gmail.com>
Subject: Re: [PATCH 6.14 00/73] 6.14.10-rc1 review
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

On Mon, 2 Jun 2025 at 19:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.14.10 release.
> There are 73 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.14.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.14.10-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: d9764ae2492695b2e87e4cd07bf1c61426d3693d
* git describe: v6.14.9-74-gd9764ae24926
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.14.y/build/v6.14=
.9-74-gd9764ae24926

## Test Regressions (compared to v6.14.8-784-g10804dbee7fa)

## Metric Regressions (compared to v6.14.8-784-g10804dbee7fa)

## Test Fixes (compared to v6.14.8-784-g10804dbee7fa)

## Metric Fixes (compared to v6.14.8-784-g10804dbee7fa)

## Test result summary
total: 332025, pass: 306599, fail: 4596, skip: 20041, xfail: 789

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 22 passed, 3 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 48 passed, 1 failed

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
* ltp-ipc
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
