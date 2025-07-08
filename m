Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68E5224290E
	for <patches@lists.linux.dev>; Tue,  8 Jul 2025 21:24:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752009857; cv=none; b=PPoMAFp9fZd4BMSf/D2SNR/H1rKv32mnf53fsO97FdMmeqONsi0VlVbbMO7AFTe/Vxyq+2rOAdDQdK1u+yhhOmTDBwk8cNO2LYGvsSxZtu03ivhHiMqCANF9rnZpjXSkjhXVIqLJV5W/jCaNqYIN1MVA3TZbHXtToRe/NBK+pHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752009857; c=relaxed/simple;
	bh=1peS5qCn54AczeLVDKVCi9E3GKez0ewn76aZqjgKESQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=creXN/1LP4G806WPMx8/s32TCjxywChqBowH+gDXu+NFGfG3iJwmUNHHpR8VdPMgkkk+SIKvs83R4zC5pCGs/tm93o7Ca689YanmDO72cfwdJ3EFYg/4bQWePXJIpHem2pwC8GSBfcvwNaD33Kjq7z/Cv8/WSZNIBQ5TQtewa80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=YMJ/5e/r; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="YMJ/5e/r"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-b321bd36a41so4318558a12.2
        for <patches@lists.linux.dev>; Tue, 08 Jul 2025 14:24:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752009855; x=1752614655; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=3TYk/LhDc5BmTUsXOQ3WfWFuFN2OL0SILOLf+2JGW+c=;
        b=YMJ/5e/rYuXX2jLwNvH5aTMVxpMMZfLsNMFBFFIpuC2ut40wlKfUPSCzGq+tT/uysm
         SQt7gjP3eEVh6MkRuCxjj2IJYJgecWmvUz5+QYcvNxDu0CTiB2yc+gwVxzobtiprwuSC
         y2iEwXNa/NTuhRxxZ+KGO6gt88qZQybdUyhr1G0qtr6KG/MPgaH42pC1Oh7jySWawqDQ
         lXIai3PLw9AUsKof0H7UU3wRcQ7n6vYrMhYQVYSEIgdSerMNPWP49esiacn4Cf//yOtz
         f+NYcKJHibp6w0XjKcZmlZNjrd7dP9vKYmTi+7MLRqZNANOr88080FXstY/iuE4CeULh
         K4Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752009855; x=1752614655;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3TYk/LhDc5BmTUsXOQ3WfWFuFN2OL0SILOLf+2JGW+c=;
        b=wwf6zF14WeRreJjyQ/wUDoxhuueermEzOc0rwW3krJuBpq4WD733gke2dxUdX/lKjF
         djVMxPZgZLs6IF0OmM/KsTWLbCjV6OwIAixBPgbTC76D1nG1dO1AK8vu4nMfaauw9QME
         WePZBSnf23MNg57FeOieMUU0761oZXx833zw7d9joKmJaoP693buPX5y86tYV8IjfjiF
         Fn6cBoLQ3XkeLwofbAGIZLeoOG145s/6v6xFd4EE5BJK+583wWhkomokGSyrrhctH5qQ
         sF2W21HZ6E/QxpOsEo8D0wbm5tmbKB+tTz+QhVZx7b/lU/T+Qip5mqniZ74kcQwxoAu8
         DANw==
X-Forwarded-Encrypted: i=1; AJvYcCU6/O3wPIWPGKT/+YrNCJRmo33PQRt2HUcIqRqolvbiuiMfT4dVfTxEY9e9xY6k4/TeiqJ8uvNI@lists.linux.dev
X-Gm-Message-State: AOJu0YxsC4fSvM5QeWqZHaL6LS3F11z+MCAfDSYpIPYBcngBDo/mfTtY
	0jtJGzmwAl62O1SHwoa8412ychyPL9b+ndtb0C1zqF8XAWCEam6i5m5J2BhgWVCYAOfSuHKc6oe
	XFridTokRi5tPdm+BxgOFc2Mtx1GisYvO8alOK4HBeA==
X-Gm-Gg: ASbGnctzFeusRuLLfEpwDF3g23LeNpQ7lMOpLhexUWk4kxh5eMX0OaAKcGur+eAHfCr
	8SXfFyYkTqytxCABJ19GCjHRxMJMdqWiyYErMenBpwqJHXfw+uW0Oq+b/EXLJpARWrWHVkjiRrV
	G9aYMOycFSZEJ1gocCW6XzPUGAQA6jPXY0zzNMtl2wUrS8g+d+P7gofGVctjLGWAVq5oA3CIsnm
	Fzs
X-Google-Smtp-Source: AGHT+IGC1zl17iwbzwdo6GEQjumT6Zw2i385vWCVOsSuiOe0iINH0VdYvfBVzIFnWmRAAWRU0qYVeo2uenzgVCAlgZI=
X-Received: by 2002:a17:90b:1c0f:b0:31c:23f2:d2ad with SMTP id
 98e67ed59e1d1-31c2fdad5efmr156423a91.16.1752009854650; Tue, 08 Jul 2025
 14:24:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250704125604.759558342@linuxfoundation.org> <CA+G9fYvidpyHTQ179dAJ4TSdhthC-Mtjuks5iQjMf+ovfPQbTg@mail.gmail.com>
 <CA+G9fYub_Ln=EPp2mgL4-2ewvorZ6O7btM97Ka6RrWhO1o0Liw@mail.gmail.com>
