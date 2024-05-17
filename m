Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9018374FB
	for <patches@lists.linux.dev>; Fri, 17 May 2024 10:25:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715941558; cv=none; b=ksrY8FzSg4wUF20hswxfE+iuPhpcC+VJKQaXHMZZdl3NWMhjyMhnGHBuf2671fHJFlkBjY+MEPsDcKEvATq4b5qBlH0m1fGdYhlb3Sb9jHYMDNrlwHCSomU/5UuWUyTOOYdwu2BaKYRZgqj4OfiWKYAjN/RbDCV9H/pFqQdbG3c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715941558; c=relaxed/simple;
	bh=9RhA9rC2oBfCPn+uO5IsICYCEmPPeGE/qi2FoW4MRAk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=vDreSt4c1GQAixpqjsqijjCTtgAdXZ+g64Ysjh13QJPjhfLs7pC0XK2BCVs1/LtHW98rotyUUD5ouXWdu2UN8zwVYIzCtCOj2u/3o4p7W/wrvCdCdJrx26NUrjfIaBJnXL37WCfCfHJLKr0EW/C4xTlfC6BAJ//9BBYvf4SDjcY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XyjIBTHv; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XyjIBTHv"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-4df4016b3c9so190875e0c.1
        for <patches@lists.linux.dev>; Fri, 17 May 2024 03:25:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1715941556; x=1716546356; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+2EE4f6Ufhb8Htz2MM1zuJ6IR23b06+w+7Yn1lBm9zs=;
        b=XyjIBTHvcNT/q9+SqDOdpeouxKvtqKa/ZhMTz8nOxvPa5ulYAbHI3C3f0M+ObZWrDD
         fYqgVEH+vqh4EZfGzyd+aiUO4d+EnEnFEhuaQSeqQlV5zlhyStsf5aI+DYuqOYSZZjRZ
         hfu9vqohBYrKre0rpYY0uwbki1Du++Rmy2+G8Cg09jBca2PMssAXSLvmrOP3iv31NBDX
         1AqlawgXg98EiFxvs0KQJKVQ9ufcpOt3hvLvoW9y4tr7YjGBaPj4dr+GFEeHk2a7+Ala
         WUZ7MVN4eBi6FRZXHTA4FfUbLF0D16+TIYzsPv7v1sUfLH8+QR5Ktiqn76E1sOteLWax
         wx2w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715941556; x=1716546356;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=+2EE4f6Ufhb8Htz2MM1zuJ6IR23b06+w+7Yn1lBm9zs=;
        b=abByrgmIwsk2c5KRINk4qRFAwozrjYSoNB8aDiOxzilugiljX5jJUkLmsdAPcoc48F
         EYAnfUSyuGduEMahk2g2grQh8+L7igSw7BZpxNy8g81I7xm4HpvDbu9qCek+xPk934Ds
         +vHzRj4qbM7DGhedn2mD/xxiZYDQ/lnCa9s9aNAUsI12qvctKKwtbnUi3AzfARIqJe1B
         iGn632Ke6CtdOUxe74FSIP/tQctxCVPQGASu6ihTRACOuHShXjo8JDKoQFPlVfasTW+R
         78pnx5TYqmTtSJ+bWYIZsVP0IEJpsCz1d2P7e9eBJL4BAsi1ks1LZ0jYub04/6VvCIxn
         G0LA==
X-Forwarded-Encrypted: i=1; AJvYcCVAcarsRCe0nIlKk7g2Z/3iQ3RhkGd2p99zXc3h6tKZecZgT3qK5DOT3sYzzbCF45Q/5GCNphNAjy2cz0Y8prOTwR8cvLji2g==
X-Gm-Message-State: AOJu0YwLbyCg4M5DdOcAw/IGaK6QaBejqGIUNUKgf2C9HbwE3g5CUhm6
	npP/PcvwyN6eqtarHF9NlnNc47z0j6zJws9L5oGZkbO0d4GbP+b0jtZmZL9cKNBFE0PNgKWEXAt
	cAa1D8cWsk44dUHDnS8++qLDNxv5d4gFhWS5P4g==
X-Google-Smtp-Source: AGHT+IF2tN/OnuYVBEWw9H8Uq3FIX0i6X/TqjD6J+rYvndB4eu6OkINyLYAnQHjMTw8SGUoXLHRkpAApYUL+3+7ScAs=
X-Received: by 2002:a05:6122:a10:b0:4d8:37eb:9562 with SMTP id
 71dfb90a1353d-4df881807a0mr20998642e0c.0.1715941555685; Fri, 17 May 2024
 03:25:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240516091232.619851361@linuxfoundation.org>
In-Reply-To: <20240516091232.619851361@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 17 May 2024 12:25:44 +0200
Message-ID: <CA+G9fYuVnf0FjnZVT0jXMVQiQPfnSOY-2eiRutT64nkU10CNPw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/244] 6.1.91-rc3 review
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

On Thu, 16 May 2024 at 11:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.91 release.
> There are 244 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 May 2024 09:11:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.91-rc3.gz
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
* kernel: 6.1.91-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 68f58d77e6715a5ff610e494b147f4111109355c
* git describe: v6.1.90-245-g68f58d77e671
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.9=
0-245-g68f58d77e671

## Test Regressions (compared to v6.1.90)

## Metric Regressions (compared to v6.1.90)

## Test Fixes (compared to v6.1.90)

## Metric Fixes (compared to v6.1.90)

## Test result summary
total: 141267, pass: 121511, fail: 2604, skip: 16980, xfail: 172

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 135 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
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
