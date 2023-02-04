Received: from mail-vs1-f54.google.com (mail-vs1-f54.google.com [209.85.217.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7917F
	for <patches@lists.linux.dev>; Sat,  4 Feb 2023 09:23:48 +0000 (UTC)
Received: by mail-vs1-f54.google.com with SMTP id i185so7806568vsc.6
        for <patches@lists.linux.dev>; Sat, 04 Feb 2023 01:23:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2qxQKnFdDTEipPcBjjZtDPjnsBu4NfXLJ3jbdZ2tJa4=;
        b=UROIpV3EeNYZTers/6+itS+eA4JtdqJGIPT3WjrU8yXWFWwCJDo6FX69dOkyUVsFri
         AnJDKmlOiF6Cd5ytYq29l2TrYCJWib9pOy4+q44wQfsPaMGhaYfqjoELah9KpgKGBv0g
         hXpdyvx4U2hwHWca0SLjG9uA/iwZfDNuFU+HWGaeljj1OGHdMrtZNDqYeDZHP0fz5Z7y
         OaMC43lg8/Kv8vZnkWB3yj1EINdyagKrk7ic3OibkBeFmg0ibrXmKliiPnscAa1JAvBg
         28bK9TZCH4TQElz9COS5cyrHgb+EGfr+kuZv/BVzptYHBOzXOmwBC/Waz7QaEhHtueI6
         1sNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2qxQKnFdDTEipPcBjjZtDPjnsBu4NfXLJ3jbdZ2tJa4=;
        b=VJhsXUEcCIt4koWFiiTObJCZyTU9cPPictekOlXp9/HdaB9EJZYdBUMGNL11uMWUjq
         vye/cXDdwOFWW6emIHHnyKA/LRFi07wwSXT6NcwjDcPlT853/EVpzxyV+2pGy10hSmFP
         R6+loStELT+kqXjZwUOghRc3CRpdCyqvdT8sAbGtffRd42upvf134qFS7lLt7W+p3Z2K
         AQqOfnfoaWXlplDAi2aLcaG90c1+gSsyJtGv/iu3d398NGAxNbfXUw8TtevLxdU7GSfI
         scjTO2G/swBHIT2ImyEC102/GXfuvTM7TAHrDWNneu3zylM3FOqD1iY/WpyVp+cwTUZ9
         1AFA==
X-Gm-Message-State: AO0yUKX2yfM9T3RUGXnXy2zyES5MNkdTIVVBATZk6GFiKSlwI/mS3Vsr
	XjWS8Dnv1+M8qth3yIyJSTUpFwTswnrGhF6B3QcDoA==
X-Google-Smtp-Source: AK7set9lduUtYHpqSpnRYUtt7osEpq2E003ppU9ZT+qaVPkVjjOSvpyUpVIGB9kmKLVetVYSNCnbxpK3MOviy9LxTPQ=
X-Received: by 2002:a67:a603:0:b0:3ed:7a8f:d181 with SMTP id
 p3-20020a67a603000000b003ed7a8fd181mr2075172vse.3.1675502627229; Sat, 04 Feb
 2023 01:23:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230203170324.096985239@linuxfoundation.org>
In-Reply-To: <20230203170324.096985239@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 4 Feb 2023 14:53:36 +0530
Message-ID: <CA+G9fYvjf4aPDD522KdrzQYWP4iPfwnu1WjZXCxdL+vFgP2f1Q@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/79] 4.19.272-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 3 Feb 2023 at 22:35, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.272 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 05 Feb 2023 17:03:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.272-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.272-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 825071b614ee8a296893d14c863cdb97f5031c51
* git describe: v4.19.271-80-g825071b614ee
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.271-80-g825071b614ee

## Test Regressions (compared to v4.19.271)

## Metric Regressions (compared to v4.19.271)

## Test Fixes (compared to v4.19.271)

## Metric Fixes (compared to v4.19.271)

## Test result summary
total: 111113, pass: 84177, fail: 3254, skip: 23348, xfail: 334

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 321 total, 317 passed, 4 failed
* arm64: 59 total, 58 passed, 1 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 46 total, 46 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 53 total, 52 passed, 1 failed

## Test suites summary
* boot
* fwts
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
