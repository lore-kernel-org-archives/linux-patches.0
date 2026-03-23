Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F90C354AC7
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 19:16:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.82.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774293368; cv=none; b=CmLc5h83AbTdnBBWSoms3xrBP1idxgIyjdNYEhTsZnYARv01Ebp3sJJHA9Mxn9mdwdVKNIbLrWbAoLOTusXYssfuBtYMi31Rh8ndXId660tSP0BMsaCI58h+ClmXSceavfEkDgJyj3jgbXopSsjEFsj4lROCPQfRbWWMmNaXETg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774293368; c=relaxed/simple;
	bh=LuskhlyNg0ufpBPxP7wKzs3JY0fbuHaYe2UNjI/yZOk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s+gULaSCRoWm8Tipzbv95IE5W2BpsGYtSuTATOEazYwjHu2sIJ/1zt94Y3S51jSDkWWsICzJhR17ir8iZ02ixH12pz93b5XuAijmIvwvsPg5627BimgeOXVBROOhieGRun81pW2GSS97WgEFgABRe5EO3fo4qvtkegXFTt/9AEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=IjRds71x; arc=none smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="IjRds71x"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-128e4d0cc48so3417028c88.1
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 12:16:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1774293365; x=1774898165; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ib4kRlGirFvOGOu/hN40SMIxQEJK6ZOLlpFibxVMz5k=;
        b=IjRds71xTGzoZS3dzxsEE0EJ8NaU6fNgMqqooJD+YL8r5nxKPuMjEK3rJPrqS7xGEx
         ZvR+fwo9/5NY917BcaC86wD+4RNhMvS+eQuqy3DyciKkqgLYl1f9GgipwcJCpCICMaRD
         ZpIwpFekp7EX1wR2dFjoaK5/7wMiAf9Nv3G+DBm//uD/6nsaMTf2mCSmURZuCd4d+nky
         kU0zwDblc0OfGslGcpilBFeuyc5S6rqOS2zb6ZSYqW6JBCdBbUjIQhhpVJ7NesJjeZ92
         fnxzr8VbI4poGy1qfqhehZr13H0CBCsdxEm7s4OrXT2UbDIeAnXmhECGtkjiN4yPhsCj
         sR8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774293365; x=1774898165;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ib4kRlGirFvOGOu/hN40SMIxQEJK6ZOLlpFibxVMz5k=;
        b=HPh44YfPp3uOBmncOIdaic1ApMFk40Nd2/OdDctj1O4pM+0+ibq8RewASjAn/rZZug
         dnB67Hh1K1zj/N7GF9U/V1E+pFXqBA3B9WxaCHNo3wrm7IxQikOfe19g2yP2ADza9bim
         hQuRAmZr+B9VWk0e+NFQdwqd77/cUP9S6TC7CPn/krdHw9GKLvQJtNZ5fL8lx4/jQiGo
         xTbjPm3fiHBY+d1dq7uWwxLfCr5b4zkTg6lEKbob1wCNjj4PWnkeAKYB1U+zx59YfxqT
         FE8bX5Ja8622x8r07KuEnVtbffxrKAg4J49NeAdVUu3+OURTpjjq9z36Fycm60YZ+5up
         tACQ==
X-Gm-Message-State: AOJu0YwQb+uug3WX9eU9IHbNwUrLxXNIR7vAiafbMO/k/3UhmnJ+9HuD
	TimDpugps55tzaTEltKZKaWHKeQmzEobIVJMpCYeWre6nQqUHpV5rTBTJ1fU9A==
X-Gm-Gg: ATEYQzzNDpAtwPTt9TgvfavX22sjfHRN9Z0A55xeAo2FKnxPpNalNFJhN2fZtVcJ9kK
	R78BQuBj6UZZj5brshC27ufd+7s6YsKOJC9Zx/aYYWMuHQyk6/BN1KHqkvYWtFwe3H/thRclMsg
	yPHS6uruw6D0JmJWjldZzMPjR0eHwcc40j1e1Y/BFwvDEgXv9tyx+dfLfOA5deOJiaKeYrGXr0i
	1FlmLFBONZEbznv48kkzgPzoGNT5hCRHVI2nzHNINyb/sGIcHOx1gMa2HeHUYN3Hup+yUoHVyO9
	kGIjtAwf1uLzHHpkOnvEq/Q3uE3U04nbDNNh4wpihzUwHdG3bxLsbEOEG+IU766IOkVPKMkfd1c
	2oN4Ux1rj/PpVCNSNrpmgf8K0USGzNBLXO0YSLI27MoYqefjqwZFid4ldSr1ycg2J+Q//SQ0+pT
	NZnD9IdaROlEhcVJYlcEQq4Xksl2q9WSggz9WPP/RNRP4y4ivREw==
X-Received: by 2002:a05:7022:6725:b0:123:345b:ba05 with SMTP id a92af1059eb24-12a726e1bc9mr5647972c88.22.1774293365429;
        Mon, 23 Mar 2026 12:16:05 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a92af1059eb24-12a733d199asm9456675c88.4.2026.03.23.12.16.03
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 12:16:04 -0700 (PDT)
Message-ID: <7f93eb95-7092-4780-9e58-a13e7634026a@gmail.com>
Date: Mon, 23 Mar 2026 12:16:02 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260323134525.256603107@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/23/26 06:39, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.167 release.
> There are 481 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 25 Mar 2026 13:44:33 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.167-rc1.gz
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
