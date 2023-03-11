Received: from mail-il1-f182.google.com (mail-il1-f182.google.com [209.85.166.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F70EA1
	for <patches@lists.linux.dev>; Sat, 11 Mar 2023 01:58:04 +0000 (UTC)
Received: by mail-il1-f182.google.com with SMTP id l2so4042298ilg.7
        for <patches@lists.linux.dev>; Fri, 10 Mar 2023 17:58:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1678499883;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Z+H3HCPd5E7nw2uSbGAh1Pef1+Hjjcqki3cPhopzRmk=;
        b=GEpKUd4vAMIPV3Z0JM2tp18C5r02HPi8MM+cCth7D16z6W76CIWTdiLz2vo+jACT9x
         9ZbJWzVrupD6lnsDPYgBBBnGmoKb1eFMQZmy/kl5C4yuC3+c2TWuN4qYeND0ebQ6aGoM
         sf/dBWX8MXoCFxcN/hY19EAQkSU1aI2D9bRKM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678499883;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Z+H3HCPd5E7nw2uSbGAh1Pef1+Hjjcqki3cPhopzRmk=;
        b=4zHsErfPTalKXFHsoValEgPE2VBI0TinsqEh+wAa/ZZHWbytiuvGSWbANcvWlAqsgI
         iRawxJplrsVkvYlCr+nswBErNtah+s1Cok6Bj2RncKy/96oOdzp1HQyqGW5X32v3dCgv
         l/TPqVaSlTzu6wwRQAzuDXypkD/vGw+8D9Y4ibTHx0ARy1slvF9m5aa9PrMICjFTz1jn
         qblnZ6ME2+hZu0wUAgu21s50Q/0cxzbxS6i8452O/f/5EmLgm/D0ZhqD2NMbbJkkfkOQ
         OatAfdHaBXgbXdza6NC9fW+fgUDWSREWjYbPg0F3mtrLSY4NBR+pK/dQS1SfFTEHgy2F
         IxHw==
X-Gm-Message-State: AO0yUKVCqaByoLjoEio9VlVscmJXBLYxtiZN0AO/1vo8MfDRDvh8Lp+K
	kY1ZhfEX/kQmv6MU1j0gzwuvfw==
X-Google-Smtp-Source: AK7set9ACxP6ymCmjEt4UqUFQ8WeykznCyv9URI3xbgqRkOk94wMVPqR7lLxWMl5jRyY9hhM4VNsng==
X-Received: by 2002:a05:6e02:1d16:b0:317:2f8d:528f with SMTP id i22-20020a056e021d1600b003172f8d528fmr3214658ila.2.1678499883085;
        Fri, 10 Mar 2023 17:58:03 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id c15-20020a92d3cf000000b0031df789038dsm472473ilh.7.2023.03.10.17.58.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 10 Mar 2023 17:58:02 -0800 (PST)
Message-ID: <3e59f7b6-9763-3caa-557a-b1dd3afbf244@linuxfoundation.org>
Date: Fri, 10 Mar 2023 18:58:00 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 000/211] 6.2.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230310133718.689332661@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230310133718.689332661@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/10/23 06:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.4 release.
> There are 211 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 12 Mar 2023 13:36:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.2.y
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
