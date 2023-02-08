Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51E4F33C9
	for <patches@lists.linux.dev>; Wed,  8 Feb 2023 17:05:55 +0000 (UTC)
Received: by mail-pg1-f179.google.com with SMTP id x10so2049374pgx.3
        for <patches@lists.linux.dev>; Wed, 08 Feb 2023 09:05:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=NtgcvPhFKAP4Fee6Luz9mWtOfLHAuno8WLgBdCIQtz8=;
        b=JEBlsLZLFhIbkuWyXAdB6SBNj9oUPK5ILJwHvgWZ4kRHfSm+JT2iQdipEfuBubRt1n
         tF8HnPRhxrbiXLPuLBJabjpJhzTWAKyRzPI+4qnWJOURDkHsJQiZIfqRBfMDeCz/LOfF
         FMqfwCncduLlAvCDqJO/mfl6H14BNXsikl3A04xmuk9pX21bvXz8diMakla6A5bkPziX
         lUmqwNNakv+nBu+swpwZSoXtdhc5Au6NZmgy4JWNtBuZOF+hgZcg8VYeyGRrgf0+li+R
         SrncsVCCRL3r1928CByBG3aFwDtemQ05aHBgogqH8b7zloxoP6Bk8jvhO4SbFHTJDdQS
         iEvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=NtgcvPhFKAP4Fee6Luz9mWtOfLHAuno8WLgBdCIQtz8=;
        b=d9SRfZ9GuPSKB/pJi/lydc/QC/tAe2Ii/xhAkIeFHTKqzE+TQLXNyYWych70AG6ZxF
         TPG5cW1gyvj7Pq9pXRuncb5v1d6GwaF7jPu5pX2Qp8byFExGu5DxVNhDDrFpBWQ7VJIp
         OLld6lD+upTtZLpnKWvfgXjhIaBkRFDEduckUq3gqPkTb23rIePw6kXtv5Bk97NeOvy/
         2dRagoEHSQxEeALX/vC1dQg6M0CO7zG5Pi3OseVxVEsrnCfFYbdTxKGIjYOkWL36X/N5
         E5ko4iJ3CR7Gvuy+7WB/+/yK8taFvV3qsb+BLo9TCZ80ksm3KiMezYxS+0P3f1c6+c73
         ryHg==
X-Gm-Message-State: AO0yUKXoJkl2nldDFkzwNEn4OW1W98+uEv9qwPZ9WMM9uq9DrcPxEJK/
	tRwfeG5ICDuf0IDor9Jaw/HYHHRsr66pqoCp1uI=
X-Google-Smtp-Source: AK7set+OevTax1m/xAS2B7en2U+1YOEHnIsELnkB1bu3keFDXH4nPGm41hmXJX57cQ6mAt2eY7s0AzklxdijXEzxb5A=
X-Received: by 2002:a62:1988:0:b0:593:ccf0:a288 with SMTP id
 130-20020a621988000000b00593ccf0a288mr1718573pfz.13.1675875954760; Wed, 08
 Feb 2023 09:05:54 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230207125634.292109991@linuxfoundation.org>
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Wed, 8 Feb 2023 09:05:43 -0800
Message-ID: <CAJq+SaB5pmW0o5SNJg_xw93emB7ZtYYLSxjjxtJ9eRQU5KTZDQ@mail.gmail.com>
Subject: Re: [PATCH 6.1 000/208] 6.1.11-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 6.1.11 release.
> There are 208 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu, 09 Feb 2023 12:55:54 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.11-rc1.gz
> or in the git tree and branch at:
>         git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
>
> thanks,
>
> greg k-h

Compiled and booted on my x86_64 and ARM64 test systems. No errors or
regressions.

Tested-by: Allen Pais <apais@linux.microsoft.com>

Thanks.
