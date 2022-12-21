Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB4E8185D
	for <patches@lists.linux.dev>; Wed, 21 Dec 2022 01:15:38 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id fy4so14229463pjb.0
        for <patches@lists.linux.dev>; Tue, 20 Dec 2022 17:15:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sladewatkins.net; s=googled;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=+ecA2KXfjiKAstKqFn0Kl2sfLSWuL9dSPL6PdGndRJc=;
        b=HLhMHTdtTaY+RzmPvx3EykrQea2pY8Rqo0th90WsLsGFLpc0t1uVM8lpLvzai3MiaM
         A5Z3lIQWq/k++BdsWInnJlXL6IkvDxqoVBR9yuwpCksa+EDOFoySF6sOpeXyZJhMqXIL
         7/GWSeWENTy3TDSqvvCHd/IHuKS8PGsEcYj5aP7xlPv9rGTjvwnUZr3i+MNiBxMcgo1C
         /xoThY/k/NeSRI3W3yTpNnMkXOg4wLOAB0q1u+GLeArOyG3rsB4qLn47/Wqcnje+yr/e
         liku4EaRFuEA4Zuj/SwnXZRSsi/Jp+mgDirEOUDMgtZdZQNuqjGMx7R8n0eX9zFsoJiC
         byaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=+ecA2KXfjiKAstKqFn0Kl2sfLSWuL9dSPL6PdGndRJc=;
        b=Nyhqxm3kkOlBBw9EUvhwU1hQ73Udfgo8iesGxYtD7jYcakhuUGupZ27HfBt2ZDD6XD
         /rtNsszBsUi/+2zAgSHe0TxkRF2i3KKeQLeDshFhDmYfxqqxUjdyk1ebBMwy90Oyi5Af
         SbVWbhfWKZWD7c6pQbjb7/O14wuVRhlAfGtfCrQcyUpURIZ6mOglIqSfbbezwudZfp4h
         S50mdD7g2wMe13Iim3yOnNnZezQtuvM/mk0tNvogNys3Xvrw+EWX3c0lgs8URTc6q4zV
         YFXPo6ru2qkKAVfoFUBGwrDgt09GVXo4H5IHapdgD8zOF2VzAeaEpVpKoGqVVKpztA1y
         RI4Q==
X-Gm-Message-State: AFqh2ko43C+LW049zXSr3PZ/+BuAZHE66rSQOlRklbt+dzENqc6FMAYc
	NcyBYRTiC7E8xn1GsnRCi4vwZpAYnf3TuyOUMXy9UQ==
X-Google-Smtp-Source: AMrXdXsOZC8o3lMenbRvAifZAxKpZqUVvFbfth8W2cnPbqoe6AHhagMGsxRpAaMf3Lvn469gMvUswW7LwzTYnvEZLLY=
X-Received: by 2002:a17:90a:af91:b0:219:536b:41ef with SMTP id
 w17-20020a17090aaf9100b00219536b41efmr15187pjq.71.1671585338288; Tue, 20 Dec
 2022 17:15:38 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221219182940.701087296@linuxfoundation.org> <CA+pv=HMdmd5E=yH-1_dbF316EQ=KkriAPgLg8e+7m6wbinchaQ@mail.gmail.com>
In-Reply-To: <CA+pv=HMdmd5E=yH-1_dbF316EQ=KkriAPgLg8e+7m6wbinchaQ@mail.gmail.com>
From: Slade Watkins <srw@sladewatkins.net>
Date: Tue, 20 Dec 2022 20:15:27 -0500
Message-ID: <CA+pv=HMJ1K5Hhho7FgsGEf=7i2ZROT6y8X9Q6m1LXSyxj9h4Qw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/18] 5.10.161-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

On Mon, Dec 19, 2022 at 5:36 PM Slade Watkins <srw@sladewatkins.net> wrote:
>
> On Mon, Dec 19, 2022 at 2:28 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > This is the start of the stable review cycle for the 5.10.161 release.
> > There are 18 patches in this series, all will be posted as a response
> > to this one.  If anyone has any issues with these being applied, please
> > let me know.
> >
> > Responses should be made by Wed, 21 Dec 2022 18:29:31 +0000.
> > Anything received after that time might be too late.
>

Hi,
I noticed that the original message was missing my Tested-by...

> Compiled and tested on my x86_64 test systems, no errors or
> regressions to report.

Same applies.

Tested-by: Slade Watkins <srw@sladewatkins.net>

Sorry,
-- Slade
(via his corrected script)
