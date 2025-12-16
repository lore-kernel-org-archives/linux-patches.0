Received: from mail-pl1-f194.google.com (mail-pl1-f194.google.com [209.85.214.194])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3E5D28CF50
	for <patches@lists.linux.dev>; Tue, 16 Dec 2025 19:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.194
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765914784; cv=none; b=a6kpWNeYIJrLNIIof09ZrzA+pIM1hVj1/Odt+5p+oxKUDOw5oV84dkVzhrSbjwGESpXKMHPFpv2/ZY1pojipgLJmU4vQXSwubTrc8Mh4risgVcB/CmneyOD9kIwGACXNkdfpZCvS/kR5o0yMy/wJEkJcI1JEWErFuJ44HvYZFnE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765914784; c=relaxed/simple;
	bh=iyfpfta9T3ygezPPDfJaAAlV1FmCLLJlERf9Bqj3wl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LZV+1PCC45JgIY0KEn0OGjpAkr/aqWjM8lVZ6pepg5ULUZcWJxr/EF7CWn+Kcgdsp66J/Z5QlWlfEuUUKAM1Jb5oCR598THdxvqGHRjYnflpj/kDDMZxvgrczTRR51i1tfK9TZtJObvX3xQEXJrtjbLMAV0wNaDQP5H0Eq9AxnI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=My25HNut; arc=none smtp.client-ip=209.85.214.194
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="My25HNut"
Received: by mail-pl1-f194.google.com with SMTP id d9443c01a7336-2a07f8dd9cdso36673205ad.1
        for <patches@lists.linux.dev>; Tue, 16 Dec 2025 11:53:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1765914782; x=1766519582; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pMv6aJNeWeKxyQePqdx7Y+0/5WaZPbWRmp5WC5tFCto=;
        b=My25HNutXF0fE7SoPVquJ+5XxUFp36d/anOH0kCRShZWUrnFsbkj2sVBT2W2sifhVb
         UKDvJiwTgRKteVHhl/s3lfS2DfiUpb+96Q6G05fl5BFnQzCkpWwkic37p3fq8xe1zQuG
         mL8c0uI3ILAwYgG5H/5x8VkKguqdgO8k37wSR1jbHx+60e+wN5Oq7MP1WjpCHtcALeRy
         OBaG2188EBPpY/p58HVbw1EjZRa++mKDWn8Sqf5oseE+w2f8n+WPefILvlemWWQIyfDi
         X81Ny6/GUE+AzB16c5d7WUWM3V/2amqPh6ZG1SdEhLI7Oqenr2LvIVCNJ6U5K2ftmS61
         W/Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765914782; x=1766519582;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=pMv6aJNeWeKxyQePqdx7Y+0/5WaZPbWRmp5WC5tFCto=;
        b=by2X/I5IF0rBhObbt9tmlr0qiPhwrVHX+kHoouie+LY1x3YTSRJ97JYD3HeW4eqWYB
         au7faDZaVQFcxcNbiRlvx6NLdgYpsUPQU4obKx9GXiAwqMUjWT0JJCAIsAETCBsXkEWu
         vYQzuWzyVBcMS8PuwWPzTWt4fmxtcBbFaDE6PxpzN3wQy8Gel70dk0LH7oi3nvwuxsTz
         SSDV0Q+UOB+9rdpVpmE46rTEtQJ5oNC+gbZB0mFxvW7GUgB9DVBeDgvxbr4Dn8ym/1em
         p0gP8/Knt+KxOtw+pW9Rbw/STkKHSR22pKgA5eN4911U5srHDeKaDWrvcRJIree0Tzia
         BckA==
X-Forwarded-Encrypted: i=1; AJvYcCVwGseQHhxuwLmSdbji16njaV0ksO5+RkTul1sMp1tHgzeE70ccowtUH7DUzfUE4iq8Q7ocw1hm@lists.linux.dev
X-Gm-Message-State: AOJu0YwiwwA0NNLBH7uOycCSvggehO0X/UAMt0vARATO+Yf7i5mdcI17
	nyauh4INUP+UI+ot2o4xY0ayih2+/Wc/QOoJDKb8KNYniAm8cwC8hnzHLg9KBQuc2Mk=
