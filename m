Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0588C25D8FD
	for <patches@lists.linux.dev>; Wed,  9 Apr 2025 10:53:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744195998; cv=none; b=Bz+rp0TVb4OGC+6mkdgevB8wnAhtrWyYEdMdgoFPGO8I5OZMyfolze9cVp77yPpkc5nEEbFVtLyJhr7koyuefolHue6tTvbaYMdZXyi1IDJ5N7Qn/7Otq1l23NSMylbPRsoNZiFBXmY9QwWnukruDnRsmus7CZ7is3ZVPQmj1A4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744195998; c=relaxed/simple;
	bh=Rx3deIVSJsCpMffhYe0+mXtPcPwYju8RaKlb1UWGh0U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=CmXsVEMmcLq3Us5ZTzKuqP7xfoOaJ+f/PS+y6CIxrdaGZe8isGVidg3NrauMKAY1Zsn8BrCRCNiomkJ96IVv3epwiAFmp+gjPWHdxDfadZNC/PKbOvwUNvg5QmYU+EEiC3HdPoiAkhCd8Reoh9pSsfdLYDZjVfALnasQpx+3wRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=cDqC/WdD; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="cDqC/WdD"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5262475372eso3079911e0c.2
        for <patches@lists.linux.dev>; Wed, 09 Apr 2025 03:53:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744195996; x=1744800796; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eiSuolfqjKUCKmLZlhGjwnD6UU5gFbBKHX8f8BQoFeg=;
        b=cDqC/WdDWYgLqz88WFGS8Zsc+9IbEcPCUi47sbPY0YYUEecyiM7YEOt+8nd6M5FJiw
         EkETEloTVtvT2T9DNsfKJD5K72tnFDS1dyaM+BkoAwM6cgmTU2CdrjZ3sDlhKrKqLCdn
         2ZxZmLZZ73UaUjDqY73lBbvBSuIz3x0lElfvWsxaUVHD4RPnBNTyDFVi0CQPIOmzIYHv
         V6Ql0miyb4ajPSmYiqJfep9ohp/rcGlbylyU0eweFZ9MR1Jgp+sKEEvQxcL+lZYryWk3
         yAD9PugxHF3FRbFDNT497VkX12/kTGUtQe+QKcH/qQMiY8MH1Xs+vkVGEEJuDI361L/h
         XtkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744195996; x=1744800796;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eiSuolfqjKUCKmLZlhGjwnD6UU5gFbBKHX8f8BQoFeg=;
        b=QpJJzXbgD0TjO2GHqnSYT6wl/FGe2GuG3Swwu/y3PIQ4A00T1yzkol3UXVoLoiD8r+
         wAVuMLI0eQjC9iP0KZtaUC7LuguaHLMWeozT1iX5beiqb5ENVmMhSMtJ8+849JM/Oa18
         dSCT3rI8mCHC+HjwSZR04oDdDTvS/RGg8jB/KfbK1qIu4Ts4sJEnMn+sfldLTkAe/BA8
         ONbE3ce++jjaz9+S/iJr+RR+i7A6zr83L6dpbvIwlOOYU0ejubPaQzi9/BOJpvNVTmj8
         EUtEk3hiwv6yEsT/qf1ZE05BS/jtDhPVCglt90fJhWeYAKzgzo/hgi3dzd4B0P/ifltO
         me9Q==
X-Forwarded-Encrypted: i=1; AJvYcCUBjIvIheeCG1zz6j7wBlskqcsqLkUkQFGylL9qGzdIjXGXM2Z1r30P/EmIzSCzo4cYDy44L1BJ@lists.linux.dev
X-Gm-Message-State: AOJu0YwM3N7Eu9zPTOpt5lqVjE8d6T+kNa7EArJQmEFBRH+bhJySLezO
	y/U8BDuf42HWXFK9QCVQXZ1yutoU+GA/xvFqZ6FTZyrvvNI9ghcrqfzLZdWzgSTHdysUx4lt26w
	ap1KRqZInZ4H2/rw6HsjUXeECFBpP+y6+MTYMKQ==
X-Gm-Gg: ASbGncsWPK+iGLa1cYu5JlNXbBIPhXzox3PvMA7n6K3PV27fkhQgLXrExZ8tj+SpQE0
	nXtEXr9VbUuPJMbY3DNwab+4t3q9Wy/sYmpGnVvTFTEqfdrQQrx68QF3Ml+eMvoL1CZ/9dGN73v
	Ithh2ZHqrfXndBKeYyV06VA/mwH0U45lkHfbUkPqUA8voLPS9ebf2Cj10=
X-Google-Smtp-Source: AGHT+IHUUDx6l8u13RcSCGLZYeTwydGM6vMjR+/x4CWrRBmQ0Xu18i8GLar6TCKnKPo4jFCSrfqJUH+ol6sLG0X2aoY=
X-Received: by 2002:a05:6102:3310:b0:4c1:9738:820d with SMTP id
 ada2fe7eead31-4c9c4175156mr1513729137.6.1744195995808; Wed, 09 Apr 2025
 03:53:15 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250408104826.319283234@linuxfoundation.org>
In-Reply-To: <20250408104826.319283234@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 9 Apr 2025 16:23:04 +0530
X-Gm-Features: ATxdqUEwK9jEVkiLJOSPz0AkhU_UIpO5zjMmuDtWqiV45Powfno279jQC9NPjCw
Message-ID: <CA+G9fYtQnkt4vJ_e5GkxSCn5=sgO2MK+cms4pitkmnveY9M2cg@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/279] 5.15.180-rc1 review
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

On Tue, 8 Apr 2025 at 17:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.180 release.
> There are 279 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Apr 2025 10:47:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.180-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.180-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 0b4857306c618d2052f6455b90747ef1df364ecd
* git describe: v5.15.179-280-g0b4857306c61
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.179-280-g0b4857306c61

## Test Regressions (compared to v5.15.178-617-g4372970bf866)

## Metric Regressions (compared to v5.15.178-617-g4372970bf866)

## Test Fixes (compared to v5.15.178-617-g4372970bf866)

## Metric Fixes (compared to v5.15.178-617-g4372970bf866)

## Test result summary
total: 51097, pass: 36064, fail: 2716, skip: 11897, xfail: 420

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 102 total, 102 passed, 0 failed
* arm64: 30 total, 30 passed, 0 failed
* i386: 22 total, 20 passed, 2 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 22 total, 22 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

## Test suites summary
* boot
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
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-mincore
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
* ltp-ipc
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
