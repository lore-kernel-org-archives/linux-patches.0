Received: from mail-pf1-f193.google.com (mail-pf1-f193.google.com [209.85.210.193])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56969382593
	for <patches@lists.linux.dev>; Wed, 17 Dec 2025 13:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.193
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765979628; cv=none; b=sfoceltjR0X7bdxXCLIvdzEQWhn40n6ZwEKD88JTjXqh4Y3RoIC7vHXJ8e+yPs1C3tzqU7oKwkclw69DR28TsN/BIbU+4lodbAJ/jQceVVOr522Sbe6CPsamKKQ9KmdQqqmbpLG2gIvvQqIoyinCDZC5u+qiudC6zBuv8tm5714=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765979628; c=relaxed/simple;
	bh=ymWYLYY2hCVl28DTIf7vb6XCEeATST3CD5cKX1npf2Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GO0RoIjLNR/D58Y3ncA8iVCu6mIeDLAR+SHojsEikt49+B1+wo++QfBSIy7gDM8dfgfROb1ojREcMv2Oi7U7jEVmjW9CNB/La0zafAekARZb88waVatjjchxpBdNiG84BwsF0bFR71y0gtudPTn+DXbp1I/AqQ55pFK9qdQQWPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Vv70YvI5; arc=none smtp.client-ip=209.85.210.193
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Vv70YvI5"
Received: by mail-pf1-f193.google.com with SMTP id d2e1a72fcca58-7b8bbf16b71so6188977b3a.2
        for <patches@lists.linux.dev>; Wed, 17 Dec 2025 05:53:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765979626; x=1766584426; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bw6domGQXb5We95z2PGEaiqjLe5ajxqpO51i2VZVJ88=;
        b=Vv70YvI5hlPVkjoU8m8f3U7Gkbbr4bgyXKwVAAhU8i3BRdYwm2h1N89TQAJ7ASEni/
         mzdPOXguDTwugXkPucpzFBUIHVbzbQkXdrscBEKX2SIAR7kJaXx29smCcr69acZvmDwW
         NRledVSeNQKJS/zPIZPflGmO2OWcYRkZ7K6zZoLTj9+XmNikryv9nvJbKBkFun8fYnw4
         udOMtrfbYTWINYAabtQ8G8isq0jYVj44vqwgNYai9WWiyCIMFQ8bJJGsmCtfTiO2V6X7
         HYYCoq24q/XDVqDwa8WoJ+nV1QsuH/9AU6JegF8AB5L4yi4I6I5n5amhyKNNl4G/MQg7
         rhVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765979626; x=1766584426;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bw6domGQXb5We95z2PGEaiqjLe5ajxqpO51i2VZVJ88=;
        b=nmCrsn/31+hd05PDkM+5O2Ivi7Sto0YnFAUtoOsUZD8+olxWBFujAEz2qNQshqKBt1
         1/PN09UNZwXtGssOmbCSvVTy4TcHaHqY9VFreSlr/E6PNEOoM6uM/7Jc/Wv3Wy7XfqgD
         bizr7p7Bbci7Mr0iNzw6wp6GSksEIIR/U2xKMefcbNyyN91d3Qk+dt9x9h/cOKTt7enS
         VAOPrpiJxgQH64CT6jf7xYFRnXD4eNC578a4gB58KU2E2OU4+1YRyAxAYE9dBVASDlNj
         X2AuPEGo/Q9FMH2/3yDkM3+9VxBU9M0nqJWmVbBpqXJMWLBmSW6crBlp9loYXkJcC2CS
         VKfQ==
X-Forwarded-Encrypted: i=1; AJvYcCUQTiauh46+P6vuixGuhqYOZeJkHA3yhUT+jiY2yGTpMXxneQByVwX2XKP2D46lJPCJj1ryodtR@lists.linux.dev
X-Gm-Message-State: AOJu0YwApfPP3cWb3ZEWK6I6wgEtOl3A+oSx1T8+5nwYf4m5zx5zh4Ip
	E6oekPQHyJD2S+NCFQFCLsIMISkhsuSLbuAEgxxjXaXZNVEHWE31pl7tCGyw03nuBLw=
