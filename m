Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A022F0036
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 10:12:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752660768; cv=none; b=E3SYwufuub53kDf5TJUHGexVr4oYdI0hCME72cJKev8NXmGasfMRjk15VGmsh17bbas5vN/d33xfv0LrtvgVD9O0y30XgfeCk3sEqQ+NQAY/pdU+iJqoZIROtG5vMieIOyS+LbmUr44JVeID/Re+D2EV/o1VLqRz2HNMatqZt8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752660768; c=relaxed/simple;
	bh=BWD7VdphZFHKjWplKHCzBxyRhgPY80wzhcSlGMcOMuk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CmZIlmWVbAJ1c5jzslv9hp49AyCfu91traydeLiGtLwedLqexsydv3UFLGx1EjKFa5OlwkBsxUqXnHObqjo/OznNRX/n+3c7TPIwipRZ2gFIVUvXZjShe2UJ053N9x2Fb6FVcF4IbbKDIjoDZ9+uf7FNVbPLY9xibVX1rpnaHyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=k9zKqFKM; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k9zKqFKM"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b3be5c0eb99so3035085a12.1
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 03:12:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752660766; x=1753265566; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=S/nyoacKNVKnvpDrNZJPu1NQrh/P0H/upYyJl85ifJE=;
        b=k9zKqFKMFalU6lajBlvu6YYsZC/IzTelH7kzhbZs3mX6FWc/tN8yXiSVQoYJubsCwR
         MO+tOW0mdwHlnWLfTUmGO45X3wBWJGN/6WQlZrM1Xr/DrGMPIJr5e7igb+nzIBRGWv3Y
         yFeSIWb8UtUEhVQ86udWywbJmO84XXN0OW0lWX9r3Nl1bGuJMelV8tLocP9OHuRI2ai/
         N9ReMbNDP4pcdBO0nXD5zFcprN1imb5gS/sQbqGwGZpqen2Vg78/+MkaQ6GwJOJAVUrt
         EJcCpic8o6/Ye+SSyTJSrjF1uNDNOJExFvxNgP5sjAWB03TVhng/x0Ma0emfFha/0++y
         CADw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752660766; x=1753265566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=S/nyoacKNVKnvpDrNZJPu1NQrh/P0H/upYyJl85ifJE=;
        b=QK8wne2zwt5HbfxI5uOd3Q1pX7LUM6njRgCTprxvAJ5C64bAAz1zohmBDflb+A9YmO
         P+qSoJ43EKbt8T+CadKHCx/A0HTMc6lr7TQQLLD3YyO1OjLH/L2VXYTd5M+/KPI8TFJR
         xBfEtWCXa+pjquytc1w6i9rYLnPE9jzfzQ3NQD9jGRl8AH7EBcprwZG+QIv1olqhI+Ez
         hm7yweA2SnWyKOAd+Fmz5msCV00Zj1VATbCPtJCNcXIKRDkgkXNO10QNV8DJ2W1d2iA4
         pVU+wxP1Jk/o6P7KkJxFOwEjsTr2LnZ1BnoGHf8+NHp8xQ4t6acyp2iE5jaGO3ESpvY5
         PFTw==
X-Forwarded-Encrypted: i=1; AJvYcCWwGrPD5uI7AZwFHg2gQatna2BUFgvGv16LefTSsTRj6RDbUksJVWtn3Ixuzf9x/++Ly7P2UyKE@lists.linux.dev
X-Gm-Message-State: AOJu0YzRWV/iYK6QA3lMmckbyHuvJ2ZaEPo2TcDM7JLwyUYR38z7WNQt
	BOe9kAFlVq4dU7uT9VFvcFzTyYMQzTd45/e3zl/xptWKtLlxji2QXz+vio3jn9c9TnQiyzmjrD5
	o0cZ2mcvl10WFQFLWL1AfKx5wtIFJSL09dg8nhWKXmA==
X-Gm-Gg: ASbGncuFEWlmc6AaaoYibcIkR5Z/MdHEm1zm0FmPOjRapZ+ldA+yS8auKItsaBBUVBA
	egnlTXmt0Xsy8AORS2VmC8x/e3o7nZHirrWyr5PRtndCusTvy2bdo7ztT4Fgr5CLGdbHPxJQbnM
	z83WSjffzDWahaCjklxucAjsUvQ1W4nH6JoomYUX/3FahcrPBNIX3NMNCMKhCcWZo0OdrofrfrR
	yLEUydfyH8SDO0emr2W15HgNCWSBM75CJqWxZnt
X-Google-Smtp-Source: AGHT+IHCb0k2dykBOSZ7iL2W5iDfYWIbDtl5cle0JXyRlnUFOcIwORjGAq1Aqe8xopL+PX/SJAo/C08ZtvLFCmyXFzA=
X-Received: by 2002:a17:90b:5587:b0:313:28e7:af14 with SMTP id
 98e67ed59e1d1-31c9e75a6demr3312358a91.19.1752660765786; Wed, 16 Jul 2025
 03:12:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250715163544.327647627@linuxfoundation.org>
In-Reply-To: <20250715163544.327647627@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 16 Jul 2025 15:42:34 +0530
X-Gm-Features: Ac12FXwjod6LQ65gQdx5Ie_iLGC16oEaTsSpUdM10nJ-9OVQaXU9hzDA63_xjg8
Message-ID: <CA+G9fYuDFgV--q+e+gZe0heZeGsc1+wxkXTV21dUR7dD6AByjg@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/165] 6.12.39-rc2 review
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

On Tue, 15 Jul 2025 at 22:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.39 release.
> There are 165 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 17 Jul 2025 16:35:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.39-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.12.39-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: d50d16f002928cde05a54e0049ddc203323ae7ac
* git describe: v6.12.37-168-gd50d16f00292
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.37-168-gd50d16f00292

## Test Regressions (compared to v6.12.36-233-g3d503afbd029)

## Metric Regressions (compared to v6.12.36-233-g3d503afbd029)

## Test Fixes (compared to v6.12.36-233-g3d503afbd029)

## Metric Fixes (compared to v6.12.36-233-g3d503afbd029)

## Test result summary
total: 320456, pass: 294460, fail: 6894, skip: 18627, xfail: 475

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 57 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 23 passed, 2 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 49 passed, 0 failed

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
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
