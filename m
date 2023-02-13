Received: from mail-pj1-f47.google.com (mail-pj1-f47.google.com [209.85.216.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11EFAAD52
	for <patches@lists.linux.dev>; Mon, 13 Feb 2023 22:06:57 +0000 (UTC)
Received: by mail-pj1-f47.google.com with SMTP id a8-20020a17090a6d8800b002336b48f653so12307925pjk.3
        for <patches@lists.linux.dev>; Mon, 13 Feb 2023 14:06:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=kvpUXbdttADA6sdXNiBxDIAzea4kHoWcT4D+ic16X5M=;
        b=d+RrvJ6R/yq+GgNUC3a+QDgCiO33flLciJVg8SGuJd1Suylg/hB9Z2A2U28awXyEeb
         RQwlH1Gmepic6kUOy/mVPgh9cZacno9SjQjrFP4JrYRQjAkuTGVyNI+EBunbJO+HdSP+
         eZnL7iPgM4/38igRTw3jK5B+NjPP1GUTXNa0SQ2wlq5qUR/e8y762/QcpCeoOcIuuS+Q
         2ICKz/1o7mgD4WaGT0naGAqo50mck1VrvYW+71/8W7gGekFL84nLcxjP/VkctrZZhWuy
         if6N2u0xjRTYhHiYTZ27+uQx/2LwPJPUbWs5yWy2q479BYDTs24S+IZOTfdgplD+Fwfv
         8bBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kvpUXbdttADA6sdXNiBxDIAzea4kHoWcT4D+ic16X5M=;
        b=s1Fr/y1kUoIiYqaSOBD5kwf1oZfCXRKMAFalFyGFDsjjOllQkO/jaJGaPqv/jiQznX
         tQTmUdimf4QAFyyP5TjlLuNPMPZ7zbf3sOVny/YtgY4dVPh+qeczXeEgl391gfJJ/iI6
         xg9/aiM87hvuXMZXvIP7K3MRMbrdLjWMrKCdAfgysjeOFHL+fJkuQiU7AGR9CU4GapcR
         08+JMnjgOe+5ICIyK9QueoERiXIf0OeR/0iOviSGntUgMTgg3nptqaaBexsXD/ZFNhV3
         8SemF3xqGg6wQmXEQySa711Kg4h7yuPUGStrufirDJjebwnJcXBcBNlB4PlfGJJftG7N
         s9HA==
X-Gm-Message-State: AO0yUKViJONOtWURetYOpeyJ1pK+o3rtDAR29uCp6g2XAEIgFbqnhw+2
	OJxlnu4DubOcd3IPsxUPuH5CCRSlnzDzz+VDpGY=
X-Google-Smtp-Source: AK7set8HL2L34StpQU+/q4nxQXJiYu0X2grhVoj/aXiQ020gBeNUnWEgOGYvGVt27l6N9y+X6998Gykfi3p5ajiJHag=
X-Received: by 2002:a17:90a:a418:b0:233:f958:1e38 with SMTP id
 y24-20020a17090aa41800b00233f9581e38mr1156172pjp.44.1676326017553; Mon, 13
 Feb 2023 14:06:57 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230213144742.219399167@linuxfoundation.org>
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Mon, 13 Feb 2023 14:06:46 -0800
Message-ID: <CAJq+SaAnGWbUCJr8_eeOod+YS62v4QVfBmMCbMaWEHw27krtdQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/114] 6.1.12-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.12 release.
> There are 114 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 15 Feb 2023 14:46:51 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.12-rc1.gz
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
