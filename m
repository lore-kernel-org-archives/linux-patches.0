Received: from mail-il1-f178.google.com (mail-il1-f178.google.com [209.85.166.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5E1F15B0FA
	for <patches@lists.linux.dev>; Tue,  2 Jul 2024 23:40:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719963636; cv=none; b=KuY+WH70j3GAF3x2N1t3k3hcl8te8rHV+fgSbCprFlnK3rdUlXpvZ/33qwDGH66lw02tO42XvR1zdbf3inbulsM1yZZFejHu+N/TENE45Gz4kNbbQBBcoAd60xCayKcutLH+ouKD0XulaNBGSWcoxntMPkc4EOH8/idLTyuCRf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719963636; c=relaxed/simple;
	bh=q/Q++bZUqwx4rHkgKvz/qr06d8ZoEgwD8AdUokHeVi4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jFOVfIAVMFR/HxKmp6Ko0F1Lhyrt00NnxAwCX5hR67gi+LiW/13SmW/lr60cjNh4MQffchEEX2AICqMMlvUsjHX6YZWBef6W0nDQXXm8Ro6tyzFeLw3DNcIwo0M5Tm0CQOqk8nrP6Mv54sxJTERQnXSjovGHzU492D+ZpQlrLPE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KTKzjBLH; arc=none smtp.client-ip=209.85.166.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KTKzjBLH"
Received: by mail-il1-f178.google.com with SMTP id e9e14a558f8ab-36dd6cbad62so2651925ab.3
        for <patches@lists.linux.dev>; Tue, 02 Jul 2024 16:40:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1719963634; x=1720568434; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M1GBiR2qP3dwXuNbCIfCAYqEpvO2cT6fV21GvANeJLs=;
        b=KTKzjBLHMXuVRnyHV8DodwrxpN+p8SmloX0ru4JLY8oiDV7W7JqaWRp+roE1/pg+D4
         NC1otSyQGY0VCfRx0Oz2shdboYN5Lf45a6vwUjBiJUE9f0nujbQNLHKEdNv3vgSI17y+
         lnzOGxF4aoM8JEIcm0rCpRAy+NZJXYT3CBiOM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1719963634; x=1720568434;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M1GBiR2qP3dwXuNbCIfCAYqEpvO2cT6fV21GvANeJLs=;
        b=CfchlmQ/SWisnQ1DUhe91rBYmi2Elgsf45lt0QwUA1qhnBdKUaAX0L1ZP33rLx7QbC
         atgBgztgnDegXT2PpLN4nrLXOPdv4w3u4awCzy3fdi3SAvSGhx/sPY4Bj5TuTU5esPtY
         wl7Qmy5+6rDSqSHByUXiAioA0WkEH3QCDt++Nf5u73TffOqT8Ci3BM5ywh+NEXw6UEDJ
         ssUfChDuRvdPYiYuh1Nd/O0qeq46iACQgUT58CsSvosYrjjm0ETubI84QNntwCckPQgq
         /+Y4+cdS0z/ovQseC3ZOY/PKOYzKEVpTfRlFMp3ME5vno0a9iohiUHucvIi8tenA9Gzu
         xrnw==
X-Gm-Message-State: AOJu0Yw6NLKwXO/74z6ECS7oN6Z+3UycVKLnrFM9pJSl8wMqwJjBQtJI
	/k21VDzMuyzmotLnzcgGgu4/VXG3OCVVG+pw6d7bwAzaQ6GIqqOWGmQwFqh8oKM=
X-Google-Smtp-Source: AGHT+IEROh2kDmfI0/vSuk2WwbomsNqHiQ8Mhs6Xsy7UzYSACQgA31qwiBNSiGoU/iCVvVcaUQXN4A==
X-Received: by 2002:a92:c54d:0:b0:376:3907:4912 with SMTP id e9e14a558f8ab-37cd1b799ecmr112365645ab.1.1719963633925;
        Tue, 02 Jul 2024 16:40:33 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-37ad22cb662sm25750825ab.7.2024.07.02.16.40.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Jul 2024 16:40:33 -0700 (PDT)
Message-ID: <857aae90-6251-4532-a8d4-6d2fb8d29114@linuxfoundation.org>
Date: Tue, 2 Jul 2024 17:40:32 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 000/222] 6.9.8-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/2/24 11:00, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.8 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 04 Jul 2024 17:01:55 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.8-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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
