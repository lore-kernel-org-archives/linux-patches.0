Received: from mail-pg1-f174.google.com (mail-pg1-f174.google.com [209.85.215.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B2F124061F
	for <patches@lists.linux.dev>; Thu, 14 Aug 2025 06:18:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755152333; cv=none; b=r9cpMyo9tbA1nW/eKo1C7nIQMolnpMTP/F3hJouagyk8z9OLusxo+fneepDP/lT4GuEUVFo5VSYLzUUBL09nv/lJo3y9fvdFfgQqfOITrngdMAdAxgXqLwT4KxlYmxeCA/OIu2cylHbroEKofIuqL0MGCDNyrV0Pe2QAtBwQoQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755152333; c=relaxed/simple;
	bh=4ncyZacGunfO50btMmfn7MReSvDAIsMQ0V86SaO7m3I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=djOG4/N7x5BLlfbxCeAaW+MLl++32NFKiLYJiww/f8qxs+I7GIBctGe0Pih0AU1V9Ytm0oD4b0Az9TMkMhXrEYBtzIYx1+7DBY57eH4BySpTzyFTdns/ArCCBQRbA8PZ/4s6q/RRVKUkf7/iYN3b4fjZd4u43jgy8ZHIDooHZgw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Sq3ClvfT; arc=none smtp.client-ip=209.85.215.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Sq3ClvfT"
Received: by mail-pg1-f174.google.com with SMTP id 41be03b00d2f7-b471754bf05so626828a12.2
        for <patches@lists.linux.dev>; Wed, 13 Aug 2025 23:18:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1755152331; x=1755757131; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FVYoHiA4OWioHJGRjjS7sBw/dfBgPghCAuWYMygSBRo=;
        b=Sq3ClvfT+t4y68f26M2zQzO2/oTuTylf688I0s+4KKLQtUcNby895VIrb6pyAoY0wu
         /8xO2EWfR4Qx9FlHViR6Zu/SOW7UccvVUUcToaUPYCxqhDza8mwLYOLSrowlRUz8cjDv
         LMHAX9fru29VyxgQKYDfHYV/cPdjrxj5grQ59rKlTZ+OdxphYRY59fkQHRBCFytvMvs0
         8A4P2ePPKiqjApQj4Q+UoD/wCkVJiCJ5I8EomvmBoeA9jI67xuIOL4C3VfePFzZoJJza
         pnbgQe9PAeeNzcQ/QQFzkc5Je0NfHtGptOL87ytVYZaiI6cOvPzlFm8Ur8CAE0q4DUCV
         ZiNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755152331; x=1755757131;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FVYoHiA4OWioHJGRjjS7sBw/dfBgPghCAuWYMygSBRo=;
        b=QH0wfbW1L1JWlDR7zEaF5vibZg3WaYMZ3VDjbwbp+X+/JzJkEF7YA5I3zLvrTmLvss
         q6DJCxF78HjuDbhTaNATpulg/yZQ2C7Oi9aEpjPrRlF3m4KHy7zuJiguscwuLjWezMmw
         sTKKoIPBFePWjoWVkD7Y8OtP3unppWURFpH63D3swuargZ1pxQwIOF9Be9qA+WjqrEoh
         s1a3Q+QPsmjbWh6RJy5hYSRcSz6YTV4jc2cUKjDMKN312sNSgNFIVL8XZgdNRdCnUR3z
         JwhKiOX7//Cw1ZxrRr96XaiGIxD8pqffOC5ZGRgko1HuvtaPUuValp1Gi+mgSK4l/RKw
         mXDg==
X-Forwarded-Encrypted: i=1; AJvYcCVFpL5xwUaK5EKQKLWMPS+fZYSjF0E/h9ktNfw80odLZO7TPbeVKlVaoKjIZSUbKpDlmOBdZ5HY@lists.linux.dev
X-Gm-Message-State: AOJu0YwUijzmZlybkCSIzPYO6ZIy5+7Tf6g2lFj1H/TfA+MGe+9i2euZ
	uSGJ+bFfOtna/iOpac/f8ODd9klZa9LCFi+hbv15l0x+kdwdw6CPpRqVIOb7+AXkF4776GuTVwS
	2vxI+O6VHoSK9M1gl8OACAbFPrU/eQ8pGPubE3iZ0jQ==
X-Gm-Gg: ASbGncty8pFuoSdmz7EL6wTS+Xjg0usYowUjXWl8oVIlPAZNuu4g29c/yQTTJ+99Df6
	MmaVvwfgu5u6Rrfo0w3la20sPOYmFr1/mqNBV2Ze7LyuR+WLhd4noLlLmR3ZK2zBgu0sqL2p/9i
	M7G7fMjWN0zKz/Hsj6Wk7Ph+yq06xMY+mfE7mlxaarvqZGJI5gxJR+RkF7h5St3p8cr65O8ii5y
	7QRhoz6hWa9E/NFpDYMkO0+XES77u1vc0Vc93t8w6hGLrcWwJEyaoW0RGlkUQ==
X-Google-Smtp-Source: AGHT+IF+JGiaAocZP3GUsrFBMxJlJkthqOzpiN6ZQpV1nwc776gUguSzq/7yFO9BdbU87/LV2qjV17GNwGes+DtCtX8=
X-Received: by 2002:a17:903:3bac:b0:240:83af:e2e0 with SMTP id
 d9443c01a7336-244586ef73dmr29790575ad.47.1755152331399; Wed, 13 Aug 2025
 23:18:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250812174357.281828096@linuxfoundation.org>
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 14 Aug 2025 11:48:39 +0530
X-Gm-Features: Ac12FXyBqFyeMoQOpaAL4FurlRjkn-Zmez588T_Bm1WbHUu695lBgJJWNy1ckCQ
Message-ID: <CA+G9fYukypGY6DjcrnSCCHXekqpWQ1U7qWXJXKAp5aLpoxdZHg@mail.gmail.com>
Subject: Re: [PATCH 6.15 000/480] 6.15.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 13 Aug 2025 at 00:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.15.10 release.
> There are 480 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 14 Aug 2025 17:42:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.15.10-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.15.10-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 2510f67e2e346f399c76101231d19be2bc0844da
* git describe: v6.15.9-481-g2510f67e2e34
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.15.y/build/v6.15=
.9-481-g2510f67e2e34

## Test Regressions (compared to v6.15.8-93-gd9420fe2ce8c)

## Metric Regressions (compared to v6.15.8-93-gd9420fe2ce8c)

## Test Fixes (compared to v6.15.8-93-gd9420fe2ce8c)

## Metric Fixes (compared to v6.15.8-93-gd9420fe2ce8c)

## Test result summary
total: 328235, pass: 307085, fail: 6419, skip: 14731, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 138 passed, 1 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 27 passed, 7 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 24 passed, 1 failed
* s390: 22 total, 22 passed, 0 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 48 passed, 1 failed

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
* kselftest-mm
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
* kselftest-x86
* kunit
* kvm-unit-tests
* lava
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
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* modules
* perf
* rcutorture
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
