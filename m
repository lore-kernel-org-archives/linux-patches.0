Received: from mail-vk1-f179.google.com (mail-vk1-f179.google.com [209.85.221.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0A3A63CF
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 11:07:30 +0000 (UTC)
Received: by mail-vk1-f179.google.com with SMTP id 71dfb90a1353d-45d3e523a43so127623e0c.2
        for <patches@lists.linux.dev>; Thu, 08 Jun 2023 04:07:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1686222449; x=1688814449;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oT79DiTiFwcBzPo8la5kITvMljqoxHk4MZnGjZJny0U=;
        b=QHkXmTOE7unXIJUKUhRi0JsDMooraLzjqTBjmfpmynhu6pFSPAA1MTXcy/suoFphid
         ZI9KBfZO9Jn4gxpHnfsKE72Rmei0M9A47D/n2Ty4JaKlpwSlwp4kxVFicWPCK7+yFx8c
         /c0kYbPuyrh1ZoBWXn2jM2mLvYgXlg7ISFTSMode52oTNs2mvMSaBs+Wfgk8cOJxyCfY
         vi6lVqWpgQ+dEtxEQjYI1fpAEx3PbnHscFljjs0lHDc3zGae/NL+gBctrHPO1XnkbUOe
         mOTR6u8oD5ROHRMUISJG9jjGD9DOTo4MK+0WkkzScpZTnx/59c2eCLtcT8Vhf6vntZad
         b+HA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686222449; x=1688814449;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oT79DiTiFwcBzPo8la5kITvMljqoxHk4MZnGjZJny0U=;
        b=VFAuPKqPOaKN9nr9Ymld8garqnMzYpZqx56ZWWpWlxCryytoCzUpa9G/cL2Q2GPSd2
         2viUBUwl7L0P9seGDCQbyUsBtSsq31IOC3GPt2cpyEEuel+WvTj+JA9QQMxZaG0CanW0
         fCYXPYVQQaBgslI8AitRsCPjFnplkP+Q98XSMuEBcYwruJsfWICDflMZI/Z/OVW//5q/
         sSI/LkCUw2SUAel8WJ9zQyE7ZkfQRW+HcbtUhJ07ooMUATh+12/Il7DWrcNPaOOGQvWD
         2fqpeKQfvfHPRpt3iBeadkAdYVwCrj5SiyF/7IRps+S/EsLc9DfhIyxGEykpgBzp4v2t
         pA/g==
X-Gm-Message-State: AC+VfDwNofaE+LVXtRtxCSBdcef3DX3NRgupht9oikf1NXpBQ4fXWvpN
	pXVMb34AxCAD24D89i9oC0fQe4KbpDQ4USJ0R8Rtpg==
X-Google-Smtp-Source: ACHHUZ6lnuhTM/MDg8XJON5BeL7R5yqKhWqXoJ16LkyTJFgCSVD+wh45Yvt5D/i41vorKUtaN88vBfjlxvGk+RgRAnU=
X-Received: by 2002:a67:f852:0:b0:436:4da:8d63 with SMTP id
 b18-20020a67f852000000b0043604da8d63mr1784432vsp.27.1686222449260; Thu, 08
 Jun 2023 04:07:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230607200913.334991024@linuxfoundation.org>
In-Reply-To: <20230607200913.334991024@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 8 Jun 2023 16:37:16 +0530
Message-ID: <CA+G9fYsJEG=mZu1rmDpuZ9qmP2AsuZ67URLUWQGRz4w3gR1WpQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/225] 6.1.33-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 8 Jun 2023 at 02:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.33 release.
> There are 225 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.33-rc1.gz
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
* kernel: 6.1.33-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git branch: linux-6.1.y
* git commit: 8f4f686e321cfb99dd17774b45f93d96a16c2073
* git describe: v6.1.31-266-g8f4f686e321c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.3=
1-266-g8f4f686e321c

## Test Regressions (compared to v6.1.31)

## Metric Regressions (compared to v6.1.31)

## Test Fixes (compared to v6.1.31)

## Metric Fixes (compared to v6.1.31)

## Test result summary
total: 111194, pass: 97858, fail: 1305, skip: 11824, xfail: 207

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 142 total, 141 passed, 1 failed
* arm64: 49 total, 49 passed, 0 failed
* i386: 37 total, 36 passed, 1 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 42 total, 42 passed, 0 failed

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
* kselftest-efivarfs
* kselftest-exec
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-kcmp
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mount
* kselftest-mqueue
* kselftest-net
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
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kunit
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
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
