Received: from mail-pg1-f171.google.com (mail-pg1-f171.google.com [209.85.215.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090C54315E
	for <patches@lists.linux.dev>; Sat, 18 Oct 2025 03:16:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760757393; cv=none; b=DWgkSux0oc48MwiU9zMbT8yF9R9rbHfAHXSO69+KIQpbmqvd+3ercacL+b7XTKNLWMUbOvAjC0gpP+0RbKerKADOuZ3pUEb8vDQRLy3PL8DTjFSyl4DZ/cLlyBulse9xLSIKDtMoQtvhErogjQquNC67l39v3UYJVPX9okG4nSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760757393; c=relaxed/simple;
	bh=3wqEQjGVhmexMMNO6iz9PsnEYDiNYzXnxmnJPClebZk=;
	h=Message-ID:Date:MIME-Version:From:Subject:To:Cc:References:
	 In-Reply-To:Content-Type; b=QPQCLV7aV2D1FliU3emMq6+5KyTPz1nY45kTuYiQ3vgzsiH1fpIc8In2Bj4yoX/QrT6GfVpWaERbTK6f/QYCIYpHDu90Sdgbsa3zFWj44nqUgsyV+kDcG6B5es6Ja/KFgNM945kEc3RuW3GWfEoZzZKKAocHTOiLLpzm5jnWAZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YzKm7He2; arc=none smtp.client-ip=209.85.215.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YzKm7He2"
Received: by mail-pg1-f171.google.com with SMTP id 41be03b00d2f7-b550a522a49so2075039a12.2
        for <patches@lists.linux.dev>; Fri, 17 Oct 2025 20:16:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760757391; x=1761362191; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id:from:to
         :cc:subject:date:message-id:reply-to;
        bh=CngrJsnwfVz5Z0uglJuuMx3gx6jUeZ2x5IS2P/yOwoQ=;
        b=YzKm7He2+hZD91nsBVDfecdsFX3JMCrTA/DYB/u+qYwMG4XP/8+JtiBopt5zqDkcPe
         AcKYj1s48R52UwtNO545HPxPbCa4RYM/sO80ed0dr4Lf3cYdhG7q+VV3IWyRty7NHTIq
         xg8xlzOfTkDfVI7HlrxamFkZYzkMje6AmzkNenA2kZRb9i1eh+orBYBSUwQ4k6C1BcCk
         ClWXNa4O8aXKU+z9/oaqRGQXPpKC6qq3jZX8y36U2rQHlMJEPm+OEzEd3yeVG3TPEMsc
         TJg5jHdX4BlkzslmAUuTXkq85vVH5QtKQQeResZQbDCXQbllvzQrtBUh0ixovgxa1ZvX
         Tojw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760757391; x=1761362191;
        h=content-transfer-encoding:in-reply-to:content-language:references
         :cc:to:subject:from:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=CngrJsnwfVz5Z0uglJuuMx3gx6jUeZ2x5IS2P/yOwoQ=;
        b=uBHfNfrp8Xkne/QDdUNnR7iJJzyBoRRpNTViRwN25ahndqzt7w0NeiZ1pRlWoC6EgV
         z/xTils4HxU+Yu4wGEhOtfuEwTDSL26J2hTWFyl0oxhr1A3uPehWSTYgeVy+/TNKLu02
         +CN/HfnapDxDRrpJLRr9TrwR1u2uToAD/IbCpmh5VUzGqrkWlDPxp0jcfPxPI7qBaRrP
         HY4nzwckDlRy12rNi5BCztZI7mKWWXthc9K9CqnplnqPNzNVwzR5nDMy6I7MaPhXtsP1
         b9yKKx7wRbZlYoVGjrXbAoQuG1QTbsrcBVSDwEgC3CtJxYvUZP4sxRFvJH3cl2oRL0sD
         uUbw==
X-Gm-Message-State: AOJu0YyD77wLFOIxqV8MBXb2sSbirQS2W+q5f0MZIuI0Wgv1okmJw8ix
	XlP+OutjO1U1stHTFAyAg0VIZYWRJRd2heYjYX6Ga7zf71UZ0v0RvOKy
X-Gm-Gg: ASbGncsSYs/fAKAp97JKBWSNW/AmHE6TYzZbYIHX296Qoimhj5HVEnPRZzy4O6V+pig
	zg9ENrhzDepqnLFO2oyfPSQt3gz8p1e6wtfZWK7GBWWBmwhLkupyP1+cxJ0bn+hfRO3fY6VuLCO
	r5tXoeaAGW7IBTppztkADu9ErNladmfOrJDn7KZO4zM8whbstakzHOiBDZydmkfCIZf6ok/BelO
	Wjhyj1JvcZAjhXR7OaBjG75/RqTN9ehwgEjMMeH9MO1WnwDK2Q+sf8YCaKq4xWKMVA6MZgZkoKZ
	ID8AuzKUlPHzgaiwUcOgbHZ4Y9S3iRXyrrmd0lqxcGB07CDq1Ddfy60rhVrSwttaQ1a9xmJuzYL
	br8yOy6zPbggU/O1HDDMMU/6ZL4SnfyvebVTi7mi6OTTRoHplIGKJBWXz/dz75In8L3MDWpZU1K
	TfVu0d7/6C5Agmrh6yK3tYAhwVdDP6XyvlP4d0bojGfkn+4mS+cLjM
X-Google-Smtp-Source: AGHT+IGF6g1VgS+2PdOdy2+M9tUOsUipAN1cyuL9NAJ+Yq6EnSQf09Cwm1hQzI6MsDSu/Ika2xwH0g==
X-Received: by 2002:a05:6a20:72a4:b0:2f9:48ac:c8ed with SMTP id adf61e73a8af0-334a8534251mr7721301637.1.1760757391312;
        Fri, 17 Oct 2025 20:16:31 -0700 (PDT)
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33d5df5c2e3sm977960a91.11.2025.10.17.20.16.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Oct 2025 20:16:30 -0700 (PDT)
Message-ID: <1b17c6d0-98b5-4456-a586-918d6533ca12@gmail.com>
Date: Fri, 17 Oct 2025 20:16:26 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From: Florian Fainelli <f.fainelli@gmail.com>
Subject: Re: [PATCH 6.6 000/201] 6.6.113-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251017145134.710337454@linuxfoundation.org>
Content-Language: en-US
In-Reply-To: <20251017145134.710337454@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/25 07:51, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.113 release.
> There are 201 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Oct 2025 14:50:59 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.113-rc1.gz
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
