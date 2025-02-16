Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BBA715383D
	for <patches@lists.linux.dev>; Sun, 16 Feb 2025 07:19:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739690382; cv=none; b=WGi7f5ClquFlQvscyFJlEL0O7nwCy40TPt2Uyq11GcqxUHNdX+BVnLP32+5PpgT54dCZ6PCJM+sSMbP8b15CECblrdEvmcLCPAm2L2v6iNGrL9VKG4PeKlSLxrUsgvAhd4slZNiDoyXiaKIIcJGrRPFwi1WwaoyXjEx6m622kuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739690382; c=relaxed/simple;
	bh=h8GLSyu0qMrP7keJKlTVF3CUjBxx96cUnU04Y2WSPPc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qE+Tk/2thD2aEsre6GgnDSUoraabB3T55ot8v48tEG4rpDJZPEpSAstiBWl8Gn7fmvh0hjg70uVKo9u4RGHes2YziYid6sJjJkeUVKy/itQqrVKJIms11aS31VcBNLLUg7bqFbVPyiD0FPFX69Njc9pcuDYHqjq39irNThOGPtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=QPY6U0lG; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="QPY6U0lG"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-38dd14c99c3so1599065f8f.3
        for <patches@lists.linux.dev>; Sat, 15 Feb 2025 23:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1739690379; x=1740295179; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oJ48bFI5nmQNNKRHP45qr5Uw0E1Ug7S7l+n7QSTbTcs=;
        b=QPY6U0lG+lMwJfci2QujVvDfjyug0P+BaVkOa94QUMUtQGhiuXR1ypZ5uQW5HUPh7L
         BPtyuf171GKgw04lsep5U6M647tnpo0DAZHtLnYemBQSCkXEV2L/y9Vi4UxwROALUFwZ
         gRm5qjs+A5At59ULSSrlrh/IZ4FHKu84cNTe+c+aL2s8ULkU4gbXGd1JBCUvq5mby+Qt
         ORTIC9kIfKdD6XO1qCriwYhxBN8P8ILkLWnk6ZNgyUqrlSRRcEX8undDC0a6hduN5VmA
         8VQc/lZl0VeWXa6bY4qqjpXRoiNIUYLbDJ8xJfce7M5bQysceAzWUHiYiA+RhH4pw0kG
         /xkQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1739690379; x=1740295179;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oJ48bFI5nmQNNKRHP45qr5Uw0E1Ug7S7l+n7QSTbTcs=;
        b=tpe9YXLEWK43gHAlYVfXVapc1gqTN+BWdwaEVZB70viY7coEr6AG6KGPCNMbmXGUcR
         WIGp8OeXYIc+fRSFoIqc3ql72G+rhensDKgGBZMZ4FqVUpEgJf0gzB8LpwnnoXd9JMjg
         EjEtFtkifEB4tM1LWPkYVkc6zLmsGoZSWbPttJLZBwZdk0Wuh6orO0yaNWGsfRT4of0E
         psov04+AmzUgsMgr8GOoL6/fmRXY8kXmqhXzaGIFAPt3ZCgLRL61qOwV9/nUyzQS2k6D
         c08CdgnXLHkmvFS/sUzgYfjOuuvC+XIBb1DAHcnWaisp3PBgKv2ltmT5munQIkEVCa1F
         bAZQ==
X-Gm-Message-State: AOJu0YyiYRe9NTI8Fwd4sc5Zp4N2Bfcf2l37cgzmO9k6wLvfdiqzVKLx
	uwXjCEHBzxK28cLkHkZDmc39+7gj2Bz7YcN3m4gp94D7DpoMy9Q=
X-Gm-Gg: ASbGncvmdgNG1hCkjCwqsp87+nBjJjSeMb8O9Cr/heURk5tze4dzgYkMCVJVv0Do19D
	qob/26Cxbg146aWifjtpTlnrzw0i9JMckB24J6S2IhzJELIthXtB0nYtRbgvbb0GF61cEuLmMpN
	eXtD0QjiX2YRIcS5zXtakkiHQdfkin8jIUc6YyzfC0YTzz2ofhdDEYP6mmDpHRpkyjHrEcIX+70
	1TwcMP1Ggryex0ISpGeIMYX+5yzpC582zaCaiS7/lgeHeiWmGyDRQctEnzPzzxkONg+kBBLOFWl
	eTZbaNPFOlx6kOmCuIj0btraNETi1z+wJs7kqy3jJ6/ICi9wNhbcrTW3imS3EYJXIUy5
X-Google-Smtp-Source: AGHT+IGm4hiqnMQWTqMPbhPKO2hNADidPmmiKUb3hBslmIgtWXuoigTeYkXT9sNM/irggrjxCpN+6Q==
X-Received: by 2002:adf:e74e:0:b0:38d:d767:364 with SMTP id ffacd0b85a97d-38f33f1c8bamr4413943f8f.13.1739690379125;
        Sat, 15 Feb 2025 23:19:39 -0800 (PST)
Received: from [192.168.1.3] (p5b2b47ca.dip0.t-ipconnect.de. [91.43.71.202])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-38f25a0fe5esm9086555f8f.99.2025.02.15.23.19.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2025 23:19:38 -0800 (PST)
Message-ID: <545f056e-fe4b-463c-afda-653cf558ad12@googlemail.com>
Date: Sun, 16 Feb 2025 08:19:36 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.13 000/442] 6.13.3-rc3 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250215075925.888236411@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250215075925.888236411@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 15.02.2025 um 09:00 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.13.3 release.
> There are 442 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
