Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793246961;
	b=S2A/6OdLMgTAHSKbvlIfxVKG+O8exaEaP2IeLgr60lhCmxXVhZrw3F5r9Ffer5QWQ3U0
	 kY+UsNBJlcH6KUjVwomT19f1mwawksow+DYw62/k/km0Eacm0Ed2TFbeb+lbj/5PmHyP2
	 73v4HT9/Z1ujRuY+PG3MYXDxktyl2wTQaxPhSuFtzeGjPDqz+WnunJ9vi5iHCOPCWXbFG
	 1Qt+4CRk8cEh8tw+zro3WsFsHXFMV6MbBt9E0QsPZfMMBTVBHZYLgastHXk9xXiaCXI5G
	 a1AMiPBsYJNxznhUx+QW4KewiIQpgMYBEaG+GCHBtcYIisFqdPz1ybGoXrpX2dJx6nQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793246961;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=hO5E56BpVRLZeIlxDPKo4f1e0ELUqpBl2C419IjueaI=;
	b=W3JfoywJNpzZW8UZp9KnnxgdNSYdjFaByDe8faeYLu7mkE9sadXdnmuR7BlAI5DOggVX
	 GETiWdlkT42SBRIYAqi2viR1hM3D0ORDRKIWGw4+V+NYKAKDfjoMsM1+B83uqb963nzwl
	 U2qxaAUycCeuXgq9yPUWwuQcSeFpcg+wESeQvM24QwqLn0qblHbDbGDKBFsyRHdN24fEj
	 JRsfeBmZzkdYKCzhLLpWu+YnHf+Z3FveCNwJ520wopPr8DeHgXvkG7U5GDHNr/lJY1kXN
	 xk2gWmzNl2e3sWVjMhbvJI1CM0rOCw6aH65NdsTV8qe+FmLX2Ea8/g8VUNJjbnW+Fdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=YUyqHhv0;
	arc=none smtp.remote-ip=209.85.128.48
Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0FE8606A31A
	for <patches@lists.linux.dev>; Thu, 29 Oct 2026 04:09:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org E0FE8606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=YUyqHhv0
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-4a1fbd52ab6so13191145e9.0
        for <patches@lists.linux.dev>; Wed, 28 Oct 2026 21:09:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1793246959; x=1793851759; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hO5E56BpVRLZeIlxDPKo4f1e0ELUqpBl2C419IjueaI=;
        b=YUyqHhv03+p0IHDXoCBKo9cUrhvO2FmC+RCjqcH+OQmvIHIUb2rPYKLzNkayMXMc2R
         7b3JUOM7LZUT8JfJJE1oYvLcy88Q9N62ix7ZLI+YIHYWzvfMwkMVihWYAIoeWYMDYloE
         F/n38wymiQK2S0Iibj+/j0qIaEm5vAN0ohPd4GwZc6e5PVhtiuOMxE9bfLaWi7gdFn32
         4093IR52xPxB1G4RiF9VkcaOGNL4d3uBpuwHgaKuc9EmcnUlCd3Zw4RX9FB31dGRkBPA
         ILY9eqMmToCIbl7Dzs3+bXHY5F7EWJImfcLTiwk5+05QigwPLJ5qWntZLgEHnYakia9c
         2YMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793246959; x=1793851759;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hO5E56BpVRLZeIlxDPKo4f1e0ELUqpBl2C419IjueaI=;
        b=hRlPME/z5ZyYs/XoNMj6mnDURHFldQevIj7W5ps5Dk1E+odQUeo+VkTW8YDHRAjEvl
         YZl7//zw/xNWfExBZ32nIuW/2zAowQN4VELjB7K3q+F4JeFS9oi6kpcjPrVvUFxTWO0P
         +2Kk7RpEddkyga/TZ6ggKfzOabpMWfAj+EQfz1h6ATAEt/HB/GX6pd8ZXfY2aGWsmo+3
         7Xq2Slag3eM3CigEAUqlMloQPKEr85+1T9OFr4GU5yuN2Dzfq21B2Ha7pTve69792twu
         QEgM1kR0JVw5veTauKtda8yLwLWytVCb4rU7q80Gk8dPzrHL3Ag4FHsXK2H34NIV4XNN
         0Wng==
X-Gm-Message-State: AFq9FYL1cfbVhCFncdaybAitMd868965wIAa4AQujns8bYSH4xxD1diE
	bQ5nPkA3QIV4LUZvhiFTAuxDNVozMJJJd54SxMctagTHIs/gwKyBtHI=
X-Gm-Gg: AYBFou1AxOJnkuH8C/pVpcNw8tQ7aV70L7fxqSI5eW2AwDkDJDH1ppeCcSDoXBe22VN
	Hz5XBgvgRQvVYedg/fGZms2hAZV703WFsetTjLqNJHMzFW3l9Qew4fwxHlv0T8V3w4IPJtqD8Zr
	TB9cclIriwU1Jtstx5lN82kxdZC4ki42XdQq5LtOs2TqOwIRa9s2fY+xsFLS3KxX7KjlfboCFAw
	q3euxDtT2WRhVIk/7nyb5RT+98rAiBrsWExgRP1QXnk7mtGRNMb/2ul1QnE7c9jxLmae2A6Ba/c
	kXvJOVh/aNdZr8jRhML/z29+1r0jNA6Q2JqI+ZweWThMj6YTtBYSTjbwvObfJ8mTcXQu9ouyl7P
	aftvkZQ4r1WWH/Yp/wLWB5L58HVZrIsaxW8cyb1wk/0gmSXdWC/oAybujz45InSawER/cf/ZeFa
	/hdaDDV7mBVseLZB0b/UIDvyHxgJAHW8uhg8ISmZwMBCjUTpmV3gjEph97U5VliTSjoxH5Yvi//
	fvFCERLzeHkjxWczYbtsxKOS9ho9n/GjJCSjb0/Lweo78d9Av7RLcunFYtEjrtGLN6QsXxnWmXc
	96OqFoHWzMrYXbhbihxvrQbotOiOiwrynI2wZ40c90aFFosq2ORzijfZqtzWJwdF/j72NSUXZ4i
	un1NTQJJXc5c9tnmguRSKonHw2K4=
X-Received: by 2002:a05:600c:1f84:b0:4a2:9cda:57b6 with SMTP id 5b1f17b1804b1-4a966f20b54mr95998195e9.22.1793246959195;
        Wed, 28 Oct 2026 21:09:19 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac3f1.dip0.t-ipconnect.de. [91.42.195.241])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecdf9bdsm30656919f8f.55.2026.10.28.21.09.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 28 Oct 2026 21:09:18 -0700 (PDT)
Message-ID: <6be3fa06-c2c0-47b1-8a0c-cc96e5a38647@googlemail.com>
Date: Thu, 29 Oct 2026 05:09:17 +0100
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.2 00/88] 7.2.14-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261028165942.107695352@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.10.2026 um 17:59 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.2.14 release.
> There are 88 patches in this series, all will be posted as a response
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
