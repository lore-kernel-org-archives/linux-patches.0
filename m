Received: from mail-vs1-f44.google.com (mail-vs1-f44.google.com [209.85.217.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44B022106
	for <patches@lists.linux.dev>; Wed, 11 Oct 2023 01:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GITIdSO3"
Received: by mail-vs1-f44.google.com with SMTP id ada2fe7eead31-4545d8a95d9so1886289137.2
        for <patches@lists.linux.dev>; Tue, 10 Oct 2023 18:40:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1696988420; x=1697593220; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nZUcgeMqW4j0qmYpGncXU307vj/5x4QTOabyiFdBv5Q=;
        b=GITIdSO3rzh00/fWeyjrtvjftDoKYIZubLYVGVRDJ7jpqwGQTSekS3PmPDZu4ceGZK
         G3T1gWL8FT92g9CgFIg5ts/dLM6vMFaSfg//H3+2SxXczzHvdkMjutLWDHnVWPIjYZLd
         k0H3pAd+Lqk2nRNvz7qsR8+dSHwx+D9wAM+hgwOGsRD6jv/B09YYBYotAknTSjnn0+0K
         rt2l5tl53/FXxZfpGwe1XsX5kVJl7G97Sce2U2gLFjHmRY0+KaOdDQqpPvCoLLx/Av8I
         kNHCQDBWScxJPAFz+3yZbMlQLQeXxSo/lPkXmStPavPYXHLpWtUVvpaOwj/UpN19fVBT
         0aDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696988420; x=1697593220;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nZUcgeMqW4j0qmYpGncXU307vj/5x4QTOabyiFdBv5Q=;
        b=GctnLPYMqHCOXmsyedBNXyg0AfDN1Gg6ulQD2wIJoRjOUA+NPCOgVtNmZx2/bBGKtZ
         Jir6/wylZNXkEn+NlRrwo4Rhm8n1nsVkzN/rSGX1p7nUNIOk5ZDc/hltd3VY1+zIzK+M
         F0NvWh2jEx4v/fBAgFFAt5i56WFYO0njIOSa5PSui9As7fzxZQ79F+j8bTNaZzzataNm
         A5D4L7bsNnzMXvrbJaxursZovgnSuLgwe6iTuLOU1pyA8qn8wmguOqeqbgqgQZR0D+EM
         xG+a/F4LzFizulyY0MSrobF00YORzm7NBOn0KUeACepC1p1Os/f7GEkrJ4r7LNn6afnA
         jvaw==
X-Gm-Message-State: AOJu0Yy4K0GagpUyShvQhthjgQJdd4F2ZmSrxPyt2e8b1qqTCjDbFIXS
	u1Sb2m228nCTN5MLgMjgCyjp/MZnnrzwIN4/ku1RSg==
X-Google-Smtp-Source: AGHT+IF+HQ9gLlPAlSdTrM1vC6Ktp8o6WJGTzvACfha7LWwpG5A1F2kT3IPJCCDyf0XGjJnGSJ6+wR77xh91rnkIKmQ=
X-Received: by 2002:a05:6102:3175:b0:44e:9351:e4f0 with SMTP id
 l21-20020a056102317500b0044e9351e4f0mr14155105vsm.22.1696988419994; Tue, 10
 Oct 2023 18:40:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231009130126.697995596@linuxfoundation.org>
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 11 Oct 2023 07:10:08 +0530
Message-ID: <CA+G9fYsQAMM9yntr1EQpJMGWvLWfegUrN0fZH2bpcVdGiOepVA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/226] 5.10.198-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 9 Oct 2023 at 19:06, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.198 release.
> There are 226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.198-rc1.gz
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
* kernel: 5.10.198-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 18c65c1b4996e3f6f8986a05eceaf427355a7a4f
* git describe: v5.10.197-227-g18c65c1b4996
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.197-227-g18c65c1b4996

## Test Regressions (compared to v5.10.197)

## Metric Regressions (compared to v5.10.197)

## Test Fixes (compared to v5.10.197)

## Metric Fixes (compared to v5.10.197)

## Test result summary
total: 92938, pass: 73992, fail: 2587, skip: 16291, xfail: 68

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 115 total, 115 passed, 0 failed
* arm64: 42 total, 42 passed, 0 failed
* i386: 34 total, 34 passed, 0 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 4 total, 0 passed, 4 failed
* powerpc: 26 total, 25 passed, 1 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
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
* kvm-unit-tests
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
