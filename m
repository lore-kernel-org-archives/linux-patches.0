Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F099B23750
	for <patches@lists.linux.dev>; Sun,  4 Feb 2024 16:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707065887; cv=none; b=jaaUYPn8i9wqkMDUjU9sj6goiXYHr4Wa1ARiGQvPaRC4VKz88SzQN/tXgurZkfNn7S6h7wMJdYHtN/AuAof8Vi9kYR6KwNCl6ZCdWdiFV+Ao5kmwfHOG0z9gdD0GBxnrdbTkIU1YIYxnRKfHUfGp5ZpkJ+A06johAgXoy8Svh5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707065887; c=relaxed/simple;
	bh=IuTP+J3Y35zedBXGGOlbZsgbiGFUnU5q+tKuIf5u0v8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bRxWJo5XKPboJ2kb+lJxZ/XxZe/gp2IyKqlq5nyp9cTgEJ/DHrujHCrNjrJNsQpfYKLuXumgPhkUsJHmYA015TrGEF/3yJQPT+3cm5W+PUS2ZTGfIkbqMlBUhLCYd/43Vxx6ohYtDANVOtjKqXZglUlE6h9i7r0mKvyxf7d1sco=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XrF857DI; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XrF857DI"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-7d5bbbe592dso1856387241.0
        for <patches@lists.linux.dev>; Sun, 04 Feb 2024 08:58:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707065884; x=1707670684; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=b8XvHeWqXLXOzR1av0qUjRtuCxZWJXJt2cLmpLDy0zg=;
        b=XrF857DI3M7BHUpUOJR/W7fQHtIhdZEU+JpZMz6kHEKvBY50CjFVX7IrlL0rUTeY/l
         i+iaBQ9EkDACeLUocutWiJJ33ThVLezptE5Bx9uq1SYuWioom+bBKBqkdg3vpdMZ1tcf
         GAp2qgZjKqKzh8uxp2VbwvTci5PmMK8Gt5ZKEL/wzXGueCnk2+3mMkzc1MFiCiyO7M63
         vH1V5kmbawzEa5qjVH5UhtRK/FdewhyHaN6fS7aqGNSBFRtwZlH3QauQ2srKgXK5Ls1E
         hoRH3MATkUEVX0RBotUtKIKnvDDrNM62zE4SW/UvQqNIHxcWGwPmAaOUQkSkX12viVia
         JJzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707065884; x=1707670684;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=b8XvHeWqXLXOzR1av0qUjRtuCxZWJXJt2cLmpLDy0zg=;
        b=aJeHxafhruFQG18xE5yt8vDDcfPzSXpKmUefe+1gpkWpNGRHHPRwGBdHa8FxOvBKY3
         doMrFk/vH6si24Y3JrlI3MhbUVNYky1kDDoHgFfdtya8+Z0URRn8JpvxwGB4ckgVGr6X
         vgT+tE2peTt6nHOPt4VTE0aneFw0M2+xO7nzjwn6O41R+KeDN6IQ64X6AjHy7ws7XJa1
         Al7kkiY9uOurmBYOwAmLZnN6ojJhiuU7GIhuJ4S+0b2q0DMASEAiwIrImMN9kZ4V/KTL
         90Rl6yC+nS8yZqrvCqhWKWIMt+IukF6QBKmubykDiedMSM/4ozkZIevSSlIkcBj6l2kX
         QN9A==
X-Gm-Message-State: AOJu0YymBIW9mggkN3ascTdXfOmlZZp6I7EEBDtwZ0bkUtjvGBq0rFNp
	pypfV8ADhDEAZY55TdDFnsb9A36gKf5J3wm66xhiYKrDrpcDHt+FAY3XRxxrZKtkRoPaGEh6y7l
	45/BK2KrfjQgs1bJCoId9/REaE/B6PbWp1ZEf5g==
X-Google-Smtp-Source: AGHT+IHEsRB/Mqs/FoDCyqXrIjS1/UK0qIRnrPqn1MRy6XCPhqYEdBs7AUMEkpcSt6P8sei/I7o7vPk7kXgzFvNQ+K0=
X-Received: by 2002:a67:ad12:0:b0:46b:3a27:9895 with SMTP id
 t18-20020a67ad12000000b0046b3a279895mr12110278vsl.14.1707065883820; Sun, 04
 Feb 2024 08:58:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240203174756.358721205@linuxfoundation.org>
In-Reply-To: <20240203174756.358721205@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sun, 4 Feb 2024 22:27:52 +0530
Message-ID: <CA+G9fYt2je2FKwdgm31isfxF2xm+HAZ-+vfwmiXhS2SpdBGLFw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/221] 6.1.77-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 3 Feb 2024 at 23:22, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.77 release.
> There are 221 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 05 Feb 2024 17:47:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.77-rc2.gz
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

NOTE:
----
Following Powerpc defconfig clang nightly build errors noticed linux-6.7.y,
linux-6.6.y, linux-6.1.y and Linux next-20240201 tag.

  error: option '-msoft-float' cannot be specified with '-maltivec'
  make[5]: *** [scripts/Makefile.build:243: arch/powerpc/lib/xor_vmx.o] Err=
or 1

We may have to wait for the following clang fix patch to get accepted
into mainline
 - https://lore.kernel.org/llvm/20240127-ppc-xor_vmx-drop-msoft-float-v1-1-=
f24140e81376@kernel.org/


## Build
* kernel: 6.6.16-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: 8e1719211b07ef9172b231100722f54ffc23ed27
* git describe: v6.6.15-327-g8e1719211b07
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
5-327-g8e1719211b07

## Test Regressions (compared to v6.6.15)

## Metric Regressions (compared to v6.6.15)

## Test Fixes (compared to v6.6.15)

## Metric Fixes (compared to v6.6.15)

## Test result summary
total: 155032, pass: 133733, fail: 2219, skip: 18908, xfail: 172

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 146 passed, 1 failed
* arm64: 53 total, 52 passed, 1 failed
* i386: 43 total, 42 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 34 passed, 2 failed
* riscv: 18 total, 18 passed, 0 failed
* s390: 13 total, 13 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 48 total, 46 passed, 2 failed

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
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
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
* kselftest-vm
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
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
* ltp-fsx
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
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
