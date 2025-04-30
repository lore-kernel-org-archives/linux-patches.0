Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C7727A473
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 18:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746036013; cv=none; b=H/XQIhzF7yRppiQfOSHz0mALon3IEXsgMkCVcg3N/K02d8Q684Tl05aw2NP4PqTCIrDYGiX22xAwd/rBZtYmkDL++Ab6Y+VuwUuWl1bH3Ju+yXxyHTXeIv6qQDAD4rAhwpNIBp0cBiN2Kssi/vsj1ztmHdnt0m4mHWxYE/d0ZD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746036013; c=relaxed/simple;
	bh=10pmLhKzUmr3h7vg9qIfs6b/59122c370o19zaJP0hs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=by1WQfGSGoWU0+3Bk26gVEVI60Yd5r3jn2ac4BSlaUFlpSn+OrT1SkC7wQ003MvEOvmSGVd03EJnb0BJC1I8aqhc1mGaVkpt2CXWk+kx5eiK3pB92o2A/rMabEiP4iXogJTW2MnpJff90CBEA3Iq/1ioJphNwryKCDaW+KXODpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=X82atgly; arc=none smtp.client-ip=209.85.217.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X82atgly"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-4c6cf5e4cd5so67620137.2
        for <patches@lists.linux.dev>; Wed, 30 Apr 2025 11:00:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746036010; x=1746640810; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MCof9VBkXgR10L5RBwKjY3VTomGE1kUW0h6R7CFwK7o=;
        b=X82atglygMKh6KcgtrA3FhHrqMC7DtnnuQqgrou4WwKBBJ/PW+ySNYqauOMk4ZDSll
         b8GVcxfB9i2Z4krVDw+/vrBhKqAitMOLVnZsuo0kYOMcVcqHMf9YDKH0z3X9pBAJzyhW
         p/JAMxDms79R9RrOM7j3KEHbZQanUZR713CjniI7KUMAiT63OFVRm9TWNcyW3+Nnb2i3
         Kd+dgMnxou/H3EpUWy6vrIveZotaDX/bkyG1Oza9yefBjnRceE6P0v5DOXRCkNziByw4
         ls1VLerpQfsOQjxg6p3BpyeEOY8/OeAANNPkaOLoZyE0mYqw94xdJl+iTicIa0+3UG9L
         JKqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746036010; x=1746640810;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MCof9VBkXgR10L5RBwKjY3VTomGE1kUW0h6R7CFwK7o=;
        b=I6sbQq+VBHARKnQMYtLY7G8jnh7EUFxAWpbgSwqwXqMQhWPy3HHQLSbPzBG4o1KcUs
         ARCaeRxSX1DagEexoJXnsdKga7AGy78s6HK67uDCBfzeAtMD91T6hD4H8B7Bgx1M+msN
         JlzqdIttxRu9cwvuaPSPrW1DgNUaMTaft+wLY3avDwflQe7dXbyVV5a0wGnqO1sUaegE
         AOKmcr6Hc+FPZkw5oghsfEhLyeR2QvjaHcngj0a/uPTtpU+3wxNc6fKjL/BpgmwBS5Ha
         gsneleE0ijez81Sv1sT1boeXHsRWRlR1KlXH0J5/EhXZBBhUOvgQAb27mvTMXHj8b9T7
         OmJg==
X-Forwarded-Encrypted: i=1; AJvYcCUSOz7sVmcCjbZ81bpzOiPoOdjbpncMRscblIOKh6ELiRm+2vWjxGK2tTNyqFbnWjc2iiPTIl2m@lists.linux.dev
X-Gm-Message-State: AOJu0YwEfszL/zqcU9i7h9QNcxhN9kLIcWcKlD6wzoICWtbt5AoqNzUA
	rGecHuLNvJ1ix4H3vAmS7wHOigQ8R2icDUI+BWbUgOD8zeCWslD67hqz9lVHecDqekpziMenwPi
	bA9mCB/yvgE8zftaUnuTlXkQRPVhEtCTD5M/3Iw==
X-Gm-Gg: ASbGncsNVHnD8t8Qp3ajN/JU8+nN6XzFbhVb6YBMvc6+zUcWFwYTapkHNbQIkYQNdAP
	q7nEsSw/1Q/jlrYC/WoaCZY4EydfkZDBWR7DWCfZgn+XrFDiimXdeCB5+HBYpDywhDBbYsJ39EB
	cYneaDkCY8ujKKc26bj/fCwZOpfs5i633njkHlRif8AYrbc9P2R+jghgE=
