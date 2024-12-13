Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF0C01E8847
	for <patches@lists.linux.dev>; Fri, 13 Dec 2024 16:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734108669; cv=none; b=mZZxR4m+/E9ZoRK2bA8uh59NWZqflDhkyFquD266HveRayjXnpcQzy38xVjJPMPuNJM3fGBeVyx7F/qDyyZ4OhAJNbcI9wAtScvMtqLzy09NGhx/+9bU1vO5nNIMg/y4qQwc+6+Ag90lD3GZqcmwgS043Rbns8QVCWeL8a5Q39s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734108669; c=relaxed/simple;
	bh=hRLG0gI9ivXr3ITGqvUNSsdsw1nIY6Mm8YSBj0Szrdg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nRwET3KgNn2qcmpb+igFyWm+S1VGY+S6cw99MoHkaH/1+XxnJeyb4aRRD7X3B1ATHu1kHaGdSINVGsnvzUjaoTmaokYyFE4Lw6qxUvpAqYTF7qrVw+tUzlBT9ZcCKjontLznzR6Gjgo8gHC5T3oIElhIffLdxg1vMkjod+7Di9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e9UVGugx; arc=none smtp.client-ip=209.85.166.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e9UVGugx"
Received: by mail-io1-f51.google.com with SMTP id ca18e2360f4ac-844e61f3902so116578939f.0
        for <patches@lists.linux.dev>; Fri, 13 Dec 2024 08:51:07 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1734108667; x=1734713467; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8/gquvUXG51k/jNV9egwVeYSE5g1NZe8U3pZAMe+4fs=;
        b=e9UVGugxITgklzIYpYK2dSgLLU36xZykSc1MMG5vjCnMmUGJs/IbQjiroi24Ifogrw
         M7aKUU1qQr+V71AVZMTyuase10NUTsKo/67s6OmfoQ7Rw/l1fC8z8jS2hvCeEnSQPBEM
         lxURMqCE64pzzlqLtjxEz2id4bn8RkI2YKEw4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1734108667; x=1734713467;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=8/gquvUXG51k/jNV9egwVeYSE5g1NZe8U3pZAMe+4fs=;
        b=jXk334SxteDN8E8C6bo+YHrs+E1WNgNCdWKkoig7FNiEtyHEfe66zaLzoVSYOvBESD
         Gh7ltriBv/73N2CKO43hv3YRUpZCiZovDdfIoGjc2KW0jsMKy0fm49JnhzqUkIHBXfKu
         1Pg+7pFPolO3RlWB6H+P1FYB0IG8Pg5BZLmScB5Q8U3tEYnZo9bmgx+lqkdOxscNnhr2
         6jgO9kbVGJQnEKbuUIuk/xxFUOCRg4F/eEwaHUlojnCuT6071QFSMILo0g3ys9J8cixL
         X4+xqWIwJjb61K8Jve3O2nXMP/3R2QCrfWN4yOknsHbNX0/ByWKqr0X+LsjHACAlWB6G
         etZQ==
X-Gm-Message-State: AOJu0YzNZihrL+hzSOjGP4GAkfTwrZvaGw6p7ovigIPXgeknkKoKwBVI
	28eIKzd5zfprvgTJejOrJ/ApY3zukmh0X9P8YPY3LbI9kkSDgHMakiDz1KtI5RQ=
X-Gm-Gg: ASbGncvvOwWRNX0oyJGwnrlR8z6oEfVSELmwv4CLix/1SHvkhsUWu103DDKZpn6c9Bb
	L2+MDzw8CdmhEWRPRwdHqM11WN1tnRY1Ma+cOttWd2iEcSx9YJI9qhwfGavnD7v4sZkmo/W+MTH
	P/gKUPGMUl1LBBmk4Usnyd9kz1dR++JBoKEvRnukulaZaLjtLVE6U0mDc2uzAiVMsCvutrOvyul
	/MEcHGaCKkh+X3d9rsygSoEtM1/jY8+TO6h1hVI5ZF2PAsRXDwL2FCByT2kKzfMaNbX
X-Google-Smtp-Source: AGHT+IG/k5V0zKRAZttbV2EkDVjn7pZoWJlVYqbCK3kD7y+Vax1tiYeztlcHHj03iaiKaDYPjNOHtQ==
X-Received: by 2002:a05:6602:27c6:b0:841:984b:47d2 with SMTP id ca18e2360f4ac-844e88eb5b8mr418899839f.14.1734108666844;
        Fri, 13 Dec 2024 08:51:06 -0800 (PST)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id ca18e2360f4ac-844738d4e38sm485853439f.18.2024.12.13.08.51.05
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Dec 2024 08:51:06 -0800 (PST)
Message-ID: <2a1860e2-8715-4052-9743-63fa8b766f55@linuxfoundation.org>
Date: Fri, 13 Dec 2024 09:51:05 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/356] 6.6.66-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241212144244.601729511@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241212144244.601729511@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 12/12/24 07:55, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.66 release.
> There are 356 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 14 Dec 2024 14:41:35 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.66-rc1.gz
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
