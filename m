Received: from mail-io1-f41.google.com (mail-io1-f41.google.com [209.85.166.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C0F13AA2D
	for <patches@lists.linux.dev>; Wed, 24 Sep 2025 00:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758673551; cv=none; b=m1V1pMQuw6y2SjYyar8qo5iElUwgnPSiTcDWG5hOpUd8BvIpqKP3YPaIIqfXDcFfeY6cXkmJK6XS9vkRAZn8oKWBZ+QIrx5Ttjctr2Pq5y1lVLmwg5AvTvlYMrnZW9/Ij35rK5X6M+dJIWE/dB0rF1LwbVYB8B0StB3Uuw6Uqbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758673551; c=relaxed/simple;
	bh=5moMFOSWjJHQFSqbTSHVzZPV2Ozn1SebUST8B99iuVE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lV2saRUYcFZqeoUDgw3Oj51w62AB5/LOf3a0/AptCNRw6m367lJV0iW2ZLlfSvrB9XzmJlX+oDJmJL5QCQLR10xMyDEQw0zIgk7nKi8Gs/A+rZ8kYEjKGtp3BJJLA/b4ZJXuHy5vBjZBEdqEwaTyL5Y9LOskvyEw4IclZzqgvgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EY+1212v; arc=none smtp.client-ip=209.85.166.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EY+1212v"
Received: by mail-io1-f41.google.com with SMTP id ca18e2360f4ac-8ca2e53c37bso240889939f.3
        for <patches@lists.linux.dev>; Tue, 23 Sep 2025 17:25:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1758673548; x=1759278348; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=dt+syD8YMODVOGHzdazoi5hpOFsjySYX54UJ/Bx3CFI=;
        b=EY+1212vlPiGEoot8EZ/bveksyI9MjftLRhEqBsqOvouIDyySdZ1cgBvN3usT7WZ+R
         SL0s8hAX4zp89hWPYOWjMDPtWqigZSIPIdlpXXlA9GiVPIgTe13lb4nuK6MvC9rKLgCV
         JkB/fU9rg+nQEyJEsAVxWJec4ntCw3/NIUstw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758673548; x=1759278348;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dt+syD8YMODVOGHzdazoi5hpOFsjySYX54UJ/Bx3CFI=;
        b=E3JdhXitWygPDxLFWNNDOkJOgC0HiaUUIHh5vucWHvAkGwlF1PgnhonG10KeUU3qnC
         /EOEfVGhYT1DWYB7FhudqLM9HzVQZQRv5inEiCiT93OKFIgXa96KzBx3jEbAcShKUShK
         uWzlawHspo6yD1ywTUEYKYuK2sGJrYzHEhgn5GQZI3VokzqzxfQ5/cG5B955W5TmzC0b
         UpoJ0DZusBQfcTNF//HTchw2iT+d97HgmeBsbOpdy04KwGBL8puxuuO97jvBI0lFefTD
         GXPXnpg9gHl+Zn5f2xDrMEWhAgXWkXkveCpdaAmsISBpV0Vj36x73o9sZ53wJeJc0JDN
         CN4Q==
X-Gm-Message-State: AOJu0Yy6yGchzJnWD4TWDNroN1N1xn7wpYJG+OcpZSXW0WsVt0xT1fqD
	hiVihumB/AvkgdVOtZGQXzRxYjc7U/hvNRlpTBwpKfrKdGnydmZULLgVf2jTnofNDgk=
X-Gm-Gg: ASbGncthSNxbsvIp7gjRRYyLRaasqqgWBlMue+etecvKRQ9D/jIlDRGa76aCGgfmcV0
	mTL+XweRqAHoouKxxNCfeeoI+883v6Ie35vbOdAusqBZX/itO/4d0qaUU02l0ndz3Tf79HnR7UE
	H6ahnuhFI19g6tlOQfbzj7cF5o0Al9TL8/WtMjpKEObfUJonIYUIjO5N20fAsXZXy5MkN8DFfkx
	EIYh/WP6KzuAAWk+InC880zkf1Cf4gDU1nHAw8RZvfMKeknZwIHtfD5d4dG2FOyxr1JkVy0hhw9
	2M8qkVpJMVLYXp4ZZN5ssgBq/lD3wWPB6ypma0CbXkIaYxqF4bzjmsSYOceG3HW71iQa7OKnsPh
	R6jGBTSnsZzyuEoTTtU9P2zO5kzmNGNfp28g=
X-Google-Smtp-Source: AGHT+IGWLxq+5GJO0TmX7pMwInHGmPQWK7BTkeoJyzyK+KqNZ0MVQTr9S3UBmomwYpmD1Hz99wjo1g==
X-Received: by 2002:a05:6602:6c03:b0:8de:d8df:e1ed with SMTP id ca18e2360f4ac-8e1c2f313a2mr866414139f.8.1758673548081;
        Tue, 23 Sep 2025 17:25:48 -0700 (PDT)
Received: from [192.168.1.14] ([38.175.187.108])
        by smtp.gmail.com with ESMTPSA id 8926c6da1cb9f-561261bdcb1sm2206193173.63.2025.09.23.17.25.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 23 Sep 2025 17:25:47 -0700 (PDT)
Message-ID: <b9749593-7bb0-4ac0-aa9a-f8d68566a585@linuxfoundation.org>
Date: Tue, 23 Sep 2025 18:25:46 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.16 000/149] 6.16.9-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, Shuah Khan <skhan@linuxfoundation.org>
References: <20250922192412.885919229@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20250922192412.885919229@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/22/25 13:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.16.9 release.
> There are 149 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.16.9-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.16.y
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
