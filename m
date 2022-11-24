Received: from mail-yb1-f169.google.com (mail-yb1-f169.google.com [209.85.219.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C93772589
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 12:47:20 +0000 (UTC)
Received: by mail-yb1-f169.google.com with SMTP id e141so1712647ybh.3
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 04:47:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Y6QLJpBSCH7lpOdOsR2ZwXVrv94Ei5Yr7j2glkp/jcA=;
        b=c8Zwke3OdjYbjAlNEQ55zjHP22QXuVPQPkZK7G2kiM76pw6FL4oNpsukNvkZECDx7I
         Zo1MKCffaZ/PawQmDK21Y3/Pz9Ts5OLVttQNHIzT3/j1WYqJZmSqp2B2l3uSDqXlVQVi
         TAfySksc6o43e7PqR4IdwlIykzf87IbXkbDVzX/7oKVocv/fnC1Lgy7YF52NC/2nbLe2
         GcDOvg/gJcd7JCpsoIfBVBj4Kz/y8YYaSgm4tey9XciaCsHpsAJsc2p8f4L+7D0HhZld
         zVT4keR3nOZRoMb2Y26euaPUzmL7oD8zW21xj/azZQOl+vij56zc0fSQ0Kdg5R6bbiKi
         nCAQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y6QLJpBSCH7lpOdOsR2ZwXVrv94Ei5Yr7j2glkp/jcA=;
        b=MnBj8yq5gqO6n7wJLp00sxolOjFXEuOkRsiavbimYqpoXJpGT51362uWUKIIofTRb7
         mAHCh3EMhVJYdpHIIWc5kGFB3v3tVPf0jLFXoK4wDtEtjMkIelALQUJZ+Sbcqp0tIlGk
         cHHAvkdyVeSWWm7LgiMKjKB0s2ZBlOZ9Jm7al3I6pT7TWZGRPTp8ttvkkBxEMTtpyad1
         pz8H5UnWxyhFeHtyIlosjBiahjvNUMadgcjsY1NE8XCHSWtigD1q6Bn0AXJquJ3rUKvg
         JQEpDedU8hoeRFH8ERBfj/rh6ze7xP745QwyyiYjsB8h+sIsuPYb3jqnHIWoVZf/CL1u
         4yOw==
X-Gm-Message-State: ANoB5pkyBC7BW349Kmx50RRvbTyNFqRwKcT6iilQGMppSsyDO6oTeSMN
	ZiMfbzxoeJ2SRNWZvwdP3arjhTyqB7CfM9M9TFcX1A==
X-Google-Smtp-Source: AA0mqf6QBzAv5uVzptgRx7B+2rSN/gsGzHPQX8Kdpq2XZCuIOsiCUmh1PwTzXHDalSnoTK/IBxSbd/1zfcwKMQLODu0=
X-Received: by 2002:a25:ed05:0:b0:6c4:8a9:e4d2 with SMTP id
 k5-20020a25ed05000000b006c408a9e4d2mr31702068ybh.164.1669294039388; Thu, 24
 Nov 2022 04:47:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221123084548.535439312@linuxfoundation.org>
In-Reply-To: <20221123084548.535439312@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 24 Nov 2022 18:17:08 +0530
Message-ID: <CA+G9fYsy7RaE-vMGVMQeNg0KTRBvfrg+D1cRfAtdjP5-fx3O8g@mail.gmail.com>
Subject: Re: [PATCH 4.14 00/88] 4.14.300-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Wed, 23 Nov 2022 at 14:28, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.14.300 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.14.300-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.14.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.14.300-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.14.y
* git commit: 7e961be09da0fbde0eb6b4948a0bcd12b84a1248
* git describe: v4.14.299-89-g7e961be09da0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.14.y/build/v4.14.299-89-g7e961be09da0

## Test Regressions (compared to v4.14.299)

## Metric Regressions (compared to v4.14.299)

## Test Fixes (compared to v4.14.299)

## Metric Fixes (compared to v4.14.299)

## Test result summary
total: 81944, pass: 71704, fail: 1341, skip: 8273, xfail: 626

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 313 total, 308 passed, 5 failed
* arm64: 53 total, 50 passed, 3 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 41 total, 41 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 20 total, 19 passed, 1 failed
* s390: 15 total, 11 passed, 4 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 51 total, 50 passed, 1 failed

## Test suites summary
* boot
* fwts
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
