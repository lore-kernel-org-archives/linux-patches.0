Received: from mail-pg1-f177.google.com (mail-pg1-f177.google.com [209.85.215.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6637B20E3
	for <patches@lists.linux.dev>; Wed, 30 Aug 2023 16:33:09 +0000 (UTC)
Received: by mail-pg1-f177.google.com with SMTP id 41be03b00d2f7-51b4ef5378bso2899a12.1
        for <patches@lists.linux.dev>; Wed, 30 Aug 2023 09:33:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1693413188; x=1694017988; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=qLb04PjPHAKkElFOM4zEg1DvSUxLNtirH0qTRIs/MZ8=;
        b=nDPgD6fjAF5rnNc1LOj0K0RdasdvXr8OfsB7e7ljOpcYhrSm/dDnEwJf1Rx5srdVVm
         EJM4hxyq0K5IQqhu3V7WvawW9na809yrfpnR8L+mBvpGWtR3dlX5wCwt/wq0W/EuenQI
         x9pRQyKhHJXuZs2z609CxApsQoCAo98SKFzu+MjohdCzBBn35z+CS2Tie12s93kalGWQ
         +Ynm86RVtC+KGEWm3W+zxgGWWRWEvBRHSGSK7zdFbJWDu9uf09En0MATnE2ALgS3mXMS
         3D6qSKIE+tX9JSZQhjaqpNeVaLE8CjS/YWKYVQWgFwmP1DrLpGhXSCwrvhdG78yfjehs
         5wNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693413188; x=1694017988;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qLb04PjPHAKkElFOM4zEg1DvSUxLNtirH0qTRIs/MZ8=;
        b=HWF2CPOWOp/SESi5LuHua9DEeZp8Yx6BNWq7V5dtSkjBLx2Cx4hA90bnuHnNcxZmMN
         wgKuCvRwg3v+PzKkWgDuL8mG6g5k7qo6EQyl0FxcR8nnMQtfnU1fMT+X8cJkDxqJhQN8
         IWeBOEqENcGNDW+YUXHyUYry1U2vWgPcMkroeCZGBSggDKQarZLlEn6DRUPNBDZcx2BD
         8ZONEhLNeAgGtJsdooU2TJvOr+8muqjwvqNdRt98sBm+yD03bNssG7FtqWWkCt0ydHav
         APAskWoU2Ii5nsOOuBKHuP+W+AwP1ubRC/ioiDBV+1AMjYHQhswfYzUotHhKXzkN2KMO
         frZQ==
X-Gm-Message-State: AOJu0YxobiU/+/omgN/qp7m+oWP8t1N8dp0rTk7w0wQVrb4SONgTh027
	94UjyIcdQRn+FEa+nmcfsqGfSSf6bhiPjSqLYVQ=
X-Google-Smtp-Source: AGHT+IFrcOygUcEGQM+NJxGZgi51vhGwiajCsPw73JLpC2sttxHYlJq0rcRWAOi9eGduPrbHAkt2UIWJ9O/VKr6MKaI=
X-Received: by 2002:a17:90a:928a:b0:26d:2162:f596 with SMTP id
 n10-20020a17090a928a00b0026d2162f596mr2603868pjo.6.1693413188478; Wed, 30 Aug
 2023 09:33:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230828101150.163430842@linuxfoundation.org>
In-Reply-To: <20230828101150.163430842@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Wed, 30 Aug 2023 09:32:57 -0700
Message-ID: <CAJq+SaCZ7moOv2TBD01h6LEg1B1RVmOzR5=eF0nD7Uc6hUaj-g@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/89] 5.15.129-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.129 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 30 Aug 2023 10:11:30 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.129-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
