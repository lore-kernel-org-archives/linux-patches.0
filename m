Received: from mail-il1-f176.google.com (mail-il1-f176.google.com [209.85.166.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 187281E531
	for <patches@lists.linux.dev>; Sat, 28 Sep 2024 17:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727543749; cv=none; b=PxShpX0hm/CeLMrAv+eTPPydTFuoc9DI2iT8FMBzrJzSOo2++XH3I9inde3kWobYHweEA84MeZNXQhXm/6V/F1TS2IMhjULHkEBkoW38RJ3Ipw8rdow9S1MTC5lMJG/ydC6sOCf1mTpZ5jzalzEXXEpt2Wcy/BTjQKYWqQI351A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727543749; c=relaxed/simple;
	bh=brZNRktrqnf16yGsrlDQ5PzC88tuMZ8s8OQMtm/EEgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dUPm9mKq9TtKAXRfDjvi/FqqTipAi+5JUNkC2c16iU7ZcNi9dpP6s8JR2epo6fXDdDsV/Pxb5wbXDyXl7tSlSqh3fsJqgAxuYSJQ00pDzEDWMWpF7B02EtpKpbg6tw1tNFiHqUI1qDAT0vwhQY0F9X05fYNpXf04lfnUcH2znHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXiZLlNB; arc=none smtp.client-ip=209.85.166.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXiZLlNB"
Received: by mail-il1-f176.google.com with SMTP id e9e14a558f8ab-3a1a3090f39so14661355ab.3
        for <patches@lists.linux.dev>; Sat, 28 Sep 2024 10:15:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1727543746; x=1728148546; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PmV2od697yXP1xZ4Ef9v5IPEDQ6DPMqZn4YDd0qdJKQ=;
        b=UXiZLlNBRsvPv4N/r2GQaaDJHxFLSYzl/mZ6wa8ebUDKzrV6Y0BvRjGqX8lITPVSFl
         5PEwDLTKctzOgSP2HjSh7WBXI0wjVcTvn7RnGhFbGBVf9LJe2soar8ha9FKhI5HCU1Ax
         gIuuMdIWWeKdhsnJwHz3v81zxcXUma1S0UbKs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1727543746; x=1728148546;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PmV2od697yXP1xZ4Ef9v5IPEDQ6DPMqZn4YDd0qdJKQ=;
        b=bmzFrzIIkYDzEDu3rUiE5AG3QCdyODX8Bvco4CIq+y6bqZNvrQJo31I7dSbFYII4HR
         6f3Jj6ISQnw02rh1JMf2nCAhcMyDdIKSOgtPDA3mq4iUZ/eCC7QyCelMwUELkZFJX1pe
         5/tqMmegFNhDPV53AGeUU4UZDGjG/HEX60DJGGHt+AIUzx8NM7QV47HtEoc7vURufcc1
         YK5BOZmpUofoPfLlT72HbydYoFggm+2exIDKhN5uzUWF9JHPAUd38+0zyhBM8CyiuAjm
         WvaZd58idvH7jGEAyovKewHPHKbrx/oBo3d0l6P8NhQHUl/Ie64NBR9rK2cwO/7A57LX
         /WeQ==
X-Gm-Message-State: AOJu0YxszPI1HAYAC32shb/PtyNwRwdoFqMzBmQjrF1HmWOsEqjm1GPc
	EE0jRk9inHhAY9sbaftUI4eZS7IvWR6fU6HQlVeT1E7RAxe79aEoDsXwAXYonDk=
X-Google-Smtp-Source: AGHT+IEm78FTE60MAO3XfTpy9lAnLFdysKd8G1TzyucE3vFDsQjy2E15BmYrkPIUP1n59S8P5BjfNg==
X-Received: by 2002:a92:ca4f:0:b0:3a0:a21c:d2b2 with SMTP id e9e14a558f8ab-3a34517e868mr68409975ab.11.1727543746145;
        Sat, 28 Sep 2024 10:15:46 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4d88885f9aasm1189688173.67.2024.09.28.10.15.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Sep 2024 10:15:45 -0700 (PDT)
Message-ID: <46033b6b-69c1-4254-8056-6e8ca8061f14@linuxfoundation.org>
Date: Sat, 28 Sep 2024 11:15:44 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 00/54] 6.6.53-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20240927121719.714627278@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20240927121719.714627278@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/27/24 06:22, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.53 release.
> There are 54 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 29 Sep 2024 12:17:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.53-rc1.gz
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
