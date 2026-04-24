Received: from mail-dl1-f52.google.com (mail-dl1-f52.google.com [74.125.82.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFD6130BF4F
	for <patches@lists.linux.dev>; Fri, 24 Apr 2026 21:04:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777064692; cv=none; b=o08Z6HUQcQmgvdeogGJmwlcDsG6Cr67B1ufz9d+2e8DohMA6flKRxNsUqgAIYGIXgGH2bxT+GntpMVmHbZbVmdcJfsZsjv4HVE12wcntFzBToJm86/oZsz1Dt+YUKZ9LnBXOS2D4Lj6s0Js8CFZGE+yuCmY7s073Ohr7EVsZhfs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777064692; c=relaxed/simple;
	bh=0/KAzMQh92kq8MZFZL5e1nLouaj1ZWDwRaanPlShioI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AJo7tZ4c+y9K7+nuUP5KR2FAExsXNCfB9yp+wij4bskVCnl6ReQ2lXsAOIQ6N05HI9HvipRE9jx0B6qoNwV9MzuxZ96ewbjAiAODMqiZ2GaLbuvRd8Zkh1bsOItoM78ENLfuty1FqAMyHUTy+j5jp19poe3lEvfqnmmd2z3kbcI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=QwJHsJBd; arc=none smtp.client-ip=74.125.82.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="QwJHsJBd"
Received: by mail-dl1-f52.google.com with SMTP id a92af1059eb24-12c1a170a50so10664388c88.0
        for <patches@lists.linux.dev>; Fri, 24 Apr 2026 14:04:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1777064690; x=1777669490; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QJF2bMoTCrgLrGhdgLcSDtTCpej3MrR/F/jXKc+xbKo=;
        b=QwJHsJBdQ+qRPhyiZoHkMCvdVf/U3m8xVCy0eHWR3tfD5ZaSMuifgoa1h0HoaJcwzf
         YbHXza7/37svBitt8d2Ug/ccBF7J77M8P16wC7jUSZfrxF+apMM2zaAxCg1zBqkEWdQq
         48p5MqZ4tW3Mo7J+Emi8LvHx+LTCeFPYMRnzi08vR1mzOIEwOcMYABSwSWm9oGjusy+l
         KDNFdZ7lNfJaMHuaCivKQ/mNxvnNsQpl+8vifamrDAywks0F04A+Yh+xDA+JjqsRWwvr
         igv88IknTZxHDxF9c34IsKOJC+WUOBmgdff1cm+RB0eZVAz2TcFiVFcYvrGh3av7b/FG
         7Raw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777064690; x=1777669490;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QJF2bMoTCrgLrGhdgLcSDtTCpej3MrR/F/jXKc+xbKo=;
        b=c5FA5dPP0ZYRpaswFo/tkV9R/ghHFxtBviQhAN+80YkNZPIIgK6zv7E3ZNT9Ztpc3r
         goW22AC1T2ZI07bgoLZEURcKapoHSP3OLtzL1IEdbU1sdz8P2l7yp0gIiubBI4RDjoFn
         3CLEs+7b86yyRUQ6Bw7SEpjHcpN/ESMAjF/lBBP3Fr9L9W0Bttnw6lS8FrLRrkqI+bXJ
         NxN4kwQ8E4ez3QRTyvPHDGfZhLfAY16xT0WvEg5o0+Uebq4lvS18V0+LgeoiR/kwLBGw
         3dddTPACqmOnoFEz9S+sIit78U0VCfU1kETxoofTNoI8BIo/njJ7Y3e6f4/++CYGeAZV
         CJAA==
X-Gm-Message-State: AOJu0YwQXsszIQn2du2bIg2/0FDHZZS23u7B0u/QgjTrvlxPkQSoJyn5
	iO8+5QCJx7M6XUG6weBUEZH8WKzFhIKbTq9yw1xhZn1YkmWy3r3COZtE
X-Gm-Gg: AeBDies+LjGlIcl+br/UwDu5cWPA/9AeX0jxJ4ra9F/TtlJDxjBZsPhC+fnK9jQKbop
	dNGi6LkWbSJtCqyazHXb6idpnMr5qlYNTPu9LhlPNcif0f+QGgyUds7fQpZ5Y9cxjy2Nvg+2JSu
	HnkR/eArAdGCj7qRBRHLnA6PoRtF6QIYbw5yVy1YLUlqpVF4i0u+wgW3pTx8kvzPvGQnWS111Eu
	sjFpmO8zc3VxOoeM0pEIpG4F3P41/oSc80GlSR9nvQCB1SGDrK4SGy9y8ctBR8ErJo1kUUZSCbd
	0GoXlpZtMzw8KwgY1ePv92mmqfIknqJLmF/AolY1SISkCJXr8t7uf3ZVgLxfGR/2eOqlLZvXSXU
	wE7xvb4ZioColx7/PzrFVMVw5y/zuZvrOsgjo+d3tu4g2IQ4516Xxf8J2pbN38OjeagihegxYzr
	A492jKUF3sDtDOXpbjRfjcpwAqHCFdYd3GdY+KCL9xKRvnRanPSnL5xasKWbUN
X-Received: by 2002:a05:701b:2306:b0:12d:c3fb:14ac with SMTP id a92af1059eb24-12dc3fb1874mr1929800c88.19.1777064689672;
        Fri, 24 Apr 2026 14:04:49 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12db8684f90sm15698896c88.13.2026.04.24.14.04.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Apr 2026 14:04:49 -0700 (PDT)
Message-ID: <8a46ef04-1b7d-4457-9d1e-d9da18221e64@gmail.com>
Date: Fri, 24 Apr 2026 14:04:47 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.0 00/42] 7.0.2-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260424132420.410310336@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260424132420.410310336@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 4/24/26 06:30, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.0.2 release.
> There are 42 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sun, 26 Apr 2026 13:23:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.0.2-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.0.y
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
