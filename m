Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E7023A3
	for <patches@lists.linux.dev>; Tue, 13 Dec 2022 06:36:26 +0000 (UTC)
Received: by mail-vs1-f42.google.com with SMTP id f189so13689666vsc.11
        for <patches@lists.linux.dev>; Mon, 12 Dec 2022 22:36:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KeterifymSwCmPpSLqh76Xayy2B+h/5saR4r3E1LaD0=;
        b=IY3jpVCGNtivPkaSoPq4jWZ3Yx4eDdNOFZJ2mfhPMP1yuo532UG3Uex0fb3uBUr00o
         81VkCpxNKywwMtJ0Rm5DG+2rQDXApkGDT1IKQ+VWMLHByR73N5TlVF0MehOFYl4UeSU4
         x3nAtGRLM3IV/7pN1U5PRqgnJM/M0brGexsExqksRVkFXtzOGww7Vcg7FAXjfs1zVAZu
         uC6L6cVRrd581Xm/KOw1M2bNuQuO+fQynWc/NBNmYLPzVrrMP/ViHpBvyvG1uDNSyBtz
         E7Yo30Xizr87k0fKIW6OFlshWckwyUaShMsLInpE7PP1o62ZdnaWsdwaRuC15yasLPhu
         S9pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KeterifymSwCmPpSLqh76Xayy2B+h/5saR4r3E1LaD0=;
        b=Dp0RHH4uW3xQEUW2Rm97OIPI1zGkw38Dj2iihJ3sWxqmOjaZdUgEbSkRb/8iWRCipY
         tqDbRtJeqTILJ4OEshjvyL2wLoAwETvsGTR7TUeygAdATio3XTW9FIvz6CcBT1iSltmV
         EAT/P8/xe1Pi4i8moQdkq6kdZzbFjc7Vufs3b5eKF9H/kA4fqRbBKBY/JVdeNRuw+aN8
         anG5E1Rc1wnRyva4lSxMy+Tv0nEOksJgJ3aJMR6dhTFQRRnzoeTQUf/NqGa73ALTcjqW
         kFiCWUzjeNy74y6pDdQqCCKJzFZywklFaHJUKpIW95u/yKzWsM89AqOwZNplNsiA7LMD
         x9rQ==
X-Gm-Message-State: ANoB5plZHUkkIjAZ1UGvwk6vqV8AJcgwS5rYII8eRak96C/+ClsZEsv/
	LX/EL9JK566fwCxfdqf4OxCmVCwKnTBeUSWzq2Mdeg==
X-Google-Smtp-Source: AA0mqf4suyhv32e0Uc+wUZX+kegi/XX5qz8tXQcqUKrvvxwt5yuMHdw4xPK9xU5fx3r0rZlhbFCBUq2fYjEWI2uN79A=
X-Received: by 2002:a05:6102:3590:b0:3aa:eee:5bc9 with SMTP id
 h16-20020a056102359000b003aa0eee5bc9mr43965928vsu.24.1670913385591; Mon, 12
 Dec 2022 22:36:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221212130934.337225088@linuxfoundation.org>
In-Reply-To: <20221212130934.337225088@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 13 Dec 2022 12:06:14 +0530
Message-ID: <CA+G9fYvoR-T=4tEFFGOB8wL2H5ioexa90LA6+-Nk+quhXbnq2g@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/157] 6.0.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Dec 2022 at 19:07, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.13 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Dec 2022 13:08:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.0.13-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.0.13-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.0.y
* git commit: 57dda3cf2efcfd145b35bbf58892b706b08c1d2a
* git describe: v6.0.12-158-g57dda3cf2efc
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.1=
2-158-g57dda3cf2efc

## Test Regressions (compared to v6.0.12)

## Metric Regressions (compared to v6.0.12)

## Test Fixes (compared to v6.0.12)

## Metric Fixes (compared to v6.0.12)

## Test result summary
total: 144720, pass: 126272, fail: 3392, skip: 14627, xfail: 429

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 146 passed, 5 failed
* arm64: 49 total, 48 passed, 1 failed
* i386: 39 total, 36 passed, 3 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 38 total, 32 passed, 6 failed
* riscv: 16 total, 16 passed, 0 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 36 passed, 6 failed

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
