Received: from mail-pj1-f50.google.com (mail-pj1-f50.google.com [209.85.216.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17323256A
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 13:21:33 +0000 (UTC)
Received: by mail-pj1-f50.google.com with SMTP id x2-20020a17090a46c200b002295ca9855aso6160012pjg.2
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 05:21:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=XyysVZNRdlhZXXRBwjfaPZSitQ3Ii1qKei/kMDd/RTY=;
        b=D328E8IJUcmuTi+HvX7P0teTBwMSvKWOMzykD66qbZfFTux0EPcgxtgpjYPuvoZfvv
         wwV6Erx7V1Vmxo9rMeR8FKpEKlBqGpvtYx09ZJvRqrRTR1aB0zaz0TGpHIaMSYk2ub5B
         ulN6K6ZG+OHfniSBGTTXfhZGHcR9SEV5RyCv+R91o9i5eQ4K+b368ATPtuuxyVdHSo7m
         AQIqph8ZoE/0iJwofzUhXjJx4+8hidUaakpH7TtKN22lHkdWflQlb6li3gLLtM5AKvL5
         /RaQx2eThKF2ybVMfsXpzB6SVHMdvVXkwojYy4u+cgxjsGatsXyK6GMqwrmEbwTQtosV
         XJiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=XyysVZNRdlhZXXRBwjfaPZSitQ3Ii1qKei/kMDd/RTY=;
        b=gOkpqNHVPl7FAY7Dxa3gJkixEdJ/ZO4JvV0DrIBAOj0hK9Nij/lLdpyoHpajtx65LP
         fb4x+HsNc82MbjcyWioHgAHz9BYXjSlPWibs00/U6iHzmlwZ3CEVhX/2VIC9WeZJ1ZmL
         0TG0atBQpSzeNMt+EEEtJKFCuWYxGu3t2F/P36mJCSsSxPPkX5/TxDb9S1lvQ/xyyVKt
         17+1uqAfYbh72ktMPXNUaZHshbH/p+ABmc86guO8YbzEL/wAzcmjoytZvMhdovgK80q2
         WNMJLMq2ZY/xCEECKRcgggjc0lFmBTYPoWb81RBB2cM2Av/qnizdF6FjvZX+ByRBvMZ/
         uSQw==
X-Gm-Message-State: AFqh2ko0t3McAQZWOL4eyjIRe4DiQDWSwb8JPCblW1/kbpGbORx8AA+1
	XpUAIhhzaSiCmzb+fJyvtK6vuIfLtTmA/xcW2bk=
X-Google-Smtp-Source: AMrXdXsyOfi65HllV91zUscNWocOYNoKuUEONuiqoyDqpXuhRXFlaiLNRj/nePP0DhG0hhbEkX0N1axrfQBQ8PuOACU=
X-Received: by 2002:a17:902:e043:b0:192:c6ad:4c35 with SMTP id
 x3-20020a170902e04300b00192c6ad4c35mr229368plx.15.1673961692342; Tue, 17 Jan
 2023 05:21:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230116154803.321528435@linuxfoundation.org>
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 17 Jan 2023 05:21:21 -0800
Message-ID: <CAJq+SaDw751Z5x0OLZGQdoCCwsWDiZuMdRM4yDzetDkZ=NgHYQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/183] 6.1.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.7 release.
> There are 183 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed, 18 Jan 2023 15:47:28 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.7-rc1.gz
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
