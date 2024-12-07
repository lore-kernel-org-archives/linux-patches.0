Received: from mail-vk1-f181.google.com (mail-vk1-f181.google.com [209.85.221.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D966414B945
	for <patches@lists.linux.dev>; Sat,  7 Dec 2024 19:30:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733599861; cv=none; b=ACzcm81mVC7K2H0Lx+P4hFRm/VdBb5QS6pitE8XCNKisLmx9XLSdKW15jZ2j7vx/kMuonqD1KhfqUdhyCB/X/Os4g+IB7kgSLQ5vdCqsD5cS+ycuGtl5zcef+vRzndIsKDutJA87B2h80ktJrxEy3p/CtBtrICS8X4mZFT2/n4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733599861; c=relaxed/simple;
	bh=MWIUYe8rynxHFhV3H9EzZP2GLleiXwTjfN9R28Xsoi0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ec4ZW+da4h9cwYkQVAmpdgTkusLi0A4410xwLRHr9/K2ij7Ur2eB/XzbT/YBhsLyWCUIslWEOhali4a4yCQdOF9mT4TNGNWsEQ/lW/ziIydff8LtkQjh/gIXD/CptD+gzr+EaeSrGpU7wvZy3gLOdZc7oNtjtvOdLSKqbzOnLBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=MfRVnJMD; arc=none smtp.client-ip=209.85.221.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="MfRVnJMD"
Received: by mail-vk1-f181.google.com with SMTP id 71dfb90a1353d-515e0a816fbso915377e0c.3
        for <patches@lists.linux.dev>; Sat, 07 Dec 2024 11:30:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1733599857; x=1734204657; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mJMJPDqFDO7AvNtISrsM1UjQtxcLbmrzTjKuUV+bsSk=;
        b=MfRVnJMDrLwyfBG+qnJyYjlBtKq3yv8rsK33hJQ5dVXnKuBMdI8PFswXTDMt1Kfeec
         RqlSN3xLBr4o4+xkW32FWPUuJ56pzb4aF9csNhkC0uZeG7tDO9Tuz2+OUvY7EG60dIOU
         8Jrg3WkPxARzZgyVk35VHFYa/JKNa9dm6T2LtemCC5m/rkb0HeAJTkaJ91LljP962Hht
         Ks/gNfCJ/H910R8LKcmaUQLNufB+6PJBgtLg10m3Kn3IEmBChLVw/bMZdDjsOSh9YaHF
         k6dBnI0WPR7xiwc+IZ+TnofoBBo7QRgnwt7heMX5rzwgHDv67S2GMbRa/tgUagw2GpsR
         DIlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1733599857; x=1734204657;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mJMJPDqFDO7AvNtISrsM1UjQtxcLbmrzTjKuUV+bsSk=;
        b=oyedkZIl4aq5DEuQqn+AC3rdV2eSJt7oI9j8xbLI4+iu6x0O91b7dPnp71OBNmNZTX
         F2rhN2/1PV79oEsF6+KO3YbzFmbu4ucU954aPXPRMdUWbKUp155lg0Z1EM2BWuWV/EMW
         TFzF6TgT8+0aPe59n3bIX03xaAWCgieXnsjlgIWajaM3o3PTCUB8vUhF0e6alYgVThbJ
         oogcYbhxAvc196nCCpYwmPJeZEpnWaqIJxAr4shvwgrUeuHdebDkCPDkrGep92FakJ7l
         AGvjSZeT8QUcDG7wh9KdX5xbfdzwSaW8/tdp6GpKID1yQZ63Dg5hTzsS01+rkZPZNJnL
         wPGQ==
X-Forwarded-Encrypted: i=1; AJvYcCXiOt5xmxkLjhudeD+uXJ4sMZjtaTXq8JkAMccBpKfF/IzM6tzJmPOmIqJgUHhN/wZm54/4cQr1@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+LNQOV9i14lAVWhdpZqhk+n44OcccJrOrt/Ovkyq01G08n0Bu
	6oK/qS5TTqhg2+WqqBz/JazlUNk8F3HA6MxLgjUseFF/VHQ+/oLmN+9wreLFQ5n5i57FIAJtrdp
	nA7OgBNfpShtQg0KkyQm4vTsTHNpGYNov4wouHw==
X-Gm-Gg: ASbGncvgCPdMnVd7g7Bt9MUbh+pUtmLpqbYrLyl2PCmUfb49wrzwwkOPB4Yi1zOlTEI
	h2YucX1TVuoOLZuObJ04oPmatTL9qZ1JCmhKokQO+ClOy8YojEa7KYyM4JlDvn6GU
X-Google-Smtp-Source: AGHT+IETMLvnjf2ePYPZmXA6raknYI25DS65BZcGw3tt+idtCpI6lOPHsr2VFcKdZpZEQ9i6MUgEhoh8dwN1lRh3vJ0=
X-Received: by 2002:a05:6122:1da3:b0:50d:5e21:ef39 with SMTP id
 71dfb90a1353d-515fc9c08a5mr7801610e0c.1.1733599856750; Sat, 07 Dec 2024
 11:30:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241206143527.654980698@linuxfoundation.org>
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sun, 8 Dec 2024 01:00:45 +0530
Message-ID: <CA+G9fYswik7dS-Sy-gmZZKT6bdxcxT1eRn4=994VV5R0RGfDxQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/146] 6.12.4-rc1 review
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

On Fri, 6 Dec 2024 at 20:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.4 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 08 Dec 2024 14:34:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.4-rc1.gz
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
* kernel: 6.12.4-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 91ba615b0f093358fd3961fb76f3479193cd18f6
* git describe: v6.12.3-147-g91ba615b0f09
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.3-147-g91ba615b0f09

## Test Regressions (compared to v6.12.1-827-g1b3321bcbfba)

## Metric Regressions (compared to v6.12.1-827-g1b3321bcbfba)

## Test Fixes (compared to v6.12.1-827-g1b3321bcbfba)

## Metric Fixes (compared to v6.12.1-827-g1b3321bcbfba)

## Test result summary
total: 158647, pass: 131960, fail: 2855, skip: 23832, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 138 total, 136 passed, 2 failed
* arm64: 52 total, 52 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 3 passed, 1 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 24 total, 23 passed, 1 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 44 total, 44 passed, 0 failed

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
* kselftest-kcmp
* kselftest-kvm
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
* kselftest-watchdog
* kselftest-x86
* kunit
* kvm-unit-tests
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
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
