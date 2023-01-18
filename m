Received: from mail-ua1-f43.google.com (mail-ua1-f43.google.com [209.85.222.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DF837B
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 08:54:42 +0000 (UTC)
Received: by mail-ua1-f43.google.com with SMTP id f26so8164692uab.2
        for <patches@lists.linux.dev>; Wed, 18 Jan 2023 00:54:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=49hVYpdfpGudyxPMxCrvPN1QUwNU0gvklZbqsfCUCE0=;
        b=MZvIz4ucU3ckbBoYyb8BHSztHdYfF/T1xOUu1DUJwso2pkiuOZ9WKT3l57A3A+BLVS
         np+t3nXZ8jvTIt3eDrkpglsgxVgpdwfyIS4zTEMzpEytvCCVF8Wv5NYLIXaze6GMPCS9
         MYcDnL0ttRjUdcBD+Px/1KIY6a7pveaN5qeSKBGSUuZ5tViGxlsOzRANMMeXisd+Ch+U
         MdyGvlHGraIECEzxgcIHSrW9Evfq3lcTOxSn5kF33OLUweKXvjFbv2SSP3k3cHxg11rZ
         mbEt+edQSeZukvlMHL77SnJBtxEb3mjK4LyDJhiCqWWf72zEo4OsRKZPRF/56ZYYcLFh
         x1gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=49hVYpdfpGudyxPMxCrvPN1QUwNU0gvklZbqsfCUCE0=;
        b=lc/nHtBQNXBD3PpSRPliV01++WgUhXGD+YhmsqztuI5jWjHDV8Y8/1eh5L5FqPF1KE
         fNQ7PCCPJ7l/4oac6CJbKMKvK9jDo1Z2/3LBfYMxN2YtOwBr8V3P2wPb/AAAy0Tq6j98
         /vOL9CQuNH7gUuPdC1825BvM47HaIdEOIGg5IXrv33YTMO+3GngRdG1C+THdf6g+gsFj
         Qi0cUyKqRcH3HnejcF9jCCIIcRNaf7fl2UzgnzlDZP35Dd3yhZir+O1RNl/fnIzwrE0h
         YHjE4eBqerekaKZ2kBl+G8hsfVnfGv6QL3DlyBnDcdzdXohHR1m0jaDAuXUWxZTwEgvs
         AguA==
X-Gm-Message-State: AFqh2kosh2KgX0FcZ/8NhFCmJI0B27BzLENg46CwH2nZ7Sb8SAl9p4wv
	rhdozeDZkP9dS17XOUjVQbqDLzEb4i3EIV118mPh3w==
X-Google-Smtp-Source: AMrXdXugKCqXvSeRnMwos6ZAe03rDqs6gyi4RAQrNJ/ogr4rbIIcW04mOaSGMLnhgth9bR1KUu84pU6rVNG0Hgd9XxY=
X-Received: by 2002:ab0:784f:0:b0:5a4:c264:fb05 with SMTP id
 y15-20020ab0784f000000b005a4c264fb05mr759518uaq.22.1674032081336; Wed, 18 Jan
 2023 00:54:41 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230117124546.116438951@linuxfoundation.org>
In-Reply-To: <20230117124546.116438951@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 18 Jan 2023 14:24:30 +0530
Message-ID: <CA+G9fYsbfzY1=5dZvdHfBqv5nX8wovpXVH2vb_Q1mo+jcTv0eA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/176] 6.1.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Jan 2023 at 18:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.7 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.7-rc2.gz
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
* kernel: 6.1.7-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 507f83506c2bc81502508bb12fc4970dec7b1746
* git describe: v6.1.5-194-g507f83506c2b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.5=
-194-g507f83506c2b

## Test Regressions (compared to v6.1.5-11-g5eedeabf82ee)

## Metric Regressions (compared to v6.1.5-11-g5eedeabf82ee)

## Test Fixes (compared to v6.1.5-11-g5eedeabf82ee)

## Metric Fixes (compared to v6.1.5-11-g5eedeabf82ee)

## Test result summary
total: 177864, pass: 147712, fail: 4982, skip: 25143, xfail: 27

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 144 passed, 3 failed
* arm64: 47 total, 47 passed, 0 failed
* i386: 35 total, 29 passed, 6 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 34 total, 30 passed, 4 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 40 total, 35 passed, 5 failed

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
* perf
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
