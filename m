Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98E341A9B4C
	for <patches@lists.linux.dev>; Fri,  7 Mar 2025 11:31:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741347122; cv=none; b=hPqB5rhpp09PB2oIDC3z9t3P7pFOqVWX1fznGF21z1S04sNOIdnzhoq8WWwQHVEsdFMK/HN2fsHjfoO+WD/7dotPuYUN1Elwf4gnixPlXh8Ftlq5q6P5v2wsbzy3h0s/Q83yY0WCmIhXQGS2yTG5pv/SKRWB4ETaEFeKUUVNnFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741347122; c=relaxed/simple;
	bh=f+BPraS5AJNOD2aTCpOoOgZLm6Ptv8S/6d8vbUiK0zc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ac2gPZmuQBwlZxtaFR9tUVmN4xc0YAW8w9TBbKyNNIlbEw8j6lACQsYyQl6YZG1Q6CId5I7OQ6G+mqBxWYLALR6+ynvkHXnSOjvg1w1o9UuoSXbQXFT3xbpHSOm84w6nw/2/RkqwxlnYUiyL2VkOGC4wKlB070WmWkaXgrN5FUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uPWB3WZR; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uPWB3WZR"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-867129fdb0aso1545415241.1
        for <patches@lists.linux.dev>; Fri, 07 Mar 2025 03:31:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741347118; x=1741951918; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ywKNXyQduZtYvoI6jxdhP8hHSFQmxCo5DD38wzTDf7I=;
        b=uPWB3WZRTVdjYj9rXCt7dgaYGIHquUm6uEVU2Y+lZwAaFOiAVF9WQXIuyndxDna+E/
         8ol1AObw75xX6V1syZhqmeRjEfyKJlbyTUJpYVeBCKAPuBRGZJ+bunT/yL0t4to55T11
         Q+E1vR60CNryK2FTHz9Ebt7HoSOmzfHTEh9Z5ObUwsl1jePbjjzs/uxb4VIWU1kCr+/b
         st7hYSfeHVichZThjgGWWQgAQU8ZmFFTZlnt+eYbl1YkoA3FU131Ge5QEHK7/x+F+saE
         QRMa6XF+Wc09A04ASz8QTJyyduf7X0zX0qfFdMzT9RhQ6oGDu+xmWPhwUTO+JKbjvJ1c
         Qe+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741347118; x=1741951918;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ywKNXyQduZtYvoI6jxdhP8hHSFQmxCo5DD38wzTDf7I=;
        b=ahwhlLjkavqIw6nWVTnM3+jZMJATg4fopkzul7vrKCNeAFy+2/ZxOShP8/XLExvO6R
         Nw9gzOywo4uXg3NiGTRGORbRxoyWK3UHD+lq4chC2M3Gf8CIDA1Q/nS2cNVxfbT0PO4n
         VYpL77zWVcUIeMYknCU41NFLXLyZrVSyQRYXNlVrydUa97ihoYZca1sIZPK3LIOSjgYL
         N32WjeidS4k49uqu2Z0r1w4DLzy3GRvbV87sP6CIjhpAE8WwbRRYG8cQm2lbSUkU38aQ
         GotUreE1gnLme4oDZVsUNUkaRF1DAb6QStLju3yiQWs94k5nmrefb0sggvEIOzyU6LjN
         ZL6g==
X-Forwarded-Encrypted: i=1; AJvYcCUQt1VY/0RBwG/R7T9RjW2LFhSEsNveKBDzwbUyDWAVog42dUThbDm3hP+qybkXZ7Uz0DutzGkT@lists.linux.dev
X-Gm-Message-State: AOJu0Yzf/9+kfsHmmCX7ybp0iOc4yT4jELMJapYm5WjQyJjeq7FmYlzw
	2n0vdgIXNuV5C5uJFN04VJyBqL2WjubnvyrFWlD8SVi8d3VOoVOyfmdZ33fUVp5RWkp07o6ShgP
	FF9iN0R4ti7LVDQwn9l3pyFX0oStAzgsT29FiNQ==
X-Gm-Gg: ASbGncusZfeDalff50spC+G0ocrTz4pM+jyaMc9758NRMZCb0UKE1McSWSNew9k9+jP
	xQRZ4nwDBWvKxQtUC4x2nTpo5HJaJQcaUwIm/BdiX7S+x2qRf7A1Rklni6xmkHyIsuKIk3WpEXC
	4qDAnWeG6XnQShZg2obIXy3am69wtW8B0WT97YNczYAnvy5yHaanrfyFGHM2s=
X-Google-Smtp-Source: AGHT+IEEoX3qpu6CmSaLeGuLW548G5UTO5B5A9BtNRSS+A2PIW08gpwHLIcHbM2Qnh/gpSxTryWAuaw+5ZOfZzxiwbw=
X-Received: by 2002:a05:6102:809c:b0:4bb:e80b:473d with SMTP id
 ada2fe7eead31-4c30a5a84c0mr1419593137.6.1741347118445; Fri, 07 Mar 2025
 03:31:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250306151415.047855127@linuxfoundation.org>
In-Reply-To: <20250306151415.047855127@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 7 Mar 2025 17:01:47 +0530
X-Gm-Features: AQ5f1JpE8AAJ3gh7RSXMtWAe3wo8-y_6_oLsy-2eWfHGaTOHnPUFj3a5CwYb0eg
Message-ID: <CA+G9fYtDNr+w0cd7uiwyTWGvdVGWn9W1UdmRjbzA2JA_-x69yQ@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/148] 6.12.18-rc2 review
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

On Thu, 6 Mar 2025 at 20:51, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.18 release.
> There are 148 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 08 Mar 2025 15:13:38 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.12.18-rc2.gz
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
* kernel: 6.12.18-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 7d0ba26d403608b56f8de4892c01e4da7e841940
* git describe: v6.12.15-529-g7d0ba26d4036
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12=
.15-529-g7d0ba26d4036

## Test Regressions (compared to v6.12.15-380-gf5c37852dffd)

## Metric Regressions (compared to v6.12.15-380-gf5c37852dffd)

## Test Fixes (compared to v6.12.15-380-gf5c37852dffd)

## Metric Fixes (compared to v6.12.15-380-gf5c37852dffd)

## Test result summary
total: 124530, pass: 101752, fail: 4084, skip: 18630, xfail: 64

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 143 total, 137 passed, 6 failed
* arm64: 58 total, 54 passed, 4 failed
* i386: 22 total, 19 passed, 3 failed
* mips: 38 total, 33 passed, 5 failed
* parisc: 5 total, 3 passed, 2 failed
* powerpc: 44 total, 42 passed, 2 failed
* riscv: 27 total, 24 passed, 3 failed
* s390: 26 total, 22 passed, 4 failed
* sh: 6 total, 5 passed, 1 failed
* sparc: 5 total, 3 passed, 2 failed
* x86_64: 50 total, 48 passed, 2 failed

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
* libgpiod
* libhugetlbfs
* log-parser-boot
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-capability
* ltp-co[
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
