Received: from mail-io1-f50.google.com (mail-io1-f50.google.com [209.85.166.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45D24AD20
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 23:36:39 +0000 (UTC)
Received: by mail-io1-f50.google.com with SMTP id g6so1369191iov.13
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 15:36:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677195398;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=rZ5XJ/W/Z6pz+mE4JXishSgSwq3TLTzAZ8KW6Yk7eCA=;
        b=ew09ybr11sadIu/Mmo/7iDzVonOX97T8sVDxIWqfjgD4jnw0mlorc8j1s65KHHEf7o
         KrNaycu41YE2cXK/OzQ3Vqx8mHL3zrAwG3IAGLVxjGgtzz29PNItud+CDd5NsIisiBpW
         sRWi+8qorCrTFoKzdh2pX8Ep1Po/jfDqAiv2I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677195398;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=rZ5XJ/W/Z6pz+mE4JXishSgSwq3TLTzAZ8KW6Yk7eCA=;
        b=N1A0+SF8AiAgHVIJRra1zNXHe3k89HYIMvVgrXSxeSAzAmsQyG45hQcwR2GAMjI1td
         lgyluFNDru3X5+DdJ+Ot/mqHpzYgH6sMqIhEsRIfW7bB6pDl954TvYK3f/lNAMw5zxfF
         DNrTyuqIwGcaNKVHSIJO/9n8ErPpJx9P95sJxGR/Em13Nr5eeGwvUvb+DVqy1D6Fad0/
         VJH1erXNnQemMh/nzdaLsGieU47O8AGv6UQQrgU6Yz9TjhGfBq8N4YFCzcV07fTRzctK
         yX+HIBs8VPXdZv70E4TR2qwKp3SzphAwNDm8vdkD/AkNElOtGhAM1E8IQan31wOliYUH
         m0ZA==
X-Gm-Message-State: AO0yUKXqp5kMsWP9NUvUm8/IsLaOv4mhEgWjBB9bUz1h1UiEB9IQFvqx
	VkKfdDwxlqrr5VnPy9iG2pHvdQ==
X-Google-Smtp-Source: AK7set8ws5hms6wUDgPHHTZsJvHTu1rgiDsEMij3CfBGIaZjO+bRFxhQvVnRDPiRE6PWqh1OdGBx2A==
X-Received: by 2002:a5d:9d81:0:b0:719:6a2:99d8 with SMTP id ay1-20020a5d9d81000000b0071906a299d8mr12048956iob.0.1677195398249;
        Thu, 23 Feb 2023 15:36:38 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id z22-20020a6be216000000b0073fd8ca79c6sm2520203ioc.9.2023.02.23.15.36.37
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 15:36:37 -0800 (PST)
Message-ID: <dfb8e24f-df8c-1754-32a4-a414fddac1bb@linuxfoundation.org>
Date: Thu, 23 Feb 2023 16:36:36 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 5.10 00/26] 5.10.170-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230223141540.701637224@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230223141540.701637224@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/23 07:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.170 release.
> There are 26 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.170-rc2.gz
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
