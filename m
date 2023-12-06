Received: from mail-il1-f170.google.com (mail-il1-f170.google.com [209.85.166.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A71010FC
	for <patches@lists.linux.dev>; Wed,  6 Dec 2023 01:39:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GWXGfiN5"
Received: by mail-il1-f170.google.com with SMTP id e9e14a558f8ab-35d374bebe3so5659405ab.1
        for <patches@lists.linux.dev>; Tue, 05 Dec 2023 17:39:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1701826756; x=1702431556; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LnDyv8mpa3XCy2SgMLwpGLCMFpHcfg7BstAYVZ2g+vk=;
        b=GWXGfiN5YuU7fFPU/E7jxIwk04l9bwtHSx6E564GJI455Z/DHzQHb3SQoVZPbgAORJ
         mG3xhnf5ykQ7WLeRdcaW5wUKh4l0C5/Nq8gCHvwBD1pl95LI4lMonDbYjLy8nIcmzJgu
         qq2P9qNTnitieJB9xqwCYJGH6tAiWJ8TYOnNs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701826756; x=1702431556;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LnDyv8mpa3XCy2SgMLwpGLCMFpHcfg7BstAYVZ2g+vk=;
        b=tplzyLjKXRT9vG1x54D+wbBIVw7kffO4UKbcF+oeoAWNgsZPtxBOgV5Ci0oSN9R1om
         /BexZhl2/3Yyy4//vf/arR0l6Vy4J87bjyLiu9AXGi3Gao4wUczvq3PbDfHw5Nx60oJM
         m03oDoeSv5jhjPw3kuDK3ndlyFeoNwzVFFCB2obxVdx+DJJ29sdy2uM/ILSGRRgz0G/d
         0UM0sgNT3DCQlIeKQOLdy8zRlDIvzym+FQgpFE8lfmp+ugwNBwso/KlgQ7T8f5+jdN48
         f57bHATDzODBXPY1u26A8jVoy8VU7BpJs6rEYkB4dNajifNJ9ubo7Dz663Vzm1J6gaDh
         yRCA==
X-Gm-Message-State: AOJu0Yz53F5Q1y7MTcyQLdChK+3zz6zGDn3M6DXNglVMvz/hZu1ucuEr
	bgikcSQr7WIIifAMWsj5wRnkDQ==
X-Google-Smtp-Source: AGHT+IGzIESU7A3Ck3UjU6zQbOlLRTIOa75cH8+024JUo3E3grE2pQ2di68BCQa7ACjTU6J0dCrp5A==
X-Received: by 2002:a6b:5004:0:b0:7b3:5be5:fa55 with SMTP id e4-20020a6b5004000000b007b35be5fa55mr505681iob.2.1701826756393;
        Tue, 05 Dec 2023 17:39:16 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id d25-20020a056602329900b007b457549001sm931003ioz.36.2023.12.05.17.39.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 05 Dec 2023 17:39:15 -0800 (PST)
Message-ID: <55bf7a58-3b9f-4c95-841d-d483c3b0bb12@linuxfoundation.org>
Date: Tue, 5 Dec 2023 18:39:15 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4.19 00/71] 4.19.301-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231205031517.859409664@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231205031517.859409664@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/4/23 20:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 4.19.301 release.
> There are 71 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 07 Dec 2023 03:14:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.301-rc1.gz
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
