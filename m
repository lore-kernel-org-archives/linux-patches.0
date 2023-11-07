Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8C2030FAC
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 17:44:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="OzDQhGGL"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-45dae475aedso1440777137.2
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 09:44:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699379071; x=1699983871; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DW3+W1JkqemIl2KzUEEcBPa9+uOwoIHQC8p9y1KLnPU=;
        b=OzDQhGGLeENsz6e2p/4KhxB9GpnkIjoKVXoqJGZnkaKBQ6d5oyHo5HwfUM43TboFik
         IdZxzmbB0vvb9fuGGtmNsHHfwy4tUfFjhza2plszDaxa3BB9TWkZbgtILSKPstxVeeCh
         wxjRnrXd7y8obNWfllauRp2cDU0CcdriDm0iJKvF3RXs05cH1+/mmcIkrJ/1pXNFagO5
         Y0zGakgZPXFvcBwDvqZKNMmXz2t0erzu9vYzPF16Va7Jz+Jo96FqZtCffik/pYmKhXSt
         L9OZLKfHKRktmYZRFqOLNn63u2wl5WoK5jJTKY1v8yIN4B61A3tn6hAWx5PeLzJVptkp
         iCVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699379071; x=1699983871;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DW3+W1JkqemIl2KzUEEcBPa9+uOwoIHQC8p9y1KLnPU=;
        b=N/9fbPYbmtH8txssxk7cwKy2dIvWUXLm0Pic0tgQDMJEfr9zckVvW4tkyLjooqiEgj
         neWL97vs2Eq7dBWuPvu1cpKKCDx40xnRCCsWEmhKiWiL/NZ4iMuP+JZpIVOeCowIP4tq
         VATrsoTbrQoWYAhJiwutWR3iGIzoXt/sMwVMrov33aPLpDTadDPRVUOKr77w6+o/CfCZ
         svTaBDkMN5ejgqYUF96GjjJF/jf4wV1get+3ggQCo5zqemZJn1fmYw/4bc2NzY88yNLu
         1oHQOVOXGfkuYQkRyrnR+ErLgIIadSFObVUh6y7WHLTCxnePYSlKWg+EIwoFqG82GJJB
         bAVA==
X-Gm-Message-State: AOJu0YwKvTpTyWONYuiXhdYYtTF1C8/xqotOUCncLNCycsd6oRSZcoFj
	CEeKqf9l5JZ+s8cqAmcJU9JVj8tFlD7DPsZ20Bh1Ng==
X-Google-Smtp-Source: AGHT+IH5Nvyc0QYX9FMsRsyZZgmkaVjGPNhVriJFhSefM1O+XV/gnLRrXf0kNV1QcMZtN4cAmcC1V8dIUMExhg6+V2Y=
X-Received: by 2002:a67:e1d3:0:b0:45d:9a4d:dc1d with SMTP id
 p19-20020a67e1d3000000b0045d9a4ddc1dmr6989197vsl.8.1699379071442; Tue, 07 Nov
 2023 09:44:31 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231106130301.807965064@linuxfoundation.org>
In-Reply-To: <20231106130301.807965064@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 7 Nov 2023 23:14:19 +0530
Message-ID: <CA+G9fYsogYh8S9F7hgjEJPmNN2pE7t0yU6Zz-A64S3UXu1DCzA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/62] 6.1.62-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Nov 2023 at 18:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.62 release.
> There are 62 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.62-rc1.gz
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
* kernel: 6.1.62-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: f2e7db5bff4666814d68d4f2a8f1818be97f5e70
* git describe: v6.1.61-63-gf2e7db5bff46
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.6=
1-63-gf2e7db5bff46

## Test Regressions (compared to v6.1.61)

## Metric Regressions (compared to v6.1.61)

## Test Fixes (compared to v6.1.61)

## Metric Fixes (compared to v6.1.61)


## Test result summary
total: 123810, pass: 105299, fail: 2422, skip: 15973, xfail: 116

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 147 passed, 0 failed
* arm64: 50 total, 50 passed, 0 failed
* i386: 38 total, 38 passed, 0 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 35 total, 35 passed, 0 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 46 passed, 0 failed

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
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
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
* libgpiod
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
* perf
* rcutorture
* v4l2-compliance
* v4l2-complianciance

--
Linaro LKFT
https://lkft.linaro.org
