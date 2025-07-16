Received: from mail-il1-f177.google.com (mail-il1-f177.google.com [209.85.166.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FD526D4E2
	for <patches@lists.linux.dev>; Wed, 16 Jul 2025 14:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752677604; cv=none; b=k6j6ZuOKGS16iHzP3PATF11fjxttK+qSRubAJQFPuNSw7gFPEb+RilezmQ0SOTK/pvUHZ+gJWrF8+iDXuEOzClLDnPsIR1rVq7rvY4XXDCirE1fQkTTrt9Z0Rr+3FbGX5GyfygZYMHpVKHA7aH1yD6yXVgtkc9lI8d4v4jEdwOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752677604; c=relaxed/simple;
	bh=aObTEVOu65cgXJJYv/X83Rx9FuUZIVPF7FW9+xhRJKE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tt6imUGaZCzj1s4GoWXg6nNRSYxgkPVQggQOV7+eeKi96DZ/WvGdT79PekeF0sXy0efE7uoifKg7GgCKLaxtVncqFwybElrqQqqYiD6sIZ+fuvjTVVW7hGPmQkJyOkOJEnj+23fxY68dgwxD3zcNbTH5XzcZHx5DSXqoDEC/AVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XPu8MV2i; arc=none smtp.client-ip=209.85.166.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XPu8MV2i"
Received: by mail-il1-f177.google.com with SMTP id e9e14a558f8ab-3e059b14cb1so4597585ab.0
        for <patches@lists.linux.dev>; Wed, 16 Jul 2025 07:53:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1752677601; x=1753282401; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=70hqscYKUMhS36bD6H7W3bD6jK3TRd5Z4bT4xaOOeio=;
        b=XPu8MV2iz+sLoOyP0DyXXOpZ8KIKdmUZey0SqB7JWfsKPba0S5Zf40XO6Do5+pS0jC
         020psBMXkDoCIrqIPnxAAkZ2cczePSgzNvgJobaUiHrZ7H1F22vtdvRMMlmBXYtenmIl
         GfQDYy9jAeWAIo0toSzrspj6kgDxPNyfZtVhQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752677601; x=1753282401;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=70hqscYKUMhS36bD6H7W3bD6jK3TRd5Z4bT4xaOOeio=;
        b=rZByW7G7txxcI/tNaiV6hX7Oa5MaZ5qUFEjR7VBgnxLjk/qfBzHX3dCktEECzrDQ02
         hExWlL4NjCga/kCeNy1q0FYHx6QrWErx6fpsu+GiHzgSkcVjq/Bdbaq8fkNDqCEBwUVU
         97oyQyUQTJ8dOGDmnx0AHPwmh3gdwtJK1P4yhmEdqvpBBQDElOC0EbLVdf/2+USqM+Qp
         RHgrDl25Z8UVdfNkFlorbdwEtq2UM26RcSxyIEnxbEA0BX+06GDeHyc7eUvoqumcZEKX
         97EIwSfLWtkKNm/ijvPy3PiAg1tFgiYVx/Cfo5moJrAIRNTFEEI75Gr/JPS3d8q6EEyb
         +czw==
X-Gm-Message-State: AOJu0YyZeHaUTntdNCSmGtpL7B0IXAyfqXz3ja9TWNri87vnyrACIgyn
	Ns8mrnci97MSc1JUb/qmwzF5wMPrXfTj9XbtIRWngKYgUPBDwhwMIvmlOU1NZ/oCTA0=
X-Gm-Gg: ASbGnctoaNrUYi0cYlSKHrTbhWV2cUTe0rIsSUNaKVL+sWg4G1eHSHZeJ3GoU24X2Cg
	vtRvVDypIYhQ2sJDTeHrfLKe4MVpLynvXLOf4ioA21ZcNnLhpP7/2e/KxoOE+PMp9aY8/AeLi1n
	RztSenyLYVDezitAVJVYIMxXa/ojV27BEqbDcHAFnZ3nl0lAxjAQ592yAuu+qSz2oU+avz53KXU
	LZccHPVFBFwg+Uc6wOHp6Q3EACIh+n34+Yxir/qIVlhF9tPy73D+wJOH0/VAMixxf5e47yRlv5q
	VCTD5h8W1cKz972KaExuAOnvfAvVjSnhbNlPFHe7vKQdYSk9RiswgS1wlAEy5AJII+kr5mtk0/0
	12WXFETfVD3K25W50cuHahyHYfS76qh7XcQ==
X-Google-Smtp-Source: AGHT+IG0GNVprRljye1iFIt81jTPpLRCL9X5k/6lyQr0UNEP/58Gv2FGcMU9mg9LCJMzEMaDolb+wA==
X-Received: by 2002:a92:d64b:0:b0:3dc:879b:be95 with SMTP id e9e14a558f8ab-3e277c6ac35mr57796965ab.5.1752677600268;
        Wed, 16 Jul 2025 07:53:20 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50556535f2asm3080620173.1.2025.07.16.07.53.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Jul 2025 07:53:19 -0700 (PDT)
Message-ID: <631a6946-0a8a-4f6e-ab5d-f9b2d0585817@linuxfoundation.org>
Date: Wed, 16 Jul 2025 08:53:18 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/109] 6.6.99-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250715130758.864940641@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250715130758.864940641@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/25 07:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.99 release.
> There are 109 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 17 Jul 2025 13:07:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.99-rc1.gz
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
