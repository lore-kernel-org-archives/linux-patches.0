Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E1681FA4
	for <patches@lists.linux.dev>; Fri, 16 Dec 2022 10:21:12 +0000 (UTC)
Received: by mail-pg1-f169.google.com with SMTP id 82so1497539pgc.0
        for <patches@lists.linux.dev>; Fri, 16 Dec 2022 02:21:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=u5s2efA9OpsOkJAjhuuBC6txtEfx9OeQwLBhU20dKA0=;
        b=GU5K59LVv0g5znwPI2UdFduZID1wexyKsPHZIwlLgDN0Tn/2oA7P5MgUmvGXOhTXbo
         nTLRTT5X2hAZWT6+Z1xG+pz4hxAmyqkoZ+fnf8LDmuC9k/kh8g3kWHY3wPkvbt8Tj+bW
         80JZZZ13QCCcF4yocIs0I21+TW1AXTMBdmIHG4lZZxSweEhXGvJt+zY21RH5ICYl5sTs
         i51Js9RApQbG3+yNQk6JnRM4vC03L8V2wcj2HuDuf01hta+EtHLuuJV3yoCbhAslQZ17
         q3z1klErSDgupsCl1h18YSKlWNeeUM3Oze8rhT4kBGHOJgpoboizig9BWsHuy74RLxgy
         zJNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=u5s2efA9OpsOkJAjhuuBC6txtEfx9OeQwLBhU20dKA0=;
        b=WpcvlIq7SjRE9UbaMYMzbSqJ8nMmxuN+pHc1UQXzUbsbqU0HiJ2a2pcTk7By/gCFfS
         L/WL+l3X0iTcv11g7O83V3axs+O8cbVAv/05GoiJCDAAL7PLvpDSYZsqiK++kZkREzqB
         OCw7Kdb3MAiN1qUHUvrJ5wTQN9aC7qrAUFKommXXiy2+YjVHJ4CItBFngQcVjav/GgCX
         2C663AV6FYY1uJEpbZRA6uzwqDzvW60vK77FlTY6jXjtdjPjqeGwNkn+CKa2bJU7BnZI
         t4bDk+hIFJLtzknf9ZR6akD77UojTy5JU0NN6nCgU0tglQHnYPWrfOd94arPoFm8JKHv
         gdwA==
X-Gm-Message-State: ANoB5plzBHzs/ezl3kkzLTaVV12OV/Z+ylLojW7opi4ntT9U9X5Dz2+e
	1etnk1MGnhxMhlOdkVGO04O147wX0/xF7+FjLTc=
X-Google-Smtp-Source: AA0mqf59EK5o43aImON/i5f3koYcOESjaO9ughNFEWatMBlE5FkNjTHOk+vd7nxHBsWzEckowBSYmunDU8QO/cUy5W8=
X-Received: by 2002:a05:6a00:1d22:b0:577:16ac:8447 with SMTP id
 a34-20020a056a001d2200b0057716ac8447mr17087539pfx.56.1671186071940; Fri, 16
 Dec 2022 02:21:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221215172906.638553794@linuxfoundation.org>
In-Reply-To: <20221215172906.638553794@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Fri, 16 Dec 2022 02:21:01 -0800
Message-ID: <CAJq+SaDApqmwA4p3-yA6zyiwP-LHyKySS9mpXrFnndWw2RJ=ew@mail.gmail.com>
Subject: Re: [PATCH 5.10 00/15] 5.10.160-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

>
> This is the start of the stable review cycle for the 5.10.160 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 17 Dec 2022 17:28:57 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.160-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
