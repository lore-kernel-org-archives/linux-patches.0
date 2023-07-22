Received: from mail-vk1-f175.google.com (mail-vk1-f175.google.com [209.85.221.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBD5398
	for <patches@lists.linux.dev>; Sat, 22 Jul 2023 10:57:36 +0000 (UTC)
Received: by mail-vk1-f175.google.com with SMTP id 71dfb90a1353d-460eb67244eso1170282e0c.1
        for <patches@lists.linux.dev>; Sat, 22 Jul 2023 03:57:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1690023455; x=1690628255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x2wGJF9wFfobg+vF6u4qnpyWGtTXV20qhchnCIbOz4A=;
        b=PDKPDITECpPuUu0xGVlXOjnj4eN9+g6JcqkUngM9N8gyq7u2YUux+MBpDyPPAvw2ik
         zaETHHAuJs80jYfSL8WJ65EKXm+N/5D+4/upe0LUDPodhzjskAq5ksDUDob+mda3z5OX
         1wAPecJIOZda6iP/qdee2kN3jJh2HkEI1hFHiqyQcbqhE3gM35SJEItvVlVddQzSn1PL
         y1Aa6X6wF7NrUlNyYRtupE+6f8GqyT+Q3gyrRvZFSUoN0/3ETX9tP18mGyrvBPl9bx/V
         oX55DBcu7JCKRE09MVmHrAy9U9HXmcUvmbRVf+KYZ/Cky7ZQuFD4vyQlzoxfD5jLbFFf
         5lnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1690023455; x=1690628255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x2wGJF9wFfobg+vF6u4qnpyWGtTXV20qhchnCIbOz4A=;
        b=Xn2qTlDkESa+d05WQAQ11llyfXUcCKwTvAKgEXwWbUdlrfVFJyQyksp+KGhu2Jb/Vw
         ilVRELCzwe3DZal5625Vml+QHmZTXM6DM9TGoW2b9kN1Ip2Bw3kH9NErLraLK9u0aGKm
         4QTXGwomAIRLax0X0Uo83ynJSYpo97rMdMgtdA5053mWun5CFTqh512Z0Amy37fnjarI
         DuaUXtxiONc4IjvKhvEvydy5KaZGnxEVWUZXWd16ezCG0qIqmtvxLbxwyzhkqCw/xT5i
         FeixMs6P3trQItSjlGFN18ulChek06JCfIsPGcjB3K39aieL27tCpWRgve8bd3och2Vd
         Zrqw==
X-Gm-Message-State: ABy/qLbrz9une/vJ8VtaggkoP8koi2pB9mUqYaJPxEgiyAnQcdxQOqkc
	ogoEGcwFJsbE8JCDtft36uWrRQjxKYgDAywsOPT3pA==
X-Google-Smtp-Source: APBJJlH4dPL16gkptTTXCJlyhdltEG4bhs4yZORHL01GMhiKavaQZQPkS23juOjPhrWvr69K2eHSf6QsWtnQFq+nKlg=
X-Received: by 2002:a1f:d345:0:b0:485:e984:779e with SMTP id
 k66-20020a1fd345000000b00485e984779emr259007vkg.2.1690023453359; Sat, 22 Jul
 2023 03:57:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230721160614.695323302@linuxfoundation.org>
In-Reply-To: <20230721160614.695323302@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 22 Jul 2023 16:27:22 +0530
Message-ID: <CA+G9fYvAyQQMMFV8o2bV9kM5sVaNKPmbxGN55Bq6m-MLUZ0S+w@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/532] 5.15.121-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, 22 Jul 2023 at 00:21, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.121 release.
> There are 532 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 23 Jul 2023 16:04:40 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.121-rc1.gz
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
* kernel: 5.15.121-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.15.y
* git commit: 48958c96454b9acda1f1117b5206838864697de8
* git describe: v5.15.120-533-g48958c96454b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.120-533-g48958c96454b

## Test Regressions (compared to v5.15.120)

## Metric Regressions (compared to v5.15.120)

## Test Fixes (compared to v5.15.120)

## Metric Fixes (compared to v5.15.120)

## Test result summary
total: 92345, pass: 74734, fail: 2019, skip: 15525, xfail: 67

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 117 total, 116 passed, 1 failed
* arm64: 45 total, 43 passed, 2 failed
* i386: 35 total, 32 passed, 3 failed
* mips: 27 total, 26 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 27 total, 26 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 14 total, 12 passed, 2 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 38 total, 36 passed, 2 failed

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
* kselftest-filesytems-epoll
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
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kunit
* kvm-unit-tests
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
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
