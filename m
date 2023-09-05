Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99DE9DF69
	for <patches@lists.linux.dev>; Tue,  5 Sep 2023 20:53:02 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-7950d0c85bbso22431039f.1
        for <patches@lists.linux.dev>; Tue, 05 Sep 2023 13:53:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1693947181; x=1694551981; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6lzSXNiIgkt0RVCFcTX8x1K9L6RQ1Rs9EBt4A42ozfk=;
        b=OGE3iIDg/QuWDjsUbO1+I8PclGmDAGU0TOXquoV4im5IwO+I8Tays1VHs6n6MNQwPO
         viGfNAFAOe/FKT5gsz5ATuujLUP8VS3ZarTLW80+CiriOuUMdE1Midhi172hano017mI
         h5PC8TYodN2Aqdb5dc/Y0VnH+6KLuGMbmVtcw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693947181; x=1694551981;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6lzSXNiIgkt0RVCFcTX8x1K9L6RQ1Rs9EBt4A42ozfk=;
        b=k10i8uj1I5V5I/7w1JoB1bgWK7BO0/Y0qTLgxBpgNmfM9isRhL3iMzo7Ooz91OqmHB
         4F+FWgdsDv9n59tXn0uCbzneJA/aGw4UVJ2shAcFq+4B0XVMH2a7xy0lslvNkyuMtOGg
         Dg+mZ3XQ+2nvTGL/E2ey3551qSQ74DLYCOJRDf51+xx2gL5A8Cjf1zN3ZSdGUbNRLdIr
         HiGFgC2TgktZiEEVCm1B8KP5jDBf5id8b7E0wwfS41Ui/W+6kwwPcgmAQxjHPYUzH524
         YYs7rwlBBGPglF4tCdfD4opTRsjM96YcoGYgfLeZ8xgNOiRI/TNd8ZRMqhWxw6+fwKib
         WXwQ==
X-Gm-Message-State: AOJu0YwqL9Bu91vSTHsRlcMhDjzoYXZ543vx+tROxyDiLUmsS2rajdCp
	6HaPOWy375kDL+4bLjjhQqCpag==
X-Google-Smtp-Source: AGHT+IETIvXknVtoBD5RJ1GF5BtEo4yZSv4IRdlZbL0D/WHeAnx8eXCUPaupMBCrwoCjkVAoQ4TZdQ==
X-Received: by 2002:a92:d952:0:b0:346:1919:7cb1 with SMTP id l18-20020a92d952000000b0034619197cb1mr13220494ilq.2.1693947181552;
        Tue, 05 Sep 2023 13:53:01 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id r6-20020a92c506000000b00348d652a6b4sm4342171ilg.48.2023.09.05.13.53.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Sep 2023 13:53:00 -0700 (PDT)
Message-ID: <f2a12e3f-9c82-90c4-829d-5b814cf6d449@linuxfoundation.org>
Date: Tue, 5 Sep 2023 14:52:59 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.5 00/34] 6.5.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230904182948.594404081@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230904182948.594404081@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/4/23 12:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.2 release.
> There are 34 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 06 Sep 2023 18:29:29 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
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
