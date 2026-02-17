Received: from mail-dl1-f41.google.com (mail-dl1-f41.google.com [74.125.82.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5D56313555
	for <patches@lists.linux.dev>; Tue, 17 Feb 2026 22:12:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771366322; cv=none; b=m2bRMerdpM1x2W2hJu+TyDJQWABrZhWujjap2ju9qpuj1rFBdb2DUl/hwqkEkLqwny1W1kmmhobvROYOUDn0D+d3q68YQ7KDvjZH6zpDj6/Kqfz91Ff78sxnLnN1HB/tz3GZpnc7cFJV9vCjvjbnJ7h0m8iyggmxK6e2aWAMUyM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771366322; c=relaxed/simple;
	bh=roEb2ORdy3Sj3LiCS7nk18n1HYWQa3KItLUCioMyWKM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=VO+gpYPQyigX7AHo9u7462fR4Ir3KhpH4Y/EFd0l5OMv37wltt3CZgbMO9wbNCm594s0V8yr6aEbx1rYNKOMHAmrEdUVpxA2rxzFjGfPRcuGvJixskgHqo34MGgoZRuFFGD7kkJTEst5mqfPb4YN3EQL3KXLQuK6jW4juNGaybg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PYSxs4fI; arc=none smtp.client-ip=74.125.82.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PYSxs4fI"
Received: by mail-dl1-f41.google.com with SMTP id a92af1059eb24-1270be4d125so5390564c88.1
        for <patches@lists.linux.dev>; Tue, 17 Feb 2026 14:12:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1771366321; x=1771971121; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lozsS/7o38zbQYiHv44V5EImHqEpM39AYU+mvtpIJxQ=;
        b=PYSxs4fI6WUeIeg8uB23SQv9WRVkcf2rUS/6JUI6hemdPdUKB+q4KP09O6dU/zs1xA
         7iaMojtCuK3KxeAemOL5hYDL1lUbAu6FavBM57HQwg41pYiMQOtK74atvN2FbZuClRp+
         BtUsW0jGhCMfkVM3hsmR2C+Q213qmKQTQzeRREtXrIwNvHg6i62vsUYlNVb2sIawQuqf
         QcKWnugYTB79Bdy40bb+KORWQy/6QyeVDZyhEIQxJJpDHoUVkkPbpQVNSzuiXymOR//+
         TacCSzJnV2mFU4VlYRbz/+Gu3uZkpIbq1QgisBPT5cW6eEO/sNs+/4cA7v5Wb70yl3j9
         rASg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771366321; x=1771971121;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=lozsS/7o38zbQYiHv44V5EImHqEpM39AYU+mvtpIJxQ=;
        b=Qij/GVt7uKQQx13CEsUPsZwfjSRWOaAqvlRee57KsfvOwycKqC1NiX4wM0s+kNZjXZ
         ltBqGiStbJqM5m/ZAzrCJz3VQIIEZWQSs7GzYO0tOkXi1RHsLHsxgXr0PUE52xVHLHXh
         fQ3g6fazvlhwDpDApEyMEYtZs2w8onLEDtXEmTK/EYb46Rwj8CKKM/EP9HS+bH68DfT+
         TUklE7yBidVxI4z3Fl1xApdU3rA/wJAJRT772GvV1Ri8pBu1i2oSC9l85vKsKRmN3QPO
         1iu6DIxsLPVVdZ+R49VNa+a4ES6+O6upjvC5qejJMp5B4XIKWdWNDzTbZmskFhHPXjNC
         hyZw==
X-Gm-Message-State: AOJu0YygVG50NeKJDlIT9QNHzL3++ZDksJxTM2RILoZlYpthqODmEWxa
	FeI3pvHZs1R8ThI6VyOptMpmSa7tvWADb0MoGU77STLTIlWvs4Vv3RlX
X-Gm-Gg: AZuq6aK98HtuQjwpoJEgiL1dPf0/wAN57NU5kJ5JCtEIHIq9Bz20RCebyzWMjFrXimV
	B8ocVABMPCc2nBXmhxrELq9uwBmKdvp0RAwBqxHQwPEBrIXDEVcKS86fnZABbHFdapv37uFRz44
	QLnE/aQ5Q7dDkFxUND2hy8TXH+USjXilenDVArTBnrhGCNL8a9+lPYeVU1y8iIuiCharUNJIk+Q
	zAHELRLhIcm0ERb+sA/JbLKn6uQ0cFxTwHYvp+fdzyKkWLAqkf5umpQxNeHnXRbHJHCRlQaLAEn
	OMJ1m9s0AzV9n4yXvLiyJC7Fmb2yYc31b06c8cdMOsoYo0ZW56R6s4NL4EcohSSsh0KvAT7ItIi
	L+S1smvEq6uVPSEsmywO3PH7yLTGg9PcW5MxjK6bZe4fSoRCqdknbrTjiCiciB6EMdkj3XlHqOS
	WrkY0OUSSRltF2udX6643gs9ptTPPBTRFpANykrypdEqvg4XEt7g==
X-Received: by 2002:a05:7022:2387:b0:11b:ca88:c4f9 with SMTP id a92af1059eb24-12741b6352cmr5432797c88.2.1771366320759;
        Tue, 17 Feb 2026 14:12:00 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12742b61ff7sm15593121c88.2.2026.02.17.14.11.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Feb 2026 14:11:59 -0800 (PST)
Message-ID: <5a20f94c-655e-4ec0-b421-d9cc28ea3ceb@gmail.com>
Date: Tue, 17 Feb 2026 14:11:57 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.10 00/24] 5.10.251-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260217200000.708219618@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260217200000.708219618@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/17/26 12:31, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.10.251 release.
> There are 24 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 19 Feb 2026 19:59:50 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.251-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
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
