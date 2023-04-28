Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94B3D320C
	for <patches@lists.linux.dev>; Fri, 28 Apr 2023 22:26:27 +0000 (UTC)
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-763740a7f31so2165239f.0
        for <patches@lists.linux.dev>; Fri, 28 Apr 2023 15:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1682720786; x=1685312786;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=RMvHiA5X/oFoi0HiHbXPC2hzPgPum6tdmBFydzRayP0=;
        b=eyseTRqHRpSKV9M4OhAJH1pTy85+2t7aWEAj0j9QrhQ8rpXvm6PpsRV9Yh3nh0XWtK
         VXgvI4oLoqMOqT8lSi7+QkL+dT3wekKd1YevUQ6fCrVW9dciWJOcY9nuYM7ZyAKKOOdD
         nT5KgKyPWIAYDoYnHc5ieUYHZjdEI5B6s/7rE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682720786; x=1685312786;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=RMvHiA5X/oFoi0HiHbXPC2hzPgPum6tdmBFydzRayP0=;
        b=ijcmHx+pL8lXtIsk64i4VW23tfRZk+iYW3XmqwaFC2d9i1yJVZ4Tfq4tA21TqpNxZ9
         AuY7RG8L1D+If0tx3KA+hdfUbJWLanv1KCtNjksV2Lw4dZj2gg7dVMFu1Q3Yt/Uak2a9
         S6EG1SrVvKhvuN+ZooNf1ujuJdRsaA1gPZsqexTLfTnC6VlNWm2mmRCYEl5qVKgOigk7
         umGurJBoOXZuK1YAcWeJ1kaHDBLfHTtHW8ss8B4jHLYXkpp+0Rjf27c9Wjb6yyMZQd+7
         AeDdLGal/6InMWmr37QJwT9DWhKOS53I2GWz3gfYxmrB/upG0S+Z02sXaO3IqM2c45kf
         AxBQ==
X-Gm-Message-State: AC+VfDx2LLCXz0sjrwBlS6NIQRdaC+lV+9MwNSQBld/OWjG6V5QlOabw
	jLH+MAT2UZtWFNZfl+e8vEUjyA==
X-Google-Smtp-Source: ACHHUZ5POQEvt+GzKVYdai0dY9PRC8C8XT0gUZk7LwFjM+90UNMY/bHThyhcW1UoqDSrssf6s5LEbw==
X-Received: by 2002:a05:6e02:1d1d:b0:32a:dbbf:5707 with SMTP id i29-20020a056e021d1d00b0032adbbf5707mr4167596ila.0.1682720786620;
        Fri, 28 Apr 2023 15:26:26 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id e28-20020a026d5c000000b0040faa68e7adsm6378810jaf.119.2023.04.28.15.26.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Apr 2023 15:26:26 -0700 (PDT)
Message-ID: <9625e834-a7d8-d595-1f7d-01910533fd57@linuxfoundation.org>
Date: Fri, 28 Apr 2023 16:26:25 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH 6.2 00/15] 6.2.14-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230428112040.137898986@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230428112040.137898986@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/28/23 05:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.14 release.
> There are 15 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 30 Apr 2023 11:20:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.14-rc1.gz
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

