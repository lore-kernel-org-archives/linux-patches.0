Received: from mail-vk1-f177.google.com (mail-vk1-f177.google.com [209.85.221.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51F7856765
	for <patches@lists.linux.dev>; Tue, 28 Nov 2023 13:25:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="i5E5wbeQ"
Received: by mail-vk1-f177.google.com with SMTP id 71dfb90a1353d-4af8f20034cso1742466e0c.3
        for <patches@lists.linux.dev>; Tue, 28 Nov 2023 05:25:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1701177915; x=1701782715; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NZrP9a46FvVK83LWUKH5z9MFb7/rqu3GX5jpGe7sb8o=;
        b=i5E5wbeQB3aF1qqb7AST2R6TXjo3WLZbzxuMSODOIgR3CkcUaHhLpLLYcGOM76Fq2H
         paqmmkQqjCCaDbWHQ4V8N4bSNrhnq4iGjgfEou02tB/NhSlH3RX2P/+dyKxPC+zrwSIy
         noQpxTf+fuWSFoffNGBwJyxOs6o94e6MQ4swhoc5xg7GkI/RsBDCTjxly6HW5H+ehHlJ
         3pDz8IGWS5CwioIUlgLjAntKMq0/Cc0ijdDAPcYF3Jkm2mvq1crQ1O693C444Q8UUegz
         nnuP1lckSB37QgdJRfuueGX4pyzHVvDVCh/lAZmMSYni2mVSu5KRcOSNWNL6OMQ24ONK
         gX+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701177915; x=1701782715;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NZrP9a46FvVK83LWUKH5z9MFb7/rqu3GX5jpGe7sb8o=;
        b=kSmgOykDse5CFDBnv/2tUtj6LxXVAu4XdNh9sqlMTTsxeFx/MPW94ZeVY8FFZhO68z
         kQaZcLxKyx6aBJlnqLGaerpHhLNYKl6PFzxNXf1oKRw9GGduvr4Xn4dsay5W+JUWW0xx
         Z38Wkiehpi7h8T9c7yxyOWpASdiCegX/qBJnTCWIfEgWph6QzItHvY/525kERkfY4g6t
         4T0x2zXLi9Fe4qUyjQ/iE8dbkSv4YjVT652cKr7mjZOnIg1FGdy+69/IgKL3C3eaoDQN
         oZWbxK4M1IhXCI2Dm28+Z1LKopU8xmj3tlAoe0ztINhuQmY0Nle0KWlYE/TWMJRjBRFK
         y3hw==
X-Gm-Message-State: AOJu0Yy82dHWn71boXPwts4Tg1Y1gexBWjZ8WoYlksBBEMBSqqFmbnet
	44BJJEOVC7N1ndlwPzlMrY4WGLqEHAv+k8neJRA=
X-Google-Smtp-Source: AGHT+IGfF5ufbqwsLkM7y/tE9HdjIvjY0fJ1ryH/bxiCfeHLeH6bnf/4/F7mDu7k06N+J0PK6TetzL1xv38Qkya7qfg=
X-Received: by 2002:a1f:4ac2:0:b0:495:febd:9187 with SMTP id
 x185-20020a1f4ac2000000b00495febd9187mr12281525vka.0.1701177915131; Tue, 28
 Nov 2023 05:25:15 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20231126154359.953633996@linuxfoundation.org>
In-Reply-To: <20231126154359.953633996@linuxfoundation.org>
From: Allen <allen.lkml@gmail.com>
Date: Tue, 28 Nov 2023 05:25:03 -0800
Message-ID: <CAOMdWSKic3ZvWRsTW4Lo5WWLtS-RFNH0cKKth-WbzZw_5rZM+Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/366] 6.1.64-rc4 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.64 release.
> There are 366 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 28 Nov 2023 15:43:06 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.64-rc4.gz
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
