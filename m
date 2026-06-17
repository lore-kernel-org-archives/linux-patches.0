Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF7C1ACED5
	for <patches@lists.linux.dev>; Wed, 17 Jun 2026 17:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781717027; cv=none; b=VJ+WWZJcOKjZgVLx70WLAKl9Kz5jP+4wAvuWWRa0+d8O+rC31/9X6YST/IyPh+KwP0wmO5i0nwq/Cm2y9ozHtXpAkcXijqh0jvpYeO3ShRBNCWkeMqHWlW8lF9D2eaAr6bSApCZK9pHfq5/Gsc4L+ZaeBmbKvLyelY4WP4oQarA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781717027; c=relaxed/simple;
	bh=LpkugHqniC1/Ud+acecpCwDNeyNZT1ZImtaVjAiFeWE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jtR222z/3DvY1gS76oV+y86gt2gNfnDm7n89JHMdmRhXCLwEtk3eeXm9darEYst4pmTAgyvBhqJWncVnJP5xadaVaC7oLEzgugMvXAVd8My5NzNm0cnDyzK+rltJKgnxFY4V1T9UVcvdbK9CpI70Kmx9ythOacSZ/3tx2NTgBW4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=amw3noAs; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="amw3noAs"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7e6d2f297f4so3696855a34.2
        for <patches@lists.linux.dev>; Wed, 17 Jun 2026 10:23:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1781717024; x=1782321824; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=3qi3a8oYApaPNeH5JbeamWYok+cJhMUB6yg9/Q+xM1c=;
        b=amw3noAsWygiMp7m6enVAo52QTG3H9x7aGB5S/MZm1YkGid5sVI4qyQKrvwhsRvAdh
         U8C75hPP01+0YkPdOn6HJUoXb88A6v189gygFrLaVQwQzfCuwFcrjSGSR32uizMgo/PL
         a2M6yiFDV+UE3pgPBnRJIfin0wtgJjY1VNIxI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781717024; x=1782321824;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=3qi3a8oYApaPNeH5JbeamWYok+cJhMUB6yg9/Q+xM1c=;
        b=J5MAOtqiw+cJRSMdB94fdRqoJ3SdMDN8uD+Sf7eXHX9Y/DUQOjf8qkQ/5HeDYbczGC
         PtAxadVi93ziIQsUEtF4nf79t22rvEl5s0mbuNGuqHmLOBttQ9k9kNXEmx0A0kJ3WHol
         NR1pwXeg6S+wTyQRbvlDXvnZHXIMIHIATagUNfNQ/Af0I07v7oQ7r7Rb9SJGJjcOUrF6
         NK1aG47QMcNxXsD96g8K2IDZmqhNZVB2fgAdEKW4R7qRvkTMsnmfAEY9gdy/UGJTwH6L
         o9cNgfDeWplDgQnXU0CIMwQPplcLKIU+EEEzz0QcTaT9+C/ZRHu6V+PgBbNTYEVIscPH
         RZqg==
X-Gm-Message-State: AOJu0YyU4Z7q8FAWFs/ncxXniW+rUU4XWjLnOKA3HPAVOnSasjGyAY9R
	WCBPXBNBi1QQqNGDSPAVBmXLf3TpoAGsjE+kv76ncWxhrxXt3F+bax11Ra71iSN+FiM=
X-Gm-Gg: Acq92OH37+MdXhKAE7Bx+BObFZkkT5i4ZsVAC1rJQWCcU65/TNyOzW7ftFQBD3xyvmF
	30QMfnLHVF71yfSQaHM0VZl0mGI/otIIgySCmWeeGAKUhH39+NTYlOYGe80Qt7yErWGPdI2VuvS
	NfU9BWzxDe0hLC514hiyWKJ2PJ08RlDXJOJOwIP2nCHy13nsxSJqkxoZ129meC+muLoPQ+g4VeW
	wCqoGAgg7PcabseooeKQ/AtAVP4ey27O15TDshS5Tk38hL3uqBmUFH3EUlKoxaSKGXY+eUj9T4T
	9bC3kb5yCmQIx/aKAEgN3sSQ+CQLrtTcZQQEzH2Z9/blnHB9FV6Ha24eQPW8kc+BKIpE1F7uj27
	A/K2JtVD2/SOWp0LMHN+K99JQgBKT5IB7L3j1pIYOK+Rakjajz7CMbvUW2V9YjlajvYvHaCHEJ1
	EtH/Fh52RDcxCI5F7GgoG3
X-Received: by 2002:a05:6830:350a:b0:7e7:623:80d5 with SMTP id 46e09a7af769-7e90b3f9891mr4771801a34.19.1781717024327;
        Wed, 17 Jun 2026 10:23:44 -0700 (PDT)
Received: from [192.168.1.14] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7e79f5bb5fcsm10283124a34.9.2026.06.17.10.23.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2026 10:23:43 -0700 (PDT)
Message-ID: <d266b43b-309f-41cb-a832-8a0868b8812b@linuxfoundation.org>
Date: Wed, 17 Jun 2026 11:23:42 -0600
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/261] 6.12.94-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20260616145044.869532709@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20260616145044.869532709@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/16/26 08:57, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.94 release.
> There are 261 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 18 Jun 2026 14:49:57 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.94-rc1.gz
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
