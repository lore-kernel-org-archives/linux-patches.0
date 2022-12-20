Received: from mail-vs1-f52.google.com (mail-vs1-f52.google.com [209.85.217.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A8B184C
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 06:58:11 +0000 (UTC)
Received: by mail-vs1-f52.google.com with SMTP id k11so10966424vsr.4
        for <patches@lists.linux.dev>; Mon, 19 Dec 2022 22:58:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6MavG/BSQqfihoP4/TEaeDzAmuIP/BPU7laq0dLUyiQ=;
        b=GsBIWFnT67ZXpkQFI41zO7pdeNulIK0cVZLpWDYskvgqyrQdpmlEdzr2EKpEtXwSj3
         gZqRHTZwWTQbhlCkmIhEmVdLUEtkhNcdvFOBsph1AMsAE773QmNpBLAUY/QE4+u1gYUb
         T96CUBgYX58tl0FY64tMUEWU58vkayPCkgP6vsI1kgoFzZlsgFlhhkZZywdeYv53Wq/Y
         MWyVNxU3jsdI67qhujEhlerm6M4/V0Vhbk+gzclM2FKthDTLBn/godyJJcEP5V+Tcn69
         YPkKUfgxjeaA0oHkn2D3jjfPLmHHfTGX/TDaz8WlB+m7Y/HfXEwYcLgw63XsoQmyo1XG
         LVOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6MavG/BSQqfihoP4/TEaeDzAmuIP/BPU7laq0dLUyiQ=;
        b=Nh0T6bzwePRQWM+PuA38/PAFziWIm49HBXZLdu1laJjwyfE3wCUA10iKq8/ASW8CmM
         4VxeMBqmob5ATZORhjr+M7gNFbp8KBhTfmgc3dbC0J/7thBkHZmyRyfNLPsdMCxA3nJM
         YboaLLzWUczLp5xSaWrkjDcKIbw7O/wyXoUc1ZKjlNQdfmzqU2oOYvBqy/xDdvsGColO
         Uq/VdPBBzTfAA1NUpuP5WQCBGLhqPTfap1OmVpKivz+4MpyYY1TPX+wmk9mY7IBYsKYM
         FBYBRo/bkzz8/s7TaZHFpp444pqRukZ2qW58sNBkMQbvPchaJs6I2s+NezymuZR/I3TN
         iyaQ==
X-Gm-Message-State: ANoB5plRKq91XjAmhHmP+q57pxLt9Sm/1fvu8L62owfqmr7VndrMikvY
	axCl7RyTD0BMp3L0KcTqv/rpLXG9smJ9gmoq1XOLuQ==
X-Google-Smtp-Source: AA0mqf60OEcAqwDC44GHkHjuifLu/BTy8qOiOSkp6A3Th2X7AaA7e/B5gMVBtzfUeCtjXgGkusTs4hIXFPxTNRnwWA8=
X-Received: by 2002:a05:6102:3ca1:b0:3b5:d38:9d4 with SMTP id
 c33-20020a0561023ca100b003b50d3809d4mr3899571vsv.9.1671519490093; Mon, 19 Dec
 2022 22:58:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221219182940.701087296@linuxfoundation.org>
In-Reply-To: <20221219182940.701087296@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 20 Dec 2022 12:27:59 +0530
Message-ID: <CA+G9fYvCfYJF_7XXt+JGb+yZsjM21bmWQd4yO44gKqp7stfP1A@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/18] 5.10.161-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 20 Dec 2022 at 00:58, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.161 release.
> There are 18 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.161-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.161-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: bc32b2c55e20a98b04c9ccb34c50e4fbd7f2b8cd
* git describe: v5.10.160-19-gbc32b2c55e20
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.160-19-gbc32b2c55e20

## Test Regressions (compared to v5.10.160)

## Metric Regressions (compared to v5.10.160)

## Test Fixes (compared to v5.10.160)

## Metric Fixes (compared to v5.10.160)

## Test result summary
total: 120764, pass: 105386, fail: 2229, skip: 12725, xfail: 424

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 146 passed, 1 failed
* arm64: 45 total, 43 passed, 2 failed
* i386: 35 total, 33 passed, 2 failed
* mips: 27 total, 24 passed, 3 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 28 total, 23 passed, 5 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 38 total, 36 passed, 2 failed

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
