Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 530EA880D
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 10:41:42 +0000 (UTC)
Received: by mail-ua1-f48.google.com with SMTP id s25so431668uac.2
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 02:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KF8HfG3RuIXGDfw/y3jed8l0oAyCq6+DPWnERHKuQ8g=;
        b=SOqHQcvIfkgg27w1oUM9xr1hTOUXUIpNbFQUbmJJ9+6C5EcxCAPW4uUFd6kW+Eupup
         ZtJlU0yqrxo/DXzFHZN3ZYgHiEJgZMsgqbzOvpIvC73ACwfTuZ2JG5xEFRLBtOlgNNFN
         hgyanrQOePD9IaBgpyCFKSL7lqMeOiqzUOBGuanr++BMrhlmy9mLBbFV5SS2IKt4bzy6
         30lSvsa7iAQREGjnbnZ4FX5EZY+Ld/tGYhK4cls7d5W16LvzbQ1U5y6Pw7pNWmcoXg2P
         3lEYmY9E5aL8w/bGP+8MPdnBnPDvOMShfqDjmQ3p8Qmwum54M8aONqxxFh0SaiNR9OlT
         k1Mw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KF8HfG3RuIXGDfw/y3jed8l0oAyCq6+DPWnERHKuQ8g=;
        b=o4h1hFtVV6JS33OvTLw4SaBYK9lcbPbhS4+iLGqoKq1xVVxJMXNJnel41Iv7OLB2CJ
         RazxTL8+g0UBa+K+1I8pOOUQpSK7y1LS8ot/HafDkahaLu7jxuB8/8bPTPTVKBOyehEe
         ISJsrMH/2iwxJt1jzcMHjQ1LJMZFpwaBq7agGrRIFcKQQQZe2o1wnzv0dXu+lAjCfat+
         bRPkHnO44a3kYxSZgYM7YrrRsCWmUxVlq3dMwwRi8Ev4dF6cFHUSBvhY2BIfYmQnHxx0
         CzNcLiyOZP9plhcnxr5fH41C2s6uPUMPQNTa80OuDa/QalAMu4WIbe+XnPAqPITPQTT3
         FeCg==
X-Gm-Message-State: ANoB5pkjhEUwq6O4paQ7IdP/7BYwAaGFI1xbTG7wy5ofDrjKfWAlV3gc
	mejqywFR6zSwLM0t4fmdnTtE669aNIMGMXqFF4qqqQ==
X-Google-Smtp-Source: AA0mqf53GSAihWfsP/lAXw/j5vdjf3+ljgaW8kpLeXgeu0d03iYtepWtPR96CJmRmqv9ALqUNM7DThL7+7Zi35+nmBA=
X-Received: by 2002:ab0:77c1:0:b0:418:620e:6794 with SMTP id
 y1-20020ab077c1000000b00418620e6794mr57006657uar.59.1671187300971; Fri, 16
 Dec 2022 02:41:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221215172906.338769943@linuxfoundation.org>
In-Reply-To: <20221215172906.338769943@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 16 Dec 2022 16:11:30 +0530
Message-ID: <CA+G9fYuqrx3_FHU52EfQbo8xZyXNRmTFcX7kYf9iPu+TVB_U6A@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/14] 5.15.84-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 15 Dec 2022 at 23:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.84 release.
> There are 14 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.84-rc1.gz
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
* kernel: 5.15.84-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 1d22ad610255f0c61903c1e4fefce61227ec73b6
* git describe: v5.15.83-15-g1d22ad610255
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.83-15-g1d22ad610255

## Test Regressions (compared to v5.15.82-124-gd731c63c25d1)

## Metric Regressions (compared to v5.15.82-124-gd731c63c25d1)

## Test Fixes (compared to v5.15.82-124-gd731c63c25d1)

## Metric Fixes (compared to v5.15.82-124-gd731c63c25d1)


## Test result summary
total: 144723, pass: 125385, fail: 3089, skip: 15690, xfail: 559

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
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
* igt-gpu-tools
* kselftest-android
* kselftest-arm64
* kselftest-arm64/arm64.btitest.bti_c_func
* kselftest-arm64/arm64.btitest.bti_j_func
* kselftest-arm64/arm64.btitest.bti_jc_func
* kselftest-arm64/arm64.btitest.bti_none_func
* kselftest-arm64/arm64.btitest.nohint_func
* kselftest-arm64/arm64.btitest.paciasp_func
* kselftest-arm64/arm64.nobtitest.bti_c_func
* kselftest-arm64/arm64.nobtitest.bti_j_func
* kselftest-arm64/arm64.nobtitest.bti_jc_func
* kselftest-arm64/arm64.nobtitest.bti_none_func
* kselftest-arm64/arm64.nobtitest.nohint_func
* kselftest-arm64/arm64.nobtitest.paciasp_func
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
* lt[
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
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
