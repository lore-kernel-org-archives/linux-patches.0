Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B891FBA57
	for <patches@lists.linux.dev>; Thu, 21 Dec 2023 06:48:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QKXEcNLn"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-7cad628ad93so166581241.3
        for <patches@lists.linux.dev>; Wed, 20 Dec 2023 22:48:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703141295; x=1703746095; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=k9jf/aWqzdVJic9dbSLeO77joE90wgpTQub1AqUEogI=;
        b=QKXEcNLnsUqRBd55CVxh8Mt6VHXjrDXbHcgSzBs41a2KA35PqT7WuR3N3fKU9pPuVp
         g2rJ2C07Zux9u6VsH1DB7Rj6cDi5wObWL/76knSQXUDkNhMEDYzyD8JtQ/VrDCU8Jwfz
         KsA2ULg8tJp6PTGCfTtF2HgmDArYEIorsyng91TtGJ1FvIcDtKPsIMm/762BrD6ZMrpc
         Z4LMUSSmcF3b6Y7cvYa0soL9Sl8PuIuMTOR7Q39n2/g0/Ebjjluwvh46bR/vdMQw6PKf
         Mgx/7rLoK1nzpsdF6dBwef8KB+iHQBhcXJ8cyXV9zvwN7/J72IIi42dx3fWRXIyl5HfY
         qPiQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703141295; x=1703746095;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=k9jf/aWqzdVJic9dbSLeO77joE90wgpTQub1AqUEogI=;
        b=IVGfsuTvrJFY9r0SVpTxZDPMT1+hq8yt1kc2ScdngqDI+nQxszSZdVtwHQSpUDEnCR
         uQot2Dp9qkgrFLJr7WpflO5umoFHIcJOwJ3K4O3mVo0hDAIAS6pt9JQeZV6pLTsZ6Ben
         ywHUkwxkj+aRtGDU4COXuTpfK7uWP3EosHNAZd192XwoM0r0eEwGWecvE5+96YzTlUcp
         j68GCNASzeEmhFxyke+NmSTeBwgq3llYd+8YoEbLkZZuncnVdPGjFzM9jkrHvUs7mldE
         5emtzHjxPCPok7TaGwugUGggsc94fJLnPzuy/mp7Xc3cvdMgaFTqO34z2/JcooPxI0Jd
         /pjw==
X-Gm-Message-State: AOJu0YzcdvLICmFPonKPtbFyGfAzyfrXQghY64WdgUk4CArbsjUvG4LF
	u0YlE6UfaODKNENsHxzGfO9Fok9OEDfD+Q1U5s0qDg==
X-Google-Smtp-Source: AGHT+IFoWkrT/yDYvY4Qu03ZI2dU6KyzH1f4HZG2nOJgTQs8/I065FWXXf13xD5wfMNEhFPN23L/irFowbzJSsBT0Vk=
X-Received: by 2002:a05:6122:4d0a:b0:4b6:c8ef:dd74 with SMTP id
 fi10-20020a0561224d0a00b004b6c8efdd74mr626733vkb.11.1703141295537; Wed, 20
 Dec 2023 22:48:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231220160931.251686445@linuxfoundation.org>
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 21 Dec 2023 12:18:04 +0530
Message-ID: <CA+G9fYtPr644KJ1168ndODXY+mtXa0kv3W-8Q4QS4n8PxJV4kQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/159] 5.15.145-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 20 Dec 2023 at 21:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.145 release.
> There are 159 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 22 Dec 2023 16:08:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.145-rc1.gz
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
* kernel: 5.15.145-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: e7911feb56b718aa3149a2665b7c83a18b46efa7
* git describe: v5.15.143-243-ge7911feb56b7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.143-243-ge7911feb56b7

## Test Regressions (compared to v5.15.143)

## Metric Regressions (compared to v5.15.143)

## Test Fixes (compared to v5.15.143)

## Metric Fixes (compared to v5.15.143)

## Test result summary
total: 97654, pass: 77080, fail: 2684, skip: 17826, xfail: 64

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
