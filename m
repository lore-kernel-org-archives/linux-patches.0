Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC4A6215764
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 16:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746032352; cv=none; b=Rw/09zSFHN7ujYlMHEP5AuJY0Z5PPgjh9DDXBU/qJXt78EKm7z9dM46Hui4WYBvENDdGebOloW+E+VXYbLNBpAGi0q6swSsGvc93Qzz452Mm4Nk1bQs+2NEc3xsLEI0inZxfWtxvsFwWVbtmV9xSmcZWO2VzV7XJZt19QRXd0y4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746032352; c=relaxed/simple;
	bh=GTEcGUBkKPXccT1faiEnmUazUSXbka2qTdd3HnptsE4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JsCoDRV8OVtgRSjytzZY9tS3W0p3g5w1kCqzpRkZLEZ36/7BBKlVhXtKlTe3eHAIEqxJ5VuExcaRjfq7mdTsf18qOJHYy+gHsIzxCNpXHPVMmtpNFsCubIk2Res9fQat82Ji6TR7mmd2dVN39YQOJf2+s7Z89XwpDj+rHTjN/Oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=N8G67/et; arc=none smtp.client-ip=209.85.217.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="N8G67/et"
Received: by mail-vs1-f41.google.com with SMTP id ada2fe7eead31-4c3745b28cfso18517137.3
        for <patches@lists.linux.dev>; Wed, 30 Apr 2025 09:59:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1746032350; x=1746637150; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0lXnLM79c71DsoI+yzl4Y7ARxJ3p8ButReOnFnSco4I=;
        b=N8G67/etMHnZevdpYKuqB6QC2OppjoqVVPk6tVdYFrD2lhhyNosDEbKPMS3wv21oLQ
         ZhgKzuN4wfhhhGuuH9rW2WaLmwUEXpHdKvEW7k6FiIgX6n5XbXp2N/3x2tmxSUQl2Lml
         UTXqDiXO8eFRDcUEYLPaLd1GHCPiXwTNdDDDiWTqky1o7Z7KdnHGlo3nBODrCLGuV6SL
         nSrOr7fT7jyRAj+iX1DC4ZuwHtWkLD9Ksin8J4SW7O+6HGQzC2s4SPvhPestiHD0NCiz
         w8fyHOuL9j3rh3YPpZZMEoD+kR7Z4jVuJMsP3GE1rHuP6GYQGy7mtMRNbvVrdMeBnagM
         yjLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746032350; x=1746637150;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0lXnLM79c71DsoI+yzl4Y7ARxJ3p8ButReOnFnSco4I=;
        b=jSVrY3EtYbZ3jJxaEBxkAgk3WxwKMt27C5uUix3h6OaLI6jz7EKCMq1fjLxE1I5REm
         bI3EOtU+utOUfduTU9QOsuRG4FGZNym4TrFL+ocrgREV2XuB1O/paAfJ0ySqXn1WogpA
         NhOS5aGVCjLGt2oCcH3+o6cRIRVWqyny7574ceExfogUNXlQeBy6hLkqEtoGgVEDNazG
         2b89nB1iIGPKP1qZitM4dh0eRZ5/RX75+j8cOdWWWK17zbJ20cWmwvKcVk2TYFdN6/wT
         VLz/a0te9R98DlJw2SBlLxjNZz1BKrDNq/H325ExShXuYL9jugJ9sKsuo+PPtPQZcxb3
         w5og==
X-Forwarded-Encrypted: i=1; AJvYcCXO9CmOXNdGl5f62ctHqHUbFYAA5xZFBIxIozupBeDOrB4KViFL3pnUKnS/Qzn7/rQXdl3vRakT@lists.linux.dev
X-Gm-Message-State: AOJu0YyQKog7YIx3trrp3hoZsegugcNJz3BlCTiIwOUKXMZVtLLcGzm2
	zeEmZNnmQvhDKJrqp5oXMF+WTDPQ+6tDVLWPTEgASTei3v6UI2pm08ahTFeek9Y2pn/CSsK3pns
	3UjEa+mi4Ne/IEf0WrqNIPlGY8YOnzjAeq2RlzA==
X-Gm-Gg: ASbGncsLMuFhK+B2o+zKPIBNOoVDnEemGgDGFq3TIF3ZYRpQMbxqmQDIk9s1MvLlj2K
	FbTJuCMONh+8XhUOUdPU/jDrJkifA3MdB5YD34hQgTALU00rkCEg30zPdJ+m9yDm6DNMCZ2+O5D
	mEBJM+q4VWi0DsuzjZEJZM4ymReN4jpen/X7VcvZMbvzyAm7dSlFxkdeY=
