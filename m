Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E24C37B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 07:26:07 +0000 (UTC)
Received: by mail-ua1-f49.google.com with SMTP id i22so593709uat.8
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:26:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678519567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=M/SU9KXz28yYtXWuLaqhgFaPmS02wHA+in6Lz/rDrPw=;
        b=pUFvUEZU1CIEKCF7HVOGu+/AQTCIsfxxhvCRSBmDepf+LHH3bDw05HpUjJ+AzxOs2s
         VcQfFe3EL7fcCCCt+b79BuIrbSeUuWSp19UXwtomvUVOlGEpOz/WijtU87Qmdu/u6TOW
         pkDsLWqqFawl1dvLiKXq+Qm77qFThTQ4gAs3gt9KvnEU8BPQcMcQxThRCjm/RreiKzBt
         s6B/2OjRIIemSWhnJumv3eYn6MT1ao4a4LVRzW8968nHvtzEgiSZqbokVQZU/wS6Qemo
         MxD0//YDn8aQAVeLCE4E2ISIFftgeD+r7u1m64cTjkZlZc2eye8azmh1vcpLcHlo+7az
         dsWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678519567;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=M/SU9KXz28yYtXWuLaqhgFaPmS02wHA+in6Lz/rDrPw=;
        b=aLLOnILD9cLhTjTpWHsaVXcN1VwhjGz7WoInEFpVB3Wx3v1ydKW1PV0lOCgeN1e6+o
         yaf0Q4pgTZgEotvZRAIv4TP5hOiwee0e26NVY6ZyAZLGtbGYQsbiYhkcuFp3HCsioIoX
         gGVRR0XrZPc5jI+iQpHHpIYxk2ziE/J/m1Asm82dSBymISYT4zlW0FzSAcbU0UQMCYkG
         8pHe6NTR2iO+Frd2AVA9hoqIWXIzqn8hsI0lTshkfICXblz65FSI4faTtDwg0QWypGkT
         z2uKwMrYKrUJPBrS5IpKSeAFXRCv5xjqusExjBC7ApJqO/NEsuWhgD5F2DyvTt4eqMWY
         RAtg==
X-Gm-Message-State: AO0yUKWcbKSc48nTYlzdOwyWLAo4AvNAlCYirZCtT02P05Dq8ABT96W+
	xgeNQWJ6N/Gt0ckGl7Sv+4gpnuZ7KyaSc4cD05dxXw==
X-Google-Smtp-Source: AK7set9wZXev+nm4e9+wm7LFHDw0bPVI3Sr5I5hpMA1Tr//IJ5EDiirQZEiwdrkR43R69XAxFOWloyEo9B6pDwHJr00=
X-Received: by 2002:a1f:4542:0:b0:401:1c83:fba3 with SMTP id
 s63-20020a1f4542000000b004011c83fba3mr17674290vka.3.1678519566631; Fri, 10
 Mar 2023 23:26:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230310133710.926811681@linuxfoundation.org>
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 11 Mar 2023 12:55:55 +0530
Message-ID: <CA+G9fYuyMYnzNLgvyQwjnnVY4=QjOK6kKoTJ_guJ+z0LDn5uMA@mail.gmail.com>
Subject: Re: [PATCH 4.14 000/193] 4.14.308-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Mar 2023 at 19:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.308 release.
> There are 193 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.308-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.

As others reported, s390 builds regressions are noticed.

* s390, build failed
  - gcc-8-defconfig-fe40093d

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.308-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 6eaf98b65d621aefe9304aeb2903e2e16e7e376e
* git describe: v4.14.307-194-g6eaf98b65d62
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.307-194-g6eaf98b65d62

## Test Regressions (compared to v4.14.307)
* s390, build
  - gcc-8-defconfig-fe40093d

## Metric Regressions (compared to v4.14.307)

## Test Fixes (compared to v4.14.307)

## Metric Fixes (compared to v4.14.307)

## Test result summary
total: 55304, pass: 48088, fail: 1943, skip: 5214, xfail: 59

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 199 total, 197 passed, 2 failed
* arm64: 37 total, 35 passed, 2 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 10 passed, 5 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 34 total, 33 passed, 1 failed

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
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
