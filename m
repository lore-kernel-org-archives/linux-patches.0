Received: from mail-vs1-f48.google.com (mail-vs1-f48.google.com [209.85.217.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 087EC3984B
	for <patches@lists.linux.dev>; Tue, 19 Dec 2023 19:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XP1KFWEY"
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-4669e00a7e7so507252137.3
        for <patches@lists.linux.dev>; Tue, 19 Dec 2023 11:22:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1703013748; x=1703618548; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=nXpA7ooi/F79bH7BNeUI2ESUWbdjubcQ/fAj+TlOEQg=;
        b=XP1KFWEYn+SIEBZm1gKWYolvIKh6GQc5NMQBWRK9pyzzUub7vayxsw28Fih9w/DMkz
         NY44rHNc29Lh+xh4nhDjx5T1a5N/2+jn7+XC4Is2YJrtg6/Wld7QSyoEdCPnJuHocxIF
         ZghwUNj2lt7Q9QMgdEsk2bqrhomGYb8J1+ctX+1RlAmufQgAbAhyeT+gBBcPKcBAgpV9
         Fd4IgZ446AoRbNscf37ZTy6fYhwLqewmLlo8anqihAq2+k9G9Vbejs7annR6BqiI0e2O
         VT3pUi7EzXFJezlPkEpDHEAk/Zg4PT07Zb+s7e30zasbYXR11S6k2WLlquPTk1tbf5vt
         X4wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1703013748; x=1703618548;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nXpA7ooi/F79bH7BNeUI2ESUWbdjubcQ/fAj+TlOEQg=;
        b=s08uvqNW9DBteMKIf+TdjYkDcTi8btiIlU42fUPk23UZjBX58uJSL3XqvTiTcNpE8x
         ++gK7/Gg4g/WI24kgZ7gwJvdsxyo9q+HhHyB1imeyHq4gefzUCyZzniDYnQIrICH1TLe
         kEOX3qi0wUPXl4D4JSkDIVp4/mwihib2jInvlG08wdMdjEqz0/vHa/SUI5NHEd6fmsru
         xKVkMSSXpT4ZiZqpU8pROLwqYoiDot+mERgh00qVAUeKohrHVbm8kHEwHdRXqAZv0rDt
         Jvxh60B0UKdo12yZIIi2Yh4HI9tTv1U094eJeBZH3ekSYD3zp24mI0lGvIUBL1IFBlcK
         2ydg==
X-Gm-Message-State: AOJu0YzlJqgBdIYQNYaA9n9JR7AuQyWQ+yzpP1LD+NERhgu4TT2rkQuY
	wW/E3xizhOjOMdTcI7eroual7UL8Zx7iL48hpek=
X-Google-Smtp-Source: AGHT+IGw1pA9ALP7yssdgF3p89vt0ffPjdrBVZ2yij0P1tQGMV2cXGdAN8EuEP03Z1wYLapbAr70kphpkEDRQC2xByY=
X-Received: by 2002:a05:6102:3909:b0:466:ab9f:cdd9 with SMTP id
 e9-20020a056102390900b00466ab9fcdd9mr1404550vsu.11.1703013747834; Tue, 19 Dec
 2023 11:22:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231218135049.738602288@linuxfoundation.org>
In-Reply-To: <20231218135049.738602288@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 19 Dec 2023 11:22:16 -0800
Message-ID: <CAOMdWSKK9TY45H1MrDKjeyRSBMnvo7ZUAatO5y8U10UjYF5skQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/83] 5.15.144-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.144 release.
> There are 83 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 20 Dec 2023 13:50:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.144-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
