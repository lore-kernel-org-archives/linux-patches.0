Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0302B1BD00A
	for <patches@lists.linux.dev>; Sat,  1 Feb 2025 15:09:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738422542; cv=none; b=qeuPHAxr8Ks/g4h5Dl54KXTbqZr2G9+dFHPNSzKJzT7OrGjPh3CQlYxE0MoVWn7LUKgei1RVPOUCt+ubVsgwmzYY6Qyv0NeB3Z8R5dLjXZX70uBOVN+pAB0CGQ+fhXbCu6FNy0yclr+x8L745650k8zk5R3ytq2ANU89XwAZDd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738422542; c=relaxed/simple;
	bh=/A+QTl1o2pMWwHHZSSDAAVBWnvxOKJtC0s3Oj+lqgG4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cuBL2ODbc84LVdG67eWMJSUQIPe0DNNc8yaiGTCrAZKwK3hmxKOWeYkOne515ibXYmMH0eaMQVs8XmatD5j2+OuSHy6M1BTZ71F5uzj0zzP/jA+1pSf07l//lJPHEtrhxRWLEEfI9Rohd0msrJGdOBWLFhN0Mfx0w6NfuYo5az8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CnQ2wpuB; arc=none smtp.client-ip=209.85.221.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CnQ2wpuB"
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-51640f7bbd3so953271e0c.2
        for <patches@lists.linux.dev>; Sat, 01 Feb 2025 07:09:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1738422540; x=1739027340; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=OBQ44SQyOeljO4HnDRpC4Y94XPsE5W9YvH9TivkW/8c=;
        b=CnQ2wpuBmjCcBl4y6mqctE9hAI/Rem/nn00ro8KoGDFhH+oR7wYLP+ii3jeue/lQMO
         Rj4KWgSwTpsgYdGCR1Z/yLixs/NGq7gnkHdE/K+8WDDtpTeRo4r6WkFKICRx1EWBJu/0
         9UreOaTogfu+39XAMjx3xS40FXIQpRIUuGRJDCSMD6GOSZpCCoKkmzAKBzyRdbeubz6Y
         9mpn1A6w7U0sPCT+KHfnZR1fBau8IUna6SYwMSMF1ZxcjVYv3uBQ44z1NyekHr9D1jfc
         +ZkwQs3RTGUNArwXMeJPZHX/D57ydb5ZbMh9f6L5otw6d/+JoaDEeKSQtPaRS58cAdrd
         apLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738422540; x=1739027340;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OBQ44SQyOeljO4HnDRpC4Y94XPsE5W9YvH9TivkW/8c=;
        b=I3SA7VA8pcAUE7FPS4fYsDgNaQhP/lL+obyg74nO6vUuwICyqkQ57TMiCeVWT1MdVm
         2tWG3lzEseTWL5BRksDPTDrv0cU2QabFfonOV7H8nHnKZX+amqbYS+V7LABUaizS6Vrh
         5MSnZvScaz8fSj9euPPk7811oQGzGCOqNXTYB3JQO/xwelnbErS9X3LD2kDxOIOZp2gu
         w6OKGxH7U/1kYofGKhPIBAMBvUibYy5xO85UPQ5EinuS6d4jsWWSwHGUJP8VoMa6o0XB
         wxscDGqKQjBn4gW+ukcTo3pGOiwUTz3mK3jmqPFH2tB0gzh4DN60AGKHT09PoGQkx5d5
         MLog==
X-Forwarded-Encrypted: i=1; AJvYcCUIZMlsUyDHxHb1XvbWVAOfCbzhS3dltFTJmEeFQ+weeTJc2h94dW1dsigWRbCI4DtKdM2UiE0I@lists.linux.dev
X-Gm-Message-State: AOJu0YzQxW8SNO1yHx5BYfX1NbAOg/1ZTrWk7pHmdBnBxuUAOgOyFFZc
	ydWdaKV2EsGvHkg1blQGdxDXOHmXNKCrA82HIu/TXkLSjVY/Vv+RyIzcoJVSOtAI7RqXZGiykD+
	yT7UmUn16HpYCHdu2nTagaTbPsmt4Z4J0JQxhWg==
