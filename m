Received: from mail-vs1-f45.google.com (mail-vs1-f45.google.com [209.85.217.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C455F17107F
	for <patches@lists.linux.dev>; Tue, 17 Sep 2024 10:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.217.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726569030; cv=none; b=NQx3oiiUEHsa3HBFqk/pFSyKvsAFyS74lUyiRcU7pnSWmzY4oJDZCZAeruPABiwSlO79eTGQoGCDkgmUppDHPkEC8UyOQXmrAmQK8gvc88GnJPBvMkrNfGVgI+i+ovCsDB3DDT90ef7fZXg+PHJwdClV3eEYAZXr0mU+3TyFylY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726569030; c=relaxed/simple;
	bh=rAUoQ4nus9+gGnXZO4GR16ay3famp7WL4FkpgBIVWUg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=i7YwXiO8VmH72XOBvld9As4AYctLhvwiDmRspaQB749oiGILObGwOPtN7j4IGjmJeilRdqHMAw8coGUvBqdHgjjI5RDaSN/btdmMFNSQp/0NyuTC/Kz4yrSQ4eft3UP8MmCTIe3Uov4KvIq3sIwA9j3bNebJjc8Vh2e758QKlw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=X809GcIf; arc=none smtp.client-ip=209.85.217.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="X809GcIf"
Received: by mail-vs1-f45.google.com with SMTP id ada2fe7eead31-49bd76face1so2994342137.0
        for <patches@lists.linux.dev>; Tue, 17 Sep 2024 03:30:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1726569023; x=1727173823; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=TiSL4J7L8lMiEUKJ3FGpFS/7E/wv/Xs1VRoLh25eebs=;
        b=X809GcIfQUu0M1sv1NcDoDcw4ksU2ru+UrgGfUdfyWZH3YouQWGR8CoO0ROCKAqHEK
         oCnUkPiHqc9119XK23djXwo62p1Ei0AyyiQUw0YZ9+4py3/1ET5Ap9w0/0DpE5+RcUNG
         dI0iNbQVVY/e0m64GR/S92WhSp+uNoKkmBmiAirQZLbSdHjhXodGctTeLaQ2clH8ihFO
         9lJ+SBZTHwvlqMl4ngf1jAxSHWZJ0tc+lbsYXp2R3ca1K9FBL+0Dt1Mbue4QPMTg+FPO
         fdotLQbjDb/lr7bMYLbZCYHPAJKgORd9568JibgaukOwiWvlTJLCJ11g25XaLnOuF2a8
         t50A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1726569023; x=1727173823;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TiSL4J7L8lMiEUKJ3FGpFS/7E/wv/Xs1VRoLh25eebs=;
        b=hCxzL2/e/50C0dIQFV6C318nQHY/Bk43rXB0gnm75/K9HKLVrJpXDpl2Qs5f+U7u28
         2zYhCp07V7bn2yeWuqo8FGx15n6h3LR8/oHJk2SeliujPa4lfGKFbffP1m6+98PRdJam
         uT0BrTGfTGoFgOK2rVqfvAdiXMg0zsdgZz5E9oMJX/pt4yGrKIAVJ9FXxQ38z7Hm3YNJ
         bb3d90MpvJnW4EsAruliJ6ZQDexQlfO+9rIQtGB0z5UwunFqX8JOapFtLkNKyAEmXVt6
         t5HAmoR3G/QuseRT2JWzHgPxx+X/Suc+0x6HsNouJgukYdiYnriYF4EfdH05FwYScOOd
         AKOg==
X-Forwarded-Encrypted: i=1; AJvYcCXrfp31Oglj0S0a7qOMeXZUtRmTiR945XplTcDQZucQbraQvHPnxo6rktqsibkDtaER+OjRuSLa@lists.linux.dev
X-Gm-Message-State: AOJu0YzjX0MtTlv44Yw3ZBDERCfMU3Z/sB67+xZR3nJpyYVQ280PEN+Z
	P5W7ynrbg7f1Elt2xn0bX9DO4B2uc75mrJKd+nB81o2j2dYHmxOBsLDAMiLixcQaz/tpnoEUnWt
	Tp2/dYN7jHwde3AL+PkB5QwPFjwgailuhHnsDzA==
X-Google-Smtp-Source: AGHT+IEVb9UtvU3qIrJ3hyC4983sMEXpKsLF/53bfiXaTkarBvujHfkK9GFkmBvRc6GUz54Xmq2wvMJKl1xR3mITQ20=
X-Received: by 2002:a05:6102:b0d:b0:493:c261:1a9c with SMTP id
 ada2fe7eead31-49d42165fe1mr12824423137.5.1726569022577; Tue, 17 Sep 2024
 03:30:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240916114224.509743970@linuxfoundation.org>
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Tue, 17 Sep 2024 16:00:10 +0530
Message-ID: <CA+G9fYv+OXhNPn87X4O9w8-HzGP04USge-et0b3Y4ncU9tussg@mail.gmail.com>
Subject: Re: [PATCH 6.6 00/91] 6.6.52-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Vasily Gorbik <gor@linux.ibm.com>, 
	Christian Borntraeger <borntraeger@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, 
	Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Mon, 16 Sept 2024 at 17:38, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.6.52 release.
> There are 91 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Sep 2024 11:42:05 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.52-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The s390 builds failed on the Linux stable-rc linux-6.6.y and linux-6.10.y due
to following build warnings / errors with gcc-13 and clang-19 with defconfig.

* s390, build
  - clang-19-allnoconfig
  - clang-19-defconfig
  - clang-19-tinyconfig
  - clang-nightly-allnoconfig
  - clang-nightly-defconfig
  - clang-nightly-tinyconfig
  - gcc-13-allmodconfig
  - gcc-13-allnoconfig
  - gcc-13-defconfig
  - gcc-13-tinyconfig
  - gcc-8-allnoconfig
  - gcc-8-defconfig-fe40093d
  - gcc-8-tinyconfig


First seen on v6.6.51-92-gfd49ddc1e5f8
  Good: v6.6.51
  BAD:  v6.6.51-92-gfd49ddc1e5f8

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

build log:
--------
arch/s390/kernel/setup.c: In function 'reserve_lowcore':
arch/s390/kernel/setup.c:748:31: error: implicit declaration of
function 'get_lowcore'; did you mean 'setup_lowcore'?
[-Werror=implicit-function-declaration]
  748 |         void *lowcore_start = get_lowcore();
      |                               ^~~~~~~~~~~
      |                               setup_lowcore
arch/s390/kernel/setup.c:748:31: warning: initialization of 'void *'
from 'int' makes pointer from integer without a cast
[-Wint-conversion]
arch/s390/kernel/setup.c:752:21: error: '__identity_base' undeclared
(first use in this function)
  752 |         if ((void *)__identity_base < lowcore_end) {
      |                     ^~~~~~~~~~~~~~~
arch/s390/kernel/setup.c:752:21: note: each undeclared identifier is
reported only once for each function it appears in
In file included from include/linux/bits.h:21,
                 from arch/s390/include/asm/ptrace.h:10,
                 from arch/s390/include/asm/lowcore.h:13,
                 from arch/s390/include/asm/current.h:13,
                 from include/linux/sched.h:12,
                 from arch/s390/kernel/setup.c:21:
include/linux/minmax.h:31:9: error: first argument to
'__builtin_choose_expr' not a constant
   31 |
__builtin_choose_expr(__is_constexpr(is_signed_type(typeof(x))),
 \
      |         ^~~~~~~~~~~~~~~~~~~~~

Build Log links,
--------
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.51-92-gfd49ddc1e5f8/testrun/25153617/suite/build/test/gcc-13-defconfig/log
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2m9YUHx7PsQwr4lBdvjITAfP9Pp/

Build failed comparison:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.6.y/build/v6.6.51-92-gfd49ddc1e5f8/testrun/25153617/suite/build/test/gcc-13-defconfig/history/

metadata:
----
  git describe: v6.6.51-92-gfd49ddc1e5f8
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git sha: fd49ddc1e5f8121355db23e04b94f6df460a5051
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2m9YUHx7PsQwr4lBdvjITAfP9Pp/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2m9YUHx7PsQwr4lBdvjITAfP9Pp/
  toolchain: gcc-13, gcc-8 and clang-19
  config: defconfig
  arch: s390

Steps to reproduce:
---------
 - # tuxmake --runtime podman --target-arch s390 --toolchain gcc-13
--kconfig defconfig

--
Linaro LKFT
https://lkft.linaro.org
