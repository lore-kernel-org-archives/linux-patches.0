Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB0C200CD
	for <patches@lists.linux.dev>; Fri, 17 May 2024 09:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715937814; cv=none; b=o3R9w+K9XMop/suaqdrPH/7rKjvRLQR21bA/DmjBofCPGIcqT/IDB5jhRUmLOGXBQpFH2L5Cw2qYL0hM0zZ6c/9NS4VZXRBqsJvVrC2vkBmLtVDHs8NI6SnZd3qgzzryuF/9IAhqqqO+jFQnSOcM6np8j59b/Ox2fx7JZGvVphI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715937814; c=relaxed/simple;
	bh=6D0PgZh5ELvFXyTcgoFpJhETrNgNZpsVvz9yn6U8duQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KuXDGy/3hy5HIw4AFFgpI6AHoFNtndMK2s3+lum8+Rf6R335oibC0N+OEyTVDgMaJhwkYzCPFylzleavV8Vvd4fPvoqB7nZlXSkZha+dTl8cYr1v6sMLXX/4BM5SZ1+KK1wDKOtxRZZr3JwmyubzWuWayXI5GeHYcmJcD25H3Nc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OGYnY3Ah; arc=none smtp.client-ip=209.85.217.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OGYnY3Ah"
Received: by mail-vs1-f53.google.com with SMTP id ada2fe7eead31-47efd204baeso2826177137.3
        for <patches@lists.linux.dev>; Fri, 17 May 2024 02:23:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1715937812; x=1716542612; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hD99hLiHSRuQQi8zXewF0a0qLZ2u/ioCBSgtrDDxDYA=;
        b=OGYnY3AhVyTXCGHD/SXQV0ukPvlwZC7wi1+XpZuI231s5xzq8FXHPVVtlEcgpA5y39
         wWoHa/K4z5l3SOG8KkF+73h4z6U4N5i7JCjoD4poj0pat8tk6SUjHqgkGCZrDCGrtu9l
         0YsID9auSquNGUIu9XGimYlOsRvBGPW6n2I8VG87kvIqj5X8qOWvnoWNczfTgbZwnyZv
         utR0wpNbTDtga3xSq+bw6DeYrrmViqAJyEUqAsZqVG4PtuzWPCwhm6SWnUROS/K5LZGH
         yicskUa3EFlsH0jKfcNPaYxY06zRQWeOPRzyUPS/uDjjKFMg5skcD7cRBudr9CTmOGna
         /N5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1715937812; x=1716542612;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hD99hLiHSRuQQi8zXewF0a0qLZ2u/ioCBSgtrDDxDYA=;
        b=NZu7EoQqSE0haTDg6p/CsNTnxDLa5pUUn4Afew8FIEewe72Ps+2Adxtw71ZUaXLtgp
         vjOkjzwH2OLSA6Au8BrQ9rWihGT3SsXzYRmXMDTPXX3hXDgsNh0P+vdgFtetT2aILMUI
         0e4hTPawGbnBR+Ix7/FwUutrLS0mHejRy8j6V4G5IWA1sLawe/eeU1PBDyxB1muOKtfQ
         5U74W1SLR0VManiCquLiPZk2GanOZ0AhHxelpeSv8qZg0jLUvls9D/SBIxLtZfM5L1b5
         Lr5lBSd82uVapo+Nhji++kYrtzqu/VbhMQI2LWE36zQkyyGKybJBz54FKaLncMUYNNcU
         1w3Q==
X-Forwarded-Encrypted: i=1; AJvYcCWmbYoQjVVXKjLDMbCy80w0/Pk5JPwx+nyLhwPjhDUJT0QUXVgqVdfIw12gESfiCy9BBRs+DLeIGYVOdCtVlKD2vlbhWnvWWQ==
X-Gm-Message-State: AOJu0YwcVIx6urC+LXHGSW6JfA+OaTu2GixrVB3fNomRLQwS8MT4oIar
	29zwJAWbOaQKkks4WPBAKgZDTgrKvcx7/jerRsloGXfCb4OBPhWj6MBMt0wUD3vhbDzSLja0lGW
	TmNyyeQfhQzhEq+BMPwFWc/v25axPKugFxschxg==
X-Google-Smtp-Source: AGHT+IHogXrZoqTS2h6fvQL9v4LVR6R+zCafq8r2UzEzxLhWlgbkc/Apn+0itECTQLPPVMur+cw6UpIapevQX/6Drj8=
X-Received: by 2002:a05:6102:390c:b0:47b:d6dc:af06 with SMTP id
 ada2fe7eead31-48077e5cb20mr20977968137.26.1715937811935; Fri, 17 May 2024
 02:23:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240516121349.430565475@linuxfoundation.org>
In-Reply-To: <20240516121349.430565475@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 17 May 2024 11:23:19 +0200
Message-ID: <CA+G9fYtzqnwm1GLeiLeRx4ozMc6AGjOLKYuXnjJEQHJFtDEC4A@mail.gmail.com>
Subject: Re: [PATCH 6.8 000/339] 6.8.10-rc3 review
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

On Thu, 16 May 2024 at 14:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.8.10 release.
> There are 339 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 May 2024 12:12:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.8.10-rc3.gz
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
* kernel: 6.8.10-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.8.y
* git commit: cb6ab33e1bb7469fd441b6a9c50c92190913ceb3
* git describe: v6.8.9-340-gcb6ab33e1bb7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.8.y/build/v6.8.9=
-340-gcb6ab33e1bb7

## Test Regressions (compared to v6.8.9)

## Metric Regressions (compared to v6.8.9)

## Test Fixes (compared to v6.8.9)

## Metric Fixes (compared to v6.8.9)

## Test result summary
total: 254634, pass: 220877, fail: 3274, skip: 30101, xfail: 382

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

## Test suites summary
* boot
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
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
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mm
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
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
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
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
