Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA31258CD7
	for <patches@lists.linux.dev>; Tue, 11 Nov 2025 17:12:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762881171; cv=none; b=KqAExzG6FhJXZdIrpj5XQRcuD3dojwzfnHToAPY+fJ4Dr+doKNQfqD5deBGjB1U6elUrq/jd99UN6GPPqHglWKvKPgEixPJbd/jr2h/Vvvx0IaCuWxmTbdALfh3pRfEzDJu6OCGHkO/fOji1eG9yMPPSvSSdXh0+g34mJk6eDHc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762881171; c=relaxed/simple;
	bh=NhtdUKojR8AS0bdaC+QuH+e6fwl3THaYmzRDwTgiWLI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=h1V63XdDCtCTqlW/sv10NxVSY9IdIWEzh7f/R34XfmIen5j+7SdKOj70HmyRSx/04RpQ8MQ8Xpkz03/fFVhezLJYkr9ljLHYLLD3oywUhjDpflucl3EJYgZw9jqvSOkKG+QyanpDbygI1vaPxOlGdSR4p89mOPZUv1NjsGnwnOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=PqYcSEsa; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="PqYcSEsa"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-4775e891b5eso22724335e9.2
        for <patches@lists.linux.dev>; Tue, 11 Nov 2025 09:12:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1762881168; x=1763485968; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wqZC9RRTjweuAlm02YPfwCHcdnGqj2UDL6R/JHOFHK0=;
        b=PqYcSEsaE0g+PtarcznmJNkMtOqYqjfuiYw2JFfZlT2cDe172/zyAyZ5b7DtIq0eSc
         zxZaT0EMh29fjIKN2D6H+u7KIexPRT8VsXqXaW4hZLaSUCjE/CA+WDHOoADpIWznD7PG
         aD4chrUrxxzXEpuYNTBpM+KpE0wTTeILiumgavTob/oh5F3ivXXaOMOX4eFDFwQhW576
         N0QmREyC8ySCjSldheeg0fmfAUUkyfTjo8GV3xAUR6LPc95hiH8sIXzKYtsnp4Z+VZJ2
         X8V0oHDltXk5RxBX8MZr1uNvuJ4TjnntghostpPe6R01OGzQ3qJUq9Aud8YYxFYhdM4r
         0ESw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762881168; x=1763485968;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wqZC9RRTjweuAlm02YPfwCHcdnGqj2UDL6R/JHOFHK0=;
        b=CJr8Iss3rjEoJjZjopKBMBwqanxuc8/2CsQOBgBsOr+sil0mmz7fr7NHkYN2Z9jw/w
         rPUnYwNX1zJTexnBpxNjJ0PyQZjSgvdR92MtTrYyFPqKHngaUDmpDiNor4oMafpLVCR4
         L19JQBF2EQeIC/kVqS9ZiAHptjLB0/yXUeqxJoi4/XQjbc+ObqL8Pm8NSWwxJxMUjInN
         UL+WpvFZAIarPNTughjjcpLKaLMKnutxdIBerJKz41cZT1ylq4vnUPjvO9ibcDYAt7wD
         bZpCr+zpM3CdW6PDmm8vRDNRTDmhWfJysiJJ9YfU4dUiJkwNQaNpkLIJx2gLSnRByge7
         jn4g==
X-Gm-Message-State: AOJu0YwsAISW+AyrIHTBsHfoS6a12/DD0TkyiJQRqal/Y4gkePZRYRan
	GD46NNm1A69KLDkELudrkfp/S90F6Ub0LW/YZSQI/7GfKKydhLHUWKs=
X-Gm-Gg: ASbGnctGgB1A6/jS1rNXRKr/AscxWikMH+Y+B2YQXItnVCmIiOGDkwuJEhfy8rP57Gf
	CgtSwZuZLCSOSvsNr75TbVapCrQwfBMUKBnxzwCouMxTXAl+yunyaLtWeL3e1reC3cH/4ojCJy7
	M5yaBF67k0OZVJGS3p8vKwlrIBrR+zHPovpkagwgA4QQVrX7WMDkssdyzxXWUuYuNHzGdHRiCF1
	CXiiklFIj6zjcs/8ExYUEGvHo9yfpsrJ9GWiD+Covrc6H3Rc+0Se9/KuwkkflkRzBmCPXaWmsMF
	uLfS/jJKkPXvm+PcKoJMmxZtVJCvV+AgL2me0WYeqEpSm7JDxMdoBQi7ya+5Wl4t3+Lospj+oIg
	EWBD8WaubNkSamiobM4rBxLmeyGQnIEfGXtpssPeSfb25yGVa5TCo94h00F8jX7/7Yu5QbMparO
	6vRUj1TSM05KZotmE3WPydR3gKo2ycVvOR4a4wnIdkmLBwZrj85i1EHe2xl3I9pw0=
X-Google-Smtp-Source: AGHT+IGJMVlZIgx3+f1AZy+dlKlifd63oezYeoPNJGyyFGVGoS5RoptzE35LCIuQes2+JmdBcEqtGw==
X-Received: by 2002:a05:600c:4594:b0:477:7b16:5f88 with SMTP id 5b1f17b1804b1-477870623f5mr1540535e9.6.1762881167658;
        Tue, 11 Nov 2025 09:12:47 -0800 (PST)
Received: from [192.168.1.3] (p5b2b46e7.dip0.t-ipconnect.de. [91.43.70.231])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-477815eeb55sm25584185e9.0.2025.11.11.09.12.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Nov 2025 09:12:47 -0800 (PST)
Message-ID: <9db2ecf0-ee3e-4c10-bb4b-1cf02c9ab8e2@googlemail.com>
Date: Tue, 11 Nov 2025 18:12:46 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.17 000/849] 6.17.8-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20251111004536.460310036@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 11.11.2025 um 01:32 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.17.8 release.
> There are 849 patches in this series, all will be posted as a response
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