X-Gm-Gg: ASbGncsUdDkm0be7bmlLjelZ6ih8M6Itt7ADsq8PTHrakApY9EfTbszCCvLsYYPPN41
	krgja3SlP2/SbiJ6kLWtEwg8A4lVfMeqHMl5PIdSypZymuwxp3gXGE/n1dDhloF+1puIJOHZD/K
	I=
X-Google-Smtp-Source: AGHT+IH7T6QC4q6y+mz61X4xpvHGlTS39L2ylkM87/l7P1wwnD6uiiVDv2UkuNHu2hOsDyXn2EEd/LstB/US+7N5sY8=
X-Received: by 2002:a05:6102:226a:b0:4b9:bdd8:2091 with SMTP id
 ada2fe7eead31-4b9bdd82bf9mr5310702137.14.1738422539748; Sat, 01 Feb 2025
 07:08:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250131112114.030356568@linuxfoundation.org>
In-Reply-To: <20250131112114.030356568@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 1 Feb 2025 20:38:48 +0530
X-Gm-Features: AWEUYZnyrR7OVlFtKvwhUCRfS8uIdoOK5ivjSB1JA_uPY3K9dVpszefiacUBc1k
Message-ID: <CA+G9fYtT36DGS=6+2u35Ki1nyo0UR2A1ee3ifUfqga6D+K2egg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/94] 5.4.290-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 31 Jan 2025 at 16:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.290 release.
> There are 94 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 02 Feb 2025 11:20:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.290-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

As other reported,
the riscv build failed with defconfig with gcc and clang toolchain on the
stable-rc 5.4.290-rc1 and 5.4.290-rc2

* riscv, build
  - clang-19-allnoconfig
  - clang-19-allyesconfig
  - clang-19-defconfig
  - clang-19-tinyconfig
  - gcc-12-allnoconfig
  - gcc-12-allyesconfig
  - gcc-12-defconfig
  - gcc-12-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-allyesconfig
  - gcc-8-defconfig
  - gcc-8-tinyconfig

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>
Build regression: riscv kernel traps.c error: use of undeclared
identifier 'handle_exception'

Build error:
---
arch/riscv/kernel/traps.c:164:23: error: use of undeclared identifier
'handle_exception'
  164 |         csr_write(CSR_TVEC, &handle_exception);
      |                              ^
1 warning and 1 error generated

Links:
---
build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.289-95-gb4cc7cb40189/testrun/27103461/suite/build/test/clang-19-defconfig/log
history: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.289-95-gb4cc7cb40189/testrun/27103461/suite/build/test/clang-19-defconfig/history/
build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2sOPMVgFZtEG3dgzhD7rgdCoAsj/
kernel config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2sOPMVgFZtEG3dgzhD7rgdCoAsj/config

## Build
* kernel: 5.4.290-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: b4cc7cb40189a3206ae81247a0596c4a2b4a9f69
* git describe: v5.4.289-95-gb4cc7cb40189
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.289-95-gb4cc7cb40189

## Test Regressions (compared to v5.4.288-94-g0578e8d64d90)
* riscv, build
  - clang-19-allnoconfig
  - clang-19-allyesconfig
  - clang-19-defconfig
  - clang-19-tinyconfig
  - gcc-12-allnoconfig
  - gcc-12-allyesconfig
  - gcc-12-defconfig
  - gcc-12-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-allyesconfig
  - gcc-8-defconfig
  - gcc-8-tinyconfig


## Metric Regressions (compared to v5.4.288-94-g0578e8d64d90)

## Test Fixes (compared to v5.4.288-94-g0578e8d64d90)

## Metric Fixes (compared to v5.4.288-94-g0578e8d64d90)

## Test result summary
total: 44418, pass: 28423, fail: 4303, skip: 11414, xfail: 278

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 136 total, 136 passed, 0 failed
* arm64: 37 total, 35 passed, 2 failed
* i386: 22 total, 16 passed, 6 failed
* mips: 29 total, 27 passed, 2 failed
* parisc: 4 total, 0 passed, 4 failed
* powerpc: 30 total, 28 passed, 2 failed
* riscv: 12 total, 0 passed, 12 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 8 total, 7 passed, 1 failed
* x86_64: 33 total, 33 passed, 0 failed

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
