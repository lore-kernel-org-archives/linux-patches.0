Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC75A8565B
	for <patches@lists.linux.dev>; Fri, 24 May 2024 11:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716551468; cv=none; b=c8DpBh58134b5BPwfHaIxHU9xNI1tgT6aAbv497+SRFeMLvQmlCtxXeF8JbtA6yNFRvbpm3lYfF+mwce1GnVwG74TILqdDgvMCBV8oqaFPQ7y37G9c8ZTRnoICSSRd6VyjD4aTW6xzFZZ2hvYROPHhTWnR5uvC6/hFXSdr47DAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716551468; c=relaxed/simple;
	bh=FCPHFlcxBHbocJtDdR19vK9bHOzjeGF96v/VOE++YcQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=L7MmYf7+3/Ht9xBGR0+r93qEtPPqPyUGkCR5C+M5qZs6SRSD/6BlMjkxrZoCe5OKz4jfC6Sf1AYG+RGcMUuUCo0JHOlpPZrPdVO51P5mdCfVJJMdqu1nL6NBiXx3Jdt47Klinjwv7nBTmiW6YDqyEDuVocV4BX5YqJ3Dw0lG/Pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=RvOKGzsI; arc=none smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="RvOKGzsI"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-6ab9d0148bfso5048956d6.1
        for <patches@lists.linux.dev>; Fri, 24 May 2024 04:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1716551466; x=1717156266; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kI3rC/mfMOMsxLRVRWjaH05KZLvb2lJoZXHMey213Tg=;
        b=RvOKGzsIDnsS3Kn+Qehv2gT4YN20BN07UoX6Aafrs70VuvlfyxhR9v4alILzID9BEL
         +wUjSrkDmizikmXOcU6w5OheuAXk/hOYIbhI1rnS5xX7ZNcW7tZtIVUzSk0pBL09jj66
         VDcwl2jjQcsVxoSwIHv1RPEEoSEMPY4AjATnpMa7qNBUzuGFdTUdlfylaXdLeWgq3kN8
         M8YZ/6YWlkbI5kafBijTQ8rawLQ/uYXVOKJ+KwL7i1I2FFTg/zlB64myy1mbwSNSZ2Xg
         suH1FZwVXhHKkB2tnjhplgHZ54Ud5XlqAlrnGsEN1xd3as9YKw/RSbwGkwSDTXsk8eOm
         weLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716551466; x=1717156266;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=kI3rC/mfMOMsxLRVRWjaH05KZLvb2lJoZXHMey213Tg=;
        b=Gl19OAOSwtUxXOY2uyqaTD/xp7veii28PO4NvAODMRTo4pEjtLC8kFicnpozgBFA5B
         4hIccvU7d4zvOv9kbyqGPmOhRWBo2urMqOOmHLUOnJh+cekhJl0IlcKa4SG499VQFHmE
         ZZl7niGfPGFHUYVNQc22/bySl2qZUW0nJE1MpWEWLp53lK7DO3juWZc0POJ+B/fTlb5C
         Xh9GfVkoE0O05ijF4QMVWSFvlPulKni64xZBrQUTSBHhTpHeO4IJQB0Hj+xumGfmYpya
         W2vOts/aecWcV0DuVYqgRTWF7ZZg8v1/H13DOebnREjjzssM4YmqdN1sMqGgkVWW4roY
         /2kQ==
X-Forwarded-Encrypted: i=1; AJvYcCXVKElPkZ2vX4CFGed71M4ULKt+xQLqqMYFZP5sFlgp861gB9zT1kl38GP/kbSb4VXorBbsoZ6R0PxYlxpDrAVRioIfz/E61g==
X-Gm-Message-State: AOJu0Yy7TK+wZrTwdyX651Vbed4qulRtVYHjfGoKUPHDV5A9xtYt6p7m
	xHxiBzF0YoI5zbsYArUOBL9Bm0COPHVksZYSAhhsssQelLrsXvJgkQXI9Mwnks0de5cvj13ZiiH
	4JRkF5M6zGd5JUQhYDKc2i6Hoavms74Gn/I8JSg==
X-Google-Smtp-Source: AGHT+IFZqBtDNWBSwVFl70aifDa3xZX3joiTKqJ0DW9rIZUf8b09hmIcoKQwVdYy5nTXL6+tjZRj4kF9HKabw9bNGEo=
X-Received: by 2002:a05:6214:5781:b0:6ab:99df:40fc with SMTP id
 6a1803df08f44-6abcd19e33cmr20418116d6.46.1716551465697; Fri, 24 May 2024
 04:51:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240523130325.743454852@linuxfoundation.org>
In-Reply-To: <20240523130325.743454852@linuxfoundation.org>
From: Anders Roxell <anders.roxell@linaro.org>
Date: Fri, 24 May 2024 13:50:54 +0200
Message-ID: <CADYN=9KOfUNp7E=sp_1or0YS15cwP0vYQJEhgkxscCUSLjVEzQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/16] 5.4.277-rc1 review
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

On Thu, 23 May 2024 at 15:15, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.277 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-=
5.4.277-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-5.4.y
> and the diffstat can be found below.

Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

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
* kselftest-openat2
* kselftest-ptrace
* kselftest-rseq
* kselftest-rtc
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
* log-parser-boot
* log-parser-test
* ltp-cap_bounds
* ltp-commands
* ltp-containers
* ltp-controllers
* ltp-crypto
* ltp-cve
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
