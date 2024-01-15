Received: from mail-vs1-f42.google.com (mail-vs1-f42.google.com [209.85.217.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB58BC120
	for <patches@lists.linux.dev>; Mon, 15 Jan 2024 08:57:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tdzMuWIf"
Received: by mail-vs1-f42.google.com with SMTP id ada2fe7eead31-469407ff780so120691137.1
        for <patches@lists.linux.dev>; Mon, 15 Jan 2024 00:57:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1705309044; x=1705913844; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=K4v1AdI32Kp8Z1EODc0dmNDkAUnEI1s57YhrdMHhuH8=;
        b=tdzMuWIfnxqswNFuYjRym8BS5nskD2ITICjz9sK+SBMceQwCGRTaieSv+X3Nq9DAtw
         b9M+PwLUuFdWX8+xZkv+lvGrZ0pANdoPVNDW28vYbixKvtUWjE6rP/Z6FMJJ8JleyC1v
         HT1v/jZweoKCNqMW7I44kHVIGKzjYPXYiQicbMKfnRVYuSm7YTsZGJ3i6OWUwLV0whCz
         eu9xWNl2irN2HuwDCsvxQWJM3gGjdVGy1n10AEWkrL+Rflkr4srQNOkmO65ylolUKATz
         bAnaMGf+p1eVUM+OwLITBAmNbQEZNVxHs61pUe4AJmTBwaUVcXwdtZMT45Sgk3aKiF4O
         9Pmw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1705309044; x=1705913844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=K4v1AdI32Kp8Z1EODc0dmNDkAUnEI1s57YhrdMHhuH8=;
        b=cJlzQpyJlMN1sfAT9+nreiQZ6hIepnzC+Q+yXvYDlvtlZ+1oX/EY1fbe4wHa+aN2xD
         5W7DtmCsIQhLgrJIOyVo/pfGqIfZ4H89ckdVeJbzFp1yy32IYGY+zKLatOmVWII8+eu4
         vXgCAmc6mQXVSFSnTvwOUI9UjGlhvFhzTRb7BLO/YAZrOqqK6edc3WcG6tXb2aQQfLj5
         6tfO0usc/PIhnsP+bQfF/zNIVqlB44+7j0JBTrnm0Ib2xR9VPlEZ7uWvKy6YoJ8Strf+
         X4uvb4HULa6PvWueGzJUB65UelJWOzIvDWlWDN4Y2fBDblKpsN2Cb5kEtVfPj5ZKLXcl
         q9Lw==
X-Gm-Message-State: AOJu0Yy3FBYKrIpdzTOX4agqrDKRiORQNKw9ymXUGjBwU97yTIUJeiLQ
	N8zumHWfHjJbFIJR47NCeuhy0hibZg1btuCYhLX1Fwl7ZOucZQ==
X-Google-Smtp-Source: AGHT+IHMmYxzI3mAVJDcEJEplNVxfmygp9nd+wcU/5sYY2iOvEMAdLZZg203zoyPOGUGbPTazWIMJJ4PrLmYbvV5IGw=
X-Received: by 2002:a67:e9ce:0:b0:467:ed7d:27bb with SMTP id
 q14-20020a67e9ce000000b00467ed7d27bbmr3166740vso.14.1705309043703; Mon, 15
 Jan 2024 00:57:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240113094205.025407355@linuxfoundation.org>
In-Reply-To: <20240113094205.025407355@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Mon, 15 Jan 2024 14:27:12 +0530
Message-ID: <CA+G9fYv71kU78tJNO-gZ-SRf4aOSgYveudKuyffq8N3-5oFvAQ@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/25] 4.19.305-rc1 review
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
> This is the start of the stable review cycle for the 4.19.305 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 15 Jan 2024 09:41:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.305-rc1.gz
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
* kernel: 4.19.305-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: cb74230da5071e4cb54b342a0d079296ecc14a98
* git describe: v4.19.304-26-gcb74230da507
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.304-26-gcb74230da507

## Test Regressions (compared to v4.19.304)

## Metric Regressions (compared to v4.19.304)

## Test Fixes (compared to v4.19.304)

## Metric Fixes (compared to v4.19.304)

## Test result summary
total: 103058, pass: 89229, fail: 1698, skip: 12065, xfail: 66

## Build Summary
* arc: 20 total, 20 passed, 0 failed
* arm: 216 total, 204 passed, 12 failed
* arm64: 65 total, 55 passed, 10 failed
* i386: 36 total, 30 passed, 6 failed
* mips: 40 total, 40 passed, 0 failed
* parisc: 6 total, 0 passed, 6 failed
* powerpc: 48 total, 48 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 20 total, 20 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 54 total, 44 passed, 10 failed

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
* kselftest-user
* kselftest-vm
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

--
Linaro LKFT
https://lkft.linaro.org
