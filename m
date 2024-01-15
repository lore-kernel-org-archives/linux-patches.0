Received: from mail-ua1-f46.google.com (mail-ua1-f46.google.com [209.85.222.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC9DF9C2
	for <patches@lists.linux.dev>; Mon, 15 Jan 2024 09:24:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="rZlkTyXv"
Received: by mail-ua1-f46.google.com with SMTP id a1e0cc1a2514c-7cdef012c0eso2493295241.2
        for <patches@lists.linux.dev>; Mon, 15 Jan 2024 01:24:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705310660; x=1705915460; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fh+LNMWozo0J3aAZgCisR4oMBODsHlxEIqXU2tzebT8=;
        b=rZlkTyXvkBgEivzsWK8hxsChR6Rq6iblP1IpSpWJlyjNyDVfmt6WQeS2ozbeGD8N//
         5iu+Z/nLK1FKPojY2B12PMxkRYWOjTHKXoyqQ8wgUZukKzhKzncA5TILeLqwxTE4mSxF
         qLn2zhLueq4VHPVScHEkFf3rUxCvyjxp1VCBFVyPvavobNg1ophJF+vKrP9zM2Z/ychg
         XE13emClzyKaZVMR8YKvQqIsCAGhg75Nt8fFajRgoWKUKSRNT4m2AUSOitLk/2WCZWA4
         0zGLht8pPAdztpZzE6kmkWSz/b2MBOazC7yhboP4iQFknzqmE9aia4EucFq6+xHgnDjG
         eH7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705310660; x=1705915460;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fh+LNMWozo0J3aAZgCisR4oMBODsHlxEIqXU2tzebT8=;
        b=viXag7HRo/tJC7kBJEDQz4u0dpNV/BChtpD+we1qWw+1137ueYva7ffuevQ7Yu/j93
         DAjTgrqjuS8fY4tRDmfqlwHkTdnWyY1yM9ULLwqu885TWi/H+G/KeEZL3FK0DnjGOUM6
         I3hf681Z2AY2XOCjlTgdslOdRm7PbypKSECuz7jVt3ZN5M+gVMrRshFq9G/kNnSLXDBP
         9IgGJxGX89OBcejlSkf3sz20auTqUX8fznAD3X/9I4+EyI2DN2PAJfzIApaKz3V4mpcW
         b+qMjkap12cGkmFYxKeHzsTHu7xnuxRzc7zVy2TQM6CV8gDlHN/EIPtVC6xZlqTMOS44
         ge4g==
X-Gm-Message-State: AOJu0YwLs0Nbu5HYJNA80pv3dhJ/StmDj8ERYwm2bK3x7TigC2cYfuoh
	Bpy4X79KhB3LJWdRhrIdxQ/iT+zwEndBsIY0k8YyGEXlshycnA==
X-Google-Smtp-Source: AGHT+IGTfBZ82YCdI7oc8T+p1JxA3rHRkpH5nuA8FLd5dC/vBpmXIkg7gkwgSvsrDaptlz8KQTrUhgjeNSVqriVRcsM=
X-Received: by 2002:a05:6102:21ba:b0:467:dd9a:b1f5 with SMTP id
 i26-20020a05610221ba00b00467dd9ab1f5mr3593591vsb.18.1705310659736; Mon, 15
 Jan 2024 01:24:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240113094206.455533180@linuxfoundation.org>
In-Reply-To: <20240113094206.455533180@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 15 Jan 2024 14:54:08 +0530
Message-ID: <CA+G9fYtjSMDFywbNMZMoc2ZaXQ0kg0aCeOHEW-xe627PLFkpNw@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/38] 5.4.267-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 13 Jan 2024 at 15:25, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.267 release.
> There are 38 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 15 Jan 2024 09:41:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.267-rc1.gz
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
* kernel: 5.4.267-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 86b133f1f903a253af84a135ff1afeec162143e7
* git describe: v5.4.266-39-g86b133f1f903
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
66-39-g86b133f1f903

## Test Regressions (compared to v5.4.266)

## Metric Regressions (compared to v5.4.266)

## Test Fixes (compared to v5.4.266)

## Metric Fixes (compared to v5.4.266)

## Test result summary
total: 176285, pass: 139633, fail: 3376, skip: 33179, xfail: 97

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 285 total, 285 passed, 0 failed
* arm64: 81 total, 77 passed, 4 failed
* i386: 51 total, 39 passed, 12 failed
* mips: 52 total, 52 passed, 0 failed
* parisc: 6 total, 0 passed, 6 failed
* powerpc: 62 total, 62 passed, 0 failed
* riscv: 27 total, 27 passed, 0 failed
* s390: 14 total, 14 passed, 0 failed
* sh: 20 total, 20 passed, 0 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 70 total, 70 passed, 0 failed

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
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
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
