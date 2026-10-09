Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E7A36CDF2
	for <patches@lists.linux.dev>; Fri,  9 Oct 2026 21:40:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791582026; cv=none; b=R/UmdN+qHZBI4Ue+scXQeXY6qMDd4zXU8GnGdUo3matgprpY18HKRnlvz0cFja0lXWC/OqOhq21Ddp3LgoacGsjZKaLYQGc3olgw9mHuHDte0nqXNUlTdTMNUotLuJ6fTMuGSG9bBO4XVg0Tdk8E3BVwsk9yH7+sqh6CGULiB9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791582026; c=relaxed/simple;
	bh=GEDqi6cQqEPhJR0cVLsj6fg4aKUXmns5XxXs2jZVVBI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=euaLkM77f6NjUv6oNglDGClGDQTWYQP9KVZw2hGij2S0/7JGM6fhkicfJi3tkHDsVrdig6nEzuJLiJVC25rLIVVlcPxhmqMDLY413MDi4v4AgvyFEDI+xTkh7RGIqFAQ3lrzqxWYINcrCNZ/Z6JoBzA//2788QOVyYHfnlaa/8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ocDc1BJY; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ocDc1BJY"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-4a1635f7c89so2412715e9.2
        for <patches@lists.linux.dev>; Fri, 09 Oct 2026 14:40:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1791582024; x=1792186824; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XYNRxEaVrIcFOPoWfTYwk6GJOOGVb1oRxSuSiudg7mM=;
        b=ocDc1BJYPeOTiv6MSKjWq6S7hjRDmQ0u6CX7+JOsvZhvLudcC6AHGaP8GCCJBdRHUu
         JeJijW/69B4hcRgSOcvIGKs4Z6ZGMC+iQFwOFUU9LfHb5uGPrHxOWaLpwlUWUlJ7YcTd
         EQ0SBth/l46kiWvqt6vPYWQsipPVqpYiQe1drxnRl237i8EvqqY1alk4d+XjoskF5CUj
         rz/sg20LmC3lbTlD/dIh7aF4XpsAqiW5IdCEkYxjEICYzODaW8NBI6lJSmDcbLEl1iy8
         F1c4lnxcHeEIqpHrrmcz7VEmAToOpGvS0JeKtxAnowIrxfyI+F8fpEZ57jGSSUi9EQU2
         40WA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791582024; x=1792186824;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XYNRxEaVrIcFOPoWfTYwk6GJOOGVb1oRxSuSiudg7mM=;
        b=yqbZppZDMAvpUxu6fay2pbn6bljgpgTA/kt3wjoC+8hxIa9HM9HScnZJ3YttBpcjbj
         3Uf8UC3xU0h2uEYyBftHhTzyEg2qk36tFdf8+Ld1gaXYHb+kh0xWlnpCZHaLayuBNYQn
         1nOO9Xmr954NDyQxBjiVQRhLuiB0MV1MOb/Sgqgj3vuQUYt3JeQ8NdWi7lPIRQvtvQjs
         2eeJ6zjdjfM0faEFUaLr+s+oB96vUHyB68NOzjMsFnQHXZNrAdREukODtwS0mypb9Vj3
         TjLyRWo79WXa9DFBlpSdCBbFJ4iM5JZ3/Ypk3Up6binBHTmChNKBu0Jqdp+hTOggaQTW
         VW2w==
X-Gm-Message-State: AFq9FYLVAMqvZ9qEX7Bus366O7yUAjwg6egMs9kLen4zJi05NONTrQu6
	SNshVpkIDBjhi3BVXj6WWw9YfR7Sx4lTFq61Z+NVRA7aMePHIFztrmo=
X-Gm-Gg: AYBFou0EVqDPQRzAxOcKQ4HYruj3vxZL7scKdWo5KAXyZViSo71iYsvS+32PGzTLb/m
	JNsv1PcAfoaiJ7N1pPaGiEFpdK9R4sgCkkNHAAxKrNrU1GACUMwIxVGqhZ0Yb4UzT3qH5zFv8Rn
	NoyicPBTS4ZP1CfiOlmJAEfA36p035AM2IpgLZTjrxlDytcDDjqsUMpuZ6UUbAoGZwhai7RlfSj
	94Sm7JEIBCtzjKD+ewncE81PoeZ55YTuHhENGbYnkeSBuPrqUesYS9+pBe/5HOAWmJTRHRuD2Oq
	ElTOikpU9fGfFHwcSstAPZRJdagFRxjRxOgguj14h8o+U5PWoUgq46AdqR3m/nMVnkQXUiV0iho
	hW7mlAEdeY6nPn6RlMDd6zJiMq6L+px6342uHmtVd5XOBMnwLsdbK81s+F29CN2H5FCJR5QOXEu
	TgZEuiUkif9Xdx0utGW/YnPwEh36fX74ezTy+YsTCOOxEtFe1YL3BkcHgkGTMoi86v7XQlSpPg5
	irfrng4JbqDPYS73hNis8q2C00hHaFjkOBBdGWT14EW+nUsQw==
X-Received: by 2002:a05:600c:8209:b0:4a0:2375:dc1a with SMTP id 5b1f17b1804b1-4a18e4cb771mr62672595e9.21.1791582023679;
        Fri, 09 Oct 2026 14:40:23 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b4680.dip0.t-ipconnect.de. [91.43.70.128])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18f3b43efsm91051495e9.1.2026.10.09.14.40.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 14:40:23 -0700 (PDT)
Message-ID: <0f8c15f3-702f-407f-8c1d-e64627294ba8@googlemail.com>
Date: Fri, 9 Oct 2026 23:40:22 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/403] 6.18.56-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261009140952.119038291@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 09.10.2026 um 16:06 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.56 release.
> There are 403 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
