Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AAF51A23A5
	for <patches@lists.linux.dev>; Thu, 31 Jul 2025 10:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753958338; cv=none; b=MI489nMWvIUg2lU+P2hvF+6O3XY1iLOkYLSF0rhxSbhCl0rOBncUkBohc18irsmLWKVGmace6N3hyFlYd/fMX5RA/fPXaxWWDeg/ertSVHd6RpIuPEkvSSuvt3dxJQjvcUAcMLLenXLO/qn4yTrHiq+Eu5kJXynLoB86C9rkHkQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753958338; c=relaxed/simple;
	bh=DKmgLs+7rBMzNOL+M6hkKTnZ6DyFBymJ0tEIRgBIGRs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OWPuof2JqcrM250XE5YU9CnCLch8j7cZy3QsKPGnbG5cVyLYJCa+trRgcBNxGRZtdAzQ/0mUJzoSPEer6WcoT9rGv22LrUszJoDDvoOQATIqBkC8RT/lXqWP1P9UgdRbCJtHHggzvLk2fByB+z+fR9fQG44r37DGbZQpqxBw+Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BGibQfFd; arc=none smtp.client-ip=209.85.216.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BGibQfFd"
Received: by mail-pj1-f42.google.com with SMTP id 98e67ed59e1d1-313bb9b2f5bso783184a91.3
        for <patches@lists.linux.dev>; Thu, 31 Jul 2025 03:38:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753958336; x=1754563136; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkDvSnoU7TGvsvWlCPvSXBARcwQMXUgFkZZD6Fvwrvk=;
        b=BGibQfFdrEtEyuSHxpyHFaapMt6iNQQPU5XfHaNg7cOoMkOBZH3IyB7zTHJMoRWdAk
         dl4rbU1B418o0e2zWmDVFt+vHb1ls6NTjc16CwxyuQbBAhm0+ONfRLZ2RwHcWaHriraZ
         8K7DfFEJFFONoBwbMfKUme9stH6c/QXB5FkBkmrkNMTNsYdYNHPGnJzoW6Dz+t27Il44
         khfYl3W4a2vOZ5jTjqThOu9COTN+QfEmk8OP2L9WIP099nA/tyGC2p2yW1tgFdhQxe2B
         RZ1aeGEr7XhK9L4LUmskPEC1s39ksz+T6QdzU1btVKrAEBtwncJC2qaeWPO4PJ1MHqJm
         gv8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753958336; x=1754563136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lkDvSnoU7TGvsvWlCPvSXBARcwQMXUgFkZZD6Fvwrvk=;
        b=iAKkXu7rgoogmd5f53u5Dx56nfilpO4zBPzNsVCpz5q/LO43HJg0R7vOfRflYKaGln
         16SH/o7Zl2dIyMtf1avycBX8EMZS/tLwhkhm/kCdTAeCrVuPgRt9B+y68MuEXvMlD5Xr
         /u3IgXd6eLmrNqdRIBLFdC1Sfk3Q3xvCH7SgmVOYKH8wOSGEvEe0+NyxGv0fivpdddCD
         0I02LZ5AyVQUR1HNLCyCstBqipb2RyB+OO1hkQgAL6WXnWMhezy8VovyiMsXDkThcMwz
         mMTu/Lerwt08AsE/L7jnyFGlo+Cc0Oi8sL10et90ynAf6jibbBwOcVGNxuS7F0GlE6+x
         XLGA==
X-Forwarded-Encrypted: i=1; AJvYcCV2qq5TpkUj1NWl9EdBV3Ge02TN8gu90mR1EcKOf8NnaI5c15+EuYF25WoDOIuV4MwuB/70INgq@lists.linux.dev
X-Gm-Message-State: AOJu0YzhFrOspWjkvw7DxDdWt3GACawDHsWcS1j46O7tJqr3ELANQ7J+
	sble7XREWOatYiGNV5+6nsgySTo4v1dbUql8qRNGfMm+HIBBYJnI8C9r0ucmR0uhTqG+VkO4n0O
	Hm5m7WYgCqwXi/n3se5/JpIYYSzudWxF2oO1StSqGXg==
X-Gm-Gg: ASbGnctFdhXsJVo9xyXS5XDyq3hyA+7ZDoSKiBjvFq3jbnE+cQcfMTkrEXtKQvR8c/M
	lPtG6eTUMbtyNFWAqSdnWwAVECdu0DvL0njKCJSvx42/ZALz23Ft21TGY83bSC552hMHN+7sMuQ
	gk66hUKpm/UVi2ZhG3qzPl/69y0q9qzl+nFobUYfooov0waCiEyweERL5Nm9GNssqWNA1jLdJXy
	6FrV+wcMkyEOwZW4FF33ftt7nWjcWyoJpy/HCJfkjrARNeXQQ==
X-Google-Smtp-Source: AGHT+IH/Y0utzzgvreW0dJK6xOnQ+BoUywaZ0Mpb8ym8+E/0auciSYgHSSPN0uqHK97ffk4lEtYzEcPfcnLh3wWwwuU=
X-Received: by 2002:a17:90b:4cc1:b0:31e:d929:5ca5 with SMTP id
 98e67ed59e1d1-31f5dd8ca97mr7850100a91.1.1753958335561; Thu, 31 Jul 2025
 03:38:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250730093226.854413920@linuxfoundation.org>
In-Reply-To: <20250730093226.854413920@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 31 Jul 2025 16:08:43 +0530
X-Gm-Features: Ac12FXxAjjqKYT2-ponmIrQtaahksxYUlIaazzjNQgBtICQCKclPBbgg48ZtZqw
Message-ID: <CA+G9fYuGLcr1Le+ARav_KsAvRqc86zJfPfEc2Xatkvq1NnWBdA@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/76] 6.6.101-rc1 review
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

On Wed, 30 Jul 2025 at 15:08, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.101 release.
> There are 76 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.101-rc1.gz
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
* kernel: 6.6.101-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 1a25720a319a8ec7842cb8ec20f6614f8eed10ce
* git describe: v6.6.100-77-g1a25720a319a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.1=
00-77-g1a25720a319a

## Test Regressions (compared to v6.6.99-112-gb00c1c600f8c)

## Metric Regressions (compared to v6.6.99-112-gb00c1c600f8c)

## Test Fixes (compared to v6.6.99-112-gb00c1c600f8c)

## Metric Fixes (compared to v6.6.99-112-gb00c1c600f8c)

## Test result summary
total: 295209, pass: 276307, fail: 5627, skip: 12819, xfail: 456

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 44 total, 43 passed, 1 failed
* i386: 23 total, 23 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 15 total, 15 passed, 0 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 7 passed, 0 failed
* x86_64: 37 total, 36 passed, 1 failed

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
