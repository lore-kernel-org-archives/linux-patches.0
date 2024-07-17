Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2D6017FAC1
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 17:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721236695; cv=none; b=ts6LFKHyH/cGjRoLnsigAqlyhjq8YyrNSMFBT/U+vcv4vBkijZRyvtyGm5fxUMxH9IXylLBOE/sxNf0NS03Bu2iFmZc8+h614PQDEvgBgnet+QDWI4esL8llYPmcAwdv0eZt7U4b2aPz1dGldBDHR3xzi+2Bt96+fqFsovUR91Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721236695; c=relaxed/simple;
	bh=Y3f8GyO5ZrEUXO7QQwWxtrVV1sbBgKpk5HJgaPZnWqQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=R79RuP5BdwCd8MEH6sCX1JeKLlbHw5BIGpi9yOFa36Y90glllUadl0r51QJufrPGoGed0FeN0vH+8Zb7eFXxWRwk+LJ4/m4w0QsHHogyKLZTsEBlHzcwgG9BPJ5WBQrUwCiHzZ7je3ZyjmbvmOOoTZ4W2PIjTSoM0+7kDiFU+5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=kWwq2jso; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="kWwq2jso"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7035c367c4cso264528a34.2
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 10:18:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721236692; x=1721841492; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nQ87CQkHvz/Gw13/KX5fDYpHUXtRC2GsKKiDfez0/zY=;
        b=kWwq2jsogyu8No9jsnRCI/KRrRV6FqU1DiznSnHXSnzqajGMcXWN8hBxrVJuN9CP2E
         TeCiBGZtD3uUVleXPUpn6Tful1D1MoqrZ7ClLed+x4YmYGE7sLmf4OCH3/5fN6oGdO0w
         EdMoMs5y7wRkUXHYI+/U3wvB879sGYmW05etnVkELdIZCkRHJEMYyM2EFYnaob8Dii+Q
         CNaolfPsk8teLQjpYyXwDWze+E5eH8/QGIst9vRrY2zaKRPlJs8yKr6Wm4kbLClE3FCe
         iSPVrezGjTU5HzqaT79tXPao1ZKEy3stzCJQvXvZXwm2XXvw3lSRcM1PSEnXX8SrHF/W
         I+WQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721236692; x=1721841492;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nQ87CQkHvz/Gw13/KX5fDYpHUXtRC2GsKKiDfez0/zY=;
        b=vuoahhV1CPwjKfLSq7P8+nbVDLR69cjAbkl89Ew1TZhkcvEMuFlLBtmKBAzuEuPymP
         oM31S/P7KwXM4L44PJDDFH4Z7qKkW9na5lZFM1/4Je+6sbGDw4ySdsMJQ5AvFQTfNDnF
         Z6IDjEf9T5feAjfciBh/Ku5gl5RNHCO0BwBETUqsK2S9bfgZ93EEyayCtGEbLcPAF3A4
         cxvhOB/BTeqLD6nVD5uxqjfrU3z62DBsmPE+GGgpWr6L5D/Yn2LfmxSDBeIXPu+YfI4A
         56gptrB4ix97jixwLCWwZ4DP3dvCbkkrof88roxB/8PqhFF3wVvAdvqCj5y3Y8euLGz2
         1Zeg==
X-Forwarded-Encrypted: i=1; AJvYcCXMAODurzszaJ/J1o+kLJpEEyauRIqU75But9VxUgkfrwAPOAK0XHVSUHM7vk56eSsPQS0V3IZTmqcFe+F5zrHvcaUy99ERNg==
X-Gm-Message-State: AOJu0YxoBRJ60FW0vPH6Rqq3qcpARrALJcR3jJfPV1p1siyFapCeUM2P
	pqt2bKyj6hkAUYfBa2iVYH8L1iIYAqB5NkTro6dUydccwL3GM1BK86nUYNFO6WDXN1HsaEzX74Z
	nnHWT+CuhxserDDeyY2YifTU09hAHBiksTGOvKQ==
X-Google-Smtp-Source: AGHT+IEOmhBZS1mBeh4jBqhuXW/iRM3FLIcVFLFuvgl8Zn0VIJKwr5xaSP6aJOa7TbGKcwS+Dlb+q+5Gfv/V8GytZ64=
X-Received: by 2002:a05:6830:3493:b0:708:b41a:ff16 with SMTP id
 46e09a7af769-708e3777e19mr2860397a34.7.1721236691807; Wed, 17 Jul 2024
 10:18:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240717063758.086668888@linuxfoundation.org>
In-Reply-To: <20240717063758.086668888@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 17 Jul 2024 22:48:00 +0530
Message-ID: <CA+G9fYuigJ2fDRugS3xpGbATqULsKvkF89h5DkzthNERDdpFoA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/95] 6.1.100-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, 17 Jul 2024 at 12:09, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.100 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.1.100-rc2.gz
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
* kernel: 6.1.100-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: c434647e253a1ace7b60140761f27e922139de93
* git describe: v6.1.97-198-gc434647e253a
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.9=
7-198-gc434647e253a

## Test Regressions (compared to v6.1.97-103-gb10d15fc3848)

## Metric Regressions (compared to v6.1.97-103-gb10d15fc3848)

## Test Fixes (compared to v6.1.97-103-gb10d15fc3848)

## Metric Fixes (compared to v6.1.97-103-gb10d15fc3848)

## Test result summary
total: 110994, pass: 95010, fail: 1148, skip: 14691, xfail: 145

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 133 total, 133 passed, 0 failed
* arm64: 34 total, 34 passed, 0 failed
* i386: 27 total, 27 passed, 0 failed
* mips: 24 total, 24 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 34 total, 34 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

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
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-kcmp
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
* log-parser-test
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
