Received: from mail-vs1-f51.google.com (mail-vs1-f51.google.com [209.85.217.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61EA818FDD0
	for <patches@lists.linux.dev>; Thu, 12 Sep 2024 08:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726131366; cv=none; b=X58GkD8a8phKRTfa6l2YQqGqODS4rBKbnfxOD+WdPaPy7Gda911x2T/vzGO0/9mnmJZicMAOcC5Y/lE2w/UgTIDJUMVsietjakGtqxvXGtCvVtldD0a6PTy4hv4WjQNqSan2zKfopZqBFZ3m4rM0jeVSajtIoPnWA7ITG+6WjqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726131366; c=relaxed/simple;
	bh=qD1HhQH4NjYHBF0Xozf0rppz5YvlGbjasErhi8pkmOE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UyMtgFKobtdc2TCeFdhGBDo4OFxHlXzSfVkFgXBklUDZQ9ORpoAFqgJ3KzDcg5Brqamh1Fz87a+7evImLdrp0pWyOYc+3firRSW/+lwq1bLZ6xwX/yYgDvMCwQ/C/UPZRP+mxaEYz4RjHMW5vzDfDlJQKIRWxwak8Xanf1RHSFE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=M/rzPdgG; arc=none smtp.client-ip=209.85.217.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="M/rzPdgG"
Received: by mail-vs1-f51.google.com with SMTP id ada2fe7eead31-49bc42bec6dso234534137.0
        for <patches@lists.linux.dev>; Thu, 12 Sep 2024 01:56:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726131363; x=1726736163; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kcvRVOfTB/QaV43zEeZF3CiWZLcYosI+3Cqn2IbwOTM=;
        b=M/rzPdgG31bXhFV1LhT0lvoNUSqOnPRqpij4iJeewdDQPXuV3uc91fT29ZoLntMTWF
         e8sl0XqQsW0IPDMH4bfz7QdKVwOHgu56kBW+Q7VNzoBm1sS+BeSmo3O6HU5cPY5WIKqo
         4Ip/vGLuzqNvWtj/7ION+7LOO42Bcj9mu7wUWSjJbQ+AoIm1xD+5LIkHjT4qSGWtFQvB
         J8V0VOl8J338lE+oDeazUyimWRmLzQb5BQ6BRS2pO5EA6N4GeXfJJ1jJvwXfaC9aIeMM
         lqDsfhB7R9kYt0AHdECkxnP9CIyAr1OA2iCXDk+gp9Fu0h47alLZn00oHisOL2ryuOH/
         Za5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726131363; x=1726736163;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kcvRVOfTB/QaV43zEeZF3CiWZLcYosI+3Cqn2IbwOTM=;
        b=kyWW+GfyslN1pGbsI+S2pniPF5JP0DuwQm/XCvCdg8Ud6kaJfz1f5runTqcoGyJd5W
         /3zfaXI0TsmxhGK8307U1kxMsm0TxJ3rw0KkidlgziPUXuQ8W2MCGi1EfGwVIx03D8hn
         1yByvgzy28U85f5M2wW4Dk83v0H5wDd9NB7ESz1WRj1alxgMRvTz/+zQrbeGhYDjtr5m
         yiZrUPtzVm3AdOrjCMqUINChGT5KwmuGro0Fx0FtegyOdP7kacJSOMB3Vo1myDIz863c
         6MCGq3ozngmgzSP+/mGldWje6yRAGdXcK4Zgwx9Wae1J6YmtUS+4ix+k2T/tMcyBjDog
         yPLw==
X-Forwarded-Encrypted: i=1; AJvYcCVCY137fBXwvtNly0WnA0M/2Ywx39sFqTfd+V0aQQ4HX2n7eIxIxHODE+t2HI+W2mObeDBQFaX/@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6ipPBLU8EvZfdmuLAnEQVMle8wISYiLyJf5z/z0W/ebiHaLa+
	R2hCYedQLqTiWXY/l+1dctGDa+WXOeZNXCgO3TAIPNwuXb2a702fti3Jd6N/hOeA5k6omXf1Flm
	2GZxs2t5i7h+NCVyjg6RFWsrJJWmYFkdPOwOfbQ==
X-Google-Smtp-Source: AGHT+IGRAG2+e0nWCRhdPvid9sHsfU07sA9f4xus2JUHYoULnNUjW15Gcyv2WVYba67WuoFAKO5VLAEjL3t6C9W0ADY=
X-Received: by 2002:a05:6102:3712:b0:492:9ca1:d35e with SMTP id
 ada2fe7eead31-49d4145c022mr1387447137.5.1726131363273; Thu, 12 Sep 2024
 01:56:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240911130529.320360981@linuxfoundation.org>
In-Reply-To: <20240911130529.320360981@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 12 Sep 2024 14:25:51 +0530
Message-ID: <CA+G9fYsw_CwZT81J08ZzurfXx1aOQqHvVqro2tp2FdqU69U-NA@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/185] 5.10.226-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 11 Sept 2024 at 18:37, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.10.226 release.
> There are 185 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 13 Sep 2024 13:05:03 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.10.226-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 5.10.226-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 6cc7ac2e6d7e0d3dded48744a235d6630d82caa0
* git describe: v5.10.225-186-g6cc7ac2e6d7e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.10.y/build/v5.10=
.225-186-g6cc7ac2e6d7e

## Test Regressions (compared to v5.10.224-152-gee485d4aa099)

## Metric Regressions (compared to v5.10.224-152-gee485d4aa099)

## Test Fixes (compared to v5.10.224-152-gee485d4aa099)

## Metric Fixes (compared to v5.10.224-152-gee485d4aa099)

## Test result summary
total: 89626, pass: 73979, fail: 2026, skip: 13552, xfail: 69

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 102 total, 102 passed, 0 failed
* arm64: 29 total, 29 passed, 0 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 23 total, 23 passed, 0 failed
* riscv: 6 total, 6 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 25 total, 25 passed, 0 failed

## Test suites summary
* boot
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
* kselftest-kcmp
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-mincore
* kselftest-mqueue
* kselftest-net
* kselftest-net-mptcp
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-sigaltstack
* kselftest-size
* kselftest-tc-testing
* kselftest-timers
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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
