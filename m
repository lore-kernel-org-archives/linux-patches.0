Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7488723BD
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 06:42:27 +0000 (UTC)
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-791b8500a21so1454385241.2
        for <patches@lists.linux.dev>; Tue, 27 Jun 2023 23:42:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687934546; x=1690526546;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hOL4fhmYp/J1U14FeZJzgC75kK+fB1QnqyhzqYSaFWE=;
        b=XY9nHEru6zF0lgR2iL4UDAOvkrUra0jjx40BONLMk3ZOqQDjFdwmVIpd0ytJVbSyZL
         7pjoyq0dceWxPL5EAQ/9XjaYKD8ZNm/so9ePEIU6FUq2PuXI2tZFrnucGiih2yAMkMuk
         DPa4UmXwhU4/66mAF0nmzkMK2Nr63A9cnPL5kYejQzxtzmTdTzyx7aY6gjq67SQoOLLG
         dKcBkiuK3lWBzKuFSgPcwWZSuiG4IkZcj7DUR/9Nf9IBYhaVbJzKku94gmIVmU+8cbXY
         c8M/gm4e9g4q9wFdROIiLpXUeVADJO9jTnv4Vv+o/m+nHF941njiw0qdVLEn6UZ0+RFD
         z4WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687934546; x=1690526546;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hOL4fhmYp/J1U14FeZJzgC75kK+fB1QnqyhzqYSaFWE=;
        b=Q3Hn/Ehq5DEuIchHnI8WlgrvmthzSqEdmlbF+9Vv5yX6uibkv2oMiD335SoJ2KLQty
         ktkJp1j3Lxeqn36exrA42YRJptUupSwwac5tDTBOB+p+kwUoubI1flp9ZBZdWaXQSc2F
         s8osedEJ3enRAR19HuEDLIV8Ehq3aqb2IuYVtRbYYlp/F9FgE3F6ugmsi6fRByvX7Jye
         tsvzSRInpFlnKdXBuzNLhOrWDcbz0DjPuTHCUBl9e8OdFqvazWPom7CYF7BbYmMlLWAD
         ItZmqAeIffscHRAKmQzdFxWmmVFEDGkIu3V52FO0/LduZ7yEtk+PdjjFQZYla9qHwY8K
         louw==
X-Gm-Message-State: AC+VfDxtZnKFqrbq4dL2uSP3/3smTgTIH9nLLoylzwMHlyGx+l6UtdV5
	dcM+f/vZLr1DpZ5ZJLnTaBB71l/3aDAURg6o6eqOpw==
X-Google-Smtp-Source: ACHHUZ7A4S4HR26N/0nle94mISPwYAJezxHfyXA6h00XeHK22z59tuMAimzyRG3vETFa6AaudIHR/709SL3eA5vGSzc=
X-Received: by 2002:a05:6102:3c4:b0:440:afd7:cfe with SMTP id
 n4-20020a05610203c400b00440afd70cfemr3062445vsq.31.1687934546023; Tue, 27 Jun
 2023 23:42:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230626180746.943455203@linuxfoundation.org>
In-Reply-To: <20230626180746.943455203@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 28 Jun 2023 12:12:07 +0530
Message-ID: <CA+G9fYvcu1z5PUZfUx3VXgwSWrGpnUxgy+gxuUZwPzejpkDRSg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/96] 5.15.119-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 27 Jun 2023 at 00:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.119 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.119-rc1.gz
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
* kernel: 5.15.119-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 27883eb9b47ea94a1f340d622c1dbf8680cd90f3
* git describe: v5.15.118-97-g27883eb9b47e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.118-97-g27883eb9b47e

## Test Regressions (compared to v5.15.118)

## Metric Regressions (compared to v5.15.118)

## Test Fixes (compared to v5.15.118)

## Metric Fixes (compared to v5.15.118)

## Test result summary
total: 111617, pass: 86213, fail: 3043, skip: 22291, xfail: 70

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 116 passed, 1 failed
* arm64: 45 total, 43 passed, 2 failed
* i386: 35 total, 32 passed, 3 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 27 total, 26 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 36 passed, 2 failed

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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
