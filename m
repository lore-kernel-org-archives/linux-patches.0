Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DEDE7EB
	for <patches@lists.linux.dev>; Thu,  5 Oct 2023 00:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OsjyOda1"
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-7a24c86aae3so7656239f.0
        for <patches@lists.linux.dev>; Wed, 04 Oct 2023 17:54:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1696467295; x=1697072095; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=a08xY7SZXFKc+c3Xwi7VT9tqVA8hFrAkL1vfo3KcpXw=;
        b=OsjyOda1k3m4XaXJzeIj3Z5YCI8NKg9YK32FTnpHryde2LWcUGwdbljjtEyOiaEWO+
         nvNM5W5sa5U4MHdv9FReQxqbzwdDm+RwScKyBIlRP51EZ6WYGJcnClbohD8Maqko/TbL
         0zcmNobz/8HEdyRQ54ok+IcSw7ESiEZuqA1kA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696467295; x=1697072095;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=a08xY7SZXFKc+c3Xwi7VT9tqVA8hFrAkL1vfo3KcpXw=;
        b=xBI3xDBxvmc6/20Y5+5xB5VIMlgDoPnsOFk4ogxtJNTDgmgBlcdB87V2vYug+luftI
         pFgmhZG6HMeUcYv/yPh/fpaQIunrzMBSCDBJVlHkN8K2IlSfYJrxo1WhNORUgKYRBr45
         CHuXIOVDeHPeU6pRB4i1fjxYZnVqwxtZKshvno5YaGbV+B6zdj5MNsx8Fp8JY3j20N4h
         RhJLV4vEa6Hlwh0aJ+j2P7yuQoWiJf1Vs9HOafXmsncZho0MB7/tZNnCwlC4aAv7YmYq
         Yd7xOuh2C9QN7dKV71OlN0FNY3oXQwlnCFSIne0OOYjFOthn+q3i0OOgX6d2Wu0I2d+8
         Rl6w==
X-Gm-Message-State: AOJu0YwxdQYckfRJJugciIUez6HvQBGIAwC+ZkxtRWG1dItLjCHNaSU4
	bDOAabzmBTnHds5pbNpz41WkKw==
X-Google-Smtp-Source: AGHT+IE58O11Qqrb8YDePCZPuDtEnm8Rhg6ypj6OjcqiXoAICbc8fmxx8LLaZD4gkl57C3EZW73VwA==
X-Received: by 2002:a92:d1d0:0:b0:351:54db:c1bc with SMTP id u16-20020a92d1d0000000b0035154dbc1bcmr3786198ilg.0.1696467295606;
        Wed, 04 Oct 2023 17:54:55 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id n4-20020a92dd04000000b0035150cf93basm100992ilm.16.2023.10.04.17.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Oct 2023 17:54:54 -0700 (PDT)
Message-ID: <8ba0360d-81b4-4555-aa47-540fc4e5acf0@linuxfoundation.org>
Date: Wed, 4 Oct 2023 18:54:53 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.5 000/321] 6.5.6-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/4/23 11:52, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.5.6 release.
> There are 321 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Oct 2023 17:51:12 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.5.6-rc1.gz
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
