Received: from mail-ua1-f48.google.com (mail-ua1-f48.google.com [209.85.222.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F0E1A20
	for <patches@lists.linux.dev>; Thu, 16 Nov 2023 11:29:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="K94humhc"
Received: by mail-ua1-f48.google.com with SMTP id a1e0cc1a2514c-7ba8e3107c9so269462241.1
        for <patches@lists.linux.dev>; Thu, 16 Nov 2023 03:29:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1700134152; x=1700738952; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cgZuTWIqDoEfzrhfwR9hBMmPlIJ36L9Yx0IZnvedSxc=;
        b=K94humhc9GCC5MUmuK82c/ciY8SWdqEWTuAYKYQMsgAcABPVg05JxDNV5yeBTOoWQi
         Vrrplgqx33ewaWYrbo++gXSLu3CWX1YddAYKb/H+QBYPJghqByCKeZvAMqQogd/eFTuT
         REgvysd5gWT7K8oChdUnpK34/mpejRaMFKo0stELJ6en4Wh0QC9TiyJrJThga85RnX6h
         s34HNecndOU0lDCSZMOW48sR8pqSVs39vJWt88E1mtPZjw5rmIsQuxntftKwubLbDsTk
         mw8DrbzBThB2bg0dIBo5pdls5W12UX9QkJylCFav+LZhvKC7guPPem/J0o2+a+qt4nNQ
         1rqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700134152; x=1700738952;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cgZuTWIqDoEfzrhfwR9hBMmPlIJ36L9Yx0IZnvedSxc=;
        b=EZLMpt3r0IevX5W37Zybqg5/dSG8qqrazj5+YKV814kXghm5lXGW0zhQ5Wh5LYGpBz
         YLxmxaXkOVVflB15OTgsmtSFkP3QT/wKg02I0gJavEW6ALtlirdJPW17q9gGC+LFO7wc
         2J8Fp0Mdzwz91D3Gc03g+jKVgq7AIb049jsaY9f+X0VANpIXpSZ/zb0Mf0OIA+iTjYXH
         qvHjLFbIAQ1FovVG/3afcq5ZRKlgPa6dgSNYRidXmu8x/3KzC3Y27PvZXPxxitRbEmU8
         4OuozBhzD8cTRafWPsarjkgran/eWFHZksWXP7I3VyaK2Cngm6uD0Nl0/OpdbudbSkaS
         a3mQ==
X-Gm-Message-State: AOJu0YwZBFyMbpkaOV9xBLNAFY3KKwENZwxUx4cGrm6iU4MH1jhsm08N
	Dk/w8COtRCmwp9YRrCMnfh98jnu3k9ONdm2TtibK9w==
X-Google-Smtp-Source: AGHT+IE4HyODO+ul8EitVlUI58gYld954XEZGDB2U72usvZq2IozoC2uXX9VlZyvWcME2u/ldmebMpj77IM0fc3NpaE=
X-Received: by 2002:a05:6102:440c:b0:45d:91f6:2796 with SMTP id
 df12-20020a056102440c00b0045d91f62796mr20805030vsb.26.1700134152486; Thu, 16
 Nov 2023 03:29:12 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231115191419.641552204@linuxfoundation.org>
In-Reply-To: <20231115191419.641552204@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 16 Nov 2023 16:59:00 +0530
Message-ID: <CA+G9fYsCscnmNLHQE8F3bZQvTjG0RUrpnecF-tRioHa+dkUv1w@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/45] 4.14.330-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Nov 2023 at 01:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.330 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 17 Nov 2023 19:14:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.330-rc1.gz
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
* kernel: 4.14.330-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: e54e4d8ac976c722369c6934276a14df398f7d2d
* git describe: v4.14.329-46-ge54e4d8ac976
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.329-46-ge54e4d8ac976

## Test Regressions (compared to v4.14.328)

## Metric Regressions (compared to v4.14.328)

## Test Fixes (compared to v4.14.328)

## Metric Fixes (compared to v4.14.328)

## Test result summary
total: 48478, pass: 41283, fail: 1157, skip: 5996, xfail: 42

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 108 total, 103 passed, 5 failed
* arm64: 35 total, 31 passed, 4 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 19 total, 19 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 8 total, 7 passed, 1 failed
* s390: 6 total, 5 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 27 total, 23 passed, 4 failed

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
* kselftest-filesystems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-kvm
* kselftest-lib
* kselftest-membarrier
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
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-watchdog
* kselftest-zram
* kunit
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
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
* rcutorture
* timesync-off

--
Linaro LKFT
https://lkft.linaro.org
