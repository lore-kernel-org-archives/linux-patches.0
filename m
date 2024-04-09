Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D319C7C6D4
	for <patches@lists.linux.dev>; Tue,  9 Apr 2024 21:45:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712699134; cv=none; b=m3s9br00FjgVQI/1d05SNSMIsYOSiRrTG1qVywg2sgutmKcU47Ee0Hpac12VpN11DTSzfTXUmQb9xzqGdc/259cTMR7yqxPzqDsSDjK1oFrATJT/qLjD0FpT1ydu0uw6nks3jLFKPf4JQNcIbPT2Z8OIu02tIEiw4xMw4+N0MMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712699134; c=relaxed/simple;
	bh=BvDvYnOOXVplEXAKZS/pyR1MTJ4xfUq5mSJLxWWLxOo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Q7rjdhcO+AGoOpmm0yqEAmLQtARzdTwwq8dgaQ9BMmEChoMhWHw8Y7mzhSKSgrWRDW7kLkhPscT88eSgAsRut/vyKvaKGt4TkkVtNBrxhV4OmroSCwOZIRPs0nifPG1MAfXh4IN7x+0vgBof5+WJ0ILDOVkHoIugAq4Z9SC7o8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=H7gqx++X; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="H7gqx++X"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-2a559928f46so1307648a91.0
        for <patches@lists.linux.dev>; Tue, 09 Apr 2024 14:45:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1712699132; x=1713303932; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iVtDfwwG8gLboGM4jqgJ+puQVYBzgA3lQVXohAbNgTI=;
        b=H7gqx++X0VgiTlqtd8QQkqaL37LIG6Fii7AlLEN8zfvGzVEao+iw12D30dL8VNkx+o
         Mmhg52ZlE1L0iSiOFntmEPoCrgWX89vIkJytaw3x7MgOgtqu3NiiHxvmWOJxCTCKOWpy
         ZMoHd8xJn/y+pyk+HysJCfnrGKidGgGiv7f28PcTqJG8+t95X7pXtLQefCwoHMoGQJdw
         unAEs67Do12/aubhBgDZUjrd0nG64NN29M5sF+yZ0KqIp7AJgT5MrR/gyOn6e3IhLQbo
         ZW9u8kdYx7z87EHtndvLNVXA9fOPTtPMFJJOoAoPsrI7mcAHWrOSLDelvG3TccS50DHn
         9x5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1712699132; x=1713303932;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iVtDfwwG8gLboGM4jqgJ+puQVYBzgA3lQVXohAbNgTI=;
        b=IUJEyTjGfTom6g0xK3tkYzLMll3yraFnxsJYVQuT0mFLO3/Ha2cwgCU57+ms/LItoB
         jDQW8VyYrzr9Ag9wXxxDclLZ1QD431LJuFnklKTNuKdTD6YapyxJOZuPgopOkkderNx+
         BRSVLoah64RKsBW3bECsj6SZMYC82N2hLkO2bzQ6Ozy/1LWglIqulwW9llt7e/jO7qsN
         yQ1BKmCFYqZSNllyEhhpdQ+WnqrxwSEEFtmlg3eOzNsRkiaLGkWpUfmIHD0EtjivJy7m
         /kLXf8cTs5r8O89V4nuOI7bbfiM9wZ8UMvrbSaTOoGwMUIcQeVDVOzqOH+iKZ/AUU9AY
         mHSA==
X-Gm-Message-State: AOJu0YyiuOh/NbkMu4yPtOKsVnHLUu/yy09RvO6hFqdOna05k/Qwti2C
	JSm3KcshW0McBBSWaMvtIzgZxUcXvhlUDzrdfDjt3ZJhV1Aj3p4n
X-Google-Smtp-Source: AGHT+IGq3sKA+G3xXmhaBew7ljkWLI4OQDEMZ/2WB/CMVm/z9wg/DswFuMYeCmjPuq067hOiftgEUA==
X-Received: by 2002:a17:90b:3cb:b0:2a5:3637:1968 with SMTP id go11-20020a17090b03cb00b002a536371968mr1002437pjb.9.1712699131931;
        Tue, 09 Apr 2024 14:45:31 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id mg4-20020a17090b370400b002a043efdea6sm73077pjb.11.2024.04.09.14.45.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Apr 2024 14:45:29 -0700 (PDT)
Message-ID: <90403017-ecf1-40cb-8455-045bd04247e8@gmail.com>
Date: Tue, 9 Apr 2024 14:45:25 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.8 000/280] 6.8.5-rc3 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240409173543.596615037@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240409173543.596615037@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/9/24 10:44, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.8.5 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 11 Apr 2024 17:35:00 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.8.5-rc3.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.8.y
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

