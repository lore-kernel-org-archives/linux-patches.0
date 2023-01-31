Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E750808
	for <patches@lists.linux.dev>; Tue, 31 Jan 2023 09:45:24 +0000 (UTC)
Received: by mail-ua1-f46.google.com with SMTP id q19so2816685uac.10
        for <patches@lists.linux.dev>; Tue, 31 Jan 2023 01:45:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=3iVwQ6OE7I/ZpBzOfnMMeG4GgdbN3q4VGBz+KufgsBA=;
        b=IBcfJ9TYShiDcDsVsc5wbFq8KvDYb+Gpnp3FKEbuwRyqlEWqaHOKL4k0GEZw88VVUc
         e+b6/pmmlFa+P3d1Fk9O+9QG3hfztRsmWRt0RKu+VBLr71H9HkvKmrlSXz/2omPPAJve
         JE9cXHpn5D0fC73lWA6fzu334HEU22QFLI9OKbuN1SzEWEzrUZt7LWovikmwhOhfh1SZ
         5p5+rcQ/+flmXkPB/7dIAuoQ7t9Qpl5q/gfuio4xn3Um8gxpydIWbrTCalrma28vl0D5
         6NAqTvoGPb4+Cv7dBhlxhTro5yPaEDiWo/SmxF1CO3g5VJEN1vRsWo5ajAkxu+rS3koG
         oeEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=3iVwQ6OE7I/ZpBzOfnMMeG4GgdbN3q4VGBz+KufgsBA=;
        b=13AcOQMF7j73HvU4Om9hnUOy3qfzOAOq+i75DiU34iMqYCkVJhi4pRqXmt5XnLiaXH
         Nq6Ag3xxH7eV3Pvj7xKj3Ckvk24lFkooG8He6WwJS6/QUDruByMx66dPIrBjda61+1BF
         x/ENCO/nuiteaReAFLVCQZAa4/k83V+0caja7BH+5zB4HTqs9AiL7LY5Z4vFqUFL6mCf
         qfNCqKcQ9IiIoTF3y77fgNn7N+ysLIQkBHqC9OGIQub9nB9z1cmb6aXdy3M8qVryp+2T
         ao6G1r52XwNNzr8GX4t9BKCHIL7jOoWJHLEj+/gTXNo9QzcXaCaVQ2/haulB2bPKP3NJ
         2m0w==
X-Gm-Message-State: AFqh2koCWWCQZ9ATNZFc+a9iQEJIWkB+thG5OMLJnrRkY2PMLQaK6SvE
	XqoUHoc3p1UaP/X2Cpge+Dvqmb/B3yaGALzMpHvaBg==
X-Google-Smtp-Source: AMrXdXuGWo/seGO07O9e25GfBiJrqx0QHSq8MH8+pXYsFFt1Gvp7d5VBGq3efWEznQ+YPMxSvdkz2EpEuoaDZJJaIQ0=
X-Received: by 2002:ab0:274a:0:b0:63d:5ab4:6c66 with SMTP id
 c10-20020ab0274a000000b0063d5ab46c66mr4832432uap.25.1675158323289; Tue, 31
 Jan 2023 01:45:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230130134306.862721518@linuxfoundation.org>
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 31 Jan 2023 15:15:12 +0530
Message-ID: <CA+G9fYtYXAeOv9SXb0B9LxxpLU30Td-xUVZF5jpvTfwhu0JQnQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/143] 5.10.166-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 30 Jan 2023 at 19:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.166 release.
> There are 143 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 01 Feb 2023 13:42:39 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.166-rc1.gz
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
* kernel: 5.10.166-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 930bc29c79c40d957f1ec23eba4fc9abec745eb5
* git describe: v5.10.165-144-g930bc29c79c4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.165-144-g930bc29c79c4

## Test Regressions (compared to v5.10.165)

## Metric Regressions (compared to v5.10.165)

## Test Fixes (compared to v5.10.165)

## Metric Fixes (compared to v5.10.165)

## Test result summary
total: 152407, pass: 125784, fail: 3629, skip: 22665, xfail: 329

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 150 passed, 1 failed
* arm64: 49 total, 46 passed, 3 failed
* i386: 39 total, 37 passed, 2 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 32 total, 25 passed, 7 failed
* riscv: 16 total, 14 passed, 2 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
