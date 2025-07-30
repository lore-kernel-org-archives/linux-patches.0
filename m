Received: from mail-io1-f46.google.com (mail-io1-f46.google.com [209.85.166.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 706FF21E0BB
	for <patches@lists.linux.dev>; Wed, 30 Jul 2025 20:51:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753908673; cv=none; b=rLXIsX/iySw4UIAiC8LkN7Z2K4/UsWadFIPD3X9HZVEjq773UQ3Tp3nnEEGmXqjnIGMNfpQLcmlvWePJZwzV51TR9GdEuYTL7hR0vp7Cjmr0W2jJkiYGqk/U7MI/ye4ooDozjKeV+52P9IJzDKiV0tzG6J6s2MyZNAY3O4laSN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753908673; c=relaxed/simple;
	bh=hhMKBAzrnRQl6txKRP0hLxiLCdDTj9HHm440OXhcwWg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=NRpoULSTWIUh8MAfR9QA+gwCusyOMwF5rl5njjC/C/DTr24UWYhaQ3dV8iVtGGGd3xKn0AMdQ3BOJEvHBY3xlPkrskI77bo94VfsK+DCEdIlUkeRYWtFTcE2bF5Au/GVMpEPrzFWIeDKcbWHvYCG/zfWcNEWa2bryVe/jKMiLTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EJM+T5UI; arc=none smtp.client-ip=209.85.166.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EJM+T5UI"
Received: by mail-io1-f46.google.com with SMTP id ca18e2360f4ac-87faacc4b8fso11514839f.1
        for <patches@lists.linux.dev>; Wed, 30 Jul 2025 13:51:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1753908670; x=1754513470; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3JJbV23d59Z4sZveYEfYuzl8tte3y6HxEdrJPwkO/5c=;
        b=EJM+T5UI1zS6mXOqnCldIUGA5QyeWzeoTZioIkgLiX47PiSv0438Ksj+UahipTZvLh
         RfSiSX2AM35pl5O+n8aSn5P8noaXccC6KWxwFqhgqwdUmgsImfJOgqu9RMl7VCrYlKWy
         JBdCXGskMExEAd/qLpWpP0erEAdBw39NHvsXM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1753908670; x=1754513470;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3JJbV23d59Z4sZveYEfYuzl8tte3y6HxEdrJPwkO/5c=;
        b=YY0Lye5pJuMHH4gedAuJGfMJ1pLMciemgZOy7oo6zvavWHVg7oQu3OLNIjJqz93bHF
         ovehtZuT9tr0QMwLkMvaFEiq092lkJ3xnB/WkSr9BNa4YLYocEk/DMp2s6dIKVOfUPec
         E3B4wKoMzcyk4iUWB0am9ujO3FyGDbswFiqPFPxzHyb6oRJfetZ99jL2SWYS/TOZjlPh
         ZHnLkW28aEd/GtqxuMKKDq/LVmvmcgQgih3MhMkF7AjMJ8VwgMmnzEYh0XCp+tEDxi7w
         AMvGLaOHy0XiXd0VAscVA/NUKgLrFlMzJ0rMzTIp9CrM+1tnGS/Rv6GaHydnoTnff+Rx
         ZmKA==
X-Gm-Message-State: AOJu0Yxvg24YrIenfZsWE7KFJKUpzoVDE/lgo1R0UhC3pavGW3Gb4pEG
	mFWBgQM4jhj1uldd5J1ZrYq53Q9UGRmadzmIchiMlKQjt+qOQ3c3ouMSQP6Cj+4Ws4M=
X-Gm-Gg: ASbGncutjBVEsnqfk5obqDHOvgUgUvclL+vPpSvw9KJmY2eCcAYNp3yJJ8hHvJFj5O3
	PzQ8paZwtGxeiDnQeFXDFf4YHY2TyB14CVQlOddNzwZx7cnyzJrCosp+6cvDXQxTG/ksQ4PMfUA
	96wVMqSTwJgXRNSFMiMEW3wUzCZwIcJXgiFdyCx5n13zFisCGZ2fL5jKDEtxc5GmN3souIFX/Hq
	udzM60xpgKKBRK70J3enbF/488+xp4EFAfy4rFGl9txgQv8cs8Wb1mfEUIhUzypPvi6Kz6ZC7Ys
	nm7cxdAi4W0671jvQWs4rQSJkDHLKUZp/lAivlejwJaqnF4+RzEU5at/Ahz/4Zxr5bxEoyeFV1F
	cn6T8LXVZG1O4chlEfUIgZJ61/3NLBZnnAw==
X-Google-Smtp-Source: AGHT+IGbmO2V5F215bA9RT9gWwFSgBF+ew+cMJpwjD2+M8EuTWMQXWowzEwtpAbPaXPzXHu0c0lOcg==
X-Received: by 2002:a05:6602:48c:b0:880:f288:e8e5 with SMTP id ca18e2360f4ac-8813770b6c8mr801463139f.5.1753908670514;
        Wed, 30 Jul 2025 13:51:10 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-50a55def302sm45454173.101.2025.07.30.13.51.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 30 Jul 2025 13:51:09 -0700 (PDT)
Message-ID: <271e8a46-6763-488d-9c60-e4c103b605aa@linuxfoundation.org>
Date: Wed, 30 Jul 2025 14:51:08 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 00/92] 6.15.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250730093230.629234025@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250730093230.629234025@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/25 03:35, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.9 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 01 Aug 2025 09:32:07 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.15.y
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
