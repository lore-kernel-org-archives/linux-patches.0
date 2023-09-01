Received: from mail-ua1-f53.google.com (mail-ua1-f53.google.com [209.85.222.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D3AAD3F
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 12:49:02 +0000 (UTC)
Received: by mail-ua1-f53.google.com with SMTP id a1e0cc1a2514c-7a52db1e4bbso780922241.3
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 05:49:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693572541; x=1694177341; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eZAs7VhAqmwUCso6UvdFSw8g4rQU2c3GRkXTqdKEPuI=;
        b=ubq932SXSoOYY81+7OoukwhdgvJ/EkoiNv7t9SXFyeOZ65rrZGoTEAoFLxQzaGh9kj
         O1cRFSAhr45hdO8laJeCqZxBYCwhkZzV60F/+PU2gVW3i/B04K4xkHrosY9PrufOWojI
         Q6vEdSkJyaq/85A7IoBAqvvhBNs45IWnqWcUpd3waVSxgv5G3OkyNainB/gjXSBF8X94
         64K6frJQVu8IeE8kpGy1nkFPAUC01ZcyZoQHus54jZFq5s8UhgYljifNZdgS7oy8SjX2
         QEA9YAAuNhQYR90usRKGy8MmQs1GFaKOzkb24Pj44vppxKzHfZtHUvVu158T2eALvA4R
         Lm+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693572541; x=1694177341;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eZAs7VhAqmwUCso6UvdFSw8g4rQU2c3GRkXTqdKEPuI=;
        b=RKbbgIGrhW+JWvV7fDsczbwtf+nxxk8OQz2t/uUlxQUqxyrD4o3FfG5ci71C2ZAYMg
         QlIGpEVaaMvX2wjd/Y+sxX8VstC4buVVcx7ZNhq2Lz4Oq+wq7Z2F5cXOln/YhXVYz3SR
         UtrzIDxOyfFG0JLRGelL3Es0kCpdwA2TOU+pk/OpsedjRi2YPkaLYRORFF3347y6fJ05
         SzQHLuQx2SkcZYtxRD0SiU94ycLum5pYr+mvuAMInh9/UE1188klyb3M5M2mnj9BzJDW
         SJ2MExk0oYlYfelumBwxSpBZUP95XsplZITVYbxJjGUqyGqYOB/MutJqA8lLvMZQzIKw
         vH8g==
X-Gm-Message-State: AOJu0YzoyF7djEHMhY6SooJ4plTbYDV2fogN4fhy2gKEro/YotdNE2J7
	v3cfpa/bKiKaitbGVSZB486I5DPGXjrp2kn9Pdkwlw==
X-Google-Smtp-Source: AGHT+IEB9jt0+K93uEZDGEfUQbqOftNhxXjcWPCxaJuZjUubR8A9yN+H/IaZ5UAnswWDbcYJp5W7kccv80ppkwSXq7A=
X-Received: by 2002:a67:efc6:0:b0:44e:fc88:9cc5 with SMTP id
 s6-20020a67efc6000000b0044efc889cc5mr2233124vsp.20.1693572540909; Fri, 01 Sep
 2023 05:49:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230831110828.874071888@linuxfoundation.org>
In-Reply-To: <20230831110828.874071888@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 1 Sep 2023 18:18:49 +0530
Message-ID: <CA+G9fYtnmbgfVUNx8wOtysxsw71poVddfQt53=Dm6GTz+8v7Cg@mail.gmail.com>
Subject: Re: [PATCH 5.4 0/3] 5.4.256-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 31 Aug 2023 at 16:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.256 release.
> There are 3 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.256-rc1.gz
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
* kernel: 5.4.256-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: dace6640c652718a3ef17226ac5cbe5a41040cf5
* git describe: v5.4.255-4-gdace6640c652
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
55-4-gdace6640c652

## Test Regressions (compared to v5.4.255)

## Metric Regressions (compared to v5.4.255)

## Test Fixes (compared to v5.4.255)

## Metric Fixes (compared to v5.4.255)

## Test result summary
total: 100280, pass: 81623, fail: 2238, skip: 16367, xfail: 52

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 142 total, 142 passed, 0 failed
* arm64: 45 total, 43 passed, 2 failed
* i386: 29 total, 24 passed, 5 failed
* mips: 30 total, 29 passed, 1 failed
* parisc: 4 total, 0 passed, 4 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

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
* kselftest-sigaltstack
* kselftest-size
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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
