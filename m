Received: from mail-ua1-f52.google.com (mail-ua1-f52.google.com [209.85.222.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 139B622F3BD
	for <patches@lists.linux.dev>; Tue, 11 Mar 2025 09:59:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741687187; cv=none; b=UrO16f+qNxM8F+43MrZXJL23Ln8KUsOvuIJQwrGYEvcvXuTEHO0v+CBLMx67RsP8h4PFwyonoaOkbDqzHy1Xdc9LTOYPHDKMO0RJuiyGtVmFJYQDgqgZUyKguB0YaIogfSlJOD5OuTSa15/5vFjYUikIbbBHzBL6+pIljS3uGdg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741687187; c=relaxed/simple;
	bh=J6C8/Z6Xx8/zFFOEjzG8rTwrunoZ1TZVpwoUTteC8vY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SlP1IFRnG83qXjnqfMgFyXTlif7S0DFqZR5LlqbAVjLltj21SkvTlhN1+McD3fjFBITElRy+aiNpEpBmH9tXT6m4D4bsyS8szF6Hgj1DYs+DpYL/fBAgP8lcchoLZGRxUX3BKh6qeO+WBud1pAyNJxIZqSmxPxuwfme1Eww9z6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=ui83Tf1G; arc=none smtp.client-ip=209.85.222.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="ui83Tf1G"
Received: by mail-ua1-f52.google.com with SMTP id a1e0cc1a2514c-86715793b1fso2218191241.0
        for <patches@lists.linux.dev>; Tue, 11 Mar 2025 02:59:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741687183; x=1742291983; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VgHHBhkd8eGrFbDvShJ9s51yYCl4gvLMZWScZVFv3YY=;
        b=ui83Tf1GlGi+VDOVRYvP58YZDNw+pug+lzTnXrQ2OHYzhV6ooxk0KLxQB8T6GREA4u
         tqMAsKAa7J/vwgm+GvtGc4ErdY0hdPzq95sYyqQJlg8NLh/6w7FW/Alj0kw0DEtgNH9q
         WdKrKVstKPe0WLL8o7x1wa+EFQZ3sK7YOrvAsoU0806J7sPLwMGvbTIMzAth1VRpymyw
         uSoit3xjQ0DdUVRhO3wadjtP0jCa1x4Mj1KTe4nJhJzs6hZIDw4zwQjTKCw0uzNM11w9
         KDYZXsb5axhC9lJvO+8ZZyp6SAbGWYUcAebWgMID/lvs69JQuADQwHOx8KE9j31wHx9i
         Q1/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741687183; x=1742291983;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=VgHHBhkd8eGrFbDvShJ9s51yYCl4gvLMZWScZVFv3YY=;
        b=ljZttm1t5NZV0aepy0mOB3YTHSd8Rs9FYEewDtwYvrJMxcumZMzaOgkbUg7SbjQQms
         +gyxwa8E+kzgArf9F+Y0Yy7rxOfeSutXN65lr+kSxcZBNoa1g7mi1XHKne7WyxY5oRnQ
         fldig0UazwGX8SxHQSwvbfKtmdWtAoBnC8DXzQUZ6nS7Jo1DoAbukW7f7jJPk4bJx6KL
         xAAwe4g7GFmyvaNaUKnYrfiqDiQboeTf1J9+Rmm8XHPFIZWoVgBzrx1Fz3am5AAdIuKh
         Hudfj8uKK/TYSHsO8S98KCcttV8ivv3wh9g6g2GDzzCOcd9vI/0NKZ09plnP4s0grFJf
         OkMg==
X-Forwarded-Encrypted: i=1; AJvYcCWEYm46WinaD6IHSfAK48LVw8WobZQPE1Jo6xtsqO0wobvOUe727uwKAsDEJ7DJUi4F01SW2HYz@lists.linux.dev
X-Gm-Message-State: AOJu0YxfeB1gifQCOxR0trBchquRa8JVICiiCtSE+bx4POCA/oJyMcpR
	P93TIpYLyn4tu5kTKCxGlietKaKJX1KKG5RtFW7UXwrJAF3MdIA6fBFQOQ5AYKE+J05Bh9t4fkT
	IOVavrqjdaTnT3jgEOKYYVhVBJVVmnWsXMHB6Tg==
X-Gm-Gg: ASbGnct7mVJaBo0gGTg1pNDd0vYk/0VLfIOR0Bvjj00qphOcyqEae5EgObHBTEoIgkF
	4bm0vCZdT84ydttqK5f+M7CJUoukfMwa1H4rVLW5AXVMGkNXrB9veqEN6i4FFsi3dpx52xRTjAe
	tZjpx7lKAf9r/zDIBbRgSlXKLpWIsLAaMqM/+Z1E68hdEosg+ZxRfTXzfVjQ==
X-Google-Smtp-Source: AGHT+IEW83Xnyj3HCDdDUXd2rQkKJnkka7mSV0uybfERQkgxMEzczr5vd28/ptt47EuXiJbo0OiVMm7z6oH6+1A7haw=
X-Received: by 2002:a05:6102:54a3:b0:4c1:875e:2215 with SMTP id
 ada2fe7eead31-4c30a534d15mr10077749137.1.1741687182836; Tue, 11 Mar 2025
 02:59:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250310170427.529761261@linuxfoundation.org>
In-Reply-To: <20250310170427.529761261@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 11 Mar 2025 15:29:31 +0530
X-Gm-Features: AQ5f1JqYM1OaGivq8FkIREmdHHUgpx2t5idwxKUVtIfiFKEINVp-cx4s8kAVB-M
Message-ID: <CA+G9fYtqPxzb==RHUbxfDuiABnJxC5pBRzGR0JKQF1voxRpqKA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/109] 6.1.131-rc1 review
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

On Mon, 10 Mar 2025 at 23:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.131 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 12 Mar 2025 17:04:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.131-rc1.gz
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
* kernel: 6.1.131-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 5ccfb4c1075fee3b843050158af9660c9489f04a
* git describe: v6.1.130-110-g5ccfb4c1075f
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.1=
30-110-g5ccfb4c1075f

## Test Regressions (compared to v6.1.128-732-g029e90ee47c2)

## Metric Regressions (compared to v6.1.128-732-g029e90ee47c2)

## Test Fixes (compared to v6.1.128-732-g029e90ee47c2)

## Metric Fixes (compared to v6.1.128-732-g029e90ee47c2)

## Test result summary
total: 72879, pass: 56029, fail: 3089, skip: 13542, xfail: 219

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 139 total, 139 passed, 0 failed
* arm64: 46 total, 42 passed, 4 failed
* i386: 31 total, 25 passed, 6 failed
* mips: 30 total, 25 passed, 5 failed
* parisc: 5 total, 5 passed, 0 failed
* powerpc: 36 total, 33 passed, 3 failed
* riscv: 14 total, 13 passed, 1 failed
* s390: 18 total, 15 passed, 3 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 9 total, 8 passed, 1 failed
* x86_64: 38 total, 38 passed, 0 failed

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
