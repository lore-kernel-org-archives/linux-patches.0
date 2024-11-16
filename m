Received: from mail-vk1-f174.google.com (mail-vk1-f174.google.com [209.85.221.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7891C16631C
	for <patches@lists.linux.dev>; Sat, 16 Nov 2024 12:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731761682; cv=none; b=fE0ojgbhvzup73udsFZ0GTVCmrz715pthWDidEvMDCpWsMGqEF0KwNNQbpLSxvCthHAsftvUlRVlIrWUzeYhDfd/CH20LS+fI+bj4Kxgd5V2yaSZGbUTWc5iocyUYmoA+EGd+sycQWt0RWmF62EWVLECkUhXQw898+0aDv+7V/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731761682; c=relaxed/simple;
	bh=V8tnW0pG41HoDBAZmyoo2mCqeNMoj/x8I1k9IWEuRNg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ALwluvrjnai0LTEEIV/ttDWbRNpZZmCGp8YUQ0X7H9kVR3VNLoL4ckTRk3KUQ5igJKMeCgXlJx4m22PVgSbR173U3jNS5DMBIm8L8KWaTnGM69mWTalBYyUvE+NBL/1sfSvIHx1ucHyaMLNXy/DOCTLkKAsAAtKydfx5LSkb2NA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=XiGG/zah; arc=none smtp.client-ip=209.85.221.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="XiGG/zah"
Received: by mail-vk1-f174.google.com with SMTP id 71dfb90a1353d-5101c718439so1009202e0c.1
        for <patches@lists.linux.dev>; Sat, 16 Nov 2024 04:54:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731761679; x=1732366479; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PkrfLtlpmMOkbZGmAfotCto0+KgmvVAi/auh4c1VTLU=;
        b=XiGG/zah1RRLmuvUGx+iJsYEJXGeGBsqFRLQKJzNzzSvEn9LDnouuLh0F908cM3xhE
         AFn2W6ODc0qXCgr+zOQUN5cKd/wyn6fVJ7tZDjmSR3LuidrI/a3izbbUHwIuR6Z2LWmH
         6xLeWtBvofXWmXuuiHMP342ky1MhGIE2nThTNs3TeldoGo1BMy/yH7DYMQkuYOk3YVPs
         z53kapEUprL5P/rYkUKBKeeSALh4oZamCqIKEYD/90zjVDGj45HPw01F41KQCHtJ1aiQ
         tTVD01+OLoSsTeIYxIw221K5Y+aXUU/iwfcHphX1heQ67e553vI1+9W+hxYz9YFB3qfq
         3GGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731761679; x=1732366479;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=PkrfLtlpmMOkbZGmAfotCto0+KgmvVAi/auh4c1VTLU=;
        b=q1L2xn7TwE1uRGq5/6987ixw5EbpFzfrlJHxI0OwAPCryeblginQJbWJjQOZuCT2vZ
         t/T10BppqsglnWjXlg9HJhCNWzComQi2r176iuXZxGccQ+EC3KQsczJgw8yNVmtPvtwE
         CQbcSv/yQhuy65EFlaD2Y66MD6sDukfOwiqtxQq6FkpkkaXm6PRV6f+x0VLN9F1nteIk
         fPP3qNqeyDsWlOt/heDnWG4wJukJH6+QLWA6e8bNf+9304P5nZV+FUjvHEdFgT3KbBHt
         6r9nr5CWq5IkXcNc083YtYrX4t+/U/ScODXI0cAPJ+uSrIQPMEkFDPTPucYDNHf4MN0o
         en8w==
X-Forwarded-Encrypted: i=1; AJvYcCURUm8mIkwl9oZD8yc4Yjj7iBd8yEIdncKtvFGyx7rHbEsZtQ9BdM6zrjiRUA+5JCR3bqfBRSG/@lists.linux.dev
X-Gm-Message-State: AOJu0Yyzfun/iuN/UGYkSydGwiZqwEGrtSoRZikf1ldyolzhE+TVOnE8
	ldfo1lv8dQu1ruxjcSp3DMqFKDdR3prxV0O0/8V15bQB64+dzc0oi+KeTknjjHxcShHfJctOstu
	yiGuZxkzfkJya3JpqyQz9Dj7mLjnXPhINRwpDRA==
X-Google-Smtp-Source: AGHT+IFBlNbBEfHKYfUCLNDUnsYSTdCdqnGy1PkuwbDOsfFBeRKbFAQ00f5BfHzKrvXon2aVChjMTfVk2GjdRQAR1X4=
X-Received: by 2002:a05:6122:3d0c:b0:4f6:aa3e:aa4c with SMTP id
 71dfb90a1353d-51478567375mr5882461e0c.3.1731761679481; Sat, 16 Nov 2024
 04:54:39 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241115063722.845867306@linuxfoundation.org>
In-Reply-To: <20241115063722.845867306@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Sat, 16 Nov 2024 18:24:28 +0530
Message-ID: <CA+G9fYvzExabWp94wW9dT=_KWLUWjTJvT4ZtoiJvFvGyxjW9Gg@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/52] 4.19.324-rc1 review
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

On Fri, 15 Nov 2024 at 12:11, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.324 release.
> There are 52 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 17 Nov 2024 06:37:07 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.324-rc1.gz
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
* kernel: 4.19.324-rc1
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 3b4d1c2cc31466d675bc2579661f90066a9c0404
* git describe: v4.19.323-53-g3b4d1c2cc314
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.323-53-g3b4d1c2cc314

## Test Regressions (compared to v4.19.322-350-g9e8e2cfe2de9)

## Metric Regressions (compared to v4.19.322-350-g9e8e2cfe2de9)

## Test Fixes (compared to v4.19.322-350-g9e8e2cfe2de9)

## Metric Fixes (compared to v4.19.322-350-g9e8e2cfe2de9)

## Test result summary
total: 25104, pass: 19640, fail: 186, skip: 5242, xfail: 36

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 101 total, 95 passed, 6 failed
* arm64: 26 total, 21 passed, 5 failed
* i386: 14 total, 11 passed, 3 failed
* mips: 20 total, 20 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 21 total, 21 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 22 total, 16 passed, 6 failed

## Test suites summary
* boot
* kunit
* libhugetlbfs
* log-parser-boot
* log-parser-test
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
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
