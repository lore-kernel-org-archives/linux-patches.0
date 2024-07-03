Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8F1186E32
	for <patches@lists.linux.dev>; Wed,  3 Jul 2024 18:22:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720030970; cv=none; b=Hf8C0NomBH647ol2wPKPVEq17SkJEzyubTR9UtnwwAzh1ze2XnhZk88D0qvSqddbQWqth3CJrhcLkjEw3sLkX4PS99YW3I6V3NLqMWGb0u7taJokR+OkGdxnQi/cz+/Gh6Q79Sb977oyNTNoepIHKmOunJGiJ7NBU3eHwAxKt0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720030970; c=relaxed/simple;
	bh=/VpfopDdBJqybxcmcYuCrbmMEGO159jxoReMIiv7UxU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L+iqJWmYddPTTPXDv5Z5QJ3OBZEzwtjDc4RFXOm7tVbKQZbzdBcVQwZBVmBksVTXFwRNPv1Fz0iVDTKiikLfQ3cYDwX0Tx0JnDvXSU50UWe/j2SEX4MG04/lLdG1fPfd12pdnny7iOqvrWXfiWA5RGN7WiUIYywdAnQum1jjkIA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=V8hfRMHc; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="V8hfRMHc"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-48fdec0b7d1so325598137.2
        for <patches@lists.linux.dev>; Wed, 03 Jul 2024 11:22:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720030967; x=1720635767; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lutnZZkFQNrPT1eWeDjIvCFMR4EQlZRCPH9vYtM3N5Y=;
        b=V8hfRMHcVqbNq0LBBETHwXXSU+e01HrLlO61jrEE956vsNFu72dabvCgaVRFyvRQLG
         Hxj/RnMZ7h4LSW811e+nKz0iGpmtp9u+9XWMTYgSqIu+IBcCSwsNFfyMCsQ7mhiOoDB7
         Qo2fdt1FKOqGdFWwCk1lWcgIetOpgLIFX9Le+lMNbEAMe2GSy7ssD7aVtVr3LwfO10+E
         EkMOblYNnmWPuKucaPTQhVkXZFW+sSC35iMdeSyg635T8hIKnhXUkiTxgJrDAfnkssHd
         SV3pnRLq9XqN1HYcIPw/UwzPLd0fisOndg9Uhckkc5cWN7+K+ulRDsV4nzRa/Nm1bZ6p
         ZsjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720030967; x=1720635767;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lutnZZkFQNrPT1eWeDjIvCFMR4EQlZRCPH9vYtM3N5Y=;
        b=TkG/Z3Q69NdfRv2kfcgtYKgjqJ6QVYu6Bk1ek20sAg73kafSPrAQcVXQ7f2DTbjUGv
         uDZsV7dkUa0q24jhpptUR+5OqdOWlMyTDR3vH0kdeGa4LDonJWI0we5YWg1tWKIDezCJ
         ppYR88gX+R/6iKFjgYNd7AubzIb9kTh2uneVFIQJmh2f2U3IPp3UHqxRWfCti9M34E4e
         ed4X3IufkjpsG2yNjXKvXeE9GTCzK4//R4rucRssyj5ckbB2yODeNGA1UPlB1gvLw659
         h/g3en9YgeMS22XKQO9nYUYZxCdu/40e1M3vQaHvsUsUDQlzkuT5kN2Hio4mWtKbPe/r
         kSbA==
X-Forwarded-Encrypted: i=1; AJvYcCXrVPl+lBKvlx2Jz4ImgQzK48vcBYssjM5QnRrrsvjpdoCsp+qXnP4HysF29oYtZqLvv285d+UWjVuvM8cpnDziGIK7ShNNyg==
X-Gm-Message-State: AOJu0Yz0srA2Kz/jjxHKYNzftebM6lpbdZAohN1mopiR1HQr371xxRe1
	JznwAR1UwdsbcGOejH/FVpuHiCV9QuRxsWMgkm19Eup1i4yRoJKLnpmxLbZkPOK15Vfac8do/qy
	+4R38WlKercNrYmqWCOizqHTUecCIScQstC21xA==
X-Google-Smtp-Source: AGHT+IFpo8fAUFUxFe0XR29oyqi5sap+b0XoPBzzgzJgzGnPTgyl68a3ag8cVeM9fud5rxa6d6z4HiMdoyBo7onLUX8=
X-Received: by 2002:a05:6102:549e:b0:48f:1bc6:345c with SMTP id
 ada2fe7eead31-48faf06a80bmr11310839137.14.1720030967212; Wed, 03 Jul 2024
 11:22:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240702170226.231899085@linuxfoundation.org>
In-Reply-To: <20240702170226.231899085@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 3 Jul 2024 23:52:36 +0530
Message-ID: <CA+G9fYvvPTUkjTukNZ+Y0Cm5QdHocv1qHFzZkkB0mL86yPj1iA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/128] 6.1.97-rc1 review
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

On Tue, 2 Jul 2024 at 22:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.97 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.97-rc1.gz
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
* kernel: 6.1.97-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 54f35067ea4e1147c1351417237ab846a0b37ed9
* git describe: v6.1.96-129-g54f35067ea4e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.9=
6-129-g54f35067ea4e

## Test Regressions (compared to v6.1.94-218-g0891d95b9db3)

## Metric Regressions (compared to v6.1.94-218-g0891d95b9db3)

## Test Fixes (compared to v6.1.94-218-g0891d95b9db3)

## Metric Fixes (compared to v6.1.94-218-g0891d95b9db3)

## Test result summary
total: 223345, pass: 192480, fail: 2666, skip: 27820, xfail: 379

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 36 total, 36 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

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
* log-parser-test
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
