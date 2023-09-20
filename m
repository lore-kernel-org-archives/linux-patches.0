Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4C5393C6B3
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 21:34:33 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-79e27406225so5496139f.1
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 14:34:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1695245672; x=1695850472; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kZcOhuXoe1gvgX0lflx3x1E53NWpGWz/sBp6zn2k6es=;
        b=e1zAxVps5ZXzcMnYYCP/p5Ye2zxwc2+z+NKz+lGj06To/MBi/eCYer63VG/FadjHVt
         /dI30s4iKF7jWqVXMTz7MTUnTrp3RCPbexDDxLcxKzrPDMKDmQT7NdkX/KqMKeYr84RY
         BaYajKKf7B41cdiX4K0A4TGY0aP4LRmCy64W0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695245672; x=1695850472;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kZcOhuXoe1gvgX0lflx3x1E53NWpGWz/sBp6zn2k6es=;
        b=SpAN080dd9s6zUYPyGlcQApyZb4PSy5xiIp5ZGMVOM9xzOCdjYPDJBM+xVBPowrEKH
         a7k3TwtSce0PsUJYJS1B32WAwjagWUIv6mc03JwCeXaX5x9Dr1070Th4u2ZnGnUlKgzR
         N5DQhUS8puspyEUw4LvzMOTMXm28YsodCU8AyTPeR5AKSPmJL2jQ2YfIAmyNNHh85qDo
         tg1AYE0pLwOcqNQb2pvbf7fbrvN3z4V/WI/OjOJ+KNLzdnm9hP8NHBWywDhYGeQsSShq
         njk8OR4JujDfhN0GBEuij1jEGiumDBCsPUxtW4R8YR/X5oHJ/Gy5S0gCE0dSi0h5tS2O
         JiRw==
X-Gm-Message-State: AOJu0Yy5B2LV1xeK7NiYJCRlV46F0Ixhyt5oUwDfhiXikyxZUFys0qkp
	Lv3PiLO+QiN6NP0lONAx8631Cw==
X-Google-Smtp-Source: AGHT+IHZIwy+JQtTgVsOLxJ3jEekSdJ9SwDsE2HJCj2NjdFGCxnOF2RbXLzpAV0P4Tq3GpqHK/XQKQ==
X-Received: by 2002:a05:6602:3420:b0:794:cbb8:725e with SMTP id n32-20020a056602342000b00794cbb8725emr5260386ioz.2.1695245672330;
        Wed, 20 Sep 2023 14:34:32 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id x2-20020a6bfe02000000b00777b94e8efasm20792ioh.18.2023.09.20.14.34.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 14:34:31 -0700 (PDT)
Message-ID: <86515fa8-bd68-df5f-3848-9d3b9264dfba@linuxfoundation.org>
Date: Wed, 20 Sep 2023 15:34:31 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 5.15 000/110] 5.15.133-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230920112830.377666128@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230920112830.377666128@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/23 05:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.133 release.
> There are 110 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.133-rc1.gz
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
