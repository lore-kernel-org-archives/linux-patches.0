Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A864423A7
	for <patches@lists.linux.dev>; Mon, 13 Mar 2023 09:12:10 +0000 (UTC)
Received: by mail-vs1-f41.google.com with SMTP id s1so10358488vsk.5
        for <patches@lists.linux.dev>; Mon, 13 Mar 2023 02:12:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678698729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KU+1KB/mSCK1kUVuZr3vnBGvCkC3xPMK1fQL4PyjNtw=;
        b=Mf7zvro85B2JVV2GNTga96Hd6rDAoQBS9ocSiV9VVOW1/OX52K1uCFY+hhzNVeZyqj
         iosrkqHsweFJKURbN34Ye5p72cvBlcwlb4LZS1H/GKQkEmdNIS5IQpnO6KHLM7vltVYx
         zLgDX8JrGl1NVDEYdaZHlOvNyNXz1kwkI8OkuPhqJat4VBCVUGqsIh2TRMH5eY60+phM
         dCtlfjsFSW2phvN8LVM4VMKLwoS9gAkaP8FHlsPeSMC+8+wgJFn1t8GTlNoLaq3gnkCE
         9DWtmmVwc+YdkNyHtaTScUmL9ofFe+s8WMO99gw0/Mpj7ecCrlxDPU/eWbLr6UF7rsFy
         ZYuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678698729;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KU+1KB/mSCK1kUVuZr3vnBGvCkC3xPMK1fQL4PyjNtw=;
        b=QJnISbDjp0xAwRu9vW1gWaGtroCFafYs0wAkYkZkxHqeow12UO+lIR+h2rZcWztbz4
         ex2BqmYuBcaf3C3CKtxNYXmqy8dLEfp9oMgr8ygnQmUeW/DcFRe/c5tdPiL8C7q8New3
         T1bvgHM3rqdA7PYOqCZGtOoc1DXkYVICHyCgak9bgihEapzJk81cfxtkkI2/BBZ9Wgk5
         ekljFlsa2BwvkiqHmVLF+uuijIKDjTSO1iCWYIu15pL8CVesAO1Hwds5DPXPv0euE0qC
         M+Ip1ckLA6Ktdvv6hlJwL3ZbuvHDgesJ4fX6qVgf/sR+27kHOMxhXQkHbgF2osHUtvBy
         vVXg==
X-Gm-Message-State: AO0yUKVVKSlQHMlVVaTOOmsK0ADkOKO/41uX/xnKb0ltXnsaXMXeWG2N
	a0cTIWxUAtzopBZtc6p/+z2P/euilrvXnWH50LCggg==
X-Google-Smtp-Source: AK7set9sRLVwl/2GQMYpXa42kVrD6n3JiglTX4kX9rxJegaEdvikrn6bASplGJ6qr0dIN05z6gkwJ4ZnhLqRm6RMvwE=
X-Received: by 2002:a05:6102:3679:b0:425:8923:d34a with SMTP id
 bg25-20020a056102367900b004258923d34amr1379060vsb.3.1678698729336; Mon, 13
 Mar 2023 02:12:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230311092102.206109890@linuxfoundation.org>
In-Reply-To: <20230311092102.206109890@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 13 Mar 2023 14:41:58 +0530
Message-ID: <CA+G9fYsxuiRQbZRVWexx+WboeHs7OAgiNz62d18_36-r9F-cPg@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/192] 4.14.308-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 11 Mar 2023 at 15:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.308 release.
> There are 192 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 13 Mar 2023 09:20:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.308-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.308-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 2326e906147b0f87bfaf7f0655b2a8282b93314d
* git describe: v4.14.307-193-g2326e906147b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.307-193-g2326e906147b

## Test Regressions (compared to v4.14.307)

## Metric Regressions (compared to v4.14.307)

## Test Fixes (compared to v4.14.307)

## Metric Fixes (compared to v4.14.307)

## Test result summary
total: 84985, pass: 71620, fail: 3674, skip: 9328, xfail: 363

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 199 total, 197 passed, 2 failed
* arm64: 37 total, 35 passed, 2 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 34 total, 33 passed, 1 failed

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
