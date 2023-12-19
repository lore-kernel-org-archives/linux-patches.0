Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAF02847E
	for <patches@lists.linux.dev>; Tue, 19 Dec 2023 06:38:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gbJ7H0VI"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3b9e6262fccso2943508b6e.3
        for <patches@lists.linux.dev>; Mon, 18 Dec 2023 22:38:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702967938; x=1703572738; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5GFqnfofMqxUzHZeJ+pdvAkPqe+C77/YREn/y9UKg0M=;
        b=gbJ7H0VI8eLPrBLqSoV7/ORfHbACxbiQ+NqMIpp1mtR5g3gG3fC09hbus3+dZavVg5
         TuGJs/XdQU9pTg3WdekOmwYmmfy/3pTP6EgKAKJk1qXEhRQLC7xGl0qJA0qVtU0/vrXe
         UepNBIaiEIgaN+kHQiUNOmaRSiBTtvNbsQlEthN3HmjSTeRJpjL5BUP4xVjeK8PsKS64
         jZ1wMSVt/1lhJHFt/CpMFBfZWmUvDziAilTZVFaZ8AeUHYpMAWYqI+FCrS5bWh65heCj
         8eJRI57x8EwIFmPdu0GldcaT6uG92fVRn7UjTmxYjxOSMheY1oPpUszIkB+GVlINRuaR
         RjoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702967938; x=1703572738;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5GFqnfofMqxUzHZeJ+pdvAkPqe+C77/YREn/y9UKg0M=;
        b=IS0uSiqnGtPT18z+qCaVcCUYYVVkCnMnrJiHgmFLCHlx0DZG1RAP/7BLlRiLBpp2d8
         zdNWayej6hgWom5UaGgqdiVKdj0UAKdN++dbFwKgpbn0S7+QsA2pcJh3FNMvYdemF480
         5QH/igvU/c+w55oLNJOknU2I4Ak2/lj6SZJUclW3ycCgOJQRWJo4WAG6vjXyX5deliv0
         ++3+JOp3MegqIO7bOdRJX6Q29TXedI68iCfpJ3ojQYdl2v3xL4lSzf5JLdicniOWrWok
         oufVTE5yCYAjKoqUhVf+I/41KBmYWh6T/nthd7C2jCPssivQ0j+LC6e0+z3q8jyaC6Cl
         2Xig==
X-Gm-Message-State: AOJu0YzKaA2XiuESnK12ndPT2A7a7jI83W42feSlpNei3PMUL6nVmg25
	Ilz2g6m7B6KOzGsu3A6DR9QMpEfj8INd/m93aeuqPw==
X-Google-Smtp-Source: AGHT+IGq1UxOojvImxHns4aOiFYkbL1QZnk6+r52TQDjKdgbtWQcbSVJE7UyxDOo/83zPKJzsDjGtHh+8uuuIP/ePOM=
X-Received: by 2002:a05:6808:170b:b0:3b9:e21d:c6a1 with SMTP id
 bc11-20020a056808170b00b003b9e21dc6a1mr21264963oib.86.1702967937702; Mon, 18
 Dec 2023 22:38:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231218135040.665690087@linuxfoundation.org>
In-Reply-To: <20231218135040.665690087@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 19 Dec 2023 12:08:46 +0530
Message-ID: <CA+G9fYv9bTstRC944xodispw6dV7cjezAh9J_-XpQ=nVZUYgQQ@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/26] 4.14.334-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Dec 2023 at 19:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.334 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Dec 2023 13:50:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.334-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.334-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 2461d9a65af242d126575115a4f8fd0d26e737c6
* git describe: v4.14.333-27-g2461d9a65af2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.333-27-g2461d9a65af2

## Test Regressions (compared to v4.14.333)

## Metric Regressions (compared to v4.14.333)

## Test Fixes (compared to v4.14.333)

## Metric Fixes (compared to v4.14.333)

## Test result summary
total: 54491, pass: 45633, fail: 1624, skip: 7190, xfail: 44

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 108 total, 103 passed, 5 failed
* arm64: 35 total, 31 passed, 4 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 19 total, 19 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 8 total, 7 passed, 1 failed
* s390: 6 total, 5 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 27 total, 23 passed, 4 failed

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
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
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
* kselftest-user
* kselftest-vm
* kselftest-zram
* kunit
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-fsx
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
* ltp-syscalls
* ltp-tracing
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
