Received: from mail-pj1-f46.google.com (mail-pj1-f46.google.com [209.85.216.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68D8EAD58
	for <patches@lists.linux.dev>; Fri, 24 Feb 2023 19:03:41 +0000 (UTC)
Received: by mail-pj1-f46.google.com with SMTP id nw10-20020a17090b254a00b00233d7314c1cso3796303pjb.5
        for <patches@lists.linux.dev>; Fri, 24 Feb 2023 11:03:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=w047R3oLOZSFdNh2VFLQBp3EdizSwQ12bg2tndBPkow=;
        b=JIKmvRfQ5uC5/dwlBMFCV67buClKNBWww/Q3KlY87dfsl0+rMiwPwEiMEj3PYyp292
         HSDpF9njfZLGMxTO5WtfQVfiE6NwdjQM05ZaJq/teikwRpIxr7IFH73b+BVP+ZkgF05n
         CxamMeNmJQYBaVNlPqfc3eyfezBtErzEtSpN4MlEYGWUkD6V4aHZYq84L3KeuUCDIxEt
         YTpcSe4z48jWsxsqjrSZ99KCxU6MvW36xbinZ1gIxJALeLNJsykhIJcPek/oN6Lk7AaP
         qsTNmQkYdoo/cf1+Wny80kKlx7wDAnpvC8OPsgGCNmIQ2NQbUwpkCzTc6Iw8d+GcVxZo
         zZoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=w047R3oLOZSFdNh2VFLQBp3EdizSwQ12bg2tndBPkow=;
        b=7bwTmouA58RS/XvKA/+MVIDnn+p3bII8CCyjrY2FxP3tCKfg3xpWcstaJ9XJiBN65O
         MYVV2aJLvk5ajm/I2izBTDYeggi9ZEsKekmXqC7fVAibARwLaj5xOBZe8DODX0mB4sns
         U6jC4WaqEnbixgwKPcdviVbBooPlJ37XttNWBomPoBX3iiBT0948cFMmkL1zIprEvQ0g
         plWd66Q0Hzv1syTgyZVQlHqunOHeQZ/dAUiFTk7f420dyiY+6jIoU1lKBagLYEi1gT8l
         pTd5Q0/LIn4O6PdCObyfYxZRy3ov4YO0p9Dmt8W9tkY3IuTvKdPHqHyweOJvQrvXujSx
         TcRQ==
X-Gm-Message-State: AO0yUKVnmHTMFRV+FS+N2dbrIfKZyohBo4Ne/wPbr/M04gyl/YtVIL2a
	O6vtT3c2IdN6MoZnSJhtU+TWeWU5H+iWl7AAlbk=
X-Google-Smtp-Source: AK7set+2Q/QjdEZpZO84t6SELi10/Mel41wZ7/+hTLw6k3DUAJh5RUWWTHX3asiwnQnFdxQQh4XBiwHOSHf7hv7LNZo=
X-Received: by 2002:a17:903:26c2:b0:19a:fdca:e3f1 with SMTP id
 jg2-20020a17090326c200b0019afdcae3f1mr3376648plb.3.1677265420822; Fri, 24 Feb
 2023 11:03:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230220133600.368809650@linuxfoundation.org>
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Fri, 24 Feb 2023 11:03:29 -0800
Message-ID: <CAJq+SaCQynXLnL50ZFq0PdgjY+kCB+puqTbWs5=dyLKp2Xfh4Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/118] 6.1.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.13 release.
> There are 118 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 22 Feb 2023 13:35:35 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.13-rc1.gz
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
