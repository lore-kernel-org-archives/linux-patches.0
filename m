Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4026883B
	for <patches@lists.linux.dev>; Tue, 30 May 2023 07:07:48 +0000 (UTC)
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-45719322ed8so1137959e0c.0
        for <patches@lists.linux.dev>; Tue, 30 May 2023 00:07:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685430468; x=1688022468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VLpyMh96hFjJk11/Uo7I4FKPFMP04G8UCQzgONMEIBQ=;
        b=YO79NXRYABP62UxVKUJ6YONcA2NKlbBZvTyGccupey4ww2VfVKkMdc843M3fbp4JiQ
         awh8f7qjPLPsDzJQ/8lM1v/hxgECOH/oR6NF8n69Q+hVzcWBmLdSJqUhiQJ/xE2yxsoe
         MXrkbmH31B8+gkvatQ9cQ1Vg8DV8zScPvqPKG0DqEZSVmq/nOF6/J7AmDU/s2RGq0/Hu
         5kPDpa1k3q6ORN4+kY81CWmRYkPs8FhqJwA7hh/WwbTVSeqXPirx9+nHL5c8oL77wHtE
         cjal3Hh1aEERoI0OLjRMNAi0+yFhbecmXKCkmbXyCmdx9WFVRWXEMw34JrJKoxmXJwl1
         vXvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685430468; x=1688022468;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VLpyMh96hFjJk11/Uo7I4FKPFMP04G8UCQzgONMEIBQ=;
        b=Vc2+TxC4A0I5crwQVr5tpDfepsyBh/1wyNbIlh2GfjnXjScgWjL5R5hbAc7Ax+UPik
         lI6YAOpT/Gyy+Hlk4Ht1aGrWBdDUHF8gb9LvjilIe34ECu6xLJUkR/IQwVtLxdX7PO64
         oBRORs3AcjzQuuwtVM116DWQ9csC7IWonkTZux7O7OGby1vbBEc/4k2cC9MusuDXJj4H
         PgIzVJh8/8kwcyx2M4d+mAmMb9CZPHiIlxkjb3Ei6P+QgmGKqX+niyJGneteywovviu5
         Q+tTcIiyEaXDxbIVNZdjxdvmnqv92ajgKwXHyLr90jQAsQ2bbrKirMCdLuP+9yxvAi0P
         UgKw==
X-Gm-Message-State: AC+VfDyC+hkUGiwqY/VVoLRqLG/lV9NngX8lahU/ROKwD/tOXQoFreiD
	LAgcBds4yFdmEV8hu7RHA8/j516/ceyXY1jYkZrmkg==
X-Google-Smtp-Source: ACHHUZ4VrrEzmMQt/EFcxyn62VWIrFRlsCM1XDb49nZYxttxqpPGiS2VWYRlzOuJ3lvN2nPoMKQxuQvBhMX0PaiFsXU=
X-Received: by 2002:a1f:c192:0:b0:43f:c71d:f027 with SMTP id
 r140-20020a1fc192000000b0043fc71df027mr233888vkf.12.1685430467679; Tue, 30
 May 2023 00:07:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230529153919.729418186@linuxfoundation.org>
In-Reply-To: <20230529153919.729418186@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 30 May 2023 12:37:35 +0530
Message-ID: <CA+G9fYuXGcMEBjWZXnq9TkUUDvz_bZKdTQsVXoVkbgmbkB4Jnw@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/133] 4.19.284-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 29 May 2023 at 21:10, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.284 release.
> There are 133 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 31 May 2023 15:39:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.284-rc2.gz
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
* kernel: 4.19.284-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: 1b63443ed3b068004bf5bdb7451c000bf9935589
* git describe: v4.19.283-134-g1b63443ed3b0
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.283-134-g1b63443ed3b0

## Test Regressions (compared to v4.19.283)

## Metric Regressions (compared to v4.19.283)

## Test Fixes (compared to v4.19.283)

## Metric Fixes (compared to v4.19.283)

## Test result summary
total: 82189, pass: 68966, fail: 3533, skip: 9548, xfail: 142

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 111 total, 106 passed, 5 failed
* arm64: 37 total, 32 passed, 5 failed
* i386: 21 total, 18 passed, 3 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 6 total, 6 passed, 0 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 26 passed, 5 failed

## Test suites summary
* boot
* igt-gpu-tools
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
* kselftest-x86
* kselftest-zram
* kunit
* kvm-unit-tests
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
* rcutorture
* v4l2-compliance
* vdso

--
Linaro LKFT
https://lkft.linaro.org
