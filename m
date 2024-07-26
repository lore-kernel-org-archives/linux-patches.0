Received: from mail-vs1-f47.google.com (mail-vs1-f47.google.com [209.85.217.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF710101F7
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 17:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722014585; cv=none; b=qL+CEfDhgvxa0TwFxIxth926RFnoU9fXJGF+L7iy8p/JxyyBEqeeC3ENpSqnnR285QwxyWhQTmXYjOVpnxTLg3Wzd5h6XN8RdZNiQqvsRK66PK3vAVSpiPKKOQXjScKVJebDg2g+qtn4kc10OrNJMIoyiX7ITWwJnEIzmLOkGjU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722014585; c=relaxed/simple;
	bh=HpHTJ8UAXqg/qBRJFXcpcuJ6jv0Otx1tVvvLI8oym48=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sBbxAJgPmPNyeReshSbiVwx1NLa6EOjROkWU8fpdfOoacJL6Rev39u7LXzPuHD/I2+HUHet8Hbi9FDXCfI71pIj7kUGdT9D+RSQDkM2E6gkYD+6yWqrVRli89uUs46bKPijr1YpTqLwqJtEvYnv3Hhq5Z0ymrK4QRWj/c0NXLk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=WqIHRAD1; arc=none smtp.client-ip=209.85.217.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="WqIHRAD1"
Received: by mail-vs1-f47.google.com with SMTP id ada2fe7eead31-4928b5531caso698252137.3
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 10:23:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1722014583; x=1722619383; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=B/1YORL54OykD9JzBMiqR9I0uazQS9lBK5x2oq741pw=;
        b=WqIHRAD1aaiNMAjrCPE0g6KsySZMb6fBesW72GwS/YXzXFxVRJU3aok0aCP5xPL/L3
         LqqywIcuaRHxaQNZzGC2UU6VW0HRdxTbdJEft/sM+rGDm3GQVE3aNg4oIb9GdZhL3Nyy
         bhnXWqK2fWhVGFbye755CpPntOzYKhCK3ijugEePdBzAgqxfudbOGISUAX5EeL1IDqsL
         03RF/SLiQ7aMMKEzg7Hh20BzIw7VZxHmNP9EEwFEXv1eBsggueaFB3lamYK1M/qG6vfw
         sF1CE+kduOo+IjeLlKQcp8b4kr1+lVkEKuRi7djM54eT5s3SHG+lWafB47c8sWFQo3M2
         Gnaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722014583; x=1722619383;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=B/1YORL54OykD9JzBMiqR9I0uazQS9lBK5x2oq741pw=;
        b=k1iwgqg25rdDYCPN9Hw4zzOooWfB8iggObED27SOAx/j87fh1nLxl3ftvHlhnkfb1P
         g46vcHHVhzPSoX1QFmuXCVvm6/dVetlm9eJQL66eRc2dqIoSSVYwNvCDh93sNLSGgEvf
         /uyQxzovSW0WAk2kprYBR9OTcMHqrA6d0OnEvYqebxEvkOxdxNVw/11OgcBpSt6Aq/43
         8Uo1oDq/ZpN1/PjHK1uYjFWbHmsrYRCiwPL6BmX3O6EcJ+BdG2RsrZ62JrTaAc9x5G1l
         p+s0ddFk9wG842ifrF3JsfTrlZbSfxcdFsBxTY1fH6Ojdtc28tPe/ZkVTAmUCz8wZgRP
         wCsQ==
X-Forwarded-Encrypted: i=1; AJvYcCVwV6mZZcFyHus/VI/X5kiT+cIatqPaVZgSrJrI0WVRkhk6IFerXCigBZ/8TjyUi/nvPLgBEyMFsoHGYIGQS0NkXChpeqaBdw==
X-Gm-Message-State: AOJu0YwMnKTOBovgsZq8UvRvDxSChCrZ0TWnsqUgYxJSaxiShIqqf3lD
	zE2yPEcbNat0nDtBUzbRZPlpp0casK5rR1DC9H6Belklg2nI3PwamaUkluQHSzr0DeqJzx+LeXr
	eTj+ZuLSzbFtzIqvWxRGzWiWBxyL4/QeUOKLIiQ==
X-Google-Smtp-Source: AGHT+IGcIjjEnlgMUd1S7i+4XbE3oBcN328lCJDqimct0ReISUdhwEXhTa7kb9Dz9WVySZcaD0vx1mFeWij5asC3euU=
X-Received: by 2002:a05:6102:6c6:b0:492:aa42:e0ce with SMTP id
 ada2fe7eead31-493fad44a1cmr344643137.20.1722014582616; Fri, 26 Jul 2024
 10:23:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240726070533.519347705@linuxfoundation.org>
In-Reply-To: <20240726070533.519347705@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Fri, 26 Jul 2024 22:52:51 +0530
Message-ID: <CA+G9fYtK3xz6Miez9vThbnUYDLU1YvP+W4DxB0EBG4wxV7dM+A@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/32] 4.19.319-rc2 review
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

On Fri, 26 Jul 2024 at 12:42, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.319 release.
> There are 32 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun, 28 Jul 2024 07:05:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-=
4.19.319-rc2.gz
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
* kernel: 4.19.319-rc2
* git: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-=
rc.git
* git commit: 0a1a65dc05b27c18b8730072d2586708d6d90c12
* git describe: v4.19.318-33-g0a1a65dc05b2
* test details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-4.19.y/build/v4.19=
.318-33-g0a1a65dc05b2

## Test Regressions (compared to v4.19.317-67-g8b5720263ede)

## Metric Regressions (compared to v4.19.317-67-g8b5720263ede)

## Test Fixes (compared to v4.19.317-67-g8b5720263ede)

## Metric Fixes (compared to v4.19.317-67-g8b5720263ede)

## Test result summary
total: 53258, pass: 47351, fail: 237, skip: 5630, xfail: 40

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
