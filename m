Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46FE0628
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 03:00:48 +0000 (UTC)
Received: by mail-ej1-f46.google.com with SMTP id u19so49215139ejm.8
        for <patches@lists.linux.dev>; Thu, 12 Jan 2023 19:00:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=futuring-girl-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=O4qDazh6QwMY3LvG+D+8H3mKX/MyNkX+etoMzkezwE8=;
        b=pYTE8kAoX/zWZB4SBkbDjTTBh9UWIFd+P6SC5jQkDEeDj7PdVlns9VanBfpC7qY5kO
         MiGmJTQ7FQnjxnzX6GW5X28SLY8Q3CMu+fFKhPhJ3ItVJa0BivOqTLXojoCrL+IjSgGn
         5Pa6324U9cLfYcL+Csd2ytA4CDUMZ+D+3GkubrvDJFdkcX3m4/o5hQ0D8s1LKCIMS7mV
         H9ZEgSXw+J/DMm1ojfv4nYY8stBifqXGnU/lYH+GGkwCCji7nxKvLSSx4VpPL9QbRy/m
         D7QCeR+kr056reSnTMDH8uD34/UwFZwHU9Hu63SSd4eTfpWLyFlHWs7OvOgtkd5RytIX
         Kosw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=O4qDazh6QwMY3LvG+D+8H3mKX/MyNkX+etoMzkezwE8=;
        b=JFG/JyBSJkbKhRWzoO532XfDM7vljQHmKSiStc112QPXMB7oeLGHqNEFPZ37GSL2Hs
         QIIpndiqNpbLgVn06o/NKNxbuukgPdbSDsGk6n8ZtZTI5Vro6njf/HF3w/dOD4gZdnzi
         sFByWhWJS1Vm8LNwIO9jGWpMsJ/xQXIvusIknIYN3X5I7gaUsjlrrILoFy6OENRcZNU6
         STIG4/FA5Qx09jMcfnhj6NJBaEizufclEKqoMm4cvttsqZXvXbSANwLTJC8OtSdt6TiL
         +xPaT4aE3etKQWKX3mOLm0g2h7fqotge86/rNdz2ZSyPIi/amJJf6qOIAN1l/rxbTqzw
         nhrQ==
X-Gm-Message-State: AFqh2koXFwwxeUk/R43vL2KlUpq9psxVfMTTBNuUAjcZvworALeIcIOP
	Ya+FeaVqFnG8MH4dcPCuI9fTTfQHWF+zsjF31cg0yw==
X-Google-Smtp-Source: AMrXdXsbh24iYUuFadTTe1PMFifWTOQcuum+A9Uz95nsAZ60lsYQu66zxBEUz4ouiTYVDeR6nqEhn+NNkGF3JuYlD0s=
X-Received: by 2002:a17:906:3b5a:b0:82c:356c:c4c8 with SMTP id
 h26-20020a1709063b5a00b0082c356cc4c8mr4396513ejf.649.1673578846300; Thu, 12
 Jan 2023 19:00:46 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230112135326.981869724@linuxfoundation.org>
In-Reply-To: <20230112135326.981869724@linuxfoundation.org>
From: ogasawara takeshi <takeshi.ogasawara@futuring-girl.com>
Date: Fri, 13 Jan 2023 12:02:42 +0900
Message-ID: <CAKL4bV6F5KmT0iE4MLVVW0o_SMyFN1dj-Y+Rt6xN63yAhXtAXA@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/10] 6.1.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

Hi Greg

> This is the start of the stable review cycle for the 6.1.6 release.
> There are 10 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.6-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h
>

6.1.6-rc1 tested.

x86_64

build successfully completed
boot successfully completed

Lenovo ThinkPad X1 Nano Gen1(Intel i5-1130G7, arch linux)

Thanks

Tested-by: Takeshi Ogasawara <takeshi.ogasawara@futuring-girl.com>
