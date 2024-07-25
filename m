Received: from mail-vk1-f172.google.com (mail-vk1-f172.google.com [209.85.221.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A357219D892
	for <patches@lists.linux.dev>; Thu, 25 Jul 2024 16:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721926711; cv=none; b=jvDNfHNLg0T+XWPo+Za+8alGbek8O2XwcM83vHpyuwwsbtG7zWyriMgCAE/IcX8N0AsucJMgIANzNDAGr0Mjao4wPIoqLn7MhXSrJeHGeulNtDQO0j7t9Qm5oMFLfEPQFdXppA+uveaHMCqZk/f8WFS3b0+hs2Awvp4DWq4joNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721926711; c=relaxed/simple;
	bh=Eh+GYj41EH2bfKgWDm+bmK5udsi7e7BfjyJqmvPoP/0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=X0X6eiPK+4WFOd7BIwUj5M+mB8pKecuQyIv9nsGsB8sbxscwfPlm/iwZdrL07BOCvvbsMUmW56+yuVh6MJPQj3Els3qUUrP+C7aqlQnEhJVE7sWCi3W+8paE+2GGxU/qNLfLOCl89z4S/FBq8L9Rgy0COGcIpGDkgXpFQX1jtZg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=Gq/IKF/n; arc=none smtp.client-ip=209.85.221.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="Gq/IKF/n"
Received: by mail-vk1-f172.google.com with SMTP id 71dfb90a1353d-4f5153a3a73so392542e0c.2
        for <patches@lists.linux.dev>; Thu, 25 Jul 2024 09:58:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1721926708; x=1722531508; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=VDQ6s6CMG7gHp/w9EVEaonlcBFFTlypRMzTuMlEuBvY=;
        b=Gq/IKF/nxb6aVc3N4xl5cvqFrNRy98sVdnjAsGOzX+UFFMr9gYQJWTT5ZfiWSxGkS0
         ur9p96e8xi4ocjD2GjJfzv4yDzRJi8I27FXuexIr+A4/Xwtu+3JYkdqguztOrIgQVoLh
         k8SfIt3hDSGWbm6VYCLSRoajJh0mAnFtGOLxpXOJUkZA+xb+8F4YzgyHfU1mQSZRe7Zq
         SQ9wf+rfkeJPWg0hYFMXuvX+oMThcKelfmQ32mYX2TmQM8BmDbT/cd5yJ81aSNia5FUX
         C+f+T2v/Ot6Nuq/nEassl7Gt2lH2/Ewd+r2BIBsjiMcHP9sdua4LR/+U7aLWKyJ84aKh
         3q6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721926708; x=1722531508;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VDQ6s6CMG7gHp/w9EVEaonlcBFFTlypRMzTuMlEuBvY=;
        b=cEqaSha3ggK/JVEckX7u5u4+H3LUxNutmf535M5tLBEwPwaZ0ydyiNmA55nKBYxxnc
         SFt7OVOCb3T/IAhvCpGso817bdtjAnKeh01C3IwKsT5nT5+EjFcSDeqdsMR4Ogi9W0Ai
         rjSzkEWLHpj540tASexgQ205gmlG81sSwz7LkSTZDYZ6LXByLyli1mU09SeiPaZ9lcFg
         obXu0IvdOXyuBmlTNWG15VCM7CtjkphLSNTAHKYAJLGjbP4xhli89BqEcKiCh7XRk/CZ
         jwiWiMTNfRCKjLcSeI6cdsoeFGjaD9UEPkYRPbUxI8AvqS0PwUJnH1xOXsCjbt3d61wi
         I8QA==
X-Forwarded-Encrypted: i=1; AJvYcCWyGiIEwLBF1SQFzJ1USzs6SxG0uVXqSiuG1XL8OuVD00BOZbY6aztQrPUkvodpnLYFHOIoVecE0qMh7egY/7lk3gjlbUSy3Q==
X-Gm-Message-State: AOJu0YzDK3x7IKsQny03J82m5FJG7pg3dum4Sm8wmG+l7t9JMCtT41vZ
	4coM1fQh9yjm0H7GZ3R4GweDuXJHUGS8kCIS/p8c0Ur2nyyA2KVaUSOrsF8S8pWzV7TtOTpoFBD
	8qP6MQFWcAzbEC2VxHznTOtfvUlJ/ldtmr252Tw==
X-Google-Smtp-Source: AGHT+IEqzIGu6UGuRS/hG4Muuvv+ROC3+TMPz4G/q7GbQ1qVMcFVJrUiW/7L+Riug4rto673vTz15kixh9I30mEwN70=
X-Received: by 2002:a05:6122:d8b:b0:4f5:27ac:ce6e with SMTP id
 71dfb90a1353d-4f6ca2f4282mr2619326e0c.7.1721926708409; Thu, 25 Jul 2024
 09:58:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240725142730.471190017@linuxfoundation.org>
In-Reply-To: <20240725142730.471190017@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 25 Jul 2024 22:28:16 +0530
Message-ID: <CA+G9fYsVD0Yn2WPqu3a_CYtDZ=XR4WctQLOyTdn=EoS-idDHGg@mail.gmail.com>
Subject: Re: [PATCH 5.4 00/43] 5.4.281-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, 
	broonie@kernel.org, Arnd Bergmann <arnd@arndb.de>, 
	Dan Carpenter <dan.carpenter@linaro.org>, Anders Roxell <anders.roxell@linaro.org>, 
	Ian Ray <ian.ray@gehealthcare.com>, 
	Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 25 Jul 2024 at 20:12, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.4.281 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.281-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

The following build errors noticed while building arm and arm64 configs with
toolchains gcc-12 and clang-18 on stable-rc linux-5.4.y

First seen on today builds 25-July-2024.

  GOOD: 4fb5a81f1046 ("Linux 5.4.280-rc2")
  BAD:  13f3efb40ee1 ("Linux 5.4.281-rc1")

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>

Build errors:
-------
drivers/gpio/gpio-pca953x.c: In function 'pca953x_irq_bus_sync_unlock':
drivers/gpio/gpio-pca953x.c:699:17: error: implicit declaration of
function 'guard' [-Werror=implicit-function-declaration]
  699 |                 guard(mutex)(&chip->i2c_lock);
      |                 ^~~~~
drivers/gpio/gpio-pca953x.c:699:23: error: 'mutex' undeclared (first
use in this function)
  699 |                 guard(mutex)(&chip->i2c_lock);
      |                       ^~~~~

metadata:
------
  config: https://storage.tuxsuite.com/public/linaro/lkft/builds/2jkAGMFVlBW89jcWOIsv80LLLSa/config
  download_url:
https://storage.tuxsuite.com/public/linaro/lkft/builds/2jkAGMFVlBW89jcWOIsv80LLLSa/
  git_describe: v5.4.280-44-g13f3efb40ee1
  git_repo: https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
  git_sha: 13f3efb40ee1218ae1933c1a9f876c2a86c48664
  git_short_log: 13f3efb40ee1 ("Linux 5.4.281-rc1")

--
Linaro LKFT
https://lkft.linaro.org
