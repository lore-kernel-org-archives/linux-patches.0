Received: from mail-yb1-f179.google.com (mail-yb1-f179.google.com [209.85.219.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F106EA6
	for <patches@lists.linux.dev>; Tue, 22 Nov 2022 06:29:40 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id s18so16220079ybe.10
        for <patches@lists.linux.dev>; Mon, 21 Nov 2022 22:29:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oscohMciL9j3oRb2IPcrfq1/TeYxNx3um1mhjGu1wZ8=;
        b=drbFN77WTj7j3jmmiN0us1uim4dy0U/Ca5wO8/TJ7lAH0Evp06I/TN8B9HLT74cgdD
         Z3BDcBySfaZcnB6UIaIjP3Mgdksx65G8z6fCKzEhehEy7b4x9mdlD0mcCdcAadGprQZn
         +IMYQUg0ap8vGqjVXv/UZ+MBXh1ta/z1nW3qhLPwn1FsYjFc2piYe3fVIrhaPEG4bs6H
         QPzZJX9P2upNpjombEdCJ0WyZxdkPmw5iq+zYb9jikIBSyoLLUtivCwVOwg/4twviJxe
         596z8MaUtN8EyWMrVxyTmUnRLg6vfaXZMnAF/ntbb/hMFNjVBypFUQu1l2r/iwk9sf2j
         P6Ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oscohMciL9j3oRb2IPcrfq1/TeYxNx3um1mhjGu1wZ8=;
        b=pzeIznsp0+ss8NqA99BO9mrOEdWyt/YKBRj8mID2yGnAPzRSKdCG+WE67q++hqV6y4
         fJYH2D2c/Si84wxjU5cnmFrN1myymJ7qYt8YT4VYYNp3ML4Q2LFx/qfHX8lFYCDJtx7e
         x3gEl/G0pQ2/SrFM9z62IkQPZZVJYTuTlxsRNdE6O7k8/8rO2IiAMyr2YVjSQo+MEooY
         BLRksqapepB5NHNH/kzSmeBw6HkpbBN9StBWIuQ8Md3dLKqT+vEC7qwveXQ7jQHXtXso
         AFl5JjqgCGpx4dKJoJUQBKvzRE/2hH7nwDJIlO5i9BU3050BL+J6nVkCiLoeMdSHEDgJ
         2qEg==
X-Gm-Message-State: ANoB5pkCJFFH7ak4Yrz45kBw23yArKaDxa4uRHW0XkbEzBHeglugXCEe
	Y3NsG9pvUj4fKfN+v/or3decV7eIpdMTVEIaG4jUeg==
X-Google-Smtp-Source: AA0mqf5PS1+rdf4Se2L6utKtoQI00rx0sLQNXTa6I6UOwSqAIJHEOf54K+bTLjJRvC7EQFQ2BvAdFPuhgf6aaoz+0HU=
X-Received: by 2002:a5b:f0f:0:b0:6d2:5835:301f with SMTP id
 x15-20020a5b0f0f000000b006d25835301fmr10404540ybr.336.1669098578458; Mon, 21
 Nov 2022 22:29:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221121124150.886779344@linuxfoundation.org>
In-Reply-To: <20221121124150.886779344@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 22 Nov 2022 11:59:25 +0530
Message-ID: <CA+G9fYuBifWjbz7zu_+PwN1hRt9a+57g5P5OS0d9MQ-wKj8cFA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/34] 4.19.266-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 21 Nov 2022 at 18:14, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.266 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 23 Nov 2022 12:41:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.266-rc1.gz
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
* kernel: 4.19.266-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 002bfba64dfd861e50556a611a3378bdca4ac7b9
* git describe: v4.19.265-35-g002bfba64dfd
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.265-35-g002bfba64dfd

## Test Regressions (compared to v4.19.265)

## Metric Regressions (compared to v4.19.265)

## Test Fixes (compared to v4.19.265)

## Metric Fixes (compared to v4.19.265)

## Test result summary
total: 91819, pass: 79207, fail: 1418, skip: 10606, xfail: 588

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 323 total, 318 passed, 5 failed
* arm64: 59 total, 58 passed, 1 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 46 total, 46 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 63 total, 63 passed, 0 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 53 total, 52 passed, 1 failed

## Test suites summary
* boot
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
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-kvm
* kselftest-lib
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-openat2
* kselftest-seccomp
* kselftest-timens
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
