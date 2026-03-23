Received: from mail-wr1-f54.google.com (mail-wr1-f54.google.com [209.85.221.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FC2B26C3BD
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 16:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774283979; cv=none; b=O0QqUds142bWvLZnqSvY3U5TFsH/cCceCpR4f/lAgTd4mXrn3KDbc3seVIPHveNp8MlTVTlAQf3njjZGDZ2Bm2fhSZBtSTVsmPGevjrDisZEG2I1s+9T4TNuDNNUqzYyLqeVAH7lc3L1VE0m+DVnVErNGumm1ZfxIu4QQfr+9vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774283979; c=relaxed/simple;
	bh=hpomdIyEmcLoNEW+bhzA7cXmRz2UPLKT5/32f1yhUgY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=F4Yk3XCOmC3UdB2490w+8lcyxXORlvUu5Ybx4kTB6ACsBQlgXBE5nigEVJp38WLk5o7c8fK9xg468V2CAN1S/SnN/iX1ClYtmeniJtHmFf5VMK3jDECDfU9lRQTP+3yco+4Tbt9kIO70Ez0VwSUeeQb/rYOQaHqCT75M0h9joqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=GlSXTSBt; arc=none smtp.client-ip=209.85.221.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="GlSXTSBt"
Received: by mail-wr1-f54.google.com with SMTP id ffacd0b85a97d-43b40003d13so2711486f8f.2
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 09:39:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1774283976; x=1774888776; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=U5Zcfh2OwyV8FCOamDdeLKjIsk6HQadA+491pqNHkzk=;
        b=GlSXTSBtcePGL+A0Vq5ullC6vxtJ/YplMoumUfZlrgTfRTs0yZkGMzGkcJK3aneWDz
         9n1MnOE28NjscMCVql94PzxhMPxrffgmgPpOYeHCJQWSBo7Vin2EliBwCkinlFSkaL+Y
         XBuCmnQNp+G9T5xQPQcgjPFZzFz9ut5Vyd8FTQdz9gacr+mEy7cCSBKxxigHC7ZKIGl7
         gu5HDNyYQXpA1r5CF3p0P7cBrBywvyaFfuQAQGEaPgaTcM0uKdIHrCq3OT/l3KKFEGRF
         Mn3AoP0A9WK9vKj2C9sD925e0yV+9PGJEqSaW4UVrar9xCSLkQ6Yob2HX47XQt+oNrzn
         6lGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774283976; x=1774888776;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U5Zcfh2OwyV8FCOamDdeLKjIsk6HQadA+491pqNHkzk=;
        b=hjFvJ0WbhW4bNMCRayIggqY2TSSkjnQueiGG8w1HhQVp2DZIAJuJabx89fmZFVVPs4
         jiMaPywPz8UK9bVERg+n42yK5JZrPlL9AvIbUoh0Xdsxw4c1/hSJIF8wO2ifDCGX5Yvv
         UZ4OEN6BxftFiCwZQHNCrVjPJM5viXMrZgJIdWy4ASvC3bkKK8Z/E4Ah2fmAqFlS2U7x
         qSJpsma8Rf1x7QMCU2XHwOJEgyZhcOGlx3eiiE+20mGsp+HanU1fg8Dm2XG/ts4mm3Se
         h41vUw6QW//DRAHQQ3kLIkKdtj4ijc8MKU9J8mxEPlGY/+m/OIcSbGt6CcBsLT+8Chsz
         jkvg==
X-Gm-Message-State: AOJu0YzTAYiHROjGH7wYcEceYvJ83ln6k2I8oGLSzDwG4Q8sjzxGe6lj
	PQ6tescsqrEILDy/pAoyWU3BdB9EVoyvdA7gQWCPD1SxYgkPA1ZmOKw=
X-Gm-Gg: ATEYQzy0mMwoHhrYyKPtveNsVe0PAqAS3YGX2iNSxdF3QxD7KiEPOqlcdDpyhW+Jd+3
	s74A+l0OcA4P11xUgJtD1bnKIxi6eVX325bPpOZfbd3EK5+x90alKd5jATYqa8vwiq8g+rsGPdi
	nLWEm45Ihl+051HFYMP+KzksSAEkZpwCFZ/KCHxtTuppmnu6jcNPyBRX7n9XS9OH+ZlejpBunh3
	NvhHc43OdIB1Cq8YpiZtD4eWC83QOW/h9zf3VOyP+rD9FdONJbSjz4cQy2PQPheGWCL5BzVnGAB
	Zh+0Z1+4XltCj7sgtVZ8mPLIx3yvcSjUCoYH7vsQfMRnou6CmGVOKS0JTQYVvN4PqjZDwWqyabK
	Vr61yAVrJqPWINjuHe8Qi7iYHgxW+U/ijF7E5DaN7yZRC6AOaEAup8TxLt69TM1bCuk3tjKIPlz
	RVKxMh4d4gVaBH6snJPsFzMOq+Yy65yU/J0Qk8LCuTAkUSj6tLyS+jVvUrDzqmPhm02sTj1KZNJ
	A==
X-Received: by 2002:a05:6000:290d:b0:43b:4757:cc5 with SMTP id ffacd0b85a97d-43b6424bae2mr20507702f8f.19.1774283975494;
        Mon, 23 Mar 2026 09:39:35 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b444d.dip0.t-ipconnect.de. [91.43.68.77])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43b64714e2esm33046860f8f.32.2026.03.23.09.39.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 09:39:35 -0700 (PDT)
Message-ID: <d3bc6886-012c-439f-a5d4-82f2d67f41cc@googlemail.com>
Date: Mon, 23 Mar 2026 17:39:33 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/481] 6.1.167-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260323134525.256603107@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260323134525.256603107@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.03.2026 um 14:39 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.167 release.
> There are 481 patches in this series, all will be posted as a response
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
