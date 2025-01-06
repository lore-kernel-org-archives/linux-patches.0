Received: from mail-pl1-f175.google.com (mail-pl1-f175.google.com [209.85.214.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69C671DE4EB
	for <patches@lists.linux.dev>; Mon,  6 Jan 2025 19:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736192736; cv=none; b=DlW/1FV+ngDyYtwsTfkG4l7x/NND6aLJNhttQYOaxbfBL2sB2dqiZf/mqOPZclGGpQ18k4KfUjo/XxnngIly1nZTQRqnlBOTgHzgsN0J6vql4x4wqoOkicf3AFI1ce09b0f+LZ8X+P55PI0vnCDgWWi1FXtwisI6s+ihRCFiUIw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736192736; c=relaxed/simple;
	bh=IWcJ929/9inRj5jhjgQxzqfgzV7m01g5j7K5dy7Ow9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=avSuFNY12PFqEw4jzuuEwBIE5xKgVp/CnGpwU10sRWq8WONI0QkOW5QDl9OeVrUWm9Up6UhV9k1r9nsyOHLAtdJPgVweCQBktn8jmRXteRbO2k//YovgmfHTN4Yz/1MhkTz3yjMJVM9nIV8SUllBIwEWecLDAXgbJ383gKC9zbY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DtUv0WmU; arc=none smtp.client-ip=209.85.214.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DtUv0WmU"
Received: by mail-pl1-f175.google.com with SMTP id d9443c01a7336-21628b3fe7dso207229745ad.3
        for <patches@lists.linux.dev>; Mon, 06 Jan 2025 11:45:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736192733; x=1736797533; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pOQbHTIpJwowN7PSlF4vQq7w1O+77ce6EHIhiyVp8N8=;
        b=DtUv0WmUBJ1DlLMy+49pUIllYnTZkYMHqK98lgBYy2UuHCkkw9Quhwosdw3SbHqFr5
         ntztAEO68UnBsiu+lhqwyooIvu6f1zaiWT9JQgNi254/H+i9H91c1pxR8MY8UjFCOboi
         95FeFM7taN4mVJf7927q7RhKIralOUzS5dUdNPywx4VwMWGq6KVK2SBsSCuJS29TU4LU
         UhD+z+uvUXDbHeXCyG3KfuSMf86a0jEDqBZw2JC/X8AYBRiT/wzYJpRsTOwu1silo/DY
         RxUBi8AgoO9VR2Yqa7WUhCTLWLM+O0QVZIZZ1O6w2pK8In2k/NGhIH/HWjipsoGH5Rnk
         uRnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736192733; x=1736797533;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pOQbHTIpJwowN7PSlF4vQq7w1O+77ce6EHIhiyVp8N8=;
        b=qKrNUigCflJBgRW5C21Zn69iVW/GRmZTvlHsY/y68EHEyYqNBxYT5CI9XXnh5B0idd
         dsEO8Dmng0uFNMMKdVoaswjHE7lzmyvSqiMGTV4dHd+ER2Dk8kbIftaNrhD53l8LMggA
         tiSfGodyDNg6RyDwxNe9prV5lZCJKtd3eCi/RHWsJSOnZcYyqktHXSDlykUATlViizUv
         fATiNg9iOQzYM/dsarIoQv1qh1Agu72O4Dz36cOOgahlj0YBhl0efdpTqbk/ccSdjxHN
         PnP8E0BcNPiZ9tkzG7TpqGF2Qkr4xJa756ZHhOBycobJMMposasoB9AeoPqbV28L/Vd9
         Sh/g==
X-Gm-Message-State: AOJu0Yxn0nqfEBvkZkWwzczUa67YqCLKeROgAZDYjsYzzi72RLSGBZ8z
	ePoiHl0k5QAdER3Ybe9VVT2rMqbDCUtO1YFwBwx6y7cEeTadeebg
X-Gm-Gg: ASbGncuhzWc9nmqN2RtOJGZBghh3Hq2fnuM1prOwmdHnZZ7W2GkkbV5uHX6SWJIjZsF
	69iAVpl81BKma6Kr3+uXimObJvqLcsu2FQyS/CP29AwaNGoR7RCYDVKKRHIGz8Bu3b6UqeYvhM4
	7+N/4xjPqPBSyh3RREboF84mOflUuKGqgd7C3AM1BB2B2dKvckagdlhbty4rQWcPwk9arR23uBL
	d0qYzhuXcBqaCfp+t/Vd4i6/BHFtp5bySQNh1tLkZtyLhJs9MTnYoMXXf2hwnFLsC8S9Q0DYkCk
	wrKLjDQw
X-Google-Smtp-Source: AGHT+IG+H/BD87SJUjPNTCGw985rgYSu3/rv+yovjdRlhXccpwI7SucI25+vhhhZDV3j8Tow7PDmYw==
X-Received: by 2002:a17:902:d481:b0:216:770e:f46 with SMTP id d9443c01a7336-219e6f26692mr817731815ad.54.1736192733026;
        Mon, 06 Jan 2025 11:45:33 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-219dc9cdeabsm286631335ad.125.2025.01.06.11.45.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 11:45:31 -0800 (PST)
Message-ID: <449fcb1a-9e16-4e25-84ee-e10db7ca1440@gmail.com>
Date: Mon, 6 Jan 2025 11:45:29 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/168] 5.15.176-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250106151138.451846855@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250106151138.451846855@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/25 07:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.176 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.176-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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
