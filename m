Received: from mail-io1-f47.google.com (mail-io1-f47.google.com [209.85.166.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63630AD20
	for <patches@lists.linux.dev>; Thu, 23 Feb 2023 23:32:00 +0000 (UTC)
Received: by mail-io1-f47.google.com with SMTP id e17so2233881iot.1
        for <patches@lists.linux.dev>; Thu, 23 Feb 2023 15:32:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677195119;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zyIeyBryi+yhauAhwwFawA2z6cP5sXH4pUcK8IFs2AE=;
        b=bPy644GfIaOOOc10/Rs26frvMcI3dhK1RUvMhRPlw2m8VdbASF4Kibt63D3DVCP9PG
         U1pMP1jrme+ifTk2eWfkwxSHPrO/rYvXvj96PStwL3Fob+ynXmOFg4JeY780tcd+NORt
         Snl/oc/4qk8UwRIxa7b7P56EFYHiyuc7bCfA8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677195119;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zyIeyBryi+yhauAhwwFawA2z6cP5sXH4pUcK8IFs2AE=;
        b=6X+bbcoaXuVlHR19BkgKim2ycZ3OaW4tOSWNzg1Ckeb/vAMjDK4zJekIhwxROeq+GS
         xQpYb4OK1FE7WeJl8wNCcOHTort4J2iFijVTDTkCWN7sa7NbbDhZFYmzYEyldLO3W8++
         zrwEvhMij4Gl8qmsgc6qqa8ETH3pHNg8hiPPVuHqYauA5rUISNXEDAUCDPSPkNfGg7pb
         3HGGAP7QPhb7Em+9bsqUXjO2k/xhb0llCMDSE6W5oghdkrGZ+ybGrIP7eUaod/OLmOyf
         JLqSSWExsqvJUmFB0SYx4I+QYT4j+aefKenbrDxMsT9gNazbD5dwZRZCcXiAqo2JCSLI
         N+JA==
X-Gm-Message-State: AO0yUKUu1lVSed+YeNwCvs3xDx0ceD3Ynx/xYPeh5ndkTNmBmtUF8+Zh
	s2tB3RERO4xBIB8c/K4jRFhIOA==
X-Google-Smtp-Source: AK7set/hXUVxXyif8mLIBAsHQeDvpW1mt0LvgboM2uPhHYzyJVXPgi311z0/1ab41iGINi5AYCk+Sw==
X-Received: by 2002:a6b:8d45:0:b0:746:190a:138f with SMTP id p66-20020a6b8d45000000b00746190a138fmr7395194iod.2.1677195119341;
        Thu, 23 Feb 2023 15:31:59 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id 14-20020a5ea50e000000b0073fe9d412fasm3304295iog.33.2023.02.23.15.31.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Feb 2023 15:31:58 -0800 (PST)
Message-ID: <e78f73df-e62b-a33c-77c8-75d1f946f6ad@linuxfoundation.org>
Date: Thu, 23 Feb 2023 16:31:57 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 00/12] 6.2.1-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230223141539.893173089@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230223141539.893173089@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/23/23 07:16, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.1 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 Feb 2023 14:15:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.1-rc2.gz
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
