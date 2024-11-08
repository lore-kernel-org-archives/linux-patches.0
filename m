Received: from mail-ua1-f41.google.com (mail-ua1-f41.google.com [209.85.222.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CC41E049C
	for <patches@lists.linux.dev>; Fri,  8 Nov 2024 09:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731057744; cv=none; b=mO+2RsaD69U9wohSCxV9y2pLrAb3VBWEk8HjFxXkS4b3alm9VJUJIC+YGl9P3CJEHY4yUGRJmhuEGWjjzgutU0Mh4VX0jZQ2X+byfWn/CxVHJeXVw5vs7dSZu5qbUjvW7BgAZ6S65Or0O+lUfK4mLE4B8z7UrOnyj+YDYkqEbAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731057744; c=relaxed/simple;
	bh=mToIfgerRVyMr4NQEYxCA3VbBeobwYg494v9mWCYPwY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IoVcIIX0zm5A/0T5RxapyeWBDrjakVIJOcjzWxyBp2jowNQ8R6WmtU+DO/QJUD1ioiOO23nHm1qgYUYoyCOUGZXv28QbfjMXyy833flG2FVl/AsQjPt/bsyYFq1cxBxkiAWeOwZqb0UMKjMhoaM+OcHuZVPq17uqXZvXSg4zX/g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=fXEtXrMu; arc=none smtp.client-ip=209.85.222.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="fXEtXrMu"
Received: by mail-ua1-f41.google.com with SMTP id a1e0cc1a2514c-851f5d3001fso744319241.1
        for <patches@lists.linux.dev>; Fri, 08 Nov 2024 01:22:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1731057742; x=1731662542; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tC21RYuyoliwxkob9Q53u4Vn3W7koImw4VYvvt4XkW0=;
        b=fXEtXrMuPEJzKHeJ1NOZS5kIGUQcn+yWSMqOKguW80g6D+kNutko5cyGqvI9QTH3qJ
         7XWLAghJL1XiQwbTmV9Sx3i4W5E8/WUzqZJ2FtEbPNvmm0RiP0f6MGjykh5mvayptCBF
         QCVO9JsH52FpRx4vsu3sVnhr+ANv5Q08IWwxAKf3CFRamGm/lxD7L63DIsK8/klk7yiX
         6crLSVjB/y7FQgdQqEWyKPFvGvAmZAzMq2tud/XdNtZnLsilHxNVdMWXfTtNCPxzRrR0
         acld2xbry1SXRlJNTJZ8NYs7ZkyE7RTou3NvT03LxWfbJJQzlBilAx7XNwUcLgVa9n9T
         S6+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1731057742; x=1731662542;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=tC21RYuyoliwxkob9Q53u4Vn3W7koImw4VYvvt4XkW0=;
        b=Zuz3BBRfeIm/7iTZo9xk3IpOub5GA1Ab+Aj02IFictC5OxcmHWQoLvQpNOhu/zWbOz
         D+OlEJHqPTLXFKygGV13NiVVCODN7FFEqpxKrVNdXv804BHin2UuIziyeghVtprQSmBY
         Ojb83tDQBPUNC8fKhfsX3QVGLRJN0R55x87NFKkWRXzOPZF5F+dcC7X8VXlV9WI/JMo7
         SPuaJIOBVGj0A0b8JpgmGaSgQ7VvTQYvmb8vBtiH3cYOxPB0iJ3OpkiktG5NGM2fppPD
         FxQQ27osJNLg8JumL8a9mja0RS1trDBT99JexFsLKaaVkS3k/iPVJa1oSYFP76oyINTl
         3rkw==
X-Forwarded-Encrypted: i=1; AJvYcCVsmE/kDSfYkI+8T2WRfw7ZoS5444Jz4irPh+CfOFRGLBlmV6vxyurEsF+cSLGN5tFHbMcX0SZ3@lists.linux.dev
X-Gm-Message-State: AOJu0YyTi24vmWnkqY8FhuEsJK7PsGhNhfNtrNVXm2XqS3zjI7sD/k3d
	P5QYD6K+qu4haIhp8bPyGUQCelqvFB5zqV1+Q8QYPMsxDaihwLLhMYrlwUx0bi3VgnyJm+0EO9T
	Whhs0zmGDrUbMquj14tFORI+ZSl7NAql43Sk/WA==
X-Google-Smtp-Source: AGHT+IESWzjH3DKo0FBP1C+K3PcYQOQo9jEzNKav6p3scDXxymE33J8RVLPJwgXLoK94kbQxLatI16b3kt5EXgeRGNo=
X-Received: by 2002:a05:6102:945:b0:4a5:b5db:ec5e with SMTP id
 ada2fe7eead31-4aae16714b4mr2278576137.27.1731057741902; Fri, 08 Nov 2024
 01:22:21 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241107063342.964868073@linuxfoundation.org>
In-Reply-To: <20241107063342.964868073@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 8 Nov 2024 09:22:09 +0000
Message-ID: <CA+G9fYs8jLY9t=u+rBJ8e18LbpB10ortb6q8j0r8yRPw6-J=JA@mail.gmail.com>
Subject: Re: [PATCH 4.19 000/349] 4.19.323-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hagar@microsoft.com, 
	broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, 7 Nov 2024 at 06:47, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.323 release.
> There are 349 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 09 Nov 2024 06:33:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.323-rc2.gz
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

NOTE:
-----
As other reported the following build warnings were noticed.

fs/udf/inode.c:2175:7: warning: comparison of distinct pointer types
('typeof (sizeof(struct allocExtDesc)) *' (aka 'unsigned int *') and
'typeof (&alen)' (aka 'int *')) [-Wcompare-distinct-pointer-types]
 2175 |                 if (check_add_overflow(sizeof(struct allocExtDesc),
      |                     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
 2176 |
le32_to_cpu(header->lengthAllocDescs), &alen))
      |
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
include/linux/overflow.h:61:15: note: expanded from macro 'check_add_overfl=
ow'
   61 |         (void) (&__a =3D=3D __d);                   \
      |                 ~~~~ ^  ~~~
1 warning generated.

Links:
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2oVnF1lNXvgGOE2tM=
mzH9cSJwwP/

## Build
* kernel: 4.19.323-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 9e8e2cfe2de91cde6ce1f79021b5115f44355ce8
* git describe: v4.19.322-350-g9e8e2cfe2de9
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.322-350-g9e8e2cfe2de9

## Test Regressions (compared to v4.19.321-96-g00a71bfa9b89)

## Metric Regressions (compared to v4.19.321-96-g00a71bfa9b89)

## Test Fixes (compared to v4.19.321-96-g00a71bfa9b89)

## Metric Fixes (compared to v4.19.321-96-g00a71bfa9b89)

## Test result summary
total: 24015, pass: 18823, fail: 189, skip: 4969, xfail: 34

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
* x86_64: 23 total, 17 passed, 6 failed

## Test suites summary
* boot
* kunit
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
* ltp-syscalls
* ltp-tracing
* rcutorture

--
Linaro LKFT
https://lkft.linaro.org
