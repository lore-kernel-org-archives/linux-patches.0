Received: from mail-dl1-f49.google.com (mail-dl1-f49.google.com [74.125.82.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF2F81F1932
	for <patches@lists.linux.dev>; Wed,  7 Jan 2026 00:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767746759; cv=none; b=tKoDdy2KX9nrfaIimMvPfSDxMrsX2k8fsmGMLZmMqEOJyLeWYZQocOJ6ntL2TAtGkxx9V1P0m2MpzYi1EGzbOBFiqigaTNkIC2L8Y06Yk6bEbKEMvIQPeX0hxpQP94uP1CMY33GI1SGMAYvf1ifkImEOdBFGN3F5ibaSEJYbD+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767746759; c=relaxed/simple;
	bh=OFJYdoQzcXwLttrVoAzXKR+W7kolRRGDljGsgq/C/Sw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RhRxQa4G5fnOwbPFUPfQGOolcOPlJo88Yl2WgZS7pc/gcgsgECK3VifCN4AJvD7cNPxiiSC9b75ZRf8vrhRTpZGiqpuX0X12sW9xqHL6hxZLBku++RyYeC1GO/2immDJd4yPPAyDKuUDqCELVtD68G70A6WtaN2GzKjIBBckLpU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nVQMNDh8; arc=none smtp.client-ip=74.125.82.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nVQMNDh8"
Received: by mail-dl1-f49.google.com with SMTP id a92af1059eb24-121bf277922so1190885c88.0
        for <patches@lists.linux.dev>; Tue, 06 Jan 2026 16:45:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1767746757; x=1768351557; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EP297vg8zfSDiTJ6Zr9Nj0Ru1xEj3sVMbfXESAoNKCM=;
        b=nVQMNDh8Kte9XLMEpVVtwbr/ONydomXG1GLhlBNL41WqbhCwp7a7Xo1r8NGpFKulgA
         2/MbM4vUXD2guRTm2SNxH9r8TbOMSdPx/dxOHOb9o0WmLbQ0Pld2gNMNvwO1cZ83vZgT
         b4Es0lhlHSTb3xZzFBB8ekllTYI23YgvmZ+SWMBRBVuSOlrV9pb2XWgI9bPgRCg653T+
         b4MQljCpizMVgrayemVuRP404NkSFwShetkfwWo3tiDjcQhgxbIKZDZ9XE2UcYSDcPqp
         qvL9Di4Lx4ng6zhLs80A1WNwYHcFjT4puzKsRSd282ry63BWlEyp2Hj3D7d5gA+eB8sp
         ZbLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767746757; x=1768351557;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EP297vg8zfSDiTJ6Zr9Nj0Ru1xEj3sVMbfXESAoNKCM=;
        b=KVTp74G2ogiYjILL1vASa6cj8nbpEDWuT41tCsiASZIY6bwXYStN4pETg5Ns6SXXwK
         LquG7QDAdnA5/yVH+lEBqZWp78XnRQHS4KEjnU4rJNXvS4HUpPjWX+mC6gxIM1RniN+O
         Qxk/JmCSHBi1PKIUW9d9DCpGOldnZrEA8Mofip95ggwWfnYybW7hpBjqkHvCY5sNz2wy
         QTSgdtYIVI/BpmLCb1otXoFLZYMpTNaPBDJRHIVMYv6EZz1ENvZ5A2TmJLjCl9q1BI96
         eCvrGKAJELrWOJMgzNXncYMG9fQtTxKGui2f6HC3DoFxlRyRGFn8+jqMX4TYKDkL1IOb
         cxag==
X-Gm-Message-State: AOJu0YwaAvJtpFnf8BGIeo4cJwnf0BNuUaad6baKVrvOs/D5iXYF2KVC
	HDCLJuktbchzmzr6/N2vkYu4h6S199Dx3d2Ww8ET+wUDN6f9uFHCw6+z
X-Gm-Gg: AY/fxX58nuN3q+XJoa/zbDkAXgqp0+hpRDWIsjzzOgORVdXp+OcUERQQMMyQsiOZ/gX
	iltsQsSAe5NjvsAqhtFKduehEcIedaXriXGteLIqkrt0X9A0ZBkg/4kjerMPsSfOlhYIPlL28wT
	LLXaIXEQfMvZ/6dZsApAi8DI/hn1kp50DWgpmEySEtKO8Fc231xYyh/Ob6VhxC3BpqrmP6eIKjQ
	TmC0LMJdg8H1NEFwr8Fyfgl/fZJ5d2kEjp73VYLgRhWyHuGeh7CfF5pI5mZHWhqb6d33tNaiS+P
	3VVG09SYxrzJJGpAG0xnGMjS3JWUt4UhLDjtRMcc2Aloev5LGQr8Pl0FI9rdJi6e0Bs2/UAIw94
	RykuvjP3TBnrCVc48YOwgMhraxbH/MGD6DuizBNk3XiLW32tv68YPA1UBrEb9IJ3oQ+16ESPoR6
	C2WAUiOqTEeo/KIoa0nYiSml5rmVRTXs7gAdrVSA==
X-Google-Smtp-Source: AGHT+IFhgfq4svu8rEScbRNxmFWK+7vRCDcNtFHbpZcvY4SlIUakl2hZEI0cSyW0E0eQG/NGrc4izQ==
X-Received: by 2002:a05:7023:b8a:b0:119:e569:f622 with SMTP id a92af1059eb24-121f8b7a8bfmr483302c88.27.1767746756928;
        Tue, 06 Jan 2026 16:45:56 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-121f248c239sm6694400c88.9.2026.01.06.16.45.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jan 2026 16:45:56 -0800 (PST)
Message-ID: <781c6589-d7be-4798-9bc1-396d1f51e87e@gmail.com>
Date: Tue, 6 Jan 2026 16:45:54 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.18 000/312] 6.18.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260106170547.832845344@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/6/26 09:01, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.18.4 release.
> There are 312 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 08 Jan 2026 17:04:53 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.18.4-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.18.y
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
