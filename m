Received: from mail-ua1-f54.google.com (mail-ua1-f54.google.com [209.85.222.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FB91427E
	for <patches@lists.linux.dev>; Wed,  6 Mar 2024 03:45:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709696752; cv=none; b=Zp/O+LYpXQuwotmd+DIRZlr2hmsPWCN2Q5nO4q53ykd8bxsYq9Ex4zarhNnYQS+rbHV1Nf3uuMifV5eSv8ty3XvmR7/na3YqCCU1eo2s774Oj844wqfiWj02nBF1ZefKvH8AN5z7FvkhdxlF/Ye/VbqBDOSV/Rr/wawwbEWE5hQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709696752; c=relaxed/simple;
	bh=jBAPuRGdRlyLec/G8hWJrmxIWweZDNQGFQVAySUpzDk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eVtsf2fksQU3gGI84IQ8H2r+sRStuqLIBzn6nCD3xVLw0arAhlHEQx/Wbe93wnyZE0qsGQ2Z1WRLmHeFKOcasZRlxCJVJQ3W4GI4wfuwmJVIPCneO5dnFLyPj1QB0LN3Bcs1f72u4JvVN+B7Z4CkArH4DZ9arHkTARwxOLQp3QA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=BOsTM/gP; arc=none smtp.client-ip=209.85.222.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="BOsTM/gP"
Received: by mail-ua1-f54.google.com with SMTP id a1e0cc1a2514c-7db4484672bso1214777241.3
        for <patches@lists.linux.dev>; Tue, 05 Mar 2024 19:45:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1709696750; x=1710301550; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=T5tvqqOLlp/L9fDdgXTeavKp6GslrC3c7o5kKTJOuGY=;
        b=BOsTM/gPevU8BZsE68ml3gRbNWZXZrQpxiAxBzO/H3msiBjZzR0eN3L13sGk51xUTW
         TPsvdw2G+M5RPNVByqlZrfEc1+6Xq9KbV/aNty6eDtC+mqnEc01iek5XtPjnSthg0elo
         cUn3krg7hcXoFvsF8jZ7oLh2m94Ewi31PaBdR1QPpD1iHQDV+ddjlf3v6MIhSCcCar2e
         WC4GDSjPwB1dXrXMkFCR5qQROMn3kgkK82LCvcQnCfT+vFvddjf3bylVd5kzdULe89iB
         UtFYTyKVi9FRwn5uZovPy3LrbYBIqCtF4FJ8Yjk3290NC+/n9YusFV9/AlAlHCxpaG1M
         x6DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709696750; x=1710301550;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=T5tvqqOLlp/L9fDdgXTeavKp6GslrC3c7o5kKTJOuGY=;
        b=QukLq/zt9nTo43pda4xE05FhQI9L31ioIPSXMrx/fp0+DZcNIy6kO4HZAKR1y2+cPx
         MhMttgYbNFXm9ZY/AY6Rkyph3KZ3CQ2VJwLkCwyy9xImxoQW6zDAr6jrtaiVaA+ZPJ4J
         rb2mp7dIBj+vG2Vaob+YG7BCjVid/7Kuxk8vl7Jk3qsh60DIh/PT+bQhdB4gWV5n/NmT
         8+0odmX7ZIIZ62r0LwZ43nIOqkIMHv5Wuk0Uknhco5Hf4dUn3T4MzBgh5GFjuncEj/iW
         cVcyc9ODhhY5/fgdacj5xiEROouO65NGLfGQpkqqdRdJ/7MVDCXf9MD7NykuHPzFzudf
         9PDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUEPa0Gz6f6nU4+h6nqCgezlnM7kSmECN/75bereDqNb96FvlYpLXCUNOWFHK+Xi+pcYiXIjdZHzu/dxba4tzr+Sypxy/kZlg==
X-Gm-Message-State: AOJu0YxT/o/9M7R8/eg/h90CnhYTGbKPnmVy8iyHDzcSDruNMH+gASgg
	GcMuhO9iAmcc037cMobAN2J5qOxUkC2lp2Vv08Qputv/qB4Ni9gr2At2Kxvz3tqIn6cQd7cAyTN
	2WvhuYiZpPaoSkFzKnbfKrJKPXCpp2E4aGiuwdA==
X-Google-Smtp-Source: AGHT+IGlgYy3++WxEbb9Vbw+tVFeATrL7uP+/E+8ROLUn4LkrKLrXnX8dPjsvyriAp4nhB6XfBccEoT5BRDkmmdMhuc=
X-Received: by 2002:a05:6122:3214:b0:4d3:4aad:22d4 with SMTP id
 ci20-20020a056122321400b004d34aad22d4mr4786922vkb.0.1709696749951; Tue, 05
 Mar 2024 19:45:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240304211534.328737119@linuxfoundation.org>
In-Reply-To: <20240304211534.328737119@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 6 Mar 2024 09:15:38 +0530
Message-ID: <CA+G9fYuFg=5Thx50TTt4VSfzjwCoPe5oe-O8+74-T+KBtN0AEw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/16] 4.19.309-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, 5 Mar 2024 at 02:56, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.309 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 06 Mar 2024 21:15:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.309-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable=
-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Results from Linaro=E2=80=99s test farm.
No regressions on arm64, arm, x86_64, and i386.

Tested-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build
* kernel: 4.19.309-rc1
* git: https://gitlab.com/Linaro/lkft/mirrors/stable/linux-stable-rc
* git branch: linux-4.19.y
* git commit: c854e1c772c4f07a8856c0867118ce064c11fead
* git describe: v4.19.307-70-gc854e1c772c4
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.307-70-gc854e1c772c4

## Test Regressions (compared to v4.19.307)

## Metric Regressions (compared to v4.19.307)

## Test Fixes (compared to v4.19.307)

## Metric Fixes (compared to v4.19.307)

## Test result summary
total: 51688, pass: 45911, fail: 287, skip: 5449, xfail: 41

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 106 total, 99 passed, 7 failed
* arm64: 31 total, 25 passed, 6 failed
* i386: 18 total, 15 passed, 3 failed
* mips: 23 total, 22 passed, 1 failed
* parisc: 4 total, 0 passed, 4 failed
* powerpc: 27 total, 26 passed, 1 failed
* s390: 8 total, 8 passed, 0 failed
* sh: 12 total, 12 passed, 0 failed
* sparc: 8 total, 8 passed, 0 failed
* x86_64: 27 total, 21 passed, 6 failed

## Test suites summary
* boot
* kselftest-drivers-dma-buf
* kselftest-net
* kselftest-net-mptcp
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
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
