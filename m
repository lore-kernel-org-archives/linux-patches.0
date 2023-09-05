Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D6E11FA4
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 09:03:15 +0000 (UTC)
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-49351972caeso138101e0c.1
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 02:03:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1693904594; x=1694509394; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=t5qOg4HkZB7J4a0HNsI8RkNIcR0paBtfkrDWP5S65t4=;
        b=eRLrfHXfHjhEFr3rzQKNaa+knwXg8a+rhU5oDUNYQAL183sbAz+nohWVprX0fpmy24
         JsqAVLOj3JFyJ4HPJ81fyPM+QNK8X+CgnzZA6iOiSNim9DwohXTN9wZYxbEmrM6NrTp/
         o0r02cZS24l0zVXBTiLC+Hcy8bGxXjxZ4IJno2WC4+exXaZxqdZp5x5JmQYMZuh0f2jR
         wntDJMaE3OVw/Jf0HK17bxmL4LVHueRcZIh5taBpYc1L1yGs6TaHm/bFxH4cebq2q/NG
         TSs3ZjLpHZqOcU2iFBXnnTQj6gP2eq2aKrus0R9fa02ys6FWrvAhza0dokJho6aNPOie
         sEkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693904594; x=1694509394;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=t5qOg4HkZB7J4a0HNsI8RkNIcR0paBtfkrDWP5S65t4=;
        b=UYeXU0jrxBZFFXvlqJIUqrXe8yoxKhDQysJ9CzSBuM80YbfUWINWy80DoDFM0JMbOJ
         GdR2ajJAZVomJZnloW9s3fAK7N1hTwm4BuTpJR7ZpL0B7R1pVESdRpHC1mAQHFHU5pC3
         0qKBdnxA+8djVrnrqXd/seytodv63pj0U6dCSWhOXy2vCjAsIYezceqRhx1xL743XxsT
         nIcB1ci7YzZvoSx5Pvg4krv9MjQ15GivlJPgimaOF322t5GvFFsFZHLNJcZOZA5I7Pcf
         +/in8IFOVTE3AeSQzE7lOIABsJouVvmvC/weK0tlgMy2B2Op+zIpnfdHy8gtXyoxDr7M
         7u8g==
X-Gm-Message-State: AOJu0YwdQZkIiXEk0ihfwaT1A9Y/iaDYNrahIjrxxoR1P07xBkcOJbwZ
	8A1KuXTM7tr0+IeY96W6lRbRrx1Z87Pv1Ara5lQQcg==
X-Google-Smtp-Source: AGHT+IE/JeKQpe2NYCRMXps9nPwUSyozHnjM8BHFtGiJZJvehyehLDv7iP4ytqnn/heiMGqrtQ38a31EpDrLueylcQ0=
X-Received: by 2002:a1f:4946:0:b0:48d:ae0:c53 with SMTP id w67-20020a1f4946000000b0048d0ae00c53mr6148810vka.10.1693904594042;
 Tue, 05 Sep 2023 02:03:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230904182946.999390199@linuxfoundation.org>
In-Reply-To: <20230904182946.999390199@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 5 Sep 2023 14:33:02 +0530
Message-ID: <CA+G9fYs9uetjpoAhVoTXPspGTs7x6BGoXWq8BuDKpx-06oHKLQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/31] 6.1.52-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Sept 2023 at 00:05, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.52 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.52-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.1.52-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: d0abe9b6003aae74696bf546c325193113e4b56e
* git describe: v6.1.51-32-gd0abe9b6003a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.5=
1-32-gd0abe9b6003a

## Test Regressions (compared to v6.1.51)

## Metric Regressions (compared to v6.1.51)

## Test Fixes (compared to v6.1.51)

## Metric Fixes (compared to v6.1.51)

## Test result summary
total: 123742, pass: 105963, fail: 2366, skip: 15262, xfail: 151

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 146 total, 144 passed, 2 failed
* arm64: 52 total, 49 passed, 3 failed
* i386: 40 total, 38 passed, 2 failed
* mips: 30 total, 28 passed, 2 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 37 total, 35 passed, 2 failed
* riscv: 14 total, 12 passed, 2 failed
* s390: 15 total, 13 passed, 2 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 42 passed, 4 failed

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
* perf
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