In-Reply-To: <CA+G9fYub_Ln=EPp2mgL4-2ewvorZ6O7btM97Ka6RrWhO1o0Liw@mail.gmail.com>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 9 Jul 2025 02:54:03 +0530
X-Gm-Features: Ac12FXw8KmXSOFloz8JHG_WxTb9KW7umiayEZP4yCzmazJVNmpe-skD5MqB7ysY
Message-ID: <CA+G9fYtb3OW5+0Y+qYC-hbg2AV-UUff3orui0VuckDrrMYjrcw@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/263] 6.15.5-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, 
	Linus Torvalds <torvalds@linux-foundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, akpm@linux-foundation.org, linux@roeck-us.net, 
	shuah@kernel.org, patches@kernelci.org, lkft-triage@lists.linaro.org, 
	pavel@denx.de, jonathanh@nvidia.com, f.fainelli@gmail.com, 
	sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de, 
	conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Anders Roxell <anders.roxell@linaro.org>, jakub.lewalski@nokia.com, 
	Elodie Decerle <elodie.decerle@nokia.com>, Aidan Stewart <astewart@tektelic.com>, 
	Fabio Estevam <festevam@gmail.com>
Content-Type: text/plain; charset="UTF-8"

On Tue, 8 Jul 2025 at 00:04, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
>
> On Sun, 6 Jul 2025 at 15:50, Naresh Kamboju <naresh.kamboju@linaro.org> wrote:
> >
> > On Fri, 4 Jul 2025 at 20:14, Greg Kroah-Hartman
> > <gregkh@linuxfoundation.org> wrote:
> > >
> > > This is the start of the stable review cycle for the 6.15.5 release.
> > > There are 263 patches in this series, all will be posted as a response
> > > to this one.  If anyone has any issues with these being applied, please
> > > let me know.
> > >
> > > Responses should be made by Sun, 06 Jul 2025 12:55:09 +0000.
> > > Anything received after that time might be too late.
> > >
> > > The whole patch series can be found in one patch at:
> > >         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.5-rc2.gz
> > > or in the git tree and branch at:
> > >         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
> > > and the diffstat can be found below.
> > >
> > > thanks,
> > >
> > > greg k-h
> >
> > Approximately 20% of devices are experiencing intermittent boot failures
> > with this kernel version. The issue appears to be related to auto login
> > failures, where an incorrect password is being detected on the serial
> > console during the login process.
>
> Reported issue is also noticed on Linux tree 6.16-rc5 build.
>
> > We are investigating this problem.

The following three patches were reverted and the system was re-tested.
The previously reported issues are no longer observed after applying the
reverts.

serial: imx: Restore original RXTL for console to fix data loss
    commit f23c52aafb1675ab1d1f46914556d8e29cbbf7b3 upstream.

serial: core: restore of_node information in sysfs
    commit d36f0e9a0002f04f4d6dd9be908d58fe5bd3a279 upstream.

tty: serial: uartlite: register uart driver in init
    [ Upstream commit 6bd697b5fc39fd24e2aa418c7b7d14469f550a93 ]

Reference bug report lore link,
 - https://lore.kernel.org/stable/CA+G9fYvidpyHTQ179dAJ4TSdhthC-Mtjuks5iQjMf+ovfPQbTg@mail.gmail.com/


