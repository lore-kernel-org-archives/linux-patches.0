Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B9833D1
	for <patches@lists.linux.dev>; Tue,  2 Apr 2024 12:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712062034; cv=none; b=G99DwfnnX2jU7eFJ6jMK5jIXwT6pc7+CnQ1HYCYpSjO7zi9EPE19WEIrG6l3y95Wl332FciDa1PlKrPiW36Wtnc6D2wOBKn99OxgMEWcRANsyYjy65pPGwwUaWkOvclpYuG8j0RaRRjSApBL8TZWqE5+IocsaF/VegSYY7PPrRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712062034; c=relaxed/simple;
	bh=y7r81xGJhGvZo4UNu8tcAQh6Pm1cop4NxxV+9nrHJUg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AkVIJoKJORZQ4jugwbHxBIGk1catv3PmdUDT643n/WmGgpssq2rsqrJgV4KPrAKeMn9ep7V2B+ACWaVtGGXc8S40J/U4uLIren01Iz6e7kJ3TQADpg+1YZ2ViRHWdpEquom3mh+g5bAdkbBb6LpxYn3zJpowHUoPPTntNnd/YP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yLOaw1A4; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yLOaw1A4"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-47651248841so1619299137.2
        for <patches@lists.linux.dev>; Tue, 02 Apr 2024 05:47:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712062030; x=1712666830; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KCvuoEY2B7r6zo9f6eT/+ISmVC7xlAWxrfabw7NgzmU=;
        b=yLOaw1A4Lbqtrl17hjcK7dosdRV5gDPGx+JZX7sTUfLgOhEkHgYaoGxMrvhkrQw9bh
         M5OIlndWsWZnF8kfmNZSOVTpvv7GCv/MRMEgSmmy1Dg6/LilssYFAWsOsA/iST3qRKTA
         MdfQ0pL22Cr+cmZf0B3rSBz7QflsO/Yp1YtUwiLOKErRUR+ASR5mfzKQICc7iRmKCl5d
         AwFvfU6y8mT93RL44lj2K7xqnj0zOmYEz3+fDQd1Y9ynjFVlDsSwZ1e3A/5djnmQGjrP
         Zum/dSUUhxaJnJtcZykawn7P7oSznUx1m7wn5de3+FVnyV2LrcetDCMCNKj9eUefqwPU
         I3TA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712062030; x=1712666830;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KCvuoEY2B7r6zo9f6eT/+ISmVC7xlAWxrfabw7NgzmU=;
        b=I7aepwcUHlU90fRHuerDyRG2PRmrTFfJUXoLy82NDAerd2Kobl0LqmZ+Ei2tGwTbHj
         rqmht2n5wXloIyZty2Vx2zeJUIJU6VoBS82cxxpanZNo42oBcSiUJXyY+S9605d8Tkg8
         X628d0/vi4q90eZx5+pbrDsz0eHsz8hwri+6moG84boEK0TB3NPnoBWo168buof5DXWr
         HrCnTsNnnmYXQbb1laZN0Xg2w3qpfaI2scKId5WwlpyreozTTVdZUNeymAO03p8x4ciQ
         +Birc0MTOdnt+VMqwQ32QMAsv1juXKdU7gJrJu/on051gmXiLvFcjCYkqDpExM339Qmw
         kCzQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNqUP/fxEKHwHvqUpPbc5PXOmjnGiroXYLNNyecxH0anf6FQq+PiDiMhmeH5qi2K8OHO1WRuzwSGNH0j1p7CSYCxwsk49c2g==
X-Gm-Message-State: AOJu0YzD6ez3kMcVGMQReN4H0GVMbVsiVYCBhMmpw3aZyWfpE413/Z5m
	lIrIu5xnDU0vq8PsTlZCzEIVTMjQDdnO2Hs8thIiSX9vlA1XmXVVP0EwtAgtNm/G3r7Fi5T/uIm
	sDhcrbzhAyBiBvQ125wV9O78US4V4zrRbFn86DA==
X-Google-Smtp-Source: AGHT+IER0olSgqW7huR3aO5YCPv6vu0CrtUUvbpJpH9rBf81cDKDA5UdfqUkMF3GdSGlM6Yl39uhsd8lOSxDgMt7MJo=
X-Received: by 2002:a05:6102:2ad0:b0:478:92a6:67d3 with SMTP id
 eh16-20020a0561022ad000b0047892a667d3mr915738vsb.14.1712062029047; Tue, 02
 Apr 2024 05:47:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240401152530.237785232@linuxfoundation.org>
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 2 Apr 2024 18:16:57 +0530
Message-ID: <CA+G9fYvMX1=ueS0SRKK00JrXt_OrkBON1-+Mp3QS51Yeiu=U8g@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/272] 6.1.84-rc1 review
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

On Mon, 1 Apr 2024 at 22:27, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.84 release.
> There are 272 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 03 Apr 2024 15:24:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.84-rc1.gz
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
* kernel: 6.1.84-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: aa2042702765a33750c326a9e153901b313636ac
* git describe: v6.1.83-273-gaa2042702765
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.8=
3-273-gaa2042702765

## Test Regressions (compared to v6.1.83)

## Metric Regressions (compared to v6.1.83)

## Test Fixes (compared to v6.1.83)

## Metric Fixes (compared to v6.1.83)

## Test result summary
total: 146089, pass: 124663, fail: 2421, skip: 18867, xfail: 138

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 138 total, 138 passed, 0 failed
* arm64: 41 total, 40 passed, 1 failed
* i386: 30 total, 30 passed, 0 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 16 total, 15 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 35 total, 34 passed, 1 failed

## Test suites summary
* boot
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-drivers-dma-buf
* kselftest-exec
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-kcmp
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
* kselftest-openat2
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
* kselftest-x86
* kselftest-zram
* kunit
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
