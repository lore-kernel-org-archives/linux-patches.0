Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3C64620
	for <patches@lists.linux.dev>; Fri,  1 Dec 2023 00:08:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iJcTLvVn"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-6d63e0412faso284887a34.1
        for <patches@lists.linux.dev>; Thu, 30 Nov 2023 16:08:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1701389335; x=1701994135; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=zIpe6Pc8ZEweE2wHhNCMd1qwpO5w40pY6E+2NFsb9lM=;
        b=iJcTLvVnqb29xRZGsUq2V9p31v8YwDc918ZG8tcwomXPTTcpW89fyNpfbMK262Uqk7
         +1GA6qYk9jMH5lvk8zxFIt4us3XGZe/JhP/ECS5FeQj8nqN/jlLt2psYyuE2Gmxl9SLo
         dkxIdM5LG5/zOp0jLOXMKUclsnxD6D5KGODko=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701389335; x=1701994135;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=zIpe6Pc8ZEweE2wHhNCMd1qwpO5w40pY6E+2NFsb9lM=;
        b=xDRH9VGhonqYP7vSJKYoBw3NENNYEwv+uqDxZ+PeA1CVziULk9yfc+3cx8TZlzTn/i
         6HDg0VMqug8doQfFXHM07cP0LMNL+LJuE7PZ23lcrhXj0/qomU77lPi/Ak5LxqGg1HaV
         BcOG3jdhEmqB+R92fBFYDGZb55vWwi8FnpsczRhUmb7dTjYHehVZxb9lZ2IoLPtGGgAC
         h2KWRaKacwwMW77jLaVcc2W1qz7cyv8g4f9ax9kQoSmasRKz+uALJrEMEsLC44FfweUD
         u4y8nu/A/dpI3s2yaVUZb63Emyqu2++2Vp1P9lwKU2p5+1EfxvihpJZiYoip2kHSuE6H
         LPvQ==
X-Gm-Message-State: AOJu0YzCBdtsAinRzTfN6rLmL/MzilO/6h3ZTX3AiyrX9kAKvaoZvaxL
	6y5SvKWsT8p/+GoMW6pkeZpUtw==
X-Google-Smtp-Source: AGHT+IFiMvXhLclCKdsvPVqAtnER9bIGg1ntAGRXcro8SZwc8QNq2ehOJpy6gxKHfW0xxsLRvnKWsg==
X-Received: by 2002:a05:6830:4686:b0:6d8:53d9:8386 with SMTP id ay6-20020a056830468600b006d853d98386mr5896779otb.3.1701389334789;
        Thu, 30 Nov 2023 16:08:54 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e24-20020a0568301e5800b006cd09ba046fsm315807otj.61.2023.11.30.16.08.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Nov 2023 16:08:54 -0800 (PST)
Message-ID: <a78d25f6-4822-46da-a431-1c35cbca7b18@linuxfoundation.org>
Date: Thu, 30 Nov 2023 17:08:53 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 00/69] 5.15.141-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20231130162133.035359406@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231130162133.035359406@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/30/23 09:21, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.141 release.
> There are 69 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Dec 2023 16:21:18 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.141-rc1.gz
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
