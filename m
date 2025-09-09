Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0DA123C4F1
	for <patches@lists.linux.dev>; Tue,  9 Sep 2025 07:52:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757404376; cv=none; b=IFhV1/E+q5289C5OF1uQsO3f0vPjRlOjAwDqgHUiYdc/jatCwZbmT2wk8Jwk3syZF1rFgbZqGWgp2pBI9nV0o0FcejkvE3ZhMTglkK7Ctntl7pBLToB4KyXeIP/VbE36j4NTvs+bufI8kQBwklqqQadM/EpVu5fK0kpCLCvVfo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757404376; c=relaxed/simple;
	bh=inPUrZMsfA2VY/R1OZIP0EMwvOmiWnfNcCAy3+3kvw0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HqhJjx31KQY22N24cERTJjqp3eDw/TXHCAc/nTpagMHiLsqJs0iEG/g7jw8aQJsPVXrGM0p52NWKyNABu1cyac1o/lQhVnAuk4L9bfuwDCIOdfbg4XGfKkUo1K7nuq66Y2IiXLXVdAVSDR9wikR+E3Tpv59GPKf+qbSXdMw3NzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=J9HgaIIr; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="J9HgaIIr"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-b4f7053cc38so3289308a12.2
        for <patches@lists.linux.dev>; Tue, 09 Sep 2025 00:52:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1757404374; x=1758009174; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=MMOBMpJlH1unyBv3NyBv5FS3WF4ll7Y30j2iPvk3MmY=;
        b=J9HgaIIrQlWNvj20tTCxGvuzTQjrIBu6y6f4ytcLQEGi6OtzZP2d2IoZf4b7aO2Exc
         UxULSpJeji8DyB1XRcWmr1imHoae96xYlgpKlz8lm14wzbHlaz8DXASwCM4CtS6clDEt
         LF/OmS0PbCoCoOMZLAF+5cjpiRD0Ws4skxBFBrnRcewWRPf8uGoDaj29W7S+CNYSuXUr
         fOAdxkeyya8BLVsifW+qOohn/7OpcGjzK4yOEazlYKDm3Iia5vPL7hzK7Q+zrkUH7e2j
         5r4PalOTehMdSys9dsny/Win3coeunnw3DAI80Zx9x5Qk6akhzTSxvryOT0UkfZMv0XN
         m/qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757404374; x=1758009174;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=MMOBMpJlH1unyBv3NyBv5FS3WF4ll7Y30j2iPvk3MmY=;
        b=QnFwQHDa+w2IM/KOh0TL1pDfsZOGe9MngPJBQxX/zYHXxq/bL+wX+MEoeAXN6F5FqC
         u1Zjt0ElZyksvRfd4Xai7uSz/ZkahsWax2eQ2sqO96RlgihfoH8VhZV3/T7CzVH7oU4D
         E1SqwqYQUdCElRBszeIqOhxMJUrL1N4IYspbgvb5dS+L5dl64plx3gNJjuKoaRiIxgw9
         8rroFJs+1xDDxEzKPQ/gP5LDo49mc+jnQQmTgXI6f1zkyh6eems1gDrOa7nJKdXZnHVg
         4zQjsh1Bsyo6WApKH+9RaMHr1T7TOYxQ9QcJfnpFSAUL5oTcFYejQTONiWl37wrMITtp
         zg3g==
X-Forwarded-Encrypted: i=1; AJvYcCXv9MqHCgvtOg2Eyd3KQqHeS7oYYJ8y2PN/jVS4m6oUM1GcfjTA/sR/r68jNRDxFn4I1jK++T8x@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/BGII7K7TAMW3iU3RL4qnz+e2DuIqVUQKty7cypod1rqYySMh
	wPb1I8/A+prI149HnQc+ZkXTPL+zTw57cdnaYM1u8zcHl+RFl/zSk2jlOiy6js1EF6KrxNEtMr9
	Xxhi9/pU7vf+ZFt/BmgYCjvROgVU17rN4ecpoNOCPGA==
