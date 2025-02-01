Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A46521ADC87
	for <patches@lists.linux.dev>; Sat,  1 Feb 2025 13:30:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738416610; cv=none; b=kQNG/8zGcvHGFmtQvIkn1FqqzWt45QnYT2Z+kAyirTGv6fNGdYO8+kBv3vnYv98Vq5IKOItmBl1VvYrVfzTKGymwg4ttzRBTcf2ar2cfM/XMkWXUIOJi+kg71InWu/9/WJomeJpecvML0rEtNe31hHXzkprNafPWk4MyhpEf9hw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738416610; c=relaxed/simple;
	bh=5JVWdh18zv/858cHINYokqla91yfj58V2KK6eKXtoYU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C4BZL1Gg6/O5IaRxFe3L+2T5ZwJTZEH1+4lQbAjZIpulpOzBOGFRGb5EqmMvBc6/zS0HrNgqugKoWENSSM8JDVNA+Ih6V7nADRtBwXGqBIETtfwSuZogTzKDWQWVEAVkrhNmf3tS6sYT/ndGomuiEZ006mQlErFjf/6+XuU6fAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IJmDuMBz; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IJmDuMBz"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-2163dc5155fso52493275ad.0
        for <patches@lists.linux.dev>; Sat, 01 Feb 2025 05:30:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738416608; x=1739021408; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=UqAzzVKMehG5SuhDIkwv/5y6JXLHrq/vpSXxcFA6TbI=;
        b=IJmDuMBzNXV2KSJHSyf9i7aPMqEvpE8HcbhP4e9hVWveDgVcquFTM1hOUEcbY2fBB6
         Xu75+9GTKK67DIlGfX2JDCAr1E9832xeeYPB+8UBv1dQdfAi1W5CYoRIRjem+BChuWaj
         03MPPgUW81VjiFjWNtH4g/aSbcYXHCfAe8RYyHJD8/Dyk/ZwgMHaCJI7RE2ikozTfZDh
         absb2c+YfQjqgMnda0DV2mYxMyGZ9ajyo45j+xUMmsZeWJPxHE658qJGW7P1+2afTC6E
         VEQihltI4hT3XCV0I5BbvkmbCkcq4WrQ8KjgeSZ2TniHbTe2bcATftDIri+NXATQlEj1
         UtSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738416608; x=1739021408;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UqAzzVKMehG5SuhDIkwv/5y6JXLHrq/vpSXxcFA6TbI=;
        b=uZxCpShA/GjgLf4GesaD2LPBRzICxx+72uHL8cqa1FgNCyvEDnSp6MFUe39SS7KhCN
         g9tG8/4CYoIwgFue3DDpIOk5iZdIaKLlQhn10MvZVWptCaytzzMMCphUlJNBAP4NXOLd
         EXMfTUZwdDUXHBf6hSV/i56x6YP2UoS6rQV5YANh8wV2z1lcgzQnxjf5zxXuXlLIYDjR
         epnwptE6opVRmWf5lrn98TpaduSO9asm4KOdBPwA7ZYdCQc0NWlvHLXFfGg1dGf9n3NV
         l2vqgebirwpVbHyrFgrP5gkdsE+kJX2LAOZxwkHNY/MCd7EgB0/D4agcO4RyU5B9uGuX
         nRog==
X-Forwarded-Encrypted: i=1; AJvYcCWxWwnFSsdRzjpH/dws7uArG4jmxsfig2HwYLOxjmiE+NAPmpfJ9jqe2FxQZ5LzwQyGookfz3q9@lists.linux.dev
X-Gm-Message-State: AOJu0Yw7QwtSCXmqqH6Wt8O84Xu0GqbBEJC1EPEre5POOrEZncR1JTuZ
	COp7WG9p9EvZB0QtHELo7olXmcaeXAAh3kLq4q9Jfrayh/e8FjBl
X-Gm-Gg: ASbGncu64AqwmF8ttB95pj3vFtdFrNBEGTeUqo63zPZJtzici+0zGmppaVQYIIj1Ouu
	sTl+Fzm1MGL1JfEB8ABwIfX+ngHsoCo0G8+6XPWeffRZi6TpyXv/iIa0api2C4mG44+yfPa/msO
	RFtYB/+UBd7AXVEEcEun8VFpbmyYPj1TRBb37uf2M2cpswac7U0InR4fdAsc9tadxXZr5KUHJl0
	JJLzKVkZc/sHykzbRMFt4RlpLY54KnG6RklCspCocAsBDYryzcOMGQTM6fcmGK3p6V2v1l76j1Z
	wGpqit2JJjzsHigFfuM9gO/PzKxyEMq2XrIPfXpg7bcaOq9AY03+yoDfCLw4m2ID
X-Google-Smtp-Source: AGHT+IHCjo/QOmXZUoTDPcYFWsXt3lWxh+F/2YzBOXeU7G2U2cHAcHk4up0qGU7oyuhwFixQ/PJ03g==
X-Received: by 2002:a05:6a20:7345:b0:1e0:d1c3:97d1 with SMTP id adf61e73a8af0-1ed7a6b178fmr27074217637.29.1738416607762;
        Sat, 01 Feb 2025 05:30:07 -0800 (PST)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-acec04794b1sm4749648a12.53.2025.02.01.05.30.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 01 Feb 2025 05:30:07 -0800 (PST)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <3275ff58-69ae-433a-ac65-d3144e7399f4@roeck-us.net>
Date: Sat, 1 Feb 2025 05:30:04 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/94] 5.4.290-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
 Pavel Machek <pavel@denx.de>
Cc: stable@vger.kernel.org, patches@lists.linux.dev,
 linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
 akpm@linux-foundation.org, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, jonathanh@nvidia.com, f.fainelli@gmail.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250131112114.030356568@linuxfoundation.org>
 <Z5zIZHIZxuHoymof@duo.ucw.cz> <2025020157-unsecured-map-aa0c@gregkh>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 mDW4+i+XlNFUPUYMrIKi9joBhu18ssf5i5Q=
In-Reply-To: <2025020157-unsecured-map-aa0c@gregkh>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/1/25 00:01, Greg Kroah-Hartman wrote:

> Anyway, are you all really caring about riscv on a 5.4.y kernel?  Last I
> checked, the riscv maintainers said not to even use that kernel for that
> architecture.  Do you all have real boards that care about this kernel
> tree that you are insisting on keeping alive?  Why not move them to a
> newer LTS kernel?
> 

That makes me wonder - is there a list of architectures and/or platforms
which should no longer be tested for older kernels ?

I am sure that could help free up test bed resources, and it would make
exchanges like this unnecessary.

Thanks,
Guenter

