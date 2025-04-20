Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 488E018FC9D
	for <patches@lists.linux.dev>; Sun, 20 Apr 2025 08:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745138253; cv=none; b=WeLVHMMrPUS276qxMR5KWk4j5p+bCZGeEDCEEoK65RpUnYglDCqVelnKu9hxAuSyiE7SydRYkzP028PEiUGOCYkWodDFhTcYA0w8W1ZGbu6XjdCZzDuWIUFoFV1rUSFDcpAiuqIulAxpjQr5uMxfdzUVZdSXAjAv6i00rpV2zyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745138253; c=relaxed/simple;
	bh=XOedVC2OqIkvM32YOlVepMWbA4ZVgTX7dcNX9a3iyUU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fR+xzWRkxPEFnnSEp61z/ZSv4zCd6X6YqdQjv8+FIO0kWvShz1OIoMw9tCMJrUgbhtWyx7doUWIoKsQ3E6VVDX136R/3aR3MyExdzJuYiCin2QCSM6AG9pXX9lJOA71xBA/xROkzAVwmNnjjBGklaqjVQoHw3VsgB2UlgWp5Naw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=F9DsbraM; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="F9DsbraM"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-5259331b31eso1348170e0c.0
        for <patches@lists.linux.dev>; Sun, 20 Apr 2025 01:37:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745138249; x=1745743049; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=sKGy/O1Y5X3EKpR0Pd5g6I+Zj0C1CEMV455BmTDC5pI=;
        b=F9DsbraMBLQov1PHZOPDCYBwNdcEzjPJrrPY7nxwOz6dWz205AU+zA+6q8yYX+ggV4
         CY7IT3WkIBxv4cK3CbXTsvnauSR17go5BfXiIVJteUcqKudKuGSsFbp9IpE6bw4m/Ddy
         r1KaseGluD5f58q3vWt2bydXg1qmbx2NjB9ydlUCMPR/5jOMXUu7huHkWG8HOT/f/M9w
         uDTWg9+bYcqYeeERm+0GDyzOeEOW7p8fTzjVbNX9zLcVtNloAfNexN94DTpq4ByWGDB7
         7yTaGrdSgLVeUMy64q0BdxHEYYSnDKHDxuvleLBtz4VO34hlfM+wgDFUllE0Srn29+vu
         H5TQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745138249; x=1745743049;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sKGy/O1Y5X3EKpR0Pd5g6I+Zj0C1CEMV455BmTDC5pI=;
        b=uGpACIaIhcg+LZkuNMySIt8lIjMz6mri7DJj07IzkdxEiABQCMvfWHfT7vsYP2OWc2
         4t2O/LR/qs9aS3BVhe6S+XhgLjoZUalw/1fM1yYyTXKNxn06a9z/Tz50W854Hu1cu+Zv
         STTrWeATxWAtq9cRAyzy3TSpCFOJl6j9qzXawhmtwA9vUvESE3mdcqyOAef76jdHpr+e
         /z0CK/AOoZhmZHBJ+3p3oGlnCicWWs5N7yQfwe2eeU40MfV2PEZll4m6DWj71L3KdTvK
         LmqF6ESsQ9JFkWZBlwhvD7C3tZYLmVdx+1cv+isodRWDr58An+1Rh/vAD+JHNChjTynL
         fMZA==
X-Forwarded-Encrypted: i=1; AJvYcCUGJlZhI6nPP+sy7D4p7ErA+5rMeG2HEXNM5s5vCQHC3j9uE/5Y4umGcqQwIJr45+MnZl+gulT8@lists.linux.dev
X-Gm-Message-State: AOJu0Yz4eH+JJq+L1gBWOzE4FZCGnuLR4DEFLrg4FIAcSA166s+2OCNm
	bYkMUoZLG7sQ0BmS3oD573XQ/9N6UbUokTS79lxutsXHL+LlIpNvNdacmzYxtmAkiNaBBobLrbV
	O/wDsmpBti7gKxRCHtDM+prxQ1JT4sjEQNPcw2g==
X-Gm-Gg: ASbGncsNMKsO7SZskmLy7Cr5VNSQfuG9/v9NEwRDl9F6lzNrhBwkRUUT5ye11D8TSbD
	wcjZ49aeNoix0XhdjwnNrwA9YfCcYA8I4qy7yk9m8ORaqyM9Hq+rgzkBVIyIpAf7R8iHj/hzTLS
	C+FZUt6yDyJn9WTUHe1ScbiZZyt3SjrXwqd5Nu7HjBijY1ukCmPotUS4o=
X-Google-Smtp-Source: AGHT+IFyyBbYrrnY3oRNhMICpkh3U6C14+ws6Ya2UK9tFei4AKCOzunP7pbazBufbKc+pkOMt7WmkbcrFYD+ebFGdZk=
X-Received: by 2002:a05:6122:3109:b0:520:5a87:66eb with SMTP id
 71dfb90a1353d-529253df465mr6314139e0c.3.1745138248931; Sun, 20 Apr 2025
 01:37:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250418110359.237869758@linuxfoundation.org>
In-Reply-To: <20250418110359.237869758@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sun, 20 Apr 2025 14:07:17 +0530
X-Gm-Features: ATxdqUFaBu7M7XklmnYHibRuXM6rlLQtZObQzh9w3_qgywS20rS88v6OMHfqzs8
Message-ID: <CA+G9fYtGn8EDdkUNpZNQR+Z4+GvhSzgGYw3X6sZEEewRG-2M7Q@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/392] 6.12.24-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Fri, 18 Apr 2025 at 16:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.24 release.
> There are 392 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 20 Apr 2025 11:02:42 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.24-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on arm64 dragonboard 410c boot failed with lkftconfig
on the stable rc 6.12.24-rc1 and 6.12.24-rc2.

The bisection is in progress and keep you posted.

Boot regression: arm64 dragonboard 410c WARNING regulator core.c regulator_put

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Lore Links:
 - https://lore.kernel.org/stable/CA+G9fYtaRQhArip=UYkLt864AnXBD6Y07-06CjOJZYSDZ858SQ@mail.gmail.com/

## Build
* kernel: 6.12.24-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 7b7562936f806e759a787c58a46b0c9ce988f15b
* git describe: v6.12.23-393-g7b7562936f80
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.23-393-g7b7562936f80

## Test Regressions (compared to v6.12.23-2-g8e0839d16957)
* dragonboard-410c, boot
  - clang-20-lkftconfig

## Metric Regressions (compared to v6.12.23-2-g8e0839d16957)

## Test Fixes (compared to v6.12.23-2-g8e0839d16957)

## Metric Fixes (compared to v6.12.23-2-g8e0839d16957)

## Test result summary
total: 147158, pass: 124098, fail: 3723, skip: 18937, xfail: 400

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 57 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 23 passed, 2 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 49 passed, 0 failed

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
* ltp-cv[
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
