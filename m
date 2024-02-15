Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 53A95182
	for <patches@lists.linux.dev>; Thu, 15 Feb 2024 00:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707955546; cv=none; b=XCT5GdJxqUGwf6Z1SgYQfzTgcvR1NxHhTsHXNFnyY4WXlZvwq/ouWcyRGXdIm203GFOrMUytfA/fdZWwuXy0rID5ivSCJPGAIDIR5rQegVYS7NXZuo/1qVXJT2HM1G/v/1GfDVJgoPCANmwuV3PK0G5J/NzenX6Y/Jij+CMMRnY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707955546; c=relaxed/simple;
	bh=RyT0hAFnyZXFspK1xF3WX3kXpHesaIlud3qAHvWfYQ8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AalmuE0/7ECz2MxrFqWfK3hvd8V3lJeRh61hVIXodRnaIJHVouHzL9sXsxfpHAiyj99kKlTVi6VLXHTua8NoYeeyzZlR+UdWPNRU7reP19fW/GhvTOdCoK49LKIZIRhunAoF1ucwSlKi8EsOu2hQy7rgDoHyRLFCP3V4TVC6ejE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iezSzkHo; arc=none smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iezSzkHo"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-429d7896d35so1457241cf.3
        for <patches@lists.linux.dev>; Wed, 14 Feb 2024 16:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1707955544; x=1708560344; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0RoGSg2VttRw4fae6dvJDXsrdDpNftzBOM5PYVXiVHg=;
        b=iezSzkHow79g2CsCeySa4bK+I7UeNp0HuUVNKB5509BH7OKLPqDzFt93eeAUY7x0Ak
         5+9NowUD4+MTgPTtpfYyGZllnTuawm0dWoYp4TWIpcXVk3y3hslETeLZ8TW6R0+qBCe5
         BKULXk/TYZ1sB/jBKsq5JGr+5mnp8IRhsAPcZnAQwcoaqIySVbaX2yv3ST0LPkJ8vlMC
         Ex2nqv1n6X61jqLD8kmuZVzs0IS/qGV+UyA/4pizqezgnrUg0ciiDsx+TSW1cklp/PhP
         J0mzp/B3pYIDjb5VzR9wst32kWsL9jPkjwnXe4opGofRCQR4FHhxntY9wMgMrxH81jdW
         4HaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1707955544; x=1708560344;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0RoGSg2VttRw4fae6dvJDXsrdDpNftzBOM5PYVXiVHg=;
        b=m1QyEvr779KvCJUQmVIDSAi/+1AZiWmsbnZm1zLboTB66oYJRWmmj5ACpylpEoQNCu
         V+WUIhaT5viyp0d3afro6oFIngHGpzZK7QJnP5dQJj2JgpsJ0WDE3uldN1nmrvEmcjVZ
         4kj8H47xJplF8hRZN5Di5D72Hc0UeYxnTDDrBXMLiBw5PTbDnq5s5r9SJ6FOcacerp5a
         z1g2hbkxmTAW8sWS8lyf6matneHVt65h31+ZtdRlxtd+NgXlFhOgkcGnxmwiWLLbxcpS
         TPOsNTpobWkwErLerCBuN1NLwJkvts64p5S0VQw2CCUkuAliiWh5WkQVZLmxk4ZCalgq
         61rA==
X-Gm-Message-State: AOJu0YyL1M+8YuLly1mSVxqAnRTLws1LYU3OGFDbS3hKMUQR46z82ac3
	UxS0/JMcL5lCPDW6L4ri48Xa3VHEWyNONkvGQIk+hsZj0nuJ+M81
X-Google-Smtp-Source: AGHT+IFpjE8rZ/HqeC/vKl01yY1yV6zz1HzKkGi6yhJBnaiEDIrmnxls2pdAv8XI9iMUXxFwVbHNVQ==
X-Received: by 2002:a05:622a:45:b0:42c:7c3d:e20e with SMTP id y5-20020a05622a004500b0042c7c3de20emr310372qtw.41.1707955544138;
        Wed, 14 Feb 2024 16:05:44 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id i6-20020ac85e46000000b0042c5ec26eccsm43286qtx.72.2024.02.14.16.05.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Feb 2024 16:05:43 -0800 (PST)
Message-ID: <1533ba43-c622-4a1e-b2f6-5ba0a6a8a1a2@gmail.com>
Date: Wed, 14 Feb 2024 16:05:40 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/124] 6.6.17-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240214142247.920076071@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240214142247.920076071@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/14/24 06:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.17 release.
> There are 124 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 16 Feb 2024 14:22:24 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.17-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

