Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 723D6125CC
	for <patches@lists.linux.dev>; Tue, 30 May 2023 17:02:29 +0000 (UTC)
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-256e1d87998so298671a91.3
        for <patches@lists.linux.dev>; Tue, 30 May 2023 10:02:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1685466149; x=1688058149;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=R8y7yMNzZ1Qqhpw6rilc+hpdM25AgZyUqwGPTyZvG30=;
        b=JVzcVggwmyRveToNOSRrzjG4a7ygx+T88EwX6Jiqkm6w+4l3PEXGCSlVKcgEHLB8kG
         ZxlGgChiCIQLHOiVqWQ0SQmwA3Jm57JvGACwNps1r7tmZ8t3iNuhHC8NK1BLTTqWLdYq
         KQj2UaqLp3bY3B5H0VdMQWRMX88fLheJh5jpLSF4BnGXfgPIC4/ZwAfQGJ02J0AiJD2C
         4+XsjvN+XO0iQnlGPmZrmv3tTdMjzkN4/1b1YrU4WtfN0xnb39T2bYhJYP0/T6+bOrNN
         VKAPqbEJKX5KePCzaQJsxdfU9wXQ9mWSYzC0LUMVSvN2QreNLxMyWuoet8iCBzXHF70g
         CJcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1685466149; x=1688058149;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R8y7yMNzZ1Qqhpw6rilc+hpdM25AgZyUqwGPTyZvG30=;
        b=fG6twxtFdkroo55/T5ze+ErvVa4yTSPtKx7v0gNo5S0dd+OTQMGhGCtrXcFIsdeUPl
         0hKptOKT5nR+frcV1+qAjmMrodxweEI0zNnTaCqnvVF6TN4149/fVabqmvazhDsFNPfI
         MdJO3c4v9/PqkKzYkiHuovzz3OZtNkr1i+SaVlzJjzUGLveoxUg+ruaSgnj6qZ2n3yW1
         QT2ivCdyk1IOdvHZhvRrrgyLR7a7/0OnkjoFTySNBFOPRyXyrv2ZRiv1RfSzI3b4985m
         tXlYlP4dLYGTKNlo8J4VzbWk46M/Es5nKlZtAn0iZih+Kwc1bvbwlB9zqddDT43SYUmV
         gDBQ==
X-Gm-Message-State: AC+VfDwBrF40nYsbKYERaRwyF3k/inHIZsPqFL+x4W7L5EPvfkGcU1gl
	zpxSKyjWKZizN6X52j4jRyRv/I8ZDgHjGBJVntQ=
X-Google-Smtp-Source: ACHHUZ7h6bz8p9RbMa12RIVDXgKFTfWqgt7XTokWmigWLZSciY6OzVC41VUTCh37/71OMtc3oZUIKTC2sEYLvnncv7g=
X-Received: by 2002:a17:90a:cc9:b0:256:6f35:fd60 with SMTP id
 9-20020a17090a0cc900b002566f35fd60mr2934376pjt.17.1685466148757; Tue, 30 May
 2023 10:02:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230528190835.386670951@linuxfoundation.org>
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 30 May 2023 10:02:17 -0700
Message-ID: <CAJq+SaCyTfTuD5Qte7cA4HhSqUzUOwDXWnNp10zTBLM9Gh5UQg@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/119] 6.1.31-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.31 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue, 30 May 2023 19:08:13 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.31-rc1.gz
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
