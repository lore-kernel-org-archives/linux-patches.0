Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 173E65DF18
	for <patches@lists.linux.dev>; Wed,  6 Mar 2024 09:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709717665; cv=none; b=C9xVmH1QI1CYiU2yXIjKR0irB9pcyhDW4fE+qb9OguHNjP4rjAmjIKvHGqyxhz7YcgzTEKFMTQvNP1PVkt+3pLcX+9fa2t1Hec75B5TE4MY5jo4tdJVvnZ9fifsAw4xi0zDhGXMLCPuSjN5oobZMaLsCObE5rF3tkVvDJ1uGTQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709717665; c=relaxed/simple;
	bh=eeZh91byZbYG0NLTOz3LS9US03+JS6hPT7Q+9TyertE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eEmN3THhcTScIqg8elGxz/dAee1NzE6wSCyTJJb2x+ku16pWBb21ukoEnAr5M840ixFn5SXtQqpiNTE/47BaGsIhM3QnxD8gYnvsXhdz87UjH78cyfNoJyTg8zgnawgiH5QDKj9CW+IsECQufiUcFePYvvroRTeesbamzGuRJNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Iiwv32An; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Iiwv32An"
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-7da6e0fc90eso319814241.1
        for <patches@lists.linux.dev>; Wed, 06 Mar 2024 01:34:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709717662; x=1710322462; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FAzCifh2gw9tE3jlAbWBQ3zu5cw+J57BEOmQzQr7QdA=;
        b=Iiwv32AnDmjasgGU6P5ywr9dEGte6fwgDNE2qfTpUx8o1iS+vaibmMOUexchqThCCb
         Fku8X/HkRIsgai5iJUXRMtyj55jJKdd702aBFkxPA4LovnPNUSf/vpdaMfMYIqEtqCei
         i6B9NpB7kDZXncrvUJefIhM7I6WgGb8gZ2WE1jLAUzduh34KnPar3c8gFEZxsxt45z4R
         R1jv4o87Ykr1JowGhItXQ/ZzDjbGG6sN8QhA4OxRydaA8zlDR1G+f6gLLETHZoi4oG9K
         7QmdWoGhJTsh+oMwGeCuZP4jPePAZvzyw6aPbossiYBtxpHxGCnbMNn9HFd0ZIu0qhMy
         eIyA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709717662; x=1710322462;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FAzCifh2gw9tE3jlAbWBQ3zu5cw+J57BEOmQzQr7QdA=;
        b=uJnaqTbljm7jL9w2gBKlUD7tMh8Grp96lNaUpIUZNZjIuxK76nEAHCsnixEL6gpnKO
         MPUzRJvCQw1Rc11gzThWmzs0gjamj8O5WdJR8/cY9W9CpQ/E9D8gAUaHkO43ATgJ8HbT
         SGA5oiTRMBRnWDHwrsdOX7oNL+yLHEsSIC5E3WsYtdAO6ghtyHy+ENodRYvm7qbjC6jA
         g7Sby7693EHMYW1/djFBw3D+Og34gAYQFQQMLw93xavD1s+dRPNpirB7LJEF8VW2Vjcv
         ov5UD4CZKOho5ByzRpCgIgxZVOgro56incnxiWLcsVmuftgZylaZWznLs/FTUu3crnHy
         VM9g==
X-Forwarded-Encrypted: i=1; AJvYcCUEmy7UCUdqNVdvFCkI25R1tf/+OJtn57BJD5mkL/XrTQ3PW46UWk4K92FgpjJ17qwR2l62yAEH0Uz4F30Q6ROuVpw3Jf3pqg==
X-Gm-Message-State: AOJu0YykZa4HqSNCa6uRl2dvFN7ztw/MzE96fR+a2VepWicd7MHOGOi9
	LayFgguRtIXNQWQ0b6SbTNHYpnGlfhdB+ZGk0phngn/LlS0XuWu128jPvtJWNt3gqqXOSUwFiT9
	aSe/onnVwzDEemFRV8FH21zmgzN+YmrSJXrs0Qg==
X-Google-Smtp-Source: AGHT+IGdxQJNIoJqcFDFmbxBEQ4KTrPI4D4F/IqEFApyymFB+SCBvBmFHnOTDPuYclpfSsDpuYsS3/2oaBZ4JS4mEuo=
X-Received: by 2002:a05:6122:4a8c:b0:4c7:7760:8f14 with SMTP id
 fa12-20020a0561224a8c00b004c777608f14mr3582005vkb.7.1709717662008; Wed, 06
 Mar 2024 01:34:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240305112824.448003471@linuxfoundation.org>
In-Reply-To: <20240305112824.448003471@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 6 Mar 2024 15:04:11 +0530
Message-ID: <CA+G9fYtw4VYLkJZA2EF_xxZ0x5tthrn8V1fP_+zVvMXq0xk3mg@mail.gmail.com>
Subject: Re: [PATCH 6.7 000/161] 6.7.9-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Mar 2024 at 16:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.7.9 release.
> There are 161 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Mar 2024 11:27:43 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.7.9-rc3.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.7.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
The arm64 device rk3399-rock-pi-4b kernel panics while running LTP syscalls
fdatasync03 test case.
However, I am trying to reproduce this crash. If successful I will
report back with
more findings.

* rk3399-rock-pi-4b, log-parser-test
  - check-kernel-oops

Links,
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.7.y/build/v6.=
7.6-498-gae550cce59f9/testrun/22969808/suite/log-parser-test/tests/

## Build
* kernel: 6.7.9-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.7.y
* git commit: ae550cce59f9da57770876a612e77f062d6b7ee0
* git describe: v6.7.6-498-gae550cce59f9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.7.y/build/v6.7.6=
-498-gae550cce59f9

## Test Regressions (compared to v6.7.6)

## Metric Regressions (compared to v6.7.6)

## Test Fixes (compared to v6.7.6)

## Metric Fixes (compared to v6.7.6)

## Test result summary
total: 239643, pass: 206259, fail: 3352, skip: 29782, xfail: 250

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 129 passed, 4 failed
* arm64: 41 total, 40 passed, 1 failed
* i386: 33 total, 28 passed, 5 failed
* mips: 26 total, 23 passed, 3 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 28 passed, 8 failed
* riscv: 18 total, 18 passed, 0 failed
* s390: 13 total, 13 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 37 total, 33 passed, 4 failed

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
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cv[
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
