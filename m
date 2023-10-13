Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A6DA219F5
	for <patches@lists.linux.dev>; Fri, 13 Oct 2023 16:53:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AwUEghV1"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-457c2e44f20so395511137.1
        for <patches@lists.linux.dev>; Fri, 13 Oct 2023 09:53:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697216038; x=1697820838; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UenrsX5MbwRjyqhnHRV6P//x8KJwOJVev+tfBEoM2w8=;
        b=AwUEghV1BiEGqKtgHLhBZAVVHX6pCvGkLNi/UV5pW/gGTAsfjlqeC148x1pIQ25ERP
         pPzWRqnh8j0KK4JHb3qHBzsZgRTdETdHtH5hLj8y4Jzr7TMz8yFFPf7CJf/G/UDmleh9
         JuWVHTyiuJeiYNWY1dmDvh5Xec6zLw+knSVO6oshzKoM5qHta7HlJYYlK4+mkkdb1Lck
         FYAm6E/Yrs3Ie1UrOL0e3bhOoUuZne2ievQ0zdqXTY/8ZOOWnsHVHNgej6Z+FvoBnkn7
         jJyOPqOoae2RcmX52RRJTzltwulf/HE8TF/rCp1RQfbS+/ahvX8ck2peLslQlSdNgVwG
         kjcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697216038; x=1697820838;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UenrsX5MbwRjyqhnHRV6P//x8KJwOJVev+tfBEoM2w8=;
        b=ct2kN2c0NpEv+T2/V6y1MyUgXaBq0MIAUS01CWatAMj1IFjJxYtEoAIgwZWvoRHTXc
         e1QuxvsU3ZuUVrdpDg1Ep2HulDDlbVDK46ocPcE9bxdDEXbMA171qfb+btImI+tfYGio
         7C3Y86QQ8MigyxISNypBa+19KN0fB/WnTPEVajYfNDIb3gm9Ceq8w5AW13j4sKv3gqkn
         IItUQU5yUCh22YO9zQQq0H2BNnHGsuTxxyAaRlf4HtZqRTFCz7jhJ4hF0gAdR4X0YwZC
         WMPaKaQRVRpkf2C+MBrgGB2x3hRUfyaGwHygFveZemKeDpdNjhCzvXMamVStqq7wtXLc
         BEKg==
X-Gm-Message-State: AOJu0Yw5Ts0eGkLOrI6DbhHyXCtrHCnU4BOOtxUWH9kJuOENPYQnsdga
	SNE5SCpqXU7NaLIBG7w3qt0MTVfZ1L8aTJp7TmJCPA==
X-Google-Smtp-Source: AGHT+IGunW9nkr39/HMSnnqsy3zHfTPQi/WNUhGsD3vAyos6IbZ6NpeB21zhi0TQaHG1JoYaVVDh8N0ewI1x40B2jsE=
X-Received: by 2002:a67:e3ab:0:b0:452:5798:64bd with SMTP id
 j11-20020a67e3ab000000b00452579864bdmr21175205vsm.35.1697216038158; Fri, 13
 Oct 2023 09:53:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231012180030.112560642@linuxfoundation.org>
In-Reply-To: <20231012180030.112560642@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 13 Oct 2023 22:23:46 +0530
Message-ID: <CA+G9fYvB290Nt666yUC_CJi7_hfbfkFvpwhowtd9zawg41EYVg@mail.gmail.com>
Subject: Re: [PATCH 6.1 0/6] 6.1.58-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, LTP List <ltp@lists.linux.it>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Oct 2023 at 23:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.58 release.
> There are 6 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Oct 2023 18:00:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.58-rc1.gz
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

NOTE:
Following LTP dio and hugetlb test cases are back to PASS status.

Fixes compared with last release.
* bcm2711-rpi-4-b, ltp-dio
  - dio01
  - dio02
  - dio03
  - dio05
  - dio06
  - dio07
  - dio08
  - dio09
  - dio11

* bcm2711-rpi-4-b, ltp-hugetlb
  - hugemmap11


## Build
* kernel: 6.1.58-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 3fe61dd155ac48d1642f5cac17bd41a92ef585b7
* git describe: v6.1.57-7-g3fe61dd155ac
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.5=
7-7-g3fe61dd155ac

## Test Regressions (compared to v6.1.57)

## Metric Regressions (compared to v6.1.57)

## Test Fixes (compared to v6.1.57)
* bcm2711-rpi-4-b, ltp-dio
  - dio01
  - dio02
  - dio03
  - dio05
  - dio06
  - dio07
  - dio08
  - dio09
  - dio11

* bcm2711-rpi-4-b, ltp-hugetlb
  - hugemmap11

## Metric Fixes (compared to v6.1.57)

## Test result summary
total: 114725, pass: 97010, fail: 2320, skip: 15240, xfail: 155

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 149 total, 149 passed, 0 failed
* arm64: 53 total, 52 passed, 1 failed
* i386: 41 total, 39 passed, 2 failed
* mips: 29 total, 27 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 38 total, 36 passed, 2 failed
* riscv: 16 total, 15 passed, 1 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 46 passed, 0 failed

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
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
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
* v4l2-complianciance

--
Linaro LKFT
https://lkft.linaro.org
