Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F43A3CF211
	for <patches@lists.linux.dev>; Thu, 30 Jul 2026 21:22:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785446562; cv=none; b=coS/Tq1lCvD3C1GWffd5VPD5jV40+1n1V0pg/nN03L7G9YP+YafVkRL+som7k4G7sj+dSsJb1J3hGIsx4IBsUIJhP9G6P9COp8DrZywE4MIkgeYuqbK+rwUijgDfPZ+FpIlOJANKOpVTAP04M8pxhIXsNEtKuve+FPon7lyvaqI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785446562; c=relaxed/simple;
	bh=arzwFI5WYUmMyzG3CocIJ5GXzBGSgkQoEQQ0OFRRdzM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jgQgd0dhvGBbKbBNhac3B/CO9I+De9NDeXcAga+UxwpIJkrXQ55mZaGdR6vzegg+Ft5o0OJFjnyCzVhTkLL3LZmYQTTdIKBKRGJ3s+OrZrwcJ+2ca8SeASN7p1JmFZR2PQccbT9KjFfjPovcwzQXqEa9pUQYHNzZ6GiqPLcMeOw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cnsx8YGm; arc=none smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cnsx8YGm"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-451d8064238so240712fac.3
        for <patches@lists.linux.dev>; Thu, 30 Jul 2026 14:22:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1785446553; x=1786051353; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EI5eCcvvzGYFaq9MnUQPRY9aniV9C4ZQS6XVKA0HQZo=;
        b=cnsx8YGmAmDHIkfOETzTpMs3ipaOFFpfxBK6m8r6X1l/FjRsW0mygI6jM9TTImJuC6
         edOc8/wEXCoxk8totge8uD322mMQmFZ5KFlDDTPtY1FVKCggdr9FyxkZQWHxqFTGud+b
         384rgMchfvpERHzGUqR4BfvhOsej3UY5ipOCM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785446553; x=1786051353;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=EI5eCcvvzGYFaq9MnUQPRY9aniV9C4ZQS6XVKA0HQZo=;
        b=PeCx1xilZZR4LYXk+jg7/3Cc8/dUObMhDyZUp/jGfewSwQjiR+MXNSmClTGx0hPpWF
         0MHNsAfvahT9JBiGLfurHMJMiEOf/F2Z+wrfH+3MmX0pX2kQjDKgp5OT3RMhMrhmQx4X
         yJ3+6ppUNBrrbk3wPQtnIkHFRiMx/TA7J9hBsMcXrbqKHvtzqS1QMZDK4DhnJJFEpCzW
         Z1txhI/WP+UgmAnbMjTBjPnD/XJveum60SA6WuA6LHVw6xBmmSMyGL9xEbmswa2JBIyr
         +TT6Ziwv5nRhIuw6clxkA6+gbRFPWvB7ZORTfkBrv5u5Zu6fK+Z8bni8rvi3lFckHwNQ
         FAwA==
X-Gm-Message-State: AOJu0YxBeEfrhZolRme8MPD/5z50v17Pdij3w4QRc6OYkEfyUKspeP8q
	SOnV6U/8M15XxWJsAtY7unXBk9k36DdMpd0zuf3KReIBRUkdwbyw4tf30YDIecsjbUU=
X-Gm-Gg: AR+sD13yfCaCiZe9mBHcII+UNFz47R749uNBmT8k3qUwM+QrcdYX6CWNhGTMDgy1mKo
	gbpQUlwbOwpVUmuvBKzZ9TzayY7lu/G6UlvqFulClI7yIng/68Yn3cyNVe/9BMKdQWBmddLKE9z
	MtcCxsG6DSj4bGkBKRdM12V7ya1Y8TtI0goJIpuqIhUPtBV+MiDYNO1ymcVgKQ+btsfVz3LCZ0M
	O7KAQwMx1OdqcB1PzKuA91jYP98Xc64vz3ZrslpJKw5I9bspM+muzF6k5Cef1ZJZz7cCymTitGz
	9f9K8ihZ2zh7VuDKkHVupAs+Y9iKGX0CuIjitwQMmK92hTWMxVSg44fC8G4QQdYmd+117hthPLV
	5PYV8jF38sA3TXNWvywCUHiQxOsE05PTLpMMzkYl4idsvAxUym2ejlU5j/xmc5YUzZ+BwvPT9yU
	sAj9LPIGWhMah5SiAjSqZxumYowmzfF7JqBnS3Zce1Xa0V+Y02UWUd42FiT9NLljgfmKc85Q==
X-Received: by 2002:a05:6808:15a6:b0:492:cdc2:80e0 with SMTP id 5614622812f47-4ad952c5d94mr1740722b6e.23.1785446553084;
        Thu, 30 Jul 2026 14:22:33 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4ad6ed31058sm5137841b6e.8.2026.07.30.14.22.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 30 Jul 2026 14:22:32 -0700 (PDT)
Message-ID: <45d77663-ad68-4d1a-aaac-6e0157eac8ac@linuxfoundation.org>
Date: Thu, 30 Jul 2026 15:22:29 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/484] 6.6.148-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/26 08:08, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.148 release.
> There are 484 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2026 14:13:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.148-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