X-Gm-Gg: AY/fxX7iTZ/fovcckrgf7k+PhCWl1CI4OYyACU12KUUsd694OpsbyIAyUOoLiEL65bA
	cat6T1tszh7JcSBK9gv39/u49dusTAVDfY+BZRMM0OkfaqbJYk3BcmYbtNMRPLQrjtv2IlyaU0+
	5lHDsd9kYRiDFo7FIGMCwEC6sekWStpjAnGjJC+4kYnIOHoAkcDzrKaZGAtoz8akID1Tb1i8/Kt
	VUadWcKM2uvOES0Uf1IqizlU4dusG9mlKIl6RwezmBw5sD1jlMGlBJw51WMzU/CULB1XWhOt3tJ
	9snNfZfjsU+1rGg4NibmQpcrpUAWaieGsAH31rKNLTYrWku2+eQNzAtac85EtexqtQKi+1bC/UC
	xdMpHR/2freVXHbuR8gt8CeFGw63L066pHxVhZp8oURujJM3ZTo6z8qFKj9rcOIXX6AO4o+aVw0
	gZYxWAy3/2/PL29eodFETGJwyjscUc
X-Google-Smtp-Source: AGHT+IFa53l16N+qvvGO5QmppAyhTeWx1VKPEgvjQDDUEOhJfhKgosxMkNqOmyEm3dPYC+8Wd+jHsQ==
X-Received: by 2002:a17:903:8cc:b0:297:f0a8:e84c with SMTP id d9443c01a7336-29f24386514mr158443655ad.52.1765914782008;
        Tue, 16 Dec 2025 11:53:02 -0800 (PST)
Received: from localhost ([2405:201:c00c:2854:178f:356c:b77b:cfc2])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2a13825b9a5sm33850025ad.9.2025.12.16.11.53.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 16 Dec 2025 11:53:01 -0800 (PST)
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
Subject: [PATCH 6.18 000/614] 6.18.2-rc1 review
Date: Wed, 17 Dec 2025 01:22:55 +0530
Message-ID: <20251216195255.172999-1-naresh.kamboju@linaro.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

I'm seeing the following allmodconfig and allyesconfig build
failures on arm, arm64, riscv and x86_64.

## Build error
sound/soc/codecs/nau8325.c:430:13: error: variable 'n2_max' is uninitialized when used here [-Werror,-Wuninitialized]
  430 |                 *n2_sel = n2_max;
      |                           ^~~~~~
sound/soc/codecs/nau8325.c:389:52: note: initialize the variable 'n2_max' to silence this warning
  389 |         int i, j, mclk, mclk_max, ratio, ratio_sel, n2_max;
      |                                                           ^
      |                                                            = 0
sound/soc/codecs/nau8325.c:431:11: error: variable 'ratio_sel' is uninitialized when used here [-Werror,-Wuninitialized]
  431 |                 ratio = ratio_sel;
      |                         ^~~~~~~~~
sound/soc/codecs/nau8325.c:389:44: note: initialize the variable 'ratio_sel' to silence this warning
  389 |         int i, j, mclk, mclk_max, ratio, ratio_sel, n2_max;
      |                                                   ^
      |                                                    = 0
2 errors generated.
make[6]: *** [scripts/Makefile.build:287: sound/soc/codecs/nau8325.o] Error 1

First seen on 6.18.2-rc1
Good: 6.18.1-rc1
Bad:  6.18.2-rc1

And these build regressions also seen on 6.17.13-rc2.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 6.18.2-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* git commit: 103c79e44ce7c81882928abab98b96517a8bce88
* git describe: v6.18-645-g103c79e44ce7
* test details: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.18.y/build/v6.18-645-g103c79e44ce7

## Test Regressions (compared to v6.18-30-g7d4c06f4000f)
* Build,
- clang-21-allmodconfig
- clang-21-allyesconfig
- clang-nightly-allyesconfig

## Metric Regressions (compared to v6.18-30-g7d4c06f4000f)

## Test Fixes (compared to v6.18-30-g7d4c06f4000f)

## Metric Fixes (compared to v6.18-30-g7d4c06f4000f)

## Test result summary
total: 101371, pass: 83553, fail: 3486, skip: 14332, xfail: 0

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 139 total, 138 passed, 1 failed
* arm64: 57 total, 51 passed, 6 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 34 total, 33 passed, 1 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 40 total, 39 passed, 1 failed
* riscv: 25 total, 24 passed, 1 failed
* s390: 22 total, 21 passed, 1 failed
* sh: 5 total, 5 passed, 0 failed
* sparc: 4 total, 3 passed, 1 failed
* x86_64: 49 total, 46 passed, 3 failed

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
* kselftest-rust
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
