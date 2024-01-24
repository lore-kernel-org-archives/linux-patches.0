Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40FF3634E8
	for <patches@lists.linux.dev>; Wed, 24 Jan 2024 12:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706099048; cv=none; b=EtdC0MUexuVQov0B+Hyj1dMC1TSSJlmFhgmikSLB0vi7JaF9qTtYRQAu+WwgQE7tNBSF/PwTd27KJ6uoWb9BRdn5JkzojJCUB1AY4PnpxaJG+ZRVL493i+tWKhDsH4hx9vhCeXL7aVIAWXoprNxw1d7CW3H9yHvs/4qlCQFEFBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706099048; c=relaxed/simple;
	bh=rGdFk8uHaZxrli54fy00MBEoautph1gscqn+/tFyVKo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Op4F9a0M/zdEqMz8aPBjWsNLmmhtumW1w9bGxTLe3y40qPQ72CfP8he27xaFMZeCctgMduEYUdtzuKJKd0H75DsBoHM6XZ849Sl/XN1+Ae+n+sYxVErD5vgY6DLX0wa/iZQWzXv/QYCtuktJxd4VJbyLDi/15FvQa66sxeC6mhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=rYffkccW; arc=none smtp.client-ip=209.85.221.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rYffkccW"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-4bd691f1038so282239e0c.1
        for <patches@lists.linux.dev>; Wed, 24 Jan 2024 04:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706099045; x=1706703845; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1B/KKXJqlXiP4vwNoP9M2ztX30MmH6mObOLpZu8w8tU=;
        b=rYffkccWm9SBqupxb6lC8+EUWf/oD0cZR6h9V5Bk2K4vZcXSot5SgyeLMAapAi7Ttj
         7cJw0EXotL7rTaScKel7FQ+iF1uH8BqH0FANDFXb9cpELuIO3VePodbT38lQ6OmvnHsw
         3BePGyPTlWHgOL6a2rfwHnjZ6M4uPTB+Yu7uBH6TOgfui4x0T6sqH2QPi8p41YJCBvzj
         iDxWFx0M33a9D33+NudKIHJPNNUKRHbbFIBhankBGWEx083GCVkA4G5z1o9LCTvswNVE
         NwFXGSpdD7mTg10yIh9JSbrbeXc1kwr+Ong+8T/V3iXmcrQYI+1HHtw2+gHUvUYfCC8E
         27Ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706099045; x=1706703845;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1B/KKXJqlXiP4vwNoP9M2ztX30MmH6mObOLpZu8w8tU=;
        b=PwxdQa4Zh+KQkVUlvHVtyjq2YIhvjHJm4p+X4IpY92SyX2hVy4k1FaMxEIQphMW+H0
         xwdm6WSiIa50t1Su3nS2G13Qwgu2xolNS3SYScKNc3/JCSm70psaaKVE+g5sc4C0OHqZ
         dplZD28tCp68LEBFIu5121hakVcdDg8osMGfnWgnIPVWMs+4AOQBecy6R0N2pTyVOzlN
         eddak0zbfrijRhLd5ZX0gMl9otEV1f1s1H8oExa4d3mVBxJs9LsyCr1Quz9VI7WhcUIQ
         DbJffY18/raqMOf014umuYz1mdsMpM9NDWRaBS27//3ZVmHgSlv0Ydzb3HKMQ/QQqWZf
         IDtQ==
X-Gm-Message-State: AOJu0YyklT0t8PiMFvjkACIbqfgXizf4wNvZBTLzVpK8EjgRWcMFrALK
	pXTlquWYHG0H8fBKrxX/hsxpI56nPmAn4lg8T4aG3dnmYWiDkoWY+ryHI+DeAKFH1+JP0a1yDm+
	Is5pFfTpvUFmKYt1lsofAVMeJTMx8snKsreWkNQ==
X-Google-Smtp-Source: AGHT+IGku4y0SXA0K+K1f2yfKzalu4Ew+iZYDkbMtOJf/XET/MR7IHirdCrkQGkQf3c4pXRvooJ32OSvS3GM8KahpKI=
X-Received: by 2002:a05:6122:44b:b0:4b6:dbc2:1079 with SMTP id
 f11-20020a056122044b00b004b6dbc21079mr535782vkk.0.1706099045094; Wed, 24 Jan
 2024 04:24:05 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240123174544.648088948@linuxfoundation.org>
In-Reply-To: <20240123174544.648088948@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 24 Jan 2024 17:53:52 +0530
Message-ID: <CA+G9fYu1pXV_9LSn2T0PNaSUpH-WWtuhaDqj1h4u211DYXMT2A@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/638] 6.7.2-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Jan 2024 at 23:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.7.2 release.
> There are 638 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Jan 2024 17:44:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.7.2-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.7.2-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.7.y
* git commit: 2320541f64baa0c9f5313c2100809a2e26d333de
* git describe: v6.7.1-639-g2320541f64ba
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.7.y/build/v6.7.1=
-639-g2320541f64ba

## Test Regressions (compared to v6.7.1)

## Metric Regressions (compared to v6.7.1)

## Test Fixes (compared to v6.7.1)

## Metric Fixes (compared to v6.7.1)

## Test result summary
total: 142436, pass: 124243, fail: 1105, skip: 16870, xfail: 218

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 143 passed, 2 failed
* arm64: 52 total, 50 passed, 2 failed
* i386: 41 total, 38 passed, 3 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 25 total, 24 passed, 1 failed
* s390: 13 total, 13 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 45 passed, 1 failed

## Test suites summary
* boot
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-kcmp
* kselftest-membarrier
* kselftest-mincore
* kselftest-mqueue
* kselftest-net
* kselftest-net-mptcp
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-sigaltstack
* kselftest-size
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
