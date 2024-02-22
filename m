Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7441512E1CF
	for <patches@lists.linux.dev>; Thu, 22 Feb 2024 13:08:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708607297; cv=none; b=iRKDcvJH6h/mWIRz2zza/Lp+QOLXXbur53HtFmt2Bbu2WfhqV8U87fLnKuT2uZZgiJl81b9Iagl00rnAIt96GW+qItBogFhlaPLzEH2Al43RKlSM7MhjYBX8xLLLo2WgmElIRRY6ZUUO/j1lGHcOUQgrlv9RIChLcEK6b334OEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708607297; c=relaxed/simple;
	bh=vBe2rH/5htWt8B1WCymGolQ5n51GQAmyO04V+UUcP04=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GF9KYFnzgPoFL6RSsbHIr86iUvnwdzYZbH5H3rL7vMuQZSqlif2bXrrR/9l0bB39GcupYGgsss+b13tgeEsVY+n2qMhHgYzHQDNIPmP7EiBLwzRQ7c8nVsh3zl09GBiNfcHlpzQkdmk86+vsjDqUQPWGiqypj55+xmTrEnQjnfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=iDQXi30z; arc=none smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="iDQXi30z"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-3bbbc6b4ed1so5707655b6e.2
        for <patches@lists.linux.dev>; Thu, 22 Feb 2024 05:08:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1708607294; x=1709212094; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q+/BhM9vk6uEEXg8M1FymefQ3xt758ktK2LzbdwL1LM=;
        b=iDQXi30zmcVNuRfhqkgGqRvIQ3D+GCr0NM8laxAcJkx+ADnSMpu5bhsBuhDywx+Xfb
         jrh4NMELfykjMW2ur+3b1YA82BOr8CHndojYh+HEHmtA6KbRAWjnKTGZz5HXACHoqj4v
         xtzIybokKAX7hD+rX4xUPgt62Drend03IS8cbHtZgp5Is7ftYe55iksOqKZ1aHgS1Ov+
         6x2nV0ge3AUYmrMBtzHvZszZS+on2g94aS2nRh9TbP3w8fS+hl2R+SAq+JRJJZ7YEf9V
         oLGFfav6yZ+DFbz4uLWMX6xmYlDj5lgM1Drap6NGylyxIP7Xp/pefbhXLrYML8z/28cn
         Asmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1708607294; x=1709212094;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Q+/BhM9vk6uEEXg8M1FymefQ3xt758ktK2LzbdwL1LM=;
        b=fRvlkMfeOJQQjpVkHV+iQiHS7ZBw0/iRkdCP79UanT1W1PYM4Wno8O/TQbpQaH1xYA
         3isUlFDQ0bqZvyHt6QttpWo/qQJBviiR/MI6etLD1/bmdf7jMeP+VsWlhiHedKAa1lFQ
         SNFoGcj59Gic3ieeAHF8TdqLZgFiIBII3JFqGvZ5DofZJYnXjzaiW+SBr8FSpi3Htll4
         hdzF4CV2rSXhT4a5Xr5elthFJidm/4pQdwukJqW2vZy3jFfADo/Jqq90uOHd+K4zGf3F
         7e10TS631A3N/J3mYZ/kNLFEACx26/oayX0ItwBsTK45lweOcymFwcrddriI0C7iF7i4
         zbIA==
X-Forwarded-Encrypted: i=1; AJvYcCVw+HF+rSk6rGui/mbswT73io7A62ooPLDn9D3tVuSk9TpYFWRInJBvpyA78MpW1DUIrM2BUp6tGBmDyXdm2t9jPbo68HJL8Q==
X-Gm-Message-State: AOJu0Yw+60ZVka+5oFFsLoxKXzDTSzB/HxGsYWeNMsVSVplBtDaDZMoI
	olHy9c5duSeohnP+Z9Hzx0/YYn+2ZyKevPp/FXUUa0nM33SXvmMby67cEygormjPWNobzSkTDeG
	NBwTklrzig49MZLQiAJ4+AUGoOmpnPt0rqqtSQg==
X-Google-Smtp-Source: AGHT+IGcaRd6sE0wNTf5brwqh6uEfsgcd2adqk5HR7foXa4cbi/H4XKc5uZpDYOBl5AnAeJDIwb0k8wasAhdoeEBCOU=
X-Received: by 2002:a05:6808:1642:b0:3be:d38b:9cf1 with SMTP id
 az2-20020a056808164200b003bed38b9cf1mr26437127oib.35.1708607294524; Thu, 22
 Feb 2024 05:08:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240221130223.073542172@linuxfoundation.org>
In-Reply-To: <20240221130223.073542172@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 22 Feb 2024 18:38:02 +0530
Message-ID: <CA+G9fYuprTkbvETPN5_r3TnJrKz_1Zq2WsVY4V0eYw3GH-OUpw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/206] 6.1.79-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 21 Feb 2024 at 18:33, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.79 release.
> There are 206 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 23 Feb 2024 13:01:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.79-rc2.gz
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
* kernel: 6.1.79-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 64fdfe5f1a1d3801ddf7c85d510f9531f4d2f6b7
* git describe: v6.1.77-274-g64fdfe5f1a1d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.7=
7-274-g64fdfe5f1a1d

## Test Regressions (compared to v6.1.77)

## Metric Regressions (compared to v6.1.77)

## Test Fixes (compared to v6.1.77)

## Metric Fixes (compared to v6.1.77)

## Test result summary
total: 144068, pass: 123402, fail: 2349, skip: 18165, xfail: 152

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 151 passed, 0 failed
* arm64: 51 total, 51 passed, 0 failed
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
