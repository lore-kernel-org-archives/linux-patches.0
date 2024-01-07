Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EF8511CB1
	for <patches@lists.linux.dev>; Sun,  7 Jan 2024 04:53:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="gjCl32eb"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-3bb9b28acb4so918937b6e.2
        for <patches@lists.linux.dev>; Sat, 06 Jan 2024 20:53:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1704603186; x=1705207986; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dl9r2/q2PwhHPnHwLB723Iewv3wGn8s1NZQNePFqWBk=;
        b=gjCl32ebo7gthvOKbrzIiXbZtzPmpGFWc16uWcDIzeAc/3DAkjdhW44tx9OIOhRuM+
         d9mAskLsxllKwxukgwuClnjtrBPL+/RgqIZlqb8Unc6pPVs/6HmMjOvu0gxxPm8n1pID
         ssNpSksMbYujov6LhwxsqGm4bxHSdtJmlBSeGQIgx9y/DG7AMK84unLn8iPSJCRxlKtz
         xdyJHM92VRk7OgAdXN+kAnPwqCozAAYNklUZFDdCTNCuyYMDQST1itfOtSoOhukniXKv
         pOILZPtl8ywW7UrP+aai5BzkV4Nw7wamLNQEFUDKLwxHfF+3/5DG4ZLLMThT+GzGFfFG
         garg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1704603186; x=1705207986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dl9r2/q2PwhHPnHwLB723Iewv3wGn8s1NZQNePFqWBk=;
        b=TrgA0taAHVE+kUllXOD5l8IUYco9exXii45K/DwHroz0IB5obcRDco38hSuJ6TgYb2
         4LoYWvksThKmOs2PIYUq+LM9cmSIqhA/BeVsWOZyG4ICBxklX9F00vwv21LuAQrHK2bq
         U2sHwTE8OWV+2GAlQ3VX5VJ6vY1OkcAslsXb8sgvTaugKKNKvpMTwPp0DciFO9B4nOJ1
         gqaEHynJGvpOBZI9Ai7s+OB0gw3wyQn21Yk7P+aHhrUVnASNwhvphENS07X7/pAsvCS3
         OKQs+ogn2fKlaupaL7XSKso3CueVvuODOuE/u6+e5rWji5SsuvlEtdILdk0TK86Oo5GC
         yHMg==
X-Gm-Message-State: AOJu0Yz43pn0vDRISp3QurYPRbjhwPlLLpoLTGYRJYWa8t9iG3OHsGLj
	fMHduoplK60BAaUons+urG5ohK4JWZWg9JZfp9deNySDUpc2Yg==
X-Google-Smtp-Source: AGHT+IGikCciqYIPubPRPb5hmvQ05w8Ucfr/MdPFC+v+3JAxbueRiPJO9WoD26dIZV3/xQJ5pZsKX5LwlyiBo9mD0Tc=
X-Received: by 2002:a05:6808:5c9:b0:3bb:fc83:7c78 with SMTP id
 d9-20020a05680805c900b003bbfc837c78mr1825451oij.90.1704603186582; Sat, 06 Jan
 2024 20:53:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240106084016.200641776@linuxfoundation.org>
In-Reply-To: <20240106084016.200641776@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sun, 7 Jan 2024 10:22:55 +0530
Message-ID: <CA+G9fYsqWVEHhow8kaCOUQHstT_7r6=7C4xCr4grmCR6mTtx=Q@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/45] 5.4.266-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 6 Jan 2024 at 14:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.266 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon, 08 Jan 2024 08:39:59 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.266-rc2.gz
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
* kernel: 5.4.266-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 27678f7dfd94dacfcf8d721b17324db3f4425487
* git describe: v5.4.265-46-g27678f7dfd94
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
65-46-g27678f7dfd94

## Test Regressions (compared to v5.4.264)

## Metric Regressions (compared to v5.4.264)

## Test Fixes (compared to v5.4.264)

## Metric Fixes (compared to v5.4.264)

## Test result summary
total: 91826, pass: 71656, fail: 2493, skip: 17628, xfail: 49

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 148 total, 148 passed, 0 failed
* arm64: 47 total, 45 passed, 2 failed
* i386: 30 total, 24 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 32 total, 32 passed, 0 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 41 total, 41 passed, 0 failed

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
