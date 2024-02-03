Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8D6112E4F
	for <patches@lists.linux.dev>; Sat,  3 Feb 2024 21:32:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706995978; cv=none; b=p9cmJR+qbeRi/KOg9Zn5C5/3YGCLF+UmS1AuGzIkqLGY+50lxZXFh5ORK0VaQnXk0cnmHPZH/sumBaV8fdRGPk6eRDJwB13MC2Ds4uJktEMHECfEPRUyh7LGs9GbDiQOW0Db7CZ0t98zCpOdiqJwXfPZ413xObWGAt7I3Y2+ciw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706995978; c=relaxed/simple;
	bh=Q+ypL+7r7LGKJTlpt2JxSW5Xhm2c2GoeyyTiSedEHNU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=iDyhGrPYb7PbHWyiJPI++Ug/+qlLjFl3LgKh8rff4bNLnfTz87kRWBrYsKAxm6YZ58mFljKGtZaaC1MW883BMgINhg+uNhhWX2oSJYddr2s/ejTtmFvuo66FxGmpAmhbOj0izAPSvjftiCJuib2LtU7iyBFNFpyMLIhv8iX7+Uc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CwPTYzWf; arc=none smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CwPTYzWf"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-783dc658bd9so182940685a.1
        for <patches@lists.linux.dev>; Sat, 03 Feb 2024 13:32:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1706995975; x=1707600775; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=VAGoWDaCAmllD0xBrRiBwC90oxDOcMQb+WVxB91lwtA=;
        b=CwPTYzWfktqwvaeUViJVGfVCBVCOMZCiOnypOJVsJE3ksccw44KQ1/KIaVK7Tpv9u7
         r+ciIHtq10Tm3gPkUKo6vEmq9xokJy9+0jcRT+aCRba8MnEU92igf1PipdjOA7ddPtiY
         RxvSjdMPcGy4k758FWCnnBROdEdGVCQ/PNVVopJIkN666bKU0bO1x3hmYrTgJnqbYQ7Q
         34P6cu8BgQRBPdaeMcBNcJ05oSqRKJv3DXjHgDMy8tmFc9csPAdJiH1KfY4O2mB3BfNw
         cvqef/hRI0w5xP9hNC/l/Ax8g93PUh/LdvAsSpTjwhSonxAhIy1irKtkV2XKGHyagp0l
         wwYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706995975; x=1707600775;
        h=content-transfer-encoding:in-reply-to:autocrypt:from:references:cc
         :to:content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=VAGoWDaCAmllD0xBrRiBwC90oxDOcMQb+WVxB91lwtA=;
        b=ANYIO8zoG6W5HiiO2NnCm0Si4hGu3+8D0XLC9kG7TvpMijcULW7OgSR+CBQuVCbgu7
         BYDkakWjxqB3Z/RPAtbGszIfvPznnuBtkcJ9iiMWaU3L9PUtDEomdkxuZkSDrIDQJifH
         LVJ7Y8R3hMFiIUgoZtJEPV22O5vPC3S8zV4mvNg/vwLbkCVgsXKjEXqpQORn841Y8vSs
         wWBA3thYyZX94FxiG74+TXnShankBor/uvafGn6j8Kxhc5tFFlspCg5f399uNq3diefI
         p9Xx+nLKg7g1jovvcRuXluLRRco3ZymGL8OGhTtMg7+MfprvCYp1Q3BLGJ0b55Xw0cV4
         Rb7Q==
X-Gm-Message-State: AOJu0Yx9OkxIxzvjQ1h+aU6mpZwopHlnTn4SbcXt1/09CLsmr29O0wzo
	wPQ+FNjIi04fQCDQml8Avq1wX5i/omsytXDcBVu26qXS/6jDrbZl
X-Google-Smtp-Source: AGHT+IFq+iaOcyedgmkBKtHcp13uhNezaL6vS1Tbh/fIF4UcxkSNQzqma49Nlgh6C0WBspmq/9Zhkw==
X-Received: by 2002:a05:620a:1aa9:b0:785:56ca:2f21 with SMTP id bl41-20020a05620a1aa900b0078556ca2f21mr7292269qkb.57.1706995975619;
        Sat, 03 Feb 2024 13:32:55 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCXIABY7+aw1St0L6xek8FwmXBimYIdcvj96klH8syYuCbiQNNQssL9kb5CvN+aTyAQeTliQrl3Gxs74Sj/0YKZFqzyKNFeW2zbnxqI2Ftb6iQ7F9vLqFtbiw3XbOjQEJWAuLTHUQHZgcEHZvdaUoOjf1iDSdVLChxR6CZdr44a14eVQl6pcJob29bajPAVtO/4H3SMHo8RDpGR36l7KfUpkstd46LktTmZJLpsXrxDbpCAdrdUV7sdq+iUQUgTxfLpjezknSQTkFRXui8iKWF+M7pqLXmyX3uhP0f3Cqq8j3Ct9AnlOEtAmDqJ7r4cllqurey+5XuxFYFwLWegXBhbKnnXsCxcBTNPquL+Hj7Zb/XURgY1UWHJglrK3G6jlviUC4upHm7xvC7pUtRgKlPJj/erVLKQK++12s3KhUrH05B8YH3oTK/iDlkbdS9XZeYLVXVNZB/LNt0DrYjr5J9fTdKMW2wg/A08E6ipMzYFB2DJvdxwq6djusjIHyKB0+x2WhRbrusvr
Received: from [192.168.1.3] (ip68-4-215-93.oc.oc.cox.net. [68.4.215.93])
        by smtp.gmail.com with ESMTPSA id x11-20020ae9e64b000000b0078408c334f8sm1700780qkl.122.2024.02.03.13.32.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 03 Feb 2024 13:32:55 -0800 (PST)
Message-ID: <f3c74a9f-9288-45e2-a3e9-64bd47f94faf@gmail.com>
Date: Sat, 3 Feb 2024 13:32:52 -0800
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.1 000/221] 6.1.77-rc2 review
Content-Language: en-US
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
 conor@kernel.org, allen.lkml@gmail.com
References: <20240203174756.358721205@linuxfoundation.org>
From: Florian Fainelli <f.fainelli@gmail.com>
Autocrypt: addr=f.fainelli@gmail.com; keydata=
 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
 HGuUuzv+GKZ6nsysJw==
In-Reply-To: <20240203174756.358721205@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/3/2024 9:52 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.1.77 release.
> There are 221 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Mon, 05 Feb 2024 17:47:20 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.1.77-rc2.gz
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
