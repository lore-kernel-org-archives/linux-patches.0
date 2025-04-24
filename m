Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 317442556E
	for <patches@lists.linux.dev>; Thu, 24 Apr 2025 13:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745501487; cv=none; b=bbg0Uy+RJK8cxLwDtOhTzIqobyvJPbN2mxkxMHx7HhbhRa4duE5c5qglymmFu7tn0EWeHKOjt+RHn3tEccil11AsaUJScD/DekYkmhDuVGaPUnmxVb0ZYp7B/KhaSx6QuCfwRBUELpySEb5Eu6TOvtuX1HJdNW5Lx+z1wn+zTDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745501487; c=relaxed/simple;
	bh=RZT+Bm4muaLofaD2erPNMsSdkXdWvtmeIvrNvvHsOeA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hzt9hfXqtKniK07bYWPhC6Y5zStZTyYLzEFlTfPJRxJ3eXxVhu78CXRclR913A0FoYVvDScR7i6ahU6HIFUnVsC2hZf60+OU1GwUOMPEoGze5cjQmr7YB7OwSFL6zRKaxQGgd0D+tAnOyyEsB9qFUw6bCxRIj5LKt7eCiG99L80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=e1UIUMQ3; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="e1UIUMQ3"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-af28bc68846so914797a12.1
        for <patches@lists.linux.dev>; Thu, 24 Apr 2025 06:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1745501485; x=1746106285; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DJ7+5ltYRZmmCdAqp83XBsh7nNRI3/U1EM/A5Q+9eyo=;
        b=e1UIUMQ33dhLT7RU0j2k5anjvIoPJIc3uje1tgf2rj87dkHjRQj4vmo4dTlt6QqagW
         ww8Dwi1YbLEE4aShv5gEwqSIPkxu5nb5X74TImgJTeQlpxjvA8Z4UqiTZ86W7t+tBPDe
         OROXmpymvE9PIpoHZKzuEeaYhvs6xiSDdE0qObHEIlKiO3a0SsWQq1rqAYH2OSQ20z00
         MyMqFaiwRyd6IHNy9VAPyss1Mmohle2v6lr6hpZtTOCI8ATztvgzKXCIDZiuI0ZHEeTG
         i/2HYFqYVONQOUUw+G5fOXDj9anjkAUGOIcwViQJYGvf4XZDJs2N8nxUqGCJpJrQOZGA
         m91g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745501485; x=1746106285;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DJ7+5ltYRZmmCdAqp83XBsh7nNRI3/U1EM/A5Q+9eyo=;
        b=O2PFK8r3HtzNQScqH7tbgDQIFZ9PSqRg1rN/3N79dT9tKcbs53+OloNOmKT1lHhBeU
         ZAsIkWrjV4DrrDEkyvwJcNo9bTy9nailWHO0GCnmlu28NmdwYWkxARTB4t60dJUadoPZ
         aGh0Wt/N8YHeXSc7DJBV9b9SwDnE+bxsepthDE8NYaykRsV5igsaqffdppH+zHFtEAqm
         1SHXDtX46T+qu+de9TYqvQhZAt4NfGeltg03rHhEOe7mVZNR/Ad0mxlXv/bz4ckn+MCh
         J5kZO26pnVPgPgWZybIId1QVHMfYYPGZj2Xdr6etJvNF+J7NS41JYr2GKmAjGGP5by2J
         8Lwg==
X-Forwarded-Encrypted: i=1; AJvYcCU4eqaC4kVqPTNp/DUbOplYxZY2ljDqoQnmcMLNd2i1pPDc5wdQa5t3xIXcNHokwsWr7X5ggG2J@lists.linux.dev
X-Gm-Message-State: AOJu0YwUmSw1ruoFHTZM+0rnwriz/OuNNeXaIYEoQk2rSQQcDpusRH1t
	aCt85aU3YOwdOfTk6zhGtoI1iPuniZPRx4DNddwc1/DSreF+SExWwzcvyT7mPBGpWJr6BqeOwQu
	ijtOjdd9iE5LEt5hg/zOU8c9N4jkABKPdD4/PczzRwKIPdLte8Zk=
