Received: from mail-ua1-f45.google.com (mail-ua1-f45.google.com [209.85.222.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CD9E1DE2A4
	for <patches@lists.linux.dev>; Thu, 16 Jan 2025 10:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737024519; cv=none; b=b0y6HeEzovgMCz+XFP1ooI1SiprLsZUbE0mmMAE4R+x5Fqt6+B0G6YiHkJQz4oCMY6FPMS0FqwcCYsCfYX9YqzxNkPC9FqmhGN1FPoWdELWwZ7tTZApcQzHeyQoF0ND9PuzOZlXhaLQEhPIqKFMB0deVD5Uitxx8JhcZ9UmZ1hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737024519; c=relaxed/simple;
	bh=u9XFg39HPyG8rqv7eF8mTN149vcnkYLhk08IiOkjGkA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FYZXNfnXLAhxKSp1gYH4Fk3HKcrPh833qogcClWEXF8GbskpfE0WIm8Xdm0w8W+INLkYOj3SS3d3w1NDcbGyv6+jkG+IGBx4bBrkIC/dUt32FKiszd9CSGv8hoGOUMhFcs56KGxs6ZzXmbtJYGGWXq58qZrSQtMHgTTTMZLo59I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RYBKpKPb; arc=none smtp.client-ip=209.85.222.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RYBKpKPb"
Received: by mail-ua1-f45.google.com with SMTP id a1e0cc1a2514c-85c529e72bcso107062241.0
        for <patches@lists.linux.dev>; Thu, 16 Jan 2025 02:48:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1737024515; x=1737629315; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=LCT1zI4OT1vpFsYxXFe9LQUvS7Xlh9EgI5AipLw3miM=;
        b=RYBKpKPbPazOqr0rWDUdMfAEmC1oF0zQ0y7KWrkfzz4FDgNsN48+APQtpJU0r/H1yK
         eJefgFR3JdtcItFo1RSM4cgQ9jp5sk2pX172YYS2jC18HpGKBfVQHemVMUFwKw9KwQoc
         KOtH6q8E8onj39op5DVqplisgPoLYshugGJo/klvrEeLFXcf2BCAnuhBfOL8FwOMHXsf
         7l3+N5DdonAcjPasVOMNlrr/3lINsK2TtjP0TXNjydVUaDZVKPCKwI0m1hXFhOLjC3Nd
         AmwXAC5Wyn6n013jVZXBbcD5tIzCLwMVwkch99jgzcReFOM5ZSvMcN93EBH834l5dTlM
         vCUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1737024515; x=1737629315;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LCT1zI4OT1vpFsYxXFe9LQUvS7Xlh9EgI5AipLw3miM=;
        b=BjSBEb6zOGbNEuuE+X/UlEo8oeiA0dyEWpnhWBI/WVHPEdFKcUmKX4hSlcF/4pnXR4
         quHb21kvEH+UKX+a7W3UayKYDbSITOA6JEMLX8y/BqeFSRaeWGPbsIfNTDXOFYP81GpF
         dNtmZU+/Er1pcFML8B7HfbwdggNt3YPvSFk9wKNmXu1MQ/f5STeMvPI7JPE1AEGOq7nc
         cd97DBAQ9LNDWnIE1IDzjlWLDP9bj7F1hD2rg4UawBpvAnAD/HkVjW+QQ5VL5WNc7Mwk
         bf6r8JfyvN7TxvJwPz0DhKbBZMUxPgX7Vg1ZvQ19Ahbv/Gm0V+0rG5o2OI3KeKKxIE+H
         uj/w==
X-Forwarded-Encrypted: i=1; AJvYcCWIbvolnQcGPQLmpnSYULwe+z3PVqVrW9G2RW6tWwcnunafRZ8j9WbMi2k+aj5v08gsZRM9vLrL@lists.linux.dev
X-Gm-Message-State: AOJu0Yw5a9KxM9Qg1VfoBFCrL8/vgojal9OX+defVxemWj4Q1oLY/T8a
	5a0ZQNwj/+fiR32TJ0Xh9MlYDjsdVq+RIZ5tiq5wf8YyuyAl/j5oaAdPnmRZjm9AwvoR8iUjjZF
	tVWQANOReKd2HZofkqMP6XLIqfeeD1cycbYRMlw==
X-Gm-Gg: ASbGnctXj9tSHZJLT6k/pCVLTFc9KXp1VKNTBfqk6DXBLnajzD037YYtsgR2AnPv6WG
	H5SF9mZpBQVi4arS+zO5Ei98soovCfcDrc0H8ZHo=
X-Google-Smtp-Source: AGHT+IG8gYhAWxdgo4p4HzmjwQWQ94NvOR5d54MWDMQAfpeO9WURUE8UD95sTlO+C1IU9Qx2OQ0F4OEBu0Ka2fnenk8=
X-Received: by 2002:a05:6102:2b81:b0:4b2:48ef:3cf2 with SMTP id
 ada2fe7eead31-4b3d0fe7048mr29507046137.25.1737024515296; Thu, 16 Jan 2025
 02:48:35 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250115103547.522503305@linuxfoundation.org>
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 16 Jan 2025 16:18:24 +0530
X-Gm-Features: AbW1kvbHnl8KdKwXAVuaxCqnHkSKU6IB1QZRoqweOPf4JkpbzgeHXkmoeBTwW0M
Message-ID: <CA+G9fYs6cKNmVBqeo_weTAPmJmBH_A_ai1WYvLwtnXcf3TDoiA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/92] 6.1.125-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Kai-Heng Feng <kaihengf@nvidia.com>, Wayne Chang <waynec@nvidia.com>, 
	Arnd Bergmann <arnd@arndb.de>, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 15 Jan 2025 at 16:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.125 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Jan 2025 10:34:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.125-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

As other reported,
The arm axm55xx_defconfig and footbridge_defconfig build failed and
also arc, mips, parisc, Powerpc, s390 and sh builds failed with below
warnings / errors.

Error:
----
drivers/usb/core/port.c:417:21: error: no member named
'port_is_suspended' in 'struct usb_device'
  417 |         if (udev && !udev->port_is_suspended) {
      |                      ~~~~  ^
1 error generated.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Build regression:
gcc-compiler-drivers_usb_core_port_c-error-struct-usb_device-has-no-member-named-port_is_suspended

The bad commit points to,
  USB: core: Disable LPM only for non-suspended ports
   commit 59bfeaf5454b7e764288d84802577f4a99bf0819 upstream.

## Build
* kernel: 6.1.125-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: f121d22cf28ea1a09e9040843f57dd73dde42bc0
* git describe: v6.1.124-93-gf121d22cf28e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.124-93-gf121d22cf28e

## Test Regressions (compared to v6.1.123-82-g88f2306b7d74)
* arc, build
  - gcc-9-axs103_defconfig
  - gcc-9-vdk_hs38_smp_defconfig

* arm, build
  - clang-19-axm55xx_defconfig
  - clang-19-footbridge_defconfig
  - clang-nightly-axm55xx_defconfig
  - clang-nightly-footbridge_defconfig
  - gcc-13-axm55xx_defconfig
  - gcc-13-footbridge_defconfig
  - gcc-8-axm55xx_defconfig
  - gcc-8-footbridge_defconfig

* mips, build
  - gcc-12-ath79_defconfig
  - gcc-12-bcm47xx_defconfig
  - gcc-12-rt305x_defconfig
  - gcc-8-ath79_defconfig
  - gcc-8-bcm47xx_defconfig
  - gcc-8-rt305x_defconfig

* parisc, build
  - gcc-11-allmodconfig
  - gcc-11-allyesconfig
  - gcc-11-defconfig

* powerpc, build
  - clang-19-cell_defconfig
  - clang-19-ppc64e_defconfig
  - clang-nightly-cell_defconfig
  - clang-nightly-ppc64e_defconfig
  - gcc-13-cell_defconfig
  - gcc-13-ppc64e_defconfig
  - gcc-8-cell_defconfig
  - gcc-8-ppc64e_defconfig

* s390, build
  - clang-19-allmodconfig
  - clang-19-allyesconfig
  - gcc-13-allmodconfig
  - gcc-13-allyesconfig
  - gcc-8-allyesconfig

* sh, build
  - gcc-11-defconfig
  - gcc-11-shx3_defconfig
  - gcc-8-defconfig
  - gcc-8-shx3_defconfig


## Metric Regressions (compared to v6.1.123-82-g88f2306b7d74)

## Test Fixes (compared to v6.1.123-82-g88f2306b7d74)

## Metric Fixes (compared to v6.1.123-82-g88f2306b7d74)

## Test result summary
total: 82792, pass: 63395, fail: 4390, skip: 14641, xfail: 366

## Build Summary
* arc: 6 total, 3 passed, 3 failed
* arm: 139 total, 131 passed, 8 failed
* arm64: 46 total, 44 passed, 2 failed
* i386: 31 total, 27 passed, 4 failed
* mips: 30 total, 19 passed, 11 failed
* parisc: 5 total, 2 passed, 3 failed
* powerpc: 36 total, 25 passed, 11 failed
* riscv: 14 total, 13 passed, 1 failed
* s390: 18 total, 12 passed, 6 failed
* sh: 12 total, 6 passed, 6 failed
* sparc: 9 total, 8 passed, 1 failed
* x86_64: 38 total, 38 passed, 0 failed

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
* kselftest-x86
* kunit
* kvm-unit-tests
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
* ltp-filecaps
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
