Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB52D1B47C1
	for <patches@lists.linux.dev>; Thu, 20 Jun 2024 16:23:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718900636; cv=none; b=dJc7hi/hG83kOC63HkKz03SHMGLFxaWYDQHNJciQqoBplfNDUjCRq98ttol/RXxJiRSf9FrzHa6U9OzJJRIpkwKXQbtMXJnCztSV1NuVG1qCvpyt2+EaJMaDN7vHbdj1na1ZEvtEbhP1mrAbKfI0fV1io9RqhB3DZbD8Yw9K6No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718900636; c=relaxed/simple;
	bh=Fx1smBOU7+g5gN1krwDVwIdwdPcrGDOEe1sKrAvkiEY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tgIwZni/vLG4k4z9pzd7gk8wg37D73I1X8E1qo9hOy0Owb6e8VFslrFR7A3MqufxwsiWAfiO4RgO3fY2UVMEzWS8I+Jo4L/eQszKh1w5il9f3AY7i0DxgJ2hlSP4moz/jfDGvxwjZGfnMvkAqREjOwa4d6cDVOPCyH3+FM9S7fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=s/E7T0mv; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="s/E7T0mv"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-57d15b85a34so1289500a12.3
        for <patches@lists.linux.dev>; Thu, 20 Jun 2024 09:23:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1718900632; x=1719505432; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LlwMIJz/BLrmB2WpkXjrpRTAkcL0lyiD4VvvoeLE5V4=;
        b=s/E7T0mvNoTFUsTHUQiQ/RHrEVvXVnLwYZRU8e08e7fC864hpizNUxG9MhB7MxPee+
         Ryj/fEcfCQol3/l4qVioNo6mVIxt4TFrcail0bw+2CI7b4eLxZVIwGRjRATGaeWtUiYO
         JkcY6ytZF2u8QmFkH8v2+SemTVPXqSKYh+C7nHdDXBsi+/y53zocOJ1LiwxIld5hGXB/
         fNq4sfTeVqu2QcGDI4hPH8mSexNDtbne5D+9VR3lg6vfPrsdNlpB4ulHCIX+8IsZ9Vaz
         YN/DfC92noj/+B5U8qzTyo4yjbVLvY/4UyuBh7bxrr+KvQTabtcCObgssEP+jj+gMtgP
         dCNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1718900632; x=1719505432;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LlwMIJz/BLrmB2WpkXjrpRTAkcL0lyiD4VvvoeLE5V4=;
        b=N/n5xWF2VwGkcwPompPP0FzG+P5sWHFGVFweDMqGYLkwNUaqEBjsGRA/7H3vsNrw+H
         +SiFcFfKLmiN3JBpvRveXuVS5ECtAGUAuuA9YCNtFWq+Wiay/TWWTBBV+889DWqw+v2E
         SBFWjlrCcDsELnNE/1hQl9z4LJAWViWZo6Fu7dRlH8lt41GcRcnR4ILQHk1UIfE3msbg
         wpjnTU6XnvgHlUxK8VD9gHCgM7C3tk54uF265caulf/BeItllEfIU5TGREMPqmn6T3uJ
         ejIavnFzdFu1t4cgHoFqjn+UwEv+VGcxyXLiXYcVv8y/z0o3SJA923hGdr/vRoB60U77
         cSiQ==
X-Forwarded-Encrypted: i=1; AJvYcCULAoaXss+iRc1wS6ITZIUoTdRSxnT611Z/NeVzNaiaj5Tjxfxp1OA4FuQghMqE5iKpVSBOLcfjf5JCTUPr3RfS5d3sgqWLpQ==
X-Gm-Message-State: AOJu0Yy7Fvsv6hNGfndzT370Sn6mUyTowIIw0diIYmfBQDVpitjPtHM6
	TQyRKpwhPbAGYGfP6VqYbhQC3pjbFM3p9LMX2UnonM6dAW9a17l7Cneho1sCyY3xMmlfCvSxgV4
	lpMirMdkGdHZK6q2uzztp/4Wyo/6eLGrHqCcctg==
X-Google-Smtp-Source: AGHT+IEiUurqA8/vupAfbQYgfZXpGG83X+0xfR1yK7bM0GHwHo0LQaZYIH41GdenK+O+unfb1dHXnKUo8wy8Glq5Rs0=
X-Received: by 2002:a50:99c2:0:b0:57c:ff94:c817 with SMTP id
 4fb4d7f45d1cf-57d07e7b28bmr4498282a12.16.1718900631856; Thu, 20 Jun 2024
 09:23:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240619125556.491243678@linuxfoundation.org>
In-Reply-To: <20240619125556.491243678@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 20 Jun 2024 21:53:39 +0530
Message-ID: <CA+G9fYsnxHwaPb2YvcLJXrgPRkqJbm7w=cF6b-Ap1mQ7jHHMsA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/217] 6.1.95-rc1 review
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

On Wed, 19 Jun 2024 at 18:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.95 release.
> There are 217 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 21 Jun 2024 12:55:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.95-rc1.gz
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
* kernel: 6.1.95-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 0891d95b9db39ae51c0edef73f56d41521be9fbd
* git describe: v6.1.94-218-g0891d95b9db3
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.9=
4-218-g0891d95b9db3

## Test Regressions (compared to v6.1.94)

## Metric Regressions (compared to v6.1.94)

## Test Fixes (compared to v6.1.94)

## Metric Fixes (compared to v6.1.94)

## Test result summary
total: 171975, pass: 145682, fail: 3002, skip: 23038, xfail: 253

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 135 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 33 total, 33 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
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
