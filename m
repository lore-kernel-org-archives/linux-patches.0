Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 022E56CDAB
	for <patches@lists.linux.dev>; Fri, 16 Aug 2024 08:45:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723797958; cv=none; b=HgAdjN4443wb2IJtKW4ahKYI95xAWwZoJbwAAYOkcccKqzm+ynhMbuclNfjLLGwy/DMq1HyCd+wSde0zqN5/oFSEk59EZW21G/6jqX2E2/KYmlJ6O5ke0U9al0F0ZHnDFDD2HZHMv0D97ZkaQ0PXxDJWeRm7Ijb2xrm4XtyLw6w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723797958; c=relaxed/simple;
	bh=l/cqChJg/Qri4UK2uKbK3Vo1Mya7dlt6OUhrF+Ts1Ug=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tJjxoTaKuCMi2RPDTAaZ9vxWnGUkncgWv7FA8GncLHftTI1L7loweFR2YeFPxutg75ozFUkZlmVqzlhV6EIGQiO10N+lomyUygXPpZpUdCC/z8wNO4XhPPBBeH4EVYoajupVye2MuUErwJ3cgIVP8Cy6ILLlJDfi9bV+btAAS+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=LcCyjLAh; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="LcCyjLAh"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-a7d2a9a23d9so214204766b.3
        for <patches@lists.linux.dev>; Fri, 16 Aug 2024 01:45:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1723797955; x=1724402755; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mJckoRh5CnaAaQkEaSAtT4W0I5ueEE7s+w6QDeInXtc=;
        b=LcCyjLAh8JAOd5rgGZ+soxPWhqrmD9qiqmVxZVuQjywwp7bMRwgPxSVP9oMOwH13oK
         zZFRc9Z4uGc2RAMLzD3mJeC8POGula3mQhKSJAeFKBs9huGAgH9uQ2F3ryRz5ea2LP/H
         c3RxUAb2h/kxbghN1w0IK0IbvLkE6aYxy7UMvAFbBuU0ZsFsaOQDustSA6PvTWYc6X76
         AkB2oIpbVwZ6/MQY8IWMupX2jTyRMxvdS6uxT1Wvl0JZAO6kr17ZfftJOgMTXLMUae/S
         lJESHMAkD5fHspBR8DTsEvUPDrIUbzbgWRxDr2gMmnEX0nXPKjKta1AI/oQCyB3fajJR
         4jvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723797955; x=1724402755;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mJckoRh5CnaAaQkEaSAtT4W0I5ueEE7s+w6QDeInXtc=;
        b=cJZF3tm8c35Phje9JkvDwZ9sZUnkeaOmwRtm3F2h4iUXN8IMXgox5D+Fr7jN40M+hK
         YPidF9wgyu8zzUEn8dyvth1o/MvO5o4+pYIP+nNRrTj903zcxM7gu2NzpJqTKFWLJday
         ipXlkED7XjyP1XyAgV0tOjZZ57GKJFLdhW5NioB0n9RtTgizVWB47QOL3cNN18vzRfuZ
         3XtPLLOu8w7e5cBAIIYAqqpVnPv9XgVOoInDN65S6Lvv/YnmeUdOeI6vi2IsdA0tuGec
         TZhcOS3iRV5xFQvYzCLHmbF1sM7xlA948vO2oWfEUbWdvVVYStC56COkxGoO0t4X6zXC
         Yi+Q==
X-Forwarded-Encrypted: i=1; AJvYcCU/KcQiNnsS+Fru/pbextz+UNP89o8jbf3/MJy46JMDw/LY0SGNLeRgtrStmZTkGMfTeVKZWG0ogRvs2mjIZdVT3ZHBt2RB7A==
X-Gm-Message-State: AOJu0Yx/wyzKTgGjaqTHl4ARdnXEyUHh8ujo1p6gSQEPIfao+w1Jz1Gi
	4c8LUoHTuZ6UH9aQCDJAMVPcHweT3FP+u3h6hDu9gSuSJq9RWa5x8eNpE6rd5XCATMTwNiCnvQ7
	uZJFH56kUP3q5a7WxqnAEEo2QXyDUur0zapVWjQ==
X-Google-Smtp-Source: AGHT+IH7RfoI3zCZ18l1bcOSWl0DD/OyHznDjT1xZTI8Gokc7IBOc4WLg21syXDGg7iJYFGi4t6uaJxwgE/Oz36dr2Y=
X-Received: by 2002:a17:907:6d12:b0:a72:7245:ec0a with SMTP id
 a640c23a62f3a-a8392a47243mr135538166b.58.1723797955238; Fri, 16 Aug 2024
 01:45:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240815131831.265729493@linuxfoundation.org>
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Fri, 16 Aug 2024 10:45:42 +0200
Message-ID: <CADYN=9L-zL+r+K-XwMGQrs0AqOB8F=k-mE=ULxv+z_DpCMixAg@mail.gmail.com>
Subject: Re: [PATCH 6.10 00/22] 6.10.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

On Thu, 15 Aug 2024 at 15:39, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.10.6 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64 and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.10.6-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: a812f2032d1ccdc36ece9248c14ac3ec8a936cec
* git describe: v6.10.5-23-ga812f2032d1c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.10.y/build/v6.10.5-23-ga812f2032d1c

## Test Regressions (compared to v6.10.4-264-gb18fc76fca1a)

## Metric Regressions (compared to v6.10.4-264-gb18fc76fca1a)

## Test Fixes (compared to v6.10.4-264-gb18fc76fca1a)

## Metric Fixes (compared to v6.10.4-264-gb18fc76fca1a)

## Test result summary
total: 246703, pass: 216815, fail: 2082, skip: 27407, xfail: 399

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 127 passed, 2 failed
* arm64: 41 total, 40 passed, 1 failed
* i386: 28 total, 28 passed, 0 failed
* mips: 26 total, 24 passed, 2 failed
* parisc: 4 total, 3 passed, 1 failed
* powerpc: 36 total, 35 passed, 1 failed
* riscv: 19 total, 18 passed, 1 failed
* s390: 14 total, 12 passed, 2 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 6 passed, 1 failed
* x86_64: 33 total, 33 passed, 0 failed

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
* kselftest-timesync-off
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
