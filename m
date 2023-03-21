Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2902810E5
	for <patches@lists.linux.dev>; Tue, 21 Mar 2023 02:24:10 +0000 (UTC)
Received: by mail-pf1-f178.google.com with SMTP id i15so4114850pfo.8
        for <patches@lists.linux.dev>; Mon, 20 Mar 2023 19:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1679365449;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=KBp3hodYXuxgjFv1xVDSLLR5sBVnx2dAi5bauwPJ9As=;
        b=kRNPCobLYyveiwrz97+qBUd6Y+yDw6wCRufopTl6egsG9zjGXuuHujgyRpUR9QxCll
         4o2nsOEf95FlHWjd1X6vOJLBDkDFfAQIKmAwuzVtRLg0DEA86CGBYJvwo4/sIJhm/QVa
         mof60+FtL//trUiGzWypSWNkxdxPxS4f5D1sTagYvogp9ZzqC75G1UwuHL7/iUSBLBxZ
         y5TFH10/L0GEpxJrcdM3TsVL3wbLAQEXa68YaUiluTE7qUWLmInSQtyx6UG8AOgJ8P03
         zeei6H4pqKXaQ4RwZKJKCxL6ZoqMpO7bLGsmTnFrucQKDT5+wumwNFKU9Z+G01EcluJJ
         eHZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1679365449;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=KBp3hodYXuxgjFv1xVDSLLR5sBVnx2dAi5bauwPJ9As=;
        b=c/CP9ZOMt4FiCjKBBZox+CZvO4d2hjS8XdjKiYIBi1/0iKwA100ZqzjVERrQLj9nYt
         QY2mGh8RAlTTGqNpAeaofS6qughMUqEN4GdNrFViqSEPeDjiFGZyGUhKI3b4plITPzqc
         KwmRpzOJ9dP3+FY0U9c0rjUVDogB8vxlW9UJeODbSLtD3nZsRXeQorn/gxWGXPFVcrtl
         /TTa0uKmTHRd1eWwVlQVJq3gj4OSYp+rzqrS4bgHANhCZw6DHxKof4KpZM+IMs1e5qz8
         z0LURiLNB0Uoss7s4dQCtN8BA9DjD5pJz+zpYlfi9YlCSBFMBEykcA62bvVYj5ptSzxE
         BeTg==
X-Gm-Message-State: AO0yUKWY8mmMH9roVORYgK7bIKUGq3VtRDBjSlymKI9ob/aci0TnhCOV
	iNq0Wg43iyhfy8tnFu+7ViySce/QaOWwokih3jY=
X-Google-Smtp-Source: AK7set/6akrAshpxac6FFFp3TU4oiU1mFSNH2zV40w97FSSiie+v1Zzqu1mzigHWIWaE4/zudCFRQPcUBem3mfqW0hc=
X-Received: by 2002:a65:4309:0:b0:503:8226:f872 with SMTP id
 j9-20020a654309000000b005038226f872mr210899pgq.0.1679365449652; Mon, 20 Mar
 2023 19:24:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230320145513.305686421@linuxfoundation.org>
In-Reply-To: <20230320145513.305686421@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Mon, 20 Mar 2023 19:23:58 -0700
Message-ID: <CAJq+SaAcQe4ZgTNrvXWsX7+u9xPhHYbdK5qFf8a_XF6whb9+gg@mail.gmail.com>
Subject: Re: [PATCH 6.2 000/211] 6.2.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.2.8 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Mar 2023 14:54:32 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.8-rc1.gz
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
