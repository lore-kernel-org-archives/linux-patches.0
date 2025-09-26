Received: from mail-pj1-f45.google.com (mail-pj1-f45.google.com [209.85.216.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2492FBE1B
	for <patches@lists.linux.dev>; Fri, 26 Sep 2025 16:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758904630; cv=none; b=QqIHZd83NorfWnaQ4zTpRuYIshvEcLDjBRsE0GPvIgI+dBSPrRk0IdB7AfD3zR9MKRyH76p/fWvOZxqhC6I+N2klTfH2B3haV5YC4y5KGkByTVgnbPLzoMzKV4Nd9Cct23DpPVqBigbtTDrgyWlKgQkiWZoT2lwbQ68N5qnwX4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758904630; c=relaxed/simple;
	bh=2ZGPXzstu1TTylI+9kAXEyr28KBi38NjPoZpDeDwVz8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DuGOrz1pqiDmCMFtxxbs6vTTOpMpHjX7wh9SAditT1Iu8PFmiIAPqjXhPN0g7psf0GbkPHx3Ep+//03B2RUzHxVuEnvlrJBXMWAh3Qc9Ff2lwIPyCL+p8Jcm/5S/nMjl2jUc+/x9CB+sf+MD1XrBtZscZrklKkPB8FMi7tmLdlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nPoubmvi; arc=none smtp.client-ip=209.85.216.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=roeck-us.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nPoubmvi"
Received: by mail-pj1-f45.google.com with SMTP id 98e67ed59e1d1-32ec291a325so1908993a91.1
        for <patches@lists.linux.dev>; Fri, 26 Sep 2025 09:37:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1758904628; x=1759509428; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:from:to:cc:subject:date:message-id:reply-to;
        bh=CEO+XfTYcR6Q4zzt0cI9zRY6H1ioqhyeSDjfXXab9as=;
        b=nPoubmviaCz3SzZh+gbmkTkhMDWmY84INEahHI9ucIMd6QZRB2OSn1uHUCNarNn0V8
         aI0D1HyutoC7Rynv41bPc5YxiO74jbuSEJ+AYeZeYuZZpDxiGkvQoc98ffE9K/cLQ6AS
         p9smL0nirzMYHYoGDmKV2kqMVlAuGiuIheykzGS1QZ9Kl19hcvKvIdjKFEes4tWiHkL6
         x0dEpM+ITDAyXrxL0gcESnYMCGMUtpP5XE8MIRO1ZHIgawH2xActE6P9oFgmM3Ko1qTJ
         vRmHDAOh1tYJEnfdKBCACXLHK3Fqox2ZJYT2UTBLXuS70VHM2SR9dO3OW3K8n3pVLS/U
         tZFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758904628; x=1759509428;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:sender:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CEO+XfTYcR6Q4zzt0cI9zRY6H1ioqhyeSDjfXXab9as=;
        b=uqSuexQpic+TXn0ik/3DLH5rFvPzrLHCzqg6+9xi/FPA44iRDjKTBrYID76mQlG0ce
         HW7LaNddmqB6MC1/Tl6ZSQjkCHqR55q4U4blkcHcl9qz1NYTr41zndqUuSJqeohOkXow
         rnFQ7l8sfqTy0tDbhC78AMfwCVX5jWQDVt5vVpuyBT8xogCN32sK253e5+Q4n7ykC2QP
         9LONos5s0G+OE5rYZJoE99Yx1HrHnLsj0pXrGEQdM0kb69jz8ZMVylml7vYyPnbc69ST
         WApwXlBAmpq1E0y/xTQNsZZWpJ77QMpIHZ+weMCQhYyrL/y078xV3P6NnyaxUkV6MMgl
         HQww==
X-Gm-Message-State: AOJu0Yx6j5+9kbz1CBeKaEK3WkwLWrHfnB6psWJ+RayqCz3GLG0Zrr7Q
	+4Qe/QVWWK+jCouDA2PULM+MTEgvVKE65+etZ1kgGxgJ/3UCxhAepNBa
X-Gm-Gg: ASbGncsetolWZ6fvgNWmG+4JsWe2khw4eNOkv83mMEBrCuNaBESE7nZWxLvvD+lCLZv
	hhh4w2bcYivG7huBFAQAO6oByMKAQamkZZUZbK0H1PHuPQLLQ2PuOmMybPeWPj34Ew71PHD7LM0
	+ajnZAo6+66A0IsZRayeZQzrmnn+y7j4UmpH1k7xfXqQ/clNk1KKSbL+73RyDrVJ4qurrISTaz+
	WvuOavv7t/H+wwkbKVVbBNG5yf18qkOxdibIgwGhg2gqsES3uVvHzMAyoaG437v3GJ3r3RiIHz6
	Impsm+l9CHe0/KuvEwKyaTyOCUPxU7by50kG7/bJxBJE94cbF8eLwdKr+jyKacKXMH/LYH5/39/
	QNHQ7wbgG+A3EgPtGPshsk+vUPJ2TgdQrgpv6vhs81fPZiQtexv8qHbCDFLBubfKexjTe8b4=
X-Google-Smtp-Source: AGHT+IEtPI4XHZichbwLh7xEHHZlnY4KYIiWjdrWSDbfypPqq5/Ag+ZvWhRzidu3WR0Fi0zeRJxuBQ==
X-Received: by 2002:a17:90b:3e8a:b0:330:ba05:a799 with SMTP id 98e67ed59e1d1-3342a2613famr8405705a91.16.1758904628421;
        Fri, 26 Sep 2025 09:37:08 -0700 (PDT)
Received: from ?IPV6:2600:1700:e321:62f0:da43:aeff:fecc:bfd5? ([2600:1700:e321:62f0:da43:aeff:fecc:bfd5])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-33471d710f8sm6029767a91.1.2025.09.26.09.37.06
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 26 Sep 2025 09:37:07 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
Message-ID: <819426da-274d-447b-a5b7-a28c8f535a6d@roeck-us.net>
Date: Fri, 26 Sep 2025 09:37:06 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/105] 6.12.49-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org, shuah@kernel.org,
 patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
 jonathanh@nvidia.com, f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
 srw@sladewatkins.net, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20250922192408.913556629@linuxfoundation.org>
Content-Language: en-US
From: Guenter Roeck <linux@roeck-us.net>
Autocrypt: addr=linux@roeck-us.net; keydata=
 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
 np3900V20aS7eD9K8GTU0TGC1pyz6IVJwIE=
In-Reply-To: <20250922192408.913556629@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/22/25 12:28, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.49 release.
> There are 105 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 24 Sep 2025 19:23:52 +0000.
> Anything received after that time might be too late.
> 

Build results:
	total: 168 pass: 166 fail: 2
Failed builds:
	parisc:allmodconfig
	s390:allmodconfig

Error log:
In file included from <command-line>:
drivers/gpu/drm/i915/display/intel_backlight.c: In function 'scale':
include/linux/compiler_types.h:536:45: error: call to '__compiletime_assert_666' declared with attribute error: clamp() low limit source_min greater than high limit source_max
   536 |         _compiletime_assert(condition, msg, __compiletime_assert_, __COUNTER__)

The code itself did not change. I strongly suspect that the minmax changes
trigger the problem. Indeed, the build passes after

df39a65668cb (HEAD -> linux-6.12.y) Revert "minmax.h: use BUILD_BUG_ON_MSG() for the lo < hi test in clamp()"
356a10d8a174 Revert "minmax.h: move all the clamp() definitions after the min/max() ones"
3f151683a9ba Revert "minmax.h: simplify the variants of clamp()"
644728e524c4 Revert "minmax.h: remove some #defines that are only expanded once"

Guenter

