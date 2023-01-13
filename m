Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45815AD4A
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 17:45:57 +0000 (UTC)
Received: by mail-vs1-f48.google.com with SMTP id k4so22929398vsc.4
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 09:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1Q3MaSVSqTaDvspy+O+trO5FGSc9zxpeY67q3aD4cKc=;
        b=S6dh+IKQDZlJ1tE56ZBYvb6O81iVrSvJMT9Y1Ppf2ifA2pxVSuBZDPBEBXmoBU/6Iq
         rQzLENf6AaEaLvkYWJY7ubJKbMn2klY5tR1ONfL0hbq1w4ABdg8jVuLok2jGn91dzl3k
         y8YLdPZuYYCosAFmHyZEa8s3CkNKOmiNUBBTMY8Y/Co2t9OZQqRtiNUZtGLTYvQXVdq2
         zz3VdT8RpX8dwscQIJ1s50jenbE1rs22osRa+cf0bWQSwf+KWEhMrsbH+2uaxh/TyS2Q
         H/8wTzPxSVMgxR8hx0NqmskKBo1CSneRALOr0ITxDyaMzxwkPV4Eyh5yLGGTrcTEKnPA
         VYug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1Q3MaSVSqTaDvspy+O+trO5FGSc9zxpeY67q3aD4cKc=;
        b=1DOha3tGtpFObRI6QSHzOupWt9DA74ge+bqyqA0C0K9tHZdwx+eV0xooKzjDUM3Mm4
         32byS8r9D4n1nhnkIpVfYaP5vsxUGtF4WKMJGUzkAP7reWxJgjlU91feyDLHsjfDCv+K
         qqcdxGC+ZIfA7/SOyxKDqNOwpmtd73+qcNMYBxJCIioUQ51BTSoiXv93k5suaPv8sI+Q
         FI6b53+QffzbOxh0fOwPm95/0DjcQ2HUANOhPv+Z+SFAVZs2W66abE58CubuWl2s9aba
         xa3zVhJd9RTDC8iHnn2BbI7p7u6qHRJB/PCoe+88qQzyiDJKmzBje0EUDaQdEoQhDWwr
         heRA==
X-Gm-Message-State: AFqh2kq/xeHV4AGDTbFnYQ1rxvboLf8EVu7nm2xfOvLsCQKVff8+13n/
	JuIVsNrhJHl4NqV5Dzf0Xm7UX0VjpkT9uLJbfBXl3Q==
X-Google-Smtp-Source: AMrXdXtKzDdD32RD5wvCAC1hYG1hBkZnhQzXrUYAHiwdIjTb8NqkF2hXHIiEZk99l2aFalHyubgcSNA8eQ61nXoUZ/c=
X-Received: by 2002:a05:6102:3d17:b0:3cd:405e:40c6 with SMTP id
 i23-20020a0561023d1700b003cd405e40c6mr6714861vsv.83.1673631955989; Fri, 13
 Jan 2023 09:45:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230112135524.143670746@linuxfoundation.org>
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 13 Jan 2023 23:15:44 +0530
Message-ID: <CA+G9fYsyDyZ3ZmfRYf-YrGpbKg8UBgeozcvpGZO9rtr4n+TBYw@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/783] 5.10.163-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 12 Jan 2023 at 19:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.163 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.163-rc1.gz
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
* kernel: 5.10.163-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: d33d55703c7895c3dd8793cbad6046db91df21db
* git describe: v5.10.162-784-gd33d55703c78
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.162-784-gd33d55703c78

## Test Regressions (compared to v5.10.162)

## Metric Regressions (compared to v5.10.162)

## Test Fixes (compared to v5.10.162)

## Metric Fixes (compared to v5.10.162)

## Test result summary
total: 157841, pass: 132606, fail: 3922, skip: 20968, xfail: 345

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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
