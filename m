Received: from mail-vs1-f53.google.com (mail-vs1-f53.google.com [209.85.217.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDAB7B
	for <patches@lists.linux.dev>; Wed, 18 Jan 2023 08:58:57 +0000 (UTC)
Received: by mail-vs1-f53.google.com with SMTP id n190so31121815vsc.11
        for <patches@lists.linux.dev>; Wed, 18 Jan 2023 00:58:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tBkTbFF9aWlMGtV+OPGHuf+HNY2wlnat0pDhkhBjc88=;
        b=q/4nsWsMhxCZhEedY6SE87FQhU76ETSz8iZHj7SSitYii6hz2Q5oV0U/n+FkhmezpQ
         UhMz09BHcsg4rUQe6eHBeGOuhvxQ3kPBQJMjMxLer1p1+lyZyMuAAjztLMjBUw8BADKJ
         kEuKMETYF5mZYKN+1xI6UJc4wtURU9jqW7VyE2Iu5gDUbaW2ezKZgkfye00hNgMHGtGT
         +MJ6wKW+gwiwADZLdLi1QadSvc/8tkjE0cQbBjjs2Zdy8SMSrv2UJHY5YRUI1MyF7Ncm
         NDdYNpnfwki2xZvSTYOpQC32nmA2q2EKEAritXmodJSIeNfqBicaIzerRsU8MScy55PT
         STgg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tBkTbFF9aWlMGtV+OPGHuf+HNY2wlnat0pDhkhBjc88=;
        b=Z/ZWvDhHywMxoO+dnCD6NvcqSP6wlWOc+xh+ffnincjA+dUj2uh19Lf4p58OmjAD3g
         edF7q/BEIpxwxvQcROxx3H2sV1UmLfMfvRFBQgVu1gfsWRDHhQeRHNE3JgcFuUaHXUe/
         cyQI6eAqpMh/I9c/P1BQyAX0YgnDmjzZuM8EbsNhoaZH+MTGnDnfey9WB1vnx6XWjlbx
         b6kys2c/59Dv1V6MH+VwY1qo1ReBo7SVG1I17fvTa5gyotINftMW6oXSREckI1ScAWvX
         t4XzB4wX7GT+2Ja1AI4C80Mr4jArj9V81oTe6cyCZjtxS6V11B+WAR3I++zyPKB7Cw1J
         s0Tg==
X-Gm-Message-State: AFqh2ko8kAqo1Lp+IeFvl/lMCvQaqx1P5CcRyFbnQ97XWaAZ+JceQ1Na
	PMe/8Uk/AeU6hN7R0PczFNtkJnW8seVgn8gxtHthlw==
X-Google-Smtp-Source: AMrXdXsyNEMyAZsS8fjeKKM+rIp55VKD4Emx6DelbC6BqI5a72ndd9EcJS9Pbz70s7rrpyTc+lzBteSrt9PtSUeqnvY=
X-Received: by 2002:a05:6102:4425:b0:3c8:c513:197 with SMTP id
 df37-20020a056102442500b003c8c5130197mr817879vsb.9.1674032335895; Wed, 18 Jan
 2023 00:58:55 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230117124624.496082438@linuxfoundation.org>
In-Reply-To: <20230117124624.496082438@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 18 Jan 2023 14:28:45 +0530
Message-ID: <CA+G9fYvbxa=vH+Er4m3i=OgiwKtOCRr=uExCjDs3tnpxMmeeXg@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/477] 4.19.270-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 17 Jan 2023 at 18:17, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.270 release.
> There are 477 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.270-rc2.gz
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
* kernel: 4.19.270-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 2738270a87607b0fe9d198d07d8866c75892149a
* git describe: v4.19.269-478-g2738270a8760
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.269-478-g2738270a8760

## Test Regressions (compared to v4.19.269)

## Metric Regressions (compared to v4.19.269)

## Test Fixes (compared to v4.19.269)

## Metric Fixes (compared to v4.19.269)

## Test result summary
total: 112688, pass: 84899, fail: 3443, skip: 23978, xfail: 368

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 323 total, 316 passed, 7 failed
* arm64: 59 total, 58 passed, 1 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 46 total, 46 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 53 total, 47 passed, 6 failed

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
