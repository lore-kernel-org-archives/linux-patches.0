Received: from mail-oa1-f51.google.com (mail-oa1-f51.google.com [209.85.160.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F1F13C5DBE
	for <patches@lists.linux.dev>; Thu,  9 Apr 2026 17:50:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775757050; cv=none; b=t4+8F30cmHEdjw1kpHyfpQ2x5+lH9RFK6SVLEzZF+Ovlk8RCFJhEPwG0Ym7+42abaPCqjIwJrnx1q1+jUM/kD2VSPPgQa2c50o99gSVRhGpOOVZA4RWLBp7TL1FaY5rQWenRrWaIb3bFwiybGibH9wJXkdIaRYZeyHDm2tuqZqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775757050; c=relaxed/simple;
	bh=LKbLNnOmt8llHI2UfSoyKRlTfIDs49SXxwFGHpJHCjo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q6dGAnlDMecnfCTwV5TFVDZ226FPDWDdZICL0L184Ot+9Sf/a4H2l7OMoz18ejKryg5t4JK3tqGuIv8AakACa52kECFO6ta6+bw5/eN0Dgf73uE7qs5QQSulOlYKQGWZgtk33TheG2gJ2M4J8X0RjWHqUtDnH5uV73jOZhoiqo0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KmRsD4Vm; arc=none smtp.client-ip=209.85.160.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KmRsD4Vm"
Received: by mail-oa1-f51.google.com with SMTP id 586e51a60fabf-4230a00de40so918964fac.1
        for <patches@lists.linux.dev>; Thu, 09 Apr 2026 10:50:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1775757048; x=1776361848; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=c7jerJW7kd6kLvB6dfldXiQ314FLu+7l1hxvSLIC6rU=;
        b=KmRsD4Vm/iiHhKCyTjKChUdQ2FWDjVpDq8a7B5q3rWOhfpVtTc0+2CwjOGrH46EFKD
         QQZj19/daRPsZTO/F6fvIvOawZe3HoK8r70p5EyJrFFaO/J3rtoy+RTw/xYYOV/i5HGB
         edvJmFystz6McNHqoZdvM5rIHJCvjNYxQIyK8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775757048; x=1776361848;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c7jerJW7kd6kLvB6dfldXiQ314FLu+7l1hxvSLIC6rU=;
        b=U5wqG5G5zmv4XL0mmwc5VkVb9wNmwmIQGc6pNE0CWDqzJkyZ5pkEheV6s/JbHpmR7h
         oDFPtHgKTlSUdUrNWIlTfZpW5LJMFBEhddVWJi8rP4v7Pwy4NPQXogtcOPPBof2dAoLr
         JZUoz+1Y4BGIN7F1bbcy5PMxQ5zpqXOeLE/Tp+WQ5qZdC+CztlFUtqJQcgwpRHABTMlu
         IAXLJ3z/v0C9K2Wg1a5JdjhsrI9u44/DOWh8OX/847s5rpjkKRG6oB6RMc0FF77Y7n/0
         jXhbUACft0ygDeHz8WKvdx25SfHnHzbGFU0eTXhC5N6+Uqp4Pmms0m2h09xL69qCtS6q
         celg==
X-Gm-Message-State: AOJu0Yy1kDLQujQZlZaHTSZbrhfbCkllY2ku07NTmzsbuIWiqEnwA0Qh
	GKMmZ9VnScuMfEYSIoc3RirsQNjSajtkaLwpGtuoPN2xRRmL/gPSa+dCKeLXOAsNfkA=
X-Gm-Gg: AeBDies6jvhkPRbRNEq68HxxktKLuykmzD4wNlMbwCjmc3y7yy/ZWzGTX9Vx6WM3FlR
	lSqI4LL1dQQPZCWb5BuidVCirQjOKSTG4eElSWMv9CAuxbzbJyvuZFgr5QLoW5Mh4b0G4i1tjok
	6izD/gxw6DmDG0wpBWeKmEvCAKQ3mUaOqDiB6AEmt5U4fYAa8h8STD7TVyNSRHG61o38Jg/7sPj
	K7+zcOrSi7F7esDfefhliSljqR66mlnqDrbrYUttIrUWmnsRXU4isoUZzf2GgTr2IjpnYN4p3/9
	MrhZgFk4WdbEGvkBm4CEQvuhGeeLjAlXIx0SW18783R3kflsSj4vCcorr+TPrd2Nc1nskE0fJC8
	upc4wKWVPjzEGzETOL/cZpZqJSyA9hZrLQitziBJXTeohHC8Rxw1GoTZI1TbvTiVYTTjCmq/p8V
	IQOovhKr5sFcLWBnMxv2OPo4UIZOvaAIE+uKw=
X-Received: by 2002:a05:6808:4a5c:10b0:472:8b95:f500 with SMTP id 5614622812f47-4772a35e6f0mr1549524b6e.6.1775757048081;
        Thu, 09 Apr 2026 10:50:48 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7dc2657335csm301347a34.5.2026.04.09.10.50.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Apr 2026 10:50:47 -0700 (PDT)
Message-ID: <b4385149-926f-4b4b-a63c-d79a447c2d0f@linuxfoundation.org>
Date: Thu, 9 Apr 2026 11:50:45 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/277] 6.18.22-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260408175933.836769063@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260408175933.836769063@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/8/26 11:59, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.22 release.
> There are 277 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 10 Apr 2026 17:58:42 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.22-rc1.gz
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