> >
> > Test environments:
> >  - dragonboard-410c
> >  - dragonboard-845c
> >  - e850-96
> >  - juno-r2
> >  - rk3399-rock-pi-4b
> >  - x86
> >
> > Regression Analysis:
> > - New regression? Yes
> > - Reproducibility? 20% only
> >
> > Test regression: 6.15.5-rc2 auto login failed Login incorrect
> >
> > Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
> >
> > ## log in problem
> >
> > runner-ns46nmmj-project-40964107-concurrent-0 login: #
> > Password:
> > Login incorrect
> > runner-ns46nmmj-project-40964107-concurrent-0 login:
> >
> > * log 1: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.15.y/build/v6.15.4-264-gf6977c36decb/testrun/29021685/suite/boot/test/clang-20-lkftconfig/log
> > * log 2: https://qa-reports.linaro.org/api/testruns/29021720/log_file/
> > * Boot test: https://regressions.linaro.org/lkft/linux-stable-rc-linux-6.15.y/v6.15.4-264-gf6977c36decb/boot/clang-20-lkftconfig/
> > * LAVA jobs 1: https://lkft.validation.linaro.org/scheduler/job/8344153#L1186
> > * LAVA jobs 2: https://lkft.validation.linaro.org/scheduler/job/8343870#L1266
> >
> > ## Build
> > * kernel: 6.15.5-rc2
> > * git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
> > * git commit: f6977c36decb0875e78bdb8599749bce1e84c753
> > * git describe: v6.15.4-264-gf6977c36decb
> > * test details:
> > https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.15.y/build/v6.15.4-264-gf6977c36decb
> >
> > ## Test Regressions (compared to v6.15.3-590-gd93bc5feded1)
> > * dragonboard-410c, boot
> >   - clang-20-lkftconfig
> >   - clang-nightly-lkftconfig-kselftest
> >   - gcc-13-lkftconfig-debug
> >
> > * dragonboard-845c, boot
> >   - clang-20-lkftconfig
> >   - korg-clang-20-lkftconfig-lto-thing
> >
> > * dragonboard-845c-compat, boot
> >   - gcc-13-lkftconfig-compat
> >
> > * e850-96, boot
> >   - gcc-13-lkftconfig-no-kselftest-frag
> >
> > * juno-r2, boot
> >   - clang-20-lkftconfig
> >   - gcc-13-lkftconfig-debug
> >   - gcc-13-lkftconfig-kselftest
> >
> > * rk3399-rock-pi-4b, boot
> >   - clang-20-lkftconfig
> >
> > * x86, boot
> >   - clang-20-lkftconfig
> >   - clang-20-lkftconfig-no-kselftest-frag
> >   - clang-nightly-lkftconfig-kselftest
> >   - clang-nightly-lkftconfig-lto-thing
> >   - gcc-13-defconfig-preempt_rt
> >   - gcc-13-lkftconfig-no-kselftest-frag
> >
> > ## Metric Regressions (compared to v6.15.3-590-gd93bc5feded1)
> >
> > ## Test Fixes (compared to v6.15.3-590-gd93bc5feded1)
> >
> > ## Metric Fixes (compared to v6.15.3-590-gd93bc5feded1)
> >
> > ## Test result summary
> > total: 259237, pass: 235906, fail: 6376, skip: 16955, xfail: 0
> >
> > ## Build Summary
> > * arc: 5 total, 5 passed, 0 failed
> > * arm: 139 total, 138 passed, 1 failed
> > * arm64: 57 total, 57 passed, 0 failed
> > * i386: 18 total, 18 passed, 0 failed
> > * mips: 34 total, 27 passed, 7 failed
> > * parisc: 4 total, 4 passed, 0 failed
> > * powerpc: 40 total, 39 passed, 1 failed
> > * riscv: 25 total, 25 passed, 0 failed
> > * s390: 22 total, 22 passed, 0 failed
> > * sh: 5 total, 5 passed, 0 failed
> > * sparc: 4 total, 3 passed, 1 failed
> > * x86_64: 49 total, 49 passed, 0 failed
> >
> > ## Test suites summary
> > * boot
> > * commands
> > * kselftest-arm64
> > * kselftest-breakpoints
> > * kselftest-capabilities
> > * kselftest-cgroup
> > * kselftest-clone3
> > * kselftest-core
> > * kselftest-cpu-hotplug
> > * kselftest-cpufreq
> > * kselftest-efivarfs
> > * kselftest-exec
> > * kselftest-fpu
> > * kselftest-ftrace
> > * kselftest-futex
> > * kselftest-gpio
> > * kselftest-intel_pstate
> > * kselftest-ipc
> > * kselftest-kcmp
> > * kselftest-kvm
> > * kselftest-livepatch
> > * kselftest-membarrier
> > * kselftest-memfd
> > * kselftest-mincore
> > * kselftest-mm
> > * kselftest-mqueue
> > * kselftest-net
> > * kselftest-net-mptcp
> > * kselftest-openat2
> > * kselftest-ptrace
> > * kselftest-rseq
> > * kselftest-rtc
> > * kselftest-rust
> > * kselftest-seccomp
> > * kselftest-sigaltstack
> > * kselftest-size
> > * kselftest-tc-testing
> > * kselftest-timers
> > * kselftest-tmpfs
> > * kselftest-tpm2
> > * kselftest-user_events
> > * kselftest-vDSO
> > * kselftest-x86
> > * kunit
> > * kvm-unit-tests
> > * lava
> > * libgpiod
> > * libhugetlbfs
> > * log-parser-boot
> > * log-parser-build-clang
> > * log-parser-build-gcc
> > * log-parser-test
> > * ltp-capability
> > * ltp-commands
> > * ltp-containers
> > * ltp-controllers
> > * ltp-cpuhotplug
> > * ltp-crypto
> > * ltp-cve
> > * ltp-dio
> > * ltp-fcntl-locktests
> > * ltp-fs
> > * ltp-fs_bind
> > * ltp-fs_perms_simple
> > * ltp-hugetlb
> > * ltp-math
> > * ltp-mm
> > * ltp-nptl
> > * ltp-pty
> > * ltp-sched
> > * ltp-smoke
> > * ltp-syscalls
> > * ltp-tracing
> > * modules
> > * perf
> > * rcutorture
> > * rt-tests-cyclicdeadline
> > * rt-tests-pi-stress
> > * rt-tests-pmqtest
> > * rt-tests-rt-migrate-test
> > * rt-tests-signaltest
> >
> > --
> > Linaro LKFT
> > https://lkft.linaro.org
