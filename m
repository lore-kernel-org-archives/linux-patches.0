Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 555E230ACFF
	for <patches@lists.linux.dev>; Fri, 28 Nov 2025 10:17:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764325026; cv=none; b=W0GgbV72tVb0a9DbtCkakJDvbqDszc5rliWyH7+XMEUtFYRdjayNAdO8KAHl48w1vNKz7rQP4SnFUeuPx8ab1dHA+zLda9ZQq8q+do4XcFTcieucZAQvHzxq5wyPgF+uAiPF4LcEmVtw5WamBRBA8dQ26R2VJz1LKuMOuKcqTGA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764325026; c=relaxed/simple;
	bh=QquRktftMDvcyPma0rgUuwljbaz7NC2huRrDAGenAys=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R+yAxDithPDFHVWIdL9YPu/5pxGki7F99RbOKq13l9Vo13GVqitNuZSuXj6UszVvoTcRJU76ba3dkfA+YMtZdWV2VmRYE99JD6tegqOVw4Fjk5RriMuXVMrK4n9ovKnTm0KpK7nThKP+TnILJx+BHebKJSUbOfkAelhPvT93V9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=e3bQVBU/; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="e3bQVBU/"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-bc274b8ab7dso1233153a12.3
        for <patches@lists.linux.dev>; Fri, 28 Nov 2025 02:17:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764325022; x=1764929822; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+PZx5wsg1ZjQV3drbiLEd5LuhaofaILeLheoeksBG0U=;
        b=e3bQVBU/4cf9UKbRlI0d4Yyn6v7GV5JItkvNrH5cVi89C06Eoquot5QUJdpSDlsovg
         DB9pW1YG8keSz/osskYyg1MkgT1Kuc7a/62diBLKbimFZ86cDb9uJDN5SgpX4CTPBSF6
         TuSnfzKbWve8cYPG5xkwXAK8TH3eC2+Y37ljEMV+OO7DnjBvlRLSKQPVirNL4xNGkWoe
         bW4Nuzpqhwr1NbLv/a1rCnh9RZA82k0zQ5DWkDzlpVDqoBJyFxkiyj4zVJhda9SnZANT
         WhJ+s//HGbQed7Zw5R0c638cK+nCA4lM/IEVXp1CXRGRgrD4mzjLD3FVdQY0459Tp3NU
         MsPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764325022; x=1764929822;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+PZx5wsg1ZjQV3drbiLEd5LuhaofaILeLheoeksBG0U=;
        b=XFIo7xpmILKJ3qE6jf/o+dkPawoqDD3EhU3v73qK4D6cCp17vkqCTrHTuE/Moz7q4u
         wsOI98fTbzPooMH1y7kCYC6GglFr7G6pbmBV16MCTXF83jyc6dQ3/EW7LAM+OVLbSyQx
         BcKMZjoBSmVIW7g4euqKvGvOViFukEeU0NThcm9valelg/SheRrAeCzgisd63Pcj3fTc
         OoiUQuGOvjNsRUFno7NmKhK88hmMAXeb0H+zFbKbPen5dP5WS5HgejsPfE0qLMJ1y3D0
         roOr0FUDbhQgrg9/Hr+AVZmkKEH7grt9Qozpj7LubnWY27awCl0JqR4pRSiZrXcNhKwm
         NKKA==
X-Forwarded-Encrypted: i=1; AJvYcCXbhOjFHbbOBwFBPwdzGPoM9+sR1DeCP928eJooG2hCwMVucQylfhu+W9BUd4c2lS7HfjWMYv5K@lists.linux.dev
X-Gm-Message-State: AOJu0Yy596c9XB+5mQoODKMofSo7Uw7WtCzCWSrAraDzgwrrF/7AXMWu
	msA0Blp/VWDAjQmj0xe3VPCLtJxRsEjpZK/1WwrISpCBn8ypBeLj1U4QQqR5EiTBACW5QOjczfg
	Nx0whjcfF96xmKqlcXV7LAtWsWv4tq9rUaHT7znooDA==
X-Gm-Gg: ASbGnctnx/aA4W1amW7J7UycA7ASgaUhHYAGEgooddN3ztbjKSqBnI0I/FQWcSohWc/
	Sn6t+ZRmAHHfAXcdfdm/cNmXwBzIDIfu9x/RUZrUKnfKnFLyciOyQzpFMaWsw6CtXIne3UPUa+1
	ZkngGAo84q2Z2tCPsjGU8vUZEG0f5pMn/SojCWckY2EmPS+jMdxmIRRSRbP/l2i5L6ERRzbwIKW
	VamyPkmkm8UooPlvheqC7cU3rkfoUEHPXXr3KUyP321tD1ReMb7umxcqCQC72atAxiRIr441YpA
	G+xDZ9mS8PY4ygyiRDZim366IVr/
X-Google-Smtp-Source: AGHT+IFkfDhWTIRrzblzepZhf2mvoytgKEvlWQ48hoDSQZDK0BMZE9C6ONFjiW8+oMVF8PBppQiFHhVZohcSqMDBwNk=
X-Received: by 2002:a05:7301:454b:b0:2a4:3594:72d5 with SMTP id
 5a478bee46e88-2a719097d14mr14878135eec.4.1764325022285; Fri, 28 Nov 2025
 02:17:02 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251127144027.800761504@linuxfoundation.org>
In-Reply-To: <20251127144027.800761504@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 28 Nov 2025 15:46:49 +0530
X-Gm-Features: AWmQ_blc5AuX8Px43jTHOo2pbTMLgPe0X745nDEbFhaJtbWb4C37gjUJknNf5Ic
Message-ID: <CA+G9fYtzvOZcMhSq_X5frUbQpwO1F-pBhLgOPSQfgvFn2HaWRA@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/86] 6.6.118-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 27 Nov 2025 at 20:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.118 release.
> There are 86 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 29 Nov 2025 14:40:08 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.118-rc1.gz
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
* kernel: 6.6.118-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: dd9a47301c80082e76fc28ed62e244e42f43a772
* git describe: v6.6.117-87-gdd9a47301c80
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
17-87-gdd9a47301c80

## Test Regressions (compared to v6.6.115-563-g69eeb522a1e2)

## Metric Regressions (compared to v6.6.115-563-g69eeb522a1e2)

## Test Fixes (compared to v6.6.115-563-g69eeb522a1e2)

## Metric Fixes (compared to v6.6.115-563-g69eeb522a1e2)

## Test result summary
total: 104988, pass: 88831, fail: 3183, skip: 12696, xfail: 278

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 128 passed, 1 failed
* arm64: 44 total, 40 passed, 4 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 14 passed, 1 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 34 passed, 3 failed

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
