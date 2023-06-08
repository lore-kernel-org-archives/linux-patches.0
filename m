Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F73622
	for <patches@lists.linux.dev>; Thu,  8 Jun 2023 01:20:20 +0000 (UTC)
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-338bd590bc1so3406035ab.1
        for <patches@lists.linux.dev>; Wed, 07 Jun 2023 18:20:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1686187220; x=1688779220;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/ztIMjiY1892+uWC+MiOMXc3d3Q0L0tPjie1ITuSUPk=;
        b=cS1oyTIu1iEoMyDNP1M4EtW40MAfhRyvTeMko0nIXLIDFIjgf2I1Il936iRHzEDiS+
         qcLiC985xeiz24VCft/PGoqxcIHck1RHIR9xAHo2+mdQ6swmf19Zb4qFJ6PrKKRED60t
         tdnptwJBthWqJtbfoFQ4TH6wCBCgXpqvw9rqo=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686187220; x=1688779220;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=/ztIMjiY1892+uWC+MiOMXc3d3Q0L0tPjie1ITuSUPk=;
        b=YS6iLe+wXQHyD84mXfQ8b0w+ckPWQLjVPpYM1Ai1p7Y+TsPG7ryx585mikgaS8ZVKZ
         ixxeZovQUA5RCd32CPhVZDHzxIEiRV1q2Gvj4AwybaHk8QsWmPkLXJieGSfn0cteYGTG
         YGn70mFBVLdLTBQq2rzSVVEzy4fX5lQ/m+PZB4gKuk4LdITs6WiXC0bB8j4P1ozB08cQ
         2zgYV2ZkLiphDnMcsfI+S3SkiZGKFPDeMJWKPIxjJYDhvkJsJn/tDza+Z02sV1XZjp7i
         FyRMIQQ/uEVtenvtemVbuZTQpJ+JWjkLJf+NkssxNaGkDd/GZiixVnjI7LWb7rtdP89N
         tlBw==
X-Gm-Message-State: AC+VfDx52cIbiWczdY9p7aM2Rq3PPz5er/YD3dNSBpD+0gi4aQhLty0p
	O0PyBwHGRxwfomUfznpLl7kGig==
X-Google-Smtp-Source: ACHHUZ777zOZxFcl7hbAZzXrEVfFIDPhy3HgFhE84piCrixW1K29KA/1MxoF4PYQeD5fgQZ9PNBYnw==
X-Received: by 2002:a6b:5f1c:0:b0:77a:b7b7:acfc with SMTP id t28-20020a6b5f1c000000b0077ab7b7acfcmr2998161iob.1.1686187219862;
        Wed, 07 Jun 2023 18:20:19 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i3-20020a02c603000000b0041a9022c3dasm3726523jan.118.2023.06.07.18.20.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 07 Jun 2023 18:20:19 -0700 (PDT)
Message-ID: <f531db6b-d8a7-031b-d457-2cffc41c7857@linuxfoundation.org>
Date: Wed, 7 Jun 2023 19:20:18 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.0
Subject: Re: [PATCH 6.3 000/286] 6.3.7-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/7/23 14:11, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.3.7 release.
> There are 286 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 09 Jun 2023 20:07:31 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.3.7-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.3.y
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

