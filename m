Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02116192469
	for <patches@lists.linux.dev>; Wed, 10 Jul 2024 15:40:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720626026; cv=none; b=d99CmpcvkZTpUXTfV1F5cryTz2Zdy9XF/lp2v5zeVGPl9oInP5t5JhWlx+oh8dWF/l7PzZ0ZObIhdcfq6tzCtYclZ0UW2AgsiPfA4HQ6ila+J4/+/o5daDnpvxP1tH3hW9cHtqpGCF4PZH/tyZq8rG7TN1qmj72yJKkn51Ycrns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720626026; c=relaxed/simple;
	bh=omsYmQS4hG6YsBHUkFIaSOzlEc+6+TrwpnKMHsG7kjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ed/YOUjV0uFLp7NY68AaDeeshX/NvEkKvHdBK5dOUTZbi2xr2oD9vfNWGZ8zQHsmeFq/N7b91NaRbgE6eILd7nDCsuB1mB9SBULJXYuj8PxWzniu3Yzy5/xXpRuqGWbYkwbEEMolDpyLYwTfkNi6D4FNcgLhBATikrjKMHMG+go=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uqHOyX67; arc=none smtp.client-ip=209.85.221.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uqHOyX67"
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-4f2f51eb86bso2409191e0c.3
        for <patches@lists.linux.dev>; Wed, 10 Jul 2024 08:40:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720626024; x=1721230824; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=h4D3P6HH5i1NmF0CLERJUVLqTlBKOZEShSy+djf8MuU=;
        b=uqHOyX67/vVbwAefd0w4G1Go1xgrbb6ighvcyiNMXH3fF57usGlgb03GVX+c+X060w
         xfdeMMlx2ntyWJO2XkIB7+mYFfV2xdAC8CWUJxYB2xKv9cTg9HYSbbwjZ869ycVsKmjs
         W7ezfBEgaRmZXpbP1tD5kykG60vxsI31U+wUrbCUMHmzuvkqhI3LZONdtRzBsza1J8X0
         2wWJdTa/y/CFxbrK2mWnohX6mgFfGpD/z/qxejJCCaak6VRKnr+0JjMYWyO//cRymSl3
         IHrSwgWIPv7vL2ZyH7Klg69GOM8V7SEDjFjUhM457ii4RtTAgwpFi7rA1KO1yAkUTQ+s
         SEBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720626024; x=1721230824;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=h4D3P6HH5i1NmF0CLERJUVLqTlBKOZEShSy+djf8MuU=;
        b=ESw8eD4drPXPvDFMn9rRTve5S1WajMsEVm07kO2MIr2gu0vAMFwjREeyWN+QTxaBpK
         Ajc1Rgrs6Xf10uEZt9G7vRDn/Na6q8692SrasLudBUZdWj7675XaVoyFZjkbo6Tk7Upf
         AcJPIBZn7o7TpF3NV6Xn/Yr1IzIqT3HHzVy9zaNUco1ZqK49MPfKgNRAccSRa1EKw25j
         mwv8sKD7d9BCNygt+2fpIYXfI3DBE/TUx5XlAoM0HDRVUEk0Kl/W2H0JUkisb520fzGN
         1acCFC90vBqAq89hR5eavaZHYNfwtb2psdTAO5QEY3uzIm2FLOLlTlSn4Q4ft+Ljb7mU
         9jxQ==
X-Forwarded-Encrypted: i=1; AJvYcCXI7I9HZTp3Aw0aGJ01Y2zrigdlJGsD9kYaS+3xy0F6JNpbBQuA1WAE5agm0e2XzG1OEz6nZspjlOPud0H6eBSHAiLf9CAQWw==
X-Gm-Message-State: AOJu0Yy1KSXVc/BtWv8//x5aTI0SHiqpvoPIRInQ1M56smmY0oa/83bK
	2cLRW1MPBRRhQBtvs5F4CR1BPyoUlqwx/8dt+nvY1V/qFGDcbOvHUlTaeeD4vJ5qolo//1yBMug
	pi5lg1kaAwDZ7nxvDkM0kNLHRckXvwkODI4cUcg==
X-Google-Smtp-Source: AGHT+IFcz+poOzmDVoRNcSrqYhk1+y+wQ2Oo1g150vyTo2Ei2HItWpnr+yvlW9NI0uR3LPGWCGrwTMDdo7z5n/JlGjA=
X-Received: by 2002:a05:6122:a03:b0:4ed:682:7496 with SMTP id
 71dfb90a1353d-4f33f31b0a0mr7123315e0c.12.1720626023634; Wed, 10 Jul 2024
 08:40:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240709110651.353707001@linuxfoundation.org>
In-Reply-To: <20240709110651.353707001@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 10 Jul 2024 21:10:11 +0530
Message-ID: <CA+G9fYtK_CCvQ01LdANMViMpAGfY-fyh7vFwiOq7XzQw889jHQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/102] 6.1.98-rc1 review
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

On Tue, 9 Jul 2024 at 16:59, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.98 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 11 Jul 2024 11:06:25 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.98-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
We have two major regressions.

1)
As I have reported on 6.9.9-rc1 same kernel BUG and panic noticed [1]
while running kunit tests on all test environments [1] seen on 6.1.98-rc1.

BUG: KASAN: null-ptr-deref in _raw_spin_lock_irq+0xb0/0x17c

 [1] https://lore.kernel.org/stable/CA+G9fYsqkB4=3DpVZyELyj3YqUc9jXFfgNULsP=
k9t8q-+P1w_G6A@mail.gmail.com/

2)
S390 build failed due to following build errors on 6.1 and 6.6.
Build error:
----
arch/s390/include/asm/processor.h:253:11: error: expected ';' at end
of declaration
  253 |         psw_t psw __uninitialized;
      |                  ^
      |                  ;
 [2] https://storage.tuxsuite.com/public/linaro/lkft/builds/2j0YAKrnHmvjt4f=
KPfYoEmSKWlG/

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.98-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: b10d15fc384867cd42b1e770181e6cfb116cb970
* git describe: v6.1.97-103-gb10d15fc3848
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.9=
7-103-gb10d15fc3848

## Test Regressions (compared to v6.1.96-129-g54f35067ea4e)

* qemu-arm64, boot
  - clang-nightly-defconfig-kunit
  - gcc-13-defconfig-kunit
  - gcc-13-lkftconfig-kunit
  - gcc-8-defconfig-kunit

* qemu-arm64, log-parser-test
  - check-kernel-kasan
  - check-kernel-kfence
  - check-kernel-oops
  - check-kernel-panic

* s390, build
  - clang-18-allnoconfig
  - clang-18-defconfig
  - clang-18-tinyconfig
  - clang-nightly-allnoconfig
  - clang-nightly-defconfig
  - clang-nightly-tinyconfig
  - gcc-13-allnoconfig
  - gcc-13-defconfig
  - gcc-13-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-defconfig-fe40093d
  - gcc-8-tinyconfig


## Metric Regressions (compared to v6.1.96-129-g54f35067ea4e)

## Test Fixes (compared to v6.1.96-129-g54f35067ea4e)

## Metric Fixes (compared to v6.1.96-129-g54f35067ea4e)

## Test result summary
total: 229438, pass: 197119, fail: 2855, skip: 29094, xfail: 370

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 36 total, 36 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 12 total, 0 passed, 12 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

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
