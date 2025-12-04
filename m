Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 646673396E0
	for <patches@lists.linux.dev>; Thu,  4 Dec 2025 10:44:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764845053; cv=none; b=ISSECgQ3pXwxbym9YtDKLtShvpf/kEYtXX40zoSua93plIJ1HVkyi8ePJPu/PXeoGIGPFMikewviG4j9NOyi0Y8JQxdRUkwGJCp3Qldsg7FPyMoIeYGimFVZkSjof1sxKmI4Faqr+gbN7iKTnFCtcxsIKv6Wmc8NE+BbrTHQu3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764845053; c=relaxed/simple;
	bh=BJRTTdVX0u2pUTv+Q/CvQHvi7Ihop9MWNqXE8mrGea4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jDa+eLudGU4jhsU0WU9Egz1wHBrCiyGWc0Fry695AeE4dOOLwAibfeMSHGv8BbD86/jMtTkE3EdcGQQO3YWTkhdCi5rRah7mXjHy2KAE0lEl/fQotfxbaWXjEafKXpUgSlhvHatJpnsD5xs2jHqt6WF3YpC5lhub47COu2tf2jI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=uLisBXDr; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="uLisBXDr"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-bdb6f9561f9so723921a12.3
        for <patches@lists.linux.dev>; Thu, 04 Dec 2025 02:44:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1764845051; x=1765449851; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=WtF+Aqjzm/WYE3KEy+g02XpY1h+HydEs9u2HSJlkEPE=;
        b=uLisBXDrN4R+u3iYxo8bxgakh4VmX6TvQpYrq3j7dqUEppABuy5FFtRMmUSEa3PCa/
         M/ubCpfFW15AE52aicmaFAvdO41DinkOiE7YxR3+T0A2bjU1CecK7nuzBLaqIIoIDw+k
         I1a14Ll/D+LbYSvMzth66h0Um6vPhuwTROIzk+Gd8ty4X4mVBF8IdGwVMePGhNF0HuCa
         EMXHhrs9kuBzmfwpZRaEw84IJlckb69PPEdVYob3pqGn6YtR5xyELDaA122tw5PogwG8
         7Z8LIK/YVpb7nA+ZueIKM3m5PzUOZue41rDwT2UmCgqB+X/g59ZtzjBlICBQkx0gCtXo
         5Syg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764845051; x=1765449851;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WtF+Aqjzm/WYE3KEy+g02XpY1h+HydEs9u2HSJlkEPE=;
        b=m8V/RiG4y115sMCauUtfNvh4lSadbQ7BKCmMHcXZ4Hj5DDK9j7xTR/eylkNUqKOnuH
         oJAfhUoHyQyccOhKgIvZk2MggtFy+G1cL+m+BCa7HBToxl++bVKticTnfupRvbzi+hGx
         GHG8tHsOBQ0BWulOQt4v/IgRxd9zrGElp8xgrnI7HIdPSegJNiTRPwZ7JrfhxnN+Jg5L
         +6AuQ/Mgq0OVPSQQYf35IO9ZsHDhmJarLMXPxQPYfhPcRJSYuGLe4rBptbun/kFiVtp9
         143K8SAbpp2Mt3sXBRZrQ4BDAHCyYq8ZrBt62lSS3gjq7g+Io8nc8UV11kk5UX8EubWY
         aqdg==
X-Forwarded-Encrypted: i=1; AJvYcCVJryGOonvtFuIhe3TV5aWs2KM0aQj9PAO85U1/784No90bUOYrQf3S0Vh82PVLGDPZ+vZStr+v@lists.linux.dev
X-Gm-Message-State: AOJu0Yzh2k9IsexUbMLyFMRFFS+DEAk/B4QDLw3ut7xzSsvlvyYaX6DG
	CgC3g6VSStmicQA92Z7EVrzdeq0QUkblmBzJkIeNAoB9JG9t+aL0q/fYFO+TdpS52WUXAxIA4Vh
	WFc3l7nN6CwY+fUHu3dijFEypqVfUXWNUNFBGMYQR4A==
X-Gm-Gg: ASbGncvWNGM1QdAoK73GlscPfXYuXO4daYr8VzPce7tY1VnI8Ts4xKCRJx3twAqUx4i
	FkIHYCHg37tvsnbB5R+I9AnL+5T+9ktusgBqQf1hADUKYeHqqCGSo51f8mtiIbPrb2JNIKaifxY
	Y4dI94pIHvS/PLwQVa9YRjhSVUZS308tZl5+FGLjon4rTrPwxbHyPZ+wPnIONnQeOhSMG7CXG9Q
	VQU0d7mrqw8m5jV/YxiPqpjU43cehSshhH6LpwyKCiZqdlvX9GqKEQ5G8fMAf1IoGtIDaULJjIP
	5qm0B+ckHPBib7T6Yfj8DXjLqa4dbAk5hFeUehs=
