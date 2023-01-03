Received: from mail-io1-f54.google.com (mail-io1-f54.google.com [209.85.166.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03048160
	for <patches@lists.linux.dev>; Tue,  3 Jan 2023 00:28:12 +0000 (UTC)
Received: by mail-io1-f54.google.com with SMTP id q190so15937908iod.10
        for <patches@lists.linux.dev>; Mon, 02 Jan 2023 16:28:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dK+ejME3vqtm+a4Icr6XTfv9xCasa5ncnfzEz7AmwPE=;
        b=FkkX1Y6/UmCHrrCunMDYfuWIZS5C0QbP6hVZgmx5b7aFVWi1IOhBKFwPM06CLsssUk
         qagPshS9cIp6myQentdOXs95tXEI0J/OSku2V09/tznz/kFs0oe6Rhtld8alkJibN9IT
         f66R83GFb/GE6jXyK4Tm9xPlobWmDAeCAB4yU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dK+ejME3vqtm+a4Icr6XTfv9xCasa5ncnfzEz7AmwPE=;
        b=Dm3zKmOOVtlcnFAXvwT7HkfFOqDfu30eQgRqh73ydUxf3qI0qdvXXgxp61IuJM0tsN
         WDq09QjD6l7xL9rq3gnqr012u05fVF55I5Axs4MZqWRA+Dgo59hyK6iUohrE0cvcc78I
         kBhfW0XM2MB20RHHyaxYfODCMLfVyeNzso5ixlivsc9RcKJIMVMcrVi8C8iaQ7wEx/Sm
         zqyhSg5gOcvADJkruIlIuOC9lCbIOiq1b3D0MJ/0tj+uiMXNLK8tiLInVgfwQQoNZ3G+
         eqWYmRjFRjbhNCEPavCoevO/5+xn9aPQ56b6kcgKGAziZeTDgHTHFLJfWw1CqtkgHak3
         mlfQ==
X-Gm-Message-State: AFqh2kou0R4WzQPMyz5D8PR9UBoeBrwn7atLvsO6iJGHjfnT0yA1Cs8y
	myr1tUJvtzYT4U1G+OE4tb0D0g==
X-Google-Smtp-Source: AMrXdXujG8b2HX5DiV2u3D5kpWk9c3RKCpnZlEcfY0e9s071qomyzBsqHE99I1el77hcqErr2Ocxhg==
X-Received: by 2002:a5d:990e:0:b0:6df:128f:ca12 with SMTP id x14-20020a5d990e000000b006df128fca12mr5134666iol.1.1672705691687;
        Mon, 02 Jan 2023 16:28:11 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id s22-20020a02b156000000b003884192cc05sm9705107jah.120.2023.01.02.16.28.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Jan 2023 16:28:10 -0800 (PST)
Message-ID: <b5febc3f-8796-9109-45fb-6d009e2df1a2@linuxfoundation.org>
Date: Mon, 2 Jan 2023 17:28:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH 6.0 00/74] 6.0.17-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230102110552.061937047@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230102110552.061937047@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/2/23 04:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.0.17 release.
> There are 74 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 04 Jan 2023 11:05:34 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.0.17-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.0.y
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
