Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C453110D
	for <patches@lists.linux.dev>; Tue, 21 Feb 2023 07:09:41 +0000 (UTC)
Received: by mail-vk1-f174.google.com with SMTP id o14so2283486vkf.12
        for <patches@lists.linux.dev>; Mon, 20 Feb 2023 23:09:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1676963380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hscTzN5z8vrwaxFCI2AwVnHdibSXNak1jNv30h0DF0M=;
        b=L3TayzkPFSd6FRAdKDo2fVYOHdhqA3sTljvEDI2pSceMmvPspKyDHzmuQIWvn50DQJ
         WiKGKfRrYXPcreSOOzPs5b9F5sMeF0NyJV4526AHHN8njksAcoQKVll60g/x4QmLgrnR
         g6Imw34SMEm29QAPG/xLoOXY+HdFb01fNGgEJdukgxbjxu4USnsp6FP0tXlGAXZpNdN9
         5TUAFcnc1Z+xurL4UGPKAHDPuDW6N6BzHnCEWNXCK3sEnaU+3eaOFUj+H7UDQbqI3l5v
         86QMrDpgIRU1P/X3AtgpcZQQUTf/2uuHP0qnH5Csr4xQLJEMTbYTgFzqZj3iCl6lzzJi
         rJZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1676963380;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hscTzN5z8vrwaxFCI2AwVnHdibSXNak1jNv30h0DF0M=;
        b=v4QfKSoC6E/GFXa+HH1bAyh7Hi8f2iRqF1RBujGdMgTZ416aFf0QtFgEa0fcWNelPm
         nsWalJP8VrrMLWzf2oGcVXo597ma8E2cy68PHQmjVJrEorqxflkelqySyWSG0TV+D8hA
         WFd4XKInDN2mG/uJ/GvP9wssVGbucKKX91RvBHk6ma+yDP59otdOqw3SdorHqhj1wRTs
         6OhTu31opg4VYpXsksfqhQKlMAulO1S8lvcotscVZb45BZ/nZBO7ZdpjE+LpcoO+bICn
         CEZ3iopmpq6BNEnpx1konVe+8XP2zyLUCThCG8hKqI1C42kFz3w+0RgaGKmYDcvgpQ/2
         tgeA==
X-Gm-Message-State: AO0yUKVeqQaHZVxWUj08cXxaIWkLLXB3Z07WEGzUAE6w7zWrSnPCm26e
	3fspLw2VrF1xEjiQE7qnY9cjQYAzqCBn6T6zkxqCJg==
X-Google-Smtp-Source: AK7set/yyK2Bn0QuazJFmrgddEhbFT3efIywKuQmJ9a9uOWNyfUJd+HAEDQAOzn5iKLRbvlwT/WBycTLATI+WVzqO6k=
X-Received: by 2002:a1f:2305:0:b0:40e:eec8:6523 with SMTP id
 j5-20020a1f2305000000b0040eeec86523mr294673vkj.43.1676963379771; Mon, 20 Feb
 2023 23:09:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230220133553.669025851@linuxfoundation.org>
In-Reply-To: <20230220133553.669025851@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 21 Feb 2023 12:39:28 +0530
Message-ID: <CA+G9fYvczFS5Leb0wt-Bu089XxQ3GdZSjVcPQA5WXOCFnWMPGw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/83] 5.15.95-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Feb 2023 at 19:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.95 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.95-rc1.gz
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
* kernel: 5.15.95-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 76543d843499bc53e1360720c61967de1d3e0ef0
* git describe: v5.15.94-84-g76543d843499
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.94-84-g76543d843499

## Test Regressions (compared to v5.15.90-205-g5605d15db022)

## Metric Regressions (compared to v5.15.90-205-g5605d15db022)

## Test Fixes (compared to v5.15.90-205-g5605d15db022)

## Metric Fixes (compared to v5.15.90-205-g5605d15db022)

## Test result summary
total: 157706, pass: 133248, fail: 4182, skip: 19944, xfail: 332

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 49 total, 47 passed, 2 failed
* i386: 39 total, 35 passed, 4 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 34 total, 32 passed, 2 failed
* riscv: 14 total, 14 passed, 0 failed
* s390: 16 total, 14 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

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
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-c
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
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
