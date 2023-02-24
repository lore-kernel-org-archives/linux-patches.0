Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 101EFAD58
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 19:06:20 +0000 (UTC)
Received: by mail-pj1-f49.google.com with SMTP id k21-20020a17090aaa1500b002376652e160so268911pjq.0
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 11:06:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mWEnmoAM+fydC30L/SYccqR/3unahEyglhtexpvnYHY=;
        b=ZJfuPIMP4hE/aZsew3a8Dyna0EjbqYmwSJh/0oo3Qb57UDaO7fK0EERSDrC2x5t6LV
         M/g+eJBurFS7ggeng2fC5YazSccATiiSfsMDkZI/q4It2R4MSacpohboKexg2HD/ANRD
         YiWoRkVrY622zGNE5tRmihvvG5zXFnceB3tTUlUH/ucnP1C6GxqufBKj0/hOs9bQGYrG
         0hrtibh9ONBMmEtWaOYAz9c6tgdVh2KfUR1smq5+YO8ZOCdo7V9oVBD6RcO6ATzXXJ58
         A2G0pZA2o7pewqM39cIVv79pZ/6DSTdXwQnmOkBbXQ/ZZ1lRKwsTiY+jOdzy1XmKAwqF
         uwIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mWEnmoAM+fydC30L/SYccqR/3unahEyglhtexpvnYHY=;
        b=nlRpU/2iecTy4yceuNE4mMwhVgNwr2rlEqj2EJVo8AtOTRRKqpHV9dxbAU3toPHXWt
         AZCI6XtjBu+F7JVtzQoLyLRb3klauyLvZUFuCtUWMhW1bArbCBygz8ZwdopuXK5wCsYI
         04EIMOtu74ht2owVoLGm86D6GQeq8XiycLqg0n1j96SSMDsXbgVPnLzoPQob44t3oboQ
         5lUIRjn7H+x0nHgcl7Jrli0CHSdy7tR2dH7nINqwS4dzHUOrUIl/qahzvmjprj/S3UH8
         IjM1026G5KBmL8zGlAa3JxPc3hfy7o6IQxy7qabWcgtxg59VXw9b5yHMFlUQYlVdCFYl
         QLYA==
X-Gm-Message-State: AO0yUKWuFe0iPBz4jYVbNkxdL0OWVVepkIgyPeem+AS2cZ65GzvX9Qv0
	QZGOqard7ZeaaaaqxW/4u75c5N8f2Fv3hepLTLE=
X-Google-Smtp-Source: AK7set/EUePO3CtYPyTFvcjXEHJAOrDQAynwXfQNdGtSYzbyYsG0toXFg8QPwqh2OEIvcWAzFuZsarXQ/EV/s8FAHZ4=
X-Received: by 2002:a17:902:ab1e:b0:199:2451:feaf with SMTP id
 ik30-20020a170902ab1e00b001992451feafmr3491268plb.3.1677265579543; Fri, 24
 Feb 2023 11:06:19 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230223141539.893173089@linuxfoundation.org>
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Fri, 24 Feb 2023 11:06:08 -0800
Message-ID: <CAJq+SaBTme=ui06N_09Pyc2nLSOwnvzZj0dSibODUgA6zL=vYQ@mail.gmail.com>
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.2.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.1-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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
