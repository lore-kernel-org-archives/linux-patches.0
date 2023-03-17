Received: from mail-vs1-f41.google.com (mail-vs1-f41.google.com [209.85.217.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB575374
	for <patches@lists.linux.dev>; Fri, 17 Mar 2023 02:39:25 +0000 (UTC)
Received: by mail-vs1-f41.google.com with SMTP id v27so3311410vsa.7
        for <patches@lists.linux.dev>; Thu, 16 Mar 2023 19:39:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1679020764;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cZXKJRO/ZggC2mXpqbpxtVf2k9v50K1x7j3WyViEayE=;
        b=mHNNrVf+GDtmtczH3QmLWHA1DGriYNTyjIrwwyXJUnJqiHKJw7TXNmrYzEc4PsXkZD
         gk08baXQGJ98LypxVWBCJyQP0//15V6hL9d2VYl8g+W8htS/wg54wJ6Sn70DrNecO9jZ
         ZPeqxCfG16ElSbXjWL9T13fUyYVFJNHXZHFtEdAF8UXr3tbmPSkeP9rZ3FIPXD60cLNL
         s3Vc3KsLtAKy3OJcg01+uXaZhJFJ5cqSS2b/pJI4fq5pmX5hGNXmyf62TIgJ3pr8wxJB
         YABZZh/XGE9YGAh5SiAcxo657ypyRT6rBuqi/eWeI3y0AVGc6fdkqZMEGAGpiv53JrO1
         /7OA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679020764;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cZXKJRO/ZggC2mXpqbpxtVf2k9v50K1x7j3WyViEayE=;
        b=sJwHJsoH/MAPDQy7OLfVRHmYXv6DKSbMRX/ExyKBgUwfmplVc0Do7EYj2Q/VyDSkKu
         8lC9aS3igs8g3XjTWnBRhCFvADTfDYmQUlp/+HcMJfSPpP99nBXcMYEtHWHVEzVaRdqC
         IYYlsdNt/W0IZRHJeOnR6Scm5OrhhUrsxOAFHXN2pi2GUwTeToYkK5Dgybtve/IFcUld
         fULIQv6Jgonn1/XejVqEHf9kUq/Fzl1Aobhx6I9i9qVN/OPkWx1SOpP6kjGouB/UMbLI
         uLTOiL5wTwviGhIDHFVe2ykPsuxtpk2RcHbcgJKKyze6vHJiFhIuzfmx4ktl6BpYzx12
         4mwQ==
X-Gm-Message-State: AO0yUKUuARBD01smy9bPCpOHs14AKsi2mKTVKSh/vbBleuuhpi6RqpUf
	QelNVN5QLi7xJqryL+B5arT6nn1kz2uJLmEwQI9kiw==
X-Google-Smtp-Source: AK7set/kStiIWe+2oSWgU239Nwlj0tiPpBThKwnwpMyzzVvkcPWJgyJg8AhcYC/U5ZfQa55OPo1+JwwiOoNQJY0kbSQ=
X-Received: by 2002:a67:d493:0:b0:425:f1d7:79f7 with SMTP id
 g19-20020a67d493000000b00425f1d779f7mr39613vsj.1.1679020764391; Thu, 16 Mar
 2023 19:39:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230316094129.846802350@linuxfoundation.org>
In-Reply-To: <20230316094129.846802350@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 17 Mar 2023 08:09:13 +0530
Message-ID: <CA+G9fYvVwjJcQ_JJ_om4Z-CvOtwQe+qy6tMu5qFpkuvJMudpng@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/27] 4.19.278-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 16 Mar 2023 at 15:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.278 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 18 Mar 2023 09:41:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.278-rc3.gz
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
* kernel: 4.19.278-rc3
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 0233a363477c634e1ba87559073eeab4b8fac88e
* git describe: v4.19.276-32-g0233a363477c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.276-32-g0233a363477c

## Test Regressions (compared to v4.19.276)

## Metric Regressions (compared to v4.19.276)

## Test Fixes (compared to v4.19.276)

## Metric Fixes (compared to v4.19.276)

## Test result summary
total: 90635, pass: 68730, fail: 3044, skip: 18533, xfail: 328

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 201 total, 200 passed, 1 failed
* arm64: 42 total, 41 passed, 1 failed
* i386: 29 total, 28 passed, 1 failed
* mips: 42 total, 42 passed, 0 failed
* parisc: 12 total, 12 passed, 0 failed
* powerpc: 51 total, 51 passed, 0 failed
* s390: 15 total, 15 passed, 0 failed
* sh: 24 total, 24 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 37 total, 36 passed, 1 failed

## Test suites summary
* boot
* fwts
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
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-vm
* kselftest-x86
* kselftest-zram
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
