Received: from mail-pf1-f175.google.com (mail-pf1-f175.google.com [209.85.210.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 296EB2F22
	for <patches@lists.linux.dev>; Tue,  6 Dec 2022 23:44:14 +0000 (UTC)
Received: by mail-pf1-f175.google.com with SMTP id n3so11750255pfq.10
        for <patches@lists.linux.dev>; Tue, 06 Dec 2022 15:44:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ZLj6FO6Z4ww2omFd1kn1UspeQgtvv8OxuT7l+R9qe3w=;
        b=m0BGW15E4sHqmyn5sz3zzu0YEs8GVqOArKugrcw9QkYqFP4gPLpUc4S2X2zEZ8XgTj
         gAv6HET91FT/S6z/ktCof+Kso3s1r1w7pVFEGOwK+1p1LKx4KLsyY/dmhylObzzdkH0o
         r8Uu52XOHnrbDn3Yw/pL2Zd6GG6w7208Ds4ZpCAm3DBeZipKz+PkoMG3XHQS1/eiyvBh
         Zv5NoTvm+EuQxu/h9f9urBsEi5Hwh51hbNledA/CBMVHmDt991OIE8SIDHsclo7S+7oR
         mI7HQZRe0DjdckkUEf/2egNhtelgDSgbe9nvQZTxgU4TCl3jIPOnEoJT3SqQ7EsXwYxG
         rFHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZLj6FO6Z4ww2omFd1kn1UspeQgtvv8OxuT7l+R9qe3w=;
        b=JF5cOdeP21O6HVMp/DsA+JWLguH0TCDqWSY04wmg5jlxTlqcGmHnHbrxxkbOUw1iiN
         JfLpm+R/1gI0k+MCG5ITpC8fJtDHYs7onw9VTtAj9dAKFcU1WLsA7KOGErs+VLlJhcB8
         sd/08yVfawwub+VS9T2FSVF8dhW0kUkTwXmfPd44aMwO8x/j6yo7DBUAR5dnrUoEFPQ5
         cUgP1PsnbxCrAYVv98COWAaOSDN48QGapaCqV67M3FRs6MA5payvOpk/B1aib7N8mNv4
         wieA7SZ2bJv997UZkzsn0pq+sOE2pYDQrfXOORaLDyY8jJFQmqCRoY5VqzUkkrV2+4Xh
         wjDA==
X-Gm-Message-State: ANoB5pm597r1SNjRmOTFj9gn5w+qgCuwllAtAzTEd24Sc5aNpXkmMfLi
	yMwaMWgxmq7UED50BKRz+oJpnETHyNfQyV0REtn0CyMcbyY=
X-Google-Smtp-Source: AA0mqf4Od+ktH+6qycNy0wKHzZi3kph1ACv4NO0bywRiejqCAHblHR8ALWi8UtF/Fenmf/ulepYQE6OYhGpBvPYp6Bw=
X-Received: by 2002:a63:ff62:0:b0:476:898c:ded8 with SMTP id
 s34-20020a63ff62000000b00476898cded8mr71448926pgk.251.1670370253608; Tue, 06
 Dec 2022 15:44:13 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20221206124054.310184563@linuxfoundation.org>
In-Reply-To: <20221206124054.310184563@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Tue, 6 Dec 2022 15:44:02 -0800
Message-ID: <CAJq+SaCAedOkQfYQu7DXZC0AvXx2WYcqBJJbasNVB+-Wiv+Pag@mail.gmail.com>
Subject: Re: [PATCH 5.4 000/157] 5.4.226-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.4.226 release.
> There are 157 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 08 Dec 2022 12:40:31 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.226-rc2.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
