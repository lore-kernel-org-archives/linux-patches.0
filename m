Received: from mail-il1-f169.google.com (mail-il1-f169.google.com [209.85.166.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48F3A216442
	for <patches@lists.linux.dev>; Tue,  8 Oct 2024 21:59:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728424753; cv=none; b=KIxW/V1ZtIuunEhNMOi9VC6JeqKhiKg6khRK6yAZzHOWKkQzJLjrQ5wIcn6tkR/tSWdY96EDwOnnMHrbiqr0yI0tus8boIWUUl2VKerfIioXOBkOXYe/D6fpQPdd21oPQP1MkIpfVHiKVhAwfbzxCj8LuYb9/KBqpYH/7a5tNxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728424753; c=relaxed/simple;
	bh=uQ/KpIk0W+YBt9/OgdauzL55cI4XSv1lQND1Cb7MKwU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hmVOY5zFW6Xal+bslULuVizi6lqwUy3tYYrQiPV/KIgzVkXT3+uDH4+ZPEV1XphtJNWZxnUYxSiOyqFNLwLBTx4z1q2EvckLhnB3Yg5W6s+YkjyczKbHU2Q8aaIe5mN/SRiCS8W2c+Kus3/tKLacc6tOcsg4B0Jmsr50gIv1SwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g4LO4x2r; arc=none smtp.client-ip=209.85.166.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g4LO4x2r"
Received: by mail-il1-f169.google.com with SMTP id e9e14a558f8ab-3a0c8b81b4eso25346885ab.0
        for <patches@lists.linux.dev>; Tue, 08 Oct 2024 14:59:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1728424751; x=1729029551; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QJx+qK9x7CGLsACm3HeKgqtf2MT9KIQffopF3Jz5VWs=;
        b=g4LO4x2rumcVUa1SUcG0bRY500ad/xn6M8MHqyg7xWuhftv2fajtiATvR7VeAjHSlB
         CDp9/4Xt0G/miMjrDQz9UTlF+Skj2NIXCb6XMmG03PPRQPof4YGUiY1Rtyf3Wr4XoSHx
         UWG8vHSxbr2HYu8WC1r0iR506CMNY3eBYkvSw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728424751; x=1729029551;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QJx+qK9x7CGLsACm3HeKgqtf2MT9KIQffopF3Jz5VWs=;
        b=rYHVNCGObzAbSH7oVVF5I3bxjHg36yn3QE4KtjkYnKBZDFQIe3s8KKdJDfo5sLcJdo
         tCu431J5456/gEcYqsg9FZNffwqv9iCYoQl19G4LkjjJqp2lEbovN3lgRpPEB2PVsBWn
         FPvNIPozaQH6J70KI0tGP3Keq5Qtw0b10OZolaWDjn0LqUk4/sX0UCf5NHIbsswg65Ac
         Dj9pK/i4QlxZVNfxt0vOQNQU/bdR04aJhGv4ieabeU2e4MsSV1nlLQbiG3Jsrh9QYEMW
         nJNfKEXIGRYsob04ynlWbzn9hveOI8DtvZmFF8h8swCbbHzV7CrMYvvJBIr+yXuat/sa
         ee8g==
X-Gm-Message-State: AOJu0YxEdBFlO4w4kZbErkrleoGTprL09xDkxp/sFYpA6UCdPz3nEJZy
	78urIrYMwmZ1K6I5X0KXflN43AED7MR03OsshXkETVddyeRrdNgjdu/Rur6oHq0=
X-Google-Smtp-Source: AGHT+IGLgxzcQdWZneVSWhW62HZHmsGOqji8cjnJIuTkoYxB/qoiwZjKFfT5jisQmK/UwSTC82IpeQ==
X-Received: by 2002:a92:cd83:0:b0:3a2:74f8:675d with SMTP id e9e14a558f8ab-3a397d19ce9mr4507215ab.20.1728424751454;
        Tue, 08 Oct 2024 14:59:11 -0700 (PDT)
Received: from [192.168.1.128] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-4db6ec4f62dsm1816011173.156.2024.10.08.14.59.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 14:59:11 -0700 (PDT)
Message-ID: <2efe3fc4-e860-49ba-aeb9-383bd3257a90@linuxfoundation.org>
Date: Tue, 8 Oct 2024 15:59:10 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/386] 6.6.55-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/24 06:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.55 release.
> There are 386 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 10 Oct 2024 11:55:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.55-rc1.gz
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
