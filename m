Received: from mail-pl1-f182.google.com (mail-pl1-f182.google.com [209.85.214.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE005189B83
	for <patches@lists.linux.dev>; Mon,  6 Jan 2025 20:13:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736194420; cv=none; b=pDpOhxOieV1Fd1MUqxtfE1LoA9vLFCjBu2JvlG2hr0bySSuXBWaxlqQTEjJOqJRax/rRnfAMFMpWXnQXrMLzoqiOZDdq7EAt0rDKfs0g4q4EyoyuLYs8RYXkYPBbMOFN4UFfr19GhSwfsn9mOYxkR3lr69XZdz/yWT2mM+C32Q0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736194420; c=relaxed/simple;
	bh=pacammo0HmgwREbZ1llTIvIRXBANgom6uS4A1yUhW9s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VI2IU1/NtJ1Z+6nL+OUo0i97S6nxQLfNc04HuOoHfsFYyTfbVeJaOZinSof09R4adz2IChiwMTxVkXUOOC6JC2RNVJN3QIO0T/RKVmOIUGObhE7As8kfbi1nbjSPqSul++4xwGK2VykFOCqWSh2dRfsA1ICzOcROhQ49nrVYfmY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cjlJRHEf; arc=none smtp.client-ip=209.85.214.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cjlJRHEf"
Received: by mail-pl1-f182.google.com with SMTP id d9443c01a7336-21628b3fe7dso207607775ad.3
        for <patches@lists.linux.dev>; Mon, 06 Jan 2025 12:13:38 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1736194418; x=1736799218; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=zMfl5wajtwnH2/i0QYRNyn6Hi8mJPmAongVpEHF0klg=;
        b=cjlJRHEf1tM3xrGpdopvggJQ7k+KDdqbLdQzsxmWpfzS6svG2tNWtcfbQajNVTqBwB
         a/pEFxbji+EuxMZwgGEVCNPJqAd8gTF0am0kTKP/sX5SW2OH4ucmz8C3HCo6YNxZekhC
         Cg255NzQEORTJp0r8yJEaWwLBRDVd0poYIc8+FyNvJrftxgtu8wrVVuVn3GP9PcyF3m0
         zw9HwLyTr3PGTmzE0EXSyGkO1ar9hTU6RPMiheqhXQYfG6CY2Wt/xhWBeqvH3/sB0SCb
         EznnEASWgIOKZJaH37bAYsytjzMvDRnYowFyqz1pqAPTZFc10gcKhjHiCahgYusY/EQR
         EVJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1736194418; x=1736799218;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zMfl5wajtwnH2/i0QYRNyn6Hi8mJPmAongVpEHF0klg=;
        b=PjA8Yd8/o4WVMjKZ1i4thQ4lv0XWfN/l6XJzdVvRF0mV5D1bdybDG3Cb9kpnl9oKLl
         Vw21uWQ/skRdy+gla/FeIJut/XvuCmmgEjURLtAEbj+5SxEkyDoiuX0G8+bI2bKsZtSJ
         XpnN/STJinKgj93gxDkoXOx+/Ia83v3q6/YFICOEfxIzOjFmTLhmHIiuac6EX38a5eQw
         m72xcjHciloFf2iHLOEcbYYVcSTowIRzuboAB+ffzB25dtgP7XtUXsAjABD+DYzuDSng
         BgtJGlTLJgM7l+sJqiDOaFcrpTmWnauP1Z7i6P0eytatcsOsptuh+8r+sMNoVruWx/n8
         I5Pg==
X-Gm-Message-State: AOJu0YxBs3RDF+l03Bnv4Ty1F7lk5puRctBa4jYCkThXYAzcfogfbvjX
	g6BfWkdvhOCbYy55CfXr2Jzs91JXjNNVdHcDbxkP9/t10fmOi46b
X-Gm-Gg: ASbGnctm+TFhpFddBJeYjD5yy52mcKe5TBtJ6H7Yz9zdqS07m7goLeKeYdeDzeiSnnm
	xESThqT+Q1rP18ThR98948Nd4uhhMOYFZwWpSZU9BokhYXWnDf/H5p7sNBBO+4wnsOGHErxshMD
	AamX8Uji9jZ9geqH58E4arlwuZjVyTuzNg7DBLw0mJSYrBKSkve5rkZ5iSdt/XAJHwBeNk56mlc
	JAkQDOMMN63kt3c/8/y/ugA5gyqNjRotfy8qg80QwhWigIGsfaz5stQgeTONfnInb4O4BNm77V5
	1z/V/fZN
X-Google-Smtp-Source: AGHT+IG4Y2tk6ZkTUpCR7Ca4HckovEkC6uyjMuWkg7+S5e4PNNnew8rXZYNp6DAx68tc77u21aEdGQ==
X-Received: by 2002:a05:6a20:c88f:b0:1e1:dd97:7881 with SMTP id adf61e73a8af0-1e5e05ab1c7mr88751600637.23.1736194418084;
        Mon, 06 Jan 2025 12:13:38 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-72aad834cecsm31787135b3a.70.2025.01.06.12.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 06 Jan 2025 12:13:37 -0800 (PST)
Message-ID: <9c16ba71-5732-4020-ba2c-b676240c0d8b@gmail.com>
Date: Mon, 6 Jan 2025 12:13:35 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/222] 6.6.70-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250106151150.585603565@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/25 07:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.70 release.
> There are 222 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 08 Jan 2025 15:11:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.70-rc1.gz
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
