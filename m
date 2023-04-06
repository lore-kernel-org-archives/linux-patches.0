Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74D2F7E9
	for <patches@lists.linux.dev>; Thu,  6 Apr 2023 02:48:39 +0000 (UTC)
Received: by mail-pg1-f182.google.com with SMTP id y19so22965406pgk.5
        for <patches@lists.linux.dev>; Wed, 05 Apr 2023 19:48:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1680749319; x=1683341319;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=MHuPzBxJToh2F/SQs1hc1tHUZRPWSYggD2FMkgtFvfU=;
        b=RTKcqTfW0bcbhj53/JSrPCwNJD1Ba88spY6/ybnuphWun2+rmFQmK1uLk0wbkc1kKa
         jZNdcK/zr3w9CBlghABXWIglBm9pYljqfr/0THmtze44cp/qPaitadt/6tdH+khAbuMZ
         QJwp0IwE9qDS0MVsFJvlrnx9tZuMss2F5AR2Od1swe1Vl7P0pacrSTYOYDL+p/IwwWHv
         5Civ59SUpKkTNlbKT5UJWcYwmZqnhAz8UIII9XKvEo2diUqzmauRDGATGkt9zQ18Hcwd
         25A9NIXzLdL5/IGyZGxHwB8HtzwocoE0QBs6TwAF7bxtmHKTDRTYWqoOoacrZRTbq2vE
         REwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680749319; x=1683341319;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MHuPzBxJToh2F/SQs1hc1tHUZRPWSYggD2FMkgtFvfU=;
        b=FnV3ZK2Rdtv4yjEp8sCaCWtsITZdhRmWnySNG4wmx6TO3BFGQEpV0GDYhuvb9QE1YB
         N6pPGVRJB8bBwmWPTiDN73txyOHaAdkZ+wnQJTe2NeUrq3UpDOoj18k5x9nRxBwBWsgJ
         x20hdtHWqPGPwgoH811a0kf0TFlLR+9ovlOEln2Xg3o7ZPvkp6LGSBWd+z6eEHkbD7ug
         TTRhNDf5Qi/QWkRN6PM5F0e6nOhE8sgsjjXFmiPI/8RzaZn4HMBTyW8zTVuyHmor6hFh
         DSwM1hLL/2yIpaVnbydUUS+AFtjYKsUNs8RtMMDx3V+KlOyz7/uGWKwOvst98nagIjyW
         s7EQ==
X-Gm-Message-State: AAQBX9drCOLH8hTuni0/RRtapfBlMmR/nx1SUOfDSbPWjwYYaRZ0fr0V
	NRRLjGQfUj2ZwO4ddE63Py37TiQkD4Tt0hvhN/E=
X-Google-Smtp-Source: AKy350bfpkuIo+RGLpDcjFpvKCAEt+1deus7O3fF9RbKJsscdxuSKlJ3KTv9GDz4ZMdQyeQE61+I0jn93WpfMURtvuY=
X-Received: by 2002:a05:6a00:1394:b0:626:2343:76b0 with SMTP id
 t20-20020a056a00139400b00626234376b0mr4514179pfg.6.1680749318969; Wed, 05 Apr
 2023 19:48:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230405100302.540890806@linuxfoundation.org>
In-Reply-To: <20230405100302.540890806@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Thu, 6 Apr 2023 08:18:28 +0530
Message-ID: <CAJq+SaAc05wRYVQVRHP0zPZfYbHb5nz80JHfU-74MSa+X8_sRg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/177] 6.1.23-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.23 release.
> There are 177 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri, 07 Apr 2023 10:02:26 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.23-rc3.gz
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