X-Gm-Gg: ASbGncsI074AcG3E8vZviy8Hbn8dweUNy+VbZyhDXpDefctd7TGsbK51t2CB65DeTIk
	xHLLEZDM/fOps0/Qkf6fkX6uzG9QW3eI8GWPmluP2OVpzWjaPAq/7SfKWmuiNCpPhUlvNcHYWbP
	pVxIiUJWw0B7T/UuHLu2y6Zu+/RMpPIfvfq194oiyoFg5tTc10AmA7TVLwQbmzb6xxlj0eZ72Jl
	ueOizgpc3jpxie2/Zl3ojVwinzOSW2ggte6mL8fmMQxtB1gPNK5hbixvBndc4vvsXqorG0=
X-Google-Smtp-Source: AGHT+IHKMwwuJuV9mWv+A5szEpOumIuvlZcVWUqldPFr6JIn3jDsrrgM3BJF5KeyNQI945RkqqnfgQuc2lOpuPGqW0g=
X-Received: by 2002:a17:902:d2c7:b0:24c:e6a6:9e50 with SMTP id
 d9443c01a7336-25174a2e860mr141006125ad.45.1757404373705; Tue, 09 Sep 2025
 00:52:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250907195600.953058118@linuxfoundation.org>
In-Reply-To: <20250907195600.953058118@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 9 Sep 2025 13:22:42 +0530
X-Gm-Features: AS18NWB51GMfdNxH5F_7y6R9Phs7xYbSJja9zt2vDLfRVbapihqj_C3CM63O-h0
Message-ID: <CA+G9fYt3xc6DmR+EYZD1cAiBSf0VxH6jqbdf0PK-8uGPivw8ew@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/45] 5.4.299-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org, Netdev <netdev@vger.kernel.org>, 
	linux-wireless@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Mon, 8 Sept 2025 at 01:40, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.299 release.
> There are 45 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 09 Sep 2025 19:55:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.299-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

NOTE:
Following list of new build warnings noticed on arm build with gcc-12 and c=
lang.

drivers/net/wireless/marvell/libertas/cfg.c: In function 'lbs_associate':
include/linux/kernel.h:843:43: warning: comparison of distinct pointer
types lacks a cast
  843 |                 (!!(sizeof((typeof(x) *)1 =3D=3D (typeof(y) *)1)))
      |                                           ^~

drivers/net/wireless/st/cw1200/sta.c:1292:20: warning: comparison of
distinct pointer types ('typeof (ssidie[1]) *' (aka 'const unsigned
char *') and 'typeof (32) *' (aka 'int *'))
[-Wcompare-distinct-pointer-types]
 1292 |                         join.ssid_len =3D min(ssidie[1],
IEEE80211_MAX_SSID_LEN);
      |
^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

drivers/net/wireless/marvell/libertas/cfg.c:1106:18: warning:
comparison of distinct pointer types ('typeof (ssid_eid[1]) *' (aka
'const unsigned char *') and 'typeof (32) *' (aka 'int *'))
[-Wcompare-distinct-pointer-types]
 1106 |                 u32 ssid_len =3D min(ssid_eid[1], IEEE80211_MAX_SSI=
D_LEN);
      |                                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~=
~~~~

## Build
* kernel: 5.4.299-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: f858bf5484295b4f9ee720b49c5348ce54eceae3
* git describe: v5.4.297-70-gf858bf548429
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
97-70-gf858bf548429

## Test Regressions (compared to v5.4.297-24-g79c1b3cebd7a)

## Metric Regressions (compared to v5.4.297-24-g79c1b3cebd7a)

## Test Fixes (compared to v5.4.297-24-g79c1b3cebd7a)

## Metric Fixes (compared to v5.4.297-24-g79c1b3cebd7a)

## Test result summary
total: 39701, pass: 30356, fail: 2171, skip: 7026, xfail: 148

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 131 total, 131 passed, 0 failed
* arm64: 31 total, 29 passed, 2 failed
* i386: 18 total, 13 passed, 5 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 26 total, 26 passed, 0 failed
* riscv: 9 total, 3 passed, 6 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 27 total, 27 passed, 0 failed

## Test suites summary
* boot
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
* lava
* libhugetlbfs
* log-parser-boot
* log-parser-build-clang
* log-parser-build-gcc
* log-parser-test
* ltp-capability
* ltp-commands
* ltp-containers
* ltp-controllers
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
