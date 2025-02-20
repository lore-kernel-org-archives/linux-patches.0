Received: from mail-vk1-f182.google.com (mail-vk1-f182.google.com [209.85.221.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DE81F1538
	for <patches@lists.linux.dev>; Thu, 20 Feb 2025 11:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740051448; cv=none; b=Ogzn6xdw9HQgDzYJCwNVBUVRsNj70p3LfKYRcwMUqMz/ct/mmvTqEpJVQ4wpBVyX+HS3Hlvq052QJJrU6gf9QGKS7lxv56+0e7R3r4oSt1b4YRAXO33+RLXCwLYBqr+4JCOfQOHxegvuUCBpXoGQaFrDbrsFaA3r9VNncrVKwLA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740051448; c=relaxed/simple;
	bh=88G0YOIoPPOL/EjQy1wtDWVST89b/CpWuK/PGMVcl54=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aLbFrEKMIR852glngsboLLkKOnvu25F+YHHzW2H8za17IRH/E38agiNKs152EuEZ8cZ+6u43Yipu+Ay61uV+O8hvgw+LT9PtWZ5UCQipUHO8Fd7RI48yMPoyf830Jy/xqblz6NU2VuyvZFOxyngglNH3NsszZ5y2S7I8qyvchOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sOJi7gci; arc=none smtp.client-ip=209.85.221.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sOJi7gci"
Received: by mail-vk1-f182.google.com with SMTP id 71dfb90a1353d-51eb1823a8eso236684e0c.3
        for <patches@lists.linux.dev>; Thu, 20 Feb 2025 03:37:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740051445; x=1740656245; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=IuzVq9OkutvCNEzS5JGhlxT8oPc0+NNNyZEuizMTif8=;
        b=sOJi7gci+xf/O1/+0VG8UhpnIxHc7kRY0LVVMGS91u9SkJsSeUR4dzAXQXuhgA3u3z
         jietdL/fy8RhPephNdpLZliJYL5AfQBOjm/KpKwTdZrWnFOPu+jKOWbjDRvNuevRqYMr
         uhizF7fulfOJF3JYgR17Ox78fVzE+uHUF0OL3tPYYFY6Gd0YsG7y48BALwQZmnPcldb2
         wii57iyviclpVPXj++xQ4tTMXrQkKvBQVHl+Ha7z9adKmjWfwwdY+bXIXrrWCjCXT8I6
         IO9IBoBKkKNp6CZVzV7JNvwu0LPqa/aZfGA+0ID1uTZZs5xUQR2fQAnYvBG4p/rRJtXv
         T0Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740051445; x=1740656245;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=IuzVq9OkutvCNEzS5JGhlxT8oPc0+NNNyZEuizMTif8=;
        b=C6xvkyZ8XyndRCdYSMib3QYGbce2wXW8sDmDkBLZxqOhd2w3lMXv4J3Q6yGsR4kdev
         7+giPV34+9hw8iL1AnPBOJ4Phul/6lYMwf3hcY+3Z0Z6POdpovtyoM9RscMMCHpczHuy
         fLeLyQPi7v3ZkuqzomrkoyEi6qtg+tnn4s1oj2qg2YZ/Wtc/FzOdtcR56Rc1/lwCF07k
         YAoDCAXSw6KGCpSho4wr0AuYoYIhtgMfWJ6OA10Aenksns4MeVoRJcaQEfxARTgWIRTi
         qyJVB2Dk2h1DApQLdv1JxarBv5fNy+3UzLHsHPBLgljC6TGc7l09A3VVaqrADpmOSGee
         rJyg==
X-Forwarded-Encrypted: i=1; AJvYcCXqumBpl0bcXpbqo5l/kaHWcFdyKMJBsDJI9u3Q2q1/YCtTe2uNyPylHB2jwmlIgzwgmW9cSCWh@lists.linux.dev
X-Gm-Message-State: AOJu0YwrZTaS9qZ+wH9ABU1ZJDuBg1MuQUVSGqt1do2VPdbyisvXo1Rf
	AzHtjodLYfoT3T45015x5hbJ46kQjWx0WGQqbmzrQAa9XGeKEkF7uEpeyU2tuhi9S5q1EcyQ1LI
	c0tAmexkujW5jiPwbxVmWj+CseCNSzJPZW5gs4g==
X-Gm-Gg: ASbGnct5NSO4mGCdcGqov+h1p+m2YfYDsWaeiWCbawL5FzxbCZ56DYsPyOoGviqr1jU
	Q9j1q+KRfvHwBswccpvP33gdw1nuRmWqp3M5/Xg+KmJOgsIpZloC9ed1t0j5iCF7/zZWA23unwU
	42sUGJsNpVbr9gSMh/evHvoxQYtadX
X-Google-Smtp-Source: AGHT+IHzJnQ8UdPjYSfM/OBiu2LSuTlvIs57FBk1cINHCNnyxHhaqri2pojhFlOAyHI/OO7q6pneJlQKoZbBkFzte7w=
X-Received: by 2002:a05:6122:506:b0:50a:c70b:9453 with SMTP id
 71dfb90a1353d-5209de6718cmr9371127e0c.10.1740051445536; Thu, 20 Feb 2025
 03:37:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250219082550.014812078@linuxfoundation.org>
In-Reply-To: <20250219082550.014812078@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 20 Feb 2025 17:07:14 +0530
X-Gm-Features: AWEUYZnQO4inOznO9_79aYbIKplawCDHNLm1B1JD3EKc_OH-xNl-HvFQIbOwsf8
Message-ID: <CA+G9fYv7WoDA1OC9VtQ6qAqwoaJA5+mpWMahE+7j+vwp1dTS6g@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/152] 6.6.79-rc1 review
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

On Wed, 19 Feb 2025 at 14:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.79 release.
> There are 152 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Feb 2025 08:25:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.79-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.79-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: de6988e4026e1da2b3653e74a33e46860cb3f717
* git describe: v6.6.78-153-gde6988e4026e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.7=
8-153-gde6988e4026e

## Test Regressions (compared to v6.6.77-274-ge4f2e2ad0f5f)

## Metric Regressions (compared to v6.6.77-274-ge4f2e2ad0f5f)

## Test Fixes (compared to v6.6.77-274-ge4f2e2ad0f5f)

## Metric Fixes (compared to v6.6.77-274-ge4f2e2ad0f5f)

## Test result summary
total: 67097, pass: 53621, fail: 1765, skip: 11452, xfail: 259

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 127 total, 127 passed, 0 failed
* arm64: 39 total, 39 passed, 0 failed
* i386: 26 total, 22 passed, 4 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 18 total, 18 passed, 0 failed
* s390: 13 total, 12 passed, 1 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 32 total, 32 passed, 0 failed

## Test suites summary
* boot
* commands
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
