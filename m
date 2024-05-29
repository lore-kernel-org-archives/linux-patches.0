Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23CC715B97B
	for <patches@lists.linux.dev>; Wed, 29 May 2024 03:30:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716953460; cv=none; b=pk9xnUJka4EWNpkteF8U0YLSupgNRKSHVRwPykJGC1PZWet3dwA9G/TxSziGPDpz1KL9IVwf9wl2g7YhTWAI5cmno+tmZwZ0lJVIfmYSiBYjK+S3AvpNVZYP71zcC/mzcDnNfkbxljSS1qaZQCIBfRbIZs/RRmoaTXHf4oPf0Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716953460; c=relaxed/simple;
	bh=WGvapV72YXaT1dVi/hBHchlcENMJadbSp+/Yz2t6elQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tsC9AnY6he7vuVp/QaGxLht7uzZwC0l19TraeSC/1vFFpqWBSMRLJ0cMQon+x/GqFiXisNL5rL4COc/XRS7OOMzIhSPvWtsygMEYL0YOzaTvzaPXF33fj0PdUbxHotES3hlTcsU82VbGl6IVEJpUxH/+9qg3ryrQ3eKYzw/E6Fw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kq1vlBDw; arc=none smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kq1vlBDw"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-48a417fd190so447518137.0
        for <patches@lists.linux.dev>; Tue, 28 May 2024 20:30:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1716953458; x=1717558258; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1K4+V+znJx86jqxQqY/ePetAkO7+psXvqg/o/9vnQ1k=;
        b=kq1vlBDw26HTFdb8wWj7nvunrKipYC4Yw9TM88Upay/+2fR2gKFLcRWFp4sVyl1ujJ
         XrkArMXoBzfhlncB/drAVVsGDvAk3LwZNFM77P7dJMVo0BM8bMRVyn5R/TIayoBAawCk
         y9DnoI2JGhqNTWdYl5vNvED9v3A/hu0FudyjYSBCOLRMwE+p7Vk8sM4VIX259HxoGq+6
         Y43Ml2cx8ufy1wbizxbAFNA0qRXKrWL3Pbsgrxe5fKLdF62+K/WCha1wJCretjP8/Hl3
         kWIAMUMlAJ/C1OqQkIthrJedpcr+t2odmuCuW/VYYsFf8Lx8yNjcBZNNn7CCJ86+vKhh
         gsRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716953458; x=1717558258;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1K4+V+znJx86jqxQqY/ePetAkO7+psXvqg/o/9vnQ1k=;
        b=VTNRxnvvyG0f4ASO/61pMiF0XjgbuJM26VmizjjbzDiHyt6vjODzVBBJbx0i7dVPce
         0e//2QPE9BHxE+7kWjBb6PrcR7fcB67deYOCYc8vGQ4JtwyIzK0jL2s2/WM4Kn72FWIq
         3Y5E5bAYx2AwNRHCm+XOXwusZeVeyKG5cHPKHhn+wOEm0BfcG8UveAX7d5jnmsPzgWIs
         Bfbb76t9Huz0BOtrjVa7AwXWmCLxtSAz+c7S6933IHOWm4LlD//FnDiJIca2kgQFbde3
         vHI8f53yvQgu7CDsF7RH+DbOhyeRJ2sU+x+W//Ko1+AwNgN2DXS5M+81Eo0cm5appJhQ
         yytQ==
X-Forwarded-Encrypted: i=1; AJvYcCWs6fojlBkW79sAYAHXLMqATtEfGmNshj52qxzo03aT2k7r5pXyXh8yLa8T98oYGNWfVZqKI9hAsfiFYKpfiR8m1s+A3JHYew==
X-Gm-Message-State: AOJu0Yyyh6iZmtCdrYf+csCjPtNlp7fdTZpeb4jjjIn/ioeOBhYJCZ6T
	yQvX9jOiAKrJErQB+3zk3xBeuFKWc8c1Dzq7XZQ7kmzCLCMXjAWIiAqoomlOWE8q5Ks3eiPBMGT
	vBFC3nWWMR5Q4DNNwS1nX98+wmo30dUdzGs8/0w==
X-Google-Smtp-Source: AGHT+IHF79MsyHPfbm23qYs9TFP6U6hAFAvWhrEOwBBivJaORASxht7MtxiGWgL39OIVbZT2P/itPNfpQX1GdGzIY18=
X-Received: by 2002:a67:f307:0:b0:48a:5abc:445c with SMTP id
 ada2fe7eead31-48a5abc4713mr8018251137.14.1716953458007; Tue, 28 May 2024
 20:30:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240527185626.546110716@linuxfoundation.org>
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 29 May 2024 09:00:46 +0530
Message-ID: <CA+G9fYvrzV1Y7bx5hJ0zNNDd9Q4p4KERfnreGS+E5NuCHp1P9A@mail.gmail.com>
Subject: Re: [PATCH 6.8 000/493] 6.8.12-rc1 review
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

On Tue, 28 May 2024 at 00:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.8.12 release.
> There are 493 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 May 2024 18:53:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.8.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.8.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.8.12-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.8.y
* git commit: 5a8ebc9c48a66c537b368b9f2794c7a951769213
* git describe: v6.8.11-494-g5a8ebc9c48a6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.8.y/build/v6.8.1=
1-494-g5a8ebc9c48a6

## Test Regressions (compared to v6.8.11)

## Metric Regressions (compared to v6.8.11)

## Test Fixes (compared to v6.8.11)

## Metric Fixes (compared to v6.8.11)

## Test result summary
total: 217214, pass: 189122, fail: 2237, skip: 25536, xfail: 319

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 128 total, 128 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 23 total, 23 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

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
* kselftest-watchdog
* kselftest-x86
* kunit
* kvm-unit-tests
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
