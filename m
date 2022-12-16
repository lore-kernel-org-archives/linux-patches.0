Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91F851378
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 10:08:50 +0000 (UTC)
Received: by mail-pl1-f180.google.com with SMTP id a9so1826874pld.7
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 02:08:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vuVGiZvFz8J7abJwlLLv4bBfBMgFKLRkZEO1QR9SecQ=;
        b=D2vDQxAcbQp3xe34yuQkUv51/1m26VAWmUrIpz0GBE0LvEV60sF/U/ymfQ7bYu/7Nd
         JlpTpjkX2rwQ+xi2d/zzz2i837cLnqWdgW3fa8r7GkboAYZMl48iUMtMkzO7Q4iohRYD
         +weFT6w+wp1GegAKZ4gwIr2PqvUq8fh6kPDmdKZ1pxuf/dqQwguEQzkbEES8uQ7j630a
         OKz4EmIfrho5C4XQR/5nJpri7Dx4T0KnFaqHTDLmnqWQJ7X/jwQ9zgfXED3qCUoK5Gu4
         rcE3UEJuec3Rl29loR+auMiPQWSsZBNJB7mk/fx/R8dMq3iT1WMkULRl/LO5+CFaVPRc
         fBOA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=vuVGiZvFz8J7abJwlLLv4bBfBMgFKLRkZEO1QR9SecQ=;
        b=hyLJEfamb0h848vpSc5n4cV0b2bLhr1Yk8M004su1SIU2kvvFJI4rcKwEYkOORFK//
         GvbHwllhwOjy1RtOHXcJ7Gnlw0GljYnS1xD+7YiMEDkOnjhYKrXR4C+9KofuLsmhU/pA
         CA8nP94Kh+IvIBbdl/Sfi8Zs4Q622jvh+2arqEtiS/vRwIZgd+nJs0AUbZL+/w/ijNvr
         TJZkeOPbfFKljxXSSzggt0rwQm2DD8rOvdLk1YhbA++qwo44I2Q01WqIa3FdjQpKTP28
         ZCGWUmpb3SaRElHSU55LwYIVMBqZQGwSYmaBPFgPzHpzXgtpjUYYDi9FTU7oGLpFf5iU
         8HRA==
X-Gm-Message-State: ANoB5pkgZ0mOuYZSj3IqSQ4qw0RZ2ETOlPW3VzkZikiVmwqKa2O1PNwI
	x91rYgPQ4ymfaET8GXUP3FOtt3bScpEPgYAi3Wk=
X-Google-Smtp-Source: AA0mqf6jKiW+QBza+9Dt6MNcGE/GIsaSNlmIGk6P9pw3Wz0D1/qkaj6+PJGiPnFa/qrlrZKiUkGcl33DyS984ewAth4=
X-Received: by 2002:a17:902:cf03:b0:186:5d7e:7ca8 with SMTP id
 i3-20020a170902cf0300b001865d7e7ca8mr79778092plg.74.1671185330002; Fri, 16
 Dec 2022 02:08:50 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221215172908.162858817@linuxfoundation.org>
In-Reply-To: <20221215172908.162858817@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Fri, 16 Dec 2022 02:08:39 -0800
Message-ID: <CAJq+SaCAg4xk=WSc8KXakTnMjqNdh=0gbLbURgiq9yR7Oj+i2g@mail.gmail.com>
Subject: Re: [PATCH 6.0 00/16] 6.0.14-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.0.14 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.14-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
