Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793287708;
	b=YdZyGyAtbKH6QWHRUhHXs83pJou3MhVhfoAWwRvjoDt8dT97GV4GP4g4Mc7Vk9334pGV
	 sLiF2GUjdmmaHmSBIxexjWX2//jYxkB82FIVKELdAbpvOYOcClUEV5zT9YIbOVtzE/pAI
	 rwtkRSFXm2ppovQfaOAVXgbdIBnjS3aAOy37JjuXspJMYShEJR1YB4jdYIIbN9x9j5Omr
	 ry3bq68UmNrOOyDJ7ZMUs+N29jjdZlgCbsYz4DOKirZ6nrN2TvDRkqQ2q9bJmF5SO+zca
	 FP76gMgbUZEPJTxntGCxNtVs7REhOOJ2l1u95yY9o+7mF0fqw8k/T4NChNKjmA3/uZg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793287708;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=yZTE4OyXfMuvSFj9u4UbsZSTrlYFDczLFmxLInU5s4g=;
	b=Qy40N0WCMXmceeBGp3xqsYEYQAP8EjJtmr7OT7HCDPUYpHPFLgjiikt/7b8iybw+pJa5
	 9qTSclK3dl+PwYDntqMcXUIv0Tg2u+bCH6k7nCmGaCniHszYHQ+FpsPepxylSjtuldbxM
	 TvYNpeSaOEDc9ME7+IaMdOy6f4K5zOPhKdZKV4eo/wXha509dBkfKzhs8SqGZ6lEywyvq
	 OxVmquX+SroogyvYQbJ7zC5CWRxHFMgn1F0tKBEWmSGnTYM13o8hkW8WTXl2z0xlhUYHe
	 G95/vN+Lblgw/Io/aAE/QIgmbmqFEzuFMZmzqZxCC1wSmgqoFAJRRzA3O+A8P9aN1DQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=edkTqdxR;
	arc=none smtp.remote-ip=209.85.210.48
Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5420D606A31E
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 15:28:27 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 5420D606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=edkTqdxR
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-8439fe796ebso1550468a34.3
        for <patches@lists.linux.dev>; Thu, 29 Oct 2026 08:28:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1793287706; x=1793892506; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=yZTE4OyXfMuvSFj9u4UbsZSTrlYFDczLFmxLInU5s4g=;
        b=edkTqdxRNeESSsKjuIg2h/9t3hfD/ABUgRob3wWuiC6wVlJ/BP4JoHgB2A4nPj6eoZ
         sKBlHBClQesYR9NMRSyHpO3mGV+k5Nq0jGgK0FziUTArLqgBduvyQWt6hXn5zDGl76Ch
         R7nIlg7w3hV5qRj9CXq3TC209G68Z1wNQE/EY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793287706; x=1793892506;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=yZTE4OyXfMuvSFj9u4UbsZSTrlYFDczLFmxLInU5s4g=;
        b=HGlD5PSPGk1Ox3Tto2+x9K6yWRs7Yz/Hqea74SGReUGv0fQLyMY7UhE4OX2+78xk1f
         rrHTXCfRZuU1QCn9MsX8vvHNDDxKCdle3tW1xQ7O0NNd+VgnN5ofniRv9rf0CUQzdzBv
         ATLejhm2hAi0LZZAtfeCihuNZUwrVGzTzO2K9zf2mXckfo4Mpr/yxeXVbWUKm0mFKBH4
         MFcc/XiaVuWvBnEsHLCltyHPii8gH8dn8X7SnjrkFa0BoZPU7HVmzJKj9EbtsqZHz1Gx
         9DNW90+yKGjZQtyFT51Gw5JY/rOeHFv17LZf8QEZLBy/SCLUHtTk+Q7VfjF0nb5EPSUP
         ShYA==
X-Gm-Message-State: AFq9FYLpBnbBBTggFgAUhTm0ToKlx99iEkxeBcpJt/YdrWZykZGoB7bb
	H2NIQZYFFF0SPOUUXK4h5m9zZezeZAuDGWEzt8vqO6iHdpMwy/HUkr+llxZ7IzsjM1A=
X-Gm-Gg: AYBFou3kj4o/bW25UztaLvY98XdXjYeKOHfaS/eePaZP/0SgkiAXAc8T5+gqK1nAy9i
	53WpLWPt1a9yQDBS1QJ2fO+DWZwuzRTMr2vxEvPES93hGtXqUiSF+6AGudvaF7afsTW1/WAeC9V
	kdEQdigMuqXVyoKo2HetwJE76d3ApFZuEY2cPctwmMLfPOw1dq1mIbwHNge++7Nn/v0DFdUahIG
	H2XRPvU+2sq9J9+5+N7lpCzofyayZz6/WZTzRdY9y3uSVMGHuEHOu/3IpRnP36yMJ82lLXR7R/Q
	w2HFqpWSBeXLLbPlLTw93g6oJUIrh10JEEcZstWvm/Nh6tSEOXCbuFxnvge3XzhOinz7NIlyWkz
	DVZijeqPW5dSeg+Z+WNDJr5rdYukLFcorkiiZWoCBpulqxoqubyKOPH68kSjERuumj9sH+L1n6t
	o17mjt3hgkZSEJ8yKx2IO+Aga44TzlayddYEchZJbTsN/1WGS7QfPsFeMSP4ic26Zt3aqVsmaKW
	ued6HbA/aoioQi22s24R2f9Q5euEvscVrVYXXmu4Q07e5PruSAYI9/b3riZYvY8jpMIvBM/EnvS
	x44AbzTsFaGFw18tuwh2AePerClPSN4ba/hc41A=
X-Received: by 2002:a05:6830:4411:b0:829:2af1:a07d with SMTP id 46e09a7af769-85abf966b72mr5093393a34.5.1793287706261;
        Thu, 29 Oct 2026 08:28:26 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-85d33f9bd96sm72469a34.10.2026.10.29.08.28.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 29 Oct 2026 08:28:25 -0700 (PDT)
Message-ID: <8c2197e0-d83b-4089-94e9-7e6cf5a080b2@linuxfoundation.org>
Date: Thu, 29 Oct 2026 09:28:21 -0600
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/168] 6.6.161-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com,
 Shuah Khan <skhan@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/28/26 10:58, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.161 release.
> There are 168 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Fri, 30 Oct 2026 16:59:22 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.161-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-6.6.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
> 

Compiled and booted on my test system. No dmesg regressions.

Tested-by: Shuah Khan <skhan@linuxfoundation.org>

thanks,
-- Shuah
