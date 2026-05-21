Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2BD352035
	for <patches@lists.linux.dev>; Thu, 21 May 2026 21:57:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779400625; cv=none; b=r/l+3rxM9hg3ZsmkPhJMM2kwodcHJqUBiqfffB4g6inCLwSsRgXY3Ms/33vZFMueOV+fUaGkm0PXGmPD5JvT/YpILpRr3cDVggdJ+lTqxl3Pxm9629/lYcKy78CswmtgG66SJZr8b6GmnHvPHKAQtJO8dQzA+Go5ga+gHU6gBj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779400625; c=relaxed/simple;
	bh=r2BUZgk2Np+Scsj4X8RP/J60+Fp7770Dl1HSTOiDzHs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nfdEO5RijYeWnHIserx2QDiuhtzNlsi7/3OFXhTBp7gBjck/uw7RrcKh8kETJ/Pu17KYXh1CGlGFTFALAqZ3YwDpxfZvBvp74IYdZbnWtCL6EvKswocbIRwPUmHLrx5qpcT+WKmf/DEO8KU2goxNismCrlmKfIetBGRPSaWV74w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=k2Z51uVo; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="k2Z51uVo"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4903cbfad68so7221595e9.0
        for <patches@lists.linux.dev>; Thu, 21 May 2026 14:57:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1779400622; x=1780005422; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=xLSU/8udiAk6jgR2mMglLiCQL8WPD5iNK8szBRkUXEo=;
        b=k2Z51uVof6LSxBaX8kQRElcj5aD8kq5ZAJ8DFwnyVsLwnVVeZl6tu7+jGrX6uEfSGC
         0Fb3cO343TqHmIjhH+N9nHr1unldbAnS5XAMwUHC5aF3cIrXGWfEufOjMKaGQ3ENxjiA
         gE6iR7+7kQ2IgL2HfsO0hSnPKU8k6xWqsEHI9xCmQoPJaZh4t549qqGL0kR2vHNH5D9T
         L204TpBs3Nndk3+C/1kIxvVDjU15yE0REjzqZD0ZBbWnfYFLUOiaeJuoLdv7EEvMrOfQ
         rcnGOFUhe/FSayx3EkL64wpIKYxy+5rRhekQDlcCkaMXYwCyfxrn6qkuQ9+E9ieUPeUL
         hRNg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779400622; x=1780005422;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=xLSU/8udiAk6jgR2mMglLiCQL8WPD5iNK8szBRkUXEo=;
        b=idVg3BGRejD5x4TRdbiDwIPMXoBCy9sqGEGJ/ZJK6aABmgwY5C69ArEO6otBIwX6/S
         X4Kb/dZsfxgrLSj28QTBMJVsqmAMTv+0V2ErmGhiEFbM9O6AIQ8tx9JIf4ha5Nd0LceX
         Oe79R+MqQ0LOc8yzFgbpDykI9oZpTSy1KrUD3s1IsASjUMQFpGsbHv0fu78PiclQs/G8
         P+bNburvFaErF7G/mVsdJKJkw6C1XURAHuOI+tiff7kDgGKHEqcgGyHjGaEwtqBriE8J
         2je3afYkb3EjM1oO/Zq/3rv63I5S7qnhZ2eBBMv/XtuAnW8amxOmq66hhBoJFolW7E/j
         HQRw==
X-Gm-Message-State: AOJu0YxYmJfNnX/T49JQ3OZyubJi1PXvn+j4VPR4AAcZiNN26tZYl9YG
	qwzLAWR3CkWbCkJbR5zHtDjHYDHqrJPm0n0rlt4hfxPdE9+O0S0DLqc=
X-Gm-Gg: Acq92OEE35Cbm61MyuTdQejrWPl3EUkI/vB3c74CP0NkDMVWvEP2J0DM5Q+0to9Izae
	6htRXXCC6VQg8ODWq6kg+XFcCfQ4nX1b+lBp88iYU5+aE6MmpOi3hV2sPcdsi94SOzZZoPNZ5c2
	TD6QkzAjAd/pNy9LLIjJXxbQIiT9rR8hjSrnayU9J3JoGMu9HSqofs2zC8wkxjtYYtwBa1EjLle
	6Esp8bOvbY+lcgEC1V1DmivyOmj/nJWDmtC5OQUV9wV6/Mx3BTtKRQQJm3wSDLSWf8J9saEin2g
	FUYHKyeWxSB8Kndjf3tIvBUUXbfZ7Bh6uqydKm+C7aOfsd/uz+42XA1f5gruFlWmzfayby4mX0N
	ofgmAZ7v8VW63v5oX+pFExi6FIGiqr8mW2qyfGGC8XbMAkhk/2GkVf2ya01Vgewkbfx0swLaGGX
	FZ8uRRT+rYTiRB5TjnzIT/ayMH3yA7VKLyByV+M1QjcPdc3EfWeEZHqsrn7goJmjN6yzYyce0QH
	AA=
X-Received: by 2002:a05:600d:6446:20b0:48f:c649:e6fa with SMTP id 5b1f17b1804b1-49035f6841amr49593295e9.15.1779400622409;
        Thu, 21 May 2026 14:57:02 -0700 (PDT)
Received: from [192.168.1.3] (p5b05786a.dip0.t-ipconnect.de. [91.5.120.106])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eb4ac3174sm123306f8f.17.2026.05.21.14.57.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2026 14:57:01 -0700 (PDT)
Message-ID: <e6e128a4-5dd9-43cc-ab87-b7132ef0a0a8@googlemail.com>
Date: Thu, 21 May 2026 23:57:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/508] 6.6.141-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260520162058.573354582@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260520162058.573354582@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.05.2026 um 18:17 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.141 release.
> There are 508 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.


Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


Beste Grüße,
Peter Schneider

-- 
Climb the mountain not to plant your flag, but to embrace the challenge,
enjoy the air and behold the view. Climb it so you can see the world,
not so the world can see you.                    -- David McCullough Jr.

OpenPGP:  0xA3828BD796CCE11A8CADE8866E3A92C92C3FF244
Download: https://www.peters-netzplatz.de/download/pschneider1968_pub.asc
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@googlemail.com
https://keys.mailvelope.com/pks/lookup?op=get&search=pschneider1968@gmail.com
