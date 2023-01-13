Received: from mail-pj1-f42.google.com (mail-pj1-f42.google.com [209.85.216.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F7FEAD4A
	for <patches@lists.linux.dev>; Fri, 13 Jan 2023 18:05:50 +0000 (UTC)
Received: by mail-pj1-f42.google.com with SMTP id m7-20020a17090a730700b00225ebb9cd01so27739578pjk.3
        for <patches@lists.linux.dev>; Fri, 13 Jan 2023 10:05:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=M7NMAvip3vfz223F9hHO3sbLI85Qz2jNvsvM/QRqJNU=;
        b=iqHyBtfue4/l/adXUxuM1ma0e2zNIFivmoKfdBUu8DuvMIBMK4RQH568rclP36h571
         xbUd69mCVySJwkJuap54Fm5zUymVXHEYFEsgDoDWKpMUwt/YZ3haOY1FsU41hp24vwOn
         LgFLq1ApaifjvcaPbJeAH5wA124yz5AcDlQ48eX1HKrvZK/Rahmpj5vIC98T4T4n/558
         vpRaH+GVk2qVrB8mXcOdiLonIrQ3PPJpkZzdNCtNXCIPZhQ4y+gd312MF6JHYrBblPdH
         4Cpwt2EWLnJtBnoA6P2XBoXRDIiHDb6pFudSObGNuIuYB2GPm1Fjw4yf/8X6083sLrh9
         m0xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=M7NMAvip3vfz223F9hHO3sbLI85Qz2jNvsvM/QRqJNU=;
        b=mGBK99QvewpWF4olEbDkNQuh8i2RTXwTc9NkvTlhInYGeF78Vhgc+wFb8mZ3pN+UoS
         EHmtIWXXtsbAKWfjVJu2pMOqtz4I6K4gCO5zmayMyny3Ao/YAAWE5JxZXfZArVPl5ssv
         iChDfWRKc9Z1mjYPxTLFPFgK1jYUhB1Ngp6E+LIlJViG6Lkh8+xmKjiBiA0OXBW/rvtU
         wLQ32k+DvM5ibYpCbYJOOolew4aERFUj3KCspJTbJ1BiXG2nsGZxKwow2enLVW9KC2NA
         gcxkxnsq7enCiN1OABJmz3e4ENRk5GuddchU504taWlXTxdf6yyS0N/khW2BWXngqq3M
         9FLA==
X-Gm-Message-State: AFqh2kqrs2mjokicSEqMBl+WKuuOjo+1KKUDh/uOtRJKV5pc9EyKBP9u
	BIr6jxKJkPKobB3I3WUWINynSb7DWVey0fcuLn0=
X-Google-Smtp-Source: AMrXdXvTz/OR/mjkEDIh1uXTetfqAEHYND8ZDBSaBkZQnGWp+cLVTgiovs6DZV4YTmL+MF8tCi5WLKHNuqd/PVImRZE=
X-Received: by 2002:a17:90a:1a13:b0:229:3009:5233 with SMTP id
 19-20020a17090a1a1300b0022930095233mr223463pjk.213.1673633149684; Fri, 13 Jan
 2023 10:05:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20230112135524.143670746@linuxfoundation.org>
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
From: Allen Pais <stable.kernel.dev@gmail.com>
Date: Fri, 13 Jan 2023 10:05:38 -0800
Message-ID: <CAJq+SaBg0D=rFPwG=FqPE-F-p8ujiAX7Jt+vJb7HjeLPQBfQnQ@mail.gmail.com>
Subject: Re: [PATCH 5.10 000/783] 5.10.163-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org, patches@lists.linux.dev, 
	linux-kernel@vger.kernel.org, torvalds@linux-foundation.org, 
	akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org, 
	patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de, 
	jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, 
	srw@sladewatkins.net, rwarsow@gmx.de
Content-Type: text/plain; charset="UTF-8"

> This is the start of the stable review cycle for the 5.10.163 release.
> There are 783 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat, 14 Jan 2023 13:53:18 +0000.
> Anything received after that time might be too late.
>
> The whole patch series can be found in one patch at:
>         https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.163-rc1.gz
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
