Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E12511CB0
	for <patches@lists.linux.dev>; Thu, 15 Feb 2024 08:12:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707984780; cv=none; b=EnlNmg4U3uccsxc+9Wl6nXWWvJ/pwdClf+JMGOZ3BdNkZamgkZjdAGiJLK8br0lvQanM6lfXCcWjKBKFl+dN5OAsuGKof0BeEW4aC3wARV/bNoqZLmxeXm5bMEPOVA58U+CnevANBOsUpGVv+gC1U8vAK8cVQATJ78waX/wfUv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707984780; c=relaxed/simple;
	bh=ZTAJV3dEKK7k8+c25CFdJVFPjs6+EE7snEv93W4xwV0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=It0JD63WC4CsRwAh3ESCxtYja2vOK9xSxaBpoExeF1toTIo62pKOn2lqjjKUWkAKmGdhPBtF0/wJ/Q3L/PrV07WkhDSVoysjLyxcuX4tpVvXmVZDeFVKh+yv8tNvcCf3o1VL8St8FzyDhdANjfwS4A2Egkr0GhEOJ5jai1ZDDPs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=TVN9PNkm; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="TVN9PNkm"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-7d698a8d93cso390074241.3
        for <patches@lists.linux.dev>; Thu, 15 Feb 2024 00:12:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1707984777; x=1708589577; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QNNRvQOusE5Z+tHDdzjn/Ee+CdNyz8HD1C3jxuK3A7k=;
        b=TVN9PNkmf++jf6wkNk4EhVPpAk4JnJWCZa4zg/f3VCKur8b37wYwE5S00xw/OefXiT
         wmnwWI9caZV7OsBG6D7Y9CSC3G/ZxgZ0crK3h/M5wmAs9l99REfdduZSoMjO4Yt6iYHL
         yc/5HXUvb2dn+alhivfAzK0beVZ9sfK6dDmbI25cl4aAJyjrxAXHoa9SSuv614iRCxZa
         mx40KjB42JGyt11eqfYchp6cqRuqe87RZPP8m7TMUNN2Bh6ubPaCqDuRgVcbfRILfuWb
         LOsbxJTcMFcERL4f9mk3l+1TXe95PckYMVTkceksM9V+f4yCLeGpcXk/LIkMKsX16xnf
         ExDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707984777; x=1708589577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QNNRvQOusE5Z+tHDdzjn/Ee+CdNyz8HD1C3jxuK3A7k=;
        b=Zzp6T7U/I7nkcGaRBpRqoy/98zEPcJltylAYfJFS0TKDNp2FbuMsLGb6tfvVgmKXbn
         6HFG7kt8agl21tPaRYkyk93bTJS8f8mje6MNtXRz+yekQlNZvhz/IieH+qbbqqyJRWUU
         49oxrJjzOjFGlK3q+benNy9GfA6FyIFqcnfCDuhuN8CvfajISe/noup8E7NBbla1qGmg
         hlGobzy8vDeR1AvD3ZU48O5V6Ano2yE8VxkM2RJ9vE7oLYF5qNUIOFdcAziYFDRZYAeK
         aappaaSg9ItJ8kpijLtqXxiK0mtDwEQRAC8JhHx7KxJ5c/yqhJ+NWVTCzFA97+O/ANgT
         +ExQ==
X-Forwarded-Encrypted: i=1; AJvYcCUJcHNpKn7YELu0H1NvF2UtLlLsHPjKlpivpw6o56qDGd93cZGKtSI7m8YgOb3Bo+fk2CRlYzjxeniQK/KFIIp0eroexKXE4w==
X-Gm-Message-State: AOJu0YwrTdoaYywYEMHcnxcKuuv2dtMizgRLbE8zEID7k1r4BNDdW+2q
	f73FbE1lhD9OfHBz7zBtSwR0aoioACDLHlzTXiZ6C8mqAoEJ86XDE35UnF75k+JbkQz/ummWnZ1
	G9+IEJwGQOFYiRHxZLEvDGB39TfZu4/j5Klgt+w==
X-Google-Smtp-Source: AGHT+IEGMGKH79Agy5UR76AZr8PpIb0hqMSr4WbtBt/A+r4PVlbkfW10erNDPMZKy0vcEHd42wkF7g4WyGfwLHuw3KA=
X-Received: by 2002:a1f:df04:0:b0:4c0:240b:89de with SMTP id
 w4-20020a1fdf04000000b004c0240b89demr826711vkg.7.1707984776789; Thu, 15 Feb
 2024 00:12:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240214142247.920076071@linuxfoundation.org>
In-Reply-To: <20240214142247.920076071@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 15 Feb 2024 13:42:45 +0530
Message-ID: <CA+G9fYtX7793mL+xHy5uZCh=mZi8McY9ATh_-HnDWC_Wobpd7g@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/124] 6.6.17-rc2 review
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
> This is the start of the stable review cycle for the 6.6.17 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 16 Feb 2024 14:22:24 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.17-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.17-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: 36bb9c22c8b6e6fd34fd6fff147c78bc62a08fa2
* git describe: v6.6.16-125-g36bb9c22c8b6
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
6-125-g36bb9c22c8b6

## Test Regressions (compared to v6.6.16)

## Metric Regressions (compared to v6.6.16)

## Test Fixes (compared to v6.6.16)

## Metric Fixes (compared to v6.6.16)

## Test result summary
total: 157567, pass: 135762, fail: 2290, skip: 19341, xfail: 174

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 146 passed, 1 failed
* arm64: 54 total, 52 passed, 2 failed
* i386: 43 total, 42 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 34 passed, 2 failed
* riscv: 18 total, 18 passed, 0 failed
* s390: 13 total, 13 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 48 total, 46 passed, 2 failed

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
* libhugetlbfs
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
