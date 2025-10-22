Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 512DC3431EC
	for <patches@lists.linux.dev>; Wed, 22 Oct 2025 12:28:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761136088; cv=none; b=GCP1fxIUKLiPhQ841ErAfePfEHcg5L8q2w5jm7sztOVK2jQpiMvS2Z8+D94zYPQLKHj6xUJj0SlJK3FtmvlAlHxoEqcMW/1Gh2pd+5csAbchrKXqzUj5bNbnm+WxxDgI+3IZLNK6ZTYfAcPDNQnrC8CZaGpqAZLaZ995aDzcrkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761136088; c=relaxed/simple;
	bh=Iejn0pWjNdBJA/skFH2+V/JvIaDlDJ3P1ZCkLVxJQvY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ExtWyG5YOM1eIatjXBNlIcZ3J7yd6CV/EciU7ek/f3dpuqCpKdJ7tiSiMEhwotmtAuf6PnoyLxOlPEulu5IgMnEU4ob7TIivrhkwRVp0dPKf3+TxTZEIlt8so1AEDyz3Ijuqp1QoDqCfHSDojJnzTTS2o5p4tR0Vx3O/otloR1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=IBqVDvHF; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="IBqVDvHF"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-427091cd4fdso3339321f8f.1
        for <patches@lists.linux.dev>; Wed, 22 Oct 2025 05:28:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1761136083; x=1761740883; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=WFbuSQX+6YT+HVJbPcsJSl2m1jB0KH5oX7eFGxAFFNQ=;
        b=IBqVDvHFc/QfwIJiuhgO68ol/ilo5y/7oxXqoEPtKdItJWMXz70qI59wMJ70v9X5N/
         xKJ6K3wUIc5Ij7HrXuipy1YsRlgGWDQkgFjugLVp7ev9qGvf9KSvqhCOj7hfqH/TWT3r
         VvOawUF88iW+QIBD0cX7uDemwrHEO+5HkGMCfZzc8qXOMwcmpIREzPP2Jn8ux309WIzN
         FrfVn31U13Zn8qvBel3sz+hwaEuvjB/b7jo/3K9Q22vtuYMj2pNuSbgbYBlpBGd/LMDz
         gBPDBQcXJhs89Y8Hxn4o85w1VijvbDSqM8wi20HMcLLS5HQGxp4giddgE2LywoV0rR9F
         xgJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761136083; x=1761740883;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WFbuSQX+6YT+HVJbPcsJSl2m1jB0KH5oX7eFGxAFFNQ=;
        b=tuKBVzhrr0P23leuh5efwi3lBeKDbtIWcWvvA/578VfSDLzEqsdQN00jXPhDW2BVhH
         Y09Nu9qXkW7hS+cT0sRt6T9NopiI+RjkZfH30Fjvxn+vCXWXoG8KNCXGt5KvaYRh3UZU
         ydHRQcWzNgeiGHYQRPyRy1KiDGin02sIipoJFeoUWBemaxgf8XBWlHxdH1ZKXVXaLJix
         fgiSG1ARRCIhQpqbcHu9CZOS1i5b6N4AM9T8UpGYD8tiM900S9f22rxlDE9w6/VaJ0go
         R8AzaKCjFhwyA9gsO5WRFPbzazKw4sw58eCd+mjArjpA+8fDUrqvdxvGww4wz1PBsP/R
         qqnw==
X-Gm-Message-State: AOJu0YzWJSKX+OtgGGfZl+N1r/GiQRyxm6kF2Vri59Su+7XKBYY/z4iw
	ec2Is19UI42jbf2S2Zt5O9rkaWTPJ38CN18zhSGO58PrdbwhXLdojaY=
X-Gm-Gg: ASbGncvsx2ofufvY3XL7TmxSb+efnHCNi9lFXhCNwagRwg4aYvLhs8+mBiLtxfAN1Yu
	gwQrO4rj7mZ6IRdj5q4lEmlaWa1IlQe23zWhdMnnvaKMyPSUPITFAJ4UfGtQ4SO6s7wFHmEsekn
	MqfxEgW3khIfc+V+884yzA5MDp10/NczWUO7GCQllX9E1lyQH081GKcppmabgecG60No9jfEG7O
	a29AcidON4JlRFlUTucLSozMBluSGP8bJcBYeeAxbapbsfQ35qNjUfg0new15d8xE0XGWUscsvZ
	yGtr0ibpFnI0K1X9E6jyQzYSZ2cDlPQE3Yq0ZtnRusY00t1hkRIF21Qw+UF/HnM2ZSbJbkpP1xI
	bCOc+v5TcEFCbFy76J2TfoEY4GIPXS1YXnetCLGszqcjIkJ0S0gtYbqiaaFE0Z9WU63V6IBehzo
	tc/LNgCp4rPwxpsb4DLq2b7EQDk+oIetNkDKfP7MA0zTv2Z/SlfmRsBsvQyJdqQg==
X-Google-Smtp-Source: AGHT+IFzalpz4I7N4GW5iAQvE1IHT4hcwYoMkH4rdlEMLAfJYgGKj+R8HqkyYQFmUVrdcF3vsI9GFg==
X-Received: by 2002:a05:6000:220c:b0:426:fd63:bbc0 with SMTP id ffacd0b85a97d-42704d786c2mr16326022f8f.27.1761136083310;
        Wed, 22 Oct 2025 05:28:03 -0700 (PDT)
Received: from [192.168.1.3] (p5b057850.dip0.t-ipconnect.de. [91.5.120.80])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-427f00ce3aesm25354082f8f.48.2025.10.22.05.28.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Oct 2025 05:28:02 -0700 (PDT)
Message-ID: <7965a547-2267-4f09-af62-0b81a2d8dae7@googlemail.com>
Date: Wed, 22 Oct 2025 14:28:02 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.17 000/160] 6.17.5-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org, achill@achill.org
References: <20251022053328.623411246@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251022053328.623411246@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.10.2025 um 07:34 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.17.5 release.
> There are 160 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No more screen problems, no dmesg oddities or 
regressions found.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
