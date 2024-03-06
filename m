Received: from mail-vs1-f46.google.com (mail-vs1-f46.google.com [209.85.217.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FCD605A5
	for <patches@lists.linux.dev>; Wed,  6 Mar 2024 10:47:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709722047; cv=none; b=aSVCK2QpG+BFRjXqMayydQAwEYLjuBOcrKZy9coSrVGGVZ1dG4xHn5MrKisUDh+NFr3yB3xn9qY1U6cTSxcI+xmDXm5QnldDF/V87EMzqY+lh0mglO4ywv7Ub5Fb4L+7cN+MFiO3+7xMDbTGRs222WBT+aqpRn7LFOzpmcx4pks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709722047; c=relaxed/simple;
	bh=T0tkg6tNNzgKe4ggRojauYOz8jIgWQEfoBASA+Nkh5M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ISsqUqsxyb4dT17FePQI6SFW573lVucj/77LEyY2fKWEBIQmNVqtpQhzfQMM19NQkfiMhbXX+7NP3u25w1RNgnq3isGxCEE2tS4rA4xXht9gmTadm/EjNZOJVowu8Ctv/DXke+rU1YyLHDH8/jUG43XjdN/W4r94CHEO0WwLfR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=lgvfhS3o; arc=none smtp.client-ip=209.85.217.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="lgvfhS3o"
Received: by mail-vs1-f46.google.com with SMTP id ada2fe7eead31-47268928105so460040137.1
        for <patches@lists.linux.dev>; Wed, 06 Mar 2024 02:47:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709722044; x=1710326844; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sw05fDmD/5sw/n+gj4x6MEl4S6mdDxa4iaEzvHHso+g=;
        b=lgvfhS3oJAtlHpO/QXSqKi4xH1R8ICABKBte0q3Thczkex5k04L/6Vj46H88BHOyvh
         tLH1aJKMlr9N7lg71yxxtwsM6beI1hIWQaUSlChnGbdXCwTmO4HdTQSmGvvOnedVBsiJ
         iNAcBnHS6eb97cCzblC4zw+Y+vKE53yPYR6S6UGxFHw2rm++YIkYPdQb5aQZJzQM/Hbi
         AJGeY1RvDmXgH1swyMXSmoBKcRX8skGN69ok283QtaqAZ5DPm0hfPolXc5SwFrczI8N9
         VVyvNmDDwf+ZKOo8yOq8ydbsUYVrJETd7jtbefRuQvLIIz8ryKp4EOSZb54cm+We0jEN
         B8eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709722044; x=1710326844;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sw05fDmD/5sw/n+gj4x6MEl4S6mdDxa4iaEzvHHso+g=;
        b=Q9f34ifI0C5xd4WC4bPgzBc0ip/E6zWvEVKhllFAjbDji4vAfeX3I/O7+cG6RV6XAA
         uO+dOuRFOXy4LU1u8QIda3khbVdhIiLI7V842FakjQf2G/BwzT+075/0JdsAb3vusW5h
         rNiGzxY+31fV+jG5Q6Ua1X05Joq2sahM1t4fQO0Nt62cK4NH17/bO/AXBAycRr1c3zMc
         4himB3vv9Low1HZqcnzhg/xBtzS43EBPwuZuBC6DzHIp71qH/zbynZ8RhukqonXzpwjd
         FmlYVHlSPL0+WuMHSRgON4htM86OvUAAxMJWbOiMdysH+InO4Gv1g0IPFuE30Rj7PQ4O
         XtAw==
X-Forwarded-Encrypted: i=1; AJvYcCURxNPSIjIoHQv+ojtacYyLurmND4MmqYTKvkpUCfupwE6W+fxNily3mwRHSmC/tVhkk+GHMrOvS5MNo4X1t3mpVHZWM/iiGw==
X-Gm-Message-State: AOJu0YzVqJ+AtpR1eAwxJMxolQFdzg6U40oSpf7Wnd7uazBu1Tx0n7rO
	i5LG+i9IY9p2btXirqZRuogv3eof8uYWOmhERSegBcicQrb/dZoXxKFegzhNtuIYIFn6hE5hROW
	VNmeT4bLI/AV1kUV1eJBb9WWQ7fC81WhKJfW65Q==
X-Google-Smtp-Source: AGHT+IHFMma7JuSceVxjvjNRcZ0aadlI+aj3d1JXNvjpIxhakTYNUAvBqf/soLRi+E9TJ3sHbH/sfpJqlCtd0CiIXY8=
X-Received: by 2002:a67:e3b8:0:b0:472:e85e:7a53 with SMTP id
 j24-20020a67e3b8000000b00472e85e7a53mr1941063vsm.33.1709722043784; Wed, 06
 Mar 2024 02:47:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304211535.741936181@linuxfoundation.org>
In-Reply-To: <20240304211535.741936181@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 6 Mar 2024 16:17:12 +0530
Message-ID: <CA+G9fYtOAL4Kco7zCMp38niCHUJ7Z1hxV5VkT8VnbaWF4mqt_Q@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/25] 5.4.271-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Mar 2024 at 03:04, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.271 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.271-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.4.271-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: fe27532da81b5465567e329b6950454328c9482f
* git describe: v5.4.269-110-gfe27532da81b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
69-110-gfe27532da81b

## Test Regressions (compared to v5.4.269)

## Metric Regressions (compared to v5.4.269)

## Test Fixes (compared to v5.4.269)

## Metric Fixes (compared to v5.4.269)

## Test result summary
total: 98648, pass: 77795, fail: 4006, skip: 16788, xfail: 59

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 138 total, 138 passed, 0 failed
* arm64: 38 total, 36 passed, 2 failed
* i386: 25 total, 19 passed, 6 failed
* mips: 27 total, 27 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 12 total, 12 passed, 0 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 34 total, 34 passed, 0 failed

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
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mm
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
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timens
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-x86
* kselftest-zram
* kunit
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
