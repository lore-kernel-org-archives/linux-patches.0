Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8011DF73D
	for <patches@lists.linux.dev>; Thu,  3 Apr 2025 23:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743723744; cv=none; b=SxT+sQW5r+OPEk1a7x27bi6d5tH7xHEXb0KVZh/d4493ZwgMvi46h6+1CHBMCshWoQ7jwyvL9mCoz2o8ZJeOxGSi51H2sUxO5HP/7bblKvMmj7dSOig9BCFTCxV91iSMSb4Or6X09P18WgwJA0zPlS4yUdQtO+TiegVXQ11PJ6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743723744; c=relaxed/simple;
	bh=yh/q+rNbuMY+pjqhXUQxsMEdyj2/yn+4i7kWgkoPIHo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Z6+xZ4XyLsJLPvaa6qNgeE/wxhE6nLqsC4q/2x8c472BIraCBS7vzx3mNYXqJ6yimfA4YB6DN8CtdI8pECr3Nt+OaUrpmJLdUt9CTxMq5l4ziAC2FZcsB81YJErGMCLQH+2hYpz43c3fPE/hAyi8akXpyVrUoVqpceb/lzBP7Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mVfbXTyF; arc=none smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mVfbXTyF"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-43ce71582e9so9905745e9.1
        for <patches@lists.linux.dev>; Thu, 03 Apr 2025 16:42:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743723740; x=1744328540; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=wkvfKktpe28S/f4k8PkmwPjxQPAqeXSFXCgD7zEYhGs=;
        b=mVfbXTyFo9reQ5eYbX1WnuH1Ckv6NpfqY/8TzOU8YUzrMmVuAdI9sB8FwlXuj7OJLE
         3uVenAC5wm4h11ZQTLohnwRjSDUDhoJ8ZwcKRlSFQBrrspjQxN/8hZ5FDHPOck1j1+Lm
         OPPExOf3BfwMMT39KoZNDwzjEXtAj4Fz3bmpqi3oQ/4Lyr3ukkqN4rVHHZDs3GPGmlL/
         +Ef+L3JBum1M3NH6qDg4L8eCNKLRRaf3jYrJZg9DMicGvvMEUD3n5Gw0fGUctFD3c8Ma
         +8PdqkulUc85KloEj3qIXXshNmD+IRuTx+N9saaLYJwG9DX1MAvHJG6ZFzF7pH9cZqdN
         sU9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743723741; x=1744328541;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wkvfKktpe28S/f4k8PkmwPjxQPAqeXSFXCgD7zEYhGs=;
        b=IwaUaElYw3kGZZ2eE0EpaH07ln/4oI0rFQw9boRRrksClsAXrhb3LtxzaxiqaR3FH5
         zo+IEUddn18ijHr6KK0oWMDWFXQyCu+3Zy5r9ikcumeVkhWCKD/PxD+jS2Vul8vN98BN
         vXkjS1vyCEKik0kqiAd5QiDx4jLtNINU82P/iz0sBh5m2+h65h3QkAAY16Oz3a0zNPeL
         NzFvkDRlrpzjfd7LHzJBPP9qJEdqA7uQn4VmdmzXN23+kT6Oa2CxIDIAXJlVIVDWUvt2
         7c/5uF8+eFcz656qQYh9p51FEKzGSvKV4pBJTYczgMvIQD/19nbTml9ezUc/0y9AT58O
         bGSQ==
X-Gm-Message-State: AOJu0YwQxFnyy6UEnvxLk04z4kKhxde24zyavJlJdTLNGZQQ/184tRX1
	tIg4ksI0aAPwjFwm6MUKJyfj5npWhiXMk4fWkDOXZzR2VEFjym0z
X-Gm-Gg: ASbGnctfEeol7igWSWKi4KAkVAtjvSfr1r7zZZeqgP5AHgb6HfYppwhobglb9YRn9lo
	6dG+O1H32rt+cPyT/chdpMbkQQDxENyDFR332mLx6HgLXw1NyUe8LEpt6OnCf0LtZfDDppa3HFh
	eyRwmZgPz9B9/GUNSC7EvMNy56crGFngmSdunobK5Ncgh5lfKflpzojv2OsaJ6z4TsVnOUf4xOm
	p27GV5pPDeG/kqfD6B9bx5L1wlj9FIfPINmtKNZSWwXFTcJymqyo49aVRdhyYSYVX2Yzryeivki
	rDoe11m87t85zyufSkbPAQrgPe91vrggyrrXt8AhzX0P22/zGXlxm7QLD+oPa84/vp3o5gQLSlj
	46wjkcrs=
X-Google-Smtp-Source: AGHT+IFiA2pBAmTCtik7KuYJ2FF48uRh3hnYs8IZzxfcylrhIqbygWG/yLUzCXuPw+peMrPhT3PzCg==
X-Received: by 2002:a05:600c:3b14:b0:43d:2313:7b4a with SMTP id 5b1f17b1804b1-43ed0b483e5mr5635875e9.3.1743723740455;
        Thu, 03 Apr 2025 16:42:20 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-39c3009674bsm2949655f8f.3.2025.04.03.16.42.15
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 03 Apr 2025 16:42:18 -0700 (PDT)
Message-ID: <8af84aa7-4353-4c33-b51d-1b4867742c05@gmail.com>
Date: Thu, 3 Apr 2025 16:42:13 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 00/22] 6.1.133-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250403151620.960551909@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250403151620.960551909@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/3/25 08:19, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.133 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 05 Apr 2025 15:16:11 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.133-rc1.gz
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
-- 
Florian
