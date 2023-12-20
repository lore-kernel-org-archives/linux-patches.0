Received: from mail-vk1-f180.google.com (mail-vk1-f180.google.com [209.85.221.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D5E3D312
	for <patches@lists.linux.dev>; Wed, 20 Dec 2023 05:43:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="zUyElSAp"
Received: by mail-vk1-f180.google.com with SMTP id 71dfb90a1353d-4b6cdb1729cso629150e0c.1
        for <patches@lists.linux.dev>; Tue, 19 Dec 2023 21:43:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1703050984; x=1703655784; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=uAZTeNF5ZezjDTNS53zJRbUUjywj7n/LbtvhNMedYA0=;
        b=zUyElSApJeTGEIOH5NfzXxHFgcBaiHXqeeqIQa2PBYlSuQAqXDBDPX0hE/Hp9grnvD
         QnSxJEmsX8SFJ0q7y59VMpe1X3YvhGg1hXxpL+qOHzZqbbqvocT546hH0tHjYEuNJ2XE
         psRuSGfyNm6x4CYPsmX0/4h0ZaF3zIFjZEoAXtwQ4PINPBs/YMzK6qx2H7faK7t8tUFC
         d8f0pZpA07HyK+3B5C6+VCxJZQzi38oQtl0gwIJq7MRQmPCqYC/UvYGJ/2XZhzJS7j1u
         WvfK59Qsb5gsDEF5ni0SRd9Ci7wJQa6gewVIq7tWQbKzl+WKoEJ+F4yxGhMRa7VOsbdM
         cv0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703050984; x=1703655784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uAZTeNF5ZezjDTNS53zJRbUUjywj7n/LbtvhNMedYA0=;
        b=UByLKImqV9V0SElIE+h587/Jz8rD2ZwcrIZq8HODACbKdwHUNmpghPpaT+pIMPjC+G
         mm/uZn+oL5/iQ5MJJ3JpnJp7FE2t7UfwNxpsNoVqowKyjrjDHy0eZr7faPhA8D21Xeuj
         UdXew4PAWQEpe+ap9nW48VWEmMMrAJRmtKDd+Ahn6UVr0vRLA7VZ5nZ2PwSa2ciXkoQ4
         lAG53EHGc8Wu0Vn60U23tJ5vFrDfpI/O/XL6gRaTCro1oJ+KRETYmuGmjFfo1IcX91V8
         MHMvGY0YnfIPOK09i8AjRRWVSFA58wpjMzhaWi0F5hnYDqVPT2YwBLdjaodGV6TQDKJC
         YK1g==
X-Gm-Message-State: AOJu0YyGdh5BBLaZa+CiI1EXXlunVp6WnBsQwTAc7yonwXxQwcoTTZcL
	Aq52Ko+9IwK0Xxmjej/NVW5aj4raT4R1vK3nV3HLQA==
X-Google-Smtp-Source: AGHT+IE+M+mVOtLBygLLepmm1wTEWiOGC0i5CQlDAKUUHH74D0RJCAYCLQRPuYto1mTmNOLpGVhgOvWzuwozWp0Fczo=
X-Received: by 2002:a05:6122:17a3:b0:4b6:d9db:d87 with SMTP id
 o35-20020a05612217a300b004b6d9db0d87mr2126699vkf.6.1703050983882; Tue, 19 Dec
 2023 21:43:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231219074407.947984749@linuxfoundation.org>
In-Reply-To: <20231219074407.947984749@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 20 Dec 2023 11:12:52 +0530
Message-ID: <CA+G9fYvmpuwR1zKNxj5DxFdxvcWnMhyn7BL5jZ+Q20RaRyZfKQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/60] 5.10.205-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 19 Dec 2023 at 13:23, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.205 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 21 Dec 2023 07:43:52 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.205-rc2.gz
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
* kernel: 5.10.205-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 163d4e78243233162937b69caa8e5368a4fba1b0
* git describe: v5.10.204-61-g163d4e782432
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.204-61-g163d4e782432

## Test Regressions (compared to v5.10.204)

## Metric Regressions (compared to v5.10.204)

## Test Fixes (compared to v5.10.204)

## Metric Fixes (compared to v5.10.204)

## Test result summary
total: 99194, pass: 75772, fail: 3827, skip: 19519, xfail: 76

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 117 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
* i386: 35 total, 35 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 25 total, 25 passed, 0 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

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
* kselftest-timers
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

--
Linaro LKFT
https://lkft.linaro.org
