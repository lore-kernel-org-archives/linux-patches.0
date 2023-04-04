Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 045C6648
	for <patches@lists.linux.dev>; Tue,  4 Apr 2023 05:19:19 +0000 (UTC)
Received: by mail-ua1-f44.google.com with SMTP id 89so22493705uao.0
        for <patches@lists.linux.dev>; Mon, 03 Apr 2023 22:19:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1680585559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=clcP9IEhfBzHUgmu2eabXxj1HhcsLZSikrHXTq7mjew=;
        b=WqZh3ZQqkwMnYTHL9/Hn12la9xxjFiBj6hogHmP0n5N8XpJ6byQtOhn4Cy7wHm5BC1
         sKjUkHR1TFtRgmI8WRConujPh4o04Z6IvkMkgawdcX2AlECufnrZcdsbF+g9Yh2qdgJi
         a64NOsXc+vQbSHvxD7m3RqEcYhV7KV/FrXdxId2zLa/xw/DXIUbJ6dXjY59L62OhFdRC
         A2hZjXx1gGQondx67YMuYhNt86/ybzqRf26yRE6LjQ9WJ6FphqZ+Hmuvi6YWzTT7cx4h
         AToCTRYmsKvmqHoJgjRQsWN/4Y+lCv0EbCt//2ASVavCEGKRl6m7tvzIs34yh+eFR/XC
         LOKg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680585559;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=clcP9IEhfBzHUgmu2eabXxj1HhcsLZSikrHXTq7mjew=;
        b=dDIlg5QOio18EbYiEpng2GkNSGVkJqP4D9ehv/VZ/sTV//kHoDjOBlGeS5X6muc+AU
         CaN2fHN5sotNAxBzQwf7v6E/5xItOLsDy8UgZC3VY4pOu3ZYJP025ApFhFg+LRSBT95x
         Q3ks1OBITt29v6GDjtKHTrUuy+fTRxw1RGRFKP1mQG+GCYJd6GDhBC0kO2PN6UjYWQ1i
         47xLD5IMXpGW4WkcKEFqhhUzLIJhnig7iZzFULxalyxbvVX157EKisXhj0+Q27F+NHkE
         VzX7HjQcq2RfS0WFQdRjJQafE2PJgxNZUJwJnuxuyPQ82TVp+rFSvt7MeuHYDeyX5okh
         q9Pg==
X-Gm-Message-State: AAQBX9f8V/ZYC7DQ1xnHb+OrP5V7i+PLAOHJxhjQqYqaNHlvsHOUfPkk
	RvHjvbg7hyI2evxXUQannpdeG09ZnQ5enJvfxLru1A==
X-Google-Smtp-Source: AKy350biw/EtOjp4EPoVplJeSd1seQsfwdamzCoQOFSHghz995LymiXjKViuwHdeCcdV4H5EQ7xcmvCMF8i/LYNb2AI=
X-Received: by 2002:ab0:5485:0:b0:755:9b3:fef8 with SMTP id
 p5-20020ab05485000000b0075509b3fef8mr651393uaa.2.1680585558616; Mon, 03 Apr
 2023 22:19:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230403140353.406927418@linuxfoundation.org>
In-Reply-To: <20230403140353.406927418@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 4 Apr 2023 10:49:07 +0530
Message-ID: <CA+G9fYsPfDX3HB=7WDYsKDCygHg51bOo+Gi54QdfgMkZR=JC3g@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/84] 4.19.280-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 3 Apr 2023 at 19:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.280 release.
> There are 84 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 05 Apr 2023 14:03:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.280-rc1.gz
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
* kernel: 4.19.280-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: e4a87ad39c9847a7bfb3415dabc4c56e738bc93a
* git describe: v4.19.279-85-ge4a87ad39c98
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.279-85-ge4a87ad39c98

## Test Regressions (compared to v4.19.279)

## Metric Regressions (compared to v4.19.279)

## Test Fixes (compared to v4.19.279)

## Metric Fixes (compared to v4.19.279)

## Test result summary
total: 92995, pass: 70324, fail: 3023, skip: 19502, xfail: 146

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 108 total, 107 passed, 1 failed
* arm64: 34 total, 33 passed, 1 failed
* i386: 20 total, 19 passed, 1 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 28 total, 27 passed, 1 failed

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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
