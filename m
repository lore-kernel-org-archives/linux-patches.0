Received: from mail-il1-f172.google.com (mail-il1-f172.google.com [209.85.166.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D50EAD27
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 15:20:23 +0000 (UTC)
Received: by mail-il1-f172.google.com with SMTP id e9e14a558f8ab-34e1757fe8fso507705ab.0
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 08:20:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1693581622; x=1694186422; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xY8BsCECr54L+c95O61jCyM46mbHUvE324/fO6bwAIw=;
        b=DA+L+Jbovatw6uclbTvgOTubknlN1gLwiQ7IiCZI7Lq5k6DyUmdkvvO5Kk56gRNCZP
         mJZPWm8srqPDzAm9t/4EJElKpGhGw+pZ9aUHBSZP1aTzILGNVi2dtQkZxsccuNu5ntJt
         UzRv8P0wPYr7dZic68bOVNoQqlLO4KsqmQQEU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693581622; x=1694186422;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=xY8BsCECr54L+c95O61jCyM46mbHUvE324/fO6bwAIw=;
        b=Ypvj02TVZkAZVUVbPTA2bPY+ajZnd3XbajkhZBhgLw/55iAdLAvHfhPgMPOddUV1+J
         PMFHnLf6o4r5KIznA4vNJfXdEnea3IrMsnHmUPugUt3hDM/4a9qOw4MMH73Fc+2Luzv5
         vVNNat/5f2e/PP3aovOJan1+rqnRlyPynQYJdg+NyLLWqJxMPq69Wvdqtfc2G7p6vE0d
         u5DLMWSV37/xPSZZ4wDN++v9K1Ojytf2n9jtkTHtlbTkvuzfsnKW4sbBsv8u5Ky7WIXY
         VfpTpeEZsSazZux4b+niSC3+szSLGTZ8JNzT0ybRV+dm4/l0HvhYgZhPEtDdKPV3hg7l
         APkA==
X-Gm-Message-State: AOJu0YwJTx27mqeO1J/VoWBVpzrNdIJk6gGtEVy8+mKXjM3hOXF+HYoz
	imckwFzO/gp0zERP2MJJKawa5A==
X-Google-Smtp-Source: AGHT+IGG3Ew+TxuHNK6QM0bToaGrJd2wXKh0rSJlX3Vov9MjzbOCzhl1ncGLiQIV6zyXr1scCg295g==
X-Received: by 2002:a05:6602:1588:b0:792:9b50:3c3d with SMTP id e8-20020a056602158800b007929b503c3dmr3192707iow.1.1693581622276;
        Fri, 01 Sep 2023 08:20:22 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id s10-20020a02cf2a000000b0042b320c13aasm1118332jar.89.2023.09.01.08.20.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Sep 2023 08:20:21 -0700 (PDT)
Message-ID: <b761de93-f4e3-2395-07d8-7f8c86da1ff7@linuxfoundation.org>
Date: Fri, 1 Sep 2023 09:20:20 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 6.5 0/8] 6.5.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230831110830.817738361@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230831110830.817738361@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/23 05:10, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.1 release.
> There are 8 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.5.y
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

