Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA6B923B63D
	for <patches@lists.linux.dev>; Wed,  9 Jul 2025 20:14:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752092062; cv=none; b=n6i30rr8nQC5ZPGUCwdhxkam0PvKpi+NW8/RPrUUPJ5CKvWEmGACC81ZLgrsvyBb0EISD8TmPWcYaofQIISuZD6cTg9AaAtrpKlL8J4Ah7mO1fVpL5m0y92rcLGcl3Rf9nZKrXzzo4mrpJ5l8NEOBszX4TaxmjrKNOd8/j+PyjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752092062; c=relaxed/simple;
	bh=mZkXqww+jb/XVO71FjjioqL0zO3mDWI6ykKz9T+vzLs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QETudl8vEFzp3Ty6Xf4ZV9WlUMVLa9b9fPcbQfJQl8pIB8R2oo9F6mo7ve14IRmYW/CmmEgddm3OyKYLfVLSsgmoq6d4DPeNr6SxpV+VyOfQ0iX8EgJSyZGYbXFhkJpzDe3fXePCiqqSHkG98PvFRo8gtESxGdnSNIZ8e5zFXZI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=D+JKLkZD; arc=none smtp.client-ip=209.85.214.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D+JKLkZD"
Received: by mail-pl1-f170.google.com with SMTP id d9443c01a7336-235ef62066eso4858685ad.3
        for <patches@lists.linux.dev>; Wed, 09 Jul 2025 13:14:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1752092056; x=1752696856; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wuxYNeYCZnL77eXJRYZOLoWLDjp2y5zriWpKfZSuYH0=;
        b=D+JKLkZDV8Il80dsBR9L0BksTTqW/ccUPlW0DZpwdV0KrkX9272PY5jueFnUqEQ9I6
         tjyFLdazHgomwU+686T4npgQdFBBoOcDN3Oq2+/tjHHRGJEGeb/mkzvRARus5Oi5SKKi
         GjA0wrK69v/9B2dKHnqt6JzskFovi427hdNq8wuOzD/Nkc+rUjylrZHqgIbAv7FazwDB
         JDcB9GjFYKQX7D9Drya1imD1Q1B5CKXAsQKkQXZWQbAIaSceQSxhQWZlv2kSh9O3UlSv
         qovlxANGJtSKZAt+MLYTOt9EcEAtwNOTLHbhxjJUcPFnpsFlA3jSrOgWe4JmdgGPuJNt
         CZXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752092056; x=1752696856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=wuxYNeYCZnL77eXJRYZOLoWLDjp2y5zriWpKfZSuYH0=;
        b=SAz8nCiQsFod/1NZb3Im+YU+JgG0V7uHY3VfY7/AcgJTfQ1K5FBG1c53TPF2OKTlWl
         Vuur/5NXM+W+TG5MnMedqAwrM4pvtZfPASrnqFj6nhN4umoHX2B2Q6pMxqDBwUbJ6SUA
         IVZmJuT+X0cwdT37r3LqdcTA0DnqmyLjfd701Iriwyq06GHpOsZQOdBn5rOHq8PaDS7T
         wKf5CypxG3EcxYiSsT3qw98lxkv8EdwE9Ij5C5cCH6PXZOdDCmRvhGuJWajEIqC76Y4n
         Go8zmOYTtVib/SynIBMxwDNU1WPSKh3vZpnUcLgnOeF1VV3ylDuS6rYcY04GPjKHzXIH
         pDsA==
X-Forwarded-Encrypted: i=1; AJvYcCWeflnJ6ai1rKMZaza5PefKJfEjmhvcPvcwRPqa0PJNI47dXMNipN1RSRFbr4L0RdyBSZpa3aju@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/STB2QaNSBb2bKdczXQ0ANScc6ScVRBSMLDKoFdfNkQUMpnzD
	grXaywsIgLfTeFN+STYlXNmzG83bM0euW1XLteLYw7Zi2Uq0laINzR83T67khV5X/F4VlxQoAYi
	wtmFb0kw19qH3jfrBIA2rrkFIavBIMb+D3SgcnvS0OQ==
X-Gm-Gg: ASbGncsZTSjUEaa629ibomHeyYckOYGSUFBpr1iRcR5U0bt4iujcLxgZ1TkcMe5HT4E
	C5htaFwXALmqwlM6qLf38sqwvSHZkhHfXOAJ6eoYXzAkQe8JXbp58YysearX6H+Tu4TPirDRfkb
	ELuwiqcpBeRmPRcoFdmW9CaMeWpR6OFgmDMktZT4mxdEdicaJgheuXZQUatDoAY0UYF6SRH8XFw
	pw=
X-Google-Smtp-Source: AGHT+IFh/sTD5lUyOFdlw8hE/8kKo7Xs9ZCqPLR1Lh4w5Hi9Jl20KQ/pQrs0JRpksabCumWnfS39o2yvc5ajsDmmhNc=
X-Received: by 2002:a17:902:e807:b0:234:8c3d:2912 with SMTP id
 d9443c01a7336-23ddb1992famr54743615ad.11.1752092056088; Wed, 09 Jul 2025
 13:14:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250708183253.753837521@linuxfoundation.org>
In-Reply-To: <20250708183253.753837521@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 10 Jul 2025 01:44:04 +0530
X-Gm-Features: Ac12FXzORM6LSIxCdmx06q_Rj-1ftioDgwAg8gn-LNGMC7ssMysWR_Kqlywr4AE
Message-ID: <CA+G9fYubeQ12JprZ--NJ9-kcsedRre2V1ZBadeGevo62kpbQgQ@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/130] 6.6.97-rc2 review
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

On Wed, 9 Jul 2025 at 00:03, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.97 release.
> There are 130 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 10 Jul 2025 18:32:37 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.97-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.6.97-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 7b8f53dba183736f96bb25a8e29066fece62ce31
* git describe: v6.6.96-131-g7b8f53dba183
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.9=
6-131-g7b8f53dba183

## Test Regressions (compared to v6.6.95-140-ge950145d456d)

## Metric Regressions (compared to v6.6.95-140-ge950145d456d)

## Test Fixes (compared to v6.6.95-140-ge950145d456d)

## Metric Fixes (compared to v6.6.95-140-ge950145d456d)

## Test result summary
total: 287982, pass: 263718, fail: 6340, skip: 17505, xfail: 419

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 44 total, 43 passed, 0 failed, 1 skipped
* i386: 23 total, 23 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 14 total, 12 passed, 1 failed, 1 skipped
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 36 passed, 0 failed, 1 skipped

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
* modules
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
