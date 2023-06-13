Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1189A566F
	for <patches@lists.linux.dev>; Tue, 13 Jun 2023 09:02:55 +0000 (UTC)
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-78cc6ec0ba1so512126241.0
        for <patches@lists.linux.dev>; Tue, 13 Jun 2023 02:02:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686646975; x=1689238975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=V8GrSifCz49aZ98QowmS7zz/X3J0dQxhH0/1YzTAdAw=;
        b=h8SlbE594Rls0nWuMPFh2Utq/W24JSKrwAxh+0DqkqXVnG9Lt7MKBXyoW4YuPNrq0C
         KTk1ajaTCwCIeVgbwcxNx2KzHueJh/xEoSTcH8pXw+wES4AxDvKNcajX0LMPbFdMN5iA
         JYKsvcWk1HpX6VoSpzv+xrNJ632GM9jOWVuh2jFmn2/nN4DRvrJIQyDFeje751MV2f7h
         DwpAk9h1sTpFLB7brurFiar2PWGP++cRq/22QXyPYhr4u0mmo0chK0aEMV336bjiHywN
         tKTIjtZbN2ku/IkB6g0BoNN95cnlvuMAJiBrpFPoo4VhGdiT/nz1Ja2UtKuJTSONggCB
         Vq9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686646975; x=1689238975;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=V8GrSifCz49aZ98QowmS7zz/X3J0dQxhH0/1YzTAdAw=;
        b=HCkmSYFRe3WttjNawUlbDaaghri6v1LOQgxSTWLSR0Xpv766l8sRltDOXkN3ZVUmb8
         xBeSqi4mEkHjjHtTDPcAgycleBO0JLaUrtezispsTf19RYGTzwQKloPf0ttfHa/ez6fR
         2AJNR31jxjGyVv3EKWIQaF5dnq1Q7U0FnPnHnoeFa1zIrT6e2BYUdfRmilPce5vUlI9T
         SLSxNhdmSP40JgRg03DUwExtkCFpcSknl6cMRVc2FAdga+N18GizIoD1/ConeJD3zYbj
         EZnAdfqtdTfnfAmHBF00Ff3MhiauRTw+JCt7L0Zp/z+n6ldxmtgt+JTKzbSQai9e95hi
         LpCA==
X-Gm-Message-State: AC+VfDxuQAv3VwviCkFFjecNgPId4wjF+qhYUJWtIwK9cGoswc2icC8j
	ZFlfuiUtIkSZO5sPOwpn0mQDgabCRjr6FrYziTX6RA==
X-Google-Smtp-Source: ACHHUZ472ELf3akgi2xGU5AUTtDTUzVkI5rji7GVrCbWRiQMLRH3A90uY6PmW7WUt4aWW5rOkqxSveRWwYed681zXxE=
X-Received: by 2002:a05:6122:a17:b0:456:f5b7:837c with SMTP id
 23-20020a0561220a1700b00456f5b7837cmr4935535vkn.1.1686646974684; Tue, 13 Jun
 2023 02:02:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230612101658.437327280@linuxfoundation.org>
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 13 Jun 2023 14:32:43 +0530
Message-ID: <CA+G9fYsp+5r2F8asPXzvsAq8_JYuezL+qYnj4VN3oH0T_bP9vA@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/68] 5.10.184-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 12 Jun 2023 at 16:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.184 release.
> There are 68 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 Jun 2023 10:16:41 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.184-rc1.gz
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
* kernel: 5.10.184-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-5.10.y
* git commit: 32cae866b1825021bd263dbd8dbb522e1d0df8a6
* git describe: v5.10.183-69-g32cae866b182
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.183-69-g32cae866b182

## Test Regressions (compared to v5.10.183)

## Metric Regressions (compared to v5.10.183)

## Test Fixes (compared to v5.10.183)

## Metric Fixes (compared to v5.10.183)

## Test result summary
total: 127773, pass: 107744, fail: 3845, skip: 16007, xfail: 177

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 116 passed, 1 failed
* arm64: 45 total, 43 passed, 2 failed
* i386: 35 total, 32 passed, 3 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 26 total, 25 passed, 1 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 36 passed, 2 failed

## Test suites summary
* boot
* fwts
* igt-gpu-tools
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
* kselftest-livepatch
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
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
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
* vdso

--
Linaro LKFT
https://lkft.linaro.org
