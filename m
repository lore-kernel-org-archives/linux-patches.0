Received: from mail-io1-f43.google.com (mail-io1-f43.google.com [209.85.166.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4328641A87
	for <patches@lists.linux.dev>; Wed, 20 Sep 2023 21:38:52 +0000 (UTC)
Received: by mail-io1-f43.google.com with SMTP id ca18e2360f4ac-79e27406225so5556139f.1
        for <patches@lists.linux.dev>; Wed, 20 Sep 2023 14:38:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1695245931; x=1695850731; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QY8PVgVpIHAID+AJM7qZltvMhQbKxhG6t29eKHUi9O0=;
        b=Fqi3t8DGE9dLjJYgxn6aQps/GWamK70IrARJCLVBIUygMzoPEsRG7TZKOh3NdcgNrP
         MBLjHH/LNRpOlzCQUvSJNev89j7yvEvJ9f7pUS2wV6ChNffc/pKGYdkrpVQ+dmc1c7nu
         nc/X7ZgxKzE783DHpw8Geg1GSzWOJ9klgQeJU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695245931; x=1695850731;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QY8PVgVpIHAID+AJM7qZltvMhQbKxhG6t29eKHUi9O0=;
        b=gSgGtMbogm5aHeSYV269zg0SFypPBjsQPjRCtH7VTyG8f30gO0wc7QUhPrbMs940gA
         yagt+/BVjZhaKoG4LGRk99QxxtMTzheXhZC/FXO0SvSd6PLssX5XwsXlOmG8Y4dk0myZ
         Qx73DXYMpyWb5TUHJJOv7imQHivLr8N+PxFuUHP1UXT9li1OET5HjWdHYIeHfiQsT4u4
         ZJ0zqao1aN6zyF9M4xX0TTKbQlTZRIbxB0vKqZ2TO/qFwll9xbStCVA3IUeM9wFo7XgU
         8SYyWOg5ToB6bq5TH4/ISeRq5V8bLresu4/SUNhgNlhA1t2wbbAR1X3F66MdfLo8lO1K
         CHOw==
X-Gm-Message-State: AOJu0Yxdtkte/cQaSzAiiZSdW12QQfILBhI6vQuF6DBTglcb+cG6u6Nl
	uXIy3irI3GzOykCrk0E/d42wRg==
X-Google-Smtp-Source: AGHT+IGeHWyarZCNN2M1V8niROtMVtxRAlyZHQiX5ZEUHbSs7i9apmB2jBsqQqYB8J9AtOBuxissgA==
X-Received: by 2002:a05:6602:13c2:b0:79d:1c65:9bde with SMTP id o2-20020a05660213c200b0079d1c659bdemr5599120iov.1.1695245931384;
        Wed, 20 Sep 2023 14:38:51 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id n2-20020a02a902000000b004290fd3a68dsm4262773jam.1.2023.09.20.14.38.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Sep 2023 14:38:50 -0700 (PDT)
Message-ID: <db56cb31-9615-c4a7-3740-17fa61e7bffd@linuxfoundation.org>
Date: Wed, 20 Sep 2023 15:38:50 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH 4.19 000/273] 4.19.295-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230920112846.440597133@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230920112846.440597133@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/23 05:27, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.295 release.
> There are 273 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 22 Sep 2023 11:28:09 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.295-rc1.gz
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

