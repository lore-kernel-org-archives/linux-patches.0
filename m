Received: from mail-vk1-f170.google.com (mail-vk1-f170.google.com [209.85.221.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D80F723BD
	for <patches@lists.linux.dev>; Wed, 28 Jun 2023 06:59:48 +0000 (UTC)
Received: by mail-vk1-f170.google.com with SMTP id 71dfb90a1353d-4717a29e19bso2160184e0c.3
        for <patches@lists.linux.dev>; Tue, 27 Jun 2023 23:59:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687935587; x=1690527587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=FSn4tuQbZU5tpej8ySDKdoCTz3C/VKUeJEIDXrI8ApI=;
        b=K7YjNdHzxsA25wuXarmLEvXMeEZYk448eeoTxHIgU1QU/1FK5XhTBjoEbhJgjKsO5d
         yfE18YHbgD3K9lAS4XSCI6sRIf4bp2hMgLVR71NQKAhAYHHgxDotA78O3E8blugd48LK
         YM+J3ikzguIdrqf2DTJUccgaR9bq51RwMwwFuviFEZ++KNmvv5Ep98LKM1Jiv3qC42OO
         ERhZruhK9+CXjweERyiGfUFoyaNIOwVPpMXY61EcspwtZtti2TBigLRQFKmDo+0JCOCt
         WIceT/E0WVWOXbiYLN3SY8hmXw5EK7Ktd5auc6lwpYUcVLjI7kD7Q8vbBUuREaCZ4nzT
         UPww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687935587; x=1690527587;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=FSn4tuQbZU5tpej8ySDKdoCTz3C/VKUeJEIDXrI8ApI=;
        b=eAkFXXbCDj4qgvCGTFF0qOp/2glqc3wYXp2wYT3NUhBvXrecXUQa8mMXMKOOTU9VFI
         88wnNww+bLdi/sp0ymN+liawtLHg0AFjDTKYngRZjuT2Zl7DOjYt9LTy/jrZnOBugUTA
         RVW0jhSBBrZ1t2ZsF2iH2qSUheNOwZIY8ECmVZ+T51UrKKPIPMFnlt2g3x+2OYzvUShE
         ZcQqsovKpL+DEzNPoKcZaGLOtyNeUA7pblI1GezsAB01DwYDa9m4j9ThbopGZ9C0JsvA
         nIzMOo+vBLwPCn2u50phww4uQnRWKkgmUWj+RK/b+gY9BYWhTQSCFt96TwRSiI/AsaXC
         Xlnw==
X-Gm-Message-State: AC+VfDxq8dZlgo/UA97H7y09rMfpG4utvZh45A77CDdE7wwtWFGZF3Ee
	kLpH30woxALQ1/AP1rezMSGN3MZMAreUoH2rM2mnyOzqe++ytPgow+fhWA==
X-Google-Smtp-Source: ACHHUZ7t44iUD/uayELXJZDpQD9e5qu/zLWUfEGQ4HOTGsdJOeGEWwlqjUuEh6jUUU001f88X4GQWC028YZtissqo8E=
X-Received: by 2002:a67:f309:0:b0:443:6052:43a7 with SMTP id
 p9-20020a67f309000000b00443605243a7mr3835859vsf.32.1687935587369; Tue, 27 Jun
 2023 23:59:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230626180736.243379844@linuxfoundation.org>
In-Reply-To: <20230626180736.243379844@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 28 Jun 2023 12:29:23 +0530
Message-ID: <CA+G9fYvdQOWt6uq4CHViVfiOzP9dOcvES_0vRCgsSg-p1qkpCQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/41] 4.19.288-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 26 Jun 2023 at 23:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.288 release.
> There are 41 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 28 Jun 2023 18:07:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.288-rc1.gz
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
* kernel: 4.19.288-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: d46c55c4b242c7dc4d40b4b2a0fb5dbac24ae5cd
* git describe: v4.19.287-42-gd46c55c4b242
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.287-42-gd46c55c4b242

## Test Regressions (compared to v4.19.287)

## Metric Regressions (compared to v4.19.287)

## Test Fixes (compared to v4.19.287)

## Metric Fixes (compared to v4.19.287)

## Test result summary
total: 65773, pass: 51942, fail: 1892, skip: 11895, xfail: 44

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
