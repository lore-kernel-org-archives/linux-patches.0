Received: from mail-yb1-f175.google.com (mail-yb1-f175.google.com [209.85.219.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA2B1867
	for <patches@lists.linux.dev>; Tue, 15 Nov 2022 06:57:53 +0000 (UTC)
Received: by mail-yb1-f175.google.com with SMTP id j2so16151094ybb.6
        for <patches@lists.linux.dev>; Mon, 14 Nov 2022 22:57:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=oepuDSJrpTbqZQNEqu7I0fwnW4/YSZGuESogruzpg5Q=;
        b=knlwIzTGgEIrAPrftSIdgCxWPKpheE7M67Oqqkz6ZE21fUXpjVvattjHeNmBRLuLdQ
         Y2HAJ22PuC1c3iD75u9KOPgAgA4VNRuptkORhQd33z/q9jOdRVfWnUE1FvNrvpKL+6TD
         YydusemqY9t+sXBHjoDfiVQj0gqdLjST2T3zTKvBy95TrLD8SqfkttM7io6pEktqPwL6
         JJadLBFKls3NEVeUGghXzH4BRbqeo6N/Ciz5SbjjPY/OxZc6Tiip6j26ouXReiWsfHWd
         6L3Uf63ghWYgGcMJ9cxrEUs5mg5QTb0Crcrbp/woYi0FGRNIdRJ5BsSiaaD2obQAIJ4r
         NTeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=oepuDSJrpTbqZQNEqu7I0fwnW4/YSZGuESogruzpg5Q=;
        b=bS2wKuZ39gaX1lZKENvJX6v0y9fJO+UCxnEdAaFTUG3yKN3CgX8OjA3lcgWy8Qrh5M
         KpANg9usZbPqAdBQcoLWoYu/yBpi9Ff9dYaHBZavajHrJOmaHqdRQ0m+qUzZSrtUcsQc
         xz5mcJiHRtbRRVsMmcEFoauO9pdupxR4vbPEukVHmAOGiZUUW9A1oHfIuqg0MS+03DXy
         jSoAAVBNaKIlpETN+/LrF+xF54JGPhuAVMeu+bc3C/npAOwAua5VkHuA5nsv5YaQTpym
         bLLb2hnGlOhs2eIfxbTwi+Y0DDflkgDbGjAZDUb5uwWq4JDGvHnpjCLx0QtmhL4jdrLT
         AUHQ==
X-Gm-Message-State: ANoB5pnf1kllCZhUeL6AaUt2IuAaLEB0U9D4GMMc19ssRENNHXXOS0VN
	E+FHO5amiTDgWlkHGym/8JN9kMSmrkkTTgz1Mn855g==
X-Google-Smtp-Source: AA0mqf4T8wvoKdrJyp/6DKFZA+QsOSY/8MqcrusDB7x/SJqNicHk+0wwCM3Zw3bKpIMx5V+xgKLeiu5wh1tPRRV9vL0=
X-Received: by 2002:a25:b119:0:b0:6cc:60bf:a33f with SMTP id
 g25-20020a25b119000000b006cc60bfa33fmr16263274ybj.534.1668495472358; Mon, 14
 Nov 2022 22:57:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221114124458.806324402@linuxfoundation.org>
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 15 Nov 2022 12:27:41 +0530
Message-ID: <CA+G9fYvA+hGXNmOVMYwN=GsQ6yjkNW3bOUHuqzxWi+JUUFFVCA@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/190] 6.0.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Mon, 14 Nov 2022 at 18:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.9 release.
> There are 190 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 16 Nov 2022 12:44:21 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.9-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.0.9-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.0.y
* git commit: f8896c3ebbcfcc053d9c27413bea3af94c01fd71
* git describe: v6.0.8-191-gf8896c3ebbcf
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.8-191-gf8896c3ebbcf

## Test Regressions (compared to v6.0.8)

## Metric Regressions (compared to v6.0.8)

## Test Fixes (compared to v6.0.8)

## Metric Fixes (compared to v6.0.8)

## Test result summary
total: 70795, pass: 60088, fail: 2510, skip: 7975, xfail: 222

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 289 total, 283 passed, 6 failed
* arm64: 80 total, 80 passed, 0 failed
* i386: 71 total, 69 passed, 2 failed
* mips: 54 total, 52 passed, 2 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 68 total, 60 passed, 8 failed
* riscv: 24 total, 24 passed, 0 failed
* s390: 24 total, 24 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 76 total, 76 passed, 0 failed

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
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-
* ltp-at
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-etlb
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
* ltp-math++
* ltp-mm
* ltp-nptl
* ltp-open-posix-tests
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-syscalls
* ltp-tracing
* network-basic-tests
* packetdrill
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
