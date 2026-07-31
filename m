Received: from mail-pg1-f172.google.com (mail-pg1-f172.google.com [209.85.215.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF21745A2A9
	for <patches@lists.linux.dev>; Fri, 31 Jul 2026 23:22:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785540158; cv=none; b=Gqb2l81zpD5o0athaV3V/X45WoCgYq5Ch1V/lL6JTsRkWEcZvnMEkDHfXNMQqT06aG+or1HmX/bd72IjZlQ87K+i8vuXx73ApjyWmxY96H4hDsn/kA3q7iSOUYx/QypSDmzEs5dQDHO5fz6wfIZNInSd59CZLdsIXAAcdm5SP7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785540158; c=relaxed/simple;
	bh=Nmz2rJPRew4myJhDE5zms+zHCoWFtHuTj//LAkatoMY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jOdSjaUmNkr1U5E+jlMyGZVaCbiv0dhQFHg+ddltTXQRYK6UknT31/ZMo8MCAG2obpwFVN1YCNTBcwIkaVCPIAopUZ49YeHgYPnvMQYI1qIyIt/6ZjdL0fYU+8ahCO/7//53J75CsMZGVG1+SC79FRDkW7kmuJQxCpq5GveC9mw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Vypx85Bc; arc=none smtp.client-ip=209.85.215.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Vypx85Bc"
Received: by mail-pg1-f172.google.com with SMTP id 41be03b00d2f7-ca957432c7fso1010638a12.1
        for <patches@lists.linux.dev>; Fri, 31 Jul 2026 16:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785540156; x=1786144956; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=LltF+iQAYfjjcEhnwprlcO3IY3gQv3vBiaNLQtnKShw=;
        b=Vypx85BcuV9vxpiy7hjSh3yuvNWafG5FhJZQdQq7dw7UQ1LNakYFBmeLA7B3vubXAy
         sjkNiGqM0oMZoNRdXo3I+dgPVIeXsiItJ3RnGdcx1wXBkZW5imy9sxfpoQrC0GOx3NTb
         jrXYYRBPuB9zGzi/R1FqZlLyTdofI7ry0Fzsl115R61yuFacHfZF8oaSZLnKYwvQqz6o
         Zo3MSbKMBXmc0f+LB5jlYdqI42vMWB2Lc7yLemPold3bokkWJyYtWcx5x9BXEVr1j92V
         /DVk2pxzNctwk1xnzBnWy5hkvhV9GdWQcM2zojz8ZNeJIA7TGxB9pE4ddCr9jo7F4V+M
         ceQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785540156; x=1786144956;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=LltF+iQAYfjjcEhnwprlcO3IY3gQv3vBiaNLQtnKShw=;
        b=Pfl90DmjPVpMq17T72CIIE3J1mAPb5ruAxc9Ik7ICKaq3Rp/Z6UeofrV9vh7Jx2y9/
         iVuUUUFr+qeJbJmbEHNhuuxNjtVM4LOLliZ2DJqOQBdnjGm5TmIkXVjN/rgeGBz+8mxU
         ZLlO2Tdj5O1AeilxZAN9uIjVUm+MpLlVyndKC+wXguEx8XKgY16BiKRhkbfKmEOmKW6F
         L9Uj0mHyLZ2GBgSm7w5zVBU190UAO6EKlUTZZlvozZQD8hvfkyIp7SeQm9hw6/0wto8v
         EhVuQc3Xi81IWSG3lLfGPb6Olhk0l7M7Cq5Oa/CA7ageFzODvRoVgkLZExCXo6V0ZTjM
         wSLA==
X-Gm-Message-State: AOJu0Yzk/DwxWqkOTzEmrMF/yu7GdO/yrUztw526x7r/3vP0ZH5wEK2M
	bREyS/m9lrln0QPUdSAtnBWIsj8Y7BNQa8uZBsZwkgwcxXodf3z0sMIu
X-Gm-Gg: AR+sD11HeMvWYNMm4ofR5BWjMPUZ7GsFtzE94Ujy++TvJPLtqEKsESEfiDsdopOWsUB
	144xAwLdcTkTNrNTdBVAJSX7mIx+YY3WcIENm5aHaIA8s34MuOynjkeYY8ODBYFxfp5NG6sKf0R
	4m+yJFNa3/OE0I4D7Wn8q915NjRAgZOr+wfNK4OLsMo7TX/xbNWVP676La4772BDd0gZK8tu/YT
	zMSKVvUV31pDm465EJGutF4YUtPSolhEkuIbtsjkpTx9sll1j54rRlwU26ncKRrjmD3A8sKCnhy
	GlMW0CnTdLnmVaFwHm09CYLlFpGfL7RMqjoclme3rG3P9h2nLVJwMt9CdBxu5ANXvm9Sy1wAE7F
	+QVtO+2moOrVJXewAabEnq7WFkTaQ3flCaTByOVaX9RpZv8YSDPucZo60IJ+C18ylUD7khEhxKw
	UArjDJWsdmftBbpi7VVjVvvTzh/cpA09tNLmfNrGy3NaJf8zDiKavt9X9+qglRwJCLF7lDrukZn
	qGH7rOrlsRTrKE=
X-Received: by 2002:a05:6a20:258e:b0:3c3:a546:12a2 with SMTP id adf61e73a8af0-3c92a824e52mr1363560637.52.1785540156116;
        Fri, 31 Jul 2026 16:22:36 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3153ddcba2bsm10855613eec.11.2026.07.31.16.22.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 31 Jul 2026 16:22:35 -0700 (PDT)
Message-ID: <7734bcae-2c5b-4d27-ad7e-8fe9a57b7444@gmail.com>
Date: Fri, 31 Jul 2026 16:22:33 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 7.1 000/744] 7.1.6-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260730141444.267951807@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/30/26 07:04, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 7.1.6 release.
> There are 744 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 01 Aug 2026 14:13:38 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v7.x/stable-review/patch-7.1.6-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-7.1.y
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
