Received: from mail-pl1-f181.google.com (mail-pl1-f181.google.com [209.85.214.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAC5C44236B
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 21:19:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.181
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787001575; cv=none; b=ioavxYB1SO5qOLP7KIH2t26g9sNCl0wGBGzmz3ZKZrvBHEu2uT+O4LmhYSmuNM1qW1g6kQmWw1bkTFBq0TcR/BZkSBGgxt06kKqITyifhxh380vv+e5qM4fC1hszeTkAxPRGV8GKMXv9FweMnBwUVyj1Odej+BIZ/AzajBYx0sc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787001575; c=relaxed/simple;
	bh=LfKFQ60MGbt3oQUU4UeDzk9gNNM573Bv+YOc2QstpIQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OVA3IzktGG2DsJFPG77SgfhAB1BtwQIVe4wRqEhSEWVEv9f1ErpFJ2zQ+q4si76RReviEScP9ySjQMRkuZOIj8Sbff9ujeO9x0aprZjuU3P1w6gqS1gTXNq7Z3LXAT6i64EIuuwhXWoQJGbHw8uWwuWoxFrevaEMh7o+kOV3dgY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=DGEyApmq; arc=none smtp.client-ip=209.85.214.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="DGEyApmq"
Received: by mail-pl1-f181.google.com with SMTP id d9443c01a7336-2ce87c7e3bbso50140225ad.1
        for <patches@lists.linux.dev>; Mon, 17 Aug 2026 14:19:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787001573; x=1787606373; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ys/YTvaoT9w4FLM9XG0rthYcw3gybAoEJJ0PsMkecBs=;
        b=DGEyApmqSBoXzfZxn4O2cigpejicwrYwwTSvExTizubQncPRgKIs2Ulnm8l6t/ShvQ
         Oey/cVngwlk0y5uhBSpfnQlfAXocCkwDuHAURy90mBbmd4uGMercCm6fO4S2tSZqGJd9
         FmZ5wnCqv6awBuHWGdSK/d2/vpzKT5Dkce+eh5DQ7lpWpz9vbl8KT3QgJQgUPX0fRkft
         sRBrSVEOsWj4NrTwoy4bkthRr7iDU3yecKV86KySp+nr6rVYsSICN73vpEjTy0hxKst2
         vErvxMj1jxi+yKQxsCT/cF3So3OyQu4g9+YiVbiKCi3H58swYumvtNKIBMAVTS+Q0S3/
         XZGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787001573; x=1787606373;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Ys/YTvaoT9w4FLM9XG0rthYcw3gybAoEJJ0PsMkecBs=;
        b=hfWoH21crdVGAqFExzgEDdcppUbzm37j8phUMphSOPq55bEqrlG1WbuzWuCViZ0tob
         uvoEKFdj5iCkjuUhuvwmE8+3DDEmv/Dmuo0UhPFEncteZ0UcHshpvTT5x6AKUfEoqehA
         J9AzXwanaGaDOjlT63AxsMzHyKHCG+h4PwwKAIQSAX70Hue7+XuJFclDFR/dmi0qs2rI
         1N+l1/TNWDcLdrzPqALcuWAf6HtlcqVJKvsTPV5guaTl8IswPSy6UHK99JId8b7TVhPV
         xzxOkuN8CIohljpJbZucQ3TN0qnSwDRaf7h0Eks8yAt7ZmKsvxkRQKDlpxRfB8bY/i4B
         FWfA==
X-Gm-Message-State: AOJu0YzIEKIXOUPIO025NK0Vp9EGz2Uij0+dczT/AvGAov/VZ64uNluF
	3GMmU6D/wAuRG0HIUHmwSoQ/MnS81L1bc4OpFflOb7KRYSm8VfDZ/EkI
X-Gm-Gg: AR+sD11CSUy+zWcr3aQXsSskQBFOG8N8yIKqoMCuH7vZ02+n5jhwG53FIf+u8mSgSTN
	mxBiwOzV2PhwdfUBF/S4yrZs9kvcMPXmKqDZMs0xgLt19i7sdy7Kcw363xamwmNPbGD1CjwHF27
	TqJ4XIeqkvOQDhlWii+Ia0UzUWDBCsEfrgxkut0M4UK84tSAHWS4lSQ34ASymE6onE9mpeXZiSx
	CKM5Dcq5iNIByfu3sHmLQoCqf+rmG0KqbaMKSd6tefoaKdZd6dNmag0CFNwfLgJxgg4FCA0gTa9
	rDP7YXXWBj0QceyGvfnirjc0xEyeFlLFFowLcxAq5W51+Pm8keVuPczRH85C8VcAOUjSXG7KePm
	KwJAIyl8TXHla+xoVrYr8PAq3QDUgh13T7ddu/BAy6bGiqhuisCDxWr45qPy2Hj78wI7bZ3GqUJ
	LZZaZbRKdkcc+nFC2Jh2j8YazXc38BGrKp2g3zn//R3FzHW5X7jjKAZ/cBXx4Hc3h5cW5I2iR4T
	xIJ/32CEMdJJDg=
X-Received: by 2002:a17:902:f68e:b0:2cf:4c0f:5129 with SMTP id d9443c01a7336-2d5c54102c4mr26838845ad.17.1787001572992;
        Mon, 17 Aug 2026 14:19:32 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-32678dceb20sm8182102eec.3.2026.08.17.14.19.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 14:19:32 -0700 (PDT)
Message-ID: <fc1827c1-fe81-4336-94d3-d49a989de2fd@gmail.com>
Date: Mon, 17 Aug 2026 14:19:31 -0700
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 6.6 000/156] 6.6.152-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 sudipm.mukherjee@gmail.com, rwarsow@gmx.de, conor@kernel.org,
 hargar@microsoft.com, broonie@kernel.org, achill@achill.org,
 sr@sladewatkins.com
References: <20260817132534.666299318@linuxfoundation.org>
Content-Language: en-US, fr-FR
From: Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/26 06:32, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 6.6.152 release.
> There are 156 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 19 Aug 2026 13:23:44 +0000.
> Anything received after that time might be too late.
> 
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v6.x/stable-review/patch-6.6.152-rc1.gz
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
