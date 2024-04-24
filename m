Received: from mail-ua1-f49.google.com (mail-ua1-f49.google.com [209.85.222.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E3471581FB
	for <patches@lists.linux.dev>; Wed, 24 Apr 2024 07:57:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713945438; cv=none; b=FZXqLScq/7Qcfc0Xh3q1SCNoKvWfpo3VnQGuaWiKrvf40nEUsVdRZu2V+e7gBd4HictcWGLJ9V6KQqubDeTBr9nzOiBGsOVbOJh2gQt/VD+DzIfCscwR4Kl+O156bYQHdeERRKj4hArpvIcrclC5o/af05iO29ljG8fJzK/iHO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713945438; c=relaxed/simple;
	bh=Or64OaneAWMEOpHLPP9hFWsP86VsJI1ybI9wBjzPf4s=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a3BANdfQXZJUX2iZi5/TcFlmVZ6u9qn7W49/N8RN2D0qLgaK+xC/oYkfS8+CqFxasjfL2SF2JIvss5PZ7nIaxa6Rx8lEVrvE1pjbw2yt1HGlEbjROgv05s8gYtIuUsszZdJSqMv6lNupCqypSbIeeNJT/H47wFpFZEqFK+SboUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=sNjO7cop; arc=none smtp.client-ip=209.85.222.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="sNjO7cop"
Received: by mail-ua1-f49.google.com with SMTP id a1e0cc1a2514c-7ee1dee900fso570224241.0
        for <patches@lists.linux.dev>; Wed, 24 Apr 2024 00:57:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1713945435; x=1714550235; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=UA2CVXNklvbf0LWrbUSmouXmAKtxu5bf0ARspZd3rk0=;
        b=sNjO7cop0Z+sYg42U56UCcHmK74uLuiakAxfzPjfKZAyzl8V8DLyj00lVP3oPYP/yE
         huhdciBQ73QAB7vUSwURNKPPgoW8fY+9+U8SOjtdBmKRCdxaTYyX8vjyi05cfiiJenYZ
         iRU3kaIGhEeCo/rhyotiZQBi2Mre4XGKrFhpjLLQicaUiqp2UcIgWTjPjRNLCCfiSFoJ
         sepGdUeyni9N6tdFuYzY157QHRMlfbV9kDIdBREY37aUrcrVkxpHKlUAMaoOsUwwaDdl
         WMK/xwIiJQMcpCuIpcEuGsiQIIbbLLo9qjUBJgGxhysLTXEzPB1Q+mEq4igcMDB2VO9B
         TmzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1713945435; x=1714550235;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UA2CVXNklvbf0LWrbUSmouXmAKtxu5bf0ARspZd3rk0=;
        b=upLB8euTLnMdLHpH93PhbvBQxXDEMyHkG2mf0sXDWjtrvUmlg5VLFKMmBwqm7O4JwT
         6O3h9ORgQigQ48wToWc4G7Bfoa7qTTRHUQAUkpSgiskpcp2jvK/ucsrqTco64JVQFOeD
         40lu9CUtUg0ZNCj2/me4sDwWxnc85UQQVM3LVq/80aTxk9q6/JByKzUsLoilaBHdTi2V
         AAP30c3hbgI4iDhUQMtjKd4qvl0aCzm8YptIquzaWVTesMVPGF8wUldldvIwyYaiT22o
         jJiO85HIfxdk4J+lNzyOPI9PTpayCF1CsusKPW4RIXz+bQzGP3Vm+q/QfaALQuDalakz
         x3Kw==
X-Forwarded-Encrypted: i=1; AJvYcCUscUKwTCWUYqPL9DEId4BF05MOoI1+nfGqD5Zm1FFBlrK5GUNfBn8uuil5fY/PWRmrF/Jpj5VNqtqD6gKFLhzIB17iULlsKg==
X-Gm-Message-State: AOJu0Yzzusvz/Brx0H29ciGV9TsDt8JA9xAE5FNbGHvwaZTFDnlYkHLV
	qvC5f5Fy8c3sTlS68Ln3XnjKfEIyGJi0ptqmiJZyz7ae6OxY6bPO5GdqQ5SIhLzptsqXEuVl6H7
	mLOI7n08M5rHWfS/zpXJ14dvOZsCj43L58Eov0w==
X-Google-Smtp-Source: AGHT+IFUwN08g7BSlDM6prRxw/urZVDh3+vum7FMACj7zISxNt8w6l0rqBWyuUBUbfTG9y+9p1LtvpT3K2vwBvNOvOI=
X-Received: by 2002:a05:6122:c89:b0:4da:9a90:a6f2 with SMTP id
 ba9-20020a0561220c8900b004da9a90a6f2mr1806626vkb.10.1713945434922; Wed, 24
 Apr 2024 00:57:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240423213844.122920086@linuxfoundation.org>
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Wed, 24 Apr 2024 13:27:03 +0530
Message-ID: <CA+G9fYsm9OYUh+H9X2kpJWXsPdde36=WbSWc+mU0vO0i-QaWOw@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/71] 5.15.157-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, linux-s390@vger.kernel.org, oberpar@linux.ibm.com, 
	Alexandra Winter <wintera@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"

On Wed, 24 Apr 2024 at 03:16, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.157 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 25 Apr 2024 21:38:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.157-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


The s390 defconfig build failed with gcc-12 and clang-17 on the Linux
stable-rc linux.5.15.y branch.

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build log:
---
drivers/s390/cio/qdio_main.c: In function 'qdio_int_handler':
drivers/s390/cio/qdio_main.c:761:52: error: incompatible type for
argument 2 of 'ccw_device_start'
  761 |                 rc = ccw_device_start(cdev, irq_ptr->ccw,
intparm, 0, 0);
      |                                             ~~~~~~~^~~~~
      |                                                    |
      |                                                    struct ccw1
In file included from arch/s390/include/asm/qdio.h:13,
                 from drivers/s390/cio/qdio_main.c:18:
arch/s390/include/asm/ccwdev.h:172:50: note: expected 'struct ccw1 *'
but argument is of type 'struct ccw1'
  172 | extern int ccw_device_start(struct ccw_device *, struct ccw1 *,
      |                                                  ^~~~~~~~~~~~~
make[3]: *** [scripts/Makefile.build:289: drivers/s390/cio/qdio_main.o] Error 1


Suspected commit:
--------
s390/qdio: handle deferred cc1
  [ Upstream commit 607638faf2ff1cede37458111496e7cc6c977f6f ]

Steps to reproduce:
---
# tuxmake --runtime podman --target-arch s390 --toolchain gcc-12
--kconfig defconfig


Links:
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-5.15.y/build/v5.15.156-72-g70f39a25a6b8/testrun/23638097/suite/build/test/gcc-12-defconfig/details/
 - https://storage.tuxsuite.com/public/linaro/lkft/builds/2fWFs1EvyrjLKUD3D6ODW0Agksv/

--
Linaro LKFT
https://lkft.linaro.org
