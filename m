Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 499D0EA1
	for <patches@lists.linux.dev>; Thu,  2 Mar 2023 01:42:06 +0000 (UTC)
Received: by mail-il1-f178.google.com with SMTP id h10so9570036ila.11
        for <patches@lists.linux.dev>; Wed, 01 Mar 2023 17:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1677721325;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wHgJd2c1+EDM3fHoog+7zpbx7+QkK+zQV9gtvUQdxhc=;
        b=WqpMGlw8tI3RBq0liEC9WqQpwXo/q1lUUD3X1jP+OpuGuJTLb4bkOz8YxxQ1f0LV3m
         +ctyX+H30xdWALHH2kRq0ARd96uvjcTozDN1XeBsf3PC++n+hpFEVTPuCR0wpnHcNWd8
         nhtkalQRzoQBjcWvM5XA1KyL89kdtQdlVv2hA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677721325;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=wHgJd2c1+EDM3fHoog+7zpbx7+QkK+zQV9gtvUQdxhc=;
        b=XJ2gv91iyFGcEufoeUX1qrmWJyt/3Haxv4jyXlXs4Gv7gFGSgOsIXgSoZeKiclZhFj
         0L3ke3PioLdRdjBpKHbsefsfLjiYzshCKIvssz627ztismcgYADZTqoAMIs4s/YyOu+L
         iroGKSbXdNXXSPuYWrYAkU9Gs8rQbf8v5mvtq0LKl+a9BNIOfPNCAKFdi96zRQ1sZv3B
         3mu0mh4G7h5hHNwpVUzl7GAsy6vlsNI1iEN1li6QDmd2Rhpg59SpnIU97mDu7FTQK2uB
         G5dIZ3JIHAf5VqmLJZqECMFf2Lbhk+BFIgU9bGPGs2Ijm3Vpg1DW/X0Ov8Ioz+ptIPn0
         4nSg==
X-Gm-Message-State: AO0yUKXAvKrSOamoHWaz4s8vbQmlon+Fn1MdRClstlWmJzhdwdM0VmTN
	2/LMlKZuwAwxfpfbqFv1FAU9ww==
X-Google-Smtp-Source: AK7set9xHkiu9dXiF/tr/Vw5b7l40+kd9CZCRhOLGAZoeecy4rPwbi8IkZd/kSC9JD2cHqY2yTQmrg==
X-Received: by 2002:a92:6c0e:0:b0:317:16bc:dc97 with SMTP id h14-20020a926c0e000000b0031716bcdc97mr5581633ilc.3.1677721325167;
        Wed, 01 Mar 2023 17:42:05 -0800 (PST)
Received: from [192.168.1.128] ([38.15.45.1])
        by smtp.gmail.com with ESMTPSA id t5-20020a02ab85000000b003ab21c8fa84sm4322772jan.121.2023.03.01.17.42.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 01 Mar 2023 17:42:04 -0800 (PST)
Message-ID: <1b98398f-0608-2ebd-3739-515645cd1cfd@linuxfoundation.org>
Date: Wed, 1 Mar 2023 18:42:03 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH 6.2 00/16] 6.2.2-rc1 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, Shuah Khan <skhan@linuxfoundation.org>
References: <20230301180653.263532453@linuxfoundation.org>
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20230301180653.263532453@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/1/23 11:07, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.2.2 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 03 Mar 2023 18:06:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.2.2-rc1.gz
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
