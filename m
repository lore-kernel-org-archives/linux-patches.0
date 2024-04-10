Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16822158215
	for <patches@lists.linux.dev>; Wed, 10 Apr 2024 12:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712752730; cv=none; b=Z/9L80c5OuWAWJPst4PU6wxsxaaJoF/hwkBG+nMXMakSMlrhZny5zGX1E8l1lNK4UXXNRLryZfP+eW7NDSk9kp1XYaQ5Gnry/vcTLM5lxZqJQvSIpPAK5rhY1i484xNo75FD2RVWICD2TGsZUxEBqn3lARMRtp6fvMHi88sQY+E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712752730; c=relaxed/simple;
	bh=3yTKbpvVf/s+1knv6dgnitL9Vocg26mUcLvAPD0lXdE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GoqrTYxkS5P6sg2AfljMDhmbgfyz4RPZjvnvLde2c7HSLMcLspdFC/EYW0tTzTHD/MEiJeNIfFYleZAWlJWDwLTtNSOthdhnJbHT7j+BEGUYiElrcOEY3q587qCitrdtwJTWP7k04uSviK/krsFCs8VBBcay8bAjgs53Gq/+bnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=OnW84rQd; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OnW84rQd"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-4dac112e142so1700052e0c.1
        for <patches@lists.linux.dev>; Wed, 10 Apr 2024 05:38:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712752728; x=1713357528; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZVxcRT7Lzw30y45VsmtK4BzB9fldSLT/uaJK59u+T08=;
        b=OnW84rQdK7/VFCv5iR2jpU3XZ+WaATGSyPV3agswmuAisidLz+riLOEU1Vft91jra/
         O2i4J6kMYpVhYpeeCDJzhyHNxR0ho5AZMUKpOiidnMHe/oB5vJa5+F9GZjuPo8rmKu47
         9jIxPmu62SvISME9Dx4cVE6vFhql2B+taj6pChETjbv5GrL4CIWxZHt+gDLCMXx4Ei3j
         ZObQ8euuluZroDItefD98HGppbC7KA3KRxgsHa6O+As41G28wCuMsZ910HmGRknWIEAq
         lRmpS2K6B9OeVwIcnb56aerIT3mTmOcfaq+I4eJaaLnnxv0NPcxbI5KCjGpFUuYIkmBP
         MilQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712752728; x=1713357528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZVxcRT7Lzw30y45VsmtK4BzB9fldSLT/uaJK59u+T08=;
        b=s5soy39j/ZLHYt6dd7YCI7UQLnRv6siYjdCi+XBTjqjF+pmBiDBT9FYSRove8ekLiG
         X0MAjxh3qaVFH1Y14Ilatmd7fIUI38rbX8g74a87plJL6759gzlyKZbBuKJWklTQI+WO
         oQI3/3CDaA7X4lH2iYBQJpnuFaHIeqVUFRVHTCn+lgvjvdPLiGmZ/aZbAhiBqjOtSsGC
         RHKh5+ztxSXuHvnK3dnilHdnRePA5/MNjNKjmUY20AqtsMoeSfXancMyJKWTlaVWTWeD
         +VT4G4MrXJGZoT/dPkogcaCzWpqP5sVGMp+hzElibOJFyb1OXGrs95RgAMQH+zyZYo4O
         yqsA==
X-Forwarded-Encrypted: i=1; AJvYcCWZdA0rfzpe252vK/Oy4mbafkcBdBiXUU0vB2YxVDS85zoe7xYEEp9tp7OhMe9VjC2t1chfylAcLs7vUupnJoIubb2nXuSUCw==
X-Gm-Message-State: AOJu0Yzu2VIlqOdJ6uiQjb6sY8A98TxVLdk7Ku8l5Q01R9DKbMBRSGFK
	ohW8UQvb7RpEG1CqOEwuM0f9WA8c+gfQjNASZAlOyxvm7j8O52pMfIm0DoDrNECUezISWdMzPCj
	4RILMimlw/V5Q6AkBDepjEp1CWw/Tn9rc820ngg==
X-Google-Smtp-Source: AGHT+IH8Soae4l/U8nIkJuJIst/3/d3ollcdeT9RrOYIH29K741jYt5lXaX4gmeyiWJUUx9vFdiCPHAxmYu1GJTJFbU=
X-Received: by 2002:a05:6122:4584:b0:4da:9a90:a6f2 with SMTP id
 de4-20020a056122458400b004da9a90a6f2mr3185975vkb.10.1712752727993; Wed, 10
 Apr 2024 05:38:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240409173543.596615037@linuxfoundation.org>
In-Reply-To: <20240409173543.596615037@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 10 Apr 2024 18:08:36 +0530
Message-ID: <CA+G9fYtq2yX0JeP+JKE0+UJNG2=2bYSvAOF4EqjyOFaFk=MaOg@mail.gmail.com>
Subject: Re: [PATCH 6.8 000/280] 6.8.5-rc3 review
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

On Tue, 9 Apr 2024 at 23:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.8.5 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Apr 2024 17:35:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.8.5-rc3.gz
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
* kernel: 6.8.5-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.8.y
* git commit: 6d08df6c401e210cdf4959cc3249188ac6083489
* git describe: v6.8.4-281-g6d08df6c401e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.8.y/build/v6.8.4=
-281-g6d08df6c401e

## Test Regressions (compared to v6.8.4)

## Metric Regressions (compared to v6.8.4)

## Test Fixes (compared to v6.8.4)

## Metric Fixes (compared to v6.8.4)

## Test result summary
total: 292298, pass: 253708, fail: 3764, skip: 34460, xfail: 366

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 16 total, 16 passed, 0 failed
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
* libgpiod
* libhugetlbfs
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
* ltp-sy[
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
