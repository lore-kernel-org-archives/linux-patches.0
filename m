Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4684F38BF9A
	for <patches@lists.linux.dev>; Fri, 15 May 2026 22:49:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778885389; cv=none; b=dz+KLWrzSPZ4vdx+fC7my8J6R/WCKLl6H3AlwVe/20/6W1o0uS2CVsoMYXawKze6Vm/LxvNn9bBArSoLm0qSBPoq/Z6QksJZvejVWtGe8aY5yn+mV36xJDsGCViS1LxjaYwjPiYNFme8yi8+wARNGVkGV7D5XvHYjCz1ppBI+QM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778885389; c=relaxed/simple;
	bh=8CDKojgg8bc2d3j+JPs4NRsF8N917fIy9qh7ITHOf8M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HlSKW+SoqMn3stzj7NMnStZGUMJ/jPgvkbs9fUsAloctSMUBCnN/K0kVVBb0Z5gs+fr5hUER4nnh9ZOw5hSUzLVmVVFi8QRY55Z0GqD7teqn4uaRDo3PLl4Abil9j/e+xL0BYSPat0C2hTkCPkQrnqdx+BMVtvdjAbMmuV/sGJk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C/0/2HQ9; arc=none smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C/0/2HQ9"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7dbd23bc684so195348a34.2
        for <patches@lists.linux.dev>; Fri, 15 May 2026 15:49:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1778885387; x=1779490187; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UOwHkwRBXTZs9rh5FCfiGoR14he+8Hhk6XucwBx3k6E=;
        b=C/0/2HQ9bECzZ0V5T8Mm1sVHBFXXJpBF9W5iYJIfxGpB4NRJkTAsL1slx+h4ENHc/1
         Hm62mOaw/2sG5zibKdGEKjA6X/o+4XulKTQt4j6ZYbSZzr/tVWfnrX3s2aSNagiBTQJg
         /snFVmEVj0dKiR8doTfPMTKaAtU7MjHoWxTL0=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778885387; x=1779490187;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=UOwHkwRBXTZs9rh5FCfiGoR14he+8Hhk6XucwBx3k6E=;
        b=QcHYj2ZqCRPgvznlqJmsUcNTUK6G2m7StZHaB2Un66ZVR1CLakkTQrd8VSWLQZSTm9
         fa3mosBftytzb2hUpUIxyK+BJ2noJeOrbRLDU8rJb9yggnpdchm7DWeT3sgPaqWC7Bgi
         80bmHz3ldZlw9hvJrucfyiNRzulYTCKThAkYgoV2UrjXC1AdXHRxdUjXd6JUE7RqXLBa
         IG9fNMjs0x5IpM2OvEjoh4zaeZu3Z3u8e9Tzz/IMTLrzwt3VQ37ZixK7E74zPxcUHBun
         4WQ+5erWIGdgcOFdXOtyWlTPfVB6PVHz/Bvw62Pza5las1Cd2Ba7HShORfuRT/lrG56S
         x9qA==
X-Gm-Message-State: AOJu0Yy9poQsaaVqOQ7yiNjd6jO8T+Lzy3pmYMoM7nP0o4WuinWF+0DB
	eUJAJ4in/cMPmaQZSG4/2WsQEjWp5dRbWQEQ0sRJuVmvCjhnbqIIsPR4JySLEhNZTtQ=
X-Gm-Gg: Acq92OEvYJqiQbPv1ydGle028iMVeUE9LeGLtDOzLDW+3FRVEypkGKBwhwqZlx/2UZK
	i6JVS2kjYkwshl1W1H5VFOGcRPxwheJ4GdaaYA8bJBJ4yD1CW4tBqPbIrc2JJH/9Z5lgJFvzUmE
	PWpi57iHLhl6TyYT3XrmBU+Ya3i3xLRKTooeOn4/t8vNMYdsZ8YwKmvZgzoS2+PrBHRTzdsaR/s
	w0zKNNCRvaLiDh6PGamwyPEwZ+3+KJAiI4H3D+LEb3jU31NMx1vjXouA83a8voXDozJjFgscbi3
	0LVOpqwBHBJLJwuOmavzhMnhL14hoQCuNxp2c6TKF1n8aIT/QdOQIkN1mVzzEMgIQUgOIEZOFmJ
	ESGLIDqd8f8Ek2tg8NPXvdEqNC0W6GYiNl6jApdjQWaJUKH4umikUsY1ELwuV1TgqJqeCKfkaSi
	76xyHp2qaPkNniLWpwNiRzYubUBiqI5s4=
X-Received: by 2002:a05:6830:6f48:b0:7dc:d7e8:cb37 with SMTP id 46e09a7af769-7e4fa0657a5mr4988597a34.21.1778885387306;
        Fri, 15 May 2026 15:49:47 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e55b8203a3sm2289753a34.11.2026.05.15.15.49.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2026 15:49:46 -0700 (PDT)
Message-ID: <bc334402-c212-4a1f-8c81-6bb6d1de2f7f@linuxfoundation.org>
Date: Fri, 15 May 2026 16:49:45 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/474] 6.6.140-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/15/26 09:41, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.140 release.
> There are 474 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 17 May 2026 15:46:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.140-rc1.gz
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
