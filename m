Received: from mail-vk1-f178.google.com (mail-vk1-f178.google.com [209.85.221.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8302B812
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722015692; cv=none; b=TqCNk0VC6J/bmjgkB9qX5liE6qlQgPkDSRDB7AKypZlmBdfbxbNV2CAbCiR1zSalLP8vQO/N2XilVT3qDkoacR3NCwZwRBarGqtqiQWoVBr0Exw4Kn0NeLVZmbDDLa2PolPggxyo9dmAgbj78y1yFtpxV68qXH9KMC508veDSgg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722015692; c=relaxed/simple;
	bh=VOVTe8AbHTWQ9OIxXLbvHyvVlS+/yu3LH1L02ekm+vU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E4FMzQTK11KWTOk8rh+O07jBojMvrtdtAS/R2crOLBqFemzl1DCY0ezD570E34mwhB7NJunxa4qeGyNCpXuLdPEmpg7MtkY/fJfJTmARpkH9afz95qtQRDjmqVjRgqVqYoFxHGnJ0RLyJgg4JOja5Jj5UcK9TO4ZakfuK+EggQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uzI+ldSd; arc=none smtp.client-ip=209.85.221.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uzI+ldSd"
Received: by mail-vk1-f178.google.com with SMTP id 71dfb90a1353d-4ef2006dcdbso327350e0c.3
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 10:41:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722015689; x=1722620489; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NyV4Ranv8hjbex09xbs1+X1ftbwqkjv5OZ97MPZTSe8=;
        b=uzI+ldSdcDw6kHEJqn3FYmy23xqHAFM1BBCFRqQcI5jxFk9DaLGovS6/hv7ir4dzR6
         ZiLxk/6WJzI/zibL+Q8ITBWiAXiCe46WhLgOQW2SDXNviFdAbbzeCuPCI5DV3bDwUQFb
         auDHUn0h3obUuIACyP9G4R+xC7PTmeKQciLbehFS/N6g068huhjeg3ry9q3tJmbEgKvW
         lwqFM1TcOzNxcb17GK6jJ7kTPLLx3sRBG3toY7eT05imuN2A4euy4YEhkQ3atrXFOoD3
         2GmCKryyTRdjldAUk6/awNLlrQjmOCz4XVDyRzIO1g4i2xEIsP1NAuHLAor4z0o/dcBq
         beFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722015689; x=1722620489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NyV4Ranv8hjbex09xbs1+X1ftbwqkjv5OZ97MPZTSe8=;
        b=UOSDoyORXk5dMKUC5Iegww+RvN7etJYUyZUbfRBFUr+/HDZhyNa0plby0TmknWSTEG
         Z4jLYJrpcCfCXjVkhrWN6WH0gBuHZE5MlS4BWYKet+N111+csfiShW97EJCmrW+Oq9fe
         PTJD9Nwvpzdr25I0sKb+aN4vpNKj9sdqazZ7BDF6HdNxaK1kNDhV5MCr9LWr8YZ4rCib
         V0zBWLZIhxiv4hx/MKVvGLejG/3QrX5dWfKCB/uv85SEn/VXhlKsWV/VL01kHnzU8mEt
         5pSPTMfK3BQoBhPTgmSBsFKC7C59+9VRaH5OFHcPHaqmWfklaC3TKbTrm3BSSZlwZ8is
         3VFA==
X-Forwarded-Encrypted: i=1; AJvYcCUBfSlbrvwngLVA0Q0GYr/OZ9kGtPpVtfB+W794Bf5DonfDfQNY373IPOHH2I0xMzN137281zBBtSpsPrv0h8bzVrPVnS6IXg==
X-Gm-Message-State: AOJu0YzM0mPczs2qCBeP3vu+2JOVyahkWYTBCvm0jqk3kEJak2/kNKbI
	KxzCO56FwZgAM3g+QPB1r+aai9AA4eVm4keY+86DIOLneOD/j4WcGHqF9DqrDCxgyLM7CDJlo2+
	A0S6BAzU3Nz8u4LAjFzjFGJLMVBkAy6pNsN/+ag==
X-Google-Smtp-Source: AGHT+IEokeUJzGuoeN1XnSD/FY3MN6iOE9X1osOhH1tB1eHXiIhNcjJ4EsQVCYkzHJarrfr3qgb1AqKBU+goVcyYVFs=
X-Received: by 2002:a05:6122:4124:b0:4f2:ebd9:8e12 with SMTP id
 71dfb90a1353d-4f6e68e2368mr177253e0c.5.1722015689388; Fri, 26 Jul 2024
 10:41:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240725142728.905379352@linuxfoundation.org>
In-Reply-To: <20240725142728.905379352@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 26 Jul 2024 23:11:18 +0530
Message-ID: <CA+G9fYvsiw97j1nr1ckBtR28bWsbWLpHkCkw13U51nUemfMGkQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/16] 6.6.43-rc1 review
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

On Thu, 25 Jul 2024 at 20:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.43 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.43-rc1.gz
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
* kernel: 6.6.43-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: e83c1018357355c0547e7887022ef46510253e60
* git describe: v6.6.42-17-ge83c10183573
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.4=
2-17-ge83c10183573

## Test Regressions (compared to v6.6.41-130-gc74fd6c58fb1)

## Metric Regressions (compared to v6.6.41-130-gc74fd6c58fb1)

## Test Fixes (compared to v6.6.41-130-gc74fd6c58fb1)

## Metric Fixes (compared to v6.6.41-130-gc74fd6c58fb1)

## Test result summary
total: 208041, pass: 178672, fail: 4082, skip: 24852, xfail: 435

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 127 total, 127 passed, 0 failed
* arm64: 36 total, 36 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 17 total, 17 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 30 passed, 1 failed

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
* kselftest-watchdog
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
