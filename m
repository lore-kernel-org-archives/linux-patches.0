Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A5DB21063
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 14:12:45 +0000 (UTC)
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-6af7e368bb7so746782a34.1
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 07:12:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685628764; x=1688220764;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=pGewkI3ZGhs7NmIEmWJMKJtAyCliT7h0BVcktsJwU3o=;
        b=iLrGKN6wIAPT9VVUhQldt4cxeaEohbI3mrUxqNSXhhr2+olaCXGHGoXXI5YMjbDm5/
         l5cS0i7lU5vrj8y3EhX87F/ubTpnrEk5/NjdrLdlZtTVPGGANkVz9hLdBLU7I3lVbRHS
         aWnjfKhtA8uD7/hVWFMo7JN+iMtB7RgB1maLxPHR/TaZs9FzNIJrG+BJSXUlZwFM15of
         9eccft+2iGMn8SaEcqR2360vFutF1hMMiTV11K6/w66te4YQo64OsCir4ihzPRWuziYO
         rIjfd/kA4SXGjfIHPalzJP1pc4jpbMlcYWq7JmeQEr+9XeScn/KMdpBbEtFHKjpXnSat
         Hm5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685628764; x=1688220764;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pGewkI3ZGhs7NmIEmWJMKJtAyCliT7h0BVcktsJwU3o=;
        b=kNgv39vqbxsMlvtBjYIo0QKepglGjTe/xubVHY5ypLkGrgkFWTFUzexqYT2Tg1J96r
         tvWNIvmqFdJ/YfBD5iAj5Skzt4nryhe1jtOWDP7NTQkerq9//cZviRAnQbzeEqioKSw1
         lRMOgS1htHzPvq8QuvP1jVV2V+4uoTgDxOfNJuhPpFooPTTxjTLTtpoqYWfjCJvkVFqL
         9JrL4vgKQZQimuZ6KwCDjar0i3XnVqgj6lYmaxHu8y6snPG31T+hFMQj5In16GVbQaj/
         sPoe6TN1azgZHL0o+GusU+UiFN1po9UwGvCCD6GnS5SeqfAdBkC1nFpPgraxVtnG+2Ru
         eBoQ==
X-Gm-Message-State: AC+VfDymg2k0VmvEHo5LL0TfDTlxs38FeLcCRY0afyfn+xx22OMmtZxj
	Ua2629buWw9RY1H1TofJq3des8/MgnIH8qViFW1QyA==
X-Google-Smtp-Source: ACHHUZ4wquHJpPIxqvZcCQ0uKolewssm+RvOtOWUpV4z+7UxM0U9tgUV5c7HdMpqTP2Z1ClfiwF8GrWs42/u2xrYFnI=
X-Received: by 2002:a05:6358:4322:b0:123:3346:593e with SMTP id
 r34-20020a056358432200b001233346593emr3701190rwc.6.1685628763883; Thu, 01 Jun
 2023 07:12:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230601131936.699199833@linuxfoundation.org>
In-Reply-To: <20230601131936.699199833@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 1 Jun 2023 19:42:32 +0530
Message-ID: <CA+G9fYt9d+bZwao0ia_7kp1maKLWepci6R4gUnb_FN2OjCSjyg@mail.gmail.com>
Subject: Re: [PATCH 5.15 00/42] 5.15.115-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, 
	Claudiu Beznea <claudiu.beznea@microchip.com>, Vinod Koul <vkoul@kernel.org>, 
	Sasha Levin <sashal@kernel.org>
Content-Type: text/plain; charset="UTF-8"

On Thu, 1 Jun 2023 at 18:54, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 5.15.115 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 03 Jun 2023 13:19:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.115-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h


Following build errors noticed on 6.1 and 5.15.

drivers/dma/at_xdmac.c: In function 'atmel_xdmac_resume':
drivers/dma/at_xdmac.c:2049:9: error: implicit declaration of function
'pm_runtime_get_noresume' [-Werror=implicit-function-declaration]
 2049 |         pm_runtime_get_noresume(atxdmac->dev);
      |         ^~~~~~~~~~~~~~~~~~~~~~~
drivers/dma/at_xdmac.c:2049:40: error: 'struct at_xdmac' has no member
named 'dev'
 2049 |         pm_runtime_get_noresume(atxdmac->dev);
      |                                        ^~
cc1: some warnings being treated as errors

reported link:
https://lore.kernel.org/stable/CA+G9fYswtPyrYJbwcGFhc5o7mkRmWZEWCCeSjmR64M+N-odQhQ@mail.gmail.com/

Reported-by: Linux Kernel Functional Testing <lkft@linaro.org>


--
Linaro LKFT
https://lkft.linaro.org
