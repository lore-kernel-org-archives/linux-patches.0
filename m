Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A4B828003A
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 17:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750786234; cv=none; b=PhxafZBvFmuZzKfDgic5U+/xO0jFo7Oyv0bZXYe7U8Puqr+GXsBPhMeB+yfhnJa33EEJYe1RQWH/MxYhqlm1kv7qjLHLjGrtM9I7ALfu1QOro48c8NKPRL+ovINd3UhWPip+3QpXOnSI1ATvLRvSzyMl3rqy+XCuewqz3XLRWpc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750786234; c=relaxed/simple;
	bh=QPmbsM3vCeQ/6N4tUAMhtC6ekMVzqeWDDDlsxvEEkng=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Nsm1obZPp78v90nN5rBSKtoLczmIO/b9BGcfi68E1FsoStYvMDP7sQWuXX2fXDJnrn6G7OQXd2S/7yy00KLxayt8bfp+WooVtCllfFUWuxNQEKpEoDVpf/jFK7k3klX3sBGmVUI+3tRveEtxJuziCN1/OQvwu85COcxLVtgOSg4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OhaTg/Fz; arc=none smtp.client-ip=209.85.210.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OhaTg/Fz"
Received: by mail-pf1-f173.google.com with SMTP id d2e1a72fcca58-747abb3cd0bso435b3a.1
        for <patches@lists.linux.dev>; Tue, 24 Jun 2025 10:30:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750786232; x=1751391032; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=YP+oZ52shuYxDzYWmlHOs+Uz2OoQ5Id/H5ia3aiicxI=;
        b=OhaTg/FzOEjI9jPdGhhsPIr2vOZZvjXX3xjKWNoeE4uEDCvcReNefd6W0TSWzRFckM
         n4I9/NgroR4/gxJM77HBfIsXr8GRD/PELJvXm15EZ2LdvtaVIVkmYEeO5Z28SnhNZ6k+
         E0Q15QSWmyZUP+Mm8YdFLNCufzMWYoIN7qXtUFt2GTAZC+KGMQKfwKiz33m0v0fRKmTU
         qmhY7D2QGr+NcMVpb2t0O9nXe1S2ZNASdlY4umEpkUFZM1rQQJYogoJ5Yj+MqiUGFhR5
         a6casYtuwsPNJfdV3Z9HZTuxDhswePs/OxIQiB1QCN6svGXvxPa1kafn3hE/9eCBYLPj
         AFkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750786232; x=1751391032;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YP+oZ52shuYxDzYWmlHOs+Uz2OoQ5Id/H5ia3aiicxI=;
        b=kpTwmiVPo2cNLeqV6VNdk9rRWy2MpsgMCnvAS7gnwQcsjFjNf4iuXm7VxZkXbVvRGc
         Qbvad1hBcuFae3UOtuaSq91MVzh+y29NL0zq1MvrdgJxEYrdWDexeuSjQmmEjeAsnSMq
         MRI2Yy8W+I4Hm/zPWAkhcqR5aVR+U+UfTNBKq9JrR57BMmClTVKnitKb+DXGZ8qcLgWg
         tg1DgsiD3DhtGkVquTIMt2uFPCgKkExGu0ZysXS9ziwa2qZNTrRGLASPaGwR57LER+x0
         tuO69J/YlmpBzs3OOjSbo7Y4fOQhT5VNEYufALqxmoXGQ8N0Os8IZnuPN+fdw242o9yZ
         s1cA==
X-Gm-Message-State: AOJu0YxhjL0N1u7jjo3O/d0qIZJek5HvMrk5X8GmFBB+pitp0m8YW1iW
	QIbl9xJ+aFN2Ht/S58ta9cAblIGYeRnV9PuItsmTvZlKP88JuCG4dEYO
X-Gm-Gg: ASbGncuIzSOrWhWrl8/GS1/toOLER7x9TPrklnGTEYJbrCMBuGqFaZI23Z8f57fPuTv
	6aXYlG4J8LxUs294UZTuDxEPYrFkgFSYR+8QnZndXs3lX8p+BY4KEsNSeksJawvPNDteZSDvEbS
	s9p+Rcl1FB0vdUlaA4yDvVubSANu2w1ZQpTdsr42LDjZLcVlH5NoeLA1z4TvPWPv/11IgV16YzW
	HjKhYBIVeKtFdVSUFGHI/uzYZV2dxHKbINN46WW3Nt+Sq3/zHE8bEvDBlM+Jqu6Y4bdZZwzcB5u
	iHMWYYAtZ4d3xcJqtHbL4jY+aIOo8HBtJeh+bnpyLICEhIRtjwCaC7sWmWYSHcKYQJPjy+l4atk
	w/Ge6zoNU/dE71g==
X-Google-Smtp-Source: AGHT+IGwKDEzWKv00qUJ726dLtfdN6pVZrF6NIdjVegKN6GGf+TCv3bwW6A23rylIeTfduxNFcanrg==
X-Received: by 2002:a05:6a20:a51e:b0:220:7e5f:b2fe with SMTP id adf61e73a8af0-2207e5fb348mr48668637.21.1750786232324;
        Tue, 24 Jun 2025 10:30:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 41be03b00d2f7-b31f118f7d5sm9647999a12.12.2025.06.24.10.30.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 10:30:31 -0700 (PDT)
Message-ID: <5c96c033-7cd8-4d76-8f85-856cd62056c2@gmail.com>
Date: Tue, 24 Jun 2025 10:30:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/413] 6.12.35-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250624121426.466976226@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250624121426.466976226@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/24/25 05:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.35 release.
> There are 413 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.35-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
