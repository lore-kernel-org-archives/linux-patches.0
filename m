Received: from mail-pf1-f171.google.com (mail-pf1-f171.google.com [209.85.210.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FEEA29B8D3
	for <patches@lists.linux.dev>; Mon, 13 Oct 2025 16:57:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760374667; cv=none; b=gJenh/W+1PDhdwazHdUHMdu1XgB8mrOMufdQ4hM5oP7ODcmR4NTR0egt4TGSXHOPI1cmLcJKrmpZQXyrA6OUxmSRo45HoLLemoRV00JnYe9Z3XxbGV2ntlcFYuSqbg8OKgZBmbi0ypktRPuwEndWtJv+AvWcUmBdaaEKCKV47hg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760374667; c=relaxed/simple;
	bh=uIZm0faNhTPOO/c5jIlL+XBC6TybQp8kD6+Bxh0rKbY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MOPyJ5IpA5nkuDODSXoIs7xZrOBUvJ6IC1W8vU17jXttNiFSLvBoM1uDqzlm9/EOyyUUrTzJQQXaQy/9Ysx+ze321hkPS4glGzqG2dZrf0wjtiCqWJVXtB4fNOF3/p8CA3MvJ/OsvCaZt0O45UyHyVkup+e4fwiJQr+3sBa/tts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Ag00QkmW; arc=none smtp.client-ip=209.85.210.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Ag00QkmW"
Received: by mail-pf1-f171.google.com with SMTP id d2e1a72fcca58-76e4fc419a9so3983236b3a.0
        for <patches@lists.linux.dev>; Mon, 13 Oct 2025 09:57:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1760374665; x=1760979465; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=GIBQ7DXPPtVFtqnlKJKBgEnwsBKQuDpfZoq02adf1b8=;
        b=Ag00QkmWdyw0pM32uQD9EvAQdaTh20XlePX9tojVV7LeMSl2lBgV22WLJL6rbWSv/9
         er2BoO/i73xObn2a5OnzM5xSaisK5CgpW0DI9Xr9W/icWDYc50JSaAWQIoCBFi6cRjP9
         3eroNQGkoP6JV5EcbjXYvjOvrgVqBAWnhyJ+ApGusBHYkCK6Co3CL4gGrAsaBJO7g1lk
         T5cFpRL0jqr9Ithu+2UKuQd4Pqn8YCdowF8afaJ8an/zr/TPUOECwdXu5kduXO7yJomZ
         uuiuGG/Odyl59GdJb32ve3DomyR5nb/gaLotf5pk2mNQq851U4+jOMB9oiOBsJMcxF2a
         XTQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760374665; x=1760979465;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GIBQ7DXPPtVFtqnlKJKBgEnwsBKQuDpfZoq02adf1b8=;
        b=bq9IJjJqsdQvYL9wd+bvAsKUKumpwSe+5rYmM49k6tKKoY13OMLPw+uVgCou8LlG9j
         pCV7SfiF5olZKHCUfi4xUsBVFo+N8nSOOXagROYJSNJWcdU1zateqL9MWME1lnXdtoap
         bOLBHDz2CoEBdOUyuxFkY7oABkMJ41VzuPgWOas/nuJnX6bXy+Ktn//+4P9KwqC/tLaN
         jX/LdnNqS7yt/CjHyGp4nmeWFe45AyTOnvD0LE3shCgI2T3hXV6MLVs04SBJIK9UDVkU
         p7Pn+otj2EmOyGTDkQe/0mlN4LPgtmMsWc9sWlrzvZGjcfC9RJPi39PFeI9vHb4PFh2p
         0I9w==
X-Gm-Message-State: AOJu0YwFIr71A8iGW1AKCSBiNFMCYzfDv3DSlje/Cxj9qxwyWVWfeNnb
	9RxY+ekoAquAml3o45wxOQkL2vXRxh86tzBgXKpjKPdaELdU02WIXhSP
X-Gm-Gg: ASbGncuouEV1OsVcND6BmLwF2iRU6EXoqP30i1gps8xKnpi3Juf5fJisiHMEG/5hHBM
	qRy71jY6kxtGG6FId85LECcSFk3zCvnYNMlkLHiswMcdzuVykFfy0RO3bt7cjRQ0lU9Ewg4+WLW
	3Qwdnw5WeTI4f03PoU20NSJGYs+xrlKKXyXCjAOiS2E57JHC+EQVYiob7gREL2jRoXVvQlRcIom
	7YhumYOvHsog5OOXuzyI94YtZ40p7afDLJTrPf67i/R0qAKwvpHafmy3+mVk/yYJ2dIhrOe6kJG
	WCRPt6qlBuyWW+KFXyjh2rzNCxBU1lizlqTfKjKkFlUdiVyEQ6jYDrFyvY7MpxcKkTM6/EkwhWi
	eH/YBSCyiKTwPxRoPkJ4UzoKYH5LrzDqWLN8Wiyzl1kou/A6KLdJCxJGGwkwo6B+nZ+7imZYCOF
	vy9SN5JD5A7jSdiA==
X-Google-Smtp-Source: AGHT+IF/F1baTGtfkyX/X4yywp8EinMnUc951in+FzSitmy5hmr0L9dH/16lif2v07+i6Ky7Ytd7RA==
X-Received: by 2002:a05:6a00:17a5:b0:781:1562:1f9e with SMTP id d2e1a72fcca58-793880f0678mr29157568b3a.32.1760374665325;
        Mon, 13 Oct 2025 09:57:45 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id d2e1a72fcca58-7992d993340sm11936331b3a.72.2025.10.13.09.57.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Oct 2025 09:57:44 -0700 (PDT)
Message-ID: <cafe0391-a33f-4bcc-b2dc-b1ac524c31ac@gmail.com>
Date: Mon, 13 Oct 2025 09:57:43 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.12 000/262] 6.12.53-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251013144326.116493600@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20251013144326.116493600@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/13/25 07:42, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.12.53 release.
> There are 262 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 15 Oct 2025 14:42:41 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.12.53-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.12.y
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
