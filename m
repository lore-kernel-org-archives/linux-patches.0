Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0645127FD65
	for <patches@lists.linux.dev>; Tue, 20 May 2025 18:37:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747766234; cv=none; b=NaR7UECrCOnSRpJBubccIh2hlAYDUcBH9KcVGY1vJ+zQg0P0cY93kcCPRda5qgx7O2/LECbDfJXWi9Wh8pV5UAB5mSCzWx62bapSXZqtacbbrW9lR5JbSZLw8bYICaFPf66jMtQXE1WwDFbtgsj1Tmob85c2lX9F0cmrG/b9J4A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747766234; c=relaxed/simple;
	bh=JICM+9CpN5Uqo5Bozrviogbjrl0NxiJgwJj3pDdrHIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=euEVCzSNncKyFbHnKozbc0v3PZEOOusCt1sgF1PtMsf+3HEZjVmdynpa0RVbALCe79+l4likr3VzqEDGh8lr0nAtQd0f0LXFRIQMkZJMg4PStf259NVPktRhs/f1zVivn6WY4yB/6wqcBl+571kdMHCNDmVU9YE0nf9l0en3SNc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=HbLP381Q; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="HbLP381Q"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-afc857702d1so5270373a12.3
        for <patches@lists.linux.dev>; Tue, 20 May 2025 11:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1747766232; x=1748371032; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=dXwsJAQByoOrBBaZLY+E7MZdLUJE91UXwKqaAsM/qoY=;
        b=HbLP381QVDZS57LjwF+kWk46wb7UdSS7sb8AMz3+BtuKlqqehZ7BqT8jn6UISjkOGT
         DdAfWU3fQ6Hpvc1+PSAt839SUrJ6lHlGWTXs4x1EGTvCTlG9cBpyku2169YQ1mdfYrKU
         ijvexHAhvHmgqhvwKRKVlMdFTRFYB9UWXHJh02ZuPeURz5sgUXu0qsibCcBeLSGfBpEu
         GlSxB3X5pkz+MjGekswo7PFJ623C9apETUmyu5QpFTJotqeb7LIdhWXZXxNh/pNlyEAh
         quWbrP641oqtX36SIpdV7p4L8nlUeE8EcG2XJeD6eYT/+H0qyjIy5d9aKpeBdjZjupj6
         n6Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747766232; x=1748371032;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dXwsJAQByoOrBBaZLY+E7MZdLUJE91UXwKqaAsM/qoY=;
        b=DWgc0HCTPAYpd/v6G4p3UdxWLu1oXuRahJI7MlASFPayBtCRMmoXIKHc9WSa6E8ZiQ
         u09QcC6dNh3nM9wEweLb33tq0d99/+G6/qpUJbxEyHOLKBR8eFo5ia1RLFuuqLz/1KE1
         RxtS4s3mj3B784du32qsojgDnfIaWFQw3KGsN8ckjynbPcA9OoErjShMnSlQqmnNwLSW
         oRNcslMQWQQooQzTY3l8b8olouiYQzO9QIJ2Kf5SBKrISDoA3MKwwaL/Z5SdZ9zs/IUG
         hqwv8y8Dc3o0wYVc+vdV93KX2/3opXlO9nhJqUbVUGSFbscPbn4jsPptaxSSQq63TM/o
         0U7Q==
X-Gm-Message-State: AOJu0YxiC4rXlnqMmzwWHIxkRauhPKKA2/awTQzX2smUe7agAZFCYmMv
	xB7hwUZX5ECcqVspbjvjGHxU7kDOVse9Uoqjf27R7clkc+2WlJbnE9qY
X-Gm-Gg: ASbGncuHRVlFRLXEQ0Kzq0k03iupd17yrlDv9hNuWCfIstsPLPJZEm9mYQ2l37HLZqa
	Ir4NzLv2Iq4BP4az+uTgMFtHLfydoxeo8GtAvkbyHsnBaA3kx2Pq2tVBPBYrKOn6TwvzBKm4yKn
	g6mfAWUmSE4u9ztFl7ofEmbed8A0Ph8urPnkF0HMrg9Li3MvJ/5tK9wZFd3PiFGKa6VRxZ/Jl2a
	Glou033yOTxZG4KOBgvlPDqGYZrcvIdU/pJ9wNebl4vGyYraFZN8jMvcIRdpb+GNrVdnuHcmEof
	Nl+ox6TIaOLrU2GTOkThk4zKNkc9cCqMlT0Kk6cVUCNd8WRLO6yxxU5lH6e3ScYlcJkzV1zd55P
	zYtE=
X-Google-Smtp-Source: AGHT+IHJwFKbXVkEArUkxOuEvJRbwPQDqevlrFfXVoHuv3My4z4Pnv8EEjI6190Q5SCZg++y7mtAZQ==
X-Received: by 2002:a17:903:b8f:b0:224:c76:5e57 with SMTP id d9443c01a7336-231d459bee3mr241144295ad.39.1747766232192;
        Tue, 20 May 2025 11:37:12 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-231d4b1020dsm80019585ad.104.2025.05.20.11.37.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 May 2025 11:37:11 -0700 (PDT)
Message-ID: <d087b0b9-1d87-4049-affb-7220d9b96f3d@gmail.com>
Date: Tue, 20 May 2025 11:37:09 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/117] 6.6.92-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250520125803.981048184@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 WlfRzlpjIPmdjgoicA==
In-Reply-To: <20250520125803.981048184@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/20/25 06:49, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.92 release.
> There are 117 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Thu, 22 May 2025 12:57:37 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.92-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
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
