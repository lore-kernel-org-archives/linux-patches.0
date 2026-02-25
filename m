Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639993D905A
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 18:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772044082; cv=none; b=BAq5lG6/RSKPrTAHA92fMzMO8nUXMsSxgXF2uMAQY3Tlww02lZqxDS01xIJtagkyWNVBxskIsPhW8nQ6wC5iTXRQ3j8hv0+3U3j7BmM4k+Jxn3dgMhsL1NCIXxXav1INazjO0yFiGOxGSXReiHswOllQNygttiZJq/AzolmNRPU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772044082; c=relaxed/simple;
	bh=9tVVzABrfYESXRiAqx4OP6+dcVZfUlVvgVSA0Y+C6cw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oH+WOLVysM+AK+zZuL0YqsmNuIuLD0ZXdV2OJ52iAWBHpiyqVsvdL9Sa3jw5zBFm0zLHjTw+Of1K+4J8rIA2QXwtFxbFgm4BBxin8LjHcw0peF7UKPzgAzNuMSDGX7GeLLbvc7Y5mWa0h1yWEYPZ3sg8TI4xGptuJiiITSEyOro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=XtKx8gW3; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="XtKx8gW3"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4837907f535so679925e9.3
        for <patches@lists.linux.dev>; Wed, 25 Feb 2026 10:28:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1772044080; x=1772648880; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Hd5W4hkBAFqLmz9UiLeJS3I2LCVeFB09bmE9bveO4Gk=;
        b=XtKx8gW30yyITG9enBoznoupC6ZbFYWXsxWa4jcWk6BYC2xXV/AN/Oce1ak+nzwVIZ
         r03D6Q+Zj7cxWWrMiCNi+9Jf3w4bD7OzSeVMSub2zj/iY8QHQDAt75VqASChDcgAFYWq
         rVidYhZy/PeTfUX30rkNBQKj5tAeeBerxYOiNiQd6M2jnA1+NCwTHtwtD1EOA4KB5D3S
         QYR0/iJ2LTimsBQS4hKuJ5jUYkamoFOKPoAHzDPgyFYUlSJebQ2t4GGiahoY2MGtXooo
         x2ZLKniVS4Gi1RvuEpPcFE36kCHUf0XcdhfLsFTBYPIoDdTu4Hh6pt9mHt4zR5fNLrSj
         7Rag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772044080; x=1772648880;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Hd5W4hkBAFqLmz9UiLeJS3I2LCVeFB09bmE9bveO4Gk=;
        b=mawa+FdIqJEKn0AlDXml5dN6/qy6eoIUjpo0g4h5RdHfF72VfpHfdw+LzR98OQMwh7
         QAulYvEDiJlRUrS8Xr+mvTRqEbjeca+0RBeaOIjtabDXjNS0lR7kRY+hraKiG+a8wnop
         /tYoulaH1I8AtwFVyqFV9wln4TUxqnzQ9aUuhbI1CroizV9VEFe2188ae4J6D+tk7usX
         ozOoQYYh5bANMG0CyCCtZnxxgLhR/63s4Zmyv8jrIHvhslIp2BXop0MVQA/H8t7u9YHZ
         Hzd5kh20ZYdLgenxglE3SloaIB/r0z2rCgicRY/Soz9fhh8tTg4uZGG7TYD61tOsPFRv
         CB6w==
X-Gm-Message-State: AOJu0YzZSXxBbyfKjC1cgyC3/67hW5hiEZXcgXG6osn5eKYwZ/9pVJ5B
	ty8RrTa2N2NTpAWNKh2D6QogXPu5eYQq+0d+nlTOacYUx+qq/3F5ID0=
X-Gm-Gg: ATEYQzyh19Khb7UKb40QsMBv9aeWXzKzIkGty1JB54IJwubWk3wEcVepY7WWezlqUXB
	DYWWNknBbktWKZmpat1JasEc5CuZILmjlGKH7Ec8LVPjlnLMaC3MOj1IEgTV1qU+iHl8lZ+ENE9
	ovrlPFmu3vtcIb6zuLxHoE4sslpKvuLBgbjYUhhAQaOLhtYBmQ26Cv0Hx7oJxrdJ6VL5PTKQkCz
	elaf3KmBEZcTbp/gRd2OgNkKZA8U/VASFeSkNwwAqIZMFTmE+7g6vGqUKnwU6t3gkSBVPMhT85C
	1qtVl+/BhSXoE0FU87KR8s61RKL3kHcFLon+NnYd3rStRBxBlqEPiLpVe7U2jh5er5JWIiv8pdJ
	yMG8hbdDqWYspEMg4guCs26FnY3lkGoJCxXvElO3aDkiJMwl9G55Wvd4yOwBZDxaBEUzQMtwzXB
	L42A09tjd9LMSe/cFHSfHeNVdOz8IK8oJF9HyFl2JUBHfp8snDO8PA61g0f+OvdTmmiTifhUEbe
	4M=
X-Received: by 2002:a05:600c:83ce:b0:477:7b16:5f9f with SMTP id 5b1f17b1804b1-483c21a9ab7mr25059665e9.31.1772044079551;
        Wed, 25 Feb 2026 10:27:59 -0800 (PST)
Received: from [192.168.1.3] (p5b2b47ea.dip0.t-ipconnect.de. [91.43.71.234])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-483bd6f2f88sm87884625e9.2.2026.02.25.10.27.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 10:27:59 -0800 (PST)
Message-ID: <f3aaf329-6884-455a-9f52-16d98f0db4a9@googlemail.com>
Date: Wed, 25 Feb 2026 19:27:58 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260225155341.094945851@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260225155341.094945851@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.02.2026 um 16:54 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.19.4 release.
> There are 781 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or 
regressions found.

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
