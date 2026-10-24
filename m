Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792808835;
	b=jGlmZElrEwBGiozyzEF2Zfl1R9WUuC/VDrUFKzw9OI4fHgxPr1/fOgxuBOw5x9bbyQ+e
	 Emy7UzBM792lYCte/vmpkbuEf8MLLqTXICYgANVjDxgiIR2JNnuxxcCgi4Dr4kA8LyCWq
	 +xN4deu7g9yJu+Mj4jzZJPbbi7YzusWhNxtW/5lgMTVfhxQHZTmBcn+MwW0S09Pob+3XU
	 EEcxy9C4d1E8GsErtsU5JOyyad2C0UKnJq8btlBh1tdyjfpDEmXdu+2fezV0NUWawo3Qt
	 zUYgcimzOPSSYkaG33sdwSrJqK4WZUGP8vexBVLzF6MwQ8g5PcHhN+s9bqkHxv0vmSA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792808835;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=dbq+C1knGtel/8heo5gmPJKIJmhELJ53YLi5og68HsI=;
	b=eaOGGj7cwSOqnCLzDqN2wM96Q+hP4Q+qUB/4dJaJCDplg3QKawhIUiMkwTl2kMFVlpDb
	 CfFNA33BCbdYAhK0I6mdIFT7iGumyI8D5vtm9wnotAc7fglL18PhJ2iCsIVZMmSzfxGnR
	 /DOz2Bd5kxl7OfKNbt3Xi/lEEmgT1mhbI1W9JzXzyL8OS7Qy4+vFewwQE8gv+LrY7jcE3
	 gEWwfbcRb2BoJsYkph0G0BVN1wLJSbvSYyNSclxibd6WzunY9+5vKdFOWgcCaWwOkDHU1
	 vmyShnVMcs4UWtdvFjArUnWRZxiGa/lDUXEZg9rH5YFieRyU6Ser5DEN7KNnw0hNNdg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20251104 header.b="RUv/hjGK";
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F0BB606A31A
	for <patches@lists.linux.dev>; Sat, 24 Oct 2026 02:27:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 6F0BB606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20251104 header.b=RUv/hjGK
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-4a210470b49so10786415e9.2
        for <patches@lists.linux.dev>; Fri, 23 Oct 2026 19:27:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1792808834; x=1793413634; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=dbq+C1knGtel/8heo5gmPJKIJmhELJ53YLi5og68HsI=;
        b=RUv/hjGKn1uJchGnixvgFJslxHASXrVtLG4hKJxi45e6h/bM8mx4IdkIoijYY5M/E2
         tr7Bcggk3NsDwMmupM4M+DFD3u7h3vO8WIGe9rqoGbllm9znO+nVdswROi/ZqLUVqalb
         dGCXiT07vOJXuoeN5brAl0O5TDYLxeNY6GEW0KslcG9FHfmQnhlo170reXLkbuXQWLxH
         dQva5xIu28HADeAm8o201UkF42jXDHF9C9PpQuBxlPY+wVqbkW+Ec8F8ryAZY94O7afh
         xysgFqZufrtxLKnujtEuYDynzAYTKIsd+QTKlcj5rEo7IMaujKvZtTOX9peopvKu/NmF
         4KlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792808834; x=1793413634;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=dbq+C1knGtel/8heo5gmPJKIJmhELJ53YLi5og68HsI=;
        b=IWInqwrBcYGBYdXlBSAuq9GCcOi7gUBHS6SzbKtlIL+J+JYWqU74R1DKy0VFyFZhfT
         sdmWHuhU2+1IteuPiSePJqrn8mywwwvXVSMvy4KL3MOMzx8ctCXjyxIDzm7SXubEIu7Q
         /VzqVksrINC/wQxFpPT4xJNePeI3l9u0ikH6mkDgVwuhrcYWO2FyPKhv2S2/X5fp3lyj
         viNytQYgWK4fgixwE9HDw9dmJGzDE+rSwn38cl0WSFuUPVEJCtj3n217+Kx4lKOu5+0p
         SgqVzyX/HV8LECw4VG0V4rPvvGfqrwyZuNy0MzklTA70EOmDQzTZmxBfi+1UQoFIJLYQ
         Y/Rg==
X-Gm-Message-State: AFq9FYJzovZagKatb5mO8wCqUxVtCe3a0lvvxBYBX3UTSldSboyeqX4K
	oYEhiEj2gTnJF8yETO+ts2keFMBdMwJGEUbbHlIrjrZ9iWiR/6ywSbA=
X-Gm-Gg: AYBFou2tBpXCw6C8X6w8TlyBbVfK6RB7p9oR7jjZTbvwpo81bnHYvsVQgXPeksV5Ra3
	oum/d+NFoIs0NXErwO1m8GY9VoxlHtx8/fQPh8MTum746V161cDrMOQjPnZi9Vtmfk8gerDFjzB
	Rp+aaiU9IYriiTu+krPB+wYh6BlDggDTcIIFGYQAF5Gx9IcxWzbvZKkAWHIPULdYBC5IBMCQRIK
	4x6cA4trk7Qin3efdtRFatbwkPHIiKp8+xvUoFR1O/1uWNhwYzWFmzQ+E2M+9KuAdMJqmcY2yzh
	XmMCqOC55P4OtDMi8A2MW8MQRgz7EPXYjgagAhhnl87cRkslmIq5iBWcR9qRb53DvZJTCTNa+yt
	tjFFsKghfJAlm+/cKR8po+9MHFvfPtU6U+MIb6UhTkWKuRRunn8cp8BgUHMF5h857wbBAlptkA6
	QwIsr6hT3Z6BHAk2UJhJrQtTfeo5D2Pf/kprF8A1ViaPSSAwAxRuWhpcWxGXL3WAvvNM4Q7mlRr
	WD8xZsuWUeSLZxUxQb5H6sO0cFgwCSt4txF+ShS0CDrcKJ7K/s5UQcybKq6iO36CaRUoINi6OoF
	Ib7O/nU5dCWS7V2+75xRTjwVsn9L/jqhTOIXZZdmgIM+f2wb/vxVcA==
X-Received: by 2002:adf:ed8f:0:b0:48e:1d87:f170 with SMTP id ffacd0b85a97d-48e3eb83fffmr740933f8f.12.1792808833581;
        Fri, 23 Oct 2026 19:27:13 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac555.dip0.t-ipconnect.de. [91.42.197.85])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e3ecd37f4sm1742797f8f.44.2026.10.23.19.27.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 23 Oct 2026 19:27:12 -0700 (PDT)
Message-ID: <a4ebdccd-4f47-4449-b120-59e1d6bc4951@googlemail.com>
Date: Sat, 24 Oct 2026 04:27:09 +0200
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
Subject: Re: [PATCH 6.18 000/193] 6.18.59-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261023163714.201276352@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261023163714.201276352@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.10.2026 um 18:34 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.59 release.
> There are 193 patches in this series, all will be posted as a response
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
