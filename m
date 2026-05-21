Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD42739282B
	for <patches@lists.linux.dev>; Thu, 21 May 2026 06:14:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779344077; cv=none; b=JwucHXITpwP8utSSeEn5Mq3FJuetrPE48nfRbleArJQEvTBQ32+cUY7pY6d9SgmH7m9w+0Ve7Go6fV4MeEqQ3cqeB0miTOxLXHh22LNCfV9vIDvlsVW4pL5My8cFT+z8d90iNdSP0Agig1KCeN7p6rfJDZgjF7DRDSumzaS4ne0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779344077; c=relaxed/simple;
	bh=mVIiD0RVDenjsOxb5e5BMzgLEeZRsf+/DVb2UcQ6CHg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WZB0NgSY9G8Bn81/6h0nGffI71Jh7wpEeElrfPc1W0A561i3btSwnENiaHkuZcLl2ZPwLJyC1M28NT0TWIaWpmR94T7MvrLvf4zgbUNQhmt9kjXTgNBH7R2EuC6oyhyorsjwiB9PYmEoBOCgLZuzbAg1iDLNqP44p/LmW0+/7+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=ItNeM3VY; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="ItNeM3VY"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-44a74032ff8so4131117f8f.1
        for <patches@lists.linux.dev>; Wed, 20 May 2026 23:14:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1779344074; x=1779948874; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=JOjcszfYBOtrIqFg5ayXWqcuSiWz2y2sNwX7DqkC0Z4=;
        b=ItNeM3VY0WEBbILMdFGANwhMw3o64D9MWX+PD6UqlB7ikPX8oCOTQWKmYuxgt1SmuZ
         t7NZVr01FmiJV1nJkOptbG/vdc+87qYKQa/qvIFWIhfyuSCIGbJe3H3s+FQWPRK23xrr
         rR4OVnD6ahpLBKxB7CPpQlXjvuGOEn1YYMyl/JdOYxdfw/NubU2PLWMPblzmzqcmGEau
         OejynRgeDGIXhzb6rJKxnnuxNpp7Sj/Zql66WOtkJ3RG9zuLxS71x2QxZNmOHHqszA4P
         3H2t1YPaA2PG3qpSZWmEVNwb1fWcgl3FgUggTT+o8aQRsEOy+SF8c0y5930j9v9J/P9Q
         qnKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779344074; x=1779948874;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JOjcszfYBOtrIqFg5ayXWqcuSiWz2y2sNwX7DqkC0Z4=;
        b=LwjKZtaZj9Byql1FUK6/LZg4Im/FveWIzYEJQ+phgWQldlMxS5j8Y169T0EZsb929f
         2/X8fR3sWzU5liIQHmlHMdVB5Ibko7B0EeyMiRUGW3uUco895U8cQSphBzHY/iw7NYu0
         F4WLCEeB6SAt4SCqLGmN2x0lEqKud8Ck3TB34/ayYDEQNQsIc1CLiC2fHrNNQFanEh9Q
         c8BvdtYorbd2zEfmbTD04JEiBof+iyuYzrVE11QvCAEKYVzZhtj2QDGxio4FEn5km17F
         80DzKWVMrblVziARPBSTKXkZtFup90COvQxmOIaZqNXCPLTuf6eL/ExnDQiCF0XhDQ/g
         oE9g==
X-Gm-Message-State: AOJu0YwMLHinyimygpLhE9pjlNo+PAKUikM6P7HiQk9a6azYVk2Q6NNa
	QjJY35/ozJG2lEEmuGu5H3AGB17he3G3A5cPcyQ/ZB58s7DI38QcyGg=
X-Gm-Gg: Acq92OE9DGLdj4sAhtcnv0Aoa2rZ8O+INaP8xK7ILx5bD6NLd2fmTy2+TYNMZFFip9D
	uCMstpZuNs1wMfyPaZqFmzk0hJzWNONT/scObrkqawrVHESmG3DMYxmhhgswmGb/LTb+0y6L0WU
	2lmrkGZC9d6WgYoHEojCIUOxeVbUHz8S7m5IZDoG/cl/smldcyCf+WJlWOz8RCFRfI7oYMyXsI9
	/NEsMBQPLXnpCL76se9Gdj2rUH79rjwv6QtrDCUiscOHclWeiDQxBWs3dArEAne2Yl3x0VkxA0q
	jsoZDoIUoZaQbg22U2dNrbKUmB0b7B6bMtmCTvDmNZpSq0bHt43IL0xof23y7vytZr0FOXPF3ET
	YEBY6ib4UXmc+QIEjpNWZHWAO2ZWSqSHq9aT3799zybIICZT/rQrg6uO42swQ5emFHR3+SnupDc
	1riFs7U/or9j7cAF+tJlwMTPLRbxELkfil6PsdaL6OLge2a3Ch2Of334c9jjMChZI80lEkmKu//
	4Y=
X-Received: by 2002:a5d:6f1e:0:b0:441:36b7:725f with SMTP id ffacd0b85a97d-45ea38cd40dmr1876006f8f.5.1779344074023;
        Wed, 20 May 2026 23:14:34 -0700 (PDT)
Received: from [192.168.1.3] (p5b05786a.dip0.t-ipconnect.de. [91.5.120.106])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eaa93d29csm85724f8f.37.2026.05.20.23.14.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 May 2026 23:14:33 -0700 (PDT)
Message-ID: <980e2543-98d5-4e1e-b9e6-04c826e4054e@googlemail.com>
Date: Thu, 21 May 2026 08:14:32 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/957] 6.18.32-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260520162134.554764788@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Hi Greg,

Am 20.05.2026 um 18:08 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.32 release.

Now I'm severely confused. You released 6.18.32 on May 17th, if I'm not mistaken.

Shouldn't this new 6.18 RC be subversion 33? Did you miss to increment the version number?

https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git/commit/?h=linux-6.18.y&id=b7adc4ce3f26a74d49d3703c6390645cb313e52d


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
