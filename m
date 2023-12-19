Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C652A1BDD4
	for <patches@lists.linux.dev>; Tue, 19 Dec 2023 07:00:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gYezERNe"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-466912ccda7so324906137.1
        for <patches@lists.linux.dev>; Mon, 18 Dec 2023 23:00:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1702969207; x=1703574007; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kOUJhlFP9EaawWtLZl5DOPkALIS3+etxDpqWFBR6+io=;
        b=gYezERNeTHAGbaKcsevN9Yid14+yCgs8xDwygfYIvtEXAnylEfYV+BGb47Q1Z9aHze
         yMN2afttCuKCoaOXdQ7gO1OCvXCWVGL3do2g8u0SnMWicIeGHFKzQ+ftk4e75Uxkn0c1
         czqtILdkNzE0KNIsiT/xMNG1vRg7VOfnt9o3IvN0U0uCs1XMVCwwzMDgNgNlocabrDcl
         WX+Jf6IyLayiyN8vZ9+hggt/gbeLaA0jTs2JG6BNhzAOLleKg3PKMHQvse5EUBniT3ev
         vc+kWxmmJdu+ACitwrqzozLw67EhqaLQKG5ltSbsehMtwTEQRRZyx+aMgg6nqACaLnM0
         3rJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1702969207; x=1703574007;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kOUJhlFP9EaawWtLZl5DOPkALIS3+etxDpqWFBR6+io=;
        b=DhaTK5qpGG3UYwIq7Gc9o/jOEJUTu89Cvbo2LIbyJ4i0gHS3qOrtHAOZmPTt9Erw6n
         GXSAoF09+lRE+Osp/d9+pZlTKwTY7iAvGn1sX0jbi+v8iiZyDSjqDyGO7nJ20+7SdXh/
         rQtZRIH8JroDFq5fPqNu1qcOK2zvDXGhJUKbScgoPBsgKe/Qqp3heKuAkK7JQBT+aaGe
         nDLdinXQYP0P3aqO18RxIK46miOGeeZE74Z3ApJsvZlSJ/iGAKmCOmskaC/Or599yi5H
         MPpw1Ppom7+RR1vwkMsfni3h+SdQODo9AK/MxjYQA6GG+iIBZefQUj34UBnJv5lQIxSn
         esow==
X-Gm-Message-State: AOJu0Yyz3EmMT5JJZ5r4n3eFaOUaAXIgmOVK7g3zpnfEa//KcbMGlWHl
	PwLIBIiaXoR+JbCfT9y371zncXo41pyP0Zxox/ibzw==
X-Google-Smtp-Source: AGHT+IFfbPj7SPepsBpIjki2G9lQd18pfZb7JvctGhfz5/6qSbQOM13nOcqVcS0wfmyDqKgrsmQcO2JI23xT6z72Ifc=
X-Received: by 2002:a05:6102:3054:b0:464:627a:55d2 with SMTP id
 w20-20020a056102305400b00464627a55d2mr13783870vsa.18.1702969207503; Mon, 18
 Dec 2023 23:00:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231218135104.927894164@linuxfoundation.org>
In-Reply-To: <20231218135104.927894164@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 19 Dec 2023 12:29:56 +0530
Message-ID: <CA+G9fYvfaTJWhu_Y7u59Xbaed_mQ0UNOSMkS7_F2-yWfojsqeA@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/166] 6.6.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Dec 2023 at 19:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.8 release.
> There are 166 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Dec 2023 13:50:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.8-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.8-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: aa90f2b75bff896df265802383a62bf4ed79b0f8
* git describe: v6.6.7-167-gaa90f2b75bff
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.7=
-167-gaa90f2b75bff

## Test Regressions (compared to v6.6.7)

## Metric Regressions (compared to v6.6.7)

## Test Fixes (compared to v6.6.7)

## Metric Fixes (compared to v6.6.7)

## Test result summary
total: 152532, pass: 130905, fail: 2449, skip: 19047, xfail: 131

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 141 total, 141 passed, 0 failed
* arm64: 49 total, 47 passed, 2 failed
* i386: 37 total, 37 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 22 total, 22 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 42 total, 42 passed, 0 failed

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

--
Linaro LKFT
https://lkft.linaro.org
