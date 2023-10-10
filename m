Received: from mail-oo1-f52.google.com (mail-oo1-f52.google.com [209.85.161.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1428124C82
	for <patches@lists.linux.dev>; Tue, 10 Oct 2023 15:04:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mYaW3lDw"
Received: by mail-oo1-f52.google.com with SMTP id 006d021491bc7-57ad95c555eso3124814eaf.3
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 08:04:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696950262; x=1697555062; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=0SAEbd0VwxslKJnxKMj+GJmEDHTq1sVdO9guwnutcFY=;
        b=mYaW3lDwmAjC0NpEJZ1LM22Zdv99InZHSCW05NTXnsyloeCOK4568WPCQYSH5asMo4
         9nJg1V6Jz8a0PEXgJzYd4decUNuEEKLtbfdtZP2ONUclE7tJTqlCllGxP5emIZT5XaDe
         HuMwR4STo/gJF0LV2DT/2YWttU2HyEImbdj6kkhRTGH3uL3uwy2wjQo2SSpSNL3ROTZF
         mpYOkBnlYamAWcFW+j2nuOoGW6ZnptKVRYmSp5msPwQcAT16c9d5m3mS7+boyOosxcwN
         64TWLDru8dL9nbJEpa5iDKqudytZwf6ylPitgIL6VvAQfcZLe7Bw1Yl8W9UaX4lfpkyK
         wtbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696950262; x=1697555062;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=0SAEbd0VwxslKJnxKMj+GJmEDHTq1sVdO9guwnutcFY=;
        b=bjHNxZx+/mGhkxg6iNj/HXPfaTm2L3GssFZdMdHA7KYpI6vlw6xoC9htjxFRZ578E6
         Wi4RCoaTIHT/vwEkfRoU7f5ZgsILxr3go5K32RShRKyrDnCh9mjqAUisvo+Gtai+LVpm
         6GySEWM3aOjJxyrFk4fmb2xDcfVbuxrd1+/cHMeukwfW0N0+zYW/DUIhMmvEFPOWVZ8b
         xE3ab4jnAgj/SNRLs358IiAkNIKxj0beA7U3PhaRkiINxYDR67kPYwKcB9Wa6sLsJ0Sj
         dM4v0Uf8KHqip1EeeCETrTAguGshhzOA3/2MYLJ3kPYZjF3fgpD18ItBLB445VmRVssK
         E/dg==
X-Gm-Message-State: AOJu0YxxnP0xYt4VXz1mhnCl/uxo4rHpnFyqRXi/GXEfWbDFIse/zFUI
	efjxPgyygvpwAzoInG+3K9C5nSJa9tKr39zuEADtQg==
X-Google-Smtp-Source: AGHT+IEEYpapbrwGyfoVUt6tiVqNaYx8L9UiAUIKvj+j36i41JVIjMX00ZBNaMkRfypAltACXf2zYmklGH7J+qRr878=
X-Received: by 2002:a05:6358:2906:b0:134:dc90:b7d1 with SMTP id
 y6-20020a056358290600b00134dc90b7d1mr22725552rwb.25.1696950261802; Tue, 10
 Oct 2023 08:04:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009130124.021290599@linuxfoundation.org>
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 10 Oct 2023 20:34:10 +0530
Message-ID: <CA+G9fYvXPjVW-kH11PHAyWcOWdJuXO6PF9uemvGqUVxrwBm3dQ@mail.gmail.com>
Subject: Re: [PATCH 6.5 000/163] 6.5.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Oct 2023 at 18:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.5.7 release.
> There are 163 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.5.7-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
Build warning on armv7,
net/mac80211/mlme.c: In function 'ieee80211_rx_mgmt_assoc_resp':
net/mac80211/mlme.c:5474:1: warning: the frame size of 1064 bytes is
larger than 1024 bytes [-Wframe-larger-than=3D]

## Build
* kernel: 6.5.7-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.5.y
* git commit: e640325b3c9a18f1de24daa332563620eb03309e
* git describe: v6.5.6-164-ge640325b3c9a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.5.y/build/v6.5.6=
-164-ge640325b3c9a

## Test Regressions (compared to v6.5.6)

## Metric Regressions (compared to v6.5.6)

## Test Fixes (compared to v6.5.6)

## Metric Fixes (compared to v6.5.6)

## Test result summary
total: 132702, pass: 113630, fail: 2151, skip: 16744, xfail: 177

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 141 total, 141 passed, 0 failed
* arm64: 52 total, 51 passed, 1 failed
* i386: 41 total, 41 passed, 0 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 37 total, 35 passed, 2 failed
* riscv: 26 total, 25 passed, 1 failed
* s390: 16 total, 13 passed, 3 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 46 passed, 0 failed

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
* perf
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
