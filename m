Received: from mail-pl1-f170.google.com (mail-pl1-f170.google.com [209.85.214.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B83327722
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 18:07:11 +0000 (UTC)
Received: by mail-pl1-f170.google.com with SMTP id w23so14690995ply.12
        for <patches@lists.linux.dev>; Tue, 06 Dec 2022 10:07:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=2YtxpTRBMkQrFKVlk2fLe5SF6BAZI+FTZ8g6kFOfOAk=;
        b=Hx3c1iTrsaQWgVMlJZ/AjAREoRG8YNOURxidP0YjgaPt69QiceSsgqs8rPspgjy9sJ
         e2ln0P7ZY4MUFKGepPn58S0wFlfdL+SnHC3BSEpBtxu100X2aJXMtGXF8AxjpZfHTO95
         8FDMGGvH4gQ0+BoupBaV1tghVUhrxWsq7GH60tm/Z6/Htn03oF1RuEzQx1LMyQmdrag6
         8Y9DteQwk9FnQz84C2VPMymjsjHWjvQg9RVaIOkNtE9rrVovUy1jku8IO5Dk9+gytqSo
         2AGIFvoN+HlitDp1f1HRp+Ai3QiYaEGx63L13+nCDb9CiSQH/9JPAopgxu+KZCL3svTO
         9/KQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2YtxpTRBMkQrFKVlk2fLe5SF6BAZI+FTZ8g6kFOfOAk=;
        b=HESXbKnr9hXJXacMcVGvW8xobM+1vKHx9leDU1bBkB7+EHY+KVvdtliXq8eQahhKGM
         2aoWoIq8JlgqALsAZaxSKpdN47ASvGJmyQ5cnITP6/wx77TpSSZ/K5cUi/FV/h45mDa6
         4T/HOxgd4ASCQjiKMDjdddNjjWsa4m+yPgHfh7A5eYmRRDgDm7EpqQcOURoY1Z+noZhO
         bHZxM5Xd2V4HicCeY0u7pqVGWcNsE/kCFtyMAJLfwIh+65l/FrTgSY0ZP5McyWpPN4lz
         Mwm0H9iBjnQdm+I/yNFdVqyWcAnRJzcRh1Ccb5P8Giyue/hLejtRxHXnT3Qa3GJGEflV
         IUoA==
X-Gm-Message-State: ANoB5pmtbgzz2S+/VhDga0jCZCj9i0I6HOpKAmoFl6hLwv3pcXC0acrH
	n4t6eiayh2RvGvs1nm1zU96ATenqsG4/snM3bWY=
X-Google-Smtp-Source: AA0mqf4KfDHXmkm1COm0QbVzaO0KO9OVT7vFeFskzI57ZSVymhCP/xzXMl8NoNFPgEEzzOGSFYnKLtDdfC70gazcOL4=
X-Received: by 2002:a17:90b:194e:b0:219:64e2:7570 with SMTP id
 nk14-20020a17090b194e00b0021964e27570mr33838030pjb.213.1670350030909; Tue, 06
 Dec 2022 10:07:10 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221205190808.733996403@linuxfoundation.org>
In-Reply-To: <20221205190808.733996403@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 6 Dec 2022 10:07:00 -0800
Message-ID: <CAJq+SaCmmB_NgM2fHi0NYGOqSuio8WMATGVFwfh1vzzCwsG7SQ@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/153] 5.4.226-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

>
> This is the start of the stable review cycle for the 5.4.226 release.
> There are 153 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 07 Dec 2022 19:07:46 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.226-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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
