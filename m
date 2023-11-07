Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D37B1328D7
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 17:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="mxwX1GcW"
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-4ac211e5bbbso1979791e0c.1
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 09:13:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699377186; x=1699981986; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=KVC3cGQbEFz+dQCqTPnVhvAdjiW2xkZ2vnB8oAFmTNM=;
        b=mxwX1GcWFY0EEKByQdCic7Cn8xNRdBfaeaDKZVzOBi24c/ToUu/t5vkQFXRy5ykn0W
         RfJ1ogDbmo6SiwK2T1x8+ualOtNpc5m+XCR+ubPTWxpKQqWJ/wiCLGpCk81nAZj7olrq
         ebhLxXWY3dsgpDuXS2+mETZG8i/ezfJ8TFF7RPOM/mZ5lRHSmTFvvQT0cd4ctRrBi/Nm
         0J4605iFuluUOByHPBPmUB2jZ+LWDeIDUVRDzKaGkh8VxqxDmWngQ7DnSWirZnIlrYzv
         cAtDri2OseYMeq9sxObjiN4KJ0/LdyctbwXvlL1vW3gMf4qy7pxbToz1qWX1Vv02YSkH
         lLhA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699377186; x=1699981986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=KVC3cGQbEFz+dQCqTPnVhvAdjiW2xkZ2vnB8oAFmTNM=;
        b=McZtAW9HN14n5WwPGGHm4mkBrp94Ze2k82i1m2nZpfnztGwUTmrY3I32z6qQi9kVoT
         brLGd/ypiIQXnB0P3KbXue5lRFt5W82veVncimbnVejHePTUSo5fwoNRG0J14Tdwf/tU
         GZ+C371/aRyFtcf4mrpOTwVy74ZzM9Po4mnbVWpt3scl7qwj3KFMbgmCfpBKsCpBM2pq
         i906OcF6WJGo+eX3c2G50wrOvpArnGHsHKj2Y3goD8RcbMKdV+lMoztnDFBBkF3u5sPY
         NlaeyQiKr/4Inp5f1uD9/FEtAFeWoqsZxVKLNRza+SvBHdrFDuT7AzRNs4qzs+K/Hy01
         Gh6w==
X-Gm-Message-State: AOJu0YxsKYYzGxMvMMuObo9dXWHhC/h0UCDlKnua3UDDNMR5F1mEUsRq
	u23Hr2JGpGH9AztDULWTg3V7p8q91hl93+fspysVXg==
X-Google-Smtp-Source: AGHT+IESAzaTZcmCSo+AqlIw8EsKuiwj1gvadL2MYwVnIdVv+QeEHXXXkFFMxLvJsNjMPcqKDIvBXtFEr4fAqnkVmew=
X-Received: by 2002:a05:6122:459b:b0:49d:7af5:1973 with SMTP id
 de27-20020a056122459b00b0049d7af51973mr1661157vkb.3.1699377186503; Tue, 07
 Nov 2023 09:13:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231106130305.772449722@linuxfoundation.org>
In-Reply-To: <20231106130305.772449722@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 7 Nov 2023 22:42:55 +0530
Message-ID: <CA+G9fYuAx18L7jQk256ykJBNoeEC7r77S6OrOzXdAyXy6-kvvA@mail.gmail.com>
Subject: Re: [PATCH 6.5 00/88] 6.5.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Nov 2023 at 18:46, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.5.11 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.5.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.5.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.5.11-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.5.y
* git commit: 73d52afec3ab4d2fede2bfcd5e386ef12e6181ba
* git describe: v6.5.10-89-g73d52afec3ab
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.5.y/build/v6.5.1=
0-89-g73d52afec3ab

## Test Regressions (compared to v6.5.10)

## Metric Regressions (compared to v6.5.10)

## Test Fixes (compared to v6.5.10)

## Metric Fixes (compared to v6.5.10)

## Test result summary
total: 137604, pass: 118888, fail: 1923, skip: 16686, xfail: 107

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 140 total, 140 passed, 0 failed
* arm64: 53 total, 51 passed, 2 failed
* i386: 41 total, 41 passed, 0 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
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
