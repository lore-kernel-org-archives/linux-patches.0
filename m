Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE7526FC7
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 20:36:50 +0000 (UTC)
Received: by mail-ua1-f52.google.com with SMTP id s23so8853168uae.5
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 13:36:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679344610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UNFVgDWAxfZd6z5ADUjqj4/aMzP9FIHByCOteARm1ys=;
        b=KJJe0UwWV4QjhRnYE3CvmlT41cgjiD0vT3se1oKJvN4UK2IT0GlQWgPJ4jIxUVhvRa
         ALXB2+YgHDcqMqsxlwFaEItFtN+Z+8xX6xvaPB2mpc1wO2LQ7nyC9YJo5f6Z49zDFllL
         v8KfaZbRJhn8gOLXJgmQvkWscG8C7bvsh8a/bvJ/C2El/gt0Djkk4ss2cUSYe5mxmOUv
         F1PAKctEzX7fBqzYNMp8CEMKWU0EniesstBn7m9HKUsFrVevHrBqPK0OznRXuRRaBFy3
         Gqj+x6d35S6ZahxK0U+BgN1E2+6R7k9htyFwAhwiamd3Z/e4Kpq5o5/nn4UrvrTCL6BC
         Patg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679344610;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UNFVgDWAxfZd6z5ADUjqj4/aMzP9FIHByCOteARm1ys=;
        b=gsQ6JGHWdugQGAx6ULhKrKs7s+UZhy85i9zjp9cuAc4vyyVkmee0k3i2AWame8Lrtx
         2iVAT+m2kQdwZ9sk5eBYII+fD+uUnz5DodpvTDxMUGBOf5DGkwM1X4H8HExo/qtc/nYo
         pRhd4I423Jo83CQ2hQCOilOe3tbDvG6ksKjzc4yDzS2gaL19csCKjNCikee7hKOYCvL4
         NNCtwkewK7v4mCBg/juSC+i0EecnuTVd1jjE3c93PuGAqLyMtaYEq05tPPuCg3qDzi6A
         CeG1fjpZxT5pwbzBubSRzJJWqRnsQcXNNFhPvL3C/CaCrBSGnRSrVJ1LdRdyqY2YGEEF
         ySQA==
X-Gm-Message-State: AO0yUKVvGcv8WLBrX21TVdhwofgxwrDP8vYAzek1gKnYfEtUbqFR22wN
	0Z88V+kxBy3w8hhTxPIPERClvp1+X1EonY4sJsJyQg==
X-Google-Smtp-Source: AK7set/zpLOC8SNehffSFXMB1rwH25iIiVTVu2SJzVZ6/uX6VEqNFaJqMpjlico03breMJc9bVk4nt0kfgZEhEaH4FE=
X-Received: by 2002:ab0:78c8:0:b0:68a:8f33:9567 with SMTP id
 e8-20020ab078c8000000b0068a8f339567mr5199591uau.2.1679344609565; Mon, 20 Mar
 2023 13:36:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230320145430.861072439@linuxfoundation.org>
In-Reply-To: <20230320145430.861072439@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 21 Mar 2023 02:06:38 +0530
Message-ID: <CA+G9fYv+NfAzwuzanTG9HLWRV4gYu72SsP3qjnYL+WbSxf0GEA@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/60] 5.4.238-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 20 Mar 2023 at 20:26, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.238 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Mar 2023 14:54:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.238-rc1.gz
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
* kernel: 5.4.238-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 1f8869b1deb887d66df4ca79b9e905f21ddfe1e0
* git describe: v5.4.237-61-g1f8869b1deb8
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
37-61-g1f8869b1deb8

## Test Regressions (compared to v5.4.237)

## Metric Regressions (compared to v5.4.237)

## Test Fixes (compared to v5.4.237)

## Metric Fixes (compared to v5.4.237)

## Test result summary
total: 92175, pass: 73460, fail: 2062, skip: 16591, xfail: 62

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 146 total, 145 passed, 1 failed
* arm64: 46 total, 42 passed, 4 failed
* i386: 28 total, 22 passed, 6 failed
* mips: 30 total, 29 passed, 1 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 33 total, 32 passed, 1 failed
* riscv: 15 total, 12 passed, 3 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 39 total, 37 passed, 2 failed

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
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-net-forwarding
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
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
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
* perf
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
