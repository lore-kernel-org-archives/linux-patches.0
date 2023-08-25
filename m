Received: from mail-vs1-f49.google.com (mail-vs1-f49.google.com [209.85.217.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195A8D2FD
	for <patches@lists.linux.dev>; Fri, 25 Aug 2023 12:19:58 +0000 (UTC)
Received: by mail-vs1-f49.google.com with SMTP id ada2fe7eead31-44e8f9f3cceso395868137.1
        for <patches@lists.linux.dev>; Fri, 25 Aug 2023 05:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1692965997; x=1693570797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eWVoS962+5v+XMJivPj4ADWDoZA4XJSt9iO3IWvAP3I=;
        b=zVuFIpyHDuk3QWOS/fSRWIeSSe4JP4cXr3RPZ/vEjXsa93xfKC+8m0/g7tf6DMamqB
         458JfYLk5nbHGiSGosW/V0BvggDryG3PzsPsQEKeyM7L2Xlil/iJA+7RBq2s6KvFaWle
         8aMVmoqstfs7qkU5BLiBvZ3BB/3zhWpmRb5+yCuwRk5U/n4tVK0c1fnXLNEME1Q8QIcl
         7M1BVepJRq4AHWH2cZpS0HMBIOx0lnXl/2vPOPMdjJyQqx8Lk8m1jfFgtvC6DUi8jIPA
         H5cWxJUb3F0Pf9eJqKeN0X4BPZdfLQCIexWBFzEgEWPAJw/nZq2MaZwQnKW3RorkFxJb
         5/6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692965997; x=1693570797;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eWVoS962+5v+XMJivPj4ADWDoZA4XJSt9iO3IWvAP3I=;
        b=fl0IjpUDyK4riciJ/k+vZqAyCSSUT09B0y8fLyadxjPv7EwbxNcqOuPoRzuHaFOMIJ
         jbRDoCF5odKzxq0eC1OnsVAHw6UB0Eghk8I6OIEVj75hr5yU6j2/qnWxtYg1S657TkcE
         e4qYoQGOd0NVUQp03q2t6qdnfGIRmE7wYBUXBKsv1/K5KreYz37v52bHQ+xDfKa8shWY
         khzVHHA92ez94oNz64APHtrIeoX+YQcPL8KRADHm5qOFixYIcTxTl4lSjV2xX2pSJVvJ
         N9XBjMvLyc1rw9DlXkx+sCy+dfR0or6dyIyEThAj3elHpkc+eGqF8YBQVEsSXCAf9PPV
         fDjQ==
X-Gm-Message-State: AOJu0YxQ6KZFUGcnNN8WKcbmdWoWwTbqgrBcPkuoSuhaWa4oxPqPVb7T
	o/nXnmpVuna7YyUW1TGODQ+EsnA4k4OzAx3+wJAt0Q==
X-Google-Smtp-Source: AGHT+IGAzBJu1U4ZveBua1HdVCYaS9q1v7fDgzyHKuP8pRC5Ec7GO9UGe/UxaB/YLIaSbVFA4rzWdorcSNnyZyhc7aw=
X-Received: by 2002:a67:ce15:0:b0:44e:a18a:2514 with SMTP id
 s21-20020a67ce15000000b0044ea18a2514mr3193080vsl.33.1692965997673; Fri, 25
 Aug 2023 05:19:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230824170617.074557800@linuxfoundation.org>
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 25 Aug 2023 17:49:46 +0530
Message-ID: <CA+G9fYurCBZt7Q3fU9NtXrBUHXzCTAY6g+xsu_BzU7nxNcy2DA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/135] 5.10.192-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 24 Aug 2023 at 22:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.192 release.
> There are 135 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 26 Aug 2023 17:05:50 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.192-rc1.gz
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

NOTE:
1)
LTP syscalls chown02 and fchown02 test failures on NFS mounted filesystem
on arm64 Rpi4 will be investigated further.

## Build
* kernel: 5.10.191-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.10.y
* git commit: da59b7b5c515edab9a57efd37b031b5b97e6c1cc
* git describe: v5.10.190-136-gda59b7b5c515
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.190-136-gda59b7b5c515

## Test Regressions (compared to v5.10.191)

## Metric Regressions (compared to v5.10.191)

## Test Fixes (compared to v5.10.191)

## Metric Fixes (compared to v5.10.191)

## Test result summary
total: 98769, pass: 80650, fail: 1588, skip: 16473, xfail: 58

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 116 total, 116 passed, 0 failed
* arm64: 43 total, 43 passed, 0 failed
* i386: 34 total, 34 passed, 0 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 4 total, 0 passed, 4 failed
* powerpc: 26 total, 25 passed, 1 failed
* riscv: 12 total, 11 passed, 1 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 36 total, 36 passed, 0 failed

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
* kselftest-membarrier
* kselftest-memfd
* kselftest-mincore
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
* perf
* rcutorture
* v4l2-compliance

--
Linaro LKFT
https://lkft.linaro.org
