Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A502E6CB2
	for <patches@lists.linux.dev>; Wed,  3 Dec 2025 23:55:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764806124; cv=none; b=PbPF/oGSUvSGdltGmK64YF96aCfTkisQZavesH+m4S6wro23TQBzQCCiFy/hvgdC6hvcOxk0Vw5vn1N5NHBKfbq/7jMdY9kCEeERhcXr4aMsdCntv6HBP0yPfIFMVAV2RiHfc4WsEvpr0qSZX2w9sJT+XXNu691zr3uqlmBj/BI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764806124; c=relaxed/simple;
	bh=TI2fK4uIvAg0wDiX9zvQGGRTrBKJrR/dr0pn6GaiD3s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UMJpd69EPVcC9Ht6Rgi2PmfR9Y1O1xrpv3nQ/e9TmjLPHnOhE87BZ/SpWi/7XyYDrVkA99MAFtDBbuC7LcBGICnE52Ypivkt1WYirD3V2I75puYRvoD5hf4i2QjxdQUi2zqMfqSPEYfrjQFiIHIGB6MALFm8x+kakuE5HqHItlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ThwG00Xs; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ThwG00Xs"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7c95936e43cso97978a34.0
        for <patches@lists.linux.dev>; Wed, 03 Dec 2025 15:55:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1764806121; x=1765410921; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=um5TvcK5XxLxS4nCrV10IJfKpreOaPQmAH0ISfnvY/4=;
        b=ThwG00XsYcPWMmZ5AvVAdy5St+9ZQl8rjmiHgBfJ5NFCxsNXHk/d9N/m3OPdRCdC6n
         dbHCId717yp8JuBjoPxto2YWGYr7SkXT+bBtJDkRNmAUM/Dj/jPuJGxiZYyNBGk/f64h
         0mxfVIzvVRAGLp03HaYpwF5+e+Wuc6tsdDGKM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764806121; x=1765410921;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=um5TvcK5XxLxS4nCrV10IJfKpreOaPQmAH0ISfnvY/4=;
        b=itpKnoKug7lXF9rsMUhtt3Z8nTQISNBe7fTS9LbjmA3jWLevNyqYqKPgAIwp/2sjNr
         MmQUlpd4JSD5EaVcLSwmov2fX30DUJBWoW0bSbJVm/VrPxfmKEahq+/9Jv/LhJ9UeGmB
         HT5KQ98kLY7wntqaw/25cinJFzwkbTc3EJC8KN7EZyf0ev60Njf2UkIjUUUH8p9VzGsU
         8c4wHe1jR/WQgNm3zg5EdHr0Y6hszK41ASmt3WcHj0Axw4+KdJ/FRH0lUWqxoSBJQzSb
         Gai7HJ9Xk1JwczrUZGaCMnYz5DdtJIhAISLLGLz/DtMQR1NQKNl8CVXJUpd5N9h/vW0Q
         0c6g==
X-Gm-Message-State: AOJu0YycEp4GpuOBu96eqOopRig7hB5c0JVt5xba5ih89S+kL4pq7Ocn
	LExoCKAbdtBdmfh9XaQxm6cM8SLHIjEc732i9XRCr7Lnm8HIuQDyk4bvZA0wtS0fWJE=
X-Gm-Gg: ASbGnctrt7BFjVOd1CdsER3jiRgAsSJo/SWgWIBOslzChi0GcGHEm3xD+HJ5x3X7EZu
	CHdh/7ul9PmVPFpjsdNjwbG/aF/wt4HlL/datFiG+gMPYf47sw0a7tTQvFUVU3aL/FePnMW4VA6
	wnhtiLDiMkCOH05Gtv+egpjQz2FCGzjSrDPibnXolERz5QvbrOk2Z80ebGnHE6mGaXXWZJUvP00
	drPK3CISZ6KvilNiKFkQJ6cHZk93qlGBA0zG0oN7A1/eM/dT6rnOUBcDaZ1VD54mQuncQjpAgwR
	2lEyl23qUKafhglToIBg7gUCmfVfr+gL185FpJA3/W6+0Ui54sYaFVjeaDwLrG+I6j0J1bT55IR
	29l3TbUpAclT6WDmLgDo24s5ZPN1Gpz3FE4mSc7mbKiuiIEziLI+vGNA31OIhoC9CnSWH9qJDFc
	fwfFX3nv+uTyz05GNSupaJqY0=
X-Google-Smtp-Source: AGHT+IEUp+ZDnKfcWMM2+K6BqrUk9DPE8wqWpq75W8szfOEgMKPkZovh9najOUi2FHBPAkVEK54MsQ==
X-Received: by 2002:a05:6830:6502:b0:7c5:3045:6c6f with SMTP id 46e09a7af769-7c94dc04ca3mr3907160a34.20.1764806121487;
        Wed, 03 Dec 2025 15:55:21 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-65933cc2b36sm6629525eaf.12.2025.12.03.15.55.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 03 Dec 2025 15:55:21 -0800 (PST)
Message-ID: <4ca25a40-ef8f-4190-931d-c44c7800e5de@linuxfoundation.org>
Date: Wed, 3 Dec 2025 16:55:19 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/568] 6.1.159-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/3/25 08:20, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.159 release.
> There are 568 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 05 Dec 2025 15:23:16 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.159-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
