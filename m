Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1867D18508D
	for <patches@lists.linux.dev>; Fri, 14 Jun 2024 08:39:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718354381; cv=none; b=SLsla1tWj8y8zQSCch3+3Ldww2wgMxqzHIF808Hvyi3xOtNDC1iu/FzxU2lGuzersOkux0D3HcR/s4gMukIixk6hljvBmm+j1CZVe96dbkVgZOYIO+sMjnc/gt0fj8iMfaGFAGqk6OuVuSIbFTMHxAQa5OgWLpPWhTD7FIWBYdI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718354381; c=relaxed/simple;
	bh=noR/1BMvTzVYSrf8tR5fjTYvMtZKm759/PkznKK2bXc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gPtgfs+DHMwhh3iHQxN4scIi0IvCOIFqx4FquwVIzSuywYGQi6FzLDffJXI1xvMknnkRVGJUDevORBgBHnn2k/jKRryWVzkAQLAN4WmvYN4oZ6MrFUxiKorelq6YS5Ho4brzm0NHyc/tPJvEr/aP3dLwg3PF1TO0F/XplUcoIFI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=H3ZjqI8w; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="H3ZjqI8w"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-4ecf9ba11c8so682362e0c.1
        for <patches@lists.linux.dev>; Fri, 14 Jun 2024 01:39:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718354379; x=1718959179; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ir/QAoQHBoCJHNX1sblS+j1ISo+HGKmrWSlo79nu2gU=;
        b=H3ZjqI8wOmDZ9y+VT/sXZa1tEzYbWGPNZZcIhxGIfN4CAzGmRfwb7gFeQINmOejPwm
         TSOBJ7K1HlFM2MmATx3vDc6CAIgqHStWmhzWnOng940s+1eDNVEx5x0sSEzeG2ceqLTs
         KV558+fQg3ELjTPWkt42icpqb2kQv8/e/yjCiXv5iGXm64PoDOFgLRIr3vL2yqpF5Tx6
         JWH7YFOP7yFUZ15wgn2AnwLr0MX5CLql/O9+JENhVi+rSz3/32V9ruj+Nuyk4vVPBEl+
         NkEjjjZqGGj9r+M1AaPlxfOd5ribMj5+x7Ew+/uaiNTqIDrULu1Q7ykRQFg6dfiGIzD6
         Tvjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718354379; x=1718959179;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ir/QAoQHBoCJHNX1sblS+j1ISo+HGKmrWSlo79nu2gU=;
        b=qOXKtTbFr9R2F3mt3gRSb+vyisHmWM+tWO3qZQ75prp5VSIR3vsllFvAwa3ijQU4jT
         3CdzVvN6iiF2LQPTOFh0vLgv7+ogmfav/N3FPWCuap8lM70vZZ9m3flH8pyL9TsqzyZQ
         j35PvNUuRiE1SUR7I1nPQa+GXLgJ2MwbsbSTskSyOS1MqNo6LeSNE1pycod1HWPROz/G
         2Kkiz8RF4NzWPr2I/gkIgjwpvb34Sf6fS4d/9NSwKSoDP1K/0ZJaeH74BBRf3FB/vgiF
         jmsAvFKkxIMlk3ARkOv4tJENTdmlvC0N6UFT3+C6JKBeVm3Da90g/Kz/NTSKITH/p32z
         207Q==
X-Forwarded-Encrypted: i=1; AJvYcCX11w4mz3YBlMrMABpeNT36RfejcuyVCW0gSHV3elDXnmijxg9MKZsHujbkQDavPfP3KXs+3lsV9TcM060aaBPTCAwmAq/9FQ==
X-Gm-Message-State: AOJu0Yzg1VpFdgKLxz47F12s70TWkwozCoMu0h+6GcFFGLWzjLQRCSCG
	gWNk+p/4KP3nMTOqgfEh5bKuO5KcYK6APAz9lSfXMsdVD96m6aAgyZ9IGFGikdWANyBWKXknjMQ
	5xZ9ciQ3gf8dpg/2VVYN4at5Boenhv34g+VloyA==
X-Google-Smtp-Source: AGHT+IGTQBRS9QzBmr/YyWpjkaZksUQtyI4an2FgWafCDTm+liAlDrd5evYeKtmqo3IMmj2HEknh124/H8HUrJMmL7w=
X-Received: by 2002:a05:6122:30aa:b0:4ec:f773:209c with SMTP id
 71dfb90a1353d-4ee3fe42550mr2397495e0c.14.1718354378898; Fri, 14 Jun 2024
 01:39:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240613113223.281378087@linuxfoundation.org>
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 14 Jun 2024 14:09:27 +0530
Message-ID: <CA+G9fYtj6+LNNfg=ds7_b5KLP2kKSqXwPOYc2bV1uL-ZGHtJdA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/137] 6.6.34-rc1 review
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

On Thu, 13 Jun 2024 at 17:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.34 release.
> There are 137 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 15 Jun 2024 11:31:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.34-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Build regressions on powerpc reported.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.34-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: 8429fc3308da68760efb0f6acfb80b41eb2f7532
* git describe: v6.6.32-876-g8429fc3308da
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.3=
2-876-g8429fc3308da

## Test Regressions (compared to v6.6.32-742-g7fa271200aef)
* powerpc, build
  - clang-18-defconfig
  - clang-nightly-defconfig
  - gcc-13-defconfig
  - gcc-8-defconfig


## Metric Regressions (compared to v6.6.32-742-g7fa271200aef)

## Test Fixes (compared to v6.6.32-742-g7fa271200aef)

## Metric Fixes (compared to v6.6.32-742-g7fa271200aef)

## Test result summary
total: 129650, pass: 112601, fail: 1079, skip: 15843, xfail: 127

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 37 total, 37 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 30 passed, 4 failed
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
* kselftest-membarrier
* kselftest-memfd
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
