Received: from mail-qt1-f175.google.com (mail-qt1-f175.google.com [209.85.160.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF1129AB
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 10:04:09 +0000 (UTC)
Received: by mail-qt1-f175.google.com with SMTP id y15so13348320qtv.5
        for <patches@lists.linux.dev>; Tue, 06 Dec 2022 02:04:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Ii1fTE+B02kfVtUTWpDYQosbbT5K+0NI1XuF1R/MCCE=;
        b=dhOEM8rgUZjh90uESoYUwHv02KL7KiHiuxQ7zoPPEy7IMGZSCCNVbsDKjeuSV/Lga8
         L2Ywmt4cZzGGfG488vrgGvB7YFHZazDfY50hSZd39cmCuzkEtIFrO/YVawXeqFpXzBS2
         Mc9aluVPH7oGA1HkQ/S4K7ri6o8wTBRDeLGptCsFa2RbXCi/Kyn5cZ6sYiCdzp20iYUy
         hVaWtZmLwlML86q2/2MNkrJv5Or6hSEPdk0wDbccTHUemsKSLsapMqMSO19kiue7y30I
         nEOUuaRV+X7y+V9T/MjkqXaVnL7amHB2GII9JLtuCBs2vynu9JJLXHsjsFMy3Vs5Q9PD
         qWlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Ii1fTE+B02kfVtUTWpDYQosbbT5K+0NI1XuF1R/MCCE=;
        b=k2q2pfo7M5IT4usRq+DpMMwcFG5hHPB2zIOswF9/aw+jQt9DeY0Mz43xQmD4/Rihft
         hsgJPvjQk+VRyhxeCkU5FucA+7octihTMNC8lnHAruG75ZY0S5Kn3yTkD9DKSOD8rWOc
         JlV0pOU/3DvWHwnohq/1rGNfONzY/rb0/0azMWduSz5snjKUZSdSMUmCQPKrEfKVrhPI
         Q73rhvhaFQFxTlA7u3Hfm7Zbyw/OeF8KypRpNlLGXMbriMo+TGqQHsNnlZgEmcRJQiUO
         IAym3OXoM5f2mxOWYiMQgLiwtDU0YPa9LC478hcR0XYb7t+jp1l61vxHEtP1FEAbNcUM
         YMAg==
X-Gm-Message-State: ANoB5pkwNskMqA6fKSjH3zFCd/R6408yyR5JwkyCFw9g2AXFk0mT6oAI
	gpm+o+J79MgBtnPnRWIV09rXZrvY4nIWFUZ8++8SyQ==
X-Google-Smtp-Source: AA0mqf7QpGTUSQHW2gfK/riBI5yp8z/XTE3+oNB2O8uaDwm3d0hZnLgAvycxQV9I897+5I6nxcYR3XMfQ5TE+FqHQLo=
X-Received: by 2002:ac8:148a:0:b0:399:a020:2aa with SMTP id
 l10-20020ac8148a000000b00399a02002aamr63446862qtj.247.1670321047785; Tue, 06
 Dec 2022 02:04:07 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221205190808.422385173@linuxfoundation.org>
In-Reply-To: <20221205190808.422385173@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 6 Dec 2022 15:33:56 +0530
Message-ID: <CA+G9fYtR6RV8YkWe+QkLyFkNegLJgVHZafTAH8AnQyUcCnT_7g@mail.gmail.com>
Subject: Re: [PATCH 6.0 000/124] 6.0.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Dec 2022 at 00:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.0.12 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.0.12-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.0.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.0.12-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.0.y
* git commit: cdf2cb62aec478b66cd531a340a5e3b58a782252
* git describe: v6.0.11-125-gcdf2cb62aec4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.0.y/build/v6.0.1=
1-125-gcdf2cb62aec4

## Test Regressions (compared to v6.0.11)

## Metric Regressions (compared to v6.0.11)

## Test Fixes (compared to v6.0.11)

## Metric Fixes (compared to v6.0.11)

## Test result summary
total: 137036, pass: 120940, fail: 3015, skip: 12818, xfail: 263

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 147 total, 144 passed, 3 failed
* arm64: 45 total, 45 passed, 0 failed
* i386: 35 total, 34 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 34 total, 30 passed, 4 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 38 total, 38 passed, 0 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
* kselftest-android
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
* ltp-ip
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
* perf
* perf/Zstd-perf.data-compression
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
