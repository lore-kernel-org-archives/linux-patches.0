Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D8FB397332
	for <patches@lists.linux.dev>; Sat, 20 Jun 2026 16:06:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781971578; cv=none; b=mP7wJFQbl7OF2/l7pXyroYvR6m/kQvrf495Cn1AJP7+qMpmP6+q6M4ZxQUywJUvyHh7CKmGTFaqjoqTMdB5baCE6h/UGuMiW1ZCdera+t9rSPKaJ++129Fdf3/KtAAYTB0eVFmwHXhco4oSVPQxdP3K+w9cRqMRyVf8/Ct7JHqA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781971578; c=relaxed/simple;
	bh=GYBR2fRvLo9AbAN9kQirI7hsgpWWk1FF5QW309PUpCU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Rrm7uz5HtHZdrZoAwDMWQvrym7fAPos02Qs2vObboj9rR+7tebSXBe/remVRxa2FmIi3D2or/9UMDVf3vESzrTAcCsxf5uuGEy+yW3rr+QKGgOeD674XcgdYAdnTxI2unmRLKo+fiMUVV/xtwwHdm3ecPWlN5dxpvMdfzbkbCEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=mWcTprt2; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="mWcTprt2"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-490b7866869so29336195e9.2
        for <patches@lists.linux.dev>; Sat, 20 Jun 2026 09:06:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1781971575; x=1782576375; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wwI3Ux2mpaIvVIB4hspGkGT9Oouh+sNJpjf3AsIcSBg=;
        b=mWcTprt2P2+bdhZwLU26Zpi87tkVFqwACgNbw2p8iA4HVotzlPsw+zPyP8hTUK5dBH
         7X5OHTi6kHhnNnec33PrgXrwwJpEYj0I/IaHPevjtanseD6YdPZQYej7gmTt76Ua0z1q
         ZCQuNBiT5NFpj1TUosETKTfIGslPuQuo5r3J9ILYUlCVbM0oNUAFqevW8wx+aKdvWiCA
         QuspP4p8q+LKRGf1fdIHS1q9VIkmZLBdtjSO+MAsZJsO2hYiG2hHhJKn07AWCi4GPyvj
         pU+U8DICeVFeqoCwo5GhlqyU/BsBuCS2H1gXxYBL0Myiq6ys4Pex2ytaD7CdnPdK3f3Z
         vuFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781971575; x=1782576375;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wwI3Ux2mpaIvVIB4hspGkGT9Oouh+sNJpjf3AsIcSBg=;
        b=qVO/hXv3SdeZn/NrIAvAIoeboAZKyLjmzmY1EoYQOV5mI4Xs/X32Bw6c3McTVbopR0
         8S9bznHXGuhG1I8rio/cEeZ2fx5VxCtuqsUMeT1+XsfecelPD6rN6zW3cpW1XvRE5Ar9
         gnFvJ+8Y1Dkov/t3ID5kK8jYD6d0XfysnEuxIOVFMNILLB+zOlRldO7HIReOL6F+uC9k
         CWUphkG1tL6VU10+uahkT01Uodxgz69HBvSW9djPELUBQf3S4AgO4bRQgQ1Hz6oWYfS5
         4aUk/S8i6HjG46vIKZ7PBiw/XYoQyO7YHbfz28PhdolIwqmUsBlJGkA46GVsqRDM5Sni
         MQgw==
X-Gm-Message-State: AOJu0YzEn6Vwm8imV09kJmIeX+S8GUSM2AFZBMT8CMkRRLx64iM9SVpu
	y9j1aBLy64OIKp6IPD//dMNpFLu8+ILyeEoflsqamDzr1avlSnDtViEH
X-Gm-Gg: AfdE7cnFIfPJGprwz5TDSaViasP9ZYYHNsvd2jwUvK718QoSFAdbo0kvq9hGiZsVtqI
	wkDQsjVJDACSXEojIsRBDwHIlKN5I+J3J6SjZhVffMbjb/MtC88+fAHyrGIyrwrTNHvnbV9ra+M
	RORgOd6TR62U2qCL2KHK1kZ4q4K0evlAXwYg4t/O4vM5geF//415GIOz89ZpPWyYbcE332chRMi
	+2Utp6Rb2nYfFb6g26o3x7vP692OJE1M/yYcLtQ6EhNhJLqWvF9gJ/Ipa3K/fgNn17E2IKmuL9i
	IfIJdHHCs4qnZT8vsWJrq7TvEiaqjPjGdyVvrhR5V6F3QAbkqd+K0AjgPOL/lX1IEWJLfbMYgKY
	+gpjax55MPFBfjcK+hme/fCY77pqbyBnYT/p5UiSXB1YJ/0gDftqBPQGyl+EI26DiHTTZfGzuBZ
	upBSNc4eVGgy7O4D+8SeLO8IYFCNP5PQ==
X-Received: by 2002:a05:600c:820c:b0:492:5030:5e7b with SMTP id 5b1f17b1804b1-49250305f4emr7110645e9.10.1781971574502;
        Sat, 20 Jun 2026 09:06:14 -0700 (PDT)
Received: from [192.168.1.21] ([41.249.60.166])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-492494497ffsm74121685e9.11.2026.06.20.09.06.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 20 Jun 2026 09:06:11 -0700 (PDT)
Message-ID: <989e0b69-8b00-4f6a-965f-1dcc370bee73@gmail.com>
Date: Sat, 20 Jun 2026 17:06:09 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 000/378] 7.0.13-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260616145109.744539446@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 6/16/2026 7:53 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.13 release.
> There are 378 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.13-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h

On ARCH_BRCMSTB using 32-bit and 64-bit ARM kernels, build tested on 
BMIPS_GENEIRC:

Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
-- 
Florian

