Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F3F42E11C9
	for <patches@lists.linux.dev>; Wed, 23 Jul 2025 13:16:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753276571; cv=none; b=njrbiEA/Ln0uh6yxxsdCMPGgbFHxM23FWAJgXKgn0FyOHRU6idD47m22L7wjqeIWgvv8bdSVww8UQs0K5+jNrDHRNc4Qm0ZPlrpCJUsPXcYTioe53DVOwHIl5rPEvbKg1taInuIfV8zVuddIun06iUWkTOwILfYFBfHDYzm7bZA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753276571; c=relaxed/simple;
	bh=14HmSM8uHW2szgsBvMI7e8oh3tK9Ou/pDBEgGzIuw5E=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pwWBSkKCvOA+PqW15sw/oSycxSy+gNBfV5eTPfts5ZlvhihJD+2RC7eTjpsDD2xsCZPr4wotjc0bKfmxD01c6T+JPt9KSJjfD3v1Hy4l/rN4SaDs5RbmnCMew1C3ct+4RDbsMRtuJDKAQr95BRzIvupWKaxUXX/Z3YyjtxFj0Hc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=v/XnOR0Q; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="v/XnOR0Q"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-3190fbe8536so5878150a91.3
        for <patches@lists.linux.dev>; Wed, 23 Jul 2025 06:16:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1753276569; x=1753881369; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=atef1i3VJcAXb2u6WsHsPrsedBDpU0QvJuuw/ePDzI4=;
        b=v/XnOR0QhdPiwB81L15hqVwls854Q9mWTf+2znYwIA0+Ynp2gGfrfmDY93GYX28fL+
         KmAFlvZaX40Sew29c7ZzOrEbpqljweZiiKVwNtqROU+mivq6HWoaMXyansEDlUSzjxda
         1/C7wtLi7DJxrPTeA/3AZuzdKnuQGdNYo282FFbiFMPWoe4SukBDNwSWr2x2ibUrrgAQ
         ynqiUeoe4uiNTpLulp539E5I+FTN9T7v94agaHlSeC29qrn6wKqkGthNKdF98Ko3LT8U
         FY2uFJIa+TEZ2NbXCUNH9jKIqMiT468pSkuQKl6P6he1Vn+ft3CK6Kpm7zXaZ5LJKZrh
         JcHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753276569; x=1753881369;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=atef1i3VJcAXb2u6WsHsPrsedBDpU0QvJuuw/ePDzI4=;
        b=dBqyQrhyT6GwWEm+C8KrUrARtaVWuD6A9phWaWTMJSr7AIXQ6vw+3+kK9IJ1JkqVy2
         X22Q/ccsw1C5kXMv5orCt6DgVXHyyDgzJtg7F3PvZhpvJdo3hIbhlJEJz1ELKv6bhURJ
         j5i+j0rTB3MOpPT8Z2njOr0z2BmGcggtfknZgL93LJvDUN0Qh/zwOanfQRoWQZUDnoNe
         oYBqb/Eh4tT+Mpa2l+aDWnsAJhP78YNqnpmOvFL9uzYht6upu6NjFK/vfKhwNzmRP3As
         mSzf8SccOCafdJw0UzFph2XlFSO6ACLApxoK5femLgzIcyWuV1D3xeD1GtYEH+kLqZ+0
         5J3w==
X-Forwarded-Encrypted: i=1; AJvYcCUL7vbHcjnzfjQh74uMbZgiVl/s9CGyZYJfNcyNKXOYhpG8XhYwCdSLn1i9KKEIJ2kKRSYjXnW8@lists.linux.dev
X-Gm-Message-State: AOJu0Ywvh1OjFBYs7G9FGGc0YKyOUyYE9yRyybLr3UeMyBXJw3U+XKTt
	YBvcbl5axvCak1YyIoYOvo30INvf2pNulNy2bCv3H5x0a/kQvBCHTQSC0sGTBWcsv5mnRRJLFPW
	TUHEWvcVwayGywtzkCyFwK0xp0fP+sp0DvzPfU6PwbQ==
X-Gm-Gg: ASbGncvqOYvq1nm1xrp/k/s3frl+4XZCZqeZG25k7Mx4xe4thCYqz/o1D/TFILxr5fl
	yoxJrH8GQxXJGY5aziqdswPENG2EUvrEdGIG4E+ZQfOiBZOhiscC/a4RpHYHOveRi6UEnrols4F
	QOnSylggLvHWH1bA8OKi4NqXoXYxyxXVAGbfZZaLIGBuEr0niLTd6KWtDg4b5xy+pEb3UmUuIDX
	xBJPo5FJd0r8OycTtw7ou/+yHQm1dwi2Ww3l3xZcJ14x6Y+XSk=
X-Google-Smtp-Source: AGHT+IEaLWB+Sw4Gbgk3BTkcEgfE8umVN+LG7rh9/lSijCb6BYcIs9Zx0jLribkrVxEXEDf3Irn/G13nDbWE53Wrcf4=
X-Received: by 2002:a17:90b:588b:b0:311:ba32:164f with SMTP id
 98e67ed59e1d1-31e507a987cmr5527471a91.8.1753276568302; Wed, 23 Jul 2025
 06:16:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250722134333.375479548@linuxfoundation.org>
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 23 Jul 2025 18:45:56 +0530
X-Gm-Features: Ac12FXxdT8wYY-fnDMpXng1kor0UBWkW0MwE1qEUQsgovX9oGjywVgaD-FaNXpw
Message-ID: <CA+G9fYv1FhGq7=dkKZFXnn-ienZ=EAq6miWxoNG1m2GfjFEy1g@mail.gmail.com>
Subject: Re: [PATCH 6.6 000/111] 6.6.100-rc1 review
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

On Tue, 22 Jul 2025 at 19:20, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.100 release.
> There are 111 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 24 Jul 2025 13:43:10 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-=
6.6.100-rc1.gz
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
* kernel: 6.6.100-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: b00c1c600f8c5bfccc64c71973fd991c0019b6fc
* git describe: v6.6.99-112-gb00c1c600f8c
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.9=
9-112-gb00c1c600f8c

## Test Regressions (compared to v6.6.97-114-g9e2d450b5706)

## Metric Regressions (compared to v6.6.97-114-g9e2d450b5706)

## Test Fixes (compared to v6.6.97-114-g9e2d450b5706)

## Metric Fixes (compared to v6.6.97-114-g9e2d450b5706)

## Test result summary
total: 300504, pass: 274252, fail: 6863, skip: 18905, xfail: 484

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 129 total, 129 passed, 0 failed
* arm64: 44 total, 44 passed, 0 failed
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
