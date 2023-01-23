Received: from mail-qt1-f182.google.com (mail-qt1-f182.google.com [209.85.160.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457DC7C
	for <patches@lists.linux.dev>; Mon, 23 Jan 2023 20:21:23 +0000 (UTC)
Received: by mail-qt1-f182.google.com with SMTP id g16so9051909qtu.2
        for <patches@lists.linux.dev>; Mon, 23 Jan 2023 12:21:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9kk2z4hYZcGz4xbYVx4jjMxTltcKZUPsKwdwkImhZVc=;
        b=aOpM6krJk1eKUQrl7/wH4IBG62B+p1DdX9FMShdl79bQwKR9B54w47EmLxGOZ38dhg
         FWatn0nK0lW1ZZ9GFMejd5XIvACKh/ozIHQklRf1rubGP23rrE9JYMaaf6NtVyTIq8/1
         uiISkKMbDMd0P9vqWDY1F+7ZKet5aqQbsRGjExzBy++akH9boTpgYh2TGoPAqHaEy7kp
         9RM0Zt011917xnrpQRP8PHDm/DLn3LGyh5gWL4VLeHpFe+SugWKx9VJ0KomHznuwMtpZ
         9TN7Nl7IGBpi3hOlG0mXz4P2ttedpRS8PJ2ENZjKxF/grsZthqRSj1pKQUWHO8m3d/2b
         cYaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9kk2z4hYZcGz4xbYVx4jjMxTltcKZUPsKwdwkImhZVc=;
        b=PHg4t9AqV/viCjS2+vZZBBWjAMiFdKW3L+RGSeiM4Ax715LVT/z+PYOHjAZR2OcYvu
         G0kVEDub/cnMU4y+4yqtcWE8JnRddAsPAOAhr1vvYrkrhGimiMD7njXdKf+5CTBE3eDc
         kJCaBF3Agz8dwVMMhRQL6e0+IYtfZinUB+xRIbWT3LoJdhsCNJ61GKQgkAqezb/pbpIx
         WiycGtl8Xl4U4jLG8qmkbmx6FDPc08rf+ljQMcblIL+qoQH7Wq0K+Rd1Gr6Lky3WzylI
         gMeRoC+hbgX/4qUFq38LPFucj0clGAruZ/Z+DLSqGJM30aoXFl2javTyU8ZPidXkvwSl
         Cbcg==
X-Gm-Message-State: AFqh2kr5HL1PAmODfuHwAPuxjInYFcZxJR50z+C1os7AUxMIGYECJtP2
	EQ9WfGac5arwlQ6qUVI1aR3i1DkLkhs=
X-Google-Smtp-Source: AMrXdXv+q+08MtyhJXj0L1iFIawGjee2OPNdkTc9+AyVhhMxIBbLvz5ALoGv6SM8oKe+xYSIjOUBGg==
X-Received: by 2002:ac8:6659:0:b0:3ad:f2e1:64e4 with SMTP id j25-20020ac86659000000b003adf2e164e4mr31226674qtp.12.1674505282054;
        Mon, 23 Jan 2023 12:21:22 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d25-20020ac85459000000b003b630456b8fsm12539830qtq.89.2023.01.23.12.21.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Jan 2023 12:21:21 -0800 (PST)
Message-ID: <f00ad162-743a-1ceb-d19f-d89738d1ad9e@gmail.com>
Date: Mon, 23 Jan 2023 12:20:53 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.1 000/188] 6.1.8-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de
References: <20230123094931.568794202@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20230123094931.568794202@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/23/23 01:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.8 release.
> There are 188 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Jan 2023 09:48:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.8-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit, build tested on BMIPS_GENERIC:

Tested-by: Florian Fainelli <f.fainelli@gmail.com>
--
Florian

