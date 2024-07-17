Received: from mail-yb1-f174.google.com (mail-yb1-f174.google.com [209.85.219.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9CFC17545
	for <patches@lists.linux.dev>; Wed, 17 Jul 2024 19:37:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721245029; cv=none; b=mt6tbO484yPqCrEsQioFv1EMvdU2vKu9YAnTqEJiPOfqeDhNoAg1Ha+aQsFjx4NQNiLxNnKdSq3CvX7m0fndubOkbfvEvZMIFjFla87tokCaanNC7BLPhpaQQcxWBqwGm7vKW/ojlaSYsG2vhGPjcnNk9cm+wTJylscLC4VF78I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721245029; c=relaxed/simple;
	bh=e3rWkXRyMTSDQrTdC6NBk1oiJsPf0uUS1yTXMzMot5g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MSMMVVHeZdzGwZKAH0YgawG6Qf/mvmcYrf4ekkJGxHsdcoZ9yad3h3sZh6bq5vH9UG5g6bdkX+llEfHmV5LmGVMU4uGN5rgUDLf7SIqR3wdgvUcr7+YhOLwJg+MnmkJWTiTyu8SO8buOxdbAIzzrt07VVKTwlhSofxHTavmpH34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fddXfX3l; arc=none smtp.client-ip=209.85.219.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fddXfX3l"
Received: by mail-yb1-f174.google.com with SMTP id 3f1490d57ef6-dfdb6122992so50929276.3
        for <patches@lists.linux.dev>; Wed, 17 Jul 2024 12:37:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1721245026; x=1721849826; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=pKPozxotJ17He89SsoGOC73F0/fehg7fO9LqzjUI5RM=;
        b=fddXfX3lfdzhLqPy6XlgqXDNSEBw2Z3oQPDhZIdb78WWg1HOYe7OG75hwrnndvwVEO
         ufMuPg8EQfsXAWuqbO8oYZn5DOJcNa68giizaEgq3asxy/Ry1miRZI0IiEYf9ClSQRBM
         UDMb7XfZjZwoZBsBsK9/bkONjZ9Zh3idU41dn1o4eAibbo3hTLegQ+Exjwf0z6mTGLRF
         TFnSN+RVEaRPxXk2+PoDegfMZyppmZ2tOXIpsluAq+k7n66cbPijOoiouExzwkk2eBvG
         +I1V1HptKSGgFAeUJoJDUO5hzZunIyc0iZyXnESaxrhu4xSs5hn0BjZrTXG8OXTCRmvK
         nV3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1721245026; x=1721849826;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pKPozxotJ17He89SsoGOC73F0/fehg7fO9LqzjUI5RM=;
        b=spRe4KKdpccfGbgCsuE4mv9OELqG+GBVR9ZHD1FAQYnJ/uUumrA3VHDVGftYEReltY
         idA53XhAIdT3YRjGxXRODQ1F9NgNt/tsgQFhYok12FQ0ZzryvotyJnMts2Nl4uFbgiZ3
         rzRSU+096zRdQgOKkvjun1W3LIyjeo7qCh29qtjB+Yc2bMwKAuhn9oXLwYD414e1oDzP
         CwDvCw6Of1ndAoV8c5dkcS2ksLt5bFNOltbrLOikcs9bdmgk5wT9g2K+U92JrdBTsVAN
         gBwlt3GaK9Ff30RHTBvNpXj2Xnp85DSq2aDeGDmyyi9TFXa+QsxIGmB5krEM42NP6031
         v57A==
X-Gm-Message-State: AOJu0YxD3jygaN7/KJRyESaNVAkMiBb9ig+M0Fwe8ol6PUEJT8ZUPLWh
	+aIwTOkXd/kP9k9LZx3j99J8+2w7rgBRodJFBU2b1hXHdoQAkig8
X-Google-Smtp-Source: AGHT+IHsdjhHg5mdI8hGqCe9yn7NB+DeyAiOT/bpMt8aIlkMs48uDK4BvQCahfyTZgtpL3mBN2U+Qw==
X-Received: by 2002:a05:6902:2189:b0:dff:338e:4f6 with SMTP id 3f1490d57ef6-e05ed6b9380mr3548069276.5.1721245025627;
        Wed, 17 Jul 2024 12:37:05 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 6a1803df08f44-6b79c519008sm1644776d6.64.2024.07.17.12.37.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jul 2024 12:37:04 -0700 (PDT)
Message-ID: <fd6f3fd1-afc3-4aa4-bb3b-c14335703dbd@gmail.com>
Date: Wed, 17 Jul 2024 12:36:59 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5.4 00/79] 5.4.280-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240717063752.619384275@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240717063752.619384275@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/16/24 23:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.280 release.
> There are 79 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 19 Jul 2024 06:37:32 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.280-rc2.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
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

