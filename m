Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B1C159587
	for <patches@lists.linux.dev>; Wed, 28 Feb 2024 17:20:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709140851; cv=none; b=Qs4FPWst9fiINQXewIEXsGQbAjBx9jqzuJqYXkuOi7k12jUfgavMUQ9l1Zi4rU0u3BhfdZZR06M5qiZn+Hj1to5uJtatT+LmbGdTfsf0v/H+Gx7TlSACQy/VIw2DO7pCu3L4+IAVzoeqiqHLkAby8bf96o1r1Ra6XaGY1tEgtiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709140851; c=relaxed/simple;
	bh=kpxN8YWY36TtTKmjENS3W9jqCOMPp80gFYzUWKcRDBA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hE9KXl2UyxYl0dKsw9Vdcg8plLaeK5D13pji3W9C51YOCAtwzyEbNKiIbYyhKcIHIwaSKlpHes3QjK6hXXn2C9Su6IiVaMNjzYdHdhtlmuQ7QAHze52dn8QYGhXm+Epm10JDLgiFtViArMFLkj+sHm5hsYhCbwDmsuTuqCuALAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lp/nXNpp; arc=none smtp.client-ip=209.85.217.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lp/nXNpp"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-47044462962so865065137.1
        for <patches@lists.linux.dev>; Wed, 28 Feb 2024 09:20:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709140848; x=1709745648; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rpcNUEap1dQkcqM2RiT68y5p7O8lCS0XT7L6VhYqths=;
        b=lp/nXNppRPJuxqmesKyx+MWQyXhWhoWb5KAIcItxIv1fDrq1IkrDE+SpDaHrDloYzD
         bC8BvlOrL3hfRmfBx4HpVAi4YarYG8Ilu72cQgtIzXRL2olMvABTTYWydrATMaR1T+HV
         6d2qXAD18SOzc0XLwdQ11D7Ml7rjxyUI4p/+hy6ukVDVO46Sg9MjG/pPh0Dxjqaae7Ul
         76bVwMKbYqtS/nAnIFAx4dnR153YWpReaSg8HCj+0B2GdGpvZexkUHxNmRIZGqVeX/qz
         epYQGSAfzh5tauG73WV+BozFy6+N1syVC31lZho21Av9QwvDZi/gDCTuwMgDoQdpZsnx
         k54A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709140848; x=1709745648;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=rpcNUEap1dQkcqM2RiT68y5p7O8lCS0XT7L6VhYqths=;
        b=OIt6ZAc60bx4xaIAq0EbI0QtNyQ4thrFyg9bnZlUrhN/X0mnpBvNXlI56zTljrcS9U
         z2nOuzXK7sPzHmTqt0J8wJRGvAaBAZ6/E0hxekwfwU6OrgmxnJrLzwlMzx/uuhh8ueiS
         o/q2+pc+Kj4GppVRtMDIKKPNj1O1TojN06fE2GJMRZj5eygcMBhyaf5j4xyG2Gf3EB4u
         hDexolWDrLjVds4/5pXit2pOGEFxh1lptQZ90IKLcsNargC596OyY3fd90ovKWUx1ipr
         gllkwCWG+CqYVh5/JeHoy/MbyZQACspPll+18O/9BsEjHKwsH/JpVWzHGINKbz8gdgTl
         mySg==
X-Forwarded-Encrypted: i=1; AJvYcCV1Ho4vfhUc3sbf0YMYEflnYDhgbxsb3gkag1GEFe6z68TZgwhuUUSoWepFi1l35/djGhoSUSqgwJS/TyAaJtbAT2k7thMK+w==
X-Gm-Message-State: AOJu0YxeBwvOtnKyHPJ0LWyFMN4ZFFaSjODSL8SE53w8vbYEnbe/YAba
	RTVMmi1RZ8hzjenGz1uChclmHkWx/Zfo2YjQJWT6NzIpsZS55z3IfuvP1Kdg0JrVDFsdeAGuOhI
	ttPJymiv2/2Zm/XRBGqvEPNsI5YtRHiFEzsETrA==
X-Google-Smtp-Source: AGHT+IGnqSJ4fTsQ3pv6pcwEs3dbuGkwVUIe7fzuSXzzCbYF2spVMHuWXTbN0xCxZoOVikXTWNOhJN77bwXqA0fMDdY=
X-Received: by 2002:a05:6102:9b3:b0:472:69ab:f7be with SMTP id
 f19-20020a05610209b300b0047269abf7bemr159114vsb.35.1709140848306; Wed, 28 Feb
 2024 09:20:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240227131552.864701583@linuxfoundation.org>
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 28 Feb 2024 22:50:37 +0530
Message-ID: <CA+G9fYs660+aMLv6m0xU3ezSY7iFcsgct_weMQ=KR5mdg-m+yQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/84] 5.4.270-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Feb 2024 at 19:52, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.270 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 29 Feb 2024 13:15:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.270-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.270-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 331c26fedbd3ec4b446d0f2ae002f93421d3daa6
* git describe: v5.4.269-85-g331c26fedbd3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
69-85-g331c26fedbd3

## Test Regressions (compared to v5.4.269)

## Metric Regressions (compared to v5.4.269)

## Test Fixes (compared to v5.4.269)

## Metric Fixes (compared to v5.4.269)

## Test result summary
total: 97761, pass: 78074, fail: 3337, skip: 16283, xfail: 67

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 138 total, 138 passed, 0 failed
* arm64: 38 total, 36 passed, 2 failed
* i386: 25 total, 19 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 34 total, 34 passed, 0 failed

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
* kselftest-sigaltstack
* kselftest-size
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
