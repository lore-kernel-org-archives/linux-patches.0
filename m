Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 197921F4616
	for <patches@lists.linux.dev>; Thu, 31 Jul 2025 10:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753957067; cv=none; b=UvJycTgEIPzY2/m0yZT5ZFjpTENC9LI4SHS/EzfhhZZLHIfl6WsBbeiphM+PE5pyvZxI3vPudCH0umUXV31vlOya4H5Gppy7tMLM4xb8hGVsTl39hRufOoBv9QfEEYUNVTLkiFLSVhC0fHIdPa9w89P5ARex06vAhGkC6Jzl2Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753957067; c=relaxed/simple;
	bh=hM+vN759MW7T6McUKOpE6yy0OUNkDj+vOuX1teluI7I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sCz5eN6dtaRZbRBwlc7BuIIODOrjkS/t7UiBPY51q7rezF6Kki1NPevXEhj4CGBOVyd019H+Ejp5lasqoEYlcIXa5qfUtt6ShJwH41+hs188w25s22rxP6O3y+FE1zfkpYriC+K2yDRJiQgeoG1RWZZJqmQQsClhChMNgp/Xx2k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sOToigj/; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sOToigj/"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-23636167afeso6748875ad.3
        for <patches@lists.linux.dev>; Thu, 31 Jul 2025 03:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753957065; x=1754561865; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GBDjfpxOp54359rJYp6X3VeTm/Gx2u9kuRZ6HlzBXjQ=;
        b=sOToigj/S6Us288m5sxJL/Php4Q3My5G9bVdDrUOtBcAFTtFnYrF6Hv+Qn2WX/spVg
         uPItfFUXFq2gLbEFWl92IvIEDIs6Reb4py698ue7lg3llJiRTDyQlHgtM/k1IBZInYtj
         GJQOpIBy9P9KSOYvNQNbPx6GdZ95fGMCoc8TsvIBg4PWjO4z5SD56M0K6JzswCefdtd1
         zHa9QzLuhaPi6k3cTXc4th2ZR5cMZHDuRb4jA/8owMmfLArYGCtBd4PjfOK8ZvAbbq2H
         5uRyRc+6yN9jxvFQgFxRVV6iMz0GtyO4ymBtGj0/EWfso9HZIE8Vwy5UYYONf7NLwhBS
         Xw6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753957065; x=1754561865;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GBDjfpxOp54359rJYp6X3VeTm/Gx2u9kuRZ6HlzBXjQ=;
        b=AGLXqtds/LhOk6jySADRsC1aAub7JwSPaGtaFYTwTaoNq/uzV4b/7KAIWc/ZrCKc9M
         Wx1yFSwDzFrVfooFElOBZmn0yozLzc0utZCcIY2leHyqcSghUWBb8lhirzdsu/8JHBsk
         foiexfMjQv8HtMXsIHB2GPlBTEozQQVbBmxlV1ASnNqcfFA6iLAKTq/25WFqiKOstPsD
         Ox1y+7gxn8hKcq5nMCgj9lAjSUIt5AeY1VJGYSGZ5/ljZolh4XOFRezWZMhlvy+5DvLH
         U2x+ShYO75z6lRi2Xv4iJVd4X8QTYxwiLr+MRZzcymXAVKpUK3F0JjqInq5mLRPQrN5o
         FMoQ==
X-Forwarded-Encrypted: i=1; AJvYcCXvnsA1PPKt0uw3RTTFQWSGICHwJ64nULfRWlC9l092avDqjUUYt+djy73nwIvDeAnYNp3HUal6@lists.linux.dev
X-Gm-Message-State: AOJu0YwqYKfvfyyb69pU9gBnD1e/v1JubtuxYOhs7sjSYbr/jXtGgYVP
	ZMvFpmVb9TpXz5Ta9R673RDH86PUt1DXhpHP9sij5nRIPIi1eNjDI+p1VHtPvJ3UTpnyx6ss/gb
	2OX39moRtats89J38wLAKW4dM+3MYRlSwAaT1VTZUUg==
X-Gm-Gg: ASbGncszJl4zPugyfQL8ovfGiDXlj4pQ5tMR9o472WgTsYcWyTrItGpjCzoYsH+gZiC
	WjdxndbPv816jo2hzeZYOP77Iq4dwdIyMq/mgKZNFavulmtyao4toNYWVJgpqT99M+vAik1614p
	QIk437PerV2FThs76KzrS4RBpDy06j71Q9jv4xr+/WLm/46i5/PykmrT4HQkJpLErlAmGAYtFDi
	I4+ruuIlMA9aTCXu0h8HJfkWMZwFn+xwY0UBHI=
X-Google-Smtp-Source: AGHT+IFY7rsm5nJyelCwk45krzeSFkbdT/gaZZRziQDcrJRc1YFgekz9X2f2KbRKja2X5oCfA5pSOZbTF7vEdnduGXY=
X-Received: by 2002:a17:903:2347:b0:23f:c005:eab0 with SMTP id
 d9443c01a7336-24096bc792dmr90043015ad.40.1753957065109; Thu, 31 Jul 2025
 03:17:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250730093230.629234025@linuxfoundation.org>
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 31 Jul 2025 15:47:33 +0530
X-Gm-Features: Ac12FXzoAr2go-p-IHVBRyqSrYJLPAOBADLHi4dKBlyrvcJyd0ZMa9rnOXK21mE
Message-ID: <CA+G9fYtcgEX6gw6xV2hAT0ewbUbf0LWzv56QUQzT4rGw+dDbxA@mail.gmail.com>
Subject: Re: [PATCH 6.15 00/92] 6.15.9-rc1 review
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

On Wed, 30 Jul 2025 at 15:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.9 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.15.9-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: d9420fe2ce8ce7d6f2f74f9b6608740432483932
* git describe: v6.15.8-93-gd9420fe2ce8c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.15.y/build/v6.15=
.8-93-gd9420fe2ce8c

## Test Regressions (compared to v6.15.7-188-g81bcc8b99854)

## Metric Regressions (compared to v6.15.7-188-g81bcc8b99854)

## Test Fixes (compared to v6.15.7-188-g81bcc8b99854)

## Metric Fixes (compared to v6.15.7-188-g81bcc8b99854)

## Test result summary
total: 331512, pass: 309941, fail: 6639, skip: 14932, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 138 passed, 1 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 27 passed, 7 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
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
