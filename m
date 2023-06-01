Received: from mail-vs1-f50.google.com (mail-vs1-f50.google.com [209.85.217.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 895D021063
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 14:11:21 +0000 (UTC)
Received: by mail-vs1-f50.google.com with SMTP id ada2fe7eead31-43b18ec23a1so386414137.1
        for <patches@lists.linux.dev>; Thu, 01 Jun 2023 07:11:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1685628680; x=1688220680;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R/OrhcM2qA3Znm5Jyw/3ZuuOkhx3JHN/zmOdcF+ZCtY=;
        b=ncW89JSfVLm2WvgeTOR2v6iWdCxphxQFfsfECN1dSJsEA25W+8U2ebFhDWp6g9WoAX
         a1pxXmSYY74zVWmHVluE9JZtM3G4RS+dAw1GojNaN4a2yN7dNn2WX156KlLRZxZfznQx
         ahKl0e5VwArv3MgXLA/TOBUVSfxKbwnkkb4VOEW15n6eyGpyLQkayb+Z6bYJn90jmg6K
         RFQup7zHgKmOAJ8TfB76aO38NkX328TfC2sNj6WyRHWTWFqUBWM/T+/PXLmrKHgC6e3U
         6XihXE9JDBn1IIBnG63ZdgCp2Oua+iSzXhs2YPwofF2yewO+bIoKeSit03/A7FZha1+K
         i7Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685628680; x=1688220680;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R/OrhcM2qA3Znm5Jyw/3ZuuOkhx3JHN/zmOdcF+ZCtY=;
        b=JgILbObUncuAsJL+OpgLO9MPTnZ6DNX508KD5CS7mv13Wg65USJ5RGUZWUNkl3KVb8
         uk7qgG4A64g317ak3S71vKD1dEHe5PIbB1HenNIx+wUea+ihsoqp7IlzqFgwAYTQznaA
         ui+pm1Xx7XDCJpakhQJfrliwSMxrY/+c1xE27toQvc9GqtuWjnyzQUP8p1L0KSx5GQbg
         LaM4zl43cixdZuCjtDnM2xpOtUm5UV6f9DbBDEKtIKYG7zTrtKrTRUUbtPAgV3ijQoZM
         DvTaH2lSGhOzOTaEoCDH6saTVsaAmYDwrMoXMqWMD07HgXBsEcnpX8w2DVWP8W8mBOgT
         c0ow==
X-Gm-Message-State: AC+VfDzCErXitfaj6iPYIWgQGIuTQLHl2amtBt8g3YMX2cGAjF6zTXGv
	LnjWSBcpb+wJ9A9JLV8LkjtmW89NHuA9g42ZsDvMKA==
X-Google-Smtp-Source: ACHHUZ6SaFtgdCw/8gINnUKdnzoU59DfImoxjuAOeE3tJKxdKy+L8ClEm22ZGULJfhF3Rn+G7Xu6ClungkRrItY/lSU=
X-Received: by 2002:a05:6102:94e:b0:43b:141a:f911 with SMTP id
 a14-20020a056102094e00b0043b141af911mr919370vsi.16.1685628680102; Thu, 01 Jun
 2023 07:11:20 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230601131939.051934720@linuxfoundation.org>
In-Reply-To: <20230601131939.051934720@linuxfoundation.org>
From: Naresh Kamboju <naresh.kamboju@linaro.org>
Date: Thu, 1 Jun 2023 19:41:08 +0530
Message-ID: <CA+G9fYuHjNhe-5TboAbrOeZrL3xL-CYYSaEnL=8onebLUqDt8g@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/42] 6.1.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Thu, 1 Jun 2023 at 18:57, Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> This is the start of the stable review cycle for the 6.1.32 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 03 Jun 2023 13:19:19 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.32-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
