Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29B7E186293
	for <patches@lists.linux.dev>; Fri,  7 Jun 2024 10:52:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717757546; cv=none; b=fc32yswbkm7y9O/y5uYkky8yGGN4uJX6tyre9OvVYCSUpHTLYO73LTwt7Dj6EM63kuyagOAEaqUFad1RFDjItM5CvLy/Pfhkdb1K2ksyA/vmf8ARjuIsiz5lYPUWIEimj8+ixCNtTG8tZyUeq18J6iHQ3Ay9tvea/ZA/PJRaDy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717757546; c=relaxed/simple;
	bh=gSWSP+7C8UOKUu7+vq+El/x9kf+z97qTlQ+ZsMnmONo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SIEAbSsEF6RWLnFO2vXgonnsCUzMSXzz063xuXYaVUhoIAF6wed9L51UMvj2aeMP8QKBVRiQCxeN3yOCgd/oCLzlc+SMpWz5YojrVcDFL4VgGXIrXeAR8DLREtVR3fJOqbTSA2Xf84zhvR2p3e+Ucevw4paJcme2i9DsNbxDJTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=VVqjWj7v; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="VVqjWj7v"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-4eb5eabea6bso73671e0c.1
        for <patches@lists.linux.dev>; Fri, 07 Jun 2024 03:52:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1717757543; x=1718362343; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mPbSPneHT7Jvjy5REyHR38Uuhd6bNow/3VWxu5TPx5Y=;
        b=VVqjWj7vm2KyGWTBpGnmgwVP4w7Cl/06QK+eExGbip0lIOvyZ70cOze3iyAmwXAgCM
         SPTe+JOD3ryXL/mqURHxWXMnjrc5+Uy1EQPaUJt2jUs3FonTCaehYcEOR7iLfav4Q/4e
         fXoPajDdk6jb5r0lcgnl9SkI+Ebn8cZsOrkPjwcZEF9Tihqdu605bvTr7V9S49MOBvEh
         Gb0ZFhu+uRPi1hwRTN4j1JaqbnJ+Ivnsdcym6qVlt1Fp0BJtu0AsWbNlvfSN0JvkjQql
         DMNvEGQbGspVWKYaEJrMcs4DisxGm9jkL8JguPiQueVHtJrnMUxi6WPgedJHi7SSBY45
         A3Zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1717757543; x=1718362343;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mPbSPneHT7Jvjy5REyHR38Uuhd6bNow/3VWxu5TPx5Y=;
        b=gDv8xkhktayNz823O+8ZYEbgj6NfaNUOxsDGHSuWYzVb/tLVwkxyJrSQZlCh6eaw6t
         d7uPfDnXSUf66pJqRqX76+gpH5jTxuNtMPmyRwLmW+Zt9jSOGhuVEr8BTEyOAumqeUN5
         QXsQ6s7tcQK310KewFhCkWK7nEXGcV66r+uko6l4Vqp8EfJnokbAPmXaSVa9sQc2yHh/
         96XNCUHvyyZl3vM9eeNltrD+DeH7eg6j8IFrw9xlWZyDfVC5067PxVRUYjHMPVFZ4NTZ
         +7bNx7KYrkdutJVLLL79NL5UAMTh19oW3n1oL4fKusvlrCTMTqErygV1+T/MTbp/5EL8
         h6UQ==
X-Forwarded-Encrypted: i=1; AJvYcCV+VKdHPSo183JtiHU3VrvtBEAvxXWzptrEnx0e7N1ChZqFCb0kXpY7ab59HhGtE5ttX38076Qoaub49sfqH7jDDrv32srz1g==
X-Gm-Message-State: AOJu0Ywr48gukpbWPMPp0PSa/2zFcNBXJr8diH/QmSQ1gXL2sstSAfuu
	9M/lTLjzHnvBgGfYxx8UsfrzZLwR81bUw76gFrCUSlMtmSDcHbrUkN936l396Kkl1tpU6pFIzRH
	Sma6YlvaKRFTJGLIlHDlMm1a18SA38KR80jmJ1Q==
X-Google-Smtp-Source: AGHT+IGZgoJBNxvF0IqzZ76RjN/3DL1M26P/4+jxT3RGwhtV8AOnkj8ddXuo2lmlwYIZDVnndDCRiLv2h7nduOcdfRM=
X-Received: by 2002:a1f:7c05:0:b0:4e4:ec86:4240 with SMTP id
 71dfb90a1353d-4eb562a4b69mr2327968e0c.12.1717757542953; Fri, 07 Jun 2024
 03:52:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240606131732.440653204@linuxfoundation.org>
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 7 Jun 2024 16:22:11 +0530
Message-ID: <CA+G9fYsnQh6ydxf3asaEvoOE8a1oabcoUp91m3MJRyR6caKJ0A@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/744] 6.6.33-rc1 review
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

On Thu, 6 Jun 2024 at 19:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.33 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Jun 2024 13:15:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.33-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
Build regressions on Powerpc.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.33-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: 39dd7d80cd65769389563028553e9ec89a8f88d1
* git describe: v6.6.32-745-g39dd7d80cd65
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.3=
2-745-g39dd7d80cd65

## Test Regressions (compared to v6.6.32)

* powerpc, build
  - clang-18-cell_defconfig
  - clang-18-defconfig
  - clang-18-maple_defconfig
  - clang-18-ppc64e_defconfig
  - clang-nightly-cell_defconfig
  - clang-nightly-defconfig
  - clang-nightly-maple_defconfig
  - gcc-13-cell_defconfig
  - gcc-13-defconfig
  - gcc-13-maple_defconfig
  - gcc-13-ppc64e_defconfig

## Metric Regressions (compared to v6.6.32)

## Test Fixes (compared to v6.6.32)

## Metric Fixes (compared to v6.6.32)

## Test result summary
total: 193993, pass: 148173, fail: 25962, skip: 18882, xfail: 976

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 38 total, 38 passed, 0 failed
* i386: 29 total, 29 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 33 total, 22 passed, 11 failed
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
