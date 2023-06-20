Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 563311549D
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 17:08:50 +0000 (UTC)
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-66872d4a141so1517742b3a.1
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 10:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1687280929; x=1689872929;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=wFGdUhJIBvjZjZSPOJLH/5SirsIlZFmwYpBcX309B40=;
        b=KOr/w2LE0N+lCMF3SiWPHFIGKhNRgDIwIgVr++EtSOr/zcJTtOm8HemTs8EfdZHmDF
         7DcNWayUhu78jIwTwgvOjefkpit9nyPWFPB/Yf47V5V7f1Djgw/7oMdm04fbkLqT7FuJ
         lxMVY6ByRaP9IQoLPySikUf/XW5l3575AS0UvFSVqsU0soHamSRx8OqyBaZOk/2HJq+K
         AsbdkdFW4xtC3oiHa2wEnllSnwfyD9h/vnJ7TjRAaFrlP2K3eRDIa4UhY8PybY8spXYx
         M5tihhJpvKlkAuoJqV4uCUkdvvvuXYRViHivbRL7UcaEAIvN/yFkFoeI61O7BScyw4Dv
         H/4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687280929; x=1689872929;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wFGdUhJIBvjZjZSPOJLH/5SirsIlZFmwYpBcX309B40=;
        b=KTE4oC3hhRPtZiLUlP532LUYAse7j0XOBGOel8eWdjex0J2MDRdI6zxhj2P4KHo0tI
         HyH3lh/W+cB4wK806Y/JcN2e0W4XaZ4JHHrce+RBSQt4G8ATWAObzwEUueSCytwhkfLS
         ilarY2VEKW0wkq5VtmpahaIwP3Px9ddckq138GOLz5wFNGIcyD+udXSlyxX8Qps1qOa2
         Mj5oeSU3+KqoUnFyTWFaZVFchQousZ02h/T9OsxOwffRmzvhzHr6WR7pa1dU9s1qNvLZ
         w8E8YhDWYuvTXQ4QtgolFvr9//oV5jimoERpIZ5YS8CaVaXmPLZYyh/xpW5fcDeHXEou
         8g4g==
X-Gm-Message-State: AC+VfDy8sazweOmBq9JoBGmh2dp0ofwaXUcU6B8esysZBscv8+f5v24j
	L5WwdyknrKug4pu/vwNuRtbmdS4dVORPZb+mxlQ=
X-Google-Smtp-Source: ACHHUZ4/bWOvXG/fzvHtGlvOXO5Gtz33y3AeFhTF7rRywTl8W5azhHtx7zPZjjr/kbSPEcTz6LztSakmX4O5lUiqEho=
X-Received: by 2002:a05:6a00:3a24:b0:668:83b7:fd02 with SMTP id
 fj36-20020a056a003a2400b0066883b7fd02mr4524235pfb.31.1687280929614; Tue, 20
 Jun 2023 10:08:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230619102138.279161276@linuxfoundation.org>
In-Reply-To: <20230619102138.279161276@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 20 Jun 2023 10:08:38 -0700
Message-ID: <CAJq+SaCOKpEFEt7G2fxtV4ahX=7Zb2P=4CGEVEmtqvhgbED6sw@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/89] 5.10.185-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

>
> This is the start of the stable review cycle for the 5.10.185 release.
> There are 89 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.185-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
