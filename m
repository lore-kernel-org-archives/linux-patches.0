Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 845353158C
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 19:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="dFWD94rJ"
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-45f3b583ce9so3772137.0
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 11:01:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699383713; x=1699988513; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=isE66WVCXkq2MkT6/BYFzPqbqY6cbzaVkTvMt+ezmik=;
        b=dFWD94rJvBiaNI3d4YvziHTZ/IKASLEy+iAQzzMC41b6r9mLBfWijZmW1F4XfD7px9
         D1Q6tHwaMAvz6kdHLaJcg24YW8hq0fHiQWDppLTg7LETRwAWHXga0HWP5la+Sf5eCbEf
         ucr/jvnGcNyTfP0IZ0IAsFyDHVVbLbEnQ0TdJI6aO7AndEzDl0bB0juaVoxmfWOooVKJ
         Ouk7ey31uoq7ItezBXZWIbqvQmIm23Qbx2HrTsLRLl9dyyc2CRVWBRV8zRBHJxthYu3B
         kRCOp/2v7CEgYJzKinamvJor6tYW+Qxh2cB2dWPzMMmcBUHPN9s2feM+D9+aOcePICbP
         BMkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699383713; x=1699988513;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=isE66WVCXkq2MkT6/BYFzPqbqY6cbzaVkTvMt+ezmik=;
        b=tzyoEs0TZcaK52yO/WNN4iucKi2ayeFKcZITe+r9Nw8UzMygk9edoLdptX+Ih2xU98
         zzXGrEuvk4Hrl8pjZXq+045YM8SeAliCsiTWQCaehIPccws/LFgXzz+BDcvnCStkwz/3
         422htmb6M5RfPh3emutlTKLi8CBizaBqa3bYWkn2brOkENP1T25vQD1OyqLx3MtGuAqX
         c1NEtej+S0HwE7yhudc7U0KRd54hvjTFUXz5MVhjrHOXZm7PJu++jDAMr+MlyXqhaaMo
         eROS6uSfX6MPiESyIa7WPT/mS8lC2dXpyAG8eA1QDIBuQUD2KRhCeg4K1a00g//TC1Bz
         R6PA==
X-Gm-Message-State: AOJu0Yy4fPdH5zmyrL6RCvMQZzOOvY0vovHu4vW5guZV/OM3DPyKoRRr
	N+lD283wuJnzStfWssRbHehIwAtu3XKoud2mu+A/fQ==
X-Google-Smtp-Source: AGHT+IG/LigaURA8GmYiHoDiTGKtYnZ9zWQ2wGyPAYMO6QhSDmwkFqZP48b/cxG6Dyl3JzPEOEmOLSEraweDInLiytk=
X-Received: by 2002:a05:6102:c90:b0:45d:8c2a:f266 with SMTP id
 f16-20020a0561020c9000b0045d8c2af266mr2432820vst.17.1699383713250; Tue, 07
 Nov 2023 11:01:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231106130257.862199836@linuxfoundation.org>
In-Reply-To: <20231106130257.862199836@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 8 Nov 2023 00:31:41 +0530
Message-ID: <CA+G9fYsP4cdcfrTSWN07qOO17cPkC3sQX5Xdj2bJWP+HzYmQmA@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/48] 4.14.329-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Nov 2023 at 18:36, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.329 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.14.329-rc1.gz
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
* kernel: 4.14.329-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 081def1ede2f5d00fdf79793a6a9996bf9344737
* git describe: v4.14.328-49-g081def1ede2f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14=
.328-49-g081def1ede2f

## Test Regressions (compared to v4.14.328)

## Metric Regressions (compared to v4.14.328)

## Test Fixes (compared to v4.14.328)

## Metric Fixes (compared to v4.14.328)

## Test result summary
total: 52442, pass: 43805, fail: 1588, skip: 7008, xfail: 41

## Build Summary
* arc: 9 total, 9 passed, 0 failed
* arm: 103 total, 98 passed, 5 failed
* arm64: 33 total, 29 passed, 4 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 19 total, 19 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 8 total, 7 passed, 1 failed
* s390: 6 total, 5 passed, 1 failed
* sh: 9 total, 9 passed, 0 failed
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
