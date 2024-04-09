Received: from mail-pf1-f169.google.com (mail-pf1-f169.google.com [209.85.210.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F38A2158851
	for <patches@lists.linux.dev>; Tue,  9 Apr 2024 21:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712697919; cv=none; b=EQv/F84d6Z3OtRoAtdn3ygd8E/iXHwaHxFqQs7MexaptgGI4fvgviBlOY9VEbN8oauYjlDEh6bcFeEl7pMDBj7CdtxzdkUOK4HxQVAPI9jsdzzDqsZGXMwCsxYhBabkf/hZ374rbLNuLs1jYRcIjNDYApVER2V8KVbsaxNAazCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712697919; c=relaxed/simple;
	bh=42dEATvNCGaUTGUwu8St96PywXvLOsZrMnMM+/SYvYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ax38f/SwJrlUYiPt7iUvn0mlPoBBCSyNuXRMS96qwiMOZW2TUkkg9XKGnfIRLhfQ+VC1rETDlKTafp2Wcf9dUEn3Ibmknb5tN6gG90scwkbBeT/IY9M9vDxyoIT81YSKCx1SUjQ1Yjf/iLXYdX5pXAYovoIgRUeMCQRkRV3+maU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nYjqludj; arc=none smtp.client-ip=209.85.210.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nYjqludj"
Received: by mail-pf1-f169.google.com with SMTP id d2e1a72fcca58-6ed9fc77bbfso600231b3a.1
        for <patches@lists.linux.dev>; Tue, 09 Apr 2024 14:25:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712697917; x=1713302717; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3GDUApSH/W0nrKfuiCwASLA+8ArtMKKjr3rZqEOBcuA=;
        b=nYjqludjAL44pLOfY1WjIo73vZN3tFMiDO4hx2Ha2Jaf3oRmxOc3zor2SjyJFXwP0P
         lDmKjJtL7JMexG4DqkWz+3fRFZdtHO8XYyJlN8QCUcIiCB3vAbJf88mRCzpHlaLdfOf2
         OAcjv9FcbuMekXJpiX+HMRPyzYdHVLcdAf6D/JM/YISZHXpawNHmE0cCq/7pNCRfjNA0
         xPIPdwVlmqV2NE7i+G/Gy0gvYXWk1H56IYKEudvxa/SBBuDoq2xMWSWk5LPIPrdUEMrQ
         ueIG1p15cywbKla+siXQuv0e3U0iIIj7s17WRbOGocAWmivEY0YHP6uq2e+WQvyrRCUD
         FLCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712697917; x=1713302717;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3GDUApSH/W0nrKfuiCwASLA+8ArtMKKjr3rZqEOBcuA=;
        b=hjyoH/0tkVvhQTc+UPGFHFt3ZpFdXMDgBFM7cKeSmvJH7+S6cOpaYQSTPobxqsqJFn
         SZx0McmNP8/nYUMQYV5lGoCLTF2iu17+S++3GjyfxeNlPQRghhteRQQmHPE/Hpfsy03v
         MbUf4hVE/IZU0hlCkGLZ2VnQkp5Tp2xfU/XzSm+6mf+GxEWo1turBmcntJk+Kkj1mMDg
         KpxDu6xKV506whb5XgO7beVLsEHqrH5SxqeakxtTxW9h2aFZl2C/1Nj3NoECQO2ayEwB
         mVkqGDP2Mbpipe+UleiwIXUeJmHEtNhUx0NQTwphf5CZnjn96SKPixiuzqIW3atZ7TLk
         Ukiw==
X-Gm-Message-State: AOJu0YxmcNS1AomAiMTojewy54rr0cKeihf7zMFGA9E4gdg60RudKW0d
	sBJUpHOSSzbB2ypZ2Qk4029ZgtlTYTLCYbUSLc9LG7NIlj0CFi1P
X-Google-Smtp-Source: AGHT+IHqkSAqfWlo2m0ORVhk3eI74/hRph//F8Kawaq/q4MyOq+BQTbRLlD4f636398l8sAuw5mEjw==
X-Received: by 2002:a05:6a00:9397:b0:6e9:74d7:7092 with SMTP id ka23-20020a056a00939700b006e974d77092mr901144pfb.24.1712697917258;
        Tue, 09 Apr 2024 14:25:17 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id r24-20020aa78b98000000b006ecfb733248sm9128036pfd.13.2024.04.09.14.25.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 14:25:15 -0700 (PDT)
Message-ID: <5e823d29-fa76-4a23-a514-911bb81df241@gmail.com>
Date: Tue, 9 Apr 2024 14:25:11 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/254] 6.6.26-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240409172821.820897593@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240409172821.820897593@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/24 10:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.26 release.
> There are 254 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Apr 2024 17:27:40 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.26-rc2.gz
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

