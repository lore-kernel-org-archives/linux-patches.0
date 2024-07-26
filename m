Received: from mail-io1-f53.google.com (mail-io1-f53.google.com [209.85.166.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4522B29429
	for <patches@lists.linux.dev>; Fri, 26 Jul 2024 16:32:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722011567; cv=none; b=daQwboPFI8qa2F8SF9/ntuj9QoQiaz2ai3+eArFToPCvKVKvVICfGgBgkMNqrObsoH4+s3XkddAfsuCY3ogVECOuEVs7Wcmn2SVxx3AlDQBizNBFZ/qANR1X0UxEYWwto2ADT1aiV2opHvapXexOrqL3BL6d5UjG7iTYV+9naZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722011567; c=relaxed/simple;
	bh=ed1/+nHimax7MGh6USmjQcKvgNVvRIPcXa/dhQA9IPA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tV0LaMrMiYVaCTLRgvKYBzSZSRAy0ny2BGPajVLPIzdUVUJ6tEhddFQJFkhPehxQMWTcoQx9h3T/cwAERVqXpI0KJ11JlXHP4Uf/DE+SZLewl+MX+NjUCcd2XHgKCpX4oVi8Wjp63KruJRipYnFR7tLvCR/gYgfsBGpZR8BscKU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ctBRzfK1; arc=none smtp.client-ip=209.85.166.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ctBRzfK1"
Received: by mail-io1-f53.google.com with SMTP id ca18e2360f4ac-81f932ede28so3115739f.2
        for <patches@lists.linux.dev>; Fri, 26 Jul 2024 09:32:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1722011565; x=1722616365; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=7RGwGXtXruvQ2qv2v/M8Q6U39N2aLr8llneA3JpvprU=;
        b=ctBRzfK1JYM/G8bTtHeYVLbVCW3sKjR1iD0nUVITts/u4qHFZzL5a6NVb2N5LHXt7a
         TkEQSODBqJZsmXZkUmx0LS9aG8h/zW60ofIfHEM+ghOiCjppgq/E526RxsKch7/Ng5H7
         VIxt8yF9QwjPi74GsmEoJxFmE2Va79Z3Aiuh8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1722011565; x=1722616365;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=7RGwGXtXruvQ2qv2v/M8Q6U39N2aLr8llneA3JpvprU=;
        b=k6QS1UEcgXF1n8JvWBwtI3kDTiZxqGN6gwh3X8Ui09AcbDAR+9qrnrpAJigLcos8yN
         6ukPmQNKdyZ7tr7Bk2HPMjiX7uYrOXQVJIHh+p408kPx2czFv6h9v5kDEBUI5JORnL/k
         /mNDflvf4LyjM0G9F0d6SwHYI7Vn3HT1Ua2miOz0gaiU1v59r2VNNJojmR8whss9O+LQ
         COEJlmjHRMrMLF0eQP8R3oSdGrkJy6nTo60pLr9hxX/QxHBVPW/DqaDLHgAsek6p3W6x
         EuBPpUWuRSjv/oZa3dfK3yybU4xxPuQgVpUragTs2R15JnV4hp1H4Xm1fckJTp+MrhnC
         jqow==
X-Gm-Message-State: AOJu0Yx2FFxeVq1MM5waiXezz3vgWw4rOgxZCWaFzj/egEGfhmMm5cnB
	783V21SaFomtu/LNnpmAqDgvoTSBmuDE8+TjAPkMw7kFLuorpK+Sr1IDYCSkwc0=
X-Google-Smtp-Source: AGHT+IG8b7Js40aTaFO3hbThVtKuYG3udcm+PJksP1inMm10ONWrLluUG9TMFNN1qq3nSaJBQDEedQ==
X-Received: by 2002:a5e:8342:0:b0:81f:8f3a:5689 with SMTP id ca18e2360f4ac-81f8f3a5894mr132159539f.0.1722011565323;
        Fri, 26 Jul 2024 09:32:45 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4c29fa3a36bsm905632173.2.2024.07.26.09.32.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Jul 2024 09:32:45 -0700 (PDT)
Message-ID: <7426c52c-5c00-4305-b959-db57b4030691@linuxfoundation.org>
Date: Fri, 26 Jul 2024 10:32:44 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/16] 6.6.43-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240725142728.905379352@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240725142728.905379352@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/25/24 08:37, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.43 release.
> There are 16 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 27 Jul 2024 14:27:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.43-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
