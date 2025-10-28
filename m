Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76D072DE6FA
	for <patches@lists.linux.dev>; Tue, 28 Oct 2025 10:06:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761645986; cv=none; b=t1cGilgRaikjfTtp9MZQfI5y4FOmkONvrmAtNEaCr45gOEwwstXuqJMzEQTeVlsh5xRzsDj87VlcvUso+BFmM2ls3uqsq50wZOyVy1/qjAWFZWvQYL4E1pGIWuA9mD8Bo4BKe2ZKo8TObPE5tq44zRPAv9KWryDtQA0YiFh+KZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761645986; c=relaxed/simple;
	bh=xuFTTSxjbw31IOiYDJaMQMJCph6kYPo7mS0EA8TYPqk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VFYG6Wc0hRGETjK3otWJ/2syJ5uJdeXCh7i2GpdGtBeYaUW8lwfLmxXHTb0SJRaGqahuGyLQa7ZBKs9FvIWw/j00ksJwtPIuFHf7tXzaCsgIedZcp44G+ueEgFDJg79TedM/JkkU3wVb6jbygQ+4Nypel6ffD06tuyS3dQj0OzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=QTzmXpd3; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="QTzmXpd3"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-273a0aeed57so74043875ad.1
        for <patches@lists.linux.dev>; Tue, 28 Oct 2025 03:06:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1761645984; x=1762250784; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OnHUFoRvTM2Rx2g0aEwEG6pjIIjUXsEmk7FkUwoNIF8=;
        b=QTzmXpd3eDFu+f42YBzoJIO064Q2lmIkPnZBgB9gAFx+Ocy0iGyK5af+0snLUfBFqA
         AlQJ9wqungWCfH/nP7kunmCD5c+tPJ1amvpkTuKVQk9R+X+6aARbZASl12PUn2XZ91S3
         RoJeVU/dfAhwzBrXX7SdAxa22StP2QBWMNGRuI6hfqN00jIlYg7IYMbvbPJrhkvLLzmN
         TMk2Ugj8rnQeXDWuxLWj3pKDqVqEpihHhsbMGBo5mTc7RjViRWS7QJr/CFmCPA7pPCu4
         jgWYvxzTrVY/wmeM1RjiBZC3Wm7C/GnLE/mmtTaMVZNiqxye/mhBK39WqJsguiG9KNSU
         EgLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761645984; x=1762250784;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OnHUFoRvTM2Rx2g0aEwEG6pjIIjUXsEmk7FkUwoNIF8=;
        b=VsFllW4RXUMtVqTVKlQ0VlNPvnJwPF4/fs1mBf8MceEhaxOC4nELOze+i/XxJWWQV5
         +3F53giqzJ6zJrRUOLYaK8ZRWAfOmPWW11rIPDhYG4mDACgBsUioRSa0ujDMjb3qRSN2
         Q/TnPX5BM8Z1CptkfQRmk1gL3LrF+PNfB53ebK1Q6JdzEvkr0ivNRqmf3d6YZke9rTSa
         CFJUoBhixDe0lcV+k6rYUxURCV9l9ZqTY1c5s8AcEANnUyvLcgS6ngP8kQosHOjAmGjy
         iOf1fFKW1yGbCPcYZWztHOjGS4lKoSctrgIYhMHykrvzLHhLdh98odKJ+munfkppbUPr
         +Vcg==
X-Forwarded-Encrypted: i=1; AJvYcCVtcZkKQtbkCw0gBu38sJvjPpyzydMuJElMHo9ovdIdE11ZVGRAvFTsOI2SKQ+iKT+guJBGPYN1@lists.linux.dev
X-Gm-Message-State: AOJu0YzlR01DXOYVLPw9a8ZupAHinn9EqAlPzcTefuFjRtosJBsorGLP
	VsO1l3TP+wjvkPYkSgbaMORjbk30mOdTq9AfyWcR2Vvi9Y95WMXPMqC66vls4rpCCTueoTwbrWk
	4cbdEHfYe4kix4PTzAvDrOwq8eHqLD/VlZ/Z4+YMt0Q==
X-Gm-Gg: ASbGncsfm2FgwZAMI+kETWYJme9D2j8Rb/OkGTFmqF2u+R5n7jI8g5O9l6RbCoPrkXI
	XM2WfJpdJu/BUzH2KO/t7jWl7sdL6GFdxuNWaEqjIY3Yoso44yTk+Hu8cFQI53ApN7qLsVDw7hx
	3+O6j6mHFHOj3dGwoYlt28vqjcg5g2pOXUSDzZ5RKmLEmQn7G+nFn1D3V4nfsVFX0QUUaY0XVFf
	5SMn/jV1j3ReqpGM7pNKkJPJWjB9oTcbsEEU80hzsiA8exvFv9EbvDGoYEQSN4JlCEeqTeOp0PF
	Zp46YYTpXBcOW0UudxMZ7d+zVLVenPC/uvD1nVVvrWcEDUuRcfn8SUJsNWGq
X-Google-Smtp-Source: AGHT+IFNk7YjyZeFMPxp3FhKWGRMLBw/14xH9cNXCvEmCNWMRlsReSO4TqKwnIzYH3KF2rc7jFnz2I7eN6c/Ga2/VpI=
X-Received: by 2002:a17:903:41c6:b0:272:d27d:48de with SMTP id
 d9443c01a7336-294cc721623mr32406755ad.18.1761645983775; Tue, 28 Oct 2025
 03:06:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251027183514.934710872@linuxfoundation.org>
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 28 Oct 2025 15:36:11 +0530
X-Gm-Features: AWmQ_blZIRl01loaTjJ3A26avTqa9APme0NL6W_imSqUXdoRXMqE3-Jk1P_3Cvo
Message-ID: <CA+G9fYupug-BDm1C2Szx=-cj=WHLwV4W5VqiW9i8R0y2AiapTA@mail.gmail.com>
Subject: Re: [PATCH 6.17 000/184] 6.17.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 28 Oct 2025 at 00:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.17.6 release.
> There are 184 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 29 Oct 2025 18:34:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.17.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.17.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.17.6-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 10e3f8e671f7771f981d181af9ed5a9382cb11f3
* git describe: v6.17.4-346-g10e3f8e671f7
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.17.y/build/v6.17=
.4-346-g10e3f8e671f7

## Test Regressions (compared to v6.17.4-161-g3cc198d00990)

## Metric Regressions (compared to v6.17.4-161-g3cc198d00990)

## Test Fixes (compared to v6.17.4-161-g3cc198d00990)

## Metric Fixes (compared to v6.17.4-161-g3cc198d00990)

## Test result summary
total: 130764, pass: 110823, fail: 4161, skip: 15780, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 139 passed, 0 failed
* arm64: 57 total, 54 passed, 3 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 25 passed, 0 failed
* s390: 22 total, 22 passed, 0 failed
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
* kselftest-ftrace
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
* kselftest-rust
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
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-smoke
* ltp-syscalls
* ltp-tracing
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
