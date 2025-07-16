Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 652A72F3C1A
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 11:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752666281; cv=none; b=TbR5wIKLt6hppyQ6fycA7sqwAk1VdE/nnR2pdQ8I3h9G/yJZm1vBY3/mc5qwyyHltU/sbUG8nofXBTZqp5/V8cfpCPHxXcXNNdluvsoyVO1VfvIzqHKQeYqqCa0e2w6D6IGJNpJcek8GmJAh2mbczzpkjMvXat3zCvSi4qODPFE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752666281; c=relaxed/simple;
	bh=JnOG6ooJhnbu69xt4DZN9M0n0dNgDQGpilBl/b+s1kY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UipI2lRmJXzLB231izs2xvVh7lELKIJ719Del9T74Q/R9iwS3AAfJWmEeaFL9B11kCyOOJ5fOozfVlMPIKWytUDR4ODJz9GR7c8wQH5iXKhNMp00NkM9QBbrK7O4WMbSPGGypRadFz8jlPGxmsRe7xPeMrSaL+My0Wv7Y7UIA2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=al2KGkhN; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="al2KGkhN"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-313f68bc519so5044944a91.0
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 04:44:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752666277; x=1753271077; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=d9Vrzj9Fu7WIJeE2OnRZTO2T6pseUqFryRb+fWlv6fw=;
        b=al2KGkhNo2oLI/t37d0ejuv4u5FiC2gXn88AA/GugM3VhVb2FcFhspJNN59D6j4bA3
         BJR34GrrPkoQFzTcrvVtuNG34MfbO6l938oDTBcnAwL6Jn7RyQvKYGmiPiMi6h9BAjfM
         zA5IYZ5VoLuH5obZHpVVMj4dpNqUXB6+xQnfABvq4E32Pu0257uyibF7N/vwYkEMCe1A
         urpLj8gWBR8XgE+g2/lXZrKLd31brADKLAo4XH3kjPaQJ+uwRxfd+2twNNrXn9LQ4/z7
         Hw+R7Cbg1PBtTp/FjWsSTrGmryDn5PO2jYprCaZxNW0scp/LVNKy/ZWlDtfgvg4MrfZf
         csww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752666277; x=1753271077;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=d9Vrzj9Fu7WIJeE2OnRZTO2T6pseUqFryRb+fWlv6fw=;
        b=H5IC+4wiEKMP8gmvB1NUZekFsiqkdP1HpYdXUoVWnHJDuhjWMdoltuHMMQB1pL/hpo
         6d3p/Z1EHFfCLAZOH+0vvX8ImatNJt9uQQYuuOZPpb5Q4xKn/ehxWD7zwuf14I1mwl2U
         o5RgUAyyU6hoFmVHGZOeZEHcNuS0kx8Kas+BaSnxj3oofGgnoIiwjb4xEIgdGHOvu+S1
         om83E9YPTbnwAjl2bR05xtg2y0X2yFCUA1bod1PB+kPV58EbTvXHimUoKnCZb0lTsSfn
         tW6Saxa8qUWcBPt5EjbaHZnRV7/GnQiy0BME5NFLHhr57621QXnxj6Tg6ZxsPPvXOEho
         9hRw==
X-Forwarded-Encrypted: i=1; AJvYcCXd5+Ep3ut0lBAJHS3sW7sUrqWRyXjH/MRgoYu9OvDTnewTvKMEYeE7IlFNbo39IGoFyDROI6Ro@lists.linux.dev
X-Gm-Message-State: AOJu0YwvA0Mw7Nd9fXHM6kyYkgcsS2QSQ8XHCoxJx+EJ2eWS7Q0sAxFd
	19HdRJBI6LT6ZLvbq7qV/wPf30FlWCLiq2VuB66xmiEvwSAzbB4EyXUHsVajYCmsLzJSdB9wjla
	LdN22XFZxozMH0WHcPmKJ9rQaF/yzBiIbwmRH1VXwWQ==
X-Gm-Gg: ASbGnctsgEHn9NAXxFRoZ6w99pKt/Y2Jh2QlMtNBsoeZvKhc+BzKKgPiqw1oThVfFZs
	MKdEbkvOdci4KkfQ9BxwSiLPN4MBP/4utz/gC3Y75P0WE7ghNYpI5aparfDvU0xS9i/HRcSK7kk
	PbEq+Vy18bzrO24GFv3QfbuAXNRzzXYlqzKXoTmYiCYSAbqL4LDovDWDV+F+EPWvGqwbk00CnJz
	zAQ9tr4Sat/gHxTvhDPmws+LML7P0X/3coukzxr
X-Google-Smtp-Source: AGHT+IFNEGCm4dlaIj+7IRWJC0AscMoG/Wnk3C9p4eF8l9ElmPT2xzCbzseXHqg93ffcOeAzDsnVK1buOBoIc1vLXC4=
X-Received: by 2002:a17:90b:48c8:b0:313:1a8c:c2d3 with SMTP id
 98e67ed59e1d1-31c9f4a8027mr2910872a91.22.1752666276531; Wed, 16 Jul 2025
 04:44:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715163542.059429276@linuxfoundation.org>
In-Reply-To: <20250715163542.059429276@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 16 Jul 2025 17:14:23 +0530
X-Gm-Features: Ac12FXwh_cyJTG8bELy58HCa7WlN5iVTMr6vUGIj2yM5KVONAlV5bNbRfch_oSU
Message-ID: <CA+G9fYsQdL2XhjF_cHSni+ABMHoe0aDiwV_zyT=Y+-k8ovr20A@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/111] 6.6.99-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Jann Horn <jannh@google.com>, 
	Alexander Viro <viro@zeniv.linux.org.uk>, Christian Brauner <brauner@kernel.org>, Jan Kara <jack@suse.cz>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 15 Jul 2025 at 22:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.99 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Jul 2025 16:35:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.99-rc2.gz
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
* kernel: 6.6.99-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 9e2d450b5706b55c38eae29739b1b81ddd7e3b9e
* git describe: v6.6.97-114-g9e2d450b5706
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.9=
7-114-g9e2d450b5706

## Test Regressions (compared to v6.6.96-131-g7b8f53dba183)

## Metric Regressions (compared to v6.6.96-131-g7b8f53dba183)

## Test Fixes (compared to v6.6.96-131-g7b8f53dba183)

## Metric Fixes (compared to v6.6.96-131-g7b8f53dba183)

## Test result summary
total: 288485, pass: 264299, fail: 6263, skip: 17525, xfail: 398

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 128 passed, 0 failed, 1 skipped
* arm64: 44 total, 44 passed, 0 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

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
* modules
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
