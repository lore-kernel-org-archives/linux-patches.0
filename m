Received: from mail-ua1-f47.google.com (mail-ua1-f47.google.com [209.85.222.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C8A2134D2
	for <patches@lists.linux.dev>; Thu, 15 Feb 2024 08:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707986731; cv=none; b=qkaB9RFPfRpLmw3CPDAc5zn/6oPKoPKDDl7XUBFhEdKbYcOubRUpGCMZBP8ZmG2aDdDJ2BT36YKQUEWndPuci4bCN93z9RFpXtMkVoHHrwU4BRFfhsw/CHQpS8KpBXfLcpJPSosvmC0/s7I+XDpMaQj047ffZaAHcBrdV0mMmuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707986731; c=relaxed/simple;
	bh=x0Tw6BNK11EGdmc5ZGxRfDLUmSeE8Z6xhgnpSMVoYtY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RfZHP7Quof+/8BdRTmAzKVIC2MvnIRzS2L4QPxMNEsDhU+On8I+ZrCZB705GG6QqXU5X1OIsA+nnG7EQ+/o55iwLdi4VRzAQprsMEKGXb/OdPCC3skxFVYr1wwINFB1mve5DfGqrco2ky0/XeXT+sxD4DyyazgjvjjKYszkP6LU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=DfEk9Tvz; arc=none smtp.client-ip=209.85.222.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="DfEk9Tvz"
Received: by mail-ua1-f47.google.com with SMTP id a1e0cc1a2514c-7d2e16b552dso355811241.1
        for <patches@lists.linux.dev>; Thu, 15 Feb 2024 00:45:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707986728; x=1708591528; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5x8+nXLLVCvqxzw2c9wjn6NCQJrdXn/C+WdlvHqn43s=;
        b=DfEk9Tvz5tcrrGb2Lnu6M/q9eqnNpA58foGtB6ztwoJTtUHTPcl9lKAJx1m5qWIz+/
         krpkbsaDEnZKP1DugANHPZH9A7LK8PQgqnjgmkyZ/BTMaTNQ8HmHRnnkxRlm2jMwadMO
         MOlIMAkgCW2tKPySqm6nGDKJmunC3JG1Jh8tXatAz9vd/L9l0eFWeqzkpaoNmPJyr1y8
         yvJ+87di9lnJoLTG8Ch9yd7CpfZP2lBC7w+bvRXxqBsiPn0ppSWX4M0TQz6nTGbJ5WEJ
         WohOrlR363nGQH66Qri0OOWfWAEewciB5Xd1P46ezNheDyogIPpg/ZHM5kGSVhWsDzng
         +yhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707986728; x=1708591528;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5x8+nXLLVCvqxzw2c9wjn6NCQJrdXn/C+WdlvHqn43s=;
        b=uKryPWXd4cr7WP7fq8XedyTEsdVSgwy343NpUi2Zrb9oZkF7OjbI3LiauPMUgCRlKQ
         GbVBMeetGWVZ6j79pLflNB0p2LXfEyCK96NsIPw3IqFtuHSd+PfwJx4ju7VceZ+kDEYp
         W2/iusUuUSVlgH0MD4fz5nLLldLKgM+XUunp1EwZ1lbeVNvclU9W16dkn7G9VI0A9HbP
         Jm6ppuiMb/YaMnY9PjIUuQetMqrM3PPCSz4f9USL9cYm4KiwPgmJZvYSSVzkXzZliN6w
         z/KE/dTStUCwTZoVteb/5Mgp0XXIKSuRz2UNIFbYMs+RPl2yjziSzOOiECct6YVxsKJC
         Izzg==
X-Forwarded-Encrypted: i=1; AJvYcCV+gVZXHlrBnRk6vk0Kc4U/0E9i3xtb+TKWnQ3K9oSzKAO/23rLD7yF1YK6J0+j33iEDoiQuij0ktJV00umFhEpifAV5hUanQ==
X-Gm-Message-State: AOJu0YzMgHA8S2HjEvBvALlhS2KEP+P9FCaCTdFS4QwXBxrfaXn2aBT+
	RrrO6R6+y2TEdPZ2Dh0d3sm4dpQFKe1hPnjkqB+tilEMMq33rqyuW1xlxp+CMC9D6RU9f5jCiFF
	j2I7Y5fx3R6T8KFVHLaYU+nGX9ayVLCNQUi4/jQ==
X-Google-Smtp-Source: AGHT+IFNWJdaAhQzckrGqOsKbWuM1nCexSm2uMnTOxJzkJyZSa1i/i1yEuc4m0ViYJU/94nEC61OEU899J5XPGpQ6/w=
X-Received: by 2002:a1f:ed01:0:b0:4c0:263e:bc8a with SMTP id
 l1-20020a1fed01000000b004c0263ebc8amr1035101vkh.10.1707986728180; Thu, 15 Feb
 2024 00:45:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240214142941.551330912@linuxfoundation.org>
In-Reply-To: <20240214142941.551330912@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 15 Feb 2024 14:15:16 +0530
Message-ID: <CA+G9fYt92+z5kTh3LUYiu5rNgnMyMe=O6Mve68ZrfsQ6TR-y0A@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/65] 6.1.78-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 14 Feb 2024 at 20:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.78 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 16 Feb 2024 14:28:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.78-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.78-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: ea6a03790c420fec42790d8c5db2e81663954186
* git describe: v6.1.77-66-gea6a03790c42
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.7=
7-66-gea6a03790c42

## Test Regressions (compared to v6.1.77)

## Metric Regressions (compared to v6.1.77)

## Test Fixes (compared to v6.1.77)

## Metric Fixes (compared to v6.1.77)

## Test result summary
total: 138874, pass: 117646, fail: 2876, skip: 18182, xfail: 170

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 151 passed, 0 failed
* arm64: 52 total, 52 passed, 0 failed
* i386: 39 total, 39 passed, 0 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 34 passed, 2 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 45 passed, 1 failed

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
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-watchdog
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
