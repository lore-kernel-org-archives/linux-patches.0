Received: from mail-vk1-f171.google.com (mail-vk1-f171.google.com [209.85.221.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E047450EF
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 21:10:05 +0000 (UTC)
Received: by mail-vk1-f171.google.com with SMTP id 71dfb90a1353d-493a661d7b6so3901919e0c.1
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 14:10:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1695071405; x=1695676205; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fGyy1dLZvQWY2khpmZDJDrrkK5+L0RBN0UD0GvrVsSQ=;
        b=XVD/iy+kfuVwcZ5d+m8SCjym4WchPnxs8RoqIp/umvin92JCZw9mhsVZfSyUbfn8nx
         Yf751H3eAvZL8qKs/HAP2oe1JnHZqWg1GstuK+Cp5HcnJzhQCGg1nXufk10iqNV5RDxh
         NrxYAqYO0vNd5A2NH2Bhp8Ahmz5biGkrFzBJotLy2AuTiHrkszFPgdo2KfMFRcdbVIrA
         IlABR7n/ZV8S6SkmIOTND25Fahez7+y1NWf9FM/KEJEaqxJOECr7/g0L6xkDbg+W3SEs
         xHu9eKLVmdFkE8ltvWu5RTcWFqyGN4iwfTkeggzhuokuggMGBJDMXJHeKtYfByqtYuSw
         Lm8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695071405; x=1695676205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fGyy1dLZvQWY2khpmZDJDrrkK5+L0RBN0UD0GvrVsSQ=;
        b=QMDHt+UgmQTU1hKfq3qrSNBMPr2/GqWa3kMTKajRmIP3qp/OfVzJOvr3PfNuGsmWSO
         HbqTz7PXtpmBjJeEsIJn1QvXlChd0D5khzE9bhAnnPDUfXHbpzf01/I04RIk6Hgm6TfM
         WIFVoXh5MHh+UV2cwGzH+QQqDP7wCWEsFR7jFCxcGDFrliFXWXjltNjZ5kAg6y7tp5WU
         2wkxjDqkBmAP5dLl/whF7ZSxD137nGSGqqKBFumXvpK26vbi6PvNYn37mfnYx+h5hclR
         BQD67Fmm6217s9IiQeluOdOP1Ohmeu/gvkRMWCA4yXURZoJlHBBvS5tYxQZPf1IPf2G+
         0U1Q==
X-Gm-Message-State: AOJu0Ywv0slBvGCvnFtJ0bhirjYKpyeP4Kix2ghMebiGE1bGh8LIUDJH
	/+cRMhzcqqsI5IatpZbr/H7MwH3/zoCyCmnXjce6dw==
X-Google-Smtp-Source: AGHT+IHWXN87NID162xsRwF1TcA1ezoFYpSyGoOq+JUSMd1jr2lgG69g4Lg2h0B8AggAIrPmikVYWjfv7XtvB2iu3m4=
X-Received: by 2002:a1f:ea02:0:b0:48e:1463:914e with SMTP id
 i2-20020a1fea02000000b0048e1463914emr457962vkh.7.1695071404718; Mon, 18 Sep
 2023 14:10:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230917191113.831992765@linuxfoundation.org>
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 19 Sep 2023 02:39:53 +0530
Message-ID: <CA+G9fYtYniwcnL3yi30o-krrb0wO_4tb5uj5wyoxFaF=2abQXA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/511] 5.15.132-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 18 Sept 2023 at 01:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.132 release.
> There are 511 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.132-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.15.132-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: ead88697522a847255e61a898bf924d37d65ee3d
* git describe: v5.15.131-512-gead88697522a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.131-512-gead88697522a

## Test Regressions (compared to v5.15.131)

## Metric Regressions (compared to v5.15.131)

## Test Fixes (compared to v5.15.131)

## Metric Fixes (compared to v5.15.131)

## Test result summary
total: 88627, pass: 70361, fail: 2511, skip: 15669, xfail: 86

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 114 total, 114 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 32 total, 32 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 24 total, 24 passed, 0 failed
* riscv: 7 total, 7 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 35 total, 35 passed, 0 failed

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
