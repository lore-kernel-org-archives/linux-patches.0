Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95FE3B8D79
	for <patches@lists.linux.dev>; Tue, 14 Apr 2026 09:06:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776157591; cv=none; b=CN0CH7adnGJbGxnHJjHPZm1M2i2seVBfaDRwVDF2bAcyLpQ37KWBmA1hOkE4HxFUlGFlCtRv+t78Nk+z+VtJ/Xgn+LaIrMbJoa6Z5KTDgfJToHd9Lm4+oYeWd5Lys9BngyaeDggsBEEv+Q8bAyeyWSxR72I/HS06hmeOii1NLcY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776157591; c=relaxed/simple;
	bh=Q5J0zlhfhkrzNkUstl27167is2h5vfjGuXbjcpI33rw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=M5TJPoA6zm5E4KAB+KgiI8XsoA7yvhfHNO3CSOZdLVLVO8clAXbz5MKR03MYSAB+qrYxwnWyIlL7N+YG55PUu13/ZiiX+B99pgOM6tK9p5IEC5Y+Ma6m3tVaS4nnHDBXp8mcykrw4wIxNTTdNwlJZFh2+RcpHgr5Kgy0stHa35Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=L5jKvbK+; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="L5jKvbK+"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48334ee0aeaso51101005e9.1
        for <patches@lists.linux.dev>; Tue, 14 Apr 2026 02:06:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1776157588; x=1776762388; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=0eplFA0Em8ZfHMeUXX0Tyv2xByYPMHNk2Benk7DSSSo=;
        b=L5jKvbK+uO/GmDJ4GdfIm1nz+ylvpqg/gbNq5BxIqdqoTgPkk7JPTFPhNvhJ0tHCsU
         8qD/+Um0Y+Dr3znk1MupvUNVu15k7BiJCqQweFyXTvK5Ha+vduehHnMfIADDhoNvnfCq
         6Zya9lIjJtLuLuORFDr+LOyLQTSkpWSi6r6/+1Dubabt+HGdvnlk9RDj+68u7l9lAuO+
         yp+RrPf59PCyZ+yOTTRXyS2zc/QbDy59wnFrDC/qm0BnxuVkFB3uS3UzxcY6X1gjNQZX
         vDGQBqHQ7EoBqJQb30pq7B729k+W90RSVbhSKEP+F5BSVJkUPizgHlJOV39dbzAAXnZ7
         MrGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776157588; x=1776762388;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=0eplFA0Em8ZfHMeUXX0Tyv2xByYPMHNk2Benk7DSSSo=;
        b=q+vT7qLHf3sSm8/ID69jDhwvuLnqWEUi5WY9jlJn3I39HkQL0HBCULIhxTvPR3a3M6
         94yG5s3qFmIyisqH20a4Cu66qbP35vkWYXcuhgAWvMqteK39rdeD8xfAZFBWjaPISkTS
         J5TgU0FiHo6O4vQvS4O9Tj+J8stopIf7byMO9XqGyP8m61pl3Cgviu51zcbqh9GdPi9R
         +PK539ruU7+4Az2S057XOipOTIqapvyoef6nxCW2RxkRQ4SetRLUIPUvRi+YHVy65+M7
         d/oHpczyD4gQ8r136mPF5moJWAF8p6nUGborcDpgWMyFXEmBB81f5v/Hf21CPVUh1/CV
         KtVg==
X-Gm-Message-State: AOJu0YwrTxoCFyMea5A56Q+MQ2yfvlTtYawRbDm0twxqO5CWHhJS/Rzf
	+IlG8cMh5Ekg9VSK/S1Qlwn89AOZ9/xoDeogNareG+vq6dA5xPUao84=
X-Gm-Gg: AeBDietIAEc+LiWgwjdnQ/6s3X/7vsFR6+YOWEOCcTWf4pfZezeftczV80mF7jkpuAr
	8wV3tKVBL+6HGCY4JmyAgdJjq92vhuq5FNO3+nsHCQb2GdtZ+U6xBfAM3UzNGKtd1US84mEzE1+
	uro1hnHPiAyyrDx3ciAOzMRb6jDnXBzodfFBZqdqN9hyd/4ri68cZxm/ly/wM24S+POjPOxj3CR
	EWoFD0SLw2HamQLzrCGde62J1LPlsf81uP03UL42Ab5cDrKL+xYeCHTvAofjMAFdb9AWbuVtUT2
	gm8zn0+sMxgO8QV8HlixrSlxHXncADpw38nmySzQ/3inbj+xy/u5vjkOMsVWmoSNk27KBMdmiPK
	NAu7FIi7qT9rk84qXd0TXfsH5MYXxajigyUktq6EvJNqAjsQXWcsreSS9N37rshJOqa90VgaFaS
	AfMhr2Vrja+Bf9CUz90vLtB6ubg+h/x4VdlN57crHslYoOFNF6lnRID1Oz2+0OdKRiMWCjwpSjp
	dqdKywO/EdCkA==
X-Received: by 2002:a05:600c:a11c:b0:488:af14:f1da with SMTP id 5b1f17b1804b1-488d67f9a25mr164346855e9.7.1776157587980;
        Tue, 14 Apr 2026 02:06:27 -0700 (PDT)
Received: from [192.168.1.3] (p5b05757c.dip0.t-ipconnect.de. [91.5.117.124])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-488d5d70891sm123063205e9.2.2026.04.14.02.06.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 14 Apr 2026 02:06:27 -0700 (PDT)
Message-ID: <fc073cc5-fde6-4601-b36e-4778202016ee@googlemail.com>
Date: Tue, 14 Apr 2026 11:06:26 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/55] 6.1.169-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260413155724.820472494@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260413155724.820472494@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.04.2026 um 18:00 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.169 release.
> There are 55 patches in this series, all will be posted as a response
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
