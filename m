Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25AD83A6F04
	for <patches@lists.linux.dev>; Sat,  5 Sep 2026 20:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788639224; cv=none; b=HBxGSAvOgTGevzd+IMyw7bBrMzpRQix14wtAmIrN7rN2ROE0ZiyjujnZswJEPZJN5hEHyNc9vRPRcDpR+VJg5lbcG+HJEJEOYsH/dJragYO4VDQTX7MqXKeGj0U09QgbZx8a/JP8TE337ZcbhX0Zmn8ZkykxhLT+D1eM9yYoEiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788639224; c=relaxed/simple;
	bh=3PKFXcmHlUz3OfVy3HJ0w8Q/d1ojlG+0EylTJLYM3SI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Wlh/5UdKcxzMK9XNIiwBzbvenXpkgvWlCH827pIOiBHf047s4aOKAr9K1j0FyQr0wGjMeER8Psr+gU6ABov8BpM4/GXrf6F5GgpxL/pPxuTcSKWFDwLHqq/60VjncTg/g+7KbModAe0ILja4dP9/he7TKEH/leBBcZvUf6r4L0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=cVZ5spD4; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="cVZ5spD4"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-49b0d8bc2aaso27403325e9.0
        for <patches@lists.linux.dev>; Sat, 05 Sep 2026 13:13:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1788639221; x=1789244021; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AYLQLVPrMZqzYFFCaoEPigRERkkXFvdO1k2M4yUI9oI=;
        b=cVZ5spD4FgQBMwYPADIlxoOoQ9LsY2E9cuvknhYPjjCuAxGlhVmrFgcpvQRUKDVxxv
         4WnLlFczZMjKtyrlhJtNwXTMF2ehYx5MQfGxu1qwIlmg3Lp73VRssqTDXiMA6a9A6XfB
         9Eiq3Nl6jWOaQT5i79CReh8fuSG9MfQC6GXFLt1oGSsyTTxmBfnd/lrzBsNlKRuqY8BY
         Pfutz42hw9eFgDOtVO0yQXOmpp1+2IfUS6oxjN9oXQw1ocZXYVEfBciirZD8XYGtbYcp
         GjpUI+iWMcb49AaGoPxSQTgcR+WRZwgxJ9e9RSqhVcTVcyrUsnUG7qD0KbSFGTDLReOB
         8W/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788639221; x=1789244021;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AYLQLVPrMZqzYFFCaoEPigRERkkXFvdO1k2M4yUI9oI=;
        b=oi0wmjMVxFhrO/pdC7oRVYTrKD/O7aBmKgKWiSLAJ4qnGdPjjJXYX+yYkVMbICxoGn
         M8emtzuIpXqvxtUk9reTnRzDgW0cY0i1wrz/ZCiqn0eSRNS5Y4uyQvB0HBebo/LEWdXT
         S+mDn+IQK2isBePxFEtlICkoAJvMyAshPRep46o03tsezGbY5K61AI3d7n7NC0vMzWQ0
         ee8x+tqDs7pjidoLW8fj8y2D5/DWbPY80xa9/eBHB3vcbbGME/hsoNZ+QD1pbu80ypFi
         4bTzSwdc4qEuVJOg+6rtksKZzmT15kSpREmj0YxieE8Y8J5WFtWgNeAQ/Rxi/rB9eT6Q
         6X5w==
X-Gm-Message-State: AFuF++mj4vSYIAi1sAxr+a8buBu+usCRT0czTpmQ9mI9PfsZrR7qdv1v
	ZMqzRNnU8g3fPUZZNqoZgHIUbEPtOW+MUVjaPM7b66hE8uBKYCxHMHk=
X-Gm-Gg: AYBFou0ZoAW8g1Jo85yFUM+gJIcNUoRl2XHkG+0Hv9yB6JM+JysLHj4xqkLW2+F6fLV
	n9/q54PQmVQJSXmtu0DKvtXMvDKFvHh8U3pFY2DpNLOc0XEoV54Cln3qAqmFSV6nA++sS1drs5+
	MF5u4xNGE7LCnzNQpuj2+nzL0WWnA5I5/X3bl22wWihJETs+uqqznIvHmD/NZU5xXhnHUzlMOOk
	M3dDcTS1YlEySHboRXVjfNa1Uiboj3pDWThx2DY3tI+8U235gSj8OeUTFFxjRUwRXd+42fYsrRh
	ltie1J4sytP5DCyvz9rpIIMlHyvfgbxuo9xi7ZfFBIBz/pDEz9Wg98L1A3fZbswqrnjYKktjSzo
	+OXroRhe1lMyZIQ0ryn1ke+tDwMgitMwef7d7joGP7IEiPN5lkpoD4V/Y73LOWkj/0bUI3oklM7
	UKTXBgwmFBD6FBXM9ajEiiOzHipiJK+Byur/OG4ICypyetRJ98ZVfWQ/ydV5gr1bQPrbvZKIfMn
	OqZEZsfy774Ct2sy/KPeiQGn20nYTGPo3iaHkXQ
X-Received: by 2002:a05:600c:4684:b0:49c:fc6c:be14 with SMTP id 5b1f17b1804b1-49cfc6cc10bmr112637755e9.26.1788639221125;
        Sat, 05 Sep 2026 13:13:41 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acda4.dip0.t-ipconnect.de. [91.42.205.164])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49cee6023edsm253975395e9.7.2026.09.05.13.13.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 05 Sep 2026 13:13:40 -0700 (PDT)
Message-ID: <6b05880f-daa4-468c-bf98-389111b2646c@googlemail.com>
Date: Sat, 5 Sep 2026 22:13:40 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/551] 6.18.50-rc2 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260905115635.269562615@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260905115635.269562615@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 05.09.2026 um 13:58 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.50 release.
> There are 551 patches in this series, all will be posted as a response
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
