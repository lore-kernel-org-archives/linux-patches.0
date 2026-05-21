Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF701A6836
	for <patches@lists.linux.dev>; Thu, 21 May 2026 09:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779357164; cv=none; b=BNi98ECiAiiKTqnXG6tdH6aDozLXtLrWJMflLY3K4j2O7BjeWgkwHCErZP16PgGC1lwAtjqoquumF8ypw6klOlS+kcdMT/o7SMA++1527ofig+qOBAxvmbntNNjSex/aFwEA+r32Rde0bu3Apd2uU4/E3Tg8HdXC3/ALYna/AR0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779357164; c=relaxed/simple;
	bh=0QyioV7LZG/XafwqGzx1VCMm/RXybvPP5wY/7llNAPs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fOpn+Ic8C4kZphOOZd3OupzNU4pgYE9g4phJN4LLzd2QaOPd1tGZ+hAgMl1xHPFEky3Az5CBMoDltM+FR/v/EDq63a5u9hO3miqBbXEmPYHzdggrM8QoIS/IwCILrIPD/UuvtzLAJ6lJMlDe8jSS+ODzm3xTKqwxc5w1zfWH7SA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=NZ7+HvSh; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="NZ7+HvSh"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-48896199cbaso46053635e9.1
        for <patches@lists.linux.dev>; Thu, 21 May 2026 02:52:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1779357161; x=1779961961; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=LHV1Tr2qVkGaZPG2Ty6FXE6k+T/1YKEQK/jgqv8RQxo=;
        b=NZ7+HvSh03CneQ/XeVEmVn5JBjjxIMIECU+Q7HqRBrkX8S8eG+DysErJAwO5+TaQay
         mk13kASs3eSSZOXty9B1WCnD8jDvKDnVXC1PC3Ih5W8k48Mkx8w6xjFsO+tDKHSCwllb
         3E2a60gPZ0xq3K5JuFCp3Jzv1kD0xeHD7ls+Lunc3NLIPKWTGmxgUtLVyV63xiqZteJY
         BSSmzfAo5LWV5drTxZegvOXBCMud3aOPOWqcssYLBLfd/KqR429uPeNYNoe0gvXdzkJk
         9JPPNAdxxpz0pai714LHvUlfiNPYBNRrUhWexDOdnZmvfQSe7iEcqFXxds1l6ldXpBQo
         4Whg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779357161; x=1779961961;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=LHV1Tr2qVkGaZPG2Ty6FXE6k+T/1YKEQK/jgqv8RQxo=;
        b=FLtOb9daS4r5yzXpVmqv3M1e+7SrlpGsA5HYiKP8iWmDYdOOC6OBcJ01z62HiaS/Te
         DRlqGT2Bgf72uihuhyGmk+TKXcW2QoBNhVHc/nQrYb1rOxHoSAayOkj/LR2HV+ZJE/Ln
         jDQR3GQRZkTawcsv02gpdlqoIFA0qXOG8HYp4yZn+QPpsoORrInwxOklAmgGIYsPkWFq
         GRv7vZWHXJFCyRo1+L79hkaUhUV9DN8kXWWrL12KuLnuY/M4JsgL7Wn0lTZGve7dfc7H
         sKW0llLAj26rYD3cry1HQ5klARuh18gbaUkMFZBkZUbz0ZIGdxaAaI1OpEKptSo1UTqR
         5PGA==
X-Gm-Message-State: AOJu0Yz2IyaItgacUjrA7FaRI3MpIJLjt/LJ0bT8HPRxUsjDOBRDxgE0
	Uh0lgI0uIy+FGUE0QJrSZIyeguM/Tjitq3jor6X1NB3kOcpmsUUu1+0=
X-Gm-Gg: Acq92OGz72c4n5/60L0vri77J3TpwU2ZkY2GxTYSKP9V/ZjfkE3pFurbSeIpnx2jSQt
	oK1kiSCOA+przvPPxgbe3Irb6RwOj8QL/kb6G8Xcq9Htl0DuWTO9jt6MBHgMix49O2kR7QNoLZy
	SgCLuVTy5h+7FgeXWw038uj9PToEUaFfjTeIYjc30GWxJcgF+AsU2pKI0yKz06yYiWg0wFuA7z9
	/iDU1RINeAh2mb6u36MkfWMji6M38iKLRTcCFKMVgas9EN3fYWn4Q8zZ//eylO7kCOKxDJALGDi
	ELBoExJ00vsKaT9pmJ5lkG7A7AL31/YqEA7ZBA2OHXI1TYyBCtlXF0ePk4UQFIQQx6DxsTkgl5S
	W+Kcs0fmIdZL/CME4FCo5E6YWHyqpVqSLPp+iuosjvE7keMD+MJuPGwyMOvBpFHmGGcThPxrb2k
	v6YMMUhtP9kmvN7bcJevaAdCYYtsAQ1FZrpn3MfkzjhEzcbVu/QzrejzbYumuCQqqxjNGEWfPsH
	+TOZ8MzTHUnIA==
X-Received: by 2002:a05:600c:2d8b:b0:48a:906b:14ca with SMTP id 5b1f17b1804b1-490360a53dbmr17287135e9.20.1779357161328;
        Thu, 21 May 2026 02:52:41 -0700 (PDT)
Received: from [192.168.1.3] (p5b05786a.dip0.t-ipconnect.de. [91.5.120.106])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45eaa93d29csm1604352f8f.37.2026.05.21.02.52.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2026 02:52:41 -0700 (PDT)
Message-ID: <7014b6c8-ed0e-45bb-876a-93ce4511fbbc@googlemail.com>
Date: Thu, 21 May 2026 11:52:40 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 000/957] 6.18.32-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260520162134.554764788@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.05.2026 um 18:08 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.32 release.
> There are 957 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

6.18.33-rc1 builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or regressions 
found.

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
