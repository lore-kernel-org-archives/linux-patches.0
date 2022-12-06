Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB378801
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 23:48:06 +0000 (UTC)
Received: by mail-pf1-f180.google.com with SMTP id a14so11975332pfa.1
        for <patches@lists.linux.dev>; Tue, 06 Dec 2022 15:48:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=um9Hcw2o48paIqU5FPh9HJQhrZz180gbgMLBUyWpz5M=;
        b=mNnzmCKaWRpiFBderq4iNe8dBMZyUGTVjDQyqS7Cfb8/vhiB4s4195/0OPtakWRm/h
         khUt/rs9BC6RR0FL9QnbTsxwFioHNExYXFfvyz44kGMld2Y2cz6teyrKOMDahL2a9sEr
         9Ww8mesGKcvpoq8Q7+uP4oDIlbk7zbvt/Szs+QuneNIwLYsaUJTcYh0OoP/L60NYPrA6
         7bn9SUSBdHyezL8gz8tXI9g5k3BDTGjn17NbdHrW3LeRR1mKnacen4eecyrW3/vPHHgx
         mimmQyupxGZQzf53BoS4WB55KNGcnNuVoNENeBrx3vGygBtM+xO+g97oJ7VpskhAnQBU
         Juaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=um9Hcw2o48paIqU5FPh9HJQhrZz180gbgMLBUyWpz5M=;
        b=thcm/TPi4XedpaQU9r2U4whjQ+CHVP5CvHf+AVJXES+tg/B0G1LKtKzZE965MBRL0S
         jkIacTlENrxqqTvzF3LCNEPPvDtcQjSLBeFiSIL8q1Sf4mu095dCkJ/7hwtwBmsnrUpb
         2ADvtD9w96IdNimKAyBTzvdp+GIrzoaoHTr5vAPE8zXz0ZL5ze65NIUcNphpStOVA2U5
         h+qolo1cuONhNKs2uwOSpSZpn7rLJhQo45Z9YsmLo97fq+XleAJUMvXMLeP8ufLVUrpw
         eYhDQaGLCLNXvVMnUNhM/NOPj34mkXx+Hwf9kWekY0Gu74lcPCOhd761VTUwAf92vGrS
         hMIA==
X-Gm-Message-State: ANoB5pnTbfCAqiS37m3vDd9Lepz7MeUv7fPUAyJa7/dZaARSJGiYg20e
	7WcPo8D14J2ipz+BjUiZW/5ypUJ5YmBMlF8/xwU=
X-Google-Smtp-Source: AA0mqf61GIWWGTUrz18zgGeHvgf3eMnoN781eYgNf1B0oen/Ln/Xmwq4NwvvpwX9VPD2RmvnKZaSquPSMq5upsxszKE=
X-Received: by 2002:a63:1f52:0:b0:477:8fed:8121 with SMTP id
 q18-20020a631f52000000b004778fed8121mr61048988pgm.342.1670370486026; Tue, 06
 Dec 2022 15:48:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221206163439.841627689@linuxfoundation.org>
In-Reply-To: <20221206163439.841627689@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 6 Dec 2022 15:47:55 -0800
Message-ID: <CAJq+SaBg0nmt0pzr4F-NhiAvgjdLRosxtsLS-pazx4uNrZBFZQ@mail.gmail.com>
Subject: Re: [PATCH 5.15 000/121] 5.15.82-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.15.82 release.
> There are 121 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Dec 2022 16:34:23 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.82-rc3.gz
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
