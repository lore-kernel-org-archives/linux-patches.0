Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226C2228C9D
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 08:51:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741683110; cv=none; b=rccEkTnryYtpwIpyl5wECxIMjIrtwlQ0Js5dbyNro+PaumxYxJnXH5ApTQEruhnPqJjwnT1VP/hjv68iLTfo3/VEoM/xn8aAlh6UNwy8szEkbT+IG5R86IEPrageU3yXUJkubrG2tt1ZuJPmFBI8MKkkc2e8E+ERZAvb2jADzgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741683110; c=relaxed/simple;
	bh=HPNdhAS6q4hJlEkYVU8ify7rPXAu5A0kWRiO/Tjhf0Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=oUOEzDG88athW5zT41ACgt0tngqTvjdK2fTuKFrn+HgYbnwAgwB5JcJQhp2G/YbRcHBzh6NHXw9ClKCVma/fqDJH2+8oo9kIpByei/8WpwcI2BMakT/TQWl24CdFQ6WiIZimnDqGPfru8wZ9kusdk/NCmpaAC7R9QEz+xHg8iqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Lv2nVS9G; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Lv2nVS9G"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-521b84da5e9so1875681e0c.0
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 01:51:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741683107; x=1742287907; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pHVvdfi9fw3XBMolrd6Lm9XR3k0CHaCADu/v/LPpSJ8=;
        b=Lv2nVS9GCSGncYpnbLylF/mjuQNhUTQqSSy4vQnhRIJJSZ8lsY85+MttVsVqXim/6a
         cSHgs/dF5d7MyY1S52TQJnkqBUlt7PCh+NDLiOxkaPFusR14FQ/YhQ143GyymSpAW+rr
         5qQ+DsKCQY21QfY+9RYFhjyy20rgGwnYDzCxL+23kK57xntHtPY06j3NSslxZ61wcPIs
         eLsY/t4UiXNB0Wm3CsTJDFn3yhZjYQeCcJh2X9KNOl2KB+WsmbznHXlgQuDC0VrS+EHP
         NUEfcIA2okikmO97NEKPXVeLbvbMmoPs63ihmhDpqx/qxgBvAw1HVdpKhVM5NIBEzUkg
         1liQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741683107; x=1742287907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=pHVvdfi9fw3XBMolrd6Lm9XR3k0CHaCADu/v/LPpSJ8=;
        b=w5Y8gz7RQ6Uzt0I3jvE9MHDaHq6n5XPQ+Jx/Y9ArJw9QcczoGf8rNKLNSM2BaitheJ
         OkteY/Dkxyx+Rj8jMsvtQWk3Aua9oeUNoPCos2ZbDcqxm5NjNlNFPXSnIcMveZyogfys
         kgRu8On/HVLk+Wz0aQjNZVPoCuMLsjScACoNt+rAQJcQCNtaC/WuE5G0IumWjWOx9Bb4
         qQeFtE6BdpNO/A84L6aalJbL5nX9dmZNACuYjAmCwzDoC4YI6Ybcs28ljr3hwR7LpRz9
         45Bb3khtBUzmq/ub3Xtdl+OIDgU0vvVUTQJ1b1SJNgQ1YkC4RoEiz0PXmsCke9NdWEJp
         FQDw==
X-Forwarded-Encrypted: i=1; AJvYcCV2Eu8SXRpo1w7+VZsHps6IetxTut4CPlR9PWyn+5PjOfzbD7Ay3x5X7YZ4/kBfJxiOCxknUcvJ@lists.linux.dev
X-Gm-Message-State: AOJu0YzVbSHKt+mLJ03lCpcR4/hL9NguV9dV5KrxbgrSlm8y27dCk/iB
	xLyM4Sx79jaF7iDSOaQw6jEbYx+5OPozjsgSW6c6+g4Iic1sLOf+YxsomSGXiCHxgNfXjxf2iqb
	W2BoGT/RApHh9u0aqGveJwKTXus25lb8DhAcuDg==
X-Gm-Gg: ASbGncujexVn7hOAz0S1TRe9MB1Iovl+CexMyIosTpetveQJnaY5rhdfZPab5o3dYKD
	Y0Vr8ajpAyaYNqheObAbW6OR7luDZ+1TbZ+hyXkgpVbI42EkIOp5p7ll+gL5+eO9EPriWsdpRuc
	zLRljeUO2LicaUcOSIkPnkqH3kpQ5bqMVHglUY2C8//lTJu5TXFGfyn0oVxfMJLrwVYCuQ
X-Google-Smtp-Source: AGHT+IFG87WJBUN07axEnNFBQO8GIGA3RY6dJYpFsIX3Fmx/B5ZuwEQC7eC7oUZsVpFKrBt8H5TzNtQSV0BzU0oig0M=
X-Received: by 2002:a05:6102:3c91:b0:4c3:221:8f47 with SMTP id
 ada2fe7eead31-4c30a5ec42dmr9492887137.13.1741683107027; Tue, 11 Mar 2025
 01:51:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250310170545.553361750@linuxfoundation.org>
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 11 Mar 2025 14:21:35 +0530
X-Gm-Features: AQ5f1JooV3MLbYovESnxXnmOYc1t9lEZkMPZWgF3fIOZCs9YHjSOSnUmd-UVZ5Y
Message-ID: <CA+G9fYsm6xnNuPsCSt7zB+-z6xhKrdLkwnHLkFT9XBCPCBf76Q@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/620] 5.15.179-rc1 review
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

On Mon, 10 Mar 2025 at 23:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.179 release.
> There are 620 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.179-rc1.gz
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
* kernel: 5.15.179-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: cfe01cd80d853c272b062feed8abd34216550de8
* git describe: v5.15.178-621-gcfe01cd80d85
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.178-621-gcfe01cd80d85

## Test Regressions (compared to v5.15.177-25-gcd260dae49a3)

## Metric Regressions (compared to v5.15.177-25-gcd260dae49a3)

## Test Fixes (compared to v5.15.177-25-gcd260dae49a3)

## Metric Fixes (compared to v5.15.177-25-gcd260dae49a3)

## Test result summary
total: 43796, pass: 30152, fail: 2641, skip: 10731, xfail: 272

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 105 total, 105 passed, 0 failed
* arm64: 32 total, 32 passed, 0 failed
* i386: 25 total, 22 passed, 3 failed
* mips: 25 total, 22 passed, 3 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 25 total, 24 passed, 1 failed
* riscv: 10 total, 10 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 8 total, 7 passed, 1 failed
* x86_64: 28 total, 28 passed, 0 failed

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
* ltp-crypto
* ltp-cve
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
