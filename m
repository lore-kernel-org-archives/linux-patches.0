Received: from mail-pf1-f180.google.com (mail-pf1-f180.google.com [209.85.210.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE05847F5D
	for <patches@lists.linux.dev>; Thu, 23 May 2024 21:06:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716498396; cv=none; b=qwYh+yIW7Sw8sQmEl7lsrAEZr1pxOUV3bNImD38oKT6sMTEomAlV18hJSNHOj15G27f9KBe9FNgMJDdXW3Id+zUPoLEiAsjnf4667msAOZ8IuGlGngIC1Xi7zU9moNfczXCvK44wilMMbYU/Uon2m7cQnh26UeRwVIJVimuU1Ec=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716498396; c=relaxed/simple;
	bh=pKD8sIzMjawIjx8TgK8/CugVLHIN9wwV+v7SX4LeI7M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=K7POdMrnvrIrrGO9BMOKKDwh2vKyI56Ifa26IkfzGT56D3f4TeYeP+JBjQRlRcplGchk4d1wYzXB6iiInWIB9jVobsP6CgOBATQBQbm7LHSlmPPF0iCmbvUrh52wki6rwXNEDuDQHySuqzXQG+w+ASjUCpLMqrdzIiNHHDXoQXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TcLI45aK; arc=none smtp.client-ip=209.85.210.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TcLI45aK"
Received: by mail-pf1-f180.google.com with SMTP id d2e1a72fcca58-6f69422c090so3385563b3a.2
        for <patches@lists.linux.dev>; Thu, 23 May 2024 14:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716498394; x=1717103194; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=OTQYbO81rVm1d7lRu0tL1hZxpq81q3UNDF+EXPIQyIs=;
        b=TcLI45aK1k/MT1G+UGOINkBpjRTBlnQnLwAzEgxKsqz4y8O70sDsig4IiO1Rpi8jSz
         HQkxzzoiFnmZmYDmbZeP7AIhwB184WK9QkyvNs/O60CmEIsoDBCYVc4Bw0CDm+jeywHX
         RcFz8K1WW/UMISi58MvJyvLNmi1S5Y9zfWtg8+JoPncvqgcz0RIPxWD4A6Bhudv/ruKJ
         uiTZ/2lC0/nHRFTaYe4YQd2KAaHmyYLQqNnW24gVKpyKHmvqGDbMWG+8jAN1xlm+bQ8B
         d4INBbOvCr6R9MFRdrS9j7iayHZDqSNih/+Gv0epz/FKxQUeoExVrQysrVz9UtL8tEhd
         MxFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716498394; x=1717103194;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=OTQYbO81rVm1d7lRu0tL1hZxpq81q3UNDF+EXPIQyIs=;
        b=U0L4IhB82S/vkHujnd3mDsAw5kJ4ALnN1tz+MZqIZJ+EeZFmWF4zpUBiQ8D9vxnDyk
         LAfvN0bW/w3n/ErUGxeORyMky5OL4mEauc6FVEcRGDS8y62CzWuWnXPqW/pXBDRAp10z
         WOe4RroiisB+j8Uk1WpActh3thhfabjwOAjeiz2EwS76TRmNbu6KLs/t42LwQ4Q7xkTS
         b/nB5+DFHy+nx3wWePCcZm7Bq+4ADIStCyovOh+D6JauawbQr1vb9fHYU4EhyXeMNGkL
         PXPuLsLTn3VidkS/sB8r3scl7jTZ/mIiwEH84rtoVd7k5JLEiMZFcIWSkRt1FScCzY9H
         x1Vg==
X-Gm-Message-State: AOJu0Yw8SeI+Uiiu23vduSLBReFQT6mPOVG0ZVT7zGRsFAVsCa7+CYIW
	RWkLfnKHpL2sEpnBRn2Sn8wkhiahcu1E6ERvH5GP6SaGwYF49XNO
X-Google-Smtp-Source: AGHT+IFu8eH3wryZgm20YQAvXwmv2wMxXRUbiTwAcGLlf4xqZlHr+NJrsBs4mNDXckPYZS2gAZKfmA==
X-Received: by 2002:a05:6a00:450a:b0:6e6:89ad:1233 with SMTP id d2e1a72fcca58-6f8f2c576d9mr396897b3a.2.1716498393894;
        Thu, 23 May 2024 14:06:33 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 41be03b00d2f7-6822189197asm11024a12.20.2024.05.23.14.06.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 May 2024 14:06:33 -0700 (PDT)
Message-ID: <84dce939-ff26-4179-b466-a4e5f8b8f104@gmail.com>
Date: Thu, 23 May 2024 14:06:30 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.9 00/25] 6.9.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240523130330.386580714@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240523130330.386580714@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 06:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.9.2 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.9.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.9.y
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

