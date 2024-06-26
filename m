Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63D9813D89B
	for <patches@lists.linux.dev>; Wed, 26 Jun 2024 12:21:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719404505; cv=none; b=rmbytno6Qz0wOmYRxzuwmYFPMnaVk+pTTy5PIjoRUV4MI2oDsibXGiifQKZ97KkdFf+DQqpWyjmmWFjRxNk/LwAjHTOlM1h8vIGqeA4pEBQUOT6Wowr7P6AIGxZ3fiQVkCdH2OQYgtLXWAp2AVHpoZZiPqd+Dsta1EZZcRGGRg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719404505; c=relaxed/simple;
	bh=QCLlRXgX1ZZCFVtyKp13Ok8pc5WyHMikqDpTarWERWw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qFVIJtyuBJ63duu16nwe3ECCZfU6G0S+0PtP1rZ7wwawkBL09Xu2/j1XE/Ji0LBxzCO0WAXxX3rFtAqIfh+kLwsizn0+k+0OFbnLDu5IZjWz+9hasnsi3vYlc+uIYfI6wPy/8y1QosITwSdc19tz2ZH/7Nk3+C05K9cnLzQqYC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CyqF5b7I; arc=none smtp.client-ip=209.85.218.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CyqF5b7I"
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-a72510ebc3fso511842866b.2
        for <patches@lists.linux.dev>; Wed, 26 Jun 2024 05:21:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1719404503; x=1720009303; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=actSsM3hNGF2bGjnU5RcQ1zHPu+xDjUXaQjl/LzrCsM=;
        b=CyqF5b7Id5COvjpiSC6oZ3KcFB/jvBmWfbCWvL3LNq1fJu35QxgvYSvCuCnhSAJEiL
         8A75qP84uQTMxzui3aFjknHhX+RK/AyXD1NUIzqJY9+WEQEDUKc6O2ReGT1e+tlDwIRb
         4dj3F6ie1OYGv8t2TD1nLsZ6LpQzFKR8rBw/vxdUZAxqW8Inh14M5Mzgq/8HbyN9RG+/
         1RDE7ZB/2a9hQDLEZixhJn4fM30gZJLFy/gz2orKlTfmR1kWrN+stgC5ujTPw0GBM0ar
         T+02vjMlyy82RHERcyDA+fxDlRPJpXEHPz8ZyNBd2e/45De+MtpqfgNe0h2W73KAcwjO
         FGGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719404503; x=1720009303;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=actSsM3hNGF2bGjnU5RcQ1zHPu+xDjUXaQjl/LzrCsM=;
        b=S3oZs2c799WRgnu6mkHuZK2b3ws+KYstkXFGfydKRz0sDm6PalieVRU3wji9Y5Fljd
         5pLG4HCjxAUP2Ts6EsPDJ6MFJ+drGH56GJVHAfRrm1dzEdfCyBvDg+Qge20sWxNt4xO6
         Umbe9IQibF2CocXYNNX8abmZ/17WDyN7xC9htA4LV5FHpuwXjWkpbuwiWghK9y8jHBSp
         QwmAuZ+QCssR68utO1BMPbgUOqV/Z+6HiB5VWqW6Q8phd2TCuNAL3Hrbb8CgQu6G9BqA
         877D+E3DJsAftDbjrI67PvNklbwFDyzsA59EjLGPWZg/t1Suh18j/PaVFCaiI1UiiXRS
         /v1g==
X-Forwarded-Encrypted: i=1; AJvYcCVE22bl3vCBYIj61UzscM9EMGU82T9U6fNIrg0NEqQFBS4WxvgG9QtHr4B07irIca283TMfqjkjynOl/8b94pU2tGaB07hefw==
X-Gm-Message-State: AOJu0YzpTOTNLnVimjTFbwG8aoroEMMirPEQZ4AfbpLi+Z63SHqje5uh
	HnHUu6jZtw8HU5eRLVaD//Dw+Ivz47N+I0S1ggWwt7mS4gDHM12I1AqH7p/5sjludFAadhZcFRu
	JDmWwXHdpat+zWxqsUr9k8qM58E4=
X-Google-Smtp-Source: AGHT+IESnBMgA6R+BjLPZ43rEzuwryURctWiotcablADk+plT6gf/pE0SJDAvl/7TzfCU2fShP8JiWzI/YbVZY5hVto=
X-Received: by 2002:a17:906:111b:b0:a6f:11f8:c21e with SMTP id
 a640c23a62f3a-a7242cdb66bmr811904066b.58.1719404502592; Wed, 26 Jun 2024
 05:21:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20240625085525.931079317@linuxfoundation.org>
In-Reply-To: <20240625085525.931079317@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Wed, 26 Jun 2024 05:21:30 -0700
Message-ID: <CAOMdWS+TdRG7sQy43RdGL+j-OC+-SceH+asxFu6685ZdkKES+Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/131] 6.1.96-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org, broonie@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.96 release.
> There are 131 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 27 Jun 2024 08:54:55 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.96-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
