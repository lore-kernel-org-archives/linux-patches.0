Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8478A7B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 05:39:02 +0000 (UTC)
Received: by mail-ua1-f54.google.com with SMTP id p2so4972713uap.1
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 21:39:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678513141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=jtTOaJXJFIxTutKMBRL4Tmd6aYY6I5kNoGgR+eC6gcM=;
        b=MtrnFD+OzINsyL9aj8JIFAqmxRlf/ncpWk4E7LB+EQCsbSgIGuOf29LOddOJmk9JZT
         zFf1Hy7Y8DmZiKj5G4ysXMuOTnmd+CkRmOk0daT1wPJn2RCKrfpTRwf6kYmiSEWGDIGh
         hS9SNfq5clb555FiKGIXaRwzpjCAyA3ja+7X7DpAJpU2QLT4t50RnAQ72t6J8HrB8TQa
         yD05wDELaDKOa4D/bL+HX4uzRTZucRXAiGF/toeaaGu7v1fzex2WTy+RfZb5hO+t4gcv
         M7HUKbd6rbuSV6tD/HWCKcJz6WJopw6QzrhHk+KuJcd/PEka9A0EHU5ZDxUpOJYaFMQ4
         gnNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678513141;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jtTOaJXJFIxTutKMBRL4Tmd6aYY6I5kNoGgR+eC6gcM=;
        b=6ZRV79ZCMrr9BEYiU6bqiFbsPmi0u6iKB7HXmlFzjoTFhH4K2RSzQxI85HqoK8Y5XY
         r/tA0Rohkv7Z0wPdLu7SbgOuu2Jg6ygxZ/SocyAmI90yqjDIS5PZcJfUn0gxVxibikYA
         r78vIvoziEyu7Sm0F2lCWx5uEUvqk+gMy7NPH45K1W9rc6jRPJbOcfM6X12Yz7xaMd4F
         kop58p5MOQcBDlKc8kDqy8PBAU51AQJJa+0MSbLlFfYAWjWHjHELOSASDE/IfPmEjaJq
         mdDDlZDYbKjbZ9HDwrCZ6zzlxBOD4/yG64/rQJ4mvxyj6ehg7uZW70LwIkC6as75e42d
         dnBQ==
X-Gm-Message-State: AO0yUKV+rIywuphmoOB4Sj3VI3AvASvdVkY1serq2sppZRm7jdsexXll
	qcovDmfGR8N4dbcu14Hu1sa7YwNzdg4HvET/crOwqA==
X-Google-Smtp-Source: AK7set/klKpLMuSG0kNbXd8n+bIQNOmP9UmXF0n8L8A7cnrwqkAWU2LMwwMUBU5AWzbZdUiU78wH5+GWZeZiXBA01dE=
X-Received: by 2002:ab0:4a05:0:b0:68b:6325:4061 with SMTP id
 q5-20020ab04a05000000b0068b63254061mr19829618uae.0.1678513141165; Fri, 10 Mar
 2023 21:39:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230310133718.689332661@linuxfoundation.org>
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 11 Mar 2023 11:08:50 +0530
Message-ID: <CA+G9fYvq=xM8eKEhCDB0A_OCZq_rgw2OOLhGkpgvUaub0SE5PA@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/211] 6.2.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Mar 2023 at 19:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.2.4 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.2.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.2.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.2.4-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.2.y
* git commit: 54d58d14b95c4ebd0d562fb22a86a3696f6b8557
* git describe: v6.2.3-212-g54d58d14b95c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.2.y/build/v6.2.3=
-212-g54d58d14b95c

## Test Regressions (compared to v6.2.3)

## Metric Regressions (compared to v6.2.3)

## Test Fixes (compared to v6.2.3)

## Metric Fixes (compared to v6.2.3)

## Test result summary
total: 197897, pass: 169533, fail: 4900, skip: 23464, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 142 passed, 3 failed
* arm64: 54 total, 53 passed, 1 failed
* i386: 41 total, 38 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 26 total, 25 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 7 passed, 1 failed
* x86_64: 46 total, 46 passed, 0 failed

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
* ltp-math++
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* ltpa-6248579/0/tests/4_ltp-fsx
* network-basic-tests
* packetdrill
* perf
* rcutorture
* v4l2-compliance
* v4l2-complianciance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
