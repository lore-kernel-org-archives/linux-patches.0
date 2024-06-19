Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFC075817
	for <patches@lists.linux.dev>; Wed, 19 Jun 2024 11:10:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718795451; cv=none; b=tFzFVthCDsX7k1kwrr7HGCSsacC0p6ae0lkFFlz25TPChM6UY3zAIPfDv9NMi9gttQLmpiC9VrFvBgAp3gGxOBHq7Y0oE5n7Klvib2mtnZKKUP87Lsz/k4M2ZsqID5Dxm8c6S/JE+w9uUPbUJje+jWITV9GIptJFSyCr/Xjjh8I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718795451; c=relaxed/simple;
	bh=HHv4mKktzf9+XNRopNBA4+5IjO1uSYcu3PMupO19558=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EHwM0nevwEzSypvQZngVHN2/s+glGuD9M4jDrzflanbCWCMcjEt5I3c6QvKTLWibbA0CqnJM6R8scuR8BhSFMlmsy7kXZ3+shs9anZ1C8wg6L0d5E48F+W15aMzKt63bxLDFeg6FhhqR08Hy6ou0y8PrCK27aNGvAIT8BbYEIBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=dcP5qD00; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dcP5qD00"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-80f4ff2d06fso316478241.2
        for <patches@lists.linux.dev>; Wed, 19 Jun 2024 04:10:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718795447; x=1719400247; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fQvMGJZrhyrI19KD2mJN9dgC/lGVs+C5Y3KiDHg0cy8=;
        b=dcP5qD00YQjk4MrbdVj7zCHSNmR1OMJhgYuWVvtmtjFsIGmmhmI65p1M2kiACPajYy
         IcHmXL/vqXNymOxO0wywc25XEssTnm5yfWuhWBj01iauX875M3sG5lWYIQLL82ZFP6xe
         mdt19KGPqj8H3MlnOcqbMGbany7hdU5Vt3OFVhn3lN73lnoFvQ5MzwgMlEjjGQtt1ec/
         VAO7VJy8y+z7x4CMaMtScOyAHkNXA+DtiRl5TLovv4vQtknIWzRjVJ2+dij+VeCfI6lF
         FNBFVDgSsSBYtK0REppohr+Z1YdLA8TFWDigs+miraq9nceRBm6mV4QgRl2efRNuAJva
         Ft7A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718795447; x=1719400247;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fQvMGJZrhyrI19KD2mJN9dgC/lGVs+C5Y3KiDHg0cy8=;
        b=OnSUdCyWmqG0zOYNTVediXYyUqk+532lLbAobRZGQlZp8OHpv/fP/9apyiLwE+0y5c
         eS9435BiuYtoXYrgipYDU9MHhFPMIV8LUzUiJ8MEgqFxsdtmaAatF9lerdmdHuLlB5Ji
         JnrxOuU5bEZ1t/Cn6ZyRIEhSjSNKpAvtBdUpcI7EfKSfBPrSB6BVDrNc7m1GfJNutXlh
         3emkr2qu5Q2rdqa1CkzshsjSywcPtDBoupzFxrd46lHFV0Q7EqY5vu0rymx6cegANU6k
         3X1S/F57g+7Neukyf9XqYA3JYmuWKFVXzNgBrmXVe2ajlteus9oGHI8gPrPl0NtXmOWi
         OXCA==
X-Forwarded-Encrypted: i=1; AJvYcCXvHURroBjKHLIbWC7L8cgy1XA8+AQVWYUrfiNj5MBvYVKYwa9P8wRG9mRdURHpKddAa2/qjug+FfXLo5OuLrwyNBEyH6xn8w==
X-Gm-Message-State: AOJu0Yx7YHO5Z9v+WlUq0j7ABD4ubCt8wb2QeYmHuw3uD5K/J24c5r/K
	DRdNzFnyrqagsmNZvDu2dW0vptqvGnDgZBasWGAa0SqhfTHO4wDYMMQQMY1ozK31GkSEbwa5SDe
	HZvQYO29ewpCVnw8ydnkBHKELtanoj7Cgs5EYwQ==
X-Google-Smtp-Source: AGHT+IEo3vf1oUGzG99mjqU8s1NDWqJZQSEdCX4+1c22HnC5JtjpGdMsT6RsBslaHgQIWWx6rf3M4XHyXsm989HKaF4=
X-Received: by 2002:a05:6122:3c46:b0:4ed:6eb:567e with SMTP id
 71dfb90a1353d-4ef277b5a89mr2576452e0c.13.1718795447207; Wed, 19 Jun 2024
 04:10:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240618123407.280171066@linuxfoundation.org>
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 19 Jun 2024 16:40:35 +0530
Message-ID: <CA+G9fYtLXLAnEemRSk5dLXbuju--ga++Jt9wF0=FHSPZ7fEhWQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/770] 5.10.220-rc1 review
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

On Tue, 18 Jun 2024 at 18:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.220 release.
> There are 770 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 20 Jun 2024 12:32:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.220-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.220-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 7927147b02fc59fa7d326be121ef2a599edda19d
* git describe: v5.10.219-771-g7927147b02fc
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.219-771-g7927147b02fc

## Test Regressions (compared to v5.10.219)

## Metric Regressions (compared to v5.10.219)

## Test Fixes (compared to v5.10.219)

## Metric Fixes (compared to v5.10.219)

## Test result summary
total: 128385, pass: 101019, fail: 5547, skip: 21723, xfail: 96

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 104 total, 104 passed, 0 failed
* arm64: 31 total, 31 passed, 0 failed
* i386: 25 total, 25 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 23 total, 23 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

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
* kselftest-memfd
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