X-Gm-Gg: ASbGncvL0bEJ7UXga/ulgbGhaSlpzpEF69ggWMbTRj6031pttXj7rAcI8kzdbQykEmG
	gIClRzMyIkDE/0JWjrkm3NWQvowIKXy+6pjfBx3pdu2BVGnBdjpWbKZyq4wflvm4aYi1OxFd91M
	iqJ9qXmggcWyn1KXr22IsZLxk9Jp6HxNSDCSDiBekuKodFzYVWCX423mIR
X-Google-Smtp-Source: AGHT+IGPQAdvPv130CtyW74bF5GLt9h9J0gOC9yqMjfZwUkVCJiQZ5jIuqZ653x0CDkSH9qNJMbaN+6YH6fuzBDQJEI=
X-Received: by 2002:a05:6122:c92:b0:529:1a6a:cc35 with SMTP id
 71dfb90a1353d-52a78396531mr1948197e0c.6.1745501474452; Thu, 24 Apr 2025
 06:31:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250423142624.409452181@linuxfoundation.org>
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 24 Apr 2025 19:01:02 +0530
X-Gm-Features: ATxdqUE3Swvm29VSdLjDBXXrmS_5N47lC-b7TJpDPawZ14stkRhW3kDUI9cl4yk
Message-ID: <CA+G9fYu+FEZ-3ye30Hk2sk1+LFsw7iO5AHueUa9H1Ub=JO-k2g@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/291] 6.1.135-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Netdev <netdev@vger.kernel.org>, 
	clang-built-linux <llvm@lists.linux.dev>, Anders Roxell <anders.roxell@linaro.org>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Arnd Bergmann <arnd@arndb.de>, 
	Nathan Chancellor <nathan@kernel.org>, "David S. Miller" <davem@davemloft.net>, 
	Jakub Kicinski <kuba@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Wed, 23 Apr 2025 at 20:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.135 release.
> There are 291 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 25 Apr 2025 14:25:27 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.135-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Regressions on arm, riscv and x86_64 with following kernel configs with
clang-20 and clang-nightly toolchains on stable-rc 6.1.135-rc1.

Build regressions:
* arm, build
  - clang-20-allmodconfig

* i386, build
  - clang-nightly-lkftconfig-kselftest

* riscv, build
  - clang-20-allmodconfig

* x86_64, build
  - clang-20-allmodconfig
  - clang-nightly-lkftconfig-kselftest

Regression Analysis:
 - New regression? Yes
 - Reproducibility? Yes

Build regression: arm allmodconfig variable 'is_redirect' is used
uninitialized whenever 'if' condition is true

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

## Build error:
net/sched/act_mirred.c:265:6: error: variable 'is_redirect' is used
uninitialized whenever 'if' condition is true
[-Werror,-Wsometimes-uninitialized]
  265 |         if (unlikely(!(dev->flags & IFF_UP)) ||
!netif_carrier_ok(dev)) {
      |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

## Source
* Kernel version: 6.1.135-rc1
* Git tree: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
* Git sha: b8b5da130779a27bf7d189bd3b40ebf59ee0e0e9
* Git describe: v6.1.134-292-gb8b5da130779
* Project details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-292-gb8b5da130779
* Architectures: arm riscv x86_64
* Toolchains: clang-20, clang-nightly
* Kconfigs: allmodconfig

## Build
* Build log: https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-292-gb8b5da130779/testrun/28211709/suite/build/test/clang-20-allmodconfig/log
* Build history:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-292-gb8b5da130779/testrun/28211709/suite/build/test/clang-20-allmodconfig/history/
* Build details:
https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.1.y/build/v6.1.134-292-gb8b5da130779/testrun/28211709/suite/build/test/clang-20-allmodconfig/details/
* Build link: https://storage.tuxsuite.com/public/linaro/lkft/builds/2w8QtyR8377WMNLrbtsmGi2lkaI/
* Kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2w8QtyR8377WMNLrbtsmGi2lkaI/config

## Steps to reproduce on riscv
 - tuxmake --runtime podman --target-arch arm --toolchain clang-20
--kconfig allmodconfig LLVM=1 LLVM_IAS=1

--
Linaro LKFT
https://lkft.linaro.org
