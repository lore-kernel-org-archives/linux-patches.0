Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6904C3A8CB
	for <patches@lists.linux.dev>; Thu, 18 Jul 2024 05:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721282130; cv=none; b=JiDkdJhxk3O0BqCp0awAEdd5zlB7I5E5Usxh0bBIS7R3FsuBqtQhl2XvVxM3olliwVLKzNiODjVKs8LmKjGfmKExWJax8jpxuTE/SH5IRpTRBBYXUQYgxjUhYYaYAXzaaQV2IeAhfaVAwC6QojVuC9oMfCVS2sgYfxAeoyjpDCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721282130; c=relaxed/simple;
	bh=e3jzj+zv4uKoyWuQ2pepUbVZTtAISYZ4y2Z+m0uWzIU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D0jMlTHxtjNPKdv7xGB8vKYCyrqXXPiRAe8IqqzNVfmsV6FEuCboyy4u07aelm8IUJTY2Fwd/EbpQLpY1XqRFOre8zAT64BQ9QnNFXr6AXmAC01dDqRohpORT4/Hj7YaT8l9glgG3hI6BlBdzJ33ZohW0finehaOoTnD3+jd3Sg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=x3oLWek8; arc=none smtp.client-ip=209.85.221.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="x3oLWek8"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-4f2ea4d80d6so180945e0c.2
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 22:55:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721282126; x=1721886926; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UikeJglj4mqEJ1Vgj9mu8IORdC9p9msk12TuLHCn4Uo=;
        b=x3oLWek8Ljic7dKdQ9WCqVklh2dmrDqZYBLD1cnbiBMgwWFgcjIrvScI8WYrBFKVIY
         pKW3UUMN5TXzJZw3rRVVrSBX8zHIk4VTNsH9z+tT3vlVuvqtD0QUOAh8vPI6WiLavYqg
         993IzmOiQA4APwNHfyCptD5Vc+TU/3ZBm6Pxz/cGtDTU8jpc0Fefa1z3IXgqLY8N1KBG
         wNVCJ9YG9QgXt3uxZBzjXtjIbUEfxn6WlEKgdY7UC9LZJKp6tANuVbTzXrJq6uYO1SvI
         qxhOcH/7I0WFGloOnyl9Jyq7nbYP8P3RDaiX8+t9MahLW4uW6w1mDrHCDo/xVZmYatI8
         oPHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721282126; x=1721886926;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=UikeJglj4mqEJ1Vgj9mu8IORdC9p9msk12TuLHCn4Uo=;
        b=TuoCicS3HeSr9H1Qwc9m0XVNHLSJS51ZUml6ITJdTl3cTaOpj15Fdh6xtvcMNU+kT3
         Z72i3wpnfwXql01XHTVpnLGNbeQesWjZS8yxw78lKUydGaeaqx7jMR3GtqKkD0PAFoGW
         uIzSwOf6Ns75fev/0uQUE32UzWBhnGfD1zZvbkkhQj4yvRGFWTOAZ7+yHKsY7g694mXR
         GFU8rDGpExVC4ClsIi/PRKNLQ14OCnNkvzwBF58SiDnFjSfcUAlR+KoVLa3SwOOC7g3L
         NNKffo5Yxt4cutyH6sMSHtzvCFbWrRtHsSRkiRjhRhjdTW1faPePwGg3rWRK7+Flnz7V
         4KdA==
X-Forwarded-Encrypted: i=1; AJvYcCVJ2Vhy/xjXZXF0xHJpn/lpFgvvKND0p3JpVe4PRm595k8YojHMpa0lYvyiOYOXyvfmGMpnujaRr15Zqyl2QyhE9eXNmHVWLA==
X-Gm-Message-State: AOJu0YzKHx09FMxm5R4YrvWU5IMkd6OvTeQPg1WqJWTmF9AVs5mB2rxa
	MmnCqf8+lY/RPdDg35ALCMYxPFX8vL687LPes5j+UORL0Ae2VkOIxrXG09mFPGa5nAx4L8DAoSG
	AY5u0005T14yJLVdt4qAw4DABP6fUuWBx8lKvcBfqBj1K9QvLqrepWQ==
X-Google-Smtp-Source: AGHT+IG1mjdqmAC/jqNQitwGKo0lDKe12wqzLLoI6KXv5dgT8yB3brqWRtn8KfCQgAlCWrbkHpnS2zKaPFh02vUSmgM=
X-Received: by 2002:a05:6122:1ac3:b0:4ed:52b:dd29 with SMTP id
 71dfb90a1353d-4f4df63cf8bmr5275151e0c.3.1721282126073; Wed, 17 Jul 2024
 22:55:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240717101028.579732070@linuxfoundation.org>
In-Reply-To: <20240717101028.579732070@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 18 Jul 2024 11:25:14 +0530
Message-ID: <CA+G9fYsLr185OmUiR0_BgKndR7_Z7D1Crrj1pxgP4uWiZbFEZw@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/66] 4.19.318-rc3 review
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

On Wed, 17 Jul 2024 at 15:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.318 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 19 Jul 2024 10:10:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.318-rc3.gz
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
* kernel: 4.19.318-rc3
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 8b5720263ede6176702e42155a0e263cfa1f4dba
* git describe: v4.19.317-67-g8b5720263ede
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.317-67-g8b5720263ede

## Test Regressions (compared to v4.19.316-140-g485999dcb7d9)

## Metric Regressions (compared to v4.19.316-140-g485999dcb7d9)

## Test Fixes (compared to v4.19.316-140-g485999dcb7d9)

## Metric Fixes (compared to v4.19.316-140-g485999dcb7d9)

## Test result summary
total: 53301, pass: 47401, fail: 242, skip: 5621, xfail: 37

## Build Summary
* arc: 10 total, 10 passed, 0 failed
* arm: 102 total, 96 passed, 6 failed
* arm64: 27 total, 22 passed, 5 failed
* i386: 15 total, 12 passed, 3 failed
* mips: 20 total, 20 passed, 0 failed
* parisc: 3 total, 0 passed, 3 failed
* powerpc: 24 total, 24 passed, 0 failed
* s390: 6 total, 6 passed, 0 failed
* sh: 10 total, 10 passed, 0 failed
* sparc: 6 total, 6 passed, 0 failed
* x86_64: 23 total, 18 passed, 5 failed

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
* ltp-smoketest
* ltp-syscalls
* ltp-tracing
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
