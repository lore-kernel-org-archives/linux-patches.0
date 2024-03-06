Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25008134CE3
	for <patches@lists.linux.dev>; Wed,  6 Mar 2024 14:55:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709736943; cv=none; b=PPmx4gm/1T+NnL1qKAsHNQcmqPmPWQ4MGztdV1TZORHFTNcGaIIJyjXy6BXldE1D9JVR7cSLozMU61MTAnznwAqk6upVLXb8DHqAPaH9PmMPYdiucRii0WLSLpD77Ubb4A/jY6+6Wot4SXZPf82jDSaY4dibLusGIBh26/IMVv0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709736943; c=relaxed/simple;
	bh=nfCQ5MUeAnyANkejhBsUcvuz//Jl2DIYQFseasFDrrY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=biOZGp3w3dFNmJ89/lJmrqQ3eZ4DIVIsafeErBUzvjDHeL0p/R2m5Q6oPAzENwuRWtrWB+iBe8eKyVv25qKXWN1kierqRCJ5NMy0qopDmCIZd3T0/2fbBxSLJjn9cKPU17sVVsB1hknGXRG/3bwA7pn2CoIgaoSsn0fUPh3bcgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=bTrgwHzp; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="bTrgwHzp"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-5d8b70b39efso6225480a12.0
        for <patches@lists.linux.dev>; Wed, 06 Mar 2024 06:55:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1709736941; x=1710341741; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Uzzlf6zHmONYejes4XgBv/bY8vZwiwX8uYZEyJ0PkRw=;
        b=bTrgwHzpr8QDvcVxidqVn9P6xOTPRJYgyL0IU095EqInAxtY8vjJPRuhlUYN8xqwSP
         gmortzOT4pL5JYhzwqhluTLvFZHD2C1NI/EJCh4l9UR/80Ez6ZBzijgxwJ98NfFiVtrJ
         q4dAAAZt3HxewfZ2NTagx/ExthOIOUhV3JS9jD/jjF3RinZ4A26qFlfEpgwlzyLwRx2f
         BxcwQhLUoKKOwcreecPYxABUdyEVvLJV0mdZylp0FQ6VYwA1e8QN0O6ecK+KwGNMbzlx
         RiANdrdDm0DbvrxBc12MXG4bTeLESXnFVOFtlHuLNUKJJ6xXeLs58m37lVCuJtROn2Ix
         yUsw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709736941; x=1710341741;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Uzzlf6zHmONYejes4XgBv/bY8vZwiwX8uYZEyJ0PkRw=;
        b=Mes1+Ri7wg9ZsZErQ8PPEFUS7pndrm0evxS1DWAyHcuvCrzCROppMkPtGzN298g91a
         hQyXRRySgdtrbXd5MPAKXmXKo5DMCKecGui3aQCvciU99Uea0Hn6n0jeqwzlfqLgd2jc
         knWrXjpy8bLz//yvoilgvq/e/pvDe6PDNafECJwXimqqEnBezOqSz+aO5SDeCxspPrBY
         oE3VV+GUk+sPLhcNqWxM1edYWOInFlLdSa6S0hWgCptT8bk/bHOh5JSxr98vIb2ID1Df
         F1gq0T8Tt6LL+u9CYC/b67b6MkcMyNg4oWiPlpV9nTYM7euyq1WVyjmAwLBPFljxLaMF
         vAIQ==
X-Forwarded-Encrypted: i=1; AJvYcCVv2U8bvg0J1gFx3H6cNYYJzfUGczqR8tjfVR2m6iiNkWLZ18y312o15safwsp8OQkkT0sfUYjDyE0qUrfz//yrgt1I2KaZNw==
X-Gm-Message-State: AOJu0YzMNHS14A0m9A0m0sRCKXSEMs1w8XyfsAUknXSTcIOyWAi8zX3F
	gxb0x494TlpeyY3HLXaCrWtLoKA577CQ7VfoATz9fDzk2ITnOzWMf87QCDEVLZ3NBlydPUQ1weI
	t1HH9ftyqcZhar+UwEJ+V6DT2tqo=
X-Google-Smtp-Source: AGHT+IERw1WxNeWmELIwx8V11vsYyqfmJN5GE5CxQaDK3TtTCXLZIwuExnjJRsqXca3sDu7xmW4bOeDKVExzbt7XXVI=
X-Received: by 2002:a17:90a:f489:b0:29b:4dfc:7d32 with SMTP id
 bx9-20020a17090af48900b0029b4dfc7d32mr7490150pjb.17.1709736941476; Wed, 06
 Mar 2024 06:55:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304211549.876981797@linuxfoundation.org> <CA+G9fYvTnAyEt-Cn7fmXQ2FK3+xLyOULmcxhrk7dMTypckDEsA@mail.gmail.com>
In-Reply-To: <CA+G9fYvTnAyEt-Cn7fmXQ2FK3+xLyOULmcxhrk7dMTypckDEsA@mail.gmail.com>
From: Luna Jernberg <droidbittin@gmail.com>
Date: Wed, 6 Mar 2024 15:55:29 +0100
Message-ID: <CADo9pHjuCRuj7KyWFK1PDcnT-Y4_JaUCtrBksph0de0UpX63GQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/143] 6.6.21-rc1 review
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org, 
	patches@lists.linux.dev, linux-kernel@vger.kernel.org, 
	torvalds@linux-foundation.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Tested-by: Luna Jernberg <droidbittin@gmail.com>

