Received: from mail-ua1-f50.google.com (mail-ua1-f50.google.com [209.85.222.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1D5C1DAC81
	for <patches@lists.linux.dev>; Mon, 24 Feb 2025 08:10:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740384631; cv=none; b=RpABrxtWC+vRWo/6HVWFAYS3jzA2x8o84gs3a9fu7mLJzKtUa8EzOo4JJJMIwDX8AaVuf1mEEXRRmVuI/BTIwX3j7jqcvFcYk4ZbxySsXWEgaGG7YYkaiu+WJGMVahPAc/p3YjloZO3lyvFwnH1rk2D+HBplc4JeiUpLehE6iVU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740384631; c=relaxed/simple;
	bh=u8TrK9hYcC65/WeviX8JWvUBq96uK8ZgDDuf0b8u/ew=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KImR5MfDIEA71Si48jFv9rqdM3HnjjmHf7LB3YDOd3et88IN+UVHQ2U2KHUwCnx4hm7JNItYRsg9gyG8UtSGRFbkWDblJec25mBwEcBkMtXdRrETK73dsj587lo3iPZG5Lt/nFE0C3XtL2KPgP5XufwNLk7cEn+F9qNDZeg/2MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=wnp1WruK; arc=none smtp.client-ip=209.85.222.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="wnp1WruK"
Received: by mail-ua1-f50.google.com with SMTP id a1e0cc1a2514c-86715793b1fso1213649241.0
        for <patches@lists.linux.dev>; Mon, 24 Feb 2025 00:10:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1740384628; x=1740989428; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5rAfh0+TUi6TP02l6JXkpyL3aEAeCTCEFN0Bf4ro6c4=;
        b=wnp1WruKfer3g7lxVvdUYUxIu0daXr8otjRj8o3DbI7bBMc0DQ4HMKjl4YMVVXmUwH
         O7DzWYd367mU91l5vaDcnyVf0Wsh2JvWjIkDOnX80AO3WEDj/1h/jV2Eak3ucBJQNh2N
         Jg0MlghXwT50GKKPsfTAQEW0ljLywS5iZw9yXYFE2ZkMPah8XOt8X5+eoVxfpBpecA6d
         v3QNOoRrgGKQLlKKT9PL8N2kHWv4TuL8y0zO0MBV0V/cpfSK99cdE9hXCR77/jVsjmaZ
         HHBrsgPKPVxn/k+rulJA+7Kqt2zlqJYIJDvRrxHzWhN8Ok/U5X7ip8F5Js2Rcr1I+Jxt
         NrVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1740384628; x=1740989428;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5rAfh0+TUi6TP02l6JXkpyL3aEAeCTCEFN0Bf4ro6c4=;
        b=WRmsBSVheogwBudq2L7eSNBfxpHLQhpiP/izkfTY6hWSqaizGvebFLJz5ICMNDz/KR
         MpK9EYfx2ylbiwKFK9qTq7+YQKpwoNi8M35ecf4Mfxh2T+mwCmonl+Q8hUJsd4d7jz+u
         F+P9pnt9W1cCPrzLM6NVRObzOk2Y1oZ92y8qVSLR97GV52OwuudngnVIO0sH06LMceOE
         GkxvoBkYXqflauNVLX9wXBgB81aqrpXiEZOU+LllULpdEf3hkQWwZyXMTtrL2PiafOAY
         86laxYR9z5C7Pkd4EmuUTCZn+9AB3SXfrlx28Q1idpb69c9bLA6JNkbr0zqlILgtUVqL
         F4rA==
X-Forwarded-Encrypted: i=1; AJvYcCWM7QesauC+6FU2ZW6h1HdyJPTmuutrpYlEN+oLwtEmiUL793O0nYuKxsmsfIe/4dBw0rhMMe5M@lists.linux.dev
X-Gm-Message-State: AOJu0YyZeM24n8v/GQ8nT8xzgbhozK+IE3//FXjinznjQ+1rrGy+zC68
	Jqzqg3EcS41spAh5uYNbEYkE0LrLEwhnZSetdpBFX81gZsGcGTH9/MwhasO7oARpAL4/CIHQhCK
	WOs8/4wp8oi8aVyGooas1Mu9yd4gkqL5G8Oib/Q==
X-Gm-Gg: ASbGncsXdN/Zm0B3MdfMjJqJshql06mmdHOT8pdIWqFpowSF2YRAiS9d+PgsuZaULm9
	LSRFqYL8bAfb/A73qV3eTjJ9ekb5KdR5Be4A7iAQ9DHo7/iC6UVRinVtPZaPUCp9zxjLg3fg1ht
	n4gsvSed4NZUOMDaApL1B3Vha90sWyrXLDcpz9Ci3Z
X-Google-Smtp-Source: AGHT+IFtTzjpecd4WNbfJBrPmnNi8gxRNYitwtUYtxG//98YquxYsUWInAxrtNW/QbRt9da1gEn7CzWKqroyZsH5TV8=
X-Received: by 2002:a05:6102:c8c:b0:4bb:e8c5:b172 with SMTP id
 ada2fe7eead31-4bfc0098918mr5692399137.8.1740384628553; Mon, 24 Feb 2025
 00:10:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250220104545.805660879@linuxfoundation.org>
In-Reply-To: <20250220104545.805660879@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 24 Feb 2025 13:40:16 +0530
X-Gm-Features: AWEUYZkqBO2UQkfmgOsDe-rD71hPOBWtwJTpV4dFszBoXqdjV-sFVpZiDA8Hqo4
Message-ID: <CA+G9fYuoYfGft-2D88dCVQeB5mTvyf6ADkWau172BZs2SD99VQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/569] 6.1.129-rc2 review
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

On Thu, 20 Feb 2025 at 16:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.129 release.
> There are 569 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 22 Feb 2025 10:44:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.129-rc2.gz
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
* kernel: 6.1.129-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: fdd3f50c8e3e56aa4407011c21e440d1f39bf99f
* git describe: v6.1.128-570-gfdd3f50c8e3e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
28-570-gfdd3f50c8e3e

## Test Regressions (compared to v6.1.126-65-gc5148ca733b3)

## Metric Regressions (compared to v6.1.126-65-gc5148ca733b3)

## Test Fixes (compared to v6.1.126-65-gc5148ca733b3)

## Metric Fixes (compared to v6.1.126-65-gc5148ca733b3)

## Test result summary
total: 104367, pass: 81540, fail: 3794, skip: 18597, xfail: 436

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 20 total, 20 passed, 0 failed
* i386: 26 total, 22 passed, 4 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 31 total, 30 passed, 1 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 11 total, 11 passed, 0 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 32 total, 32 passed, 0 failed

## Test suites summary
* boot
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
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
