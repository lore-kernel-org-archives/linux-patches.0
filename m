Received: from mail-ua1-f44.google.com (mail-ua1-f44.google.com [209.85.222.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86F020C48A
	for <patches@lists.linux.dev>; Thu, 10 Apr 2025 08:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744274531; cv=none; b=p51oMqKLDveyvg7tIjfahPGUO56IL7wkooJzuyTikpESIG3HSz5TKRYw4nJQkcgB/rkPnuWvOr5kfqYlPR5s1ePfY/YrJi2vlDLmaA/P07NKt1xGNkNCNi6sjYst9hJki+x9jdVtTmwi6P/KCkdFo0DKnsjE0iQOqJGTP5r8j/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744274531; c=relaxed/simple;
	bh=XG6NxBHDCU8e6wWhYpT5+1tNDUysPx2K/UBmryuS2Mo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l5lK42bpTIcUMXf49rjpK9VNAxRnLYbP6XFU6v0tMUSUiIb6XNnTWnjiT1Ai610ttwBc24eCK2fhGlBFvcHrKY5YvrWxTLo6Fl37vXC842y5zDvP/9JVOQRYOqbnPuDW0cRjqI+WAFH7MM6BXEtE9zDqeIYFZ9YOx7OVlY/vAg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CKpmC5Yq; arc=none smtp.client-ip=209.85.222.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CKpmC5Yq"
Received: by mail-ua1-f44.google.com with SMTP id a1e0cc1a2514c-86715793b1fso216871241.0
        for <patches@lists.linux.dev>; Thu, 10 Apr 2025 01:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1744274528; x=1744879328; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=GyIfJr2KsQTHGuBJx3uboxs4QfrzCXTKIx86BPgvMt4=;
        b=CKpmC5YqMoaEQcDRITZfmqs5bWl6zVdADcoEmlZxwYtOJ9mi1SMxsImbe/YwM/PJ8T
         dXECDa/kNXCh4xcxj0c+KY6naOcc0wR5Qscl9YsXFZ9cgi60JwL1uiuOBA3iBncClO7/
         36lvN9FjQX6lwprI/uRmoYC50lorWnBmYsU+4EZDWITKL8NLB394XbUk3EViHFDdbGjH
         w2xW/gmDziKkJYDnR8qzrIy3119htOfJnQZ5akmcNyFVD1Tw7rpj8fnxWWjBuGH/290f
         OobBSbhIUZRiI6g4TB0XZSym5flBOvWAfTYNuahtLPty/AA5a0ui3NY/CLyDQwiO+ghO
         jnFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744274528; x=1744879328;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=GyIfJr2KsQTHGuBJx3uboxs4QfrzCXTKIx86BPgvMt4=;
        b=Bgz1uU1rFYvfMszSwSzcJBy+OGv5UCx9i0pAO6USb1T8LjJkrMP3QRwBQWiQnuHCYX
         Zz5j9QBHWpzXsMk5nba5JEHRaVkr0JZOI4EVLmvg/9o7MMtdAjXwylVCVvkSK693pzmF
         gKud+1uwy/ef0EyDT3rL4x6vpCpFljnqS6DOlLk5KYk5a3s1qRRcvi74G6GsculUbbeM
         /OOHul+xR4eM6J1u8N+EpD/0qHMR23LcsjS1QE5ln7gEKjgpR5m0sCVu90bAPLNRniEV
         Y7tjSzfSTcSU324LJPJ7Ei52AFfktSZBqKwfiTNue52X01vO+bg0EXFj2CpGxvA/muEh
         cxAw==
X-Forwarded-Encrypted: i=1; AJvYcCUbqSGzQ7OegJW+u14uR5zUiP73gB/xH0TQKB494Sjtas9lUBlgV0hluZQvGGX/z2GA7cSS1cDL@lists.linux.dev
X-Gm-Message-State: AOJu0YwM8OxZl67eUdgG9TB/CThAaq1hHWI7AwWK881lViCcPzIco6mp
	pWRZ7ZEJ2wX64r82YyxahW8qouvcJPTeG+J4Dg6gYLiK1i0XDPW9ItSLId/JIcX0dNZi1FRmzSn
	oWPqeyGlZmg2ZsGPoCeiq9f2xGS8idHc/2y+3iA==
X-Gm-Gg: ASbGnctwWchg4Y2A/L80cpvo8e+spzq6+Dnl+3OqAMwrEsmUH+64U/40dKJeUb6vv9R
	WtzqYcp6kU2e43fnQnn55fDU16o1foPrZuNuyQYGGDPSRpBnmOtZbUkUqnPBRXhjBPfzLcgSi08
	fu6gBtkD4spkcS2ow4DOFB5v9GcZHbjvLtlFuSPvlu19RcPJj8j6mouAw=
X-Google-Smtp-Source: AGHT+IGEyduE75Oa5qN4VHLm8M3R7hj/JMCUjzegckuIY/DQaVT3G91+oV6FvbCTJnJFb7i4ArsCyl/2lP0i82WbZ9M=
X-Received: by 2002:a05:6102:3c87:b0:4c1:774b:3f7a with SMTP id
 ada2fe7eead31-4c9d35c57a3mr1052484137.16.1744274528525; Thu, 10 Apr 2025
 01:42:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250409115832.538646489@linuxfoundation.org>
In-Reply-To: <20250409115832.538646489@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 10 Apr 2025 14:11:57 +0530
X-Gm-Features: ATxdqUHVxWyVTy2Pevd2zCaKDuF7x7M_hIPZ-bHH-56kzLv0RETgWUsQbJV9hsY
Message-ID: <CA+G9fYt+bq=20FNgxqTXnEcj0mScu1d20kCnyeoF7NS6LJEi=A@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/281] 5.15.180-rc2 review
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

On Wed, 9 Apr 2025 at 17:34, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.180 release.
> There are 281 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 11 Apr 2025 11:58:00 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.180-rc2.gz
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
* kernel: 5.15.180-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 20340c8f4f00f2248a63d0a83fa118e2894a8439
* git describe: v5.15.179-282-g20340c8f4f00
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.179-282-g20340c8f4f00

## Test Regressions (compared to v5.15.179-280-g0b4857306c61)

## Metric Regressions (compared to v5.15.179-280-g0b4857306c61)

## Test Fixes (compared to v5.15.179-280-g0b4857306c61)

## Metric Fixes (compared to v5.15.179-280-g0b4857306c61)

## Test result summary
total: 51458, pass: 36401, fail: 2669, skip: 11981, xfail: 407

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 102 total, 102 passed, 0 failed
* arm64: 30 total, 30 passed, 0 failed
* i386: 22 total, 20 passed, 2 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 22 total, 22 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 26 total, 26 passed, 0 failed

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