X-Google-Smtp-Source: AGHT+IGZ9gQ3tu+qzuFMr0iUFZmrrGHM6mufdWGBmolg3g4UfIuy5JKVSAR8n7Xn1WvRpeLZXbEb1LtM6OVxDrfeO18=
X-Received: by 2002:a05:6102:152a:b0:4c1:94df:9aea with SMTP id
 ada2fe7eead31-4dad35bd8admr3238552137.15.1746036010199; Wed, 30 Apr 2025
 11:00:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250429161059.396852607@linuxfoundation.org>
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 30 Apr 2025 23:29:58 +0530
X-Gm-Features: ATxdqUGSmMl820yTA2v7nLItMEKSOy9gbZK2IzfLWQ2IEh-AL8fgRuomfjJoYNc
Message-ID: <CA+G9fYs2AK7jGyJ-kR884-CJA3RRLLWD8r1L5fKLYn68TSQ1ow@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/204] 6.6.89-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Apr 2025 at 23:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.89 release.
> There are 204 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.89-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Following two build regressions found one on riscv and s390.

1)
Regressions on riscv build with allyesconfig and allmodconfig with toolchains
gcc-13 and clang-20 failed on stable-rc 6.6.89-rc1.

* riscv, build
  - clang-20-allmodconfig
  - gcc-13-allmodconfig
  - gcc-13-allyesconfig

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: riscv uprobes.c error unused variable 'start'

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build error riscv
arch/riscv/kernel/probes/uprobes.c: In function 'arch_uprobe_copy_ixol':
arch/riscv/kernel/probes/uprobes.c:170:23: error: unused variable
'start' [-Werror=unused-variable]
  170 |         unsigned long start = (unsigned long)dst;
      |                       ^~~~~
cc1: all warnings being treated as errors

## Build riscv
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.87-594-gcbfb000abca1/testrun/28273725/suite/build/test/gcc-13-allmodconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.87-594-gcbfb000abca1/testrun/28273725/suite/build/test/gcc-13-allmodconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.87-594-gcbfb000abca1/testrun/28273725/suite/build/test/gcc-13-allmodconfig/details/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPmvuQupVPFOxaqXSUOvDNirrW/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPmvuQupVPFOxaqXSUOvDNirrW/config
* Toolchain:  gcc-13 clang-20

2)
Regressions on s390 build regressions with defconfig with gcc-13/8 and
clang-20/clang-nightly on the stable-rc 6.6.89-rc1.

* s390, build
  - clang-20-defconfig
  - clang-nightly-defconfig
  - gcc-13-allmodconfig
  - gcc-13-defconfig
  - gcc-8-defconfig-fe40093d

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: s390 pci_fixup.c error 'struct pci_dev' has no
member named 'non_mappable_bars'

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build error s390
arch/s390/pci/pci_fixup.c: In function 'zpci_ism_bar_no_mmap':
arch/s390/pci/pci_fixup.c:19:13: error: 'struct pci_dev' has no member
named 'non_mappable_bars'
   19 |         pdev->non_mappable_bars = 1;
      |             ^~

## Build s390
* Build log:  https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.87-594-gcbfb000abca1/testrun/28271143/suite/build/test/gcc-13-defconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.87-594-gcbfb000abca1/testrun/28271143/suite/build/test/gcc-13-defconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.87-594-gcbfb000abca1/testrun/28271143/suite/build/test/gcc-13-defconfig/details/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPmvTChk1B5KLhldYbYaKP2ckj/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPmvTChk1B5KLhldYbYaKP2ckj/config
* Toolchain: gcc-8 gcc-13 clang-20 clang-nightly

## Build
* kernel: 6.6.89-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: cbfb000abca1fdde27066eaf6cb77cbddc7a21c6
* git describe: v6.6.87-594-gcbfb000abca1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.87-594-gcbfb000abca1

## Test Regressions (compared to v6.6.87-394-g2b9f423a149b)

* riscv, build
  - clang-20-allmodconfig
  - gcc-13-allmodconfig
  - gcc-13-allyesconfig

* s390, build
  - clang-20-defconfig
  - clang-nightly-defconfig
  - gcc-13-allmodconfig
  - gcc-13-defconfig
  - gcc-8-defconfig-fe40093d


## Metric Regressions (compared to v6.6.87-394-g2b9f423a149b)

## Test Fixes (compared to v6.6.87-394-g2b9f423a149b)

## Metric Fixes (compared to v6.6.87-394-g2b9f423a149b)

## Test result summary
total: 127756, pass: 105351, fail: 5243, skip: 16647, xfail: 515

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 27 total, 20 passed, 7 failed
* mips: 26 total, 22 passed, 4 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 20 total, 17 passed, 3 failed
* s390: 14 total, 8 passed, 6 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 33 passed, 4 failed

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
* lava
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
