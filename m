Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C1A2AB2F
	for <patches@lists.linux.dev>; Tue, 20 Jun 2023 21:05:23 +0000 (UTC)
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-77e3c55843cso38278039f.0
        for <patches@lists.linux.dev>; Tue, 20 Jun 2023 14:05:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1687295123; x=1689887123;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uaunI/80Lr5c/6cpZUQwWrbl0e18AfNucYFl8k8adXY=;
        b=eVLBt7sa2AqscCYtkHCn0ejkmn/J6wMN0J2fpY0kG9GMqES8FtI6tznQC5efCWKGqF
         eHot6FQ23ohxqfwW9RqQuUK9587cEOO8FY27zwsNYI1n+wTASbwXMiRrgzWabtiK3O++
         oICFkAIJbd80/44v6/wpZcwHSB0moJ1KytsXw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1687295123; x=1689887123;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uaunI/80Lr5c/6cpZUQwWrbl0e18AfNucYFl8k8adXY=;
        b=Nw2ltKFMM43ymnal4XLiGWwc0ZJ8k/P5OPnUuHvSu9eVoUNAxBI4JStEcALkr1+1c8
         gHbFPgHVuPXQ52WVFK5aVeUfpaSX+CqD3p6R3ClUQYHbZdFoB8HBpbmoOlSfsqE5DhzB
         x4HsraTqpBtXoXxsU+Uu0MejigOLYPBcg0alDDwzwt4IEc7lvq+0KWk6HflQW9LQsb9n
         VGNE4zNMhfYvZvaP2RUq7zeCnbV2LWpZlKzSWol6Jpb4VkajepU8hSGbhOsxMH3lfTby
         1xJlp2yYN0a0Ua01DuNvl/At420P/+qhpul5IfYUiW4H3vIL0O6qzdNzh9wvF56U7q6S
         33KA==
X-Gm-Message-State: AC+VfDwa7KRiQDrX6/JisenhI/12J/i/n/rgTLUNq02Se32a1GNsPY4V
	WY9ISE2nwdyBE5H+Hfm/OLrXUzCEMc8ecPhB/oQ=
X-Google-Smtp-Source: ACHHUZ4hcR63xRl9TDyH8gZxquZL08MuLMnqHhuiP7v1HGTXAVw6AScWkzPvl3nUGCeg4ux72atd1A==
X-Received: by 2002:a05:6602:3998:b0:780:a83a:7684 with SMTP id bw24-20020a056602399800b00780a83a7684mr2495810iob.2.1687295123060;
        Tue, 20 Jun 2023 14:05:23 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id a12-20020a056638018c00b0041f4bd6f285sm874213jaq.37.2023.06.20.14.05.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Jun 2023 14:05:22 -0700 (PDT)
Message-ID: <911a8d41-b52f-2471-8878-d6e5a4712bcc@linuxfoundation.org>
Date: Tue, 20 Jun 2023 15:05:22 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 4.19 00/49] 4.19.287-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230619102129.856988902@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230619102129.856988902@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/19/23 04:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.287 release.
> There are 49 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 21 Jun 2023 10:21:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.287-rc1.gz
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
