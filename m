Received: from mail-qk1-f170.google.com (mail-qk1-f170.google.com [209.85.222.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCEFF68B61
	for <patches@lists.linux.dev>; Tue,  5 Dec 2023 17:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="z5hUqOWL"
Received: by mail-qk1-f170.google.com with SMTP id af79cd13be357-77dcf6330f3so246385785a.0
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 09:41:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1701798088; x=1702402888; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dlsdvKux8KBjo1yORhCzPi/wYEemn58vl14vutNt5b8=;
        b=z5hUqOWLsAL2exB4Gg2OvlNuv4SFy+akmpvWzWl7GOp/etovJSc48d3N/3zLjVVpMp
         pxL0bnq75WVMF1Q3VeSBCH+lTOHzunW0GICAhGx+YXCJ4pbzo2oozgiqAcT/6l9IgrrJ
         Y9OyYLDeiiAZiJw/YSV5S1aH/LpcjcU8yLO5k011zOg3tPOnIp9F7UjdaC0HORJPsBu0
         1q67XZiqzKYRz6TDh29+jQNsG4Ou7Vf6b5chRL9EIjr6/nme75WFhAn+A1NiilcHLoc1
         ZPvTa8o2p32uKh39cp2Ahp1tpkvlormU5qRP3g08zr6uFoPAm2g0Qbg2/pm6rg2OC9k/
         UTpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701798088; x=1702402888;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=dlsdvKux8KBjo1yORhCzPi/wYEemn58vl14vutNt5b8=;
        b=gT0JTANtdrFii+zLadO+KUpNkwJQgQfDxBQZVCwKyTqbTp243uyzeKV8yRzchg/QsH
         hM39/GTm9XnuqkIPlPEQ16154JH7u1kAVDWYNERVAULonJ+bf+glCFIY3EMB5nftBMiI
         SQICM8Hlh+dH9/4jdlFH4BAzAc1ftQhJDCU02VjuDZ7mgD51bQFtTzK+ckcptWwXb0I8
         56BkEbLNrmzJyIL7B7/6J98CiceQtBuJcgtL+B2k/z5YqXK8N/tqdpLdbxK+nAxIQjiy
         5Ba1S+Ivo3tU3I2fhhF6j1rliWBIu/uC+eTuu3QSVdGrGL67xA4Z5zfuamh+XQF7aFMh
         ly7Q==
X-Gm-Message-State: AOJu0Yyd53Tl4tqNqo2BWQjJPophKoTnBNjFgsYtzyL5bPlCBEQUPTYc
	sK+UOV2QsbdLJQU72xina78+K4uGfgwxyQEubgj6lQ==
X-Google-Smtp-Source: AGHT+IFxKRofhiHifghODSTOLmVOMB2G7Zc0olaleLmeblEItlygcVU8ag+EwNQUW29QQ8ODXdmcuIsP04W3EjkQWXg=
X-Received: by 2002:a05:620a:888f:b0:77d:795c:71f8 with SMTP id
 qk15-20020a05620a888f00b0077d795c71f8mr1229948qkn.19.1701798088473; Tue, 05
 Dec 2023 09:41:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231205031535.163661217@linuxfoundation.org>
In-Reply-To: <20231205031535.163661217@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 5 Dec 2023 23:11:16 +0530
Message-ID: <CA+G9fYsezgwb2W8ngoKELKxR7rxrOCzpxzixY3CojKrZSLkJ2g@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/134] 6.6.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Dec 2023 at 08:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.5 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
x86_64: gcc-8-allmodconfig: FAILED
 - https://lore.kernel.org/stable/CA+G9fYuL_-Q67t+Y7ST5taYv1XkkoJegH2zBvw_Z=
UOhF9QRiOg@mail.gmail.com/
 - https://lore.kernel.org/r/202311301016.84D0010@keescook

## Build
* kernel: 6.6.5-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-6.6.y
* git commit: b0b05ccdd77dde3d5f44e6849679a2af2f3af0e2
* git describe: v6.6.4-135-gb0b05ccdd77d
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.4=
-135-gb0b05ccdd77d

## Test Regressions (compared to v6.6.4)

## Metric Regressions (compared to v6.6.4)

## Test Fixes (compared to v6.6.4)

## Metric Fixes (compared to v6.6.4)

## Test result summary
total: 144804, pass: 124361, fail: 2511, skip: 17803, xfail: 129

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 145 total, 124 passed, 21 failed
* arm64: 52 total, 44 passed, 8 failed
* i386: 41 total, 40 passed, 1 failed
* mips: 26 total, 26 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 36 total, 36 passed, 0 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 13 total, 13 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 46 total, 45 passed, 1 failed

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
