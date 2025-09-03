Received: from mail-pg1-f170.google.com (mail-pg1-f170.google.com [209.85.215.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26DFB2D8764
	for <patches@lists.linux.dev>; Wed,  3 Sep 2025 07:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.170
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756883028; cv=none; b=jIaQmo2eCXmZv3RLL5MlBtgso56JTdqoXZSHzxYu0UiFr8mIU7QAFtBzfncn3pPB2CB0gbEk27cvp6Isv+dqbbBur+PqHt9t7bDLtn9pnvQ4WgqHdV6gNA+aI0AmYoq6jjVx3KbuFZLcuQBq7CVYVlGmL8+Av/xabxeHCSgot4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756883028; c=relaxed/simple;
	bh=+CzZMuJEXya7F5oV21pY4l6G7TTcJtH9gknq/TQ/aTw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=l6TZhPb4+guNsRZ40K5VP0Yyz7FBAt4WrjmZcyryliU6Im7Cigm57njQlQgtXWKrO5lU0ACghZHZEjbzv+MZZR7TmaiKzbmpN/AHUYkT2jXHeI7O2u61KtInJuCHZyAsLZ245UqWdL8rdDWmlnZ1KGX5TOcS26024LhKd7DrPTs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BI5wT17B; arc=none smtp.client-ip=209.85.215.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BI5wT17B"
Received: by mail-pg1-f170.google.com with SMTP id 41be03b00d2f7-b471756592cso4035080a12.3
        for <patches@lists.linux.dev>; Wed, 03 Sep 2025 00:03:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1756883026; x=1757487826; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fL4SkVrTJ9oKe7qs7sANkBC9i27TXliw0xssBarmLsc=;
        b=BI5wT17BkKd0tr7jjfK0yRPFaoqFXDYJ9ZAFcVEm3X4IkEcBxojbRPkXrJQlvssE5y
         2iYJMA2T+tdCnvffG7/uZJLzVXLDPLKJeHEpIZ/VvdXNc25u6mEVhgYcQbhMP5rd7eH1
         b+HuVTAAGzE8C1pQ1Pjf29VdlvlJeWKflZf2DHqLtFvAxynKkompc9M+HDIk1BBqZOsy
         IIcPX5Cc7SMeTwLxOCt1YbY8eM/7CbWd26d2601CcMQX+0/+exwAXjo4B/yKTunrsJvg
         HSjjcuhq+fd8FQkdJ5EHxtuMJFjZdvTe5PeUpD0ufdpwpSHnL9l2LeKVpdkF+7Z7B39w
         y7KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756883026; x=1757487826;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fL4SkVrTJ9oKe7qs7sANkBC9i27TXliw0xssBarmLsc=;
        b=LbhYQoeMKrpRAAjj5zbd2QYrN2LEzSbQPV5gZMV1XgH0SFJ9amPe7bfvwApo8yBpU2
         4PkIkCfCxaIqw0YFckSriBR13UnvuzcWOrd0IObRBWzws4k9xjyVgYpjxfMOAhfLjO/w
         QylMuFpl4nmD3iWUOdRNVwmkkV0Jhh7ZztmqzRQ2xHi8jPYnLtzc0waCJSZpuE4XClJs
         5qxwPlh/pW5IO+3WDR5zhbuTJo1al9jh1Z6f5qM2EsnKTa3cW9URcAUqnPy3+Pjgw4g6
         X3gBXU9V4rOqZmeE01YFFmqNx0DdHkFkzHuabblmwTXmaSt8QtY9jQgDlAX/mCRswCQX
         3J8w==
X-Forwarded-Encrypted: i=1; AJvYcCWVDcWi8OyvRlUIWi0tInLaMW3Y/yEsUFXcpn3W5uHjXYii7EWKbTm33ZYLns7g7R+Zx9+AYJ/n@lists.linux.dev
X-Gm-Message-State: AOJu0Yx+dEAiuPAe9U92qkwCVOYNz2p3by1eTr8COKjEHYfK6pQu5ix8
	SsyIAf3A6youWb7VWdA8r1w9dReFUUYT5supNLyJ2ovXmNMdNlp7DaDGsX2MRnEcWXXmkN+G+P7
	tW+leO9ZnzeATzfkgKLV3o+zWRTkMF6FIg24rOkT22Q==
X-Gm-Gg: ASbGncuNybkqmAoCjq2aIy4SfwVGt8gSA2LW5R7B05TYw1I8mcHNnylXGGmSzOGrMhy
	iQVq1RaBr0kIZrsE7M2z/I9dfbhhWd+l+LB69TYwnqrBAYQcxwOJqZMO6Wy9x11oPaxTmftfPV+
	4JAeSyFAs2sIcIeQWqRRNYgRpwPCKrcY04ZF79VbD4m0m4HjkU9r7cQgVOGSvrBdcfl+DIGseKc
	Zswin6M+LKrK5Tzr2cFJdzYbJxKGsbxkfkaXPWg
X-Google-Smtp-Source: AGHT+IE6Gxv2TMCJAdKOWCYjEhj7lI6inwVBs9oUuCCbiTP1CtDGKISOowssI7uYiatr92QpupXT3zdopt8oyZ18daA=
X-Received: by 2002:a17:90b:17cd:b0:32a:e706:b7b6 with SMTP id
 98e67ed59e1d1-32ae706be21mr3502062a91.11.1756883026133; Wed, 03 Sep 2025
 00:03:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250902131927.045875971@linuxfoundation.org>
In-Reply-To: <20250902131927.045875971@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 3 Sep 2025 12:33:33 +0530
X-Gm-Features: Ac12FXyKfC_-aqYgJLlTgXqXUoZh-SGrsO4A4Lu15UJtjPsYwvrVGOG4RJwNdq0
Message-ID: <CA+G9fYsHzdo8BqxV9yLs_NeDE3dB6p6GE4H6RhHWGL-oVMyFsw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/33] 5.15.191-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, achill@achill.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 2 Sept 2025 at 19:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.191 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 04 Sep 2025 13:19:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.191-rc1.gz
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
* kernel: 5.15.191-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 29918c0c5b353baf87a2bbc3e2a4256c99430dba
* git describe: v5.15.190-34-g29918c0c5b35
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.190-34-g29918c0c5b35

## Test Regressions (compared to v5.15.189-645-ge09f9302f92d)

## Metric Regressions (compared to v5.15.189-645-ge09f9302f92d)

## Test Fixes (compared to v5.15.189-645-ge09f9302f92d)

## Metric Fixes (compared to v5.15.189-645-ge09f9302f92d)

## Test result summary
total: 55718, pass: 45636, fail: 2304, skip: 7414, xfail: 364

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 101 total, 101 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 18 total, 18 passed, 0 failed
* mips: 22 total, 22 passed, 0 failed
* parisc: 3 total, 3 passed, 0 failed
* powerpc: 22 total, 22 passed, 0 failed
* riscv: 8 total, 8 passed, 0 failed
* s390: 9 total, 9 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 24 total, 24 passed, 0 failed

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
* kselftest-livepatch
* kselftest-membarrier
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

--
Linaro LKFT
https://lkft.linaro.org
