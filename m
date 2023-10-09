Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86C3E1428B
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 22:57:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GNIOWrRt"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-7a29359c80bso19068939f.0
        for <patches@lists.linux.dev>; Mon, 09 Oct 2023 15:57:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1696892268; x=1697497068; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2OEcyx+CG+G2DX8k230kBj9Zk1p7l6RAqnhFlG0dPE0=;
        b=GNIOWrRtX4ufuNhYv07pL2mFT0lbVW4MB4DS0NoiUSrBu+KmOb4SGLopqSl6WixFEx
         2B+t2yJ57W+upyFmhXk3sFkYNp4dLoRm0bdtkGFtWSCN4ZBS1o41BB1EURcvmj45M1II
         zD7EgN7bQui8wiWDF0tdzZMy9OAvgHMrZTMnQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696892268; x=1697497068;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=2OEcyx+CG+G2DX8k230kBj9Zk1p7l6RAqnhFlG0dPE0=;
        b=i0zEwXmhtyNce3Def+rvuxydew5J68UzMb2crHUuHD99MtXhGKNV68BqlddIEiEPgj
         fIk1k8hY80GJUO2FLiG7NrOssnhJXM1AsuSIsjBzuQ0HHUlaaRpWMOpMrh8/k3vV1Lnd
         nbaDxDuQ7KkVMCYrlGFFx1WYJLl3EPeImTkwcPaVvucco+7B3DwxUzkuNjtwx1uAY/ur
         jdbwnpvR/YNsEBcGVS9r2WEGcTsSDB5MlAZ0woaocTrTVnSuRkYCP9pxybK3mUFa0ZNP
         gedclO9m60trS6c6xvOQstXjOBuyRQqIX0AhXdZhiURmoFpyeaOs1+4Tf1LQiIjPU4z+
         cyuw==
X-Gm-Message-State: AOJu0YwPtzvDWNK3x+/vX6DQzq2TIdC+v2UNXk4xDF9jl/znF/NgHmeh
	O0e90gGAg0lkito5OaKY+rK+Xg==
X-Google-Smtp-Source: AGHT+IFbTZ2wIH4yqfN84dEc3TWbmavjElIAAr7btZSRiegZjepleLuOOmWAR//KMO3Z9SVLZvXinw==
X-Received: by 2002:a05:6602:1a07:b0:79d:1c65:9bde with SMTP id bo7-20020a0566021a0700b0079d1c659bdemr17549615iob.1.1696892268502;
        Mon, 09 Oct 2023 15:57:48 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id j2-20020a02a682000000b00418a5e0e93esm2347740jam.162.2023.10.09.15.57.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 15:57:48 -0700 (PDT)
Message-ID: <98ce539d-481f-4897-8d30-13b6c57e5b74@linuxfoundation.org>
Date: Mon, 9 Oct 2023 16:57:47 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 000/226] 5.10.198-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20231009130126.697995596@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20231009130126.697995596@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/9/23 06:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.198 release.
> There are 226 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 11 Oct 2023 13:00:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.198-rc1.gz
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
