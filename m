Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB1F25DAF0
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 15:59:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746028763; cv=none; b=bahTtsmwPS5EWkHLw9DGz+IZ6SPU0SPsyZEICfQJ306k/7PrEZjDQJ5YPlFo83/UpD6QVo0Zccuf71Kkx6WCm4tdS+py+bHt8ciWll/vkQhpIzFFw1SJdhVFkBt1QsBg8Sdon7t7HqHMuX/Rf5HQ+exfVhcrZr8ED8u1JPORR6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746028763; c=relaxed/simple;
	bh=T+jWp7m5MmJAhHAncr831UxJIfIxqvS8QZ0MeuyejaE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CSjczTrEEKqcCkhVuqAlaJOQDA1l8G7Dkqn7kBsgSTEPoOfbR0P/2mhXgGzrw0YVllN/TwzgPBVy7Q5uIECWIJ0yfQwyjVjw4Yl+Fg437i9gEgppl9Lwg2MqY7ZuMBb1WP3u/AMZu3o1IfCJEBrNk1U6NVrHBFmtVdetrfY16tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bQaw9Er6; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bQaw9Er6"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-85df99da233so815724839f.3
        for <patches@lists.linux.dev>; Wed, 30 Apr 2025 08:59:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1746028760; x=1746633560; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=CHfH8/RuvOHiVMcKgXPSO7Ua/1QwmE/VSmmffsLEhDI=;
        b=bQaw9Er63DLvSVVN0LnfMJvnLOTHA9SAX7PTnIUP8rNFzL1j2i7+LWvFGKoesyXvWn
         yS2TB7C8eSGRN0vc2LhCoUC8d+W4J79+k4oBKk5I2lLgyjPxRgPN8biyRk1k7Y7pypr/
         bdnPp8VlKdaqNJlEHs15bShhZ1aCZ7mV0f+Vk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1746028760; x=1746633560;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CHfH8/RuvOHiVMcKgXPSO7Ua/1QwmE/VSmmffsLEhDI=;
        b=ZXHCI39T8tqFof68NS6ms+d3YWNku5q1hwAdR/HjMmam2s4lFXphpVA0zMkyMAUUw5
         3QHNqy/mpHQq/IdtwQRsSPAed9nsrWJApfcDBgtfcYalCTsEQ6/E7+99x9MZg8ppP1Dn
         W8VEd9Wmd4QDEl1Rhd16gADiF80Ps3YxGwdUx1o+hxhr+p1Fv4rQgu3yKH5w/t83PVGI
         e4PsMCtth+l6OJr8QYokyxtX1fJ7h6RXuqXQxpNXfUdrj5IF4nTAeqATqBdtdjKovjq9
         X5V19baGImBdR0YuP+usUjrJwnxz9R3NNWjyj1rdqjHYHzsvZJYYXcqxIk4K2ott3K0A
         tAPA==
X-Gm-Message-State: AOJu0YywS5f8dJZlE651beprytvjgMVIXUe6Qh5ddbR7YthlTbSECGKy
	e7AWntTS53GzQwXi2cDTwLZf7pEmI15BpKbYTfpLtNjzwjTFqbgCiOeJFw1VgCvJJg6VfgMQ3Kv
	h
X-Gm-Gg: ASbGncsceDXgo7OmsnS19RwB7B6dukFdW/k5NjtBimy05cMSIVg77C0W07J83wFBdtD
	dbBGpPrIh5V2h7QtVIMQEnRLl3rWT3Lmie2wbQlomsBShQgrkyv3PtUrO97xVnF5yJrPEc5OCY6
	2hpHXUf9X2+dUU7ua5+5dCBMUpGipvgF90v9fgkIHq7hVJ3CYe2O1zV1a3CkPUstcJBcRr+JiHa
	Soxg81p1WCnu6meTxfjF92i+6ZKqySVMjqOMCVRerc3MC+MMPWa3nck+WPyovMmuspQz16eAzv1
	dULD514kRySU2Xf6jAHfHJJzlpp14j7cViN3e7fyF4bInyUdUl8=
X-Google-Smtp-Source: AGHT+IEiAIs8OYji6l+Z+0g6CqLLwH1qcgR8c8xPWDGgB+PEAq1VbP+QvofEs/k8l//Tlnpao+jlRQ==
X-Received: by 2002:a05:6602:4749:b0:861:c4cf:cae8 with SMTP id ca18e2360f4ac-86497f4455emr318828139f.2.1746028760602;
        Wed, 30 Apr 2025 08:59:20 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4f862b5d6d7sm864389173.0.2025.04.30.08.59.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Apr 2025 08:59:19 -0700 (PDT)
Message-ID: <4d1ff5ab-23b1-410e-850a-b0e38d7b743b@linuxfoundation.org>
Date: Wed, 30 Apr 2025 09:59:18 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/167] 6.1.136-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/29/25 10:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.136 release.
> There are 167 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 01 May 2025 16:10:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.136-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
