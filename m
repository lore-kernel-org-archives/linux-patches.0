Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC428333434
	for <patches@lists.linux.dev>; Fri, 15 May 2026 22:48:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778885294; cv=none; b=LgCo7YyQN94ou+yVQkplIus5/w3lWboXkPLgaeVYKSc5exmrTOnBAiDcUqcSjID+rnsy5BNNF3jWOCV2t7m9Zy3vcVo06A0kKkSWysta4I1l9v501SgtxCCXxVQj1en5QV9nKyAsa3D2lGrUkgKxvxzlx6h/VZDokLPHNKr4bE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778885294; c=relaxed/simple;
	bh=EdDOedeMerSNN3gY03WEabZ6oTdFxCDK0wm0Z+xbmoo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RBAOeteN3GdsjtUP/0MZo158CNQfw0wUJHewZ2D2fiD4WpmXtLF5L2doVYbb6RQqLOxwZabWcZQG3c9Kjip9tBB/rpa3UfqS/KDVFKhXrnUb+op+sGxGKYCKJCOBxA8hGbt932rpaUbMPDbWfBgKN6xoa8Kc9sy2wzzZZ8NASlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BpgZ1def; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BpgZ1def"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7dbe07d3ec3so199692a34.0
        for <patches@lists.linux.dev>; Fri, 15 May 2026 15:48:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1778885292; x=1779490092; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=mqnzQByjyy1E+SKpYzIivj3iQcyds1Z9QBuuYKjzBLg=;
        b=BpgZ1defjA1jRrbd03dpV3r+YzoEa++d1k1L8iZ0TP7qUpsLhdpoP8h7g2xYUwlXb8
         2GFmv5eH/nLjK9qbyPcgNwoAOWX2+SeeSkvu3H93bydWYZZh4+7A48KtKhkPHE/PnGzk
         /nNzrwWRGG8yuPWBDAT+VIlIk9jIkdqhEtfwA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778885292; x=1779490092;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mqnzQByjyy1E+SKpYzIivj3iQcyds1Z9QBuuYKjzBLg=;
        b=CioEmdgMtTZVJbxPEoJbd278P7xI3gO02B5d/thyhllzK2b+s7NGJIa+ZsEUEgauh6
         hxN3TDskh19Kdg6y16IFyrx/Hu9KI1cjkHRKccsPCKZmR29k00ZudnNGM1oXnqW7zB+m
         8SxSZk7z/uYKDttKoue2o8LC1gd1I3X1GNu7XcqdDiFBiWWfCp2Ajj2uzE2Yf0XUazEb
         YjKjlboQ63QkUupJeexANjOOjQVNEgRcXzEeBXuxODl+v6gjDB4v7/X10u4gCpGzRmHp
         FucCRyul7/kvy7lPHLh0r06aa7OAF4lrskmW5myeIpwBcRO8kLxMqv/r6HRD/2uP4lx2
         is5g==
X-Gm-Message-State: AOJu0Yxc193HRfVDLtKWp2bg9iqOpkJJyCsd9WjgYG5JvZS86lpq1pC5
	YLw6Jl+zDXdMQPLy8Pmne2G4tZofmVO4p6bkEW29IGih5bJU+E6szt+4rg2+Pg65NK0=
X-Gm-Gg: Acq92OF5R4RPBZF3ts20ECq9eUfi83f/wA0jGwXyUuJgmO/jfW9tm4TcWmJXkbeDkQW
	9GBM4OqPj7lhvYF0/Xhp+mD2czSy4Gvskf3mAg3eJMmS+vg4Ch0vRLU+ZbrTiL5XplSHqmevL3c
	Tp1l6+ed51Mdhi9W4aeKtoUepDGGJZotBbJ3fLmBes8TUi5fSy40R6eJllyTJcjCnHGqlGmHPGy
	/ooJAmblDIm0MHK6t3LPRXaeTID8Vdu9lx/uivZPTsBPEptXmFqlvMX7vFYpCgGohSF1V4sUFO6
	UrdUIVovw1ZbVAQJlADXFxNJtqXrkC6fWKLyn/dTFXiXNtwy7jDk5HbcsRFQA0VKYA/HsCGMPeL
	XT6RQNqqY8d+xzKUc+HinHj/FIHKINZx6vZZOFT8Z2l3Jw/Kva+jbgm7Il+YHrRwwi6JSxgNoZw
	Wn+P2pusoxkBnEwAzGHuKnRMHbsmXfGHM=
X-Received: by 2002:a05:6830:6604:b0:7d8:b269:e99b with SMTP id 46e09a7af769-7e4f2b8074dmr4018861a34.17.1778885291688;
        Fri, 15 May 2026 15:48:11 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e55bbd10aesm2277398a34.18.2026.05.15.15.48.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 15:48:11 -0700 (PDT)
Message-ID: <6f2ad9ee-b8b3-44cd-ab42-7cbd03c2fd0a@linuxfoundation.org>
Date: Fri, 15 May 2026 16:48:10 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/144] 6.12.90-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/26 09:47, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.90 release.
> There are 144 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.90-rc1.gz
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
