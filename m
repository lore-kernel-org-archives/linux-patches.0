Received: from mail-qv1-f44.google.com (mail-qv1-f44.google.com [209.85.219.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 578E9171CD
	for <patches@lists.linux.dev>; Tue, 13 May 2025 16:17:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747153059; cv=none; b=SWbofOZytoF28t7cHJxduQTRTtXenkd0OLOW5XrN7bL1J9c3teOVAipqA1a1wIQOENjLeVBZaVLOHWfTeiptnoCz/c4kdmtGpfuCuLbvW4+V8tZTN0szP35+cNeXQ7D0G6uo9zy1/q0nmTejyaruepyjsLVDhWAi+1uB6WIhgpw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747153059; c=relaxed/simple;
	bh=/k6EH3Fc/zb3rtylgyq4u/RSFENEtTcwHkK59WGtR7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GBsqA2ym+QvOp/tO6iS19ZzPElO40kg/nNogImYMK77PbRmeBZDrSxMYAiQYYG8WK+tPOXBCk1/+NJeVGntwFrUajqyx5WlkRkucSjQ3I9+5dUdaq7srnqESrFdEQW3a5z+mhJvz2HGMrFAbsEU30aJVMAc0+Tm304RHVYbW36s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=GMk+5Hgn; arc=none smtp.client-ip=209.85.219.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="GMk+5Hgn"
Received: by mail-qv1-f44.google.com with SMTP id 6a1803df08f44-6f6e398767eso62079596d6.1
        for <patches@lists.linux.dev>; Tue, 13 May 2025 09:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1747153056; x=1747757856; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6KYGCCD9QtETURvM4SFF+hSR2hHupYk+lugy2F+Fvto=;
        b=GMk+5HgnX17Ez6eccklAgbEyG1LWlpYdm9+0UwKdB2egSqjm490rNs/fAgtB2zN7+c
         VqFV/tqgfR2c24eKuQK4+BMRcNQXiZb6mRFULKqL2fwqloUkUgTm9aQPt+QBGqUC8TZ7
         STgPQxX0SAOall9nvQXORoCjNDwhuJFQGL7eryqi/Y3NEuiq7XBJ/BJIaZ0sDAPi6Q/Q
         QLzQx5foTOOYsG409sKnwAHwcy5l99K4Ncy+PnomUYcgaxvbUnEBcFtWCZ5RlvRjiQrf
         8jpW6+DXtecm54o/UKTdARFmLVeu7Eg1aXORAKCPjPJGH2IPlndYJ15VVdK25KhtdoR0
         COjQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747153056; x=1747757856;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=6KYGCCD9QtETURvM4SFF+hSR2hHupYk+lugy2F+Fvto=;
        b=htDdxmC7w9Ru+wKd6rdPj2+IDoXte1qNKrG6m7mWo9yBqyl8IfdF0OX7JdMVEkoxc8
         d+WxrLo9H++dKuaSZGGonsvTiVmHzW/WKkJR2CZRJ1JggIbU368VXQuoT3LyOaog2pr3
         pXzUVLfax28stLvjpbXEhSoHGgDZttDl25lL0FQ6TwSRcTs46HIGj7S7LQC6gPKKxSdO
         yg6PNFY6oispJQKOgeIXT0toT1lYrDPwlZCEshXK577ICutsw1rstFr+BfnIhluMn+SQ
         gy/aCBGe5AVmX6A/6ej+1FSznYFWXIxrfwzSFMMOROo3El/T6iTW+jD69YmDM/wxOsPh
         4Dvg==
X-Forwarded-Encrypted: i=1; AJvYcCWc+PtRrijahHOttL6ndbqwC4ETX4Gm18fzQ+eO9PsFyNS1bVMNLNcmfzuQlU7PwO5hzuRuRa3y@lists.linux.dev
X-Gm-Message-State: AOJu0YxVQtzoFVDqgntLPapdt50knEA36BsbGyolgcB3niWjMk9E6E4V
	+lAQXluML0lGUI0X1AGz4J6jR7cqJ362huB6L6CbVf3ruwqPzr6avh5AMai9OsnaFtIK5Y6nzTq
	anOWJeWz2PNMo5+fP91a1zYg+Qkta0R4CbgN9Lw==
X-Gm-Gg: ASbGncsoFngNsIAUbtEGU9f5lxcjia6Zb3DVcHOfd5/V/GAjj/IKIobnGuMHQwPdYGQ
	eR1RX1QO1z6tm9gKXZdrtYukWzwCNVvobvf7tIUEd/DYAsdMZoESeWBEnuSsDvNyQ0K9T9QATO/
	F8b2RCwFPOfwNlquNIu4s2i0BjsnJV9Fs=
X-Google-Smtp-Source: AGHT+IGYtyQXfctZatQi1ETEYQsyfcieEa/w22127hAJNNi/hZ6sMfmmqVsyG0iIkzuDvFKRJBUHtQq63iAMg8rxyso=
X-Received: by 2002:a05:620a:6006:b0:7be:73f6:9e86 with SMTP id
 af79cd13be357-7cd1debe7e7mr658324285a.20.1747153056207; Tue, 13 May 2025
 09:17:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250512172015.643809034@linuxfoundation.org>
In-Reply-To: <20250512172015.643809034@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 13 May 2025 17:17:25 +0100
X-Gm-Features: AX0GCFv7Gkug46vmMqzunGkj5qmL-HDap1Yz3dTHGpAw2W-izrUW9GWapqpKAMs
Message-ID: <CA+G9fYtR4d2AF4BGDJ+7iYS8kA26J0sQWmUTJjj4DWdX4wFBGw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/54] 5.15.183-rc1 review
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

On Mon, 12 May 2025 at 18:31, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.183 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 14 May 2025 17:19:58 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.183-rc1.gz
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
* kernel: 5.15.183-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 5aa355897d1bc9d3ec5947e4242c939d117e9f3d
* git describe: v5.15.182-55-g5aa355897d1b
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.182-55-g5aa355897d1b

## Test Regressions (compared to v5.15.181-56-g364c50bdd7d2)

## Metric Regressions (compared to v5.15.181-56-g364c50bdd7d2)

## Test Fixes (compared to v5.15.181-56-g364c50bdd7d2)

## Metric Fixes (compared to v5.15.181-56-g364c50bdd7d2)

## Test result summary
total: 60455, pass: 46917, fail: 2089, skip: 11091, xfail: 358

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 101 total, 101 passed, 0 failed
* arm64: 28 total, 28 passed, 0 failed
* i386: 20 total, 18 passed, 2 failed
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
* ltp-ipc
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