X-Google-Smtp-Source: AGHT+IFAJ2CZUznrTFksDW3w5GvNMalFr+CO3O+rhD4mQ2hBBJxciRTwnpIYSDAZP9MnugFZU/REHnR47Wfk0IfeNA8=
X-Received: by 2002:a05:7301:319:b0:2a4:3593:969f with SMTP id
 5a478bee46e88-2ab92e2ba76mr3921689eec.28.1764845050451; Thu, 04 Dec 2025
 02:44:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251203152440.645416925@linuxfoundation.org>
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 4 Dec 2025 16:13:58 +0530
X-Gm-Features: AWmQ_bmAl-hgydOnhau6L7BFlOrYmCn60oaNj2eL9o7iZX9XrB1YzBpcG_aGkNs
Message-ID: <CA+G9fYuoT9s1cx3tOoczbCJDf2rtrmT1xSg-wut5ii6LG6ieMg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/568] 6.1.159-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, 
	achill@achill.org, sr@sladewatkins.com, 
	Adrian Hunter <adrian.hunter@intel.com>, Svyatoslav Ryhel <clamor95@gmail.com>, 
	Mikko Perttunen <mperttunen@nvidia.com>, Thierry Reding <treding@nvidia.com>, 
	Arnd Bergmann <arnd@arndb.de>, Dan Carpenter <dan.carpenter@linaro.org>, 
	Anders Roxell <anders.roxell@linaro.org>, Ben Copeland <benjamin.copeland@linaro.org>, 
	sparclinux@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"

On Wed, 3 Dec 2025 at 21:48, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.159 release.
> There are 568 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.159-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The arm and sparc builds failed on the stable-rc 6.1.159-rc1.

Build regressions: arm, fuse-tegra30.c:250:10: error: 'const struct
tegra_fuse_soc' has no member named 'cells'
Build regressions: arm, fuse-tegra30.c:250:18: error: initialization
of 'const struct attribute_group *' from incompatible pointer type
'const struct nvmem_cell_info *' [-Wincompatible-pointer-types]
Build regressions: arm, fuse-tegra30.c:251:10: error: 'const struct
tegra_fuse_soc' has no member named 'num_cells'

Build regressions: sparc, allmodconfig, ERROR: modpost:
"pm_suspend_target_state" [drivers/ufs/host/ufshcd-pci.ko] undefined!

### arm build error
drivers/soc/tegra/fuse/fuse-tegra30.c:250:10: error: 'const struct
tegra_fuse_soc' has no member named 'cells'
  250 |         .cells = tegra114_fuse_cells,
      |          ^~~~~
drivers/soc/tegra/fuse/fuse-tegra30.c:250:18: error: initialization of
'const struct attribute_group *' from incompatible pointer type 'const
struct nvmem_cell_info *' [-Wincompatible-pointer-types]
  250 |         .cells = tegra114_fuse_cells,
      |                  ^~~~~~~~~~~~~~~~~~~
drivers/soc/tegra/fuse/fuse-tegra30.c:250:18: note: (near
initialization for 'tegra114_fuse_soc.soc_attr_group')
drivers/soc/tegra/fuse/fuse-tegra30.c:251:10: error: 'const struct
tegra_fuse_soc' has no member named 'num_cells'
  251 |         .num_cells = ARRAY_SIZE(tegra114_fuse_cells),
      |          ^~~~~~~~~

### sparc build error
ERROR: modpost: "pm_suspend_target_state"
[drivers/ufs/host/ufshcd-pci.ko] undefined!

### Commit pointing to arm build errors
  soc/tegra: fuse: Add Tegra114 nvmem cells and fuse lookups
  [ Upstream commit b9c01adedf38c69abb725a60a05305ef70dbce03 ]

### commit pointing to sparc build errors
  scsi: ufs: ufs-pci: Fix S0ix/S3 for Intel controllers
  commit bb44826c3bdbf1fa3957008a04908f45e5666463 upstream.

## Build
* kernel: 6.1.159-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: abd89c70c9382759c14c5e7e0b383c2a19594c5c
* git describe: v6.1.158-569-gabd89c70c938
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.158-569-gabd89c70c938

## Test Regressions (compared to v6.1.157-158-gf6fcaf2c6b7f)
* arm, build
  - clang-21-defconfig
  - clang-21-lkftconfig
  - clang-21-lkftconfig-no-kselftest-frag
  - clang-nightly-defconfig
  - clang-nightly-lkftconfig
  - gcc-14-allmodconfig
  - gcc-14-defconfig
  - gcc-14-lkftconfig
  - gcc-14-lkftconfig-debug
  - gcc-14-lkftconfig-kasan
  - gcc-14-lkftconfig-kunit
  - gcc-14-lkftconfig-libgpiod
  - gcc-14-lkftconfig-no-kselftest-frag
  - gcc-14-lkftconfig-perf
  - gcc-14-lkftconfig-rcutorture
  - gcc-8-defconfig

* sparc, build
  - gcc-11-allmodconfig


## Metric Regressions (compared to v6.1.157-158-gf6fcaf2c6b7f)


## Test Fixes (compared to v6.1.157-158-gf6fcaf2c6b7f)


## Metric Fixes (compared to v6.1.157-158-gf6fcaf2c6b7f)

## Test result summary
total: 80660, pass: 60774, fail: 9871, skip: 9886, xfail: 129

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 115 passed, 18 failed
* arm64: 41 total, 38 passed, 3 failed
* i386: 21 total, 21 passed, 0 failed
* mips: 26 total, 25 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 32 total, 31 passed, 1 failed
* riscv: 11 total, 10 passed, 1 failed
* s390: 14 total, 13 passed, 1 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 7 total, 6 passed, 1 failed
* x86_64: 33 total, 32 passed, 1 failed

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
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
