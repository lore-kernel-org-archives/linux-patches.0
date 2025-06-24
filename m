Received: from mail-pl1-f174.google.com (mail-pl1-f174.google.com [209.85.214.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 171A42E2EFA
	for <patches@lists.linux.dev>; Tue, 24 Jun 2025 17:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750785388; cv=none; b=ArS2GtGVnLt13KOhZU4WPKSpvwqJTp9ypMqfH3md7H+xSo1w7rch0o3Eg2A6dYcXLAzKj55ik3mVv1chGanh9qIjqcVI8aWTUJKaZ72p4fonXCXrWbEYAG3oGlB+U37cvoHdDCkdLTvBbC6I05JB//jUw92fcAbJ0s7jUa8weaU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750785388; c=relaxed/simple;
	bh=sA4PVWx8ekjrYSGDNwYr2uad1dOY0vxfJoJmbwfTQ30=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uW3CWqUMjSd1OZS2sp8u/Yo3APEPD+necloEQMsrczONF/LQ++W2XRNvNb2UTpnnU0aKh1kQoDQJah9O5ncFNEEEO4llxA17S/SlpW/YKupnoMm8Y/8oBhzFLr5zZrHzN3ItULuJi4Lraxa0xES/Ryj1123wbgP6fwh5AEDFWG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fZrank1Y; arc=none smtp.client-ip=209.85.214.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fZrank1Y"
Received: by mail-pl1-f174.google.com with SMTP id d9443c01a7336-235f9ea8d08so8036765ad.1
        for <patches@lists.linux.dev>; Tue, 24 Jun 2025 10:16:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1750785386; x=1751390186; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=+ASqjqLPGzQpM6LG3oMFEhZ+AGIcCwuenkpLcwoSHTo=;
        b=fZrank1YFkdsHccGBx8j3nG6/5iReI/5ws1OL8N8pqTgJNo30VlLao0WedMeZ08pxl
         V9DqIyUzaG1N/iBzw+gV0M22L2ObiXW6vBRLKb5cn35OgegySwAWsbVR4N1RpcDnUVqf
         iDCdupkCHim0W8i+c5++uVksNR6emG44Wy7cCpzEJRdhyLIztBpweEHmhcqzRSP/npEY
         cfctoRoLna5oYbq7nx69sxUeg27jl43qvDJjOo/3+hbWHdGu2NgZFREzGerUFtABw0zI
         jRVey62MdU5gEC998B2/yo79UKESqtSeec+JAfxKurQbmXJSFXeRPuZ1fUSzmbInZSgR
         y9xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750785386; x=1751390186;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+ASqjqLPGzQpM6LG3oMFEhZ+AGIcCwuenkpLcwoSHTo=;
        b=vmcwN6UQb7m6Nvms9Of738SPOAJcKJiLiPGow29YpGc8g08lOGlgNB0Bs+kKLu8PNK
         edbrb45s9JkWBc+kfKkpyPAmI7kfMhYU1MjHheLq3dckoowxcICeW8E5280mLJyQiJto
         jqZ3Vv5dxrqOs1veHYjc5L2s5W3YuDRP/89O54AFCyEDgNBK4IJ4v1NpAZDgAl+gtrfF
         hSUXTM39iq6UYESFMy9aOFFbiQ9H0PL57N9fCg60qQ1pbdQAxKlXeEweEy9PuFybOKME
         DIIUKwVsI+ohDjBFXUQE1RZSpVYei7HUIC+XXFoU4MA2C05Z0vJckA022IYa59w2yXPa
         ehpw==
X-Gm-Message-State: AOJu0YwpeXSEQdmesl/Eb+/xVnf2RrJnryVT4ANuoJBTQstWmKpZY/eU
	+s0Od/o/ynkSnKP3EfoIBKclw9iVWare8pp6qse80WisLT58OZW+PxYS
X-Gm-Gg: ASbGncsrYSv1UsNbrB0UBKUvCvOIqRDWvHMyjM8NdvQRsS0Dcmo62If0FU1g/BhT1Zh
	9uDGsGH4wTddiV5eFS/qT2NEbpZ4W8M0ifstSQwdcNh5YONF6u2kL1zpYKjOmwLsiHjEfBU1pER
	jyKgakjGUd/KW5iplvdD/7hNQcN55JOHNT+nnsdJlSk+tdK32vUZb2V41fTkBNQRPocAaGZ1XJo
	LkoJ1pWI4j28h2Dh/dlvfOHq6DN0x+NN1/Ipk8FJMNBK1OGnLKQALYg3UiXIGvSSq6L6SShNDMf
	bKl3MVxfEvcSoWq5oY0SM3QBfdhD5CvGsmQ1jGxoww6AsinpdalIIusv3RxzODnDwejOocDMefQ
	RgcZnxLUIKezpvg==
X-Google-Smtp-Source: AGHT+IG+8wM9PCZWAHORUbSJM6iY98aWcluzL9fzJbDorXFMVuqQJu7nldaiK8uVSihQiBAro4B2oQ==
X-Received: by 2002:a17:903:1b67:b0:226:38ff:1d6a with SMTP id d9443c01a7336-23823f7e290mr2111175ad.7.1750785386208;
        Tue, 24 Jun 2025 10:16:26 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-237d872a3d4sm113452005ad.239.2025.06.24.10.16.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Jun 2025 10:16:25 -0700 (PDT)
Message-ID: <91213d76-0abe-46c5-9ade-935224bd6238@gmail.com>
Date: Tue, 24 Jun 2025 10:16:24 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/288] 6.6.95-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250624121409.093630364@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250624121409.093630364@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/24/25 05:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.95 release.
> There are 288 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 26 Jun 2025 12:13:28 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.95-rc2.gz
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
