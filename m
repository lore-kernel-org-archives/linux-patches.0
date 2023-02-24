Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A86F539D
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 13:27:52 +0000 (UTC)
Received: by mail-vs1-f48.google.com with SMTP id o32so4097021vsv.12
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 05:27:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ht3Zl3ZeZf9aYs1rAv0eBFAKdSyPCi8FHnQJB2PH7a4=;
        b=q42TEXf32WjxpQYaZ+P2B/m7xXg3PhNpsXDHqqRDBJVt4oLOScq4Mq0mWbSErQAvOY
         ZN2eBQUbcKaIvX8p0Pcn63o/WTCMIFSCxfNigG+qtncT+KwLVEs6BpBdsFdFuphJB1Pf
         92N9M67hUUXGLbEGW0tWoRLNJ+H/ZWI/CiONWjTVQEQl/0lNL8AcStZsx9AhAaQWVuOl
         f7Pul1kjFp5lJ2Sy1YCNdy+BKmZQBx3GLgGGwBwVLVAcwiVmMSXl08xp+5vhbcXBy101
         gjShESLdUz+z+gOlFkKCQIrJX85ZfTtU11E8NLOXP0KxqQV3QMgW4R3q6j/pK9MZBVDo
         KhHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ht3Zl3ZeZf9aYs1rAv0eBFAKdSyPCi8FHnQJB2PH7a4=;
        b=n/vIpk1Rjfyd/1spyVVut70f/E4dTDd+/8SsSPndf5DwzJrrkPNKJIjsb5w59B3ahL
         6nUC9pUmtHYBizBe2+KxqNBpOdp/TqvDolZD8A2wFf+QRxHdrKtNRtQcij5A8TGuoxGg
         h4+g+I/x7JS5r8q42+RH7Oc5Ih0EMlZtsbAgoGGWu5Sk0RfgADjC1vafCoEMpGAlRcC0
         2lNm7RqJpF6iKySGL1VA7vjw6sVZd3ASgUn9z5PGS5y8gDOaMNxGQ+zswQeLyPDvBJnV
         XKBCdIdKD0LEawntSiAZepry06h1HJIDjs5GRybXCwNa07z/afWm2V9N4+SgaWjXQpYg
         /jaQ==
X-Gm-Message-State: AO0yUKU41PssES0Gb8bERLg6A8tHjfHno+Xnpr26qsMga+Sttl4TPx3n
	aTe5yrOOni8s6VqMHYnoku9vxa6nnO/3KuP2JQrAfA==
X-Google-Smtp-Source: AK7set+RvhMqiPUTtmN09JfHxAMoVYk1d0TWTJi3iZrKtWsN1At8RhCFG3vW/3R5ioz49sQafvf7WJy7UxAH0kpg7Sc=
X-Received: by 2002:a05:6122:e17:b0:401:8898:ea44 with SMTP id
 bk23-20020a0561220e1700b004018898ea44mr2344915vkb.3.1677245271310; Fri, 24
 Feb 2023 05:27:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230223130423.369876969@linuxfoundation.org>
In-Reply-To: <20230223130423.369876969@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 24 Feb 2023 18:57:40 +0530
Message-ID: <CA+G9fYsOV3vqKEkVKy-2FCzhM4S1d1HMHByHO_1kTSgsopy=gA@mail.gmail.com>
Subject: Re: [PATCH 4.14 0/7] 4.14.307-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 23 Feb 2023 at 18:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.307 release.
> There are 7 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 13:04:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.307-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.307-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 43b3a61e4368a7abc906689e505cbb1e198bd1cf
* git describe: v4.14.306-8-g43b3a61e4368
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.306-8-g43b3a61e4368

## Test Regressions (compared to v4.14.306)

## Metric Regressions (compared to v4.14.306)

## Test Fixes (compared to v4.14.306)

## Metric Fixes (compared to v4.14.306)

## Test result summary
total: 92685, pass: 79026, fail: 3518, skip: 9809, xfail: 332

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 228 total, 225 passed, 3 failed
* arm64: 42 total, 39 passed, 3 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 38 total, 37 passed, 1 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
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
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-firmware
* kselftest-fpu
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
* kselftest-vm
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
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
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
