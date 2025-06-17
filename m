Received: from mail-il1-f174.google.com (mail-il1-f174.google.com [209.85.166.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 581281DDA24
	for <patches@lists.linux.dev>; Tue, 17 Jun 2025 21:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750195057; cv=none; b=hqeMQoWQfmfQkqqp78jhCHqyQ3mRAPKDaVKn9RlsVW7A9cjr3FRuWa6yt8CXi2LuS0nVS9xS0lBbZ4EXn9G6iA7X8tXXF6CbfRgOs3VBgR9hHoWcAjJ0W2YGdr3K1x4+oAqLgM5pFT9diev7BlqkorTeLVKLIIySbukF+d1VYN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750195057; c=relaxed/simple;
	bh=C3zqzvgxnqkEbq6gbzY5/vJOF5ioN1uUUpyG3ec7Dwo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=vGoVUeh0rFXJQn9ktZa3iAE65QUN3OyHlj8DyVh4e7uOksthmC9ysPFWMatD6Lem1t3VL+Rre0UBepE/X+fvCqSiO8jDwqGiTeCU8Q/hPftM6I0nl+B4W7pHkam53Hh9PyHFG/2E0X4qL/fOsr0RWOEpU728LBiHjPOa6Tn7gN0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ffUuTG6c; arc=none smtp.client-ip=209.85.166.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ffUuTG6c"
Received: by mail-il1-f174.google.com with SMTP id e9e14a558f8ab-3ddff24fdc4so72499915ab.2
        for <patches@lists.linux.dev>; Tue, 17 Jun 2025 14:17:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1750195053; x=1750799853; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=K3o2EErfEHnz3hmNQBgh5TFWazInBuO1PKdU15xcdgw=;
        b=ffUuTG6cAu1V2IdXuFvA7mdKxBGXBPYwt5xwQw+VNG6QqhL8NrrgCXgYRiIKfpP33R
         Spk1b0bflfnSImLxRbfCykp3tciPjF3NcPIrDsJ1dR98GOXmFI0NnRGVtnQ1cs3aBJER
         Aafm6SBA7ULJ+O1eCcYSaKt6W/9Ipd6dYI2c4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1750195053; x=1750799853;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=K3o2EErfEHnz3hmNQBgh5TFWazInBuO1PKdU15xcdgw=;
        b=e9rOkq6ev8H2FXi4bF31REdb2oC6JI3s77QqAe/uiNjGzGecbTergNPlaf3od0Mxh2
         Z24q17vVtaTDdKl+/HUnAGO/7nSkYy6k2vvqBqvczch8aTQJ3158qAdKny0SP6b+Aifs
         VJb8nPoh4to09/ZG2883aIS8XWi6ArfW1rqSCqPSNhtjKwr9GBplGr8Wcc+w6h28EQ0S
         9uK688/WdKgiy7B0MKqCud8gZYVrIwJODbIHi5IyRT0tDJC8fB/HF7Trqg5yUlUZJasl
         g0uLgwXMsu/RLJIh2C4VHPXuVNL7J/ZU9yvT0ICjZJQvEvPc3ASni9Y4K34jkPAPJP/c
         3qXQ==
X-Gm-Message-State: AOJu0YxgCn+Cds6+ptl1yWY8k0fyOnjYcjdjP7D81svTznFePmAXENLI
	Mty27nok6SueBcZ0WoOyB6mDZc49gobP7Wnmb41RzyIE9jpUOIaONkmS/e8eFPHzeDo=
X-Gm-Gg: ASbGncuxHAoOCKWoSphMr0pEcccpe82D9z5ysQjSdThLAbo7evio7fO0WjC3TZO3a6s
	/ScNxZXIc21c1asf371ySI9E7P9QbjC9z9L5CNGey2rCUZATRkkXjBkPSIoxzHB/c6QgVeCRUXF
	/o1KhqMDQLzJnlyrsAvyLuW1Vig7EiZ1jMOcWRgSDw+UtvXGw5qvpLBa//L5/DLOSdYE3kmv7e2
	5cFon2towXJi5X/JHcoIozEX2Z6WuOKYgkQDCElJd7wz1lFTDZVqdK3PTYClNWmATThhrr24Sx/
	E2w33PmOdF2XoOKEiUxXVnKRaf4Kf8frfUz6iX0Ot5Bhtf4UMarqZtbukKAOdT59gstT8PRYqg=
	=
X-Google-Smtp-Source: AGHT+IEBgMyPOW6hAMXcdTuzK8RVSxmS3n+6K8lB0g5WvUu0MVvxKgSVKQVBgJhZmKEfgPNtN6loXA==
X-Received: by 2002:a05:6e02:19ca:b0:3dc:8075:ccde with SMTP id e9e14a558f8ab-3de07c272dfmr162449005ab.4.1750195053421;
        Tue, 17 Jun 2025 14:17:33 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.170.29])
        by smtp.gmail.com with ESMTPSA id e9e14a558f8ab-3de019b4406sm28236045ab.1.2025.06.17.14.17.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Jun 2025 14:17:32 -0700 (PDT)
Message-ID: <31757a3e-7c44-479d-a75f-baba2d436658@linuxfoundation.org>
Date: Tue, 17 Jun 2025 15:17:31 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.15 000/780] 6.15.3-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/17/25 09:15, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.15.3 release.
> There are 780 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Jun 2025 15:22:30 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.15.3-rc1.gz
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
