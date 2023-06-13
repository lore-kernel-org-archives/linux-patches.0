Received: from mail-qk1-f181.google.com (mail-qk1-f181.google.com [209.85.222.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C5582915
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 09:38:07 +0000 (UTC)
Received: by mail-qk1-f181.google.com with SMTP id af79cd13be357-75ec6ae7ffaso66990585a.2
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 02:38:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686649086; x=1689241086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SCPI/baR/1VYFN9iIgC64H+gWSsqCVgPPgVley52h74=;
        b=C5P9Bazs8hgLVml0ldFwiQHTY0Zr28EaLT0/7WczQeBtdBGcekr4SAsNC1plsu6ZO7
         Jb5J9zrFIOXDqnNbH/EIqiguftis77A65Uk20swL9A11NbZo2DuGNnZ8duwUzA0TVw/l
         EfkFkU9oB+N3wVo+fnkrzRSMkMZk3+75aDm4RDIEHyjgkKoBqgSaBt2otUdCfUVrclgm
         Pw/OG6Jfx3deB5H+pJzhFzuYeBi97W9G9eoIjzl46gQIZNZgwMnw/krUuJqmf5nM7zJ7
         0+2OwYEWw6vQrglOxVa0KoCj6jzDaj5sbq0kpoOw2+FbT4ZI/FsaJtTmPF0JNUjvbICP
         1M/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686649086; x=1689241086;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=SCPI/baR/1VYFN9iIgC64H+gWSsqCVgPPgVley52h74=;
        b=L4Ov6B7pNeRXsyC3fIJeG6r+db/Tfl78DisWY4hXwZUf6BTGnGraVddjkAo11/2PFL
         mDkU7nc8VnTwtx+tQlqK69U3hPBqsFp0hukbuce0zxYzyHnIRd1o5FQ0wiJvjng09DEF
         iYVynbo/yszNCEfF/CzFG38mAFnzhY6AAOny/wABj0vbD+XBaAKijsZFBp7mrn5iJf+0
         JG6D0BdCmDpnOXH+BC1mp7zQP2uNIvDztGqRB4vqMHt5MghBBH61lxzU+DSa7soGuuYy
         BRRtRvOYaCbyReoI83PsIBC3kEEYEolfsTz0tC2VUBmGsVxIePTwcAdpbgMTE+BhNaO0
         gWrQ==
X-Gm-Message-State: AC+VfDznubkFc4sjUU/TX8fDFNB4JrstlQ34GhHT3uI2BCRW3hRGPn7j
	V2koc1AcCxUrXq/7f0OHhnrjOxCtXxdhrv3HLJURcg==
X-Google-Smtp-Source: ACHHUZ7BsgwAIuWzY3ZkmN7LhmIvOa/f0yfQNee1bpK6kzqRGQ/b+LXQE/Ih9ohA8bQZ1kQI+kuhxKMp79U55nODkiU=
X-Received: by 2002:a05:620a:20c3:b0:75b:23a1:8e35 with SMTP id
 f3-20020a05620a20c300b0075b23a18e35mr10969418qka.6.1686649086154; Tue, 13 Jun
 2023 02:38:06 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230612101651.138592130@linuxfoundation.org>
In-Reply-To: <20230612101651.138592130@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 13 Jun 2023 15:07:55 +0530
Message-ID: <CA+G9fYuYfZMWLCcELs7QDYJxB-cgWz_g2K8NTL=OhUQRvbbhpA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/23] 4.19.286-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Jun 2023 at 16:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.286 release.
> There are 23 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.286-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.286-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-4.19.y
* git commit: 0312c44fe57536e9b4128c831334afb0d829e674
* git describe: v4.19.285-24-g0312c44fe575
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.285-24-g0312c44fe575

## Test Regressions (compared to v4.19.284)

## Metric Regressions (compared to v4.19.284)

## Test Fixes (compared to v4.19.284)

## Metric Fixes (compared to v4.19.284)

## Test result summary
total: 79126, pass: 67918, fail: 2874, skip: 8200, xfail: 134

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 111 total, 106 passed, 5 failed
* arm64: 37 total, 32 passed, 5 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 26 passed, 5 failed

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
* ltp-fcntl-locktBroadcast
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
