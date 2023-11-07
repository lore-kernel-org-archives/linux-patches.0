Received: from mail-vk1-f176.google.com (mail-vk1-f176.google.com [209.85.221.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7FEA34CF0
	for <patches@lists.linux.dev>; Tue,  7 Nov 2023 17:58:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="vO8eI+34"
Received: by mail-vk1-f176.google.com with SMTP id 71dfb90a1353d-4ac28cab4efso1313436e0c.0
        for <patches@lists.linux.dev>; Tue, 07 Nov 2023 09:58:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699379932; x=1699984732; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5wKYIjRk9u20OhZbZz7Pq1pTPus6RUsjTNPft428Eb0=;
        b=vO8eI+34ncanal9im5t5TOJJEJR6sU31JlQw454P2E2cnbTDaVSMAB8Hg5PLQF7gek
         KGfKx17o1QyKNY0C+oGpxxXHdgJHERcp87Ds5Qwrs9gQZK0xy19L07/b2GntbgsvhylB
         LHSgtRMRPaCS5WygrCYbXpMHZXlFySMld9TuBphhlBAYvV/bheh2DonQ/wnEMZBMnPsc
         iXkGFnqqoXPqfbavVe5gqk16FTpTzHvPDCL6Ub7/2ox1m4YSSvaAgShqKrna7hcU7KtJ
         o5+C4vNQ+F33rb0qhe4VBujSHiMVhyFY+RgrXV3jD+xXVR3n/HG90OS32+ipRbL6tPsV
         O7pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699379932; x=1699984732;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5wKYIjRk9u20OhZbZz7Pq1pTPus6RUsjTNPft428Eb0=;
        b=b2aYXPK1ysOnCOJ70ZVzytma8xxzJ6lMOQvRsNECgUe0MXz0npKqbLybh9yLbnqQAl
         FSyEHC1kbtBpp60wLD/5THna0Q9Na1PaCpSuNgKPy8Vlcj8nXlYadLQo+YA1rSsURTXW
         X6hrpIwe1dg5Sxa76FlI7ScdNs5MtF+pSgm0OeRxPgywe1Uc4O1kwpNvs6XcTip85TZW
         M4zjWAMuuPLNcpr4s9NsA/yXSWDMrLzel/izNtqXYcw7yJcKSlCofs1GN/HtzGgbXlEZ
         qZ/FgER9I9hUbMlqiz7B4Ir0l7XkzC838SYPz2RYhfONFMeRDxq4v1ixNiOkS+3eFcZS
         JF7w==
X-Gm-Message-State: AOJu0Yy+rjAP0XOAk1FxMReDkIFYbXjU6EdJdrIpNc3XcH5J3IvPqcWh
	KD6QBzqh04SSbkS+caC18VrgESf12396a/g/x3oTGOSjEnBtxZb04DY=
X-Google-Smtp-Source: AGHT+IG5z26zY9vVz1AkbSL2orZlMYhnkYNGVSG4XHuqY9aiXHOzIeMDrxyV8LUdJIIQzoww6sJgQ71i7mUkiFxgGZQ=
X-Received: by 2002:a1f:2f57:0:b0:49b:289a:cc3f with SMTP id
 v84-20020a1f2f57000000b0049b289acc3fmr29050940vkv.3.1699379932606; Tue, 07
 Nov 2023 09:58:52 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231106130309.112650042@linuxfoundation.org>
In-Reply-To: <20231106130309.112650042@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 7 Nov 2023 23:28:41 +0530
Message-ID: <CA+G9fYtp3fh-jrU3pta_PeVRTrLODdbWDtJE5ppxUZu+Ek6fDA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/128] 5.15.138-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 6 Nov 2023 at 18:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.138 release.
> There are 128 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 08 Nov 2023 13:02:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.138-rc1.gz
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
* kernel: 5.15.138-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: ec134bfabca018727b246a05cbd7d2da66864974
* git describe: v5.15.137-129-gec134bfabca0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.137-129-gec134bfabca0

## Test Regressions (compared to v5.15.137)

## Metric Regressions (compared to v5.15.137)

## Test Fixes (compared to v5.15.137)

## Metric Fixes (compared to v5.15.137)

## Test result summary
total: 90364, pass: 72614, fail: 2502, skip: 15189, xfail: 59

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 111 total, 111 passed, 0 failed
* arm64: 43 total, 43 passed, 0 failed
* i386: 34 total, 34 passed, 0 failed
* mips: 23 total, 23 passed, 0 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 25 total, 25 passed, 0 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 11 total, 11 passed, 0 failed
* sh: 9 total, 9 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 37 total, 37 passed, 0 failed

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
