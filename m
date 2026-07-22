Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B38943CE61
	for <patches@lists.linux.dev>; Wed, 22 Jul 2026 17:18:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784740707; cv=none; b=JlfBTMbfX4hYOKdFROcq2uOjDidICL+pYcL51IxhiWe0yLb8uZAc6MeyujGBYdJ67Hl0AIBwj9OTTbNJ7ENFTuSSPNO64JjSuxr9VD76IS0RnIScMwjRVQ5aOjY/kKLPkHrYfYT3VRIS2rXN45j99HikOolISrNC5acab+Uponk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784740707; c=relaxed/simple;
	bh=swp9CXdQimYMhmwp1w/RYh5hvJ2ll9KjC09Ba5I0m5s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=J1p7xSY8YJbJ0csGjw2EovXYaQg+zWcbiSCQyGQ7+J1E8GlLO+5xndBUJkNSBX6Z/A1SqkcERyzZn/x2FN/GEbrVT/Dfn4tzyBwe27Pgy9AwKwMJpg31p1JoXt/Z9tGIsMfDCig9UaT1fRN8ny+nC9wNlDrRjARtqLq0C0RJMMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDUPvplY; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDUPvplY"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7ee37dc91f5so450431a34.3
        for <patches@lists.linux.dev>; Wed, 22 Jul 2026 10:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1784740704; x=1785345504; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VkGADoG7kLhndNpq/P0s/Y949e7MLNwqaoLrtmet1cg=;
        b=gDUPvplYXBE42Bo5Tz9w8lxJHEdkKN1acoSsyFE6hevdHNtRS7ODO4Zjnuqek4ygki
         cEvhxNAgziKFBJ4/Q1MFO6f6CWJbOPWNH4bC7HC5yRCDRcxCNk8UjNzl4qNgc6XbE7V8
         p/ddJ4q/xMk4kqSRRng/hNPybwPfZEVqitBtc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784740704; x=1785345504;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VkGADoG7kLhndNpq/P0s/Y949e7MLNwqaoLrtmet1cg=;
        b=SYs86mTRBE2L8ouvxhEtPonz14OD8VTasnnS5ea1OFjjjdxXi2M1IqOOx4vM6vFVKW
         UVo4Kz+6B6V4dzaIQ3eBqt73FkskEwrxQVM5BM9FXB0vkssdPv0Isb6Iu/ECVWwL6QgX
         a2+BNMm1TONIOyVHaVAHaAZWAym6qDBUXzO1o+czIm2GDFqa3lAGgB9sGZuOlRBZwMti
         vVBtb4fFzrGYhTvrnkWecFoJ/UgDqhYG85rY+fa/2aE706Nn2d0VL4iFgmQHvxJqUqaX
         ZlemBLeyRye2BvsmP0klZe7yIrBRTua03nW+stVBZ9SQGAtXbO6V+/BvuU09suBpwXxa
         2Oww==
X-Gm-Message-State: AOJu0YyzEUPsACUzVkPjz83Mt7nDkaTjzvr/Lc4CNGQ474YbPVN5EahE
	wgk8eabTXO3M7j8GxWxDP436xBWse6P5wdfMpVzqdwHJgTMdQ5YLQv2gmc3Hm/Q2Qrg=
X-Gm-Gg: AR+sD10Ti9enp5G7svgnIUE+3hjSKu+5V3cFwY6QzaShi+v/l3CWo6s8SafEs4ZOOMX
	j54kSUK6eKGMqMNdTlPaAi3P62QWGVhvP0vsVlLn+x/ZNciqztA+mqfXGTo98sQ+glgeRqfutJu
	Q54GhOeISh2lLhbYCskh7hKBSRZx6D8RjRT452IPtDkjnRpIUcZiHtXruXVKYOpMI2bg7oKzZoG
	dtZLpJAnSrKUOWRFh5kAsAEsUaRZcUHrSax61kPFBVecJLm08tiwac6DXRT+oR9ccl0mGN0zbgp
	1gyNXfoVQHguZ++iDTacT4fhNqnQjP8iBgIr9fVyxSc6xoY41DuIRJaWg14R0U9loxP3iIjermJ
	URp7nJdiaaMmKVY9SA80CDZ3cXmJgWGFnll62Gi7TvHliDOhrN+2ZZANw5VgVgdTg9GPdrXPRcP
	E3vrKh5L9rO64=
X-Received: by 2002:a05:6830:3499:b0:7e9:e0be:583b with SMTP id 46e09a7af769-7eda073ca12mr12517809a34.9.1784740704278;
        Wed, 22 Jul 2026 10:18:24 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7ee29e0f876sm1727222a34.7.2026.07.22.10.18.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Jul 2026 10:18:23 -0700 (PDT)
Message-ID: <cca4ecd7-4514-4a52-a254-8a1f77375ef2@linuxfoundation.org>
Date: Wed, 22 Jul 2026 11:18:20 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.15 000/843] 5.15.212-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/21/26 09:13, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.15.212 release.
> There are 843 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 23 Jul 2026 15:23:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.15.212-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.15.y
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

