Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 016871DF964
	for <patches@lists.linux.dev>; Tue,  8 Oct 2024 17:05:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728407116; cv=none; b=mdi9Z3NVP4dI/h4Tsb87CV/dsSzlk/Io5IYsJbGozltujy/SxU1p5TCmn6vRseS72aMURbds5K4mdHvzmca+y8uR3oj8nRdob0dhKa696yMKylYiK6MF3AgnrRYC/hKNiM55LcpOYWoXkhe94XzDp3Lqi1H5ESIw9hv842NoSRg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728407116; c=relaxed/simple;
	bh=6yf8RgkWeLrXVP+1l3yxp5qwHoOq5jHnuctZRyfcLrc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WPea8tmGLjttiWq1mu2q3XzIukr+hsB2OnZEPuc4D4JmVwnY6FH7fjE/0ut/LmWO1InOOFT4N6z4SOxJomrAF1duvA8k5E7mk8id4TCi6O5TGwIG0gU8LhnOTmcT4gGNTzQK4jvYO1K9wZNuImuN9GG7HaWs86uqKLIiq2PuMy8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=FheaXzme; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="FheaXzme"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-37d2e81e110so474761f8f.3
        for <patches@lists.linux.dev>; Tue, 08 Oct 2024 10:05:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1728407113; x=1729011913; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=f3YRV8BLw6t5/e/+7ajFhrM1Fg7IM/Mpe/N72BSndBc=;
        b=FheaXzmeU+LgTL7YmbQfTXU4bDzrSKOUUm2NpjHltYWNxCv9heS9SzibWtqNkIHtkw
         5o9FdTCk6jbQxKRnYABEgOc0myMMruEembMtLSOpjepb72AocqoMJKLTrY0gR9HonPjG
         RWzYWr37D9UhNRt+nRpz5UBdAvOKc0UWTYT78ERCnl21ZYd6RxuXsi7+KYxupdk4iGMl
         A2NgzqYCxYLcTePaH3Fa9wpaSVjgMe+MSBE2cegu+Mf8CiqTf1MgRdaVBVHDhSJl13kv
         DcDuVUi5RJaeUtyq9MhJpOLGNQcu9qA0EPcvotuCGyGFVVlTTof+iHm0Qbe/u3yOjsh3
         bSUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1728407113; x=1729011913;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=f3YRV8BLw6t5/e/+7ajFhrM1Fg7IM/Mpe/N72BSndBc=;
        b=qXFWItAAn3Q/sHGXmRpt2gOgPRHkaNEcr0gh/zMOuYuH/VKqPV+egyx6N4DIX4Scev
         L45pp1KRIseW7paJ8IStCRBLyVjD6XNCDvlcJGjcKImbqUWWZAdYF1z1uj5aq8VbFJh6
         2Djxdzo1f4+ZuQJUgJTINXCsD66+RPCqS1cKG8SNhHbTAQ2fRcyI5MdiWwTbcOhj6vwu
         ygkJwEkSJKD4xyXLIED8jx76sOruRoyXBwvjYZfLxiOikdY1/9nX5BuVGjgtiXiRcx+D
         gNkJMgVApxFNPzvsm1teoNV3HRwdz5muU6a8M5RTdtW14oSr1pr+hz5344kWadGVKyta
         LUsA==
X-Gm-Message-State: AOJu0YyGY/gwPqEiPfxA+UzMnscrh+i2E+U8lAzCSrxG54wv9kCE8rDQ
	Y9zlvh8Pvjp/aCwqNZaSTDW7sBmL7WoWcRrKGwOnbnE/uM0bHgs=
X-Google-Smtp-Source: AGHT+IHQfl0hND+4ioU/ew6zB6733O+fXHQ6AI/5lvB2hSbTyvQLjTIf02G16828G/wHCR8TOnBEsg==
X-Received: by 2002:a5d:648a:0:b0:375:1b02:1e3c with SMTP id ffacd0b85a97d-37d0e8de99dmr13576498f8f.45.1728407113096;
        Tue, 08 Oct 2024 10:05:13 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4723.dip0.t-ipconnect.de. [91.43.71.35])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-37d1690f25asm8479886f8f.11.2024.10.08.10.05.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2024 10:05:12 -0700 (PDT)
Message-ID: <158d864c-7378-4929-b244-76af607574c2@googlemail.com>
Date: Tue, 8 Oct 2024 19:05:11 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/386] 6.6.55-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, allen.lkml@gmail.com, broonie@kernel.org
References: <20241008115629.309157387@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 08.10.2024 um 14:04 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.55 release.
> There are 386 patches in this series, all will be posted as a response
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
