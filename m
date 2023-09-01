Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151D023BC
	for <patches@lists.linux.dev>; Fri,  1 Sep 2023 15:50:53 +0000 (UTC)
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-3a9f094b399so237829b6e.0
        for <patches@lists.linux.dev>; Fri, 01 Sep 2023 08:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1693583453; x=1694188253; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZDVLiGkCJ44mSe9398hxPMh1wdeWVEXWAYExdgYO+l4=;
        b=gbrg9nNXTbq8Q3k828ZFZ7n38zTknFzQiY0HQwEnsmQ/nsniOnrfF03dr5UEVC9jcN
         zyFPcNQ/ezQ8HIfe55InOa+xfYqbVXS/m1PAnSZ6ze7B9aqxkCb+HKcXScGKLgYGBMxd
         jx2sgCjy6XigFK6O8lJnSOU8imu7Gvy1XZE6I=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1693583453; x=1694188253;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZDVLiGkCJ44mSe9398hxPMh1wdeWVEXWAYExdgYO+l4=;
        b=avfKH2j3eBvoFKPqGVEuS4r/+phbCV3+3xTvxophKqzeJxOL88I4+Inxh/19L1s8IA
         YyrLD+7QDeLCDP/8iHifm4wtBwXBC2Gk9owwV8bt1n1t8x0+QUPtdixyBG+hL/JgKSCR
         uhK2RDa/ciMX6jArk2N7zOtup5LsE7J88z9UyXlBCh1iV6FA5xMs/TQz3oENY09HvKIR
         5oCOkxJ451jfLgfl0yuY5Td6QqLpmz2rZQRqR3WeQMUGKf5LdDgmpJ7GnW7GTewGctFu
         J47x41UNCpTe9QMbUcbPLEDd8abyp3a6xrSxTa0h65RDe6RPQf+OLHIXf6xU/3dKIM8l
         shdg==
X-Gm-Message-State: AOJu0Yym3IIlistqsJpEcuyzIMTroVqqRWBGyhaYEc0QFWlygtrPSoJF
	bSXL4KJVXUicYSs1h8Ls6954IA==
X-Google-Smtp-Source: AGHT+IGYxGykt5vTi4lZLI418Gz4H7++6jPC4+QxnO4vCE+VSdDD+qw3KAVsbATSlIfTV0HXI5a7lg==
X-Received: by 2002:a05:6808:1a06:b0:3a8:8aa8:a4c8 with SMTP id bk6-20020a0568081a0600b003a88aa8a4c8mr3579934oib.2.1693583452898;
        Fri, 01 Sep 2023 08:50:52 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id q29-20020a056808201d00b003a76d7f596esm2090874oiw.54.2023.09.01.08.50.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Sep 2023 08:50:52 -0700 (PDT)
Message-ID: <6ae96706-6d0d-f42e-0110-4339ac94f4a6@linuxfoundation.org>
Date: Fri, 1 Sep 2023 09:50:51 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 5.10 00/11] 5.10.194-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20230831110830.455765526@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230831110830.455765526@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/31/23 05:09, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.194 release.
> There are 11 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 02 Sep 2023 11:08:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.194-rc1.gz
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
