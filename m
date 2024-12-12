Received: from mail-pf1-f181.google.com (mail-pf1-f181.google.com [209.85.210.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C0F11BDA97
	for <patches@lists.linux.dev>; Thu, 12 Dec 2024 21:38:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734039520; cv=none; b=NOu4l8InYgodRpm/7kP3Q39ltngDdtwLVepjTC36bNZQaMuMs4RuUN4P6YxCfN3LQVFi7yimXJvlmw6GCr/GJZ0wUnuMTEqg6XoFCpPmTLrviDekMgxO4d8mj9a/jevCIqKdXANF/jfNGeMo9MjLh4a1idz5vcrFkfbRQqb0sNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734039520; c=relaxed/simple;
	bh=FVsAhf/L/A/1hExk6EI4BILQJE/BdwS8en2INWU/29g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ln2R2XkTlV0uS1c4yVPMpTHuTks6fRvnZpJbL+j8gQPeCYJcauM7FK+FGgOu5hX6bYJyhUyY5Da1t4hO44cf0paIhqCmvqOq0d/AZuF1CIGBAgwuoKNI40uWak2zw9iMBdAFnbcK3fBOH2VlEYXqwrXj7h9gDdC3rEmjWAG3zcU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VRcH4Mvv; arc=none smtp.client-ip=209.85.210.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VRcH4Mvv"
Received: by mail-pf1-f181.google.com with SMTP id d2e1a72fcca58-725ea1e19f0so904470b3a.3
        for <patches@lists.linux.dev>; Thu, 12 Dec 2024 13:38:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1734039519; x=1734644319; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=pZ5zZgnlUdJh8z0DW3NiXjiumc4XlLzMn30s1WWYCFM=;
        b=VRcH4Mvvyc58E9Qu0aQhhX2m3iBhDT4fRBDN5/5J3iDdzhLVto9fBzJCdoh+FzbscQ
         rN78YDyxTs1isHPnWP5OLQ1w7mVNaQN4Oqc0LRTnMtHqEB6aullglgDkQuN4NFXEi6ci
         m4qzYrRPJXBkf4tTmIDpRVIaN6rr7iuOZR89IoqlHbUc7AdS6iPVwNNgZ6m9GTj55hJS
         DqArqzaCXWwC17A6UMfTJKg3Ig9FfVf0ggK9HrAbwauMmuHkohzQl7k7l1MSsbgswGj7
         Yds9dGRSrX8UoKwjOr+gkCBTzrG6tr4yg8YeC3BX2oApeJ09T5LvhrKGaApAxM94v5pG
         eDwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734039519; x=1734644319;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=pZ5zZgnlUdJh8z0DW3NiXjiumc4XlLzMn30s1WWYCFM=;
        b=KFg03VuSXa1QFOoczNXPX4HDtZXdO+rCcI+XGtWVbYMeZW2+04qKXPxyqhw/2wPeX2
         C/+/lhJHmg+bSEgY4z80G02KmovYnnN6IseMP/ijAGbAZYzGfvtTEOrm4T+4/eeo6Lf2
         I++4NYuExSgsqDGZu2kBOL4t1uqQdIHvmtsf8LC1aH/6AQQVTkPnlk7MR6UZqIDsF9cg
         BDFhJ+PDmm0cHwqrD94EiAh1+t8R2bpHrx5BExCMcBw6DP4PpvsWaoKyhY7gHJix1stV
         bsEBacBhicAKyoxuHq9CXQLsGoZYdOHJox1G6wij95gHzy1P5QqfhEpRCZ0pAysXD5Bu
         FXGA==
X-Gm-Message-State: AOJu0Yxqa4z3BRvK/LEdsbkmWeFq8Q/251yQa3Kkh8toVLVOQDQ4WE/k
	xhqtLmGRJJb7zskZMvjjK2QGWLGH6tY/sWLAwKBGYBBARO+5K+T2
X-Gm-Gg: ASbGnct3BLItyCrxW3Eag2x3J0clJ0Ff6ZolRomVz3J0plYv9pNqCEZQ11gOLIYJfsE
	7/j7HvhicIDbkdyEFOQUsBx0LJ6QZdkNONMQZs3AHyIs5IklGP82XwyY9YyfjrXY/HjVfqrmo6P
	EuJOIbW8Z1b1SfMQxPBEWQVv9NBx/tmpPtoOpnKqZzSNMbY1pJkoq6Y4M292DHtszbXwRYrHSvZ
	78YvyM8CBOgtpAI6Y9AIsKLvVIPPZmpMtdwV1PpqLMV9Z2JFkCfSkn1y32J0OzFFyOGJ8AWRrH9
	olujUnm2
X-Google-Smtp-Source: AGHT+IGY7RCaXhDWkOiohikluaInFk753KShzMe0a+LB/ak/xr5+1bNnx0spv/17RPvzmUvXHDONfg==
X-Received: by 2002:a05:6a00:f08:b0:725:f4c6:6b71 with SMTP id d2e1a72fcca58-7290c25a4c7mr211922b3a.20.1734039518574;
        Thu, 12 Dec 2024 13:38:38 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-725a29e8df0sm13750293b3a.68.2024.12.12.13.38.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 12 Dec 2024 13:38:38 -0800 (PST)
Message-ID: <c356563b-4137-403f-9f0f-29e9b38512ce@gmail.com>
Date: Thu, 12 Dec 2024 13:38:31 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/772] 6.1.120-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20241212144349.797589255@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 12/12/24 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.120 release.
> There are 772 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.120-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENERIC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>

There is a new warning though:

scripts/mod/modpost.c:969:44: warning: excess elements in array initializer
   969 |         .good_tosec = {ALL_TEXT_SECTIONS , NULL},
       |                                            ^~~~
scripts/mod/modpost.c:969:44: note: (near initialization for 
‘sectioncheck[10].good_tosec’)
   HOSTLD  scripts/mod/modpost



-- 
Florian
