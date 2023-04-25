Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E06817B
	for <patches@lists.linux.dev>; Tue, 25 Apr 2023 14:33:22 +0000 (UTC)
Received: by mail-ua1-f43.google.com with SMTP id a1e0cc1a2514c-7756904cbabso3958211241.3
        for <patches@lists.linux.dev>; Tue, 25 Apr 2023 07:33:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682433201; x=1685025201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WQ2CLAjMPgKbOZe4brMjde1QLHkIgbVunV88zomi5KY=;
        b=QSOxF8e2muGNZob7KuS75YfJBtMdxjOuLe46O21qktQ+fC1TxNejM/vKZelejgPkSJ
         Z2cQVvS8kWWMKlVg5wlM5bsl5FzNx6n4HkbqFHmC0BS6FeJq2zVuSMnIPOCqdApDolC8
         wrLd9RRJJapVfcfLySyGHOMmgG3TIGGmolWSzjlkSc1d63pgfiNQMRXc98EYnz/PlGgN
         oJXqqtCY+nm0Y8FaMWXxO4XGUose6KR2aaYWwfe6Jb3bub7G2BlvBn9GLWAmiiTuLvts
         osduTNr0RZZ7LksOlBptFLuAePl8noMgCOF653i/zNg8vCJFZP+WOsu0RBt0InLcYYH8
         xUFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682433201; x=1685025201;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WQ2CLAjMPgKbOZe4brMjde1QLHkIgbVunV88zomi5KY=;
        b=IGA6QYFaxA5cHf4/TV8hVkLmFs1hYk8UJhsNqv9pRgAzL2KPujvCFFM89UffziNQvm
         NyJ14Hn1i0c5RFEVBj/N5xkzNuqwNUaJhclIX2PvW5SAdpOb+YLPsSjbsghISuJ5nf/i
         Cma1xFyTQ8CoqdP9DGTebDcsxcT54OihmudR/kKF6YuFtE7VDleCBcIQ6wacOC5JmmZa
         /wqsc2RLUNCplmKWtxIbD0LdXqN0msZ6V8jpJC/4Vi8Ft+7CMyFl9JwvIXwYpiEKJtUV
         ZGuNnml5S1Ag/SgupR+JYEBLtuSLXrwtX0X4Ac3G8DM0F5vcQ9b3jtm/H5Hsf8WM9IOl
         TGEA==
X-Gm-Message-State: AAQBX9fjVDSv887OoU5EezTTDtg/xoNRXbnLcN3BZqZKk4YaXLuamkLx
	dZaZAtWkRetO435Qad/33dAM4PcnXpvGYBtCirLKhA==
X-Google-Smtp-Source: AKy350YX6AwO0pQHfBFGLNBOTtx5pYpGmcG+rrY+6QopEdOgUNUrMvxAJKNFhncmK2TEboB273ZjpmyipgS8gxjrLrU=
X-Received: by 2002:a1f:bd0f:0:b0:440:d7:da79 with SMTP id n15-20020a1fbd0f000000b0044000d7da79mr5766207vkf.2.1682433201450;
 Tue, 25 Apr 2023 07:33:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230424131133.829259077@linuxfoundation.org>
In-Reply-To: <20230424131133.829259077@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 25 Apr 2023 15:33:10 +0100
Message-ID: <CA+G9fYvc__9umKyeMWk1mmO6K6hfCt=MDt3BTHpr_XfJc4HXXA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/98] 6.1.26-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 24 Apr 2023 at 14:24, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.26 release.
> There are 98 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.26-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.26-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: e4ff6ff54dea67f94036a357201b0f9807405cc6
* git describe: v6.1.22-574-ge4ff6ff54dea
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.2=
2-574-ge4ff6ff54dea

## Test Regressions (compared to v6.1.22-475-g45df5d9a8cbd)

## Metric Regressions (compared to v6.1.22-475-g45df5d9a8cbd)

## Test Fixes (compared to v6.1.22-475-g45df5d9a8cbd)

## Metric Fixes (compared to v6.1.22-475-g45df5d9a8cbd)

## Test result summary
total: 155536, pass: 137480, fail: 4021, skip: 13697, xfail: 338

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 148 passed, 1 failed
* arm64: 52 total, 51 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 44 total, 44 passed, 0 failed

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
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* perf
* rcutorture
* timesync-off
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