Den ons 6 mars 2024 kl 13:56 skrev Naresh Kamboju <naresh.kamboju@linaro.or=
g>:
>
> On Tue, 5 Mar 2024 at 03:07, Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 6.6.21 release.
> > There are 143 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> > Anything received after that time might be too late.
> >
> > The whole patch series can be found in one patch at:
> >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patc=
h-6.6.21-rc1.gz
> > or in the git tree and branch at:
> >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stab=
le-rc.git linux-6.6.y
> > and the diffstat can be found below.
> >
> > thanks,
> >
> > greg k-h
>
>
> Results from Linaro=E2=80=99s test farm.
> No regressions on arm64, arm, x86_64, and i386.
>
> Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>
>
> ## Build
> * kernel: 6.6.21-rc1
> * git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
> * git branch: linux-6.6.y
> * git commit: 5f9255b6ac459ba1b98dfffa0680a5700447d28c
> * git describe: v6.6.18-445-g5f9255b6ac45
> * test details:
> https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6=
.18-445-g5f9255b6ac45
>
> ## Test Regressions (compared to v6.6.18)
>
> ## Metric Regressions (compared to v6.6.18)
>
> ## Test Fixes (compared to v6.6.18)
>
> ## Metric Fixes (compared to v6.6.18)
>
> ## Test result summary
> total: 168781, pass: 145491, fail: 2395, skip: 20734, xfail: 161
>
> ## Build Summary
> * arc: 5 total, 5 passed, 0 failed
> * arm: 135 total, 132 passed, 3 failed
> * arm64: 43 total, 41 passed, 2 failed
> * i386: 35 total, 30 passed, 5 failed
> * mips: 26 total, 23 passed, 3 failed
> * parisc: 4 total, 4 passed, 0 failed
> * powerpc: 36 total, 28 passed, 8 failed
> * riscv: 18 total, 18 passed, 0 failed
> * s390: 13 total, 13 passed, 0 failed
> * sh: 10 total, 10 passed, 0 failed
> * sparc: 8 total, 8 passed, 0 failed
> * x86_64: 39 total, 34 passed, 5 failed
>
> ## Test suites summary
> * boot
> * kselftest-android
> * kselftest-arm64
> * kselftest-breakpoints
> * kselftest-capabilities
> * kselftest-cgroup
> * kselftest-clone3
> * kselftest-core
> * kselftest-cpu-hotplug
> * kselftest-cpufreq
> * kselftest-drivers-dma-buf
> * kselftest-efivarfs
> * kselftest-exec
> * kselftest-filesystems
> * kselftest-filesystems-binderfs
> * kselftest-filesystems-epoll
> * kselftest-firmware
> * kselftest-fpu
> * kselftest-ftrace
> * kselftest-futex
> * kselftest-gpio
> * kselftest-intel_pstate
> * kselftest-ipc
> * kselftest-ir
> * kselftest-kcmp
> * kselftest-kexec
> * kselftest-kvm
> * kselftest-lib
> * kselftest-livepatch
> * kselftest-membarrier
> * kselftest-memfd
> * kselftest-memory-hotplug
> * kselftest-mincore
> * kselftest-mm
> * kselftest-mount
> * kselftest-mqueue
> * kselftest-net
> * kselftest-net-forwarding
> * kselftest-net-mptcp
> * kselftest-netfilter
> * kselftest-nsfs
> * kselftest-openat2
> * kselftest-pid_namespace
> * kselftest-pidfd
> * kselftest-proc
> * kselftest-pstore
> * kselftest-ptrace
> * kselftest-rseq
> * kselftest-rtc
> * kselftest-seccomp
> * kselftest-sigaltstack
> * kselftest-size
> * kselftest-splice
> * kselftest-static_keys
> * kselftest-sync
> * kselftest-sysctl
> * kselftest-tc-testing
> * kselftest-timens
> * kselftest-timers
> * kselftest-tmpfs
> * kselftest-tpm2
> * kselftest-user
> * kselftest-user_events
> * kselftest-vDSO
> * kselftest-watchdog
> * kselftest-x86
> * kselftest-zram
> * kunit
> * kvm-unit-tests
> * libgpiod
> * libhugetlbfs
> * log-parser-boot
> * log-parser-test
> * ltp-cap_bounds
> * ltp-commands
> * ltp-containers
> * ltp-controllers
> * ltp-cpuhotplug
> * ltp-crypto
> * ltp-cve
> * ltp-dio
> * ltp-fcntl-locktests
> * ltp-filecaps
> * ltp-fs
> * ltp-fs_bind
> * ltp-fs_perms_simple
> * ltp-hugetlb
> * ltp-io
> * ltp-ipc
> * ltp-math
> * ltp-mm
> * ltp-nptl
> * ltp-pty
> * ltp-sched
> * ltp-securebits
> * ltp-smoke
> * ltp-smoketest
> * ltp-syscalls
> * ltp-tracing
> * perf
> * rcutorture
>
> --
> Linaro LKFT
> https://lkft.linaro.org
>
