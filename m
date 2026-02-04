Received: from mail-dy1-f169.google.com (mail-dy1-f169.google.com [74.125.82.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78E65267B89
	for <patches@lists.linux.dev>; Wed,  4 Feb 2026 19:52:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770234768; cv=none; b=nl0ktmtgPUBfCd/7Gs3W1piKm7bWuMF+j5q6l8XxNLL0lsIGxOdmD19z5Fwdp7oBfXRJZlvzCKNK7/W17qYlqwjQJY/UyohllO/wJljW3Q2D3l9ShP58yFUdfFAcHQu2Xjs23hPKnN/fUTwAjOrF2AvRtQfh5H6lUTjhtQkuziA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770234768; c=relaxed/simple;
	bh=eOs5YJhuIMFvF5Pyi5qav5mAKRd6Smea1vyT/LCMguc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LsyRlc5Vz3oXFbDGr8O0bztodubPQMB+HCGWHRPjBBxaOiKKB90iT2m5CDaP5tZGwRCVM9y6U/jGCb6+WG1PXA76WylkU0gkbJgzyyQv1aCqyOEqRXNvWGMQfxCiSnRwHcDPgSEJUULNNwneRHexFY81sc8U0wBvdFoXpLTqwkM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UG1uarqu; arc=none smtp.client-ip=74.125.82.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UG1uarqu"
Received: by mail-dy1-f169.google.com with SMTP id 5a478bee46e88-2b71515d8adso94340eec.1
        for <patches@lists.linux.dev>; Wed, 04 Feb 2026 11:52:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1770234768; x=1770839568; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=43XEN5FRmJdXIAFFjkZ/WehUolYnNIeYiLFrpcT7fUM=;
        b=UG1uarquwjzO9/UBKcKQxzMSSN4LK9onF1hbhdvb5eryxD5jWYTFx8WPKO3RXI36Nq
         TIGktxjBMYURIgkAmRVGgYUJ/qB/QpVPRH9GkKHkLMKiL+66vJR4eRY/PdVoBQD66ICM
         DsFOVenC5FNpnPSgp95EJMiaa3AOSvqpPqy+a8sCLc80Meypd0i33vGE1sNqPNwNO71G
         p9RvnkYKZT9rddT2jnUg4MLgZd4xN+DhAZ2ku4XsNVOusuLbAuINr4mCnmdCwivm/bTo
         5r8S2gcrDNUheBXF0W7BEKpSZ+AooDQ32Q8BF+RIYir+JzxdQ2DRCIfSpdDw5JufjmvN
         APQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770234768; x=1770839568;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=43XEN5FRmJdXIAFFjkZ/WehUolYnNIeYiLFrpcT7fUM=;
        b=vGFHJTzATTJcr0BgHIMjy2nMIjiZGn2MP+eUm+YCNM+uMNdWs9x23RIe/z3P8UI3iA
         UmXNVDSszBLIahM49C+wLqx7mHxICaXOSc8NlV1b19i5VeOMZkBQ0hQ2KaOp0ZGjN6IM
         5v75tm0t4Rf/VgL7JHjkN8P+w2oc5awcHhYgfdt9uWXrbpskAlwV2vKQwK4jV8pOUn/S
         sxW+lHy7yETOvjpp62F7XwkBlPHFQavjGGEZmFORIMr56K8XwVizhdzyPN80dIA0TOgm
         Zx8oPx15q8hv6wMAAwgECy3890VCl7e09cZgQfSPTZXXGEEFUyqv5BkS/zJhtCg71aDk
         rrUw==
X-Gm-Message-State: AOJu0YylkSEubIgMm5fkmshHNLIxIk9mszk89aGzX1xXoimACIBYhkrx
	TIPorduwmkln3MHOTWEn3C9ePX1qh1m0jW7iFFoDMRVcRKpwZMVez7Qy
X-Gm-Gg: AZuq6aL7Q95CBhPT8KRByBIwTJiJJgWRD/BQzFTWwIyL9zzpvqnIPhWrpPZasyNYC4J
	RiYQJ5KIRE7SYABk4FDtA+roKyU2OHKTpA5b6r+kG4O9Eq0eVGkcPdhdFSllSh/8O7GZzs6AHqu
	RfbS7SaBTK+kLrDjlLf4OEjQ11BtqQnSjILwFCWTL4IJHGC2UT8e1T8zyVndGL8ZIc74wkxu2XI
	bx5tlzKCXnuANkbVQdOJNRqpMoH/t/rGAHXPvW/+TnbON4tjPBFyXpxw8kqeAk3MHlmm0c4nBKJ
	uFCZVgc/ML/zXBwEftPY8Wdt/l5HbMUS7+5gQ09qLk243PCz/KDkhP4qghOwN7xAjrJvl8ShpKi
	Ez45Kw5zsT0FX/Aqzu+fgRmKmKDKKmcNdRDCLbrtsIyh1Cz+KurditrJo0tmN9MURgKwdq8rsii
	cz8QR8tXycqqkEzNYepZFk8DsjSMYNpapmU5Bifw==
X-Received: by 2002:a05:7022:1b0d:b0:124:9acd:3a38 with SMTP id a92af1059eb24-126f47dabe6mr1491565c88.35.1770234767516;
        Wed, 04 Feb 2026 11:52:47 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-126f4e04297sm2686236c88.3.2026.02.04.11.52.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Feb 2026 11:52:46 -0800 (PST)
Message-ID: <52f93069-ee1e-4763-8435-5f18b1631c0f@gmail.com>
Date: Wed, 4 Feb 2026 11:52:44 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/280] 6.1.162-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260204143909.614719725@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/4/26 06:36, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.162 release.
> There are 280 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 06 Feb 2026 14:38:23 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.162-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.1.y
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