X-Google-Smtp-Source: AGHT+IEH3dIIDHsW5az+V8pUXZxXzvAaiwxnqrgFU7XrBLDT0NnscivJwFeiXI/Cd+Ul84Eq/ffVssTnacHufU5Wr94=
X-Received: by 2002:a05:6102:3c98:b0:4bb:dba6:99d4 with SMTP id
 ada2fe7eead31-4dad48fea6amr2931325137.7.1746032349721; Wed, 30 Apr 2025
 09:59:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250429161115.008747050@linuxfoundation.org>
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 30 Apr 2025 22:28:57 +0530
X-Gm-Features: ATxdqUGfeogcMik9UVwyPEMLTncQujWiyfwm5zrgQu384girWevS6O-yTBLvD4M
Message-ID: <CA+G9fYvL0ZXnqujn9iNvy59R1gzX10Of_VLRmad5yg1aGxO_ZQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/280] 6.12.26-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 29 Apr 2025 at 22:55, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.26 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.26-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Regressions on s390 build regressions with defconfig with gcc-13/8 and
clang-20/clang-nightly on the stable-rc 6.12.26-rc1.

* s390, build
  - clang-20-defconfig
  - clang-nightly-defconfig
  - clang-nightly-lkftconfig-hardening
  - clang-nightly-lkftconfig-lto-full
  - clang-nightly-lkftconfig-lto-thing
  - gcc-13-allmodconfig
  - gcc-13-defconfig
  - gcc-13-lkftconfig-hardening
  - gcc-8-defconfig-fe40093d
  - gcc-8-lkftconfig-hardening
  - korg-clang-20-lkftconfig-hardening
  - korg-clang-20-lkftconfig-lto-full
  - korg-clang-20-lkftconfig-lto-thing

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: s390 pci_fixup.c no member named 'non_mappable_bars'
in 'struct pci_dev'

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build error s390
include/asm-generic/io.h:736:21: warning: performing pointer
arithmetic on a null pointer has undefined behavior
[-Wnull-pointer-arithmetic]
  736 |         writesl(PCI_IOBASE + addr, buffer, count);
      |                 ~~~~~~~~~~ ^
arch/s390/pci/pci_fixup.c:19:8: error: no member named
'non_mappable_bars' in 'struct pci_dev'
   19 |         pdev->non_mappable_bars = 1;
      |         ~~~~  ^
12 warnings and 1 error generated.

## Build s390
* Build log:  https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.24-499-g990f4938689a/testrun/28265216/suite/build/test/clang-20-defconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.24-499-g990f4938689a/testrun/28265216/suite/build/test/clang-20-defconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.24-499-g990f4938689a/testrun/28265216/suite/build/test/clang-20-defconfig/details/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPferDpcis0NyPDGQjav2hUYrd/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2wPferDpcis0NyPDGQjav2hUYrd/config
* Toolchain: gcc-8 gcc-13 clang-20 clang-nightly


## Build
* kernel: 6.12.26-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 990f4938689a6e1e62fecab4342d21ae2a0d5136
* git describe: v6.12.24-499-g990f4938689a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.24-499-g990f4938689a

## Test Regressions (compared to v6.12.24-224-g56d2398227a2)
* s390, build
  - clang-20-defconfig
  - clang-nightly-defconfig
  - clang-nightly-lkftconfig-hardening
  - clang-nightly-lkftconfig-lto-full
  - clang-nightly-lkftconfig-lto-thing
  - gcc-13-allmodconfig
  - gcc-13-defconfig
  - gcc-13-lkftconfig-hardening
  - gcc-8-defconfig-fe40093d
  - gcc-8-lkftconfig-hardening
  - korg-clang-20-lkftconfig-hardening
  - korg-clang-20-lkftconfig-lto-full
  - korg-clang-20-lkftconfig-lto-thing

## Metric Regressions (compared to v6.12.24-224-g56d2398227a2)

## Test Fixes (compared to v6.12.24-224-g56d2398227a2)

## Metric Fixes (compared to v6.12.24-224-g56d2398227a2)

## Test result summary
total: 142554, pass: 117555, fail: 6231, skip: 18376, xfail: 392

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 16 passed, 2 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 23 passed, 2 failed
* s390: 22 total, 8 passed, 14 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 42 passed, 7 failed

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
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
