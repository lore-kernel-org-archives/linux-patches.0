Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21361FA4
	for <patches@lists.linux.dev>; Wed,  7 Dec 2022 11:28:43 +0000 (UTC)
Received: by mail-qt1-f172.google.com with SMTP id r7so3246901qtx.6
        for <patches@lists.linux.dev>; Wed, 07 Dec 2022 03:28:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=c8F6zuUbnnWX6FbXjZkqcfyxeunydod4ZZtHAFDkt4o=;
        b=MA0XEoFCJTXFG5RUybSr7AhZENvexNlpYrPT//vHNLyaskzWf1lGvgQaq5FCNwcC3+
         oQlVc5pSUj0puILpM+bzL8YdNa2O3VHDID35WaFi7ZuvxcO1enD/zn/pgv0Eq58pWAJF
         synNDcfAud98K+vvVzoBOvuHNBHMh3JlnJ/SebLx9aJr5zvVDafgK+EM6Mj3wdKFAtN1
         GGoIBgd8sT9QxUq53bt/mwBNwMUb4ydter7QKarrqKUkfMfM25ACMxK+ja4GLIe8/GTy
         okmqSoFwXLUGUsXsSmSfhYpAmwd1CvscnvpqRdW1EwdRUC4iWE59gQtE+IEXE4LubUXh
         rGvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=c8F6zuUbnnWX6FbXjZkqcfyxeunydod4ZZtHAFDkt4o=;
        b=xCviZDh3ElGtq5zUzQRM4+++ZYuiJ/hZGiAnKJE6MZhVi9s2we1ybNFME/zyhQ3xUc
         lg3+T6qOntHjR9uSuBzRbPk8VyFk0fqM5+whRM+QJ4O2MaZTfT/vgO1GMIp5jGJvMaPE
         kCny1/Wc/J/xscB7G/FK/QF7fFOe8QYOvgufAGvxk6NXbNa+yxEcIQqkdvwAWiDj9TwQ
         Ywct9QjWEXWOp7vUMTuV7aoLKa/AQpk5ZHGuQwn1fFrjvbM0exHA3crv8pRkQydF1Mji
         agP4SnrsZkYqZkhgANfDoswBZOwAmEw2HdqkMKc7b2/oUkLKcwWlTRYT97RjffTcZvp7
         Bgpw==
X-Gm-Message-State: ANoB5plMuH4ky7Jm5ac9Pruxu8QguDvs9Xhas4PDHB4TRN0x5YhU6cpH
	IMxlPzzpzAuK2PHfbcQ51DWC3PnbnsrEJNrjrprQjw==
X-Google-Smtp-Source: AA0mqf6aRmzdWZl8DjEsLb5UWfJsO5sYcvlu4aJXx0h+FRnKY9DDMqDc1ivbkTWM7949CU9Jc84t3QbwEBKb6jGJ0Hw=
X-Received: by 2002:a05:622a:4ac9:b0:3a5:ae7:9ada with SMTP id
 fx9-20020a05622a4ac900b003a50ae79adamr66967856qtb.191.1670412522083; Wed, 07
 Dec 2022 03:28:42 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221206124048.850573317@linuxfoundation.org>
In-Reply-To: <20221206124048.850573317@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 7 Dec 2022 16:58:30 +0530
Message-ID: <CA+G9fYtXnk2q8V5OH+UQv-4z9D_8qHEz5DPrwh7n4eMfPyMn4g@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/96] 5.10.158-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 6 Dec 2022 at 18:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.158 release.
> There are 96 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.158-rc2.gz
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
* kernel: 5.10.158-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: 8dca57ec68a7eca30ce178d858b45748b2a65eaf
* git describe: v5.10.157-97-g8dca57ec68a7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.157-97-g8dca57ec68a7

## Test Regressions (compared to v5.10.157)

## Metric Regressions (compared to v5.10.157)

## Test Fixes (compared to v5.10.157)

## Metric Fixes (compared to v5.10.157)

## Test result summary
total: 61785, pass: 51491, fail: 2027, skip: 8109, xfail: 158

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 151 total, 148 passed, 3 failed
* arm64: 49 total, 46 passed, 3 failed
* i386: 39 total, 37 passed, 2 failed
* mips: 31 total, 29 passed, 2 failed
* parisc: 8 total, 8 passed, 0 failed
* powerpc: 32 total, 26 passed, 6 failed
* riscv: 16 total, 14 passed, 2 failed
* s390: 16 total, 16 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 42 total, 40 passed, 2 failed

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
