Received: from mail-pg1-f182.google.com (mail-pg1-f182.google.com [209.85.215.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C5FAD2C
	for <patches@lists.linux.dev>; Thu, 23 May 2024 20:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716496773; cv=none; b=ltrMpGK/eCvhtpOsjIMAI1/vXDOgJJGzjuNy7h3FBlbeUqiPuPlwDWeXh2SE/b9a3AkepTM+WyNm1NRWpG0JsThP0NdH08/z0OpfU9JZy76xncU3w80Nizt8Cpn6+yq6vnyDQNMXwM32h7/Zj/JuXrLssrKHJ3+d9oNiXwQOvos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716496773; c=relaxed/simple;
	bh=mgn9h28+Vwf/nN4w7oj/4mZLrW6UjJJC0ePuhv5zS0k=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZdNQpq5eoMaRFcUlxzcmvOGQd6p36FRo0na06skdUhofSYXcQHe9jyVS4/KSvB7w4/aEh9LyxUS/X0ve5irh30YfZnjLoo9zmnBucE8hX7LxIjIVb9GXsbcZDFnqnO/4tZq2x6yDlsCqBXxm3qGIreBNgi0/JrAuAAnCVAXtwLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=EP10uxML; arc=none smtp.client-ip=209.85.215.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="EP10uxML"
Received: by mail-pg1-f182.google.com with SMTP id 41be03b00d2f7-6819d785528so120364a12.3
        for <patches@lists.linux.dev>; Thu, 23 May 2024 13:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1716496771; x=1717101571; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=N2zukG9AHwYGlaUsr6ubbjF9W1PHQWW61Xya5qRT0JU=;
        b=EP10uxMLLj7JJ3H6nPvJmVQuLdEv4FS9fZ1OGXD/5V2fw5YwtLU2H6ajj96iSm58yS
         rCiHSiPnCUIHBZmexH2cQBsuq7FosPOqyFbSZKdIl41W87/1WeIcjvm2w1K/VRO0JCYZ
         HxxVMwvdtfIUvczXXiBr10JUoBlw9CwguJQlmRE7jG/hvUhlZkznyxVoA2ob7V78AYJW
         mMeMASLxw88oIo4oRfYu3dToANyeR/Y/KB2Dr1Yx8TTJ+ShR9ybqp6y6LUcdR5tn7ZwL
         eLiLQSt+Z2XI3w+ogxiWb4g7UEeB6J+MhofxNUVdhgrlZY2wgN/kZ+1J0WNmQYdssV0N
         XQRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1716496771; x=1717101571;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=N2zukG9AHwYGlaUsr6ubbjF9W1PHQWW61Xya5qRT0JU=;
        b=wuQDEBC4rR6NZF17qHgVmlC/j1s17oidZD1rvpbjmZ3aMb/rE+eBJfCV4kpSAvZWCk
         uhPLyYh/QbUb57wiQIC0T6XxXQyCimc5XeNlRD1pnyxuonKjSWqK7GqM3Y2WTfS6L1kV
         WT4aqD31/nzQYEUBwhcVvN3J2JA+b+s3kco+4EpPvk4GenAsl3RurmY4780x78HokYkA
         jX5D5QAQeyXcBLjBXA12t1R6G32sjW2iuHfPPtjW+l7Wz5GlS8krSOsEIT9k86CIQa1b
         9tg0TPBZxUARhAvkc/q3Rf4ksJm4xhMN/nFbFwhyFhI4kUlE9VNmYrosmBBaV8bqAFEr
         daIw==
X-Gm-Message-State: AOJu0Yyg1vTnL1KDF/bKJMF8a7n4Illme4RueTQwJkJ/7byLVU2PwWxH
	dKzT5JBHEuym5LzPAm5wZ/quYOkDsahgUwFJXkXLNUsHm95D7t0M6CULeZ6S
X-Google-Smtp-Source: AGHT+IEQGxnRZXZ0Qz9mZFnPzonGw8RgyMWgzKQck1ITAFDNLFtt2hC/kadqF+cH5aMwhgtwtMCbqA==
X-Received: by 2002:a17:90a:d801:b0:2bd:d2f9:c22a with SMTP id 98e67ed59e1d1-2bf5e660254mr289152a91.29.1716496771389;
        Thu, 23 May 2024 13:39:31 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id 98e67ed59e1d1-2bd9cf52fc2sm2315494a91.0.2024.05.23.13.39.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 May 2024 13:39:30 -0700 (PDT)
Message-ID: <7009aac4-2187-4c21-8272-ca9074edc4ab@gmail.com>
Date: Thu, 23 May 2024 13:39:29 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/102] 6.6.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20240523130342.462912131@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20240523130342.462912131@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 5/23/24 06:12, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.32 release.
> There are 102 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Sat, 25 May 2024 13:03:15 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.32-rc1.gz
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

