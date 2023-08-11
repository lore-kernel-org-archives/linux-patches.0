Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 438AC5675
	for <patches@lists.linux.dev>; Fri, 11 Aug 2023 06:55:30 +0000 (UTC)
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-79d8edd6d99so577910241.3
        for <patches@lists.linux.dev>; Thu, 10 Aug 2023 23:55:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1691736929; x=1692341729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3jl9p+KNxoqOn1WZcsfVA9kXOhluoQxx4pHOLUhZQLg=;
        b=G+fDLAD15tJ3QtHYpj//HUHvjje/vA3uAVCJVl7Gg+6Kk3xfTFVMN/FlTArL5rDeYj
         kbXxsf/7mA6P4FBSp5CUACs9sn9beuPHlkoetLUr1HPiYaW/7oa9i0YV4O6Cm3u/q8Nj
         lWIJG3Y1u/29qJcVlG+c5vl8Wweapt19GEeUgDLelL8/RHJzvFzwbA40sfOlxYAsqNYV
         4UuPLQrj0NkgmIjpdPyuEZdUbpuJKszm2vg3Rz/NNWrG93x9CkodE5OuaQySuRrv77/I
         OXfdx9L1q08jxjg+mkEVBXQGScu81iJMBhZlo6G1KiVl0DVWNlq6r3FQ5fB+3Gc7gTJ+
         CETg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691736929; x=1692341729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3jl9p+KNxoqOn1WZcsfVA9kXOhluoQxx4pHOLUhZQLg=;
        b=ltCIr3qrbTZ90rNytdoU7HY/q+rC7d4k9bqnVCHupFptem+8kQm7KTP9SkfufA3b7q
         ceVVGZuIo6Dcacx5MV+1Pcrwbsx4q/yc+Q6Q6VS4xaJ1MzsDXjesoJyzv60hgDP2N5rg
         zeKR3mAOZ06IyW1ThTW+/fj15ANdwrMt8bzBaa39d6nh4py1KY2ZymfRZ0G9VnWvLDXd
         TR1kkbsycCCQABi5xkCi43Q/2C9KsHBcsCrBY5y6vg16G1g758JekUrof5RK/Sx/Nxbk
         KDaExHQU2vTs3UBRKrzTailnCVqpVLR4FYXOwDNMAVR4eEXLD05RFbiCb0BwFTfTY6A7
         vMog==
X-Gm-Message-State: AOJu0Yx9wmsICUtj1XQ2/WIm7kerWeBqCAG5zAwz4kMCRFhGTVHJitBi
	x9LkLMLPlIGUpHN2DTlmVXRHRIh9pseXOcpkVXthDw==
X-Google-Smtp-Source: AGHT+IGgeT53zPrfyNp7tkWuSpmapHMuynAiAUznmB1FH7SdPvqcyy26XjxPJ+StldAlMA1MJxb31zTkoxB9UCHukmU=
X-Received: by 2002:a05:6102:a93:b0:447:8f16:4c71 with SMTP id
 n19-20020a0561020a9300b004478f164c71mr856897vsg.21.1691736928901; Thu, 10 Aug
 2023 23:55:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230809103636.887175326@linuxfoundation.org>
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 11 Aug 2023 12:25:17 +0530
Message-ID: <CA+G9fYtpZ307=fdiHuYF6OZo0eQbzG_t_ynGfk1gdPkFVMem3A@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/154] 5.4.253-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 9 Aug 2023 at 16:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.253 release.
> There are 154 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Aug 2023 10:36:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.253-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.253-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: b4a2489fa8b7c1e8a1c012020dc7bf2eeaaf5325
* git describe: v5.4.252-155-gb4a2489fa8b7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
52-155-gb4a2489fa8b7

## Test Regressions (compared to v5.4.252)

## Metric Regressions (compared to v5.4.252)

## Test Fixes (compared to v5.4.252)

## Metric Fixes (compared to v5.4.252)

## Test result summary
total: 125061, pass: 100749, fail: 2463, skip: 21758, xfail: 91

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 148 total, 147 passed, 1 failed
* arm64: 48 total, 46 passed, 2 failed
* i386: 30 total, 24 passed, 6 failed
* mips: 30 total, 29 passed, 1 failed
* parisc: 4 total, 0 passed, 4 failed
* powerpc: 33 total, 32 passed, 1 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

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
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timens
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kunit
* kvm-unit-tests
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
