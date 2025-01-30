Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F20FF13D89D
	for <patches@lists.linux.dev>; Thu, 30 Jan 2025 22:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738275972; cv=none; b=Gsg8B7Sw5/6v2BZH30qRdb4KQ8LQRoClMcjlWO5Hir0hQoNGMtKWn2I6sQJmce0UqAi0rWTYM5KrQwQ9SCzu55tXbfHvDpNYvuRjRXBths/0c+bcqzZoeThXH+jWi3JZOthLFX7dfTgygp/U/ZxiMoPR5aiD7DrQgrDQFpib6qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738275972; c=relaxed/simple;
	bh=xHl2SQMgOA2XBZOrSdNO1kp9Qrn0rIX+mKbYFjUHk+g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=O9QfX4Uxy0IsQ+0GN5VUnfPuOdNeRrWfuyjIA1ruDiH1mhqnrH9QNY7rugfGptNm+vDIdJUEUArOcv6Rh7J+mHuEZW+DHnHmXa05XVmGWHy1Aemj4gOWVhsfGzfq/hMGNXvyiOKuJId0Se5wVm8bgsxZOlcHtKmvjyk1chgs4ko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=O0rpK+Vu; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="O0rpK+Vu"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-2ee8e8e29f6so1845350a91.0
        for <patches@lists.linux.dev>; Thu, 30 Jan 2025 14:26:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738275969; x=1738880769; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=qptudTT3cNZ8XsCDenWkL6YV3Q4JTNcPbCB8ghHw3uE=;
        b=O0rpK+VusSSYJ8klXXf6/xfh4XOoXTDsdBD8YSciBAUSeWvvtkoWvgxScIlOBvXQLz
         iqaHLuAp1EIKBP0f4drU+fDdbem4vCE+xBJJW5Q4DHOoRTygwMm4wpcIzVxN8KGU1DX/
         EpAk6D8ltRytTQ30a3WAoGK0U6RM5HRu75SW5A92xjUIf96M83SA1oV78zYcDLHVbNic
         vaxXo9jgDiTxlWiAhVhLyjl6DY3X49AeUTLFhHXpc0PLZAad+pOqs5eWAoQwb2iUdX1A
         SaRLGHlnTAS+msiuxCX/iqOQT0szbzA2EEXg1l6UKRdnWSvnaaGZCXSxqbiFJ5cIVIY7
         CJhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738275969; x=1738880769;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=qptudTT3cNZ8XsCDenWkL6YV3Q4JTNcPbCB8ghHw3uE=;
        b=fxr2rB9JhxaYbJ3JWxftxEp8mfyAVT1Of/LbAVQbyu4oxpN7EjEw0jTzO0KF/Ty4XJ
         /y0wlZsXe2391+1EaF/ZxPDy+0RE/okzQtb4zm0oGK8/9HO7loPh7i97/MCn543utpCH
         ATBVSthah1U2SiOTO9aSR6kg5eYaxWLsnrfw2oJX2Ju5XiiAXnVWSViflRIzp5fmAjLG
         RLPKOEMOITVFFoCwz+lVtJZsSXdFC0RbUdc+tzBouw48ulqUkN0S/balue305LZocxQG
         Kwsd3l/GtJz/L2/+HsxikCQKnS9cnE5i9JOKR58EVKINA2xnpc2/1b6+v2vS3wsbGnfL
         UM7A==
X-Gm-Message-State: AOJu0YxE5Tz5cD3WAirR3sXX7IBq0ctsFoCIASfXT5Qgm9LtjpkBL6j8
	l0qwc2kGgGH+1+IC0ONkSSgBBzmdTIq38s9gJzbrzXTXpk8S/tVR
X-Gm-Gg: ASbGnct8Fs48hB7Ri7Iwoyar8h3OobACgaTmwEthM4ZIYNCB8ludObd9J2j04GZ42TH
	m0s9SB5joJpnn3iiSl4PE561Y1YK2a/mfv9Z9UEEew9mhDb2xZDooUknEbanOFrQCGX9HtO8PKt
	Y+ddVD3BV6D/U6OmXdNeNse1EiZLlA7OJQEBJAML5gJAdnJP06OXhwkac/bumuvtKr8nfIubI3/
	1ysv8SudFMyttw9CkRpCYD4CUrF9ix/a657gJa5C7BmZiXXuDYRB1N195q/pJYlU03jdLpV+k+5
	arPYPF0NojBqyEPPc3Xi0OX6sqiPWPmWYAB9v94Q+ZM=
X-Google-Smtp-Source: AGHT+IGK07wTgifXspdE/ygnEIrvYCe4ktwMGoUL+Q/ZZyV5X//pqHLw9f5VXS1Xyf3fTr9Dt02PdQ==
X-Received: by 2002:a17:90b:4d06:b0:2ee:d024:e4e2 with SMTP id 98e67ed59e1d1-2f83abb3be9mr14009883a91.7.1738275969016;
        Thu, 30 Jan 2025 14:26:09 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-21de32ebf4csm18997975ad.141.2025.01.30.14.26.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jan 2025 14:26:08 -0800 (PST)
Message-ID: <0a1af8e4-2fe9-4a0e-a9da-f93fa9716767@gmail.com>
Date: Thu, 30 Jan 2025 14:26:06 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.13 00/25] 6.13.1-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250130133456.914329400@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250130133456.914329400@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/30/25 05:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.13.1 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Feb 2025 13:34:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.13.1-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.13.y
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
