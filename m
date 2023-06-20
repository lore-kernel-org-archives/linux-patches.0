Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA9E08464
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 10:05:46 +0000 (UTC)
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-43dd7791396so1200754137.0
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 03:05:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1687255545; x=1689847545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/0GY0mmpJVaGap30C67wQ4P4gkVBdItlaEd3GxE6mzE=;
        b=O8vF/rEtSvgMMXiU+C/qQiDrvHcz7ZOo2WW2SAITXvKS9KF+/avDhkBoACW+rhVBSq
         rqRHA7CZ1dDN6ivk4dJtWJdI3xeK17NYMJUXT65vMK110RGYeazogZXVSfNxzvgguCiR
         EO9pSr6oDAEKSYmUxWzTwJi2hPBwX/7ufpuvwZCGP2QaNotok2ZEwUGpgBy6Juacj8n2
         tCCe1yF4dy6JrSYMrXXDRjpiWrQ2KXfH/wB8YQd9/hJ80iNfBkPGfWr8gUVuqcOG/8Oq
         bYFZFyYMyOb6IS/43JcIcvzIqwSYWWNRaNsRjQwLg9nvGMgfKv57JsrDktIQoE11irfK
         hOMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687255545; x=1689847545;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/0GY0mmpJVaGap30C67wQ4P4gkVBdItlaEd3GxE6mzE=;
        b=A+h1fOGck4JUsDewA+GEPdWNhHDVjxYaJff0ZYAcOn13eqY8mT3ND1UyeoVKBfmXle
         NbfnK6DE6nz3jGKp8hYEt94Z5DOQf4d0QbVN5YXUgXcEc4/K7dZCErheWJOsH/JukAeO
         X71Choe/wkRJMt7WB5IbJuHgekYwlO6BiUZsKccUgp2sOndCq9pvhZGep9W7vxmqrVrv
         LSUkecVtGuGz+jJcG919AAajSq/l+WO8dnsRtadK3dRN7m+f+ikFdqsAyIv+DZ43+DQa
         fbBNAAtWeSlGw1ETPbg36/tsdngds6hA/Zus79adS2PD+BH0yD6eZAYAG6orPkswYKKk
         E+DQ==
X-Gm-Message-State: AC+VfDw5QbDK7Sgx1pEaFHPDhoEPxmcdlzu5l8Ky93bwWGPbRX7a6WCL
	NsOmhYzb+8hFYzivRFFWKkiEG9zI9Q+B13hejiVUgQ==
X-Google-Smtp-Source: ACHHUZ4paUhqdQaooZN5/vkkgDUI30Ys4MzA6JHh3iVvL0JixzJdzyeBkA6kXR2s4JlhIhuQ2fiYtoF9mOMPKrBE3zQ=
X-Received: by 2002:a67:fd81:0:b0:440:a737:8b39 with SMTP id
 k1-20020a67fd81000000b00440a7378b39mr2609405vsq.6.1687255545181; Tue, 20 Jun
 2023 03:05:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230619102127.461443957@linuxfoundation.org>
In-Reply-To: <20230619102127.461443957@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 20 Jun 2023 15:35:33 +0530
Message-ID: <CA+G9fYuSVS5T90SBViOzS8hqe-KAMSE3WYxisjzKVvqCcdL=sw@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/32] 4.14.319-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 19 Jun 2023 at 16:00, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.319 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.319-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.319-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 30c57b30b667852569dfc303f0bbd69d595134e6
* git describe: v4.14.318-33-g30c57b30b667
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.318-33-g30c57b30b667

## Test Regressions (compared to v4.14.317)

## Metric Regressions (compared to v4.14.317)

## Test Fixes (compared to v4.14.317)

## Metric Fixes (compared to v4.14.317)


## Test result summary
total: 76666, pass: 62979, fail: 3251, skip: 10347, xfail: 89

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 108 total, 104 passed, 4 failed
* arm64: 35 total, 31 passed, 4 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 21 total, 21 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 8 total, 7 passed, 1 failed
* s390: 6 total, 5 passed, 1 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 27 total, 23 passed, 4 failed

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
* kselftest-kvm
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
