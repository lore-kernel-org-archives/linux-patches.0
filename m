Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.128.42
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794674762;
	b=mGjiOzScVgLqysZbR5F73OWTI/Qbntx7+UUf1xTVJhtje6NQTBDiW/C5B55ilr/250Ze
	 wL1lYkuy4KtisOi82AyZHjkq9dA83TSTALz+/CLA+j6wbn1RBtGDa791XvOM/J2wLbu/d
	 0qEOscUFTeiaHMLJM+Y68OJjGcr7CKyYDVQX5rJ4cb8fh+ipwmq9UG80CUmn//Ny5OI38
	 4jEYl9uj7ZGNnlu8jgxluLVhw8GXEpt4B+nkMQ0Ji9hQyJ64S5aYwtkx7sU6bTf67E8yq
	 c/i4IRxC5xipoJa8xJrgely0sjURaaRPIUtl/FJ/xwydu7F24+s81a7bWM+O9Xra3aQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794674762;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:Content-Language:To:Cc:References:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=RByEtiTC/lcrF+PYQ/coAaO5YWg4gnthMLJRYovYsjs=;
	b=aSAQCHvXyCv/MjMFyk5ptbfSYEsxGUmBBC4BTN3mJX14XF/CqnxgSOQsBiw4A4/0q/nM
	 kr9T3+WA39TWlwblX6BmQMjNzZnro1Fdg1QgOqGX7/IfGt9QWaIV43Q829CLDoshh5LMK
	 OJDffb7msEXuCoE1J/n7ManfvcenO8ifhtw9vn8xHUFFN5w48M3zIf9RuPk5Q+FWuqCX4
	 qYqlKOu08/qCdlM1/OrN29JRS+PTIrweUxa88AW3xZNSXaXqdMlHXmfG4azYoAyYhR1wG
	 mbyje4pihD1pnF8GhIPXs2+HttUxn7cFgEsKjAaGYefVHgR/pmMJVmcuTEZkWuCSM7g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=googlemail.com;
	spf=pass smtp.mailfrom=googlemail.com;
	dkim=pass header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=g1tM9sNu;
	arc=none smtp.remote-ip=209.85.128.42
Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33D71606A32E
	for <patches@lists.linux.dev>; Sat, 14 Nov 2026 16:46:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 33D71606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.a=rsa-sha256 header.s=20260707 header.b=g1tM9sNu
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4b79502c27aso15131555e9.1
        for <patches@lists.linux.dev>; Sat, 14 Nov 2026 08:46:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20260707; t=1794674760; x=1795279560; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=RByEtiTC/lcrF+PYQ/coAaO5YWg4gnthMLJRYovYsjs=;
        b=g1tM9sNujB72k3P4I/efS53/o2AUUCKW5TU5dKGvgHquo1TGnYQtRv2XtTcyG4fq4r
         5BEBVdiuDt6sdxoRmh6CI8+QzDEOgcCsdwPZSQJ2fkjM6mULYP9Ofy4zfSbGA1ktnFvR
         iY9j13vETEDyQAm9qeg+dnnheSN8qrpRHFNktljEQve0hGNsOsndKNuB2+xxPcXk2M1p
         AJjuC+w/NP6PpqqjFkAq/IGzxYesPJU+bCo3kmzfZiPHjKZXP4bixb/S4jPbLnYgFoz2
         9mmUSfMQS9Ss3J5aB7v18ptbIgo9CHgdpYEOgsLam0Rf7RwOPJmgfSZuofgET4Em84Zx
         nXcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794674760; x=1795279560;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RByEtiTC/lcrF+PYQ/coAaO5YWg4gnthMLJRYovYsjs=;
        b=QvTJ4tmt4E1oOSGldKSc3AEdgILC4ZlV8KA2FhJuFvwpgPZnjbR/Vvrv6WSu6LyyOX
         7PunJLV6kTd9M3jEN4HphhXyhQMgKU7aMxMuhtqNOkTqP0KRPCMe8LaXgcwFWyWV9s/A
         e7RX48h/MGIL+W3rP1Pst27R5KaLKwXnGbXTSBmrLtvHpODaafP5S2uAGaKbTtVmIwnq
         sr4CfbFOK41fC8JWLsqpHvLZo/6vK4+zjIL5tA8Jx6k+8GP8Ql+uHEFLC9j1jjtATL44
         g7l8f24uw+m5vRl+wg2e5w+ugAO6E4JXDqMSGsm23c5so3KkmLyZH3lGzyK1dWC88JDW
         Di3Q==
X-Gm-Message-State: APuU4Z8dQ8unyLhZQZSUxBBg8/4JM1yjowAjpghw5xjYFlt67MtSg9Wa
	GhCGOoPohNc2IqGTHuTYzuRuWQ5RP0rwXdydtAkfM2qEoRQW+kxwYgI=
X-Gm-Gg: AYBFou1Vaz6N1gbbiB5EJWhD+lmkWDa272VQKeBPoR83jemgEc3i3nwHUlEE+CbiIW0
	R2uwd34QiZ1TeutEJ2564ghgu3l30flbFWCVf0W0wZHbXN6iAyf5R4HbIXosT238F8Ph5Tpyi3m
	8P2q8MrKCMBQQeKLYnhgE+wytZDZmFB1diZLadxi+6fQGfHzcD5Tg2dgEBxZmSJ0VV2cJUwyijp
	6CY8Cr095CT9O+hW2jupoTk3g4JsOg2yuxftS6sKAKu+HUKeu5BfIKxtT8CxKCNS/afiN0sQF+5
	mfbWjbevxBr3v2HauZPCs7YqIg4MUncl3qYgVVVslFm7M5obj1iwey8AM0mBliAz7KlfAi0j2iV
	zhnigfdYIq53+YJKDuRZ2WGw5X2JJwJmkorqQKf3BKU6EshiIs3BE7Bj4W+diwoaFDMDg4yO2V9
	jMY4kHL3oG+xRFC+/M48urhMdb0eTSTGNOhwmuad78D+3ZaMC74gxgng4TWUikibdgEpzhvqQfL
	I7pUuKcFQiTVKjK2BvsBKwETKXbEIRuiwIV7HywGMMh+OPeHvPcYUBDWfHYolCnr2Hz15QAZD7j
	S5nnJ+VbP+npERfPriTDOghVggO06CLM8G2MpK3tNcCjpnHOVkFDIYK+ZTcU3+pvNC1OyITT2fM
	jMKbrpxy3JzkIe+k7usypbGsEyZE=
X-Received: by 2002:a05:600c:628c:b0:4ba:6d8:dfad with SMTP id 5b1f17b1804b1-4bb55a6b67fmr136565715e9.14.1794674760452;
        Sat, 14 Nov 2026 08:46:00 -0800 (PST)
Received: from [192.168.1.3] (p5b2ac4c4.dip0.t-ipconnect.de. [91.42.196.196])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4bb52bab8bbsm171491635e9.13.2026.11.14.08.45.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 14 Nov 2026 08:46:00 -0800 (PST)
Message-ID: <848521d2-239f-402f-ba0b-3e0bab7dc18f@googlemail.com>
Date: Sat, 14 Nov 2026 17:45:58 +0100
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
Subject: Re: [PATCH 6.12 000/670] 6.12.118-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261113153811.177190860@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.11.2026 um 16:42 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.118 release.
> There are 670 patches in this series, all will be posted as a response
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
