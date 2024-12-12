Received: from mail-qv1-f41.google.com (mail-qv1-f41.google.com [209.85.219.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC36B2309AE
	for <patches@lists.linux.dev>; Thu, 12 Dec 2024 18:05:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734026725; cv=none; b=cvOHh/7kQsVt+ydQAyTXcCDdrCE8J+cCytMQ072pPTxnvmy9u3haLqIYrI4a0nZv6QTy/aoCvRQpCdpV73h4xZlRRMy2tPtcZ9ojUectwa/sd00UZWB0qSwXGFdfGZq3/X0zqS+OPDBVWbLSuy26M+G+IrTpx3UKcAPqRwL7znE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734026725; c=relaxed/simple;
	bh=GnTV6Da5YELPXMcORuq9yXyw8ZWX24rsUjlfFf5wTMU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=a2MoVoIejcjbMTeh9rGkXNiWzjOh2sMn+xiQ2hWxSVGFxB29QbjiDTaThNiuFrW9/MppRa1vpXrRWJrTOFWKmwnhmr/7KgtsTozlmd8bUH36fNGq4a92N5AHFVgYfqhOZ41w08Hq00frGVX7mtCyr/6WpgvaEIuvbc1GuUzDzyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=o7OLAn/s; arc=none smtp.client-ip=209.85.219.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="o7OLAn/s"
Received: by mail-qv1-f41.google.com with SMTP id 6a1803df08f44-6d8ece4937fso6769166d6.2
        for <patches@lists.linux.dev>; Thu, 12 Dec 2024 10:05:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1734026722; x=1734631522; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=0ACbT2hrUAn63fc+9lLjJy9djGKWLbWmKIxJyevbg8Q=;
        b=o7OLAn/slMTK8uiGHEm/Wj7Wz6FR8ldgMafG+daD61ycaX059VJe488gvJ1qpTv6Yq
         CeSJfWa6eliKPmipPQBxV4/GLN8NhKZ6WmMMXIyCIqfy0yLYf/ZOMeWizTrFCuQosKj6
         UI12J3Crk997DaGlACRUVQXP6QV6eeOCmY8Uot4eo/dUkcRwc+yT6q+x8d/uNuCEfMOU
         BXjkwsv9s2zxW57EI0whDWNtbRRt5ZCqxkVrCyU6/bRbEMV3yit31Rf2Q29uNvw3hKxh
         K4l1+JzPSS9pqQH7QE2MgBYI97XT9tjyjev7kXPVQ48QCnPGR21Esvhl7w63O4wB/4Zd
         9I6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734026722; x=1734631522;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0ACbT2hrUAn63fc+9lLjJy9djGKWLbWmKIxJyevbg8Q=;
        b=MbrLvwV2uckLo9mGiXqoQAwjLmnQNpYiEm2iyRzZVbw4EmpnJpUN+MMMi2woiwVROB
         Ua3h59XmzvueIZTm6xhzj0h8ezcvKDkm0CwuAzXkzABdCo2GvcQusu0JtOesmj5ZAV/h
         kklq2OXeQ3kIiGXONgAMbh4oKT/5Rt0m9cQ4ipf2CDDDd/uNJdEw8EbnBNS7YPNUuyVx
         3okzEtAFuvjAxytOk83PXnusuMOfQpAqO2wK2j3i2SWjPIl1xGO+rF0OntbS3v7ymoUc
         k4lh4kE460hIoPmG/YU5vVhGj9LyGRmFAvtEwysi9l2aHz6GYeRzHWwRzUQx1H59i+3p
         E8aA==
X-Forwarded-Encrypted: i=1; AJvYcCXZ23qsZ8KxpslQX3NpL4qAhQy7/lRvbqbeLOFBdiLEu72bNWNWZrdAiR6Lzj78OshJ9UARNwjc@lists.linux.dev
X-Gm-Message-State: AOJu0YyikTUnpkdDNAA48tfKuTjVeK8anan7xrJ6vz99Uz7e2pWuVFu+
	TL3iJZxh07eKf14DWD05mlRMB8iO8DbC2KRRH0auVorj7CuLxzqq721+At7cOr1tXuSQcL2OL17
	7gr4SkCdw/Q+hSpbvPwECz7D4f8AhEe4oKCsLfaDk1MaFLwigh2U=
X-Gm-Gg: ASbGncstEPggBR6mVXKDzFxxdjmCHCqGeq3GRPa/LhLzITmE40wXcBehxbRezhjnHH7
	QOTxK6y+vb3IePO8LeZS8oEFyeIHiVFbww/pD
X-Google-Smtp-Source: AGHT+IHG/uFO/ewrJZj42vcEKEa3DNJ0EvDn2NCbKG87UO1uP4jMl3G4T3F9G2Z6947ZPgYyKqumWNWDItutLlRMg3k=
X-Received: by 2002:ad4:4ee6:0:b0:6d8:a1b4:b591 with SMTP id
 6a1803df08f44-6db0f77b2f3mr18289156d6.23.1734026722575; Thu, 12 Dec 2024
 10:05:22 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20241212144306.641051666@linuxfoundation.org>
In-Reply-To: <20241212144306.641051666@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 12 Dec 2024 23:35:11 +0530
Message-ID: <CA+G9fYuX2BsEOCZPC+2aJZ6mEh10kGY69pEQU3oo1rmK-8kTRg@mail.gmail.com>
Subject: Re: [PATCH 6.12 000/466] 6.12.5-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, 
	broonie@kernel.org, Thomas Gleixner <tglx@linutronix.de>, John Stultz <jstultz@google.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 12 Dec 2024 at 20:30, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.12.5 release.
> There are 466 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.5-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The riscv builds failed on Linux stable-rc linux-6.12.y due to following build
warnings / errors.

riscv:
  * build/gcc-13-defconfig
  * build/clang-19-defconfig
  * build/clang-nightly-defconfig
  * build/gcc-8-defconfig

First seen on Linux stable-rc linux-6.12.y v6.12.4-467-g3f47dc0fd5b1,
  Good: v6.12.4
  Bad:  6.12.5-rc1


Build log:
-----------
kernel/time/timekeeping.c: In function 'timekeeping_debug_get_ns':
kernel/time/timekeeping.c:263:17: error: too few arguments to function
'clocksource_delta'
  263 |         delta = clocksource_delta(now, last, mask);
      |                 ^~~~~~~~~~~~~~~~~
In file included from kernel/time/timekeeping.c:30:
kernel/time/timekeeping_internal.h:18:19: note: declared here
   18 | static inline u64 clocksource_delta(u64 now, u64 last, u64
mask, u64 max_delta)
      |                   ^~~~~~~~~~~~~~~~~
make[5]: *** [scripts/Makefile.build:229: kernel/time/timekeeping.o] Error 1

Links:
-------
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.4-467-g3f47dc0fd5b1/testrun/26281169/suite/build/test/gcc-13-defconfig/log
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.4-467-g3f47dc0fd5b1/testrun/26281169/suite/build/test/gcc-13-defconfig/history/
 - https://qa-reports.linaro.org/lkft/linux-stable-rc-linux-6.12.y/build/v6.12.4-467-g3f47dc0fd5b1/testrun/26281169/suite/build/test/gcc-13-defconfig/details/

Steps to reproduce:
------------
# tuxmake --runtime podman --target-arch riscv --toolchain gcc-13
--kconfig defconfig

metadata:
----
  git describe:  v6.12.4-467-g3f47dc0fd5b1
  git repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git sha: 3f47dc0fd5b11e6655e9fa78a350d64c0a3d53d3
  kernel config:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2q7Ekivz3juYAyrxbUVAOGrVOAe/config
  build url: https://storage.tuxsuite.com/public/linaro/lkft/builds/2q7Ekivz3juYAyrxbUVAOGrVOAe/
  toolchain: gcc-13 and clang
  config: gcc-13-defconfig
  arch: riscv


 --
Linaro LKFT
https://lkft.linaro.org
