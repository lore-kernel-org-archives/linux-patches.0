Received: from mail-qk1-f182.google.com (mail-qk1-f182.google.com [209.85.222.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3964815ECD7
	for <patches@lists.linux.dev>; Tue,  3 Jun 2025 11:32:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748950341; cv=none; b=L34bqE18KoslBp4D+whCkeYw3umlYaa8cwVRUOSjYF4gNqDrErxjLjvCf5DlZwKsDXAO1x7B7ZvVQIh0a+r44IHYc+z9dnaivhEAQqcsFCBAy3YX35RHP/+whJb447/oHWTbNrZ/U4XsoGL+Z6dHjtVogvSTNSQaRgB3DenwCQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748950341; c=relaxed/simple;
	bh=C9gRWlLfBi0YKgBn0SoTcZxQPj4DkPXCPkpzlSXSJqk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lGKzYuhpTSYvh7ZjKwxKAl3ChA2m023hf+Vig2m3QfAB5o6RfoppYZ/m7D2fR0MUAqIlywAawA40pY1x64FSvqGd1wiAr3dbBaF9kJK3OKnNBAv80xyeQNWWB3fEYIMPMwObKirA1O88IhaP8ZErprWgIQ9JjSDzW+t6YLpns0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=yX7TtDOe; arc=none smtp.client-ip=209.85.222.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yX7TtDOe"
Received: by mail-qk1-f182.google.com with SMTP id af79cd13be357-7d09b0a5009so554588585a.1
        for <patches@lists.linux.dev>; Tue, 03 Jun 2025 04:32:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1748950338; x=1749555138; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4Atrc7hSG4Wq+YEOtslDiDaD9TR06OeEIkbilhWvmPY=;
        b=yX7TtDOenfRPjW33YtShe9Db1xWT0jGBXJRIVrhFFhroS7h8lXACM3QO110bkYr3OV
         1n7lqXZMnjYemGeQ6+4gBNFlU1mNLxz8uP3us5ncLeg+dt1YStV5rMVyStnchnQExg86
         A6JQF53HOYwFxgGTDGGmVLDrqm6TX0KgMsLzbuTM4tIw3DiKsMZKNNu10V7BQYqHgiOw
         NeXej3Oyy4QGc7kD5XepTSPixZyTQ8Xc2LlpeEKtjnfG/FtuB3yobxHPR4OI81X5LkxV
         gxvU5h5qui9RvmNTvWTu5oAAOd1Wsa8AVt2A9BeqXBHIiQHKxManWpuXa6JnKlNPcXhB
         wv8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1748950338; x=1749555138;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4Atrc7hSG4Wq+YEOtslDiDaD9TR06OeEIkbilhWvmPY=;
        b=C6dYA4DmUNuRWIFAksunyXIPZTxDuFEmhHOOOk2gQjtAPT5yinbBErUEV2mXEdJE9r
         DRB6BDC/Wtx8+sc1KgTUYL6Woh7stR3cnQObLZ9dOWucE4whEhe1fezVc3EG1Gn+Ma5C
         EHRd/MD2qrYZHhonRC0jsMuychNz2R56kUa1Q+c5Fao3Y4HQ0dSx5tkuTItG9qF4gz9a
         S6Kewd+jGOUKc29sXAYapbJXViJL4u/aRspqr8SqKGuzv8IxHwTO3/1jClKegv/917z7
         SzDEpKeVe8zvXeWHIbc0pZYSZhzfEUJXq5ZK/7CuD3veAzdOCXcuExeiJHYKNB9to+OG
         U8ZA==
X-Forwarded-Encrypted: i=1; AJvYcCWEDrBRBXED/x+2ZrV72ZCrwSlnN93jHRAJgP6ZkZVDDu6ge1fBRfDg4BHBZ3+k5pEM19GNn/gc@lists.linux.dev
X-Gm-Message-State: AOJu0YyMxREhvSoyHE7DFQxuKxudCbod7Uu9HvIi8WCO+ij6F2G1pWE2
	2IM6HHUYcErz5DMhfyrRJZAteaAKVsPORLzE3D0XfNyOZIe0yap5xJUzMRsLr7HP9ylLuVXNtYe
	uG/OfMW6Pgl7M24PTSlBFxZkFX/CxlVUX2qi5orYByg==
X-Gm-Gg: ASbGncu5F9nUMs5TWMvydSTe0InlTqKDq8wdhKQ/zbieHnSiwHc5kscqGCD3ijHwk3/
	4fB0n1MnfAN8WarOTD32UALOGqYi7izrRgd0xae0S7DRGMjxFmFC9SqQUa9gPEVMe0YH4KF43Cz
	mweOOpzF4RSTXhUh8VsSYWcg3glSYtdh4=
X-Google-Smtp-Source: AGHT+IH6CJu60GvORvqxJTYPklRaw8iQFScWg5PgSdR9bv70h3hv92ChYzgfJyf3St4K9Fc9ny/UTGzMOdn4NZ36zbM=
X-Received: by 2002:a05:620a:4406:b0:7c5:4adb:7819 with SMTP id
 af79cd13be357-7d0a4af0149mr2061854185a.16.1748950337974; Tue, 03 Jun 2025
 04:32:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250602134238.271281478@linuxfoundation.org>
In-Reply-To: <20250602134238.271281478@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 3 Jun 2025 17:02:05 +0530
X-Gm-Features: AX0GCFt8z_HGqiWFmGilVaVi001nq_yq_XNavx9fqIS6CTpy8M6ngbWXGV8DcCY
Message-ID: <CA+G9fYufqNSo+bhq_JQgEPNo0pKFPhuWQQbmGd8_HOE9LX1-7Q@mail.gmail.com>
Subject: Re: [PATCH 6.12 00/55] 6.12.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 2 Jun 2025 at 19:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.32 release.
> There are 55 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 04 Jun 2025 13:42:20 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.32-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.12.32-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: ce2ebbe0294cb1fbd36bf75316d94f81f26e582b
* git describe: v6.12.31-56-gce2ebbe0294c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.31-56-gce2ebbe0294c

## Test Regressions (compared to v6.12.30-627-g3fc6e1848884)

## Metric Regressions (compared to v6.12.30-627-g3fc6e1848884)

## Test Fixes (compared to v6.12.30-627-g3fc6e1848884)

## Metric Fixes (compared to v6.12.30-627-g3fc6e1848884)

## Test result summary
total: 309879, pass: 285936, fail: 4866, skip: 18494, xfail: 583

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 56 passed, 1 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 40 passed, 0 failed
* riscv: 25 total, 23 passed, 2 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 48 passed, 1 failed

## Test suites summary
* boot
* commands
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-efivarfs
* kselftest-exec
* kselftest-fpu
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-kcmp
* kselftest-kvm
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-mincore
* kselftest-mm
* kselftest-mqueue
* kselftest-net
* kselftest-net-mptcp
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-seccomp
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user_events
* kselftest-vDSO
* kselftest-x86
* kunit
* kvm-unit-tests
* lava
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-capability
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-hugetlb
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-syscalls
* ltp-tracing
* modules
* perf
* rcutorture
* rt-tests-cyclicdeadline
* rt-tests-pi-stress
* rt-tests-pmqtest
* rt-tests-rt-migrate-test
* rt-tests-signaltest

--
Linaro LKFT
https://lkft.linaro.org
