Received: from mail-pj1-f52.google.com (mail-pj1-f52.google.com [209.85.216.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 994DF37E5FD
	for <patches@lists.linux.dev>; Fri, 17 Jul 2026 18:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784312812; cv=none; b=fBdRYApRPHAevexzeKgjP8bESeyMJlxwSDV/HI7r0qb31YGZG5vEdw1HtBoEkUWUp0hPO2a2f+HovRgAkoPoD+tyRTibBx5+KgoCSAJBHCyNRHbsXGx94exYxBRT2S7WvYxRZjUN3JDJNOL+P8vyXZ1p38TYf3zAy9kQVwzRWOY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784312812; c=relaxed/simple;
	bh=tKyySihkT20xIqRU3Wp22Nft9XxHtSfOyRrQ/6QIdOE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ofZDkeoDcWFfWh5bDv56Rj4h2+m5WvVXB0fG8L0V4VkGVAPIjwLErv0+Ilmee7XxfT651A+LbfKNR770tj7mwLNca6DlUi9+GdtTlcOSiT8aAUfpMpxg6/8et59Gc6nmbq8Uw7X8s9dfrNQeLYRVZ0USxfV8m0215FYuw8UbbKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IjTJ21de; arc=none smtp.client-ip=209.85.216.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IjTJ21de"
Received: by mail-pj1-f52.google.com with SMTP id 98e67ed59e1d1-384c94c9414so4113414a91.3
        for <patches@lists.linux.dev>; Fri, 17 Jul 2026 11:26:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784312811; x=1784917611; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CXC8PXJJavATSwTaY4dMubvNR7I9l5U7+WOoLpAqGuc=;
        b=IjTJ21de/REO7Ghnax2mIcZmbhTL3G/Yxwa7qFTMEvi3JW35+HPIIcjHOpGD1+9ygt
         uVXURRGohU8y0R27R6W3rWxWmHtm+IWviRC2qD30wPsVkUoM9VWFzwXCaj6hZX9u6j07
         HatFN216LnJx4HlKGR1EHX0k0+lp/2SCdYLXKgrsWE5gUqi82NEDa0fBe7gT8jFMT1ZM
         moo3L6tAsWSoi1whjqWvFpMNODrcu8/SMhwpLErDsLOWZ4YRhbfVNcmIE0cj1FNIGr6/
         3WwSRsJkOAXZ5sTat3VLn5ikPoZB+Y1Ui+jKa9FaeQZRdeOjOAPARIx+16GDzIO7RWiq
         v6aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784312811; x=1784917611;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CXC8PXJJavATSwTaY4dMubvNR7I9l5U7+WOoLpAqGuc=;
        b=WCgfM9Eh3sxJ1+6FeKshKQ+7YMNJGGt6KRPdkQ1rR9hD15qSODvWoeB+lR1tUrApe4
         q/SSiIZC/axIOtYOnoqyxRqV/zZJXpdW/PcGj7+9Ldtox7P6rosJ9yZnWHVn+E9TPQU0
         Kk2IuGPxs+bCg2nQO87TC+rOMOb5tfLvtMADEBYHsS1Oy/ROt65uJ4DgMCgNh297ziuq
         OM+3aCycP9oRzwy+L3UE7ISoL1aNjLQGPzbBhWsHs59b31QD8T+h/FGG4lN06R8r0/h+
         tkAmwWz3QLvGR3XcZDGnKHLph31K+qgpmuqxwwmJjsoLHBzzuzAiqaXDNIVl30W1I0bc
         5MLg==
X-Gm-Message-State: AOJu0YxP3VB0ArkBmwSazrQpuFHaY9h4shiO4OtmoT9AuwLN/KWZk+kD
	9HRrTFMJBfZtMWXN4GhOguUBH9f6eaXYhY12k6QBGyFGZinM8zf19rrM
X-Gm-Gg: AfdE7cnDAp0H8i8j68VVvr5bT92sfi6hbRjt2qNiJtK/0QrnhHR/TkLk74LriL+cbIJ
	vbw4wZCyyoTngGMjAdv5To9qarRHIs4t90LpHNnIf81qdSrwNDznpNxwUdD87TREwx/t8GDBrI4
	FqwVz5ezgh/Qf87zhY7X4sG/ftTHVWTrR/gftdBJHgCGllyYChsyUpJuTzFVOvqm63TKImq45/B
	LTZlMkqKDrl49xlqHH3stosc6kae4L4Ic7fLDeUtRdMSoqfIuCPNkIr6eFK/5i/9PIEddzuxb4i
	rhLpeFKE/gvg6wjeurydjXbpGEu6Jl6LgfF16LYlZnt1P8+iGeFr9gKYUgowW2NlBYX9A4Q0sOE
	W5YgPqLD3Ox4bJmlcfIHkL8IXQteYsOOiZORTZWGWcgPcfkiIPGER4AVeBw9zSBg/qJnblH48oZ
	1i52SuFrniTM+kNnyvVI/sUSgh4vsf
X-Received: by 2002:a17:90b:3886:b0:36b:944b:fd81 with SMTP id 98e67ed59e1d1-38e4b3d27c3mr3989067a91.4.1784312810914;
        Fri, 17 Jul 2026 11:26:50 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-31429cf22b3sm9811189eec.0.2026.07.17.11.26.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 17 Jul 2026 11:26:49 -0700 (PDT)
Message-ID: <7dab6f4b-e7e1-4df8-ac29-066973055f4b@gmail.com>
Date: Fri, 17 Jul 2026 11:26:48 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/357] 6.12.96-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260717101823.379399592@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260717101823.379399592@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/17/26 03:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.96 release.
> There are 357 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 19 Jul 2026 10:17:43 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.96-rc2.gz
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
