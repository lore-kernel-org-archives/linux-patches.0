Received: from mail-wm1-f51.google.com (mail-wm1-f51.google.com [209.85.128.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41C121553AB
	for <patches@lists.linux.dev>; Wed, 30 Apr 2025 00:37:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745973477; cv=none; b=dH/steWB7cZL4M9/SPmskZeEyyyrhWevbphpjCWKY3zU2+TrgMkUyUKKRYPUm4iveBiXOd0T0gY1LcSb+rLnxN/O4EZEqYqd5eAT3eKEFyFe8M+JWij8xbnI9PRcmgiATN3cqYlIBBRSbQHzbw4OWGLvHB9ygRWqKHo4QinVxSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745973477; c=relaxed/simple;
	bh=+aqnPA4r+iO0QbmkbcmL3npYlqLKb9+zjCliuHyxX10=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ZxM+ZTjjURbXHmFJcKPWkWJ8y3euuSI7RujGj23bVDNO3p/xfSEbT9o3We5hQ4yBINz13qSVskwJ7W33rBDdCgZQg5X47Q+5Np4belPXvA6lcOTTgZFNYVJOVZLPGjxcMywm+qZF9um5/AZ8S4Px3kxcP39V4RqW0faEwJQ0srk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=aYICf5+w; arc=none smtp.client-ip=209.85.128.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="aYICf5+w"
Received: by mail-wm1-f51.google.com with SMTP id 5b1f17b1804b1-43d0c18e84eso32594705e9.3
        for <patches@lists.linux.dev>; Tue, 29 Apr 2025 17:37:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1745973473; x=1746578273; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=36jpzvknKzrbqzrdJBObuGYioHZ4/CkD82SK+7pHs9I=;
        b=aYICf5+wVxGNV1wV39jGEJpjjt4bdi9eFTpQyhCzyUjIXxepofX+3Nfop4urrmQivk
         EHR0JUfBdqn7Jyg4MaSBGYOY7fuQqwo0aKtmrbKMuI24dz0pQn4YTv7x78wNn0JWvNaa
         +z1nAK3KAwm37SeO8O7SNeg8rCT1mGn+/pFRy8Q5Fdf6n3zOKcXZ+t7UAyj78GsKFjiE
         kCNqY7zDWqv5HmhXIWMUufLjWpseGHtwauk6XCtA9/BRGX6yl+TPMggn9uV2FflEPbse
         qe3xRLQxm+bPdzFegyRQT7xE3eptD+IH1cSWug9YOt1p16CWTD1n0wJCxLbIcySfogH3
         SvVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1745973473; x=1746578273;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=36jpzvknKzrbqzrdJBObuGYioHZ4/CkD82SK+7pHs9I=;
        b=w5RBA/Q/wK3EV8FZ1kKbMf0mMqF3Yu7K+8zk2BU8IAgw6yErTN7idEEWraqCs88mqF
         kQUVFXZg6IGFuAix6Sz4M1ihaGFqZbBzstZLQeMQIXy0EznPBPCCuQNS7QtPDT589v+r
         QMwXpLPMQSXk4nrBLitvcVt4GG5m3L9cUa0t9qduojPwEEY7YsdanrZH/Q1SZliMbqsI
         OcyG/hLFNu+RKTLJo0XgfxoBlD6uR+t3qP957b1b3aurjhmizHE0K22nqbe9Ezeu5Swd
         ij4bmZAXiv94Op44ZLRNCHhCBPX/jbYoZZsgW1QAbB/X0DewqOBlNYqEzAO1wnO6CAO/
         7gkw==
X-Gm-Message-State: AOJu0YxW34NnT4jB2lKV4K6MHDqniiNRX3fqWBT0HcGmUo3DoleSBc9X
	TaDxsld9PurTx+b12mJhMblFfPwppUvr05JtLZOx6sDfO8nlrO0=
X-Gm-Gg: ASbGncsf2UnpRfOFu/pRvNDU5vGppJUBlX4ugzPlTPZEBYSIQ+/s+PPYKyV0UySj32X
	Id8mEgC0HBuSxStF2BQbYX+Q/4m1ULm+kERmcJqIukyMitkkGjB9jMUyYomTECiQyBEY3VgbOIW
	R6Q4XVr6l1baR6bUKkBtWGdeOllM7vKChfa3r+brPZ+jdDUWtQ5YiVOQf35yZlZ47bcmuCGCy4n
	VKA6WqHk/d2q5L+DKpC6u4N6pSOuQ/oZmX023zHPUgv8NP8jdyLNIjumAYYUYHL/CaPIwFeo4Nf
	w4uPMh0ouByH/L+vvy3vKiQURYRLif7XRu3NOHbpA/yh7lcgwuSccjgwT4CeS8pyhio6H6D95yF
	kpkspniEOX2utmQWX
X-Google-Smtp-Source: AGHT+IEKN5ZYb0V0mxVQ8VeWxSdDrKf1KJS1OxwBEsuSfvGVnc0TndID6ZTMb2SApHZjLTcV88Wixw==
X-Received: by 2002:a05:600c:540e:b0:43d:160:cd97 with SMTP id 5b1f17b1804b1-441b1f5c0c5mr9040945e9.25.1745973473092;
        Tue, 29 Apr 2025 17:37:53 -0700 (PDT)
Received: from [192.168.1.3] (p5b057647.dip0.t-ipconnect.de. [91.5.118.71])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-441b2b20a65sm4942685e9.32.2025.04.29.17.37.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Apr 2025 17:37:52 -0700 (PDT)
Message-ID: <39b1a5e4-d8cf-482d-b603-d61f0ea3f51c@googlemail.com>
Date: Wed, 30 Apr 2025 02:37:51 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/167] 6.1.136-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250429161051.743239894@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 29.04.2025 um 18:41 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.136 release.
> There are 167 patches in this series, all will be posted as a response
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
