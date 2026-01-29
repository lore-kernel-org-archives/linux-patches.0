Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 454D23783B2
	for <patches@lists.linux.dev>; Thu, 29 Jan 2026 07:06:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769670378; cv=none; b=PvOvgT0KZ9pqxOTDrnmUgDE09bg7rqPgVhLgCDPLg1uPEFkUHt+nYnZb8+NdYuGRAS/HhbMu53MmDG/gBNJSl4r3Bii7m4PQm1B7wW2Trp1SThx8836M1wNMSyL8jOxbWZyJaGxxGhC5WYWnjBUnsErQ9zpTGSmnzWF6uzhRsCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769670378; c=relaxed/simple;
	bh=NiH2eoG7zgP8DoTvCiby5vxkPXXj50mzFtxKUu0S+9Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ChKcXCl/+9GRSPUBsAnaLDqT+T6W+Yu2nQSFrRmDDRSQxwx9wUtl5IsgIEH+/Og82uCw30idFkwvoNo1bzFdEF33GL3lMlhVl/+uj4g4c9yzBpbfOd6mvePrzXGq99Qb6WN9vopcKDxQZICQVWLYr2A/0qYB0PaPEb2x+UiYtSQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=D9cxHL5m; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="D9cxHL5m"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-47edd6111b4so6057135e9.1
        for <patches@lists.linux.dev>; Wed, 28 Jan 2026 23:06:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1769670376; x=1770275176; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=D1fDF63EvGuoA50Iy5jKQKMvTWmanzhkAdtgMnNPQ6c=;
        b=D9cxHL5m4YkT8DfQprzwdJ4HIQY1KxEHtCDQwoF71Gq3B1oB3cXa5QMJ2tJx7hKZ/5
         betQSSiowH7mH3nrarcZyJ6gThQekx5+B4Yw7phhQPYqiLN8juGpiOdWbJm6cfdVMZFK
         K5L7Ltq/WdyyiUjAA8q+7eMDstPke3h/zUJFa4j2k3NG2vSxUfhwzrx8n+sUUsuN7L2m
         LlIB81cFU473g9bUAuyvBE1XJfcT0SUPXvoqw2M27MmdUD7HTAQfSVOTiwYmNafewg2s
         aG7wlscWa78QBSkL8KRmeXTzIQl+mEfgm0W0UJZVj2/1/lFrZUuqLK9gP0muAONUN/Nf
         gdXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769670376; x=1770275176;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D1fDF63EvGuoA50Iy5jKQKMvTWmanzhkAdtgMnNPQ6c=;
        b=li4zkv/XpkBzwJTlKVAkWznFmkjxOW4P55I858ukYmer0bWzLeOd17rQ9Mdi07XOp7
         Cg1hGhzlJnonXrbi7GMec9sRDhHMMPC3hxDd/4HosZM5D/hK6l0YpB7RbaJi1JcHh+MQ
         5bM0KnWu+Qy1MDOLsF/4FcFCS32d3zzwk1QN8PkJ937URg56sEs5JllUAaTIs1FdXbpE
         /K6L3wmYqGhRZkDNgYnyG1pz3exJtSBhfWbolzg0Gis4CVX4SbDEk/2jYyQ8V1pw6DMx
         3g4bvfB2anT/K2NZvEj03YZfS0GUUa15tNLvi8zG1PIbvoHWiNs7YrLnC21kiut4q2pz
         Os8g==
X-Gm-Message-State: AOJu0YynsbLvIpsC5biDlL0X4brn+7xMxBAI9NHs7Z6DDCVkcLWPDW+J
	7scYdnyyLL/Hp0gZfPWcQNQzQl37h/SD8vurAXlqPNps4teGVQWz4cQ=
X-Gm-Gg: AZuq6aK1Imhg2cUF06whNTtqjWY6fqLOI18ALxQZvOmridS/ixxXpj6gyTh51tLdtAk
	xwCRq5NvBi+6u+RKt2Sl/NDmaPRljINEkGPMkrK2ndY7hjxf62nBa1PrhnSz0818GcumpUAFFBl
	oDScRG/2R1YyvRiYR2G7ARLNCpgK0fupKoQGRwOYR2nlXmOMPH+UckOivHBUdDyPEWeMPMqOJ5T
	e0S+EofRdQlRnUc3h905GmPSR9azVWS1pdXDCthCOi7Halvzp+mTHbNddX9+Jy+N4IZa+hxb/a3
	CAHALL/TYTPM5/zYovYVE2Y6nDzfN20ElFy8UUfCSwiAVu84+JgvJUSIhUJstIiVqkM6LZP9vW/
	HRoL+OC2K45SJsRZ6IO/Q73VW3Qq8+3+SK9w+RpcbUZnYdOPUvgock+l2g3P00sR0QkS77MKRSJ
	2Jt/nnen3m/1xX9xeYLiy8xABwGORi5tz04l70cGWtLmtR90UXU+1jZlmtr7W3rw==
X-Received: by 2002:a05:600c:1554:b0:480:1d0b:2d32 with SMTP id 5b1f17b1804b1-48069c1c2f4mr97740075e9.12.1769670375441;
        Wed, 28 Jan 2026 23:06:15 -0800 (PST)
Received: from [192.168.1.3] (p5b057921.dip0.t-ipconnect.de. [91.5.121.33])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-435e13235f5sm11662842f8f.29.2026.01.28.23.06.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Jan 2026 23:06:15 -0800 (PST)
Message-ID: <7678fadc-e8d7-477d-a422-6e4aff345026@googlemail.com>
Date: Thu, 29 Jan 2026 08:06:14 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/227] 6.18.8-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260128145344.331957407@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.01.2026 um 16:20 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.8 release.
> There are 227 patches in this series, all will be posted as a response
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
