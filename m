Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E88052CA6
	for <patches@lists.linux.dev>; Tue, 20 Dec 2022 18:57:40 +0000 (UTC)
Received: by mail-pl1-f178.google.com with SMTP id 17so13250473pll.0
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 10:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=mSPTHsXsrhOIwndCIwPpGYW6EAktLLgeTGWc4GBS0Ec=;
        b=CFYf2eZ3CxVmwaUbcrKsNBy1u3NuzGBER4gEuMCisQ0jtzy5T7WsAdO0uC81YTwpqv
         Lz7OJ3/Hvp19gi7jP53I5nGZV6qMTknqUI8pR8oaIQzh7zTkMgB5AeRBVmDOjpP+7O4Y
         nfBMDg+AH6rST6a7BkZXVsYQUIoHq0XuY/BB8zPvcJPium21oZKC3zEWhxQncGi2JbiJ
         1+GYdPezqgQPcHHE8TB/Ewz1FekLkzcPml+VQHnvWXI7zyPZxC2fI4Avhj5pWOXI7vet
         dWZJt2cjRqwZgU+b4GeKefFv5tesAJhGSy6+2a51JlMGJLSd5/nCRXmJcaLW9niefa33
         RAoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mSPTHsXsrhOIwndCIwPpGYW6EAktLLgeTGWc4GBS0Ec=;
        b=A/ynzLhH+kg/zcoJsgvDg0cp1iKafRi7Xjonwe7eVevYO86z/r10e06QKEqIj4Q1rx
         tpODIuh6OT7o30q4/LEqQ7XabkfCWW7vYWP8kilzTGEpdgvo8nWaLSdq7Ml2SiQwC6VS
         yARRdvOae/K1tIfatY+gJu2dQf9uwIgg5XYB4qxpOdcgLUYUH8hAflxLajEAGkFZ3dWg
         f0nrSKPLIgmcw6WOVcl2c6FTMJD+zMjc1QW8AiQROKayYyxByC626hBOtvt2Utb88ElE
         FwNAWQxoj8tAqzvqBWT+ZTZ7yywuv3drg5s8g922c4K8BGTKortjjEqrxRCz5H2lqsdd
         HKXA==
X-Gm-Message-State: ANoB5pkRusKhr4wUVCD+gbQH+N9+futF4vnKB6UapwiFF2DN3neYhAqT
	OhqOHfJUSK6QOhPjj/VJ5fC1FAPwTfwzLcCt4mHCF4GpMEY=
X-Google-Smtp-Source: AA0mqf6l0TavrCU9yrUNKxvMLdkUhelDFyBVVaaLkbmUpK9hN79cFp9gg2EuTkBDIgjjaIxXPqohuR4pcmNWkgGWx4c=
X-Received: by 2002:a17:902:c951:b0:189:e81a:1520 with SMTP id
 i17-20020a170902c95100b00189e81a1520mr16236577pla.48.1671562660294; Tue, 20
 Dec 2022 10:57:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221219182943.395169070@linuxfoundation.org>
In-Reply-To: <20221219182943.395169070@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 20 Dec 2022 10:57:29 -0800
Message-ID: <CAJq+SaBiKCraBGBY7m8RmvSxrPF=Ccw579nMkCnhp+N1NYLPfg@mail.gmail.com>
Subject: Re: [PATCH 6.1 00/25] 6.1.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.1-rc1.gz
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
