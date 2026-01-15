Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DDBC324B34
	for <patches@lists.linux.dev>; Thu, 15 Jan 2026 22:42:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768516928; cv=none; b=Gc9j5x63l+bIjr9qcZHW0gtHtCQLCOT2Uycz7+z8PtXQouvg1qHa+6pigRgesAkrjwTd0IesxXVmg6cz2ziywPslO26LDldM1xoaBVHAelmd4PECrQ6NAfjUOzyN4n0NgYPU5j6vv/x1WMZeQfpdF37/wuoX+4uiDOHR8LiUKsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768516928; c=relaxed/simple;
	bh=bMOaTfGugxS6QIi36AKbrK7Y8LT2HQHJHPSWYoRjJJc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LNZe/nZDbBHfsijiLor0kP355pHKx7NSO8rpR18HDgS1t2oqZY0x7ymAQUlrN8IO+DHcWmunrC435BwHjsuqMIU8Lt6YD4kwxY8C/FQ9heI8U0aGiYKagLxvJvz99n9idDfV13yRpF8s7QF1RLNkRwHlQPJYTGtV/exagfuFdaI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aamWOAJi; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aamWOAJi"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-6610b241d19so734696eaf.0
        for <patches@lists.linux.dev>; Thu, 15 Jan 2026 14:42:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1768516925; x=1769121725; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Yw+GRLa7oPofsUXGY1SgAYmLZ2UQOdGxmoW3/V+A5Dw=;
        b=aamWOAJiVkrS4P7HdbsURM6753pf7Ad5BeBFsrz0Larb4jObaUg4LXmV44VWVStcfv
         j7BPHXeLLK7M1jyiY/9jMt9Y81p42HVBm9+6UEoHcoD3k+PdNm+CnmuFmu5/7OvrKCXv
         ZOOxq0uqHxG3fHOzJv8uirMAqm3iG58Pk/wtM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768516925; x=1769121725;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Yw+GRLa7oPofsUXGY1SgAYmLZ2UQOdGxmoW3/V+A5Dw=;
        b=uN2G3xy1yAWOjEjBKDU05perMIVjvgx11hgRxaMtZe2EJ87qTpVwh9fywTygA+4vzH
         mInir98K5MPK5qwXMyDxclwoW/xqgPZKuo6BD6c/Bq74XfUJ8+IpEbvktQwYqHTkajGP
         NQTY7t5kcBN141yQR0qrEBz/C/LXawECJJ4a2mFuhjsRocJo1gWom6EXdHd41FTU42OR
         P5mntHFMHIaQAnLzPlkrJ/VR7T0dtYGuw9R7rjnjL2fPFp/LiQarVbby5IjPJkypLhVL
         i6X9E6MJ6axpffIK43Ljblo4WNj3KQlJqb2Yhm/HIODynAzeZxYt0RdoCoZO7FfriWKQ
         4V9g==
X-Gm-Message-State: AOJu0Yyc1GFz/7IxAuePano7MrFCU6DPPNrrI94OL7AXYuFg98ICi/E7
	QVd29fjWRBvRmcn2yR9jOiiaeMJCZKRt6ykFMXC1Y4xbAJrWpPLwKhcYQmc2Di+YESs=
X-Gm-Gg: AY/fxX4EqVURw0KbpFCPCBb36bQy8cH7nglMV1QZ0jEmsm5lSLxDPpcchNfLMo0E2YI
	GEy+XcOcQABFIQZrRiBQvOXocf4hdCwtBEqInSe4WK5/Xj+IjWWYKnW6DH6e6lWUtvoz1ekmNIt
	c5mpoMOjoHonp13P6UP7K5hhMuixZoNQlH7vZJ1ayVFwH28FglvjeIyH/qq0UYblTUfk/M/AasM
	Sab2sIxwZXyBEom1rI6XX2QQT9Ec4/wy+ScaXoKLkFa2OkwgX1eRjxGA0D8vkD6srOzTz16LiiH
	+QoxsmXRI2+hUuKNlJskkC6CSAZeBhFNw2j7wFMMwT1Vm4H6S5WP7oJufP7lMTxhkEXfjlj/mZW
	2tJ0QmFkHBCo+wTCiXT1P5J4TqcBFBMKpvWXDfKBpXqEV5uyWDjgJShcbGGo9AifSmdWMp4dQwz
	nlYH1VYcZRmsWVC3UIeXQE0Z0=
X-Received: by 2002:a05:6820:174a:b0:65d:1697:e6ce with SMTP id 006d021491bc7-6611795a653mr585783eaf.23.1768516925352;
        Thu, 15 Jan 2026 14:42:05 -0800 (PST)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 006d021491bc7-661187cffbfsm407799eaf.17.2026.01.15.14.42.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 15 Jan 2026 14:42:04 -0800 (PST)
Message-ID: <ced90aee-f047-4304-9a7e-bed0ba1db0c6@linuxfoundation.org>
Date: Thu, 15 Jan 2026 15:42:03 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/119] 6.12.66-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/15/26 09:46, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.66 release.
> There are 119 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 17 Jan 2026 16:41:26 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.66-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
