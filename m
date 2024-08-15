Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96150154456
	for <patches@lists.linux.dev>; Thu, 15 Aug 2024 22:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723760015; cv=none; b=SIvYj87ESjRMCZgQj3rLYajLnrRBpRMrWmvOqygYC+M3Axw1yi5Y6B3u2br2S4WJ7xVClvEzOAeEWrdKi7jYbl9foVjcrk9Yeo1gQr7OcTzIUVcxtW0/+zlsSJmb1ksTJAHA1RpAFI5n3ycQNlk+Q0g0EhMqy3yznXhrlqBVbi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723760015; c=relaxed/simple;
	bh=eQum6iaE+rv3Ph7bu8aJFg44H4RBuaFTZwi3t6g21xc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sbBKPZ/Brj/6NBDioqVvImtuSR3j+PqidUIOi2ULQUaD4Oue6wTEYi0j3vrbvYn3xV/p9m+9O3sEro/XMjACuO229GDukPmVXeFwX2b0NJTGjq7Swos9gXY3u+wHRiG+Mr+KEIo9D4qIQuf3Jg5+av3+WhWkHp4g4arq4FGyzZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dgnnL6ue; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dgnnL6ue"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-201fba05363so6750625ad.3
        for <patches@lists.linux.dev>; Thu, 15 Aug 2024 15:13:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1723760014; x=1724364814; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=arrrA+WQbb0NxGhusaGob6M8x70A5QVsX7ieBI3XSRQ=;
        b=dgnnL6ueLGLHaEkJML/p7w5TyGcvFtMNz6pIxvz13IQBIWsDHQej/pzbDXxt/iCHEA
         WKhu8F93rKu0Q2p+DxPcYjFmoI95s56+GIC/9JmE5EzXWJmTvFrdixa8vBb0/Qv4x5us
         REBZZb3WEMZHRn2UkvDKGfF05Ug1dju4ypUUdMMu3DfVuoqC5bnLNVbqXGS8LWJQMyTZ
         EoN2MSYah6O7gVJeffKuWS5PU/lXQ2DVDwqIjcXueREL1C0s3fOHkklE4YVLpijjLwqZ
         GjfupR7BpZdPAuy34oSJ6rxzn+E4saG0x/ATF+zLRVZTgAMNUQcp4aRM2fypxHkVsOS3
         g5YQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1723760014; x=1724364814;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=arrrA+WQbb0NxGhusaGob6M8x70A5QVsX7ieBI3XSRQ=;
        b=bXFyoyRj8F1jA9pDmJHqXAyUfQMul8dmLlTmDrJE8Yp7XjHxnFq0nEVqSbbDi6iJ7Z
         tbQoPIcH5JWewWW8Pb+on7QhvE5R7bJX67aLDluy4t/pnCChjo+kVhXAnXWyUSBNEFDu
         jQnSLWyTl6PXVnqr3YKQ9hY5Ih6H2QlKcZpAEDX3BfA2xx26tomIxcpr1SSW2R5JCUaW
         IW9OzCN9J2SylhoBGO7ieIyPsb2aEZlzA9cYpymyy25IZl+NyVpYgGKyJfWUmDCsbwhs
         8nwXnYh01cuzjGogvuU1Ajyw9UQcK/h5zi2t43PVFA8taXSymtaeTfLryYfGO7dQQHqy
         WC4A==
X-Gm-Message-State: AOJu0YzdVbAHLAJmJCJfyK++F2BuydNp385a7nbC4xZVinfU38cdu2YY
	M+XzaXrh2vY2UYYQ8H+BkZPawDZJJX3CI5QuPNGpApMjEzuixuUo
X-Google-Smtp-Source: AGHT+IGArETAC6OBlaLl3mPQr3yQ6rYTBhcEmS/Td5rSoxReEtC3OXKUD3v9kbcsgbBs5DTawnAeew==
X-Received: by 2002:a17:902:ce8a:b0:201:f161:7e51 with SMTP id d9443c01a7336-20203ec4f8cmr19001815ad.31.1723760013781;
        Thu, 15 Aug 2024 15:13:33 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id d9443c01a7336-201f031c5e1sm14685215ad.94.2024.08.15.15.13.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Aug 2024 15:13:33 -0700 (PDT)
Message-ID: <a368397b-3d86-4225-b18d-a65e9149a99d@gmail.com>
Date: Thu, 15 Aug 2024 15:13:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.10 00/22] 6.10.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240815131831.265729493@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240815131831.265729493@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/15/24 06:25, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.10.6 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Aug 2024 13:18:17 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.10.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.10.y
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

