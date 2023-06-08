Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC46DA4A
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 01:29:58 +0000 (UTC)
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-19f36a8ac3bso19689fac.1
        for <patches@lists.linux.dev>; Wed, 07 Jun 2023 18:29:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1686187798; x=1688779798;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q9wnjGe5UURJo7WWA04Rwg6yssO99190s+RUQSR8wj0=;
        b=d0sDMlHxot8jX1BOZfMCdSShbw6aKymnJQ2DEioJuL8ZGkNj/mcM2tqtmTlKZJnPeS
         4s1ddrkzMf7EDE/O6rj2OR/iNV8P2gcYHdbrQTfZkJg9IezU/p4scbIFXQzB94eFPHWB
         B7yd9k6wLhKbBm30dknQ8fgcMGou2Soou2Utk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686187798; x=1688779798;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Q9wnjGe5UURJo7WWA04Rwg6yssO99190s+RUQSR8wj0=;
        b=HDKwfss+1kSxzarIwc03xhFOjuOlS5nsh61DWPk0LidUGaAMdcQJS7aBtzfRSWZ3IH
         5EHYVOkHr12kmY0RZFwEgEUOBOg7aFLeSHpZiUUWsySPG20GfuWRopPS11wcjqaRINR1
         aCY/IQVDP62X/QabEXixxGszb//C2RouaW4E21tXO6YwCHJ6k5ZZfOhSCq4d2L2+DNtD
         AV9bXz55D3TY+nyl7PbBSZxflHrq3Q+A6S/fyQxUQgHPShmbllX2bYo+XxnZ7mdRdma+
         FR7xp/76f9QfueB2SkqicQ/gjZXCe56WpuDZdR9oU3wjmmHDwP//jabPJT6Sh3Sft8Hf
         LZEA==
X-Gm-Message-State: AC+VfDzLxZ16lNIk1GbS2RkAsH8ax8vi90h57Z3ucRQLyvav/kSlTKlj
	TcHR6i34dZRvSZsPnjRIozlLBA==
X-Google-Smtp-Source: ACHHUZ4Wk8tfXecvJKKETcV+6pvRSLdbTHgMZoxgrP4KT1zfyPOL324JtwfpBssrGDS76bzJtDJ4AQ==
X-Received: by 2002:aca:a996:0:b0:397:f167:e3cb with SMTP id s144-20020acaa996000000b00397f167e3cbmr2073040oie.3.1686187797773;
        Wed, 07 Jun 2023 18:29:57 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id l9-20020a02a889000000b0041631393ac9sm3950216jam.18.2023.06.07.18.29.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 18:29:57 -0700 (PDT)
Message-ID: <2731b2fc-f40e-2551-f463-b3ea2c5d0308@linuxfoundation.org>
Date: Wed, 7 Jun 2023 19:29:56 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 4.19 00/88] 4.19.285-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230607200854.030202132@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230607200854.030202132@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/23 14:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.285 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.285-rc1.gz
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
