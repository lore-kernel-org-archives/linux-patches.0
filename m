Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90A336FBD
	for <patches@lists.linux.dev>; Thu,  3 Nov 2022 11:59:20 +0000 (UTC)
Received: by mail-ej1-f53.google.com with SMTP id ud5so4579325ejc.4
        for <patches@lists.linux.dev>; Thu, 03 Nov 2022 04:59:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/8w955riB/tcF9oZ9i2EQ/eH2CtH8tAwB/HB+myWj6A=;
        b=lWvl6dAoDcGn47aiSbz3qf8R++AIGSDL08VlpzBoFKyZwhscX87RjWKA305ioh0QW2
         /0+Uaexp1UyHSjq+rEgrM4VWKZMWLqYI7ANsgSHDaDXEbI9rtfHgzJLsdELNXRfXEAYI
         zZlgSsIDZ586sqLtcMih5D2qotnnwU+Rcirmr9AfX1e5TjgF2MYH5HprCiohY1phLzYr
         tEBhQRyIrSHk/BoauId7kn+dsPBVFJjejzNkkNGH0X2knO028XyFEzj80ufcOyh6bIij
         jDMIC4Yi4coi6wYLzvYoBd9Y1G6jfiFKOJjc5YeS1rJ94vOamfsonhYBqeXTntVUnoZR
         xRbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/8w955riB/tcF9oZ9i2EQ/eH2CtH8tAwB/HB+myWj6A=;
        b=D9sjRaNqQFqu54OQ8uI7IahJdYUKqh3ZoZQX/BDQiN1dqBveWMh2wAtKtvq5uVgUN+
         3LQPD/YlVLqfFMcQnaWNcx0wbPqi862AIzCL+zgPUI7Fj/jgxsoHm5gVBPhJxYlcPOg4
         v138uLRx/oMU63ZnSIb+uL433MVS84vdL8vjzw82xrGujvqxDaHte1WcoXJMUXRrPSWh
         +1X7bAw88TtUaCOPmoBL6lOUgF0/joMZqRFkuhT8/p+v0jWhTrnH4zaRWP+gErzGoFot
         k3/gzqqZbWeFm4gT8bY8/gZJpIP8d4IiHBiV2jMp/4/NZlVg47c1C151vKs2veLa/YYH
         LdPA==
X-Gm-Message-State: ACrzQf1HM0zy/f6+xCK6CNKcmhpVv4fj1b+t5Hax5pjiwGnUuYInxSbb
	0dMCZrR97YPPGnqaj07aRjlMbaRaVnTeE0kRmxpWyQ==
X-Google-Smtp-Source: AMsMyM7i9DdanFA+qCIw2y5Eez4pQmHNmR842CXxzAYBfZevSXWhKE7MPnea6hEtBDqLAdvBGQ9RjfhFRnnvA8MWjwk=
X-Received: by 2002:a17:907:6e1b:b0:78e:15a3:5be6 with SMTP id
 sd27-20020a1709076e1b00b0078e15a35be6mr28678837ejc.750.1667476758617; Thu, 03
 Nov 2022 04:59:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221102022049.017479464@linuxfoundation.org>
In-Reply-To: <20221102022049.017479464@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 3 Nov 2022 17:29:06 +0530
Message-ID: <CA+G9fYvZ+FWg7bhng3NyQkZBeu45++5ma3AZumqsK1Jiv1+0GQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 00/44] 4.9.332-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 2 Nov 2022 at 09:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.9.332 release.
> There are 44 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 04 Nov 2022 02:20:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.9.332-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.9.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.9.332-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.9.y
* git commit: c8644fcd30082db200dd0663c60b1f5e01734ee8
* git describe: v4.9.331-45-gc8644fcd3008
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.9.y/build/v4.9.3=
31-45-gc8644fcd3008

## No Test Regressions (compared to v4.9.331)

## No Metric Regressions (compared to v4.9.331)

## No Test Fixes (compared to v4.9.331)

## No Metric Fixes (compared to v4.9.331)

## Test result summary
total: 109694, pass: 91889, fail: 1834, skip: 15080, xfail: 891

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 282 total, 277 passed, 5 failed
* arm64: 53 total, 46 passed, 7 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 40 passed, 1 failed
* parisc: 12 total, 0 passed, 12 failed
* powerpc: 45 total, 19 passed, 26 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 48 total, 47 passed, 1 failed

## Test suites summary
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
* kselftest-net-forwarding
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
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
* packetdrill
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
