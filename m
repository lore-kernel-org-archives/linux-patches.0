Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7618519D892
	for <patches@lists.linux.dev>; Thu, 25 Jul 2024 17:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721927454; cv=none; b=ZsVZeIULU7ApEhnDX/B1QeNP8d954CjB12s6nyxVlv6e+JitKmP9XRBzamWKO4ZqCheckU/oK8t6LW5I8OcQ1SO1Xu6TAww79GP6oH16HbsIOlQXAmBFecqKJ5d/LM6pMOHOW1bZjjNjf5sd1Tjwe+j5q3JOqdZ9Eab4c6Nzhro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721927454; c=relaxed/simple;
	bh=yq6fiZf90GE/tQySFOVh8V/HeAcKNExS/zycZaa10Co=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E8ryK5/lm9AKS23F45l5xMszvj/fUJEuhBoqZuL9/6JaiM0NdYK2giyz9HhAFgqEZzpXnTWA1tGe2AotKk8h5IOZQXpCgq7a7te3HVL3mLVDL4g4M1i7IeF8JGLSVJGhZC5DfcSY1icuhZYBXowr4wwNRMuSaovhmNUB/W96pQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=keVomZSR; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="keVomZSR"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-3db157d3bb9so43382b6e.2
        for <patches@lists.linux.dev>; Thu, 25 Jul 2024 10:10:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721927451; x=1722532251; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u/6EDuIv5npXWqlxfUSzl63jK0iAGmMuRKGsW0DtQFk=;
        b=keVomZSRQ9lIJleaF816JnKQFISHuXOQ28+rPiUt1iFmXtokvscSRk24po+kbqMfJD
         vIrlm2UbVjjXgNOaqGcIfN2NPbNyjv/qZBRHX5SNLeBFzTAf3nqtD75ma/8HGwdz1qpb
         sFiYiQc1lV4Z/EryzzD1QXS7peHOT7XGqvxTGrLM3Li6K0GjWcRnAsGcOr6yfK6igIPy
         Bm8BxTRyhxbf/S/m2yUjpdGpoaRuNYqPnLwFCEwD3s/+APcJsRfZ+cxT356j9zGeg0Dw
         1CG5Ry3DaZh70Zoesey4Ui9J46cqmnJA3WWAwR3c0aWJjqGbU/cKhGrC+3tJtrWxEXth
         lrzA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721927451; x=1722532251;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u/6EDuIv5npXWqlxfUSzl63jK0iAGmMuRKGsW0DtQFk=;
        b=Fp+X00Mw3kM/gf9VaOmbcLuWSa2mxtJtOAG910iSFa7CWtdrnAcUaKklz0XuubPRNm
         xCF50LAV4oEd+I2/eav2EvEUC6hywLllZlo+lXH/xj0n1ZRT4LaOxS6OX5uZpTge4aY0
         L3rVDplDLWUrmSfeA2Mdl3pnsVJkMrwhL38UNA/k8Ly150oON5FVBJ9knMiVLRFt5YqV
         /9v/EVuqB8Pb/a8wI78smBG1dVU3G2bZafANhLfBlf0R12AE2hP086z+hhzdPwFd2Vth
         dwjrCavEqaXqEt9fbPirWedThyt2lGbyTb+AriikJbW+clMXamS6bAbBJ2Q4SgBX6hjh
         c0dA==
X-Forwarded-Encrypted: i=1; AJvYcCUZKrEB3kLLisM0b70+1t7zXNT7dGKfeQgjUHb8+iDR6j4q7RpNe1HmYmSs8c8FcGg9K1Q7GDszHC2VuaJjfLgy9B+VYG3fWA==
X-Gm-Message-State: AOJu0YyH/K5ic9Hf67ou54PKuKz9YFZvFRchkNBVrJv1R6YlVJxohuNa
	w92jstEjWKviCXYRH3WMbeO3EYfGQLcM62nUUACsDufMTDf/hF8OTW3GjehQSBf4V/j7JGvPWND
	JHJp9ijhtmNfdmJio1sX0fmwam/diXALFEu/JtQ==
X-Google-Smtp-Source: AGHT+IGZJWFzM9uMa6wq5NoAxXUBEnqFHPu1rf7aDHw1G3YQx/Iwzcp3y7kbrA2Tb6TdzHCuqJn2Ds6P8BN7E4HUIA0=
X-Received: by 2002:a05:6808:1924:b0:3d9:4004:ff27 with SMTP id
 5614622812f47-3db14118421mr2499522b6e.21.1721927451044; Thu, 25 Jul 2024
 10:10:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240725142728.511303502@linuxfoundation.org>
In-Reply-To: <20240725142728.511303502@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 25 Jul 2024 22:40:39 +0530
Message-ID: <CA+G9fYtZKAiw3abrvxmBovfYbJK7XcpV0aqH8Lg9wPc=i5ULHA@mail.gmail.com>
Subject: Re: [PATCH 4.19 00/33] 4.19.319-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>, Ian Ray <ian.ray@gehealthcare.com>
Content-Type: text/plain; charset="UTF-8"

On Thu, 25 Jul 2024 at 20:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 4.19.319 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.319-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following build errors were noticed while building arm and arm64 configs
with toolchains gcc-12 and clang-18 on stable-rc linux-4.19.y also on
linux-5.4.y.

First seen on today builds 25-July-2024.

  GOOD: 8b5720263ede ("Linux 4.19.318-rc3")
  BAD:  f01ba944fe1d ("Linux 4.19.319-rc1")

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Regressions found on arm:
  - gcc-12-lkftconfig
  - clang-18-defconfig
  - gcc-8-defconfig

Regressions found on arm64:
  - gcc-12-lkftconfig
  - clang-18-defconfig
  - gcc-12-defconfig
  - gcc-8-defconfig

 Build errors:
-------
drivers/gpio/gpio-pca953x.c: In function 'pca953x_irq_bus_sync_unlock':
drivers/gpio/gpio-pca953x.c:492:17: error: implicit declaration of
function 'guard' [-Werror=implicit-function-declaration]
  492 |                 guard(mutex)(&chip->i2c_lock);
      |                 ^~~~~
drivers/gpio/gpio-pca953x.c:492:23: error: 'mutex' undeclared (first
use in this function)
  492 |                 guard(mutex)(&chip->i2c_lock);
      |                       ^~~~~

metadata:
-------
  config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2jkAGJux4DNHx9cFS4VQJrPrBvc/config
  download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2jkAGJux4DNHx9cFS4VQJrPrBvc/
  git_describe: v4.19.318-34-gf01ba944fe1d
  git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git_sha: f01ba944fe1d15cbd27088980031db315340e6e4
  git_short_log: f01ba944fe1d ("Linux 4.19.319-rc1")

 --
Linaro LKFT
https://lkft.linaro.org
