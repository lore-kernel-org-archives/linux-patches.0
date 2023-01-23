Received: from mail-pj1-f44.google.com (mail-pj1-f44.google.com [209.85.216.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD1003224
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 17:08:59 +0000 (UTC)
Received: by mail-pj1-f44.google.com with SMTP id v6-20020a17090ad58600b00229eec90a7fso7082342pju.0
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 09:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=DQx1ZYz4K0qsZVhAjIXu9/aggRexBv0BEFKN2lOjUzU=;
        b=Ayu0j2rJRSbWpuBTQlalSiwe8BcTOeWjyYwmCK8klCW4poeumbUA1PJ7ZviFKBTuwT
         KPbr518xRALuDsTHxJeQ+tgzghJWMK+2tpC5vypdsMQlIdiyPV+w8tFxqhP4eiQMDDG8
         icfTxfz6dVhMvCM2obNp0KuTESNcMgJXOjGxhJ/2ROjnRwn0y3VmCI72JheJ8Is+PpVK
         PebrulyP5e9sTdQM/RryYxM4/0rneknyePPlX7cypxNDVlkd5mtg4gncXoT6lpzZoI59
         v0SinIWZF3O8m/RWEqBdwXZteVhWBVWgZYAm2KlxliH4AwOMSUBiAKWcUFUrMXP6vkVa
         Uihw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=DQx1ZYz4K0qsZVhAjIXu9/aggRexBv0BEFKN2lOjUzU=;
        b=YDGMgXEDdTidhAhPLHD27SBjW5y7OZIDWsVEW5uAguuIKdGyMEQspPrfk7LFAG84Cl
         yh6wEEtKvmXIOmkQ/EwEUx38kNbZYvZl8DsO7Q2cMq/gO1h5vozA97Ysm+OUtN29jWCz
         2seOB4wuHisCb5mjwv0wPcOPOp1QXBrOJvzMkLnj5JV6DCiCyFBYrrx08ynx+cp+tRmy
         OFvBxwxl2p16+OhR5w/1XXCnz9ipnMPOy2kjkgxudWxgiYG8MxeIuSpI9Crbtj9i3zSw
         pUAT7Lu/bgUWuVcChPvCdhRHLtBfcTiYPPFNeTXVD9RW2t1gl/7UEJxkeN6L3qaXJFWS
         AgZg==
X-Gm-Message-State: AFqh2kon2xIvA4YKiDl1DuItKFXNNnAhLPAV0oanyUsNHdMZnEa39KPk
	E9egeAoPkI0A1GIi8FVFLkHHNfbXbA37xaU1pN0=
X-Google-Smtp-Source: AMrXdXvC+r5V9h1FTjDzrRDiH3ZAgPcyxh+tifryaeZ7LyOUg7otR8yjyXkyACzVn/INg3sMtBL55Zp5cxZq0x9aTu4=
X-Received: by 2002:a17:90b:d8a:b0:229:15d7:8a27 with SMTP id
 bg10-20020a17090b0d8a00b0022915d78a27mr2916998pjb.12.1674493739108; Mon, 23
 Jan 2023 09:08:59 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230123094931.568794202@linuxfoundation.org>
In-Reply-To: <20230123094931.568794202@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Mon, 23 Jan 2023 09:08:48 -0800
Message-ID: <CAJq+SaA_RFiRPh3X_dn0az2-A2wDiQKK+c_W9sYUaDs0gcUFvw@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/188] 6.1.8-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.8 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.8-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
