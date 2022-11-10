Received: from mail-il1-f181.google.com (mail-il1-f181.google.com [209.85.166.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC1B364
	for <patches@lists.linux.dev>; Thu, 10 Nov 2022 01:53:10 +0000 (UTC)
Received: by mail-il1-f181.google.com with SMTP id i5so351633ilc.12
        for <patches@lists.linux.dev>; Wed, 09 Nov 2022 17:53:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yC4dnHY7IX8JIC8XVQZbHumkUsZcQ/kWMRWgfr+JpBc=;
        b=cPu+0IEV9d0/djuPjK0FdyVGoNNNd5l0fDueRZ2ZuMZUktABBeyR+AM7VzWDbIN/os
         7htA7QbLFMA/m8eJr9eeYwvKnIZ3z2Cdah5aa/rAnCZ0WXgIdMgtTU1iGmrTS8nscfm9
         o3Q97lu1YnFe0o9Xs3kcxPq1vcbUA3hL5tIe8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=yC4dnHY7IX8JIC8XVQZbHumkUsZcQ/kWMRWgfr+JpBc=;
        b=XbayrhlS2Pqm9Hn0oLbQaY5R6CQ+ZfPAxDq+Jffyc74hnUTNKimqZkuTjj23fPl7RZ
         iJwdh19bDtbvKS+Wsjf6mLXpv2dBLDxKiKf8jdAw+GNCUQJfeI+3bX19JlMekPPrTNX+
         8gNOW1IBKDJMYA2tfwFktSurIhWLLWwA7VeOHBdwbe9rKSEKbA3ny9KuFGXhFPJNIPuy
         6yxH9ygHP6sG7/h5X+jaU+ub1m8dUvlLxrYnrOpu8qZk6B2DwPsylA4eJm6Xjg/PVl7m
         MNs7OGEEfO1fawfyl1uWfImAf+3OXD/FAwU2F+4fQkVM96TCGyeb71wUQwUmlZD092BH
         2cKg==
X-Gm-Message-State: ACrzQf1DHz7JLIgP5rfTunq7B6+9fxmaLpMlLotGnskpmCdLhcsbAW3s
	8kkPYePjw4LdWLRSGeTDc16rZg==
X-Google-Smtp-Source: AMsMyM5tS49qktlapJt5vQ4mFB0UbdrVhfHSaPbzXiuGVqR+4AlIi2XLTYN6sOTOsNOqSqYisyJ4aA==
X-Received: by 2002:a92:8e0c:0:b0:2ff:c5c8:792f with SMTP id c12-20020a928e0c000000b002ffc5c8792fmr32280658ild.313.1668045189839;
        Wed, 09 Nov 2022 17:53:09 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id ck22-20020a0566383f1600b003636c5dcf29sm5235167jab.176.2022.11.09.17.53.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 09 Nov 2022 17:53:09 -0800 (PST)
Message-ID: <ef6bf02f-f0e6-fbc1-ea95-39a097974c2d@linuxfoundation.org>
Date: Wed, 9 Nov 2022 18:53:08 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.2
Subject: Re: [PATCH 5.10 000/117] 5.10.154-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20221109082223.141145957@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20221109082223.141145957@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/9/22 01:26, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.154 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 11 Nov 2022 08:21:58 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.154-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
