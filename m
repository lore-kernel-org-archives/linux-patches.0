Received: from mail-io1-f45.google.com (mail-io1-f45.google.com [209.85.166.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07C8B625
	for <patches@lists.linux.dev>; Tue, 15 Aug 2023 01:03:41 +0000 (UTC)
Received: by mail-io1-f45.google.com with SMTP id ca18e2360f4ac-7748ca56133so58580239f.0
        for <patches@lists.linux.dev>; Mon, 14 Aug 2023 18:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1692061421; x=1692666221;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Zf24qn986+3HODYb4D7dbEQc+CnKSZ5LVW4DefTNb54=;
        b=dswvIqwEJ+uQndBIdiZJZx44dP90/nfHjw9vK5bNSC9lVx/tSjJQSrzGV5gDYSlzlK
         mgTL6y0rjWziN8oiKbhFfq8Tx/EGmeUHJ/zgkpH6LmH8sqgs2DjPQjYWkO6AbfQLywfc
         XiS0/lDyOZ4jFkwceBgPSiqXIJb37lWnfT2ZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692061421; x=1692666221;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Zf24qn986+3HODYb4D7dbEQc+CnKSZ5LVW4DefTNb54=;
        b=No4pzZaWOMMKwBrTH0vhZMQ4bcjr5F9K4MYnXiJieWadncFOWRuHt9ugjgDFB0vBCm
         NH11D9/oguMpSXg3ccdi0oElCx8y3i3g/W79NMI7hJeg6qE86LBCMF7f77zuV558WAGW
         +541LBolVBvoZen9CICfJkTAgHHlSLPai7g/ruTuMaxa3O23yjcxzdDn3gDnH6+IwFpa
         MGua7wvqWO+Imwfxneg/sJ8jsROzafzWTnAzEzYnz3a+H93+LY1ftIOEIs/I9sVxXeVO
         AsUaLAggzNiSA4fCHp7o1G2gV+WWKuuMxY4R7+aReMx11U2klDTv8XYmGdkIzKUqz6jJ
         efQg==
X-Gm-Message-State: AOJu0YyyRrCtDV10XrKU3GwunyNCyEQmOztXrOEXrKVfzUR7dj5iYGaL
	ktvMQGX1TM6wJ06jo5dLj9CydA==
X-Google-Smtp-Source: AGHT+IFlStz432lwAjsuSr/+troe7G5Li7J95LcHwvH6pVQdhQSvB40tJvf/Q8ymE0iPVul6ltWuqA==
X-Received: by 2002:a05:6e02:105:b0:349:385e:287e with SMTP id t5-20020a056e02010500b00349385e287emr12041151ilm.1.1692061420997;
        Mon, 14 Aug 2023 18:03:40 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id b6-20020a92c846000000b00348c7617795sm3563764ilq.49.2023.08.14.18.03.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Aug 2023 18:03:40 -0700 (PDT)
Message-ID: <f4848ba1-39ac-5d1e-307f-1fba3ee3786d@linuxfoundation.org>
Date: Mon, 14 Aug 2023 19:03:39 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 4.19 00/33] 4.19.292-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230813211703.915807095@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230813211703.915807095@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/13/23 15:18, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.292 release.
> There are 33 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 15 Aug 2023 21:16:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.292-rc1.gz
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

