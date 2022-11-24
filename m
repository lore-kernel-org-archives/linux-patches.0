Received: from mail-yb1-f182.google.com (mail-yb1-f182.google.com [209.85.219.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ED721FA0
	for <patches@lists.linux.dev>; Thu, 24 Nov 2022 10:38:05 +0000 (UTC)
Received: by mail-yb1-f182.google.com with SMTP id 7so1346864ybp.13
        for <patches@lists.linux.dev>; Thu, 24 Nov 2022 02:38:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qs4UbLke9/Onvxx/Ghxtpad0Bs7asJ2wPLuCypYEUdo=;
        b=kYZS80blcT8xh3GsfUaHzZMqcdm6KDHKenr7bFjhUaHn5B4U67hGX6KBwJyiyS3ynq
         CL7OX/D3yoBnMwLt7fhKlSLy7gkzafLi4g5SeddCHG1XC6ZeCzfiQQKFj8VNZ3B41rt6
         VOVtM3GsDbeRk2OpQOV3R/9Dm48izwEou4I8RRI0J+8hu5SSrqOdhld9kXjzpvCkkUx+
         2vo9KJWHBSPHgLZxNX/ZsY94ieI32tcMz7yA3+NsaxYR3fRi1SWw6fWs3s9z04CJMoiG
         Q4Jrdd1N9ZVY9rl9OTQ4b0iIaxzrBXHH5IEdjvoFtHuyA9Q0qIp30OnxBgmvNhpFvUWh
         4xkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qs4UbLke9/Onvxx/Ghxtpad0Bs7asJ2wPLuCypYEUdo=;
        b=PnP+NM9KyKGkZbN02WYZ/AsKufc4e8KZP/q5BztxfZOZAfVF5xYFwyeHIaM1cSE3Gr
         2ppP/UwpYEDEwAOqqU7CXYSTtSGGf4i00/cKEE8TLx3DFYVbPqBvJLrq09MhM7Ho13mJ
         3bMnxnfJCrUv/I8GWKlb63B2gP7YEhJtsKibpK4e/DAH7B+YghlyxVPCD96VlTAuMwgI
         LmKPEtsgLbHZCCgjngStOzT49/K3hYgzhU3AHn9as9GEeWKUI3SNOW+hWVd1M1QlE37n
         Kzp7s/U/EMX9jirUvXwmRmizDDRGFO1oVyFhh0XQ+kw+aFM5kCzHfr2NMuVJLDIgE6Le
         eimA==
X-Gm-Message-State: ANoB5plPDP29sY2UbZX0uw3jnctUUg9JB1doBksmOxlmFati45Lejklz
	Ev3X4EkDYyiScbIOY7kBMg+Wo+n98aHV1+atoxKd3Q==
X-Google-Smtp-Source: AA0mqf7QgXlzU8LDdBzz4hOd2MCIZqWXbA8iVgKS80JsYnDINsFD52ee36E5wLylGaupj3BPHYpS01tTi9d6IHW2akc=
X-Received: by 2002:a5b:f0f:0:b0:6d2:5835:301f with SMTP id
 x15-20020a5b0f0f000000b006d25835301fmr20262055ybr.336.1669286283903; Thu, 24
 Nov 2022 02:38:03 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221123084557.816085212@linuxfoundation.org>
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 24 Nov 2022 16:07:52 +0530
Message-ID: <CA+G9fYsyx+8kyfLgDEBo6NEGAC6Sp20XKY4RYO-P0TCELLCdXg@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/156] 5.4.225-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Wed, 23 Nov 2022 at 14:41, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.225 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Nov 2022 08:45:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.225-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.225-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 3e1fbfce73e530cef2817a20a79506d24f6fadde
* git describe: v5.4.224-157-g3e1fbfce73e5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.224-157-g3e1fbfce73e5

## Test Regressions (compared to v5.4.224)

## Metric Regressions (compared to v5.4.224)

## Test Fixes (compared to v5.4.224)

## Metric Fixes (compared to v5.4.224)

## Test result summary
total: 103239, pass: 90351, fail: 1558, skip: 10990, xfail: 340

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 146 total, 145 passed, 1 failed
* arm64: 44 total, 40 passed, 4 failed
* i386: 26 total, 20 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 37 total, 35 passed, 2 failed

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
* libgpiod
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
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
