Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8169129A7B
	for <patches@lists.linux.dev>; Wed, 24 Jan 2024 14:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706106580; cv=none; b=KoLTHU4wkPh8I5kqhvBqJMDvV0D45RnQSE2S47GHKlwczqfNLO7PhMIul16WlXoOqmdXmC7DWpSDojYAjxiY/7Yj1g2WvBBPUn6qr4SHsuz0VPS+u8OztuOACrR7Q1Yj7EettiCYfwD1K5wwgczTR95I/Agnu9QRMZzFVMsneAU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706106580; c=relaxed/simple;
	bh=akEtNapOtWe4XpDbQ03Zoq4jA9AuW4EIjZlR9eCJqUM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=bDjyZJF0lh4s9o9OFQUiXzvSeAs/+c71vbtS/0WBYzzrOyHb5X7D3MZV4XiY2t2Yz/MjyJSFbsPVW+2nx7AWDfgcrMe5O6hK7UMbYWiydEi0gwl6tggCY3Xryco6FiQ9iL9PfbLu1MtzcvLih1FaD+gzV6jwvx2tmr+cv4YRLaY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ftW4/oy2; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ftW4/oy2"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-4bd559d127cso258539e0c.0
        for <patches@lists.linux.dev>; Wed, 24 Jan 2024 06:29:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1706106577; x=1706711377; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QHJjqYGfzpKjEknY4tel33plGqBq8hXNMw/yUH7PxwM=;
        b=ftW4/oy2FOiv98oFv0V4vgRznEpqC74eh8v2N6Ly736mI7vxDAsgmLtJ8dtqZmx50E
         pm7U0a+LM/OI/VEhL03K2Sjqa38s266R82IPdk/UWuQ0/kYHTxCDQveGtV2UZZ8BwB5K
         3cut5zEkKSFNoWUlGi4+nHBl9TviKQMJ9S611xyVVe8efm8oXx20m9cEc8uiKkU4yf9L
         ZktbV+9tjTwBHhhteofaWebKGdxR410oCqfzMlZDrMaXcvWkRIxTGVmzgi9/+gjHk9HM
         TYG2+jAvOABbX8ho/Ya2ZsjWdbwo17XeMNJc/cQwr7UD254QGQ4u9CYausGvJyCilieF
         0jcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706106577; x=1706711377;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QHJjqYGfzpKjEknY4tel33plGqBq8hXNMw/yUH7PxwM=;
        b=a5ON4aof9kiI4HgQJhIWQD47vK68izkXTTD8KPs7OgdtXAko6MH7KeoXsm32QUgj+U
         Wqh1NB3p1PfUDMToved7D7yZt+q8dEfQuLXW+xoB5GRPAoFKegDSQz7WhqvlItQ/ME5V
         Yt3btunVVeJLwr/bQj1VRYWLCglg6pI3fr5rg/p1benx+xxv/eyDyt8kLAybhI97OUn3
         fhu1ucL7GAvIVTFH4PU/a9sgbT7ncb1K2leDegjv1N7LBx42tg6t5TuxB4GC6Zc1SLT6
         /J5eXfvyUE/6ci0GvKsidX/4buD6kb5Uz7oY1fbL/vxawJmANRBVXe7aR9Gk9L0D2wQ1
         VHhg==
X-Gm-Message-State: AOJu0YxhgvbmQogKj4yPCZkz6i5Wzv+q7pLiPbznVjcIq5qnUX4bwjb4
	bjIofkbzBSatqUXHcXY9rOsBKdzofOeV5x92Wywhwv7aTQ+XipvZWdfVfOi48udUUGBVD6uAR8b
	GMIjIPXU45vXfVNs95j8Ze857E3ARxs8U1v/5jA==
X-Google-Smtp-Source: AGHT+IEWYS7aa4rSosSQMCkKHSWuVc0Pjr5R5BjdJVrA8+kPCCiaHuOyToSu1TkPpSp9eaVypHJYqCsnpXTItmLIoVY=
X-Received: by 2002:ac5:c986:0:b0:4b7:6fa9:1166 with SMTP id
 e6-20020ac5c986000000b004b76fa91166mr3672345vkm.0.1706106577560; Wed, 24 Jan
 2024 06:29:37 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240123174500.819179356@linuxfoundation.org>
In-Reply-To: <20240123174500.819179356@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 24 Jan 2024 19:59:26 +0530
Message-ID: <CA+G9fYsmps8+Mf5qW2gB9BC1Bw9d+QBS-CdR95LSNz=R3KAVsA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/371] 5.15.148-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 23 Jan 2024 at 23:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.148 release.
> There are 371 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Jan 2024 17:44:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.148-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.148-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 6de5fbff4f2e80d1600441f61858895afcd2fc61
* git describe: v5.15.147-372-g6de5fbff4f2e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.147-372-g6de5fbff4f2e

## Test Regressions (compared to v5.15.147)

## Metric Regressions (compared to v5.15.147)

## Test Fixes (compared to v5.15.147)

## Metric Fixes (compared to v5.15.147)


## Test result summary
total: 96904, pass: 76054, fail: 2826, skip: 17923, xfail: 101

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 117 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 34 total, 34 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 26 total, 26 passed, 0 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 11 total, 11 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

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
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
* libgpiod
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
* network-basic-tests
* perf
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
