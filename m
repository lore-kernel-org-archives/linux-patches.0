Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3CE378C60
	for <patches@lists.linux.dev>; Mon,  2 Sep 2024 11:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725277770; cv=none; b=HKwN1eqAoJ2RrYd9LtyVp8oUX0MyGGpa/D+lcKTtnYyFs5Bh7eFPcCJ8ZmINDvla4HG/TAZxfltPjs3nItZvwaOeHiYxxt3KyHwPuO/FoaF/vFSWAqys35Ku0/3I7hbgPbghgSE/DFfdcYNf457o7aP7o/+mLzMQuAiF6PE/u04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725277770; c=relaxed/simple;
	bh=TbsLhDhTwEQZqG/BspoBxQwZG8kUpSJ8LMtZATpnDRM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u2/ZIAYGMGqlswqk7kNdHZogx9nUpnObbibjc4TDFL9if4nfc93pUt9QaUuZuetcQHy/PCQUDF5qNYiHvpB73mpMXOTQAmqHsRVhTDDeW06b1u+ChJgSK7VxN0CE9cipSamJ3lsIABXCYo9hDVZCD8N2L6ilygb6M3ZxLvyV7VM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DL1fW/1d; arc=none smtp.client-ip=209.85.217.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DL1fW/1d"
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-498c4d5a912so1577481137.2
        for <patches@lists.linux.dev>; Mon, 02 Sep 2024 04:49:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1725277766; x=1725882566; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cTifHbeYcxDQuXfliKouQ/B6JHrDG8JJUyn5xqITlps=;
        b=DL1fW/1dXTh/09oaoh7rSJkGfdJHNbY1t60RmlXCt/ETUYhhRs0tKlHKYRoD2NLl6H
         eEpbPY+vFRxfxfcyUaV+aF4+FVtpYlFBkFZonFvFwge3EbgLRSu+MlyoSPBVYVI6UP4p
         TyfpGThh2PKq5YVQwnmHIotvJ6mZAqoJ/fIn/bEB89wW143vDY1rbQL8b03gidvp5EUl
         8ZaKyypvqC1nsjUR8Xll3D5iQTwbHy9ILkSakFqzP/+hQsYALEITPD6tg/P4l/nXjWQ6
         DXKiTg8mmhjbra1Vkd2MpNrbEl9Oln5F7lF8DYwCzjn0Oa/yxltozJRU9AR7DpfBZkKR
         NaQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1725277766; x=1725882566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cTifHbeYcxDQuXfliKouQ/B6JHrDG8JJUyn5xqITlps=;
        b=BKKE5sSzzqjOIB5G//Z6YSDnRQL1bL3nCt63D6gKBmZebJAzY9qJftUK7oS8Mgjj7V
         aKfiFbD7XfsoTgNhFz4CfU0UL3ctiSw19N2yku1GS8S94JMiAQL/0V7buf6vLpFUXAhc
         pNVP0JRzdUYLXRwyHFkEOFyzfoQ7qWuMlwc57aYECvnlcI0Y4RjYlByV9K9qWfV4GtJy
         k58q9zD4GQL0N8c48HOaQjTMY3xrqrKFbLrZDmIs7Qzc85WcGkR79JWqntPBq0yTrtIn
         mVqQ5CEJBk2Xy79wMEgQuWqby1XUMySS74PARK7qsTLcur4CjFkXyhfNuo7zJnLAfg/M
         uGvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXNYjnYdvuFxPsd8zuQNEXjyykepaTpgPgO4AP1UdWQith3j8wxhbeSQYPCLI+jX68X1bi32PUo@lists.linux.dev
X-Gm-Message-State: AOJu0Yz2h7ogZTzLHWVYIYQGfjbhzs6vmwPB8QDoOgC/pZlVHp0quq8e
	RGiLFnJDEeG1OF1g8qnmlgjPN4OljHuzIltQQ+FU8Ud+nl0wyiZpYjcGUySxxvlBEmGMHAJ/Knz
	Sec1YeSP8AmHJ6CX55mirr4vfLP5ClE9+zVyAVA==
X-Google-Smtp-Source: AGHT+IEqJTMFzAtvhaYcjWv0okauFOgdky9k0/FOXTxZktuO6h2MRkyM3tNfux7MBolYe2+OpW4jCLLHXdWXrfZzrWA=
X-Received: by 2002:a05:6102:3a0d:b0:493:de37:b3ef with SMTP id
 ada2fe7eead31-49a5ae733bbmr19067756137.13.1725277766603; Mon, 02 Sep 2024
 04:49:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240901160817.461957599@linuxfoundation.org>
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 2 Sep 2024 17:19:14 +0530
Message-ID: <CA+G9fYvYmpUeain222FMmDCQ=N5qMrBoza=fO-jhNP5romhM3w@mail.gmail.com>
Subject: Re: [PATCH 6.10 000/149] 6.10.8-rc1 review
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

On Sun, 1 Sept 2024 at 22:01, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.10.8 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 03 Sep 2024 16:07:34 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.10.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.10.8-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 88062a11f41d8d4c9f723337833e4e9ea9324d5a
* git describe: v6.10.7-150-g88062a11f41d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.10.y/build/v6.10=
.7-150-g88062a11f41d

## Test Regressions (compared to v6.10.6-274-gaa78b3c4e7ee)

## Metric Regressions (compared to v6.10.6-274-gaa78b3c4e7ee)

## Test Fixes (compared to v6.10.6-274-gaa78b3c4e7ee)

## Metric Fixes (compared to v6.10.6-274-gaa78b3c4e7ee)

## Test result summary
total: 199765, pass: 176468, fail: 1757, skip: 21311, xfail: 229

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 127 passed, 2 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 28 total, 26 passed, 2 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 3 passed, 1 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 19 total, 19 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 6 passed, 1 failed
* x86_64: 33 total, 33 passed, 0 failed

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
* kss/1_kselftest-capabilities
* kunit
* kvm-unit-tests
* libgpiod
* libhu
* libhugetlbfs
* log-parser-boot
* log-parser-test
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
