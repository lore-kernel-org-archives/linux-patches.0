Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74091541465
	for <patches@lists.linux.dev>; Tue, 13 Oct 2026 23:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791933090; cv=none; b=r1yE83pnnHZrIw6fU4v3DTExSgg/AcxVbAWyGa7qCwuBi+uXGVeT+zlEBV+LZKcXb0SPPkVc3EPLrOoWVTSaUn53CgWTFiQYdYAT9WxK4wouYuWG42b21iG6z9g4qbH10rcxmoC5FQfrcxM6FxinMcI2FVhQPBMs11lylj2delo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791933090; c=relaxed/simple;
	bh=5IBhaLUp5MdLPNUcVu4QR7/5QsLhjzo7lK/mXulxCHc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Uu8luOpepG9I7LIFd2Di5gjq3Posof7+MqgsLv2AsudqWVuuYilJtiICjLfi1noTDRYeE1oVMrNx36dzOyPPLx7KfEAd9Na7VZOUZPJK5ATT92QvymenaMicBID0gd3aSBiLU4HwhsAvDM3PWdi4PWH/fEGxGt8nEkna5UuLX64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=X9ylwybm; arc=none smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="X9ylwybm"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-4b28d9537bcso2519370b6e.0
        for <patches@lists.linux.dev>; Tue, 13 Oct 2026 16:11:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1791933087; x=1792537887; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=b/a5/AdXnTf6cDcdZphHu5UXWH0M+sRSxBHGhoRv5/E=;
        b=X9ylwybmvINYDvA0PY0oJ5iYxkaOk16D1nORzeAGtKxCpIG7qKJi+MSGImaTDDoy4i
         Hl6MixXuSovYZDGqXS3rU55Rwy0DclP7KD3jaGtNRRaMQwH7Esc2kSfD0SVd5p+PgPKW
         A/A2XtwFdKdRaOlk+krDPEdV7pGslZVXB2IF0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791933087; x=1792537887;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=b/a5/AdXnTf6cDcdZphHu5UXWH0M+sRSxBHGhoRv5/E=;
        b=UmsnyfDZq/y3VjqjIJAnvz20ejIfMVJxxZ5iVtUpJqLDRXOcgmHQ+oxCkGJe6NREJ4
         GIpsh4daMtZjjfQ/dgZ3oBIN4F+F00K4qyEXDsfvPgHpeEuIflGjNXjNR7U8veseTe8e
         RMjqSi5Ln0BfdnSQ09DX+cTYtDKDQvmPO0Ek6AYqjXzQ7adAWe/Z5+HA0wT7G4A4qXtD
         ShGEhh3lwC7Kw6XAqa5DE0ekbreUM/Qw6q60IUB2lUCZsjj+ntj03Rsu4D5iMhuFzfu8
         VY4c3RsYUP0RQKzTDtoXrR4rhHlvgTUoPKEeg6c6qx2hjLHOgoW83SWva3+MB9pd6r2S
         uqXQ==
X-Gm-Message-State: AFq9FYLxi8rkLZu9WBQAYL5OZt5KsuAgJkvKHhTjaLlQNrEDKTfnYoQ2
	hHLF2hxFaxJEB5rhxCgxEK1n0i1yBIs/uf+vazPdr6xbA5c7QRk4sOkUlasAjZA5rY0=
X-Gm-Gg: AYBFou1gaZNArWYx0O9CQu1Yr7MRj2LxBVVx5QqTblPY+LhcCxqcnoESgbClHxZGEZq
	o2ZnnKxEzenktHhTJZAxGsnfgA16ZD+1TS9EeHPV+18ULCHwQQS2ZY9+K8maQBB6nqwqNiujet7
	eMnQfbaRJn8P7Q+WRlTkBBH/zmiT+KaoGCH3ln1meDkEPWRfHMN0uyaASg3V4/9PXkNThdI1oi0
	qcUggbpMeXsNc3XpxjR3XdwSgWo6JR5FFuxpSpmxWdd735sFLEmVH+oTknR6Gu7sZj3pG2DnJl2
	z7Bl7XQpzdmziHKXgfidxu+Rk7JrfPpV40EBCW5FiphZW9G0SrBhtDpLfQSFaSf0/eyHYVyCYze
	ZXJSL7HS67pbsmZ4LUr4UW3BFYoHM3+RCM+Y37LrgfOaJ63CbYhlypumhpzT7fk0HvlBrlszGV9
	Dc1Hc6ut/93LAiCkwAT0WlH0felQzlnDiL759SO+MgUkKseqzlyyLvZ/+XeOH6P6JWjqLukMkib
	WrTAU0=
X-Received: by 2002:a05:6808:250a:b0:4b8:4703:db91 with SMTP id 5614622812f47-50b621adba4mr10283311b6e.26.1791933087183;
        Tue, 13 Oct 2026 16:11:27 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-4a6dfc44a5csm860681fac.12.2026.10.13.16.11.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 16:11:26 -0700 (PDT)
Message-ID: <6f18fa43-9fda-4787-9e2f-63eec412ad9a@linuxfoundation.org>
Date: Tue, 13 Oct 2026 17:11:21 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/621] 6.18.57-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/26 05:29, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.57 release.
> There are 621 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 15 Oct 2026 11:28:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.57-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
