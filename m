Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CACB1D63FF
	for <patches@lists.linux.dev>; Wed, 12 Mar 2025 10:51:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741776711; cv=none; b=j6Y5RLJrLPR7juZotHox4zKcxZUmAG//7HdexoUuSEdpoHodQD3Bn1qpZZ/eph1C3or2+hUCOs8PUfUhmnbxb38wBCFErRvkyjXgLE+Kfpf0NeyrOBB6g7zBxFNh6dgHEJe3QgJ1e7/vanEkZqzEfR+ZTa2FaK6QJNKuTaM25w8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741776711; c=relaxed/simple;
	bh=hXSiJkKHJBCdJvH+R4+/RqJzaWY/eGeelD7MrTlv2js=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Lr9f8/jsV3Lgpx3Hpp0E6H8CMBrP+P3F0Aj5k8lPdhMTlKpWmjIGGzacdPRo2ZusbxsDJKBk7q+B4R+T/G7TPyNEb18HzPRt1HjlFa0gx81Abkj7JMwGII859+7JURvR9iuwde68lDNbCM7BUk4wdBdEX2eY0AXhzvuDvqFTZxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=AfESVPFO; arc=none smtp.client-ip=209.85.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="AfESVPFO"
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-86911fd168dso2515261241.1
        for <patches@lists.linux.dev>; Wed, 12 Mar 2025 03:51:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1741776708; x=1742381508; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ofIXHd0nXdS+xLnWIW+XGUrMohg/3SYDu/r8Q0SMWRM=;
        b=AfESVPFO7vGGUEjcNM3nevJoStVx960iw7QBS3qRUEMeTL6xvmVVH1oAXxcmqBKA9R
         1lW1aYLZSXX6oB0XmgV4lzSWkG7MJtE0pAxwY3r4HbyuK0/85CeFuEpCP66bUPhCBudl
         I3Q6Xkel/CpcmQ2mqKnX1B/HZxMrQC7GL6y3L4ZrX9HzwoVlh+8fhLcPkAuLW90LXmYJ
         qGgFE5HIjiKHD+ynNJRHvfnzwRbIVdy1ohns2/JYty207ESOwYT3VU2RSdD3Ma/SteC5
         RU6qIFyC+5lP6s5NVV+UNmkL+aubPwkhAy9XOt5TshD0EOpwVpb9E36jUtaMT1ciISeX
         Wx/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1741776708; x=1742381508;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ofIXHd0nXdS+xLnWIW+XGUrMohg/3SYDu/r8Q0SMWRM=;
        b=kDlzvrZFAGaC0MdMDbfoPVrVjY3MatYkIf2c942ZspxO2eQjOkBOOqP9NP8CeP4TWK
         DJmAR5s1r5QLJa4mzefwNqSeM28O/VSpworonh1cHyW1KAxr6g+dUSPr6kgF9CU4r5KC
         PKeTRE1vml4f00TPK5QHMbnWYtUMjWjeOludZJ48X8ouxNQDtlnVjuYRsshopyDbYUOl
         H77Rjyi0AV5qlE5EfoOO91TrgGfk4Dek0moBzZL8GpXR6AdOSoPx8xG8eSCYUEu2uj1i
         yfeiFySUwjdA4eCVgjqE0XnCOut5p37fHDqsB1vZQ7Cdo6sr6Qid17E5PF6RhlcNvPOw
         QY/Q==
X-Forwarded-Encrypted: i=1; AJvYcCVjHg5JeVWXHccPdO1t2a9eKnHS33HV4E/oonJ1xgBKIQT8gfGH3cCSLRAoNZsjHUkcWrjLuD3y@lists.linux.dev
X-Gm-Message-State: AOJu0Yziffsi0rFAz6pH82VfMhU7HPfWVXxqTe4WFCYkPHqDBSzfYATN
	rFDxCsnle21wDqz84Gz1/wDrOA8Oru/lEreQVhD2iL7I9lTUikoLfPPaQlyEkP/MMejvkW1yHFR
	GdhwbGv2RK2ZGmMZ9GQWMSJmqctbesnrUCTQqUw==
X-Gm-Gg: ASbGncvI8OGqApWBajfMUSrttMGYMsGAm4msKrgVLTOlJ3M0xnH/8zu8guv0AF4niOv
	exFkLbJCgIyM7OylBSZFuRTOHQ+tsF8U3Z7LCS175/CYKuwXRPCpWV4xGqb/TJ1bUFX6epIGhOZ
	lpmcVLnjr9MRR3LyzBp8V4ZjTyZnjHN+9b5DAiabFXjkoElGqdqaF5GmLlfoY=
X-Google-Smtp-Source: AGHT+IExqjwNlPJDVbhRq1gUihp2DfP+lo58w+qtI1pZKKxOFe/VwKkG7rpQaIQKS+9RqW7lVdJCkF4xzButJtwk2EQ=
X-Received: by 2002:a05:6102:808f:b0:4c1:935a:2446 with SMTP id
 ada2fe7eead31-4c30a6aeeb4mr14044886137.19.1741776707905; Wed, 12 Mar 2025
 03:51:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250311135758.248271750@linuxfoundation.org>
In-Reply-To: <20250311135758.248271750@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 12 Mar 2025 16:21:36 +0530
X-Gm-Features: AQ5f1JoF3cL86ld_u7OGbca9lABCc58A27MGCDo0Tu9RpKsaKCWwzWHaW4rmjTU
Message-ID: <CA+G9fYvZ024_ujvUe=0YJ6xDD-sNHAgjMzX0EJpOGd98RtP-ZA@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/616] 5.15.179-rc2 review
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

On Tue, 11 Mar 2025 at 19:32, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.179 release.
> There are 616 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 13 Mar 2025 13:56:14 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.15.179-rc2.gz
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
* kernel: 5.15.179-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 4372970bf8669b796c66bde58c72b591b8934373
* git describe: v5.15.178-617-g4372970bf866
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15=
.178-617-g4372970bf866

## Test Regressions (compared to v5.15.177-25-gcd260dae49a3)

## Metric Regressions (compared to v5.15.177-25-gcd260dae49a3)

## Test Fixes (compared to v5.15.177-25-gcd260dae49a3)

## Metric Fixes (compared to v5.15.177-25-gcd260dae49a3)


## Test result summary
total: 70512, pass: 51509, fail: 3484, skip: 14908, xfail: 611

## Build Summary
* arc: 6 total, 5 passed, 1 failed
* arm: 105 total, 105 passed, 0 failed
* arm64: 32 total, 32 passed, 0 failed
* i386: 25 total, 22 passed, 3 failed
* mips: 25 total, 22 passed, 3 failed
* parisc: 4 total, 4 passed, 0 failed
* powerpc: 25 total, 24 passed, 1 failed
* riscv: 10 total, 10 passed, 0 failed
* s390: 12 total, 11 passed, 1 failed
* sh: 12 total, 10 passed, 2 failed
* sparc: 8 total, 7 passed, 1 failed
* x86_64: 28 total, 28 passed, 0 failed

## Test suites summary
* boot
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
* kselftest-livepatch
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
* ltp-filecaps
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
