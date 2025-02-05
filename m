Received: from mail-oi1-f180.google.com (mail-oi1-f180.google.com [209.85.167.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A96661DF242
	for <patches@lists.linux.dev>; Wed,  5 Feb 2025 17:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738776357; cv=none; b=ck1j30AlyZ0W0Vj682JOhF7iVUP9x0RvMne6loUgFg1BrkVx9KJnCAbyqfLTojFfGiGZTFvpfT0nebAQA2qpdpXABKrwhorlQALp2WfBUOKYcHIgRSvJElItCXLzP8mpCxpm+t4MVwFUxQ0+DNNNfqEGPXNEzkx9JaDmynctnmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738776357; c=relaxed/simple;
	bh=4fZ2waS4Le6CZjqkUYNRfumY2c2UMR6bpbsXUZLjIQI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=m0mNLSs97b+/km9512Wj6gpHVvxp5kznO9GAprPGneRmxd5G811GEWe8UkZVdsk50X1uTopHE81svbHqkqOXBDneWy4DA5nQcFUsfFQHbactaX1AnyPkFhOIwaOpHukEnPqzED2WmKpLN/AYJm9bsNYgVpwFDQ4s3QYeciB7Lvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gd/mu4xh; arc=none smtp.client-ip=209.85.167.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gd/mu4xh"
Received: by mail-oi1-f180.google.com with SMTP id 5614622812f47-3ee29277d44so17652b6e.1
        for <patches@lists.linux.dev>; Wed, 05 Feb 2025 09:25:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1738776354; x=1739381154; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to;
        bh=Z/ljvoAbrblzPWSlWGaI+of7Rx9z5FMvqfx035HSCoM=;
        b=gd/mu4xhjCJmT4YLK/gJ6IXHxS0rmLakr0/hlq8FrOWy4cFWIiJf9+4mBURZQ6eu8g
         mKZvwAbzYKX1gKcdYI+wcoofSxAldcyuNgwi0ppHOlwJyBjHufZzbP+7uHfGoyt75BTo
         ngoaqbM1+2S1c7yuxhy6m0wXcC+QAUsWcP2l+i7N43J5RTYJFjMVbPJgwdf9oYR+e8x7
         dsb7arwNr30qYu63Zs0Hi99CQcsdgoFRzkkZKc8ahjF6TKQM9eSyW4Xj+i1+lmD0adFy
         1xZmZhDYN+XtNXKegLRuPwgO+xbaUAsZ8v3iwIZ6j5a3ZBtIBzLMUPEUrd17+apmVcG/
         rDMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1738776354; x=1739381154;
        h=content-transfer-encoding:in-reply-to:autocrypt:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z/ljvoAbrblzPWSlWGaI+of7Rx9z5FMvqfx035HSCoM=;
        b=sxqnn+Dq2zXmIs436tZR0STd4EhPSJJQvjlWfPhCiwI4Ne6/Tx6th4iVZZZ85U6rbM
         Ftuilb5obQB4yjWunW4CvvND77dxDj2r6c62vwT1wSOE7+8p4h9WaLlE4bsUY/VY4ItL
         nE4m/OvZBgw3MpIyP+i3Bq1eA+OUooQW0cj1ORP28anPRK6A/wouTnSS4k6SiT7RkP2n
         M+Bg3bCta6GB8J38zgZIHsgPoL2BZ8Fvy5tx2Xbga5MPBIZgNbFxn/ynsOgyxLwG9tpV
         7ZFvsc1dxyeQmXE+JIKh7Ai93MLfQygGXA7hmoSWn/QU5tbTbD2kvd3gHFKjOilmxER7
         Dz9A==
X-Gm-Message-State: AOJu0YzLklM67HNnai4G5bUR6lCA7tekke8WKgQaYdqo6Mv2a3ceVyQ2
	A6OPMWsZmKP8A09H343KJSK+mSMh9aVPgwa72Wq7OlQRzs2Gya/t
X-Gm-Gg: ASbGncu1Kw6DsHlLMhPBquLVqDT5VQkN8BgoRDsYI0xYoSOAgCGAnwIlXKaYTllcV3H
	8m7areLJtjpXM2px6fsl4F2GxWUqg+u5w5PnjG2S9SdT7HIeCCpH4AFHqvQcWjpbq6KVS00qqQZ
	6v8WzWn+jCnbpLSDxvtH1jJSYtiFH2Qzq+IuNnHZ4BhnRta+kGNJamsgZalOra3BR7JV6wFGIbg
	cyoKZhOWDzNPokZ2MSNoqirU1EsjwNv+Zsg41a+YGjq5V4rRB9yZPLWTRcfezm6DfkUQZINOHPQ
	6Y/plF/TBiC2URC1ox8SKV6oBqdyUn1afeQuH6oaL3w=
X-Google-Smtp-Source: AGHT+IElJOEwGJXcpxepx+lPh9mZuSv1BA33+xNsWiHFiM16bUf+mtRCpLAXHEId4Tc49SoAgkWDLQ==
X-Received: by 2002:a05:6808:13c4:b0:3ea:6533:f19d with SMTP id 5614622812f47-3f37c178fd3mr2824741b6e.30.1738776354479;
        Wed, 05 Feb 2025 09:25:54 -0800 (PST)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-3f333523f8asm3614380b6e.6.2025.02.05.09.25.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Feb 2025 09:25:53 -0800 (PST)
Message-ID: <ea7aaade-b942-47a1-85f1-1a222efbf545@gmail.com>
Date: Wed, 5 Feb 2025 09:25:51 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/393] 6.6.76-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250205134420.279368572@linuxfoundation.org>
Content-Language: en-US
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 2/5/25 05:38, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.76 release.
> There are 393 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 07 Feb 2025 13:43:04 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.76-rc1.gz
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
