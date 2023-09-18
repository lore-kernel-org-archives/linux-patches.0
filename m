Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5623F28DD6
	for <patches@lists.linux.dev>; Mon, 18 Sep 2023 22:27:14 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-760dff4b701so64292939f.0
        for <patches@lists.linux.dev>; Mon, 18 Sep 2023 15:27:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1695076033; x=1695680833; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3rqIWrOLYqD06it1VsQqnd3u9qXxj+oJZ3vgSdaTqjM=;
        b=MLE/2igA8cJqFfFuzBP8WLpMsPYUOcAKY99YhnkMqQ2700gdSL9g7+nmQuN8IYhsec
         gx3MYWpehCO6V9VU6KTne+Gd8gaSn6eOQkj6OOapW4bx38HJOi0SkluaHp818VoHatID
         8Ts1dPy2fsmJ/giYY5T/q/y7STM/BA2LeVUYM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695076033; x=1695680833;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3rqIWrOLYqD06it1VsQqnd3u9qXxj+oJZ3vgSdaTqjM=;
        b=SVy6liQKnpqt3CbXlF0j2y0OiFcru3LfIfVy9aRlBadFaEIiMY5nz4Igpg5u/uXNQ4
         HIM5460UTXoWPxnjlCnTidQvW7jH54nl8QdubQsV/V0/90BcnGhVnUxxdNRxQZNXmS1q
         cwn/QhVOhEd3uoo1J/5teECJGxXAoHqGoDz0t3WqZ3iOjS/TkEG740uLfE3YqlJtKA1S
         m6Hjlei+A8xHxzj7N/IzZ+EN8h6qrkxp+iTCs94rAWHJDyHRFU2qHiZ64JPEWq8MMbTr
         2p3u0AE35cWDHz4XOoZSxw05Isb3D6KXvO7Yv3B2HCOGu3N6MgicF5E98ZVskE66IrsZ
         QUEw==
X-Gm-Message-State: AOJu0YyogIznzjA27QSm5gadksvmJckwjP7Zrw6hCg2COOR0B6thwEov
	v0Ax+q+3+ehbnPWxgzj88Eiw6w==
X-Google-Smtp-Source: AGHT+IHDpo6xjPia1Y9rnAdAv6S0PeTNKEuHYXTuoeaPDZGV2nE4B6rRETLt6m8zSLY+XF35iwe/gw==
X-Received: by 2002:a6b:3bce:0:b0:790:958e:a667 with SMTP id i197-20020a6b3bce000000b00790958ea667mr11843320ioa.2.1695076033510;
        Mon, 18 Sep 2023 15:27:13 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id h6-20020a02c726000000b0042b3a328ee0sm3089190jao.166.2023.09.18.15.27.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 18 Sep 2023 15:27:13 -0700 (PDT)
Message-ID: <0b0a02b9-3693-bec6-d200-ec1ccb7b9ccb@linuxfoundation.org>
Date: Mon, 18 Sep 2023 16:27:12 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 5.10 000/406] 5.10.195-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230917191101.035638219@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230917191101.035638219@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/17/23 13:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.195 release.
> There are 406 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 19 Sep 2023 19:10:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.195-rc1.gz
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
