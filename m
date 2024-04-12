Received: from mail-yw1-f177.google.com (mail-yw1-f177.google.com [209.85.128.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2B269979
	for <patches@lists.linux.dev>; Fri, 12 Apr 2024 14:35:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712932503; cv=none; b=a+g3Xvmsu/BhCbDRYw+rC9whybaWHKbW4ZLBJ8EXxMNWkAgjMePAJRAq4Ms69dQFRhupapiR5Gkm2Lo3zXuiiVAZ8qzSUfojJmfhNTEX5qbVsivXngdHNJv+oZiBH3Q9d1HqLEBPl/wRdOt9kVXwMwleKVzciO4q1p/c/3DMcuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712932503; c=relaxed/simple;
	bh=wUBzQHUwt6/ntRQQFcRF8kQGAiGeZ3n4cxtkIT5qrtA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=K4m91GU0SDwp8y8Icqj+/ggq8WdwPXmmcIoz0/1Muc8/H6cbYGPvqTp4j7dJkbkn9w9UNwCOOP/I8kLKdo/w7Kmv1BY1J/LBCkVLQ6m8wm9ZgvBoZM+/Imp5vzKfgN17Df5ENN3GI8CEGVfFu/MkYpl3L4m1yTEER2YD7BfGo7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WZajn/VJ; arc=none smtp.client-ip=209.85.128.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WZajn/VJ"
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-618769020bcso9964047b3.3
        for <patches@lists.linux.dev>; Fri, 12 Apr 2024 07:35:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1712932500; x=1713537300; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SgOXnMStIHN46Kz0NUk8tixwh+qg++oHVyRP48CyUG0=;
        b=WZajn/VJVdy1WrWozoMgAJvPaimEG4whiU4Uouoau8yPXYaOGMdqozXQ9QyEWLufrd
         0SKWsMfPxiimtq3lHMXoq+Cmi4qCYLOMx6ZciG4tvtkDV8TD8Xh9po3EDb75i9r/HK0S
         15BZ5aeMhzTKCtj2AGhC9TL2KoNdQ3Ry3yEwMZvCVRojJle+zKxH818uK0y2ZJG5/4yt
         5xDpnIz+u46VjJBPsdgjZYfMnp8QwzJ+THeP6MoD0YG+NT3cuBxFhDGLCRBWcymgqBDb
         KIIRR5t8YA30EvpLQ82wkC44L6WoTlvmJx3Vm/PmJEufim+B483zHxq9gG/sg9JO92Xj
         GnZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712932500; x=1713537300;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SgOXnMStIHN46Kz0NUk8tixwh+qg++oHVyRP48CyUG0=;
        b=W30cShSa+hcVo+s804cWsMW8Zi2GnTOJoHff2N8BqsS0cSM6qaPMjbT6cBBCLuqdVd
         4SZ62tKpDEb4/+XQCXM2wXjOnOTfyqGzrF/Vf4JANZiGZlxRV2np3saCMrmZGDCk0Fn0
         1Rv1DASHF5gl8siEcfdEwfIJfvOmos8kF34xKHWlWm3sNMFBGEaH4D3epLpTOzNmNj3f
         O5qY3c0iKEYy1FSHY4UAsapVUy8zp6QC2aXzQEr3Ktc1FvPlro5mTzsjtcCgKIfagGiC
         1bfzmneK0TEaKispgy0MczcFzcOdLm7xaLplbXyebXE0EYBcDJ38Nw1Q6qyBG58G25l5
         iOUQ==
X-Forwarded-Encrypted: i=1; AJvYcCUPZ0Hz2fQ4QIRJSlIoxYS/ubQlzsi+zajy3zVganY1bZSBTsnBJ/7uy1msiThcSgMqg0HlU2uMN7jOObWAnxtiNvSIMdf2RA==
X-Gm-Message-State: AOJu0YxKjMq9jEVoFKNUptFrTibKRH3vToWsS+K0nrrXCPlf4cnFunM5
	sqynyghhBSYxE4cGrrq6RVHOrod1EzBSTNT9jzqNrjE8i+7fdzLYPkuj/x723Lqldi7oLuLEhNv
	QnlF7CZwtK6w02EwowsZRpzKPEwkOXlRagEBmaQ==
X-Google-Smtp-Source: AGHT+IGWgdpQEtJQGF8ZxvJHuaPU/CK4HM747qSvcp3vgE/92uXTsfu0SYh79YYQKRBfOo0jZ7dzfc9EO8OSYl+Z2go=
X-Received: by 2002:a0d:cbcf:0:b0:617:c543:35b3 with SMTP id
 n198-20020a0dcbcf000000b00617c54335b3mr2720478ywd.20.1712932500628; Fri, 12
 Apr 2024 07:35:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240411095416.853744210@linuxfoundation.org>
In-Reply-To: <20240411095416.853744210@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 12 Apr 2024 20:04:48 +0530
Message-ID: <CA+G9fYtSkL2ru64oDqd8FSDrDSe8sjWSF__S2usLq3nhricOpQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/114] 6.6.27-rc1 review
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

On Thu, 11 Apr 2024 at 15:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.27 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 13 Apr 2024 09:53:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.27-rc1.gz
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
* kernel: 6.6.27-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: 3126167a036c76b2c9a53d19f7387cdcaf2ffd19
* git describe: v6.6.26-115-g3126167a036c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.2=
6-115-g3126167a036c

## Test Regressions (compared to v6.6.26)

## Metric Regressions (compared to v6.6.26)

## Test Fixes (compared to v6.6.26)

## Metric Fixes (compared to v6.6.26)

## Test result summary
total: 242107, pass: 209368, fail: 2761, skip: 29712, xfail: 266

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 33 total, 32 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 19 total, 19 passed, 0 failed
* s390: 13 total, 13 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 37 total, 35 passed, 2 failed

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
