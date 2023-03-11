Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B49E7B
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 07:11:39 +0000 (UTC)
Received: by mail-ua1-f49.google.com with SMTP id g23so1483002uak.7
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 23:11:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678518698;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D9IQYwTv/WihtT371pEBgPh49LwJU7wNx5c/eqHzu8M=;
        b=q+o7EkCrTVEmipUmMGg5mbaHNsEzv5AD6m2GHtexzfSSKWVtBvW0rGcd7YPX7ZMp3+
         5ID1KAua7rvEs6p3G3xbVWxuZD8ZWKb9/YyMEc9SCoC6PO8xUd0g3KZPYLIv8/sOPLEp
         Qu/oN5dDS0E4IKuaQKupKX/Eox4E8begc4HO/XwK0yvC6uGqpMmYYmkY6iU9ac/0OqO7
         q0Eibds305HngAEezgUxIHMUbK3Z+K23sv+psb6KyBEND1PdP8YmJSrEwJOhFp8+BA6c
         0KRQlGkg4WD1v1qKpn2n0GUK+0xwmOubSCS0ljyL/b/eUPWG9fjynQoWMh30CiLZvcKc
         l9Tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678518698;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D9IQYwTv/WihtT371pEBgPh49LwJU7wNx5c/eqHzu8M=;
        b=7uVx7P6PM56FTjPumX3/y0Vin/oP44wNh9WBztGWnuFY4U9d4wrC7kmVAPwQo5r9J6
         Cy3swtJJNHf9PYUAID4WiIvZrTtTYhnOYw1BivisW8gjxEHxHQ0S9zDVNxJOugNOm5Rt
         P7uDAv7zQkdSUDAzAfDPcDlmFpf6YX2+Vgpab4IlYSLbiNhil34dalzW9ZsQ7YjeKJGK
         y+kkbIAaOh8cmEIZxNFWLbtUKERFHhXKEjeN2NdperrIqHAgTKeeorhbyQOSybsS1iB6
         f5DHzrfc9NwbRbW1sq+P2rBl4Y2YzSVgbOFoXUExUMeQnq0a3M7NvtZJL+fAL3exPKFP
         fO4w==
X-Gm-Message-State: AO0yUKVfWbHU7X7Vbs58YSpVL8NSZC8fXV1aDPCAc5N2WKu5Cnp5ZzxN
	G1QSgMXn1djQqp8atKV8PrdSTqbcUuAKl8QjKN0KNQ==
X-Google-Smtp-Source: AK7set985Ze+dpq3+X1HM7bI73/6P7JqK4L6qawz579lcA+9g2siLvk9XM+IdfgZqL/TVQB+k5y7cLS2RXGhRojjO5A=
X-Received: by 2002:a9f:314e:0:b0:687:d8e3:6835 with SMTP id
 n14-20020a9f314e000000b00687d8e36835mr18594988uab.0.1678518698161; Fri, 10
 Mar 2023 23:11:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230310133718.803482157@linuxfoundation.org>
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 11 Mar 2023 12:41:26 +0530
Message-ID: <CA+G9fYu3kGKV_3ruv0zi4znRoNyjV32yUoLBy4MdDuc2WjpB-g@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/252] 4.19.276-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, 10 Mar 2023 at 19:45, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.276 release.
> There are 252 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.276-rc1.gz
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
* kernel: 4.19.276-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 70b2ca70b378b14ffbcd349d80cdfc361e044b01
* git describe: v4.19.275-253-g70b2ca70b378
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.275-253-g70b2ca70b378

## Test Regressions (compared to v4.19.275)

## Metric Regressions (compared to v4.19.275)

## Test Fixes (compared to v4.19.275)

## Metric Fixes (compared to v4.19.275)

## Test result summary
total: 71771, pass: 52887, fail: 2333, skip: 16246, xfail: 305

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
