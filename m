Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F6462574E
	for <patches@lists.linux.dev>; Fri,  1 Dec 2023 13:14:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ha4+AbYu"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-6d84ddd642fso264689a34.0
        for <patches@lists.linux.dev>; Fri, 01 Dec 2023 05:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701436485; x=1702041285; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0W16F4lcpZ8yLA66z8Ns7cQEkaAJSZRgZlujODAFBjY=;
        b=ha4+AbYui0HItcr3k5lFuV4JW5xhG8aQmBym7i9P/g3cBM62BxBppl2VcPFLdBf09G
         GMb2hxh9vADuahBc6LPFYvWPBqiRlqkAjSHhTOsobijEIvprjeHwLIly4ZxbPYlIwzzc
         mvEWvza66DUdoR4pcdkVSoEMYFUUt7rhrTjtWm6ZGQ66p8AMyuszMp10/Tey2wSrvAuU
         4rCATDSo2hmRWZbQxyrNK0wTYOdsXhh6Bjd9bQ2ia1q3w5QEApDJww73Acql8/HNGKAd
         aVCaIFUhuSjb4Wm6CwJPsPac3Ew7CCgF8mornt72vToBUOSjnP+nnsJ57s+lrjV6Opr8
         LNQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701436485; x=1702041285;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0W16F4lcpZ8yLA66z8Ns7cQEkaAJSZRgZlujODAFBjY=;
        b=DWBjEW+tflzo768IlQwtXbjc+436l7N1pRy3ANoHqY3n8Kq84ZnW5A5MjcnOgAZuJi
         6UC8CP5IJaj4l3+CIsDZr6PA2A3P4QYkL0I5I/PM1d50SK759Z9AVibCj64satXHymTU
         GiFMG18RdCs9QHa+mAn8Qst0/Bi7oALAd9SCCvkliHm5CKkC6P4XwAPOy6tDdpdhxpSo
         xOi9aESEXTuiYmIvC5QNLWtFmUO4Ms5Iks1tnhiTktal2FFgFSnPM40sX4TpRqtbMvUq
         pDnlqypjxpvQsnknJ6zSW9gNHi1Engo7CkphqdmmQ3QANK08PNMZEgY9SPcalz13yor+
         WBTA==
X-Gm-Message-State: AOJu0YzWKPKn+kq45yiy5sd3+tSzQiCnp3Yap0u3uKZbeoD6KUEHof/U
	+nfFisbCA0hV3BUpcRsd99L2wcjgb6bjB7NoZs1CQw==
X-Google-Smtp-Source: AGHT+IFXeQf2TOaP+x86KeVNznhphAjy5NQ2X3ZGv+eAupqFUPllnCV4oSIRSe387vTiOXL/OxelT7sLz3tjjeaLbt8=
X-Received: by 2002:a05:6830:1011:b0:6d8:6c3f:50a2 with SMTP id
 a17-20020a056830101100b006d86c3f50a2mr1432559otp.6.1701436485512; Fri, 01 Dec
 2023 05:14:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231130162140.298098091@linuxfoundation.org>
In-Reply-To: <20231130162140.298098091@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 1 Dec 2023 18:44:33 +0530
Message-ID: <CA+G9fYuaN6uYzfKn1wc3-_9TFAQeRt8mTGi+WwB8WkH151P0FQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/112] 6.6.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"

On Thu, 30 Nov 2023 at 21:53, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.4 release.
> There are 112 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 02 Dec 2023 16:21:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.4-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.4-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: 6ed60a9257c16a5f571b2354c4c0178caa70fc71
* git describe: v6.6.3-113-g6ed60a9257c1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.3-113-g6ed60a9257c1

## Test Regressions (compared to v6.6.3)

## Metric Regressions (compared to v6.6.3)

## Test Fixes (compared to v6.6.3)

## Metric Fixes (compared to v6.6.3)

## Test result summary
total: 154229, pass: 132702, fail: 2283, skip: 19120, xfail: 124

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 145 passed, 0 failed
* arm64: 52 total, 50 passed, 2 failed
* i386: 41 total, 40 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 13 total, 13 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 46 passed, 0 failed

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
* kselftest-user_events
* kselftest-vDSO
* kselftest-vm
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
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

--
Linaro LKFT
https://lkft.linaro.org
