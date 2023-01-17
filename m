Received: from mail-pl1-f173.google.com (mail-pl1-f173.google.com [209.85.214.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C30C82906
	for <patches@lists.linux.dev>; Tue, 17 Jan 2023 14:19:48 +0000 (UTC)
Received: by mail-pl1-f173.google.com with SMTP id g23so18081497plq.12
        for <patches@lists.linux.dev>; Tue, 17 Jan 2023 06:19:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=l+gG5SAYt1RkPg1LOSIKLTdG82d5Mlvgl0CxibdSrVA=;
        b=M0DAL0eP+0MMc+Sj5+9iTxoAgGR6bc1hH4UJe9FbO7Bmk+MXfm+Ktp5JkAar2IfJ+E
         +zlTV5Nij1/bJg6nQptfUKvRurMn1QExlfXinu7oYcG+8XQZwpcJWJMjgwqErAVJ2Xif
         Fgg6q0JRqPUAkU5TsVucjEQBcR6jmkUz2CPsRJmNWioufTRr+bscrXidShQ9tmwd/bDc
         tPS7I/etd9so6t8DGBoT0x4Z60F4qplyNVXZ1klZgjCiX+cVEx73JQbIdxq/7ZSPE7D6
         x1udVIAfxDLur6x2DgZ+yP1NjpzZcTEp/AnNIaLq12mJlGUAEUSi0ReiS/cssVEBlV0L
         4HDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=l+gG5SAYt1RkPg1LOSIKLTdG82d5Mlvgl0CxibdSrVA=;
        b=DaOX6nv/Rpjus+lGNXfTm7NfpP9+m3ucHy5/FeN8/xb/Qpr37l5zqBAogEWxAL5xwD
         wZqXWdskyzJuNnR3lxYpwMopf1pohiSZKOFaEhCmQZXl63+YWE739paeOG6wVHL+654/
         Qc8GIe37F1YhhSQxo58VsR3Yo6H2t4lXVkvc+jzCKq1+eYai5/rwz6r4/xTXDbScquZT
         Id7BqPuKVVpTvmnbbrBjJSnsXg8ClMiqZY9VyYVIketfNIDvBe/AHOHExpznrGUhg5xS
         QIxw68sOpOKc3sjmSdRS1udGDHM2J2KijRPBzNJ7mozp7ihtEbUQbyghwukQwmPoAHoM
         hZsg==
X-Gm-Message-State: AFqh2kq466UFpFzEWmWUBu2l0zTbF6fwyWJU74JPuVHq9r1JGe8gQAtH
	48h7cpowM/Kfojc1lQz55XxnM2imnYv7o/FAGYY=
X-Google-Smtp-Source: AMrXdXs2NfXMWu0i7Gi5AloLWuLxgQ0AAJX8RPUvH+prS4pPWCHYgwdrlKbKN341M7bGjGiEOhZFmImG4rlv4cz39uw=
X-Received: by 2002:a17:902:d4cb:b0:194:87f2:3b5a with SMTP id
 o11-20020a170902d4cb00b0019487f23b5amr243227plg.52.1673965188113; Tue, 17 Jan
 2023 06:19:48 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230117124546.116438951@linuxfoundation.org>
In-Reply-To: <20230117124546.116438951@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 17 Jan 2023 06:19:37 -0800
Message-ID: <CAJq+SaBzukOtzmstnfSED1MOk8QyH_9wrmTZqvsL_1St-Vds2Q@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/176] 6.1.7-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.7 release.
> There are 176 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 19 Jan 2023 12:45:11 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.7-rc2.gz
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
