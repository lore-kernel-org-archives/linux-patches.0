Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFFFA364
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 01:57:55 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id h206so257024iof.10
        for <patches@lists.linux.dev>; Wed, 09 Nov 2022 17:57:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RVy4dHcr+3ctZbV++kQ+x2sxq+u+6c8Ljhwdo5Gph+o=;
        b=V54ScCv6iT/vmqAnORNHusYQVooKtM0NdwmOWzMBLGp5BODUbRmFJ0IqP9fu6Rxf1M
         tGbQZ0/XN1fQuYj4crq4yK4m/dDlID5UDTy7Bqc6IySwjbBBu4NvirICBn4+5fHpqogy
         r2L+ewgLNAMUcy7raSJT+wg3u0matJ+Qj4lXw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RVy4dHcr+3ctZbV++kQ+x2sxq+u+6c8Ljhwdo5Gph+o=;
        b=YuKkgT8Jt9ZS17v9LRY8HxTIJB0FXTieXnAnbc9NSbnXtRkDaC2qFlVIB9liWBz4la
         W6fSN1Mkpa+PA/6D2XwnwZEpOf2IuTgPNEhxE/cg0NxmvH034oLH/roDQ8sRM4E0eI2p
         bnMWzpqVnqIYljol+fmJxEeGvK+URhrmL8A1HBucHfKqSnwMIJhyxBsQlwlBP2qfWt/m
         byiKLyElMCeJeJJa3dKotT+AQSHmIL9HIhoOTM6YXn7gTAG33pE1sxiAiuOE0I6UWYZX
         C0E6QHKndi0z3iX6xGsQXV+l7oO4AUz8+ddZSfl2HXGbE3l6ZgiPhnKNXXA4lKWVXsSB
         CcfQ==
X-Gm-Message-State: ACrzQf1nyVoPrw6M/zqCbtY1c2kpbmvsI6FP/Ht0aaN0TGV4Y4L5+3Te
	tUd4qqOFpdlmdv0GxOmJeYOV3g==
X-Google-Smtp-Source: AMsMyM5ilNKZN2ViiC8a5bHibrF/afIqpOauFHiW67ALGdURC06ZZ6O2PScynkQXeUUesfmRBqxXDg==
X-Received: by 2002:a02:6d61:0:b0:375:660c:2c78 with SMTP id e33-20020a026d61000000b00375660c2c78mr28137761jaf.193.1668045474756;
        Wed, 09 Nov 2022 17:57:54 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id i5-20020a02cc45000000b003720db763bbsm5332873jaq.106.2022.11.09.17.57.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 17:57:54 -0800 (PST)
Message-ID: <a59aba7b-8602-84c5-2caf-1b1b7f600617@linuxfoundation.org>
Date: Wed, 9 Nov 2022 18:57:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 4.19 00/48] 4.19.265-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20221108133329.533809494@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/8/22 06:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.265 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Nov 2022 13:33:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.265-rc1.gz
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
