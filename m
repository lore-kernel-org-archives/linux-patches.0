Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6495101ED
	for <patches@lists.linux.dev>; Tue, 18 Jul 2023 17:30:52 +0000 (UTC)
Received: by mail-il1-f182.google.com with SMTP id e9e14a558f8ab-346392da0d6so25101725ab.3
        for <patches@lists.linux.dev>; Tue, 18 Jul 2023 10:30:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1689701451; x=1692293451;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=7uJNrPb2IKEH47xLNWX/WXtagKONU11JTCz6dajhAnA=;
        b=bw80+EiqwxwsbhnqikH/AUsHwlYK0VB1mUp355XdaB9G82juR3s1l1HjUZVznoknb+
         QyKAkoQJ4oyNwhZiXSoxrFtr4ihgBRnqJn7R6SJ9DxriJaN+5rE4CTyd3Y0UGOU9YS16
         aHDqWI1TJTb4Nw9o761oC0nEvcoc75hHNwya4D4O2lqTwzsKMySUNN3w4dt8C44TLRYz
         zJjD8zYGA5vDSES4B64rxSaofCMx6XC/3+GfQRGxxWL+diz4CozI3Beo3JOhkSO0Y8Mr
         hZGDXrYlXGAILIiy6SZwB3l7PLK9L1K6yEZR5Rk2WRNFd8ZWe1+ie2JoFsn9oe4YxthC
         eywQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689701451; x=1692293451;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7uJNrPb2IKEH47xLNWX/WXtagKONU11JTCz6dajhAnA=;
        b=faevCmUZhgw+vzxlyoXiacrwvXP/QKk5+KAOtEU0QsFnNGGE7xPbYEvSCsIirlaXGE
         2YsWYGd/3Llu4XG8+H76dP/sMiHbrkr3dD4QWY3BNn567AB8VlEkjge94iD00R87w5qH
         1W0HqEYkZooKZcR8wvGrtTRDfRYB7SLCjj45XwgQG7/MYLa3NoBuB20csrox/NoB5wyg
         z17qcUCSsaQwSecQXrcCHiJeXRktiVpQGskVLMbGlvmqyofriBMyROgzdWKiNHT4yAg4
         Xh9Ke3O/yL21LlqIWIAHIt5N8Mp4Wj1gGPnCREIpsHKsBtd6yB2AZMmp8RfR1yzgNv+N
         Z/EA==
X-Gm-Message-State: ABy/qLaDNqAeJrLQsbfndem5+6CSkthe4eBNdRIJCrAWDoSNpWTivNC7
	nWe1KYvpPPIM4sNDKlG1KJa12znT249Fy7Mf7Hg=
X-Google-Smtp-Source: APBJJlG/hjrwsimT1/hWsDLi9khDkXsFq+F16HLb1wrHRRHYdrxXqWGln+eTku/hXOVLCjC4hRCmPFzTtXL9pNScEDc=
X-Received: by 2002:a05:6e02:2191:b0:346:3eec:c893 with SMTP id
 j17-20020a056e02219100b003463eecc893mr3917937ila.0.1689701451515; Tue, 18 Jul
 2023 10:30:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230717201547.359923764@linuxfoundation.org>
In-Reply-To: <20230717201547.359923764@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 18 Jul 2023 10:30:40 -0700
Message-ID: <CAJq+SaCn7wCd=Ve3Dimadd68sd9TUBZa97Py7nNdtoJGt3DkGg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/589] 6.1.39-rc3 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org
Content-Type: text/plain; charset="UTF-8"

>
> This is the start of the stable review cycle for the 6.1.39 release.
> There are 589 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 19 Jul 2023 20:14:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.39-rc3.gz
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
