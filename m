Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73FF23431E7
	for <patches@lists.linux.dev>; Wed, 27 Aug 2025 09:26:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756286781; cv=none; b=nJyX/Gs5C2rgZil0IJH39+cgD5EkllUp/5mVuZv36Oe093VqpMc2uMkG0QAiWgpd79Y9fcA6fEwkQAzeYL2iMgObAJKGWr8UTTqKeeUG5X7q9NDDZ12ZTa1OkaWZnUn2MexH96mWlP93ZHsKRPSMdfY0rCN/B5ALKg30b1DzZs4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756286781; c=relaxed/simple;
	bh=ijsvinMsyvw0y2W3RvJVA/LaBuLCajMeHEsODWMvu1I=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=W9zJ9pR+PnI1t1dhtyBxX9rZ2U27BkMojJscpGfs7YGi4xQm9Fz5Dt0skYs0Xr1NjkTMcKIsDV5N/8O7xx8f7b7rvxBBoTtxAItFhoY5anD90TOtauwcVcVaIPnmP6zKQ5LIxIkxqfQNqSJiGA1IapLm+rP9xPnRpU50C49mPcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=nYHSqC/B; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="nYHSqC/B"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-70da6a3acd9so6672126d6.0
        for <patches@lists.linux.dev>; Wed, 27 Aug 2025 02:26:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756286777; x=1756891577; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=RObNvhRzj14YrAIax+dM99xs/Xf3Y4EHrFUMEOiDAYE=;
        b=nYHSqC/BtBh8zPQklej0H8RGVnJolU8/fW73X45ciaxfKwJpBnP4drs4y/ciAso5U+
         SnO9y4nVhUFPKHqDAdjVlRRG2/HL+WA9yz6PAo06iPwAnBRpcbflF1GkNzgjZJKUuMK3
         ym3EnBZ3YbEi3+5nwZe3+iYtUTtu4LUYqakk1UzwUWL/X19PfE3p8H/lTS0VnDlLw0dE
         uvyzPg6Inaf2eKEHXgWnCAXjJXz7Vyjstbn1EVnsDEWd8zaBVBUEgf/nDdNPdH8Hz4D8
         9WJkChECrrrS9ihFd9kCjkto6iqF1OlSxG91As/U+tZZB4fzj64w/Ghqc98TkZrWEW+I
         3dEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756286777; x=1756891577;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=RObNvhRzj14YrAIax+dM99xs/Xf3Y4EHrFUMEOiDAYE=;
        b=bUp6P3R7DGyB/7AJXCyL7rA0Z7EGqLar652QZUAgn94QHjRKCjKJqld0oAjs/maGki
         8hZGLVsCkNmcsz5BDZRc3qmSrUb9zBJb7NnbnF2SrZalph+zfU5+hnGmycfvTFGDrata
         OEEqY2nSIde6VkMD1T55hqU+q5OVYFsMxwUX+jw9gD72LqK4OifFkn1B7E2buno3wBhL
         yjO8q5ZzADBIw6JF+Lj9ukc6iTw5f4rQJmZlHvdm9YMPbj61WiLOvm2FpFRJROYDtyIY
         QN6fFTRruuO9bdo4bYAjA//qLpYPoEGe54HQVK/muiwK6By/hHaj7GBkK6HJ744uPJ5g
         9bdQ==
X-Forwarded-Encrypted: i=1; AJvYcCWxZMaUWLXPojTuW4QCteoqV57l7TXG8OTCwt6x8KAZokSXjRh39Xff3Tfow4X4f4LHdML2b6Xf@lists.linux.dev
X-Gm-Message-State: AOJu0YyTdDiA6ESRxMMjaldM9Ijt83/SsWFxpvnn3tfULKZTqMDN657O
	K19p3GazJ7YSdeXFoaGK9Yy+HxIq+qczQqURRHRURNoCpgbFdfjJxGhgWdVuAd9bW+fQcBublFj
	8Bu9YU6fXhCa8k42v2pDQeWGxaM5lFf7so9UnBPnKqg==
X-Gm-Gg: ASbGncuFND2IWl1y73Ma7NQYmdTWz2d7csZM970XqL5bfwtarlu3XkSFrKlGJL7XIZl
	oSsHtnPyAzXYCt3aJehg59Xs5X8iaXp/mvijp6AB37MFzjGv9EYPmWlNuyDkdjFSQYVtPsmnt4a
	zhzH0T+Oo+OdtuBMJHVOy6DIvoOiXaiN+A/PQqcKXnoSoa918KAyHi1FHqo/JL1wGbXiFxd6ZxP
	9d0/od1g1FPb8BWGTRScYev9ws=
X-Google-Smtp-Source: AGHT+IHjJ8ojfehejC6rUtG2n9YWVWEdlo8h3+JG4hp5aDstD/xNsnAnq5uvb/MrWZkcfry6UfWdzDOZp+dxXTeBdvU=
X-Received: by 2002:a05:6214:4c86:b0:70d:9819:8799 with SMTP id
 6a1803df08f44-70d98198c61mr126143366d6.6.1756286777207; Wed, 27 Aug 2025
 02:26:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250826110930.769259449@linuxfoundation.org>
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Wed, 27 Aug 2025 11:26:06 +0200
X-Gm-Features: Ac12FXyfQSMfovOH5u8fKvG_4IT8L7R8HIzuMNFjhYcsK1bP_QGHDLPsal_-a3A
Message-ID: <CADYN=9LgcCC-QLMpQNuKq4wW9iOqZqPrNovEYY7r3=TRsidbgA@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/482] 6.1.149-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"

On Tue, 26 Aug 2025 at 13:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.149 release.
> There are 482 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 28 Aug 2025 11:08:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.149-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro's test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>


## Build
* kernel: 6.1.149-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 3c70876950c1fcf1008baf5be67b598127de7679
* git describe: v6.1.148-483-g3c70876950c1
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.148-483-g3c70876950c1

## Test Regressions (compared to v6.1.147-254-g7bc1f1e9d73f)

## Metric Regressions (compared to v6.1.147-254-g7bc1f1e9d73f)

## Test Fixes (compared to v6.1.147-254-g7bc1f1e9d73f)

## Metric Fixes (compared to v6.1.147-254-g7bc1f1e9d73f)

## Test result summary
total: 226713, pass: 211004, fail: 4615, skip: 10850, xfail: 244

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 41 total, 41 passed, 0 failed
* i386: 21 total, 21 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 11 total, 11 passed, 0 failed
* s390: 14 total, 14 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 33 total, 33 passed, 0 failed

## Test suites summary
* boot
* commands
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-exec
* kselftest-fpu
* kselftest-futex
* kselftest-intel_pstate
* kselftest-kcmp
* kselftest-kvm
* kselftest-livepatch
* kselftest-membarrier
* kselftest-mincore
* kselftest-mqueue
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-sigaltstack
* kselftest-size
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
* modules
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
