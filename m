Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A269B1A3A92
	for <patches@lists.linux.dev>; Wed, 11 Sep 2024 15:14:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726067667; cv=none; b=YQBn8JZCl8CThzAqoh3JgvVl/J8kz0hJV4Lri4L8X2Fndk5QtzVVs7E0dv0HSwCSMo1N4Q9Ctdd85lk0NrpnHX8i62ps5CED5FcBfdSPOseFjgRofo6lMYmLTh9TauftsMjp0MrBQ50BvrK8Ik+Q+t0jHLO9LveXnZEUs3GTaBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726067667; c=relaxed/simple;
	bh=hVLkjmjja4YumeOo/ICIYN89vr8whsE1fNmkNLzca3Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BrEyLtQsUwLeRCmrU6Yw2yyfoEOzSIpalb+utqE46wrAmP00YUkcYR4QvXmfNK722scXd4yXrN+llJfy6/irb4cM87EwV4CaVa8b3bCH49TLJNZW/PVT0aec20KA1bLrxJM7y//klJnMRIQqbuBaeQlrdsgoFOaYgrmgZUowJVQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=p4ChMLMS; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="p4ChMLMS"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-6c35b72f943so9145526d6.0
        for <patches@lists.linux.dev>; Wed, 11 Sep 2024 08:14:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726067664; x=1726672464; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B17khsdsB9SaA53nbjw65jnMre9SuZD0kxsnqYHyGOE=;
        b=p4ChMLMSlQ3DCcFY6+wZdeLeqze80yYFLQvPduSWkMu9tlMotYmBZ8h5JwxrgJ4x8f
         TTIoqTNr8TV9rbCaV0im7MtN1SYjqtfs/DJcZ8Xc3vH725SzsJ6QtvWhkCfMTvvysHJ6
         GifLcfCY3cJOyih7ToPcs4VB10+YfnG4S2AOQkgdg6k3d1wDTj9RD2kZAsAdSPH5TznK
         xLhYxTFSKRdKYa3jxiMNdZitieYPxu5ljQj4y8cME48+Zn+JTXWWkO9KW2XYGs6k2n6/
         F/Ij3C63AB45Mg6w5irIWYcpY3VLJfnWTVbrJqooJ6tuS7MtHW737N8WFK5U/frrgVmU
         /7IQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726067664; x=1726672464;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B17khsdsB9SaA53nbjw65jnMre9SuZD0kxsnqYHyGOE=;
        b=VRX+JzE6KqghbSCBxl4yfHxrh07PHZwwCXSqNP9kDRQ/pFqP2mLy0lFgRCWxnpPzXg
         NzVVqc/7w9riIy0BoDfNUDaGYe7y+uVoT1aY2Hlu285+W6K4OrN36rHHUWJjZ4weltYS
         0OKA6/ottImA4eH28ftJ0Uuh3vpVdX4uhFXcXn66+dM7TTANQTxsWRb/nRJk2eyrb3Mr
         2g5sTdmreaIl/EXkT3tvileqJgD0nTl3VwKbZFan/83tSnhjPGR281zYAncItV4gcPPL
         qZAM8BSpE4p2NVTXuhNUG+e/buzHtZcmNOVZU5zhq7wYboqQxx1XIUyQrDWK3aL5eYB7
         eJQw==
X-Forwarded-Encrypted: i=1; AJvYcCWAxxAdfdhveBYH3+W7tvWNGwc4572RLL+500j2yFOxoppL2iPlth7HXt3tE2iqkOx3+i7vyv9I@lists.linux.dev
X-Gm-Message-State: AOJu0YwqLsFU5LJpPIrvj0Azd22t2dWIai2B9zr5xOsXFhcVJ/c0RaAW
	oy4tIAANCPnX7FU+90EQPVBdplPaoyQ/d39d09LJNthyUOgX/6+lwi4nMDD3YUc8fQZL1RXfk9R
	pRLZu26regIY6gxDRBO4H0IGppruG7Qqj5sr7KQ==
X-Google-Smtp-Source: AGHT+IE2sHotIw+W2O/DHyuHZFvH0buTU9s1JRa1Paz60QZm9n1B6kBUw9FGxmBeVDuFcCLNuFiuNnN9P0Ao4E4ynKw=
X-Received: by 2002:ad4:5dc6:0:b0:6c4:d2f9:644e with SMTP id
 6a1803df08f44-6c554d43f77mr112593956d6.12.1726067664557; Wed, 11 Sep 2024
 08:14:24 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240910094253.246228054@linuxfoundation.org>
In-Reply-To: <20240910094253.246228054@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 11 Sep 2024 20:44:13 +0530
Message-ID: <CA+G9fYtxOA7Ee1omhLT-fMaaBPqNEZQYVHXovLtGgv9jbuxQLA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/95] 4.19.322-rc2 review
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

On Tue, 10 Sept 2024 at 16:18, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.322 release.
> There are 95 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 12 Sep 2024 09:42:36 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.322-rc2.gz
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
* kernel: 4.19.322-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 00a71bfa9b89c96b41773efee1cca378cc1fa5e6
* git describe: v4.19.321-96-g00a71bfa9b89
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.321-96-g00a71bfa9b89

## Test Regressions (compared to v4.19.320-99-g0cc44dd838a6)

## Metric Regressions (compared to v4.19.320-99-g0cc44dd838a6)

## Test Fixes (compared to v4.19.320-99-g0cc44dd838a6)

## Metric Fixes (compared to v4.19.320-99-g0cc44dd838a6)

## Test result summary
total: 116497, pass: 103587, fail: 542, skip: 12283, xfail: 85

## Build Summary
* arc: 20 total, 20 passed, 0 failed
* arm: 204 total, 192 passed, 12 failed
* arm64: 54 total, 44 passed, 10 failed
* i386: 30 total, 24 passed, 6 failed
* mips: 40 total, 40 passed, 0 failed
* parisc: 6 total, 0 passed, 6 failed
* powerpc: 48 total, 48 passed, 0 failed
* s390: 12 total, 12 passed, 0 failed
* sh: 20 total, 20 passed, 0 failed
* sparc: 12 total, 12 passed, 0 failed
* x86_64: 46 total, 36 passed, 10 failed

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
