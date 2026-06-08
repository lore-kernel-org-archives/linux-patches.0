Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD8AD3382E1
	for <patches@lists.linux.dev>; Mon,  8 Jun 2026 10:42:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780915343; cv=none; b=RyywQqbtf2epYdvspQ24ol0Cg6KEflvyDATp2npzesuxEHN8qvzy6PPFIer0uY40XeSd361fDgtPTtjSbZ2w4EO51/zkzTRdKfRg96YxXqt3nvT0fTshkhidxKVKSABe0nhXDIWyWm7MVc3AdNt848RVMBDB6O3h+9ryn4cPuxw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780915343; c=relaxed/simple;
	bh=tyFm1ydanooCPaPGXWuuurLw9oSfDkDuy+Vhi+8VaDA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WzhJkMZGKXAoOBwFVDyH+vXiFwOj6q1hoIdSAp13MRv+cypmKzifFikcUxi7BRNXq2pXvHjxYJ5n2hgEOMOTCRfGddNcxBn6FTm2g1d231ESj0qqvJlkAEt1o1f3DhqJ/QgyJBQugiMV0Ehy5UXgS3YCfdsLyJaTpv8ag7opWsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CrhbKyNC; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CrhbKyNC"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-490b64c8311so46555625e9.3
        for <patches@lists.linux.dev>; Mon, 08 Jun 2026 03:42:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1780915340; x=1781520140; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=azxfeq+XTXz75Qe37REfwqMLQybd94mTkxsSsjtZPaw=;
        b=CrhbKyNCdGFQrkdnHZLrYb9Xb95U9UaILRbBESwZMcIjoWcjnSg8U48qcOie4UCcO6
         epLaqyrLQgjWX3FZG8JXUA4b9CXUPByieYGNkuRYDlw7nbpz1rBr1MlryRSHTLCMuIWZ
         t0ch27s9bqWQ3XX80THAJH4FIcDt5s+2sNJZp39UPIBM/d5mI11k9tB85U7vT+Vw0i7b
         Ky0l/ybPwIz4iCXrl5/y8mk80VsweBhv1tfXGugnPjHSLUp5ee9UJZbz8Uzq0UzDbw1u
         VNvcEFRkHQVm3suNejfnQfXN+SutRJjVX1e3sd4b/RNz8a9hDMBDugT7np1TexlyBbWy
         1cDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780915340; x=1781520140;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=azxfeq+XTXz75Qe37REfwqMLQybd94mTkxsSsjtZPaw=;
        b=k0hMa/h4Gh2iiravTOJyl9mIQaWARjLzDoWEzbj1E9V9atZGRvJuduvsqPC2cJyfo6
         /VfiZi6OyOWkW8mM2MbNQcTYQ3SLaqxsre/YI6gzmh//UN5jG5gaR8eOgkON5jmPZutO
         K23++IdPR0D4kw0lvAgHvCG4aZ6+Pbrn0bekUktXlISaWuuyN+mCNQz2AAqkQ9x0ElPD
         gT/QSdX3fP5W/s5Rghor82j0Pyy2JYTPCsryUSY56aAy/Dwb2pzBRNGM0bsjve75ltkD
         2IxI/ZSZrN8qM5Pq5Qx8BoyzTbzC5ItwhI1IO86BPE99btD51+vwz+ZrOEqfQPXyFV1t
         n/IQ==
X-Gm-Message-State: AOJu0YxaNkIvRwvZZuvBoHYea6uyFg4VDy/DHKugRysul1WDm+qjIDcg
	5dgg6ur94wv+K6Rc0F9eJL57ak8aF030PhPjo/bjXee8qRblcA991GKQukNi6z13
X-Gm-Gg: Acq92OFUuE29S1kmvm3Q3Y1hrzGgIkoKTz0t7hKEuO2YksPrLo8ybTvyM4K1u2JT4WN
	vSJGaW7Cw8XEJxALtKxGT/pXljCSTVHSQTX8cI+NQsr44o8nNPCAegh1+QdI4PfS0VfU94ePrHr
	VSxZCUC233rC/eE7Jxa1qlPvZ4sNl0zkNXC/NxWFvK9vJSvPcjAd9+Gw/kApT+3y1SFj1ap38HV
	9v//LvVnQBOX6IPFTHXpyGEs1kAgVONr3GlGY0ZRgPzkWg9shg2j91vCLOdz324Olp8Ql9pqFNx
	2SgiRWjGIR8GoO6/sio12gUd0+iUfkjZ2XSteptnblVJivAVU07wkvJMZrvX+yv+oW8IPF0P9ur
	qHeInxdNPPK87w5qqvWS+7jOWcOHH00nBaz/XZdtEtuWamoLGBN2FZoS3Qv8dSbrfTn09j7acNy
	vGu7upGwRE8z4T07IofkZVq88ipPRoaRJDM2ovtuCuSkKLQHusvU8USHh38ZCX0K3UCZyUUK8bU
	4usrMcdCwM=
X-Received: by 2002:a05:600c:458a:b0:48f:e518:d110 with SMTP id 5b1f17b1804b1-490c2614beemr218939445e9.32.1780915340086;
        Mon, 08 Jun 2026 03:42:20 -0700 (PDT)
Received: from [192.168.0.105] (88-187-52-200.subs.proxad.net. [88.187.52.200])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490c2d37edbsm290366725e9.2.2026.06.08.03.42.16
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 08 Jun 2026 03:42:18 -0700 (PDT)
Message-ID: <e35f543d-d0ee-4ab4-869e-8d01191a5240@gmail.com>
Date: Mon, 8 Jun 2026 03:42:21 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/307] 6.12.93-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260607095727.647295505@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/7/2026 2:56 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.93 release.
> There are 307 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Tue, 09 Jun 2026 09:56:47 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.93-rc1.gz
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

