Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE4423BC
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 16:01:07 +0000 (UTC)
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-34e1757fe8fso572685ab.0
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 09:01:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1693584066; x=1694188866; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WCsm7PXzMA4syA8CcbnCY0pyK9en/7AsjazHCOViui8=;
        b=EqS1UzYc6Tl4n1DWa/l0PhzgRxAK0ZROXUok4WTKy3QxBRr+8B9t8kw+MZhUy0NZY5
         CegScatJ2Adr9aC7OjTvIxen+QQIleRyjdd9kWIhquUR7J9ez58teUMgaK0Pzsyk2F5j
         RxDbjCQ9yNNvDd7kt9Iw4JtP2MT8YznuC4YrM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693584066; x=1694188866;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WCsm7PXzMA4syA8CcbnCY0pyK9en/7AsjazHCOViui8=;
        b=SjRFVaw63ZYAAJWqZqpn/IlUol/horu+SdgBfO06mnyZ0mr50MEwz0/ICuTfgsw/NJ
         uJWxArRsXppqxhueMoLCwd69phdxpHbTyjI9ZzLrgzw+gNYarFOvBPDYwRq78/jxrmvx
         sh9nk5clz8ugUcG+l9ctKFR3WDCSBf1vkdalwMJ+wCp3ZvqckdAAR62uYjVnPVPmXymI
         jGPs++AX3BQQn8PL7lwzEYIH3XgYIgY5u851huv/YPrwregeTGuhVoXCkB15SH4Pc+eU
         Q3KkM6K05aq4Y4SPx73/XDH3q7JGF0LvPq2REoe1eQw1bN5oDObgcxHip9xDVRjxNcQ5
         3dPA==
X-Gm-Message-State: AOJu0Yw1F5YNBn5YfWd3L+MKqQqbo5HZ0NCniKcoVggm9LP25QMGV2Jg
	Gu6AztQq92aMZrd2g9QZ/NwP9Q==
X-Google-Smtp-Source: AGHT+IECl/yIAZ8YZTPgtDkBe82ANt3cbAnEAFiOnhj4JTckTUTkOO2xqK/EcdV8L56q0eNCdCsdHw==
X-Received: by 2002:a05:6602:3886:b0:792:6be4:3dcb with SMTP id br6-20020a056602388600b007926be43dcbmr2833593iob.2.1693584066384;
        Fri, 01 Sep 2023 09:01:06 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id ge12-20020a056638680c00b004312e5c9b0dsm1097780jab.139.2023.09.01.09.01.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Sep 2023 09:01:05 -0700 (PDT)
Message-ID: <73970980-0076-292e-67d3-4563fc0d53ab@linuxfoundation.org>
Date: Fri, 1 Sep 2023 10:01:03 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 4.19 0/1] 4.19.294-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230831110828.433348914@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230831110828.433348914@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/23 05:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.294 release.
> There are 1 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.294-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-4.19.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
