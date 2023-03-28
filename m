Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A46E2F2A
	for <patches@lists.linux.dev>; Tue, 28 Mar 2023 21:06:56 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-7585535bd79so8004739f.0
        for <patches@lists.linux.dev>; Tue, 28 Mar 2023 14:06:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1680037615;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hanuyFiFhVc/3RlCbpgD6fgmr+rE2YPGOnPcwJgKGQ0=;
        b=LYeEAX/3D65jXOQjO9a4EZnrh4gNd9cqsx7Z9HeeHrCaYw/KDOSjx5JiZDr6BlBmuf
         JJ6Qt/QFydNGJykAO4T9vXIa+AfX9zDdPbNtaK4z3T7QxARh29RHlhVsUHZnSMMVseWu
         DxkZmbiMzO0lcmUqlg3hYDP4Z/CbAsRNW9xxc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680037615;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hanuyFiFhVc/3RlCbpgD6fgmr+rE2YPGOnPcwJgKGQ0=;
        b=or6gn518tmDafFqWfu7nrlgi92rtm7Nj8JswSQhVVk8aSM2mowGziU2Tc7g1x+aq5c
         Eyg1Z4p1okMYGg+lAY9w6SOthT8PfymJaFikC4RSzHVFe3D5Jrq1U0o71q5qPPtE+Kf4
         3O5nblJ4zz7HAg6Fe7hrc+W1aykB+VHqQxGJoNt2X5LRa7kq2TSJ+lzw0Z91+d4aXdu0
         bW+kQiHRku+6f4k532xLS6HsCGWjLkyI0SsM98zM5YewfZKC/VrygQ8XtJsgGeY83BAb
         czogqlARKrIGWTh+0D77McVl5rRC1VXvQ1Du3ZhAEZZvv0wg7eLKUoHKI99KC3WYV1Sf
         o4wg==
X-Gm-Message-State: AO0yUKXfs+Md/p/KQBGRNRb3stCzkXwR8uPnLG11j/aCF1xRbmRlrFpM
	fSeUXH5l14ZBzYOHhSiO95KfHQ==
X-Google-Smtp-Source: AK7set83tp04y3GJbPyEa2LtGOuxdx88tQRQq5+ZfqDKh8TFASHi9M2UIhXhFGmabMnwCbzzKSnmZg==
X-Received: by 2002:a05:6602:2d87:b0:759:485:41d with SMTP id k7-20020a0566022d8700b007590485041dmr10044879iow.0.1680037615269;
        Tue, 28 Mar 2023 14:06:55 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id u19-20020a05663825d300b003ee71bccb7bsm9903752jat.158.2023.03.28.14.06.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Mar 2023 14:06:55 -0700 (PDT)
Message-ID: <0b0cdfd6-07da-f146-3d63-c7b3e3b508d4@linuxfoundation.org>
Date: Tue, 28 Mar 2023 15:06:54 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 5.15 000/146] 5.15.105-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230328142602.660084725@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230328142602.660084725@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/28/23 08:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.105 release.
> There are 146 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 30 Mar 2023 14:25:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.105-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