X-Gm-Gg: AY/fxX4u7d16q4Ve+K6zSdf0vJMwS6Ty2BP3r2Iqk9VU1K6F6ZNwcM4Rg4lU/N3zNYf
	J5QjAjYrVwwN20z/4cMVelnukW1P1CzkLNcKUrHaaIdn41mM1glRt8/oQ9NN+s/CpYZiRVpmH6r
	GOeohCMCREwFmsaIwTIt9ks41doRyaFe8FP7qT/MCk9MtcK9uByqlUYOzUGxkd908RnrSCcYxz/
	Ydc4uGrxtTwdRJCgZxhhi1uoQl6BT8ps0U4qeqEBSmP7ycvXVwNubSl1m5hFW9RlE3wTHAQSLBI
	t+bWCBB4WoeJ7cGwnfRqjQ+r9Vlx7IVraEHedEkJlhVlQ1VmlJYLRPIb1nqI+4A+9X4x/tbrqRf
	rzUZUoxa3oHYx0wQCaoaoteayjQzMLs83zcAuumZCH/ORPeQ3U7UK6QeVPiPsKCGOl/SaB3+eIG
	kT4nKrjfUL4JfojzyU
X-Google-Smtp-Source: AGHT+IGJjIoNyzEoQRNyQQ0EVpiAF8sJKXpD2h9Vf2anlo2Omut3mjOz22uIu0wg92zvh+eZpb5z9Q==
X-Received: by 2002:a05:6a20:939d:b0:341:9db0:61f1 with SMTP id adf61e73a8af0-369b433b221mr17001311637.16.1765979625467;
        Wed, 17 Dec 2025 05:53:45 -0800 (PST)
Received: from localhost ([2405:201:c00c:2854:ecba:10b1:66e4:448])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-34cfd7036e7sm2539893a91.1.2025.12.17.05.53.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 17 Dec 2025 05:53:44 -0800 (PST)
From: Naresh Kamboju <naresh.kamboju@linaro.org>
To: gregkh@linuxfoundation.org
Cc: achill@achill.org,
	akpm@linux-foundation.org,
	broonie@kernel.org,
	conor@kernel.org,
	f.fainelli@gmail.com,
	hargar@microsoft.com,
	jonathanh@nvidia.com,
	linux-kernel@vger.kernel.org,
	linux@roeck-us.net,
	lkft-triage@lists.linaro.org,
	patches@kernelci.org,
	patches@lists.linux.dev,
	pavel@denx.de,
	rwarsow@gmx.de,
	shuah@kernel.org,
	sr@sladewatkins.com,
	stable@vger.kernel.org,
	sudipm.mukherjee@gmail.com,
	torvalds@linux-foundation.org,
	dan.carpenter@linaro.org,
	nathan@kernel.org,
	llvm@lists.linux.dev,
	perex@perex.cz,
	lgirdwood@gmail.com,
	Linux Kernel Functional Testing <lkft@linaro.org>
Subject: [PATCH 6.12 000/354] 6.12.63-rc1 review
Date: Wed, 17 Dec 2025 19:22:48 +0530
Message-ID: <20251217135249.422394-1-naresh.kamboju@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Tue, 16 Dec 2025 at 16:48, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.63 release.
> There are 354 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 18 Dec 2025 11:12:22 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.63-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


1.
I'm seeing the following build failures on s390 due to,

## Build errors:
arch/s390/include/asm/fpu-insn.h: In function 'fpu_vst':
arch/s390/include/asm/fpu-insn.h:381:36: error: 'size' undeclared (first use in this function); did you mean 'ksize'?
  381 |         kmsan_unpoison_memory(vxr, size);
      |                                    ^~~~
      |                                    ksize

The commit point to,
  s390/fpu: Fix false-positive kmsan report in fpu_vstl()
  [ Upstream commit 14e4e4175b64dd9216b522f6ece8af6997d063b2 ]

2.
The clang-21 allyesconfig builds failed on on arm, arm64, riscv and x86_64
as it was reported on the 6.18.2-rc1 and 6.17.13-rc2.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.12.63-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: f8100cfd690d4b1fd45bdba30428b0eab2980dc0
* git describe: v6.12.60-537-gf8100cfd690d
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.60-537-gf8100cfd690d

## Test Regressions (compared to v6.12.60-182-g4112049d7836)
  
* s390, build
  - gcc-14-allmodconfig
  - gcc-14-allnoconfig
  - gcc-14-defconfig
  - gcc-14-lkftconfig-hardening
  - gcc-14-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-defconfig-fe40093d
  - gcc-8-lkftconfig-hardening
  - gcc-8-tinyconfig

* arm, arm64, riscv, x86_64, build
  - clang-21-allmodconfig
  - clang-21-allyesconfig

## Metric Regressions (compared to v6.12.60-182-g4112049d7836)

## Test Fixes (compared to v6.12.60-182-g4112049d7836)

## Metric Fixes (compared to v6.12.60-182-g4112049d7836)

## Test result summary
total: 84881, pass: 70888, fail: 3200, skip: 10584, xfail: 209

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 137 passed, 2 failed
* arm64: 57 total, 51 passed, 6 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 24 passed, 1 failed
* s390: 22 total, 12 passed, 10 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 46 passed, 3 failed

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
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-kcmp
* kselftest-kvm
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
