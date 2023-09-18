Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB2C28E0C
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 20:57:08 +0000 (UTC)
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-4963a2e3aa6so2795027e0c.0
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 13:57:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695070627; x=1695675427; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=g7HIuecrhu5r9aHSQmQWLOoPGbrYoLIj45CPxPWw+d4=;
        b=GY9qbqbWbnKx6/9/gQCnBseG7pid0KHf3wkNJHd1ge/k/9Aie1FPxe0MScqfGGi59R
         CA6IS8UsLwmW2O8zBIwEZbXVlr9ugaSWVoZsHcsLb+5p6/L9LGTJxDvVt6W3DpWi8Kbp
         KSEAPoa76WGBPE2ti9HeI5YcTiwh81Us0fajhAYVOXbO89Jm157bWIA2j5Tzi0uZ+y6/
         wNU6WCRBU1sMGd78wF5y9Toju9OVBsk3FFRoPMyPtsiCkb8rmNrptjhsTQ5kYxJYPzsh
         rWOx59nW6UufftfJNUPW0Oi1RdxoED4zlqbWXePTxQVRFqIvb/ji/ossTwI2eIEWmJ9A
         F1Kw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695070627; x=1695675427;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g7HIuecrhu5r9aHSQmQWLOoPGbrYoLIj45CPxPWw+d4=;
        b=JKYZbxEY9QLSBOaREe08Cb+Gwt3XUlXu2TOPNNeBMQvRHGltpSkTalu1U2pcmjSC5J
         JmwxepScGWXLWuca7AbaGPGZ2TOgRzyE0E+ir/mllDoVTZXzT/MjXyqKlHQLLXkel7OB
         YQ+a2rALc2GgFH8SfZjRgnUhCO5O9Tq02d6RptPcnMMpBom59OLTTVL573u8cKtAuX6j
         72y3mlVGzkUmC2TQgwVXJvQ7rgYAVVKFJ0GfhIEEtJIVk3rLlZrb21jykzsKFllmnBbI
         HUH9h5fjKhIp48rZjmhEQbC2SWtSVicMaogDkthGiulr/YGq3SpxRouW0KYd+kJfhESP
         +tbQ==
X-Gm-Message-State: AOJu0Yya/ejqRWyIUWqnFF2bU7nGeb2VVf9ZRSrXUwQbgkrxTOaFTKAC
	HEYot/PBeiRj66fNqgolmbwyIWhHP17iBRLz9f1azQ==
X-Google-Smtp-Source: AGHT+IETthXK4kpJkr3Nqn++h7nQNja9kGkbPN70yjl8ZqaStFD6X4yEiZ5/Mrbu4I58Zyv2h4DaAo4uwfDROlim1HA=
X-Received: by 2002:a05:6122:4682:b0:493:7ce8:9851 with SMTP id
 di2-20020a056122468200b004937ce89851mr607642vkb.8.1695070627549; Mon, 18 Sep
 2023 13:57:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230917191040.964416434@linuxfoundation.org>
In-Reply-To: <20230917191040.964416434@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 19 Sep 2023 02:26:56 +0530
Message-ID: <CA+G9fYtP+n7P7Nx-kb6wzRNb=nJ9ZW5faQ6s_vH=JQBHoqemvg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/219] 6.1.54-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Sept 2023 at 01:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.54 release.
> There are 219 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.54-rc1.gz
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
* kernel: 6.1.54-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.1.y
* git commit: 89fc7c511aa5cd0b21e82ec42611db04d9e3b7c2
* git describe: v6.1.52-813-g89fc7c511aa5
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.5=
2-813-g89fc7c511aa5

## Test Regressions (compared to v6.1.52)

## Metric Regressions (compared to v6.1.52)

## Test Fixes (compared to v6.1.52)

## Metric Fixes (compared to v6.1.52)

## Test result summary
total: 206086, pass: 176646, fail: 2859, skip: 26303, xfail: 278

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 284 total, 283 passed, 1 failed
* arm64: 89 total, 87 passed, 2 failed
* i386: 67 total, 65 passed, 2 failed
* mips: 56 total, 54 passed, 2 failed
* parisc: 7 total, 7 passed, 0 failed
* powerpc: 70 total, 68 passed, 2 failed
* riscv: 28 total, 26 passed, 2 failed
* s390: 28 total, 27 passed, 1 failed
* sh: 26 total, 24 passed, 2 failed
* sparc: 14 total, 14 passed, 0 failed
* x86_64: 76 total, 72 passed, 4 failed

## Test suites summary
* boot
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-drivers-dma-buf
* kselftest-exec
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
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

--
Linaro LKFT
https://lkft.linaro.org
