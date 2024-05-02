Received: from mail-vk1-f169.google.com (mail-vk1-f169.google.com [209.85.221.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 400A0224F2
	for <patches@lists.linux.dev>; Thu,  2 May 2024 07:43:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714635819; cv=none; b=MWsQ0hbjrm5+Lc+LdcrZ5zMU+g99eOv2jOTD1t9rnoSiAOG/5E8kVcZG4DW369aYHJllqpPqS9GrUrel73Ljc2IrkK8Ob9xbg04bsW6E1wq68VoAwtvvAaRztbjhabHA6PZwINk6V2u18zi06ZhSEjVqMtbQB3WSl4wmQ4hI9gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714635819; c=relaxed/simple;
	bh=rDono9JDP3oaHl15CED3BRbCQJ6twVEr8Ie1x16gH/8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hwpUpi9f765UYpW6KQmRx+tmbxeYc25shA9FIDFf1VIhR1XxwvZlf9Gd9GU08akJiXuI83WVfk4cYhPnBRqG3FjOj9zyhdQ6DZmn4rWjIUz9jEj0TS6QdKmFT/lhDOi6uyhmYCqBax4DI8RivaZgzDbEuGp4jdZVmT72XCkAzy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=CpLkhAuR; arc=none smtp.client-ip=209.85.221.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="CpLkhAuR"
Received: by mail-vk1-f169.google.com with SMTP id 71dfb90a1353d-4daa8e622f0so2013126e0c.1
        for <patches@lists.linux.dev>; Thu, 02 May 2024 00:43:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1714635815; x=1715240615; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Rcob1TfnhXb+bEn5tF/RI3RqQrQ53a9U7OzbM4Ax2nE=;
        b=CpLkhAuR/G2GeCnRcdtjXXrXRFqQVN1Gi5SLz5D0+GYx6B+Ss1/53acXA9od1g+PIG
         Pttf7y3UpmP+yIfKsiK6Wwe6KlggVc96Aky5ZPHcu9GNaJF5nxehY1clNAm/ZyfxJG2U
         zq70+32qy4t4WAuZAYpIsj3bZcOTolgnQYQYxlfsqaTLMODVSOqRB1JcrgvZM8aWtc8c
         +RlmU3hMT9Ob/MuYiRqmGU1Q7wH+gpccBUibVBc96ul9qKcVQP3jxo5isLop5pRoDwnm
         fpVfKfKOdsIU9hD2+0G6zZKqFgGTWfcUCmlhHem+cDZKF+uhKB+Y2AB+pgU4zYTngfY/
         h65A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1714635815; x=1715240615;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Rcob1TfnhXb+bEn5tF/RI3RqQrQ53a9U7OzbM4Ax2nE=;
        b=AUiIBU0k5jLH3FAiAyQA7b10mlMnPRenPv2dVK2WZ2tLPPFwkqp8n0oqkQzW2xmjP3
         qqbuLPnv91gXdOTQ+WW/g+WtVbIwBb8Ry+McSZgt3nA32eWjaDDLPjgzBJSbZjgAbfjj
         B2lp0i4Ce5oPsfVK+PCd8J6lzML71AoOPBO6JD0vpMgWamECzeLgTwOgcp7DM+JtzCGd
         LFGTQy2f1f3/25CscVzXudW36xURkfX8sxE0cYkupgoIU3fddeoAJzLOGHDfumEsqzCJ
         XpWnG6UlmUSzY8x0lxxqqcHOMq0A1tQYkBDAN2yK+qVmx1Yt57yCDpXdR2NvUY02T35K
         GwSg==
X-Forwarded-Encrypted: i=1; AJvYcCWRdXpAKEFV2PwIQ2apRe1hTbFWKcuN97ZKFr2WulkX5LhhM59aMteEg7aKptaiIYTG97xlLD/28q2cSOYGuJIhQMnamS5EXw==
X-Gm-Message-State: AOJu0YzfNFduaVIs40U4xpS2W5vFIFJjewxvMKp2BfKhE+uMOd2flluO
	b76jSMVhhjbeF3OqX8tndSCh0jqViCohKav+nBVIhu26IUWs60uj7GqaHQH9WBuChgNh95djYjh
	u6lzSQnB2T6Dr8A8F9MttIIr2AQvB5nh78K68Hg==
X-Google-Smtp-Source: AGHT+IFvrUNNJeORwF7RJ0RFDFEgsKfOtCpFP/WQu6feSafNZETbA70DvepwWypWctu3kv/IkSZEjHNYdd4gxCFiJvI=
X-Received: by 2002:a05:6122:3d12:b0:4da:e6ee:5533 with SMTP id
 ga18-20020a0561223d1200b004dae6ee5533mr5611768vkb.16.1714635813741; Thu, 02
 May 2024 00:43:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240430134021.555330198@linuxfoundation.org>
In-Reply-To: <20240430134021.555330198@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 2 May 2024 13:13:22 +0530
Message-ID: <CA+G9fYuX5H_jwpYCr+vS2W1G7J+mG67M=D2DYwj7L9MN3=89GQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/106] 5.4.275-rc2 review
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

On Tue, 30 Apr 2024 at 19:13, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.275 release.
> There are 106 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 02 May 2024 13:40:04 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.275-rc2.gz
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

## Build
* kernel: 5.4.275-rc2
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-5.4.y
* git commit: 6c530794f59e8e3bb37b90d4bc14a70ec7d657dd
* git describe: v5.4.274-107-g6c530794f59e
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.4.y/build/v5.4.2=
74-107-g6c530794f59e

## Test Regressions (compared to v5.4.272-183-gc3a33bc34a87)

## Metric Regressions (compared to v5.4.272-183-gc3a33bc34a87)

## Test Fixes (compared to v5.4.272-183-gc3a33bc34a87)

## Metric Fixes (compared to v5.4.272-183-gc3a33bc34a87)

## Test result summary
total: 104581, pass: 83299, fail: 2741, skip: 18467, xfail: 74

## Build Summary
* arc: 5 total, 5 passed, 0 failed
* arm: 135 total, 135 passed, 0 failed
* arm64: 35 total, 33 passed, 2 failed
* i386: 23 total, 17 passed, 6 failed
* mips: 25 total, 25 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 30 total, 30 passed, 0 failed
* riscv: 9 total, 9 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 31 total, 31 passed, 0 failed

## Test suites summary
* boot
* kselftest-android
* kselftest-arm64
* kselftest-breakpoints
* kselftest-capabilities
* kselftest-cgroup
* kselftest-clone3
* kselftest-core
* kselftest-cpu-hotplug
* kselftest-cpufreq
* kselftest-drivers-dma-buf
* kselftest-efivarfs
* kselftest-exec
* kselftest-filesystems
* kselftest-filesystems-binderfs
* kselftest-filesystems-epoll
* kselftest-firmware
* kselftest-fpu
* kselftest-ftrace
* kselftest-futex
* kselftest-gpio
* kselftest-intel_pstate
* kselftest-ipc
* kselftest-ir
* kselftest-kcmp
* kselftest-kexec
* kselftest-lib
* kselftest-livepatch
* kselftest-membarrier
* kselftest-memfd
* kselftest-memory-hotplug
* kselftest-mincore
* kselftest-mm
* kselftest-mount
* kselftest-mqueue
* kselftest-net
* kselftest-net-forwarding
* kselftest-net-mptcp
* kselftest-netfilter
* kselftest-nsfs
* kselftest-openat2
* kselftest-pid_namespace
* kselftest-pidfd
* kselftest-proc
* kselftest-pstore
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
* kselftest-sigaltstack
* kselftest-size
* kselftest-splice
* kselftest-static_keys
* kselftest-sync
* kselftest-sysctl
* kselftest-tc-testing
* kselftest-timens
* kselftest-timers
* kselftest-tmpfs
* kselftest-tpm2
* kselftest-user
* kselftest-user_events
* kselftest-vDSO
* kselftest-watchdog
* kselftest-x86
* kselftest-zram
* kunit
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-cpuhotplug
* ltp-crypto
* ltp-cve
* ltp-dio
* ltp-fcntl-locktests
* ltp-filecaps
* ltp-fs
* ltp-fs_bind
* ltp-fs_perms_simple
* ltp-hugetlb
* ltp-io
* ltp-ipc
* ltp-math
* ltp-mm
* ltp-nptl
* ltp-pty
* ltp-sched
* ltp-securebits
* ltp-smoke
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* perf
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
