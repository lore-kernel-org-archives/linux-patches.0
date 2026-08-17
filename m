Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4586837A834
	for <patches@lists.linux.dev>; Mon, 17 Aug 2026 17:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786989268; cv=none; b=qtNJR2P/hKKVjTU81YGhEU3yV0Yh1sOzXtQ3FF29DPaPHbqodBazeKMwowMIGJDW4kqvF8Qw8lyle5P3jgvb7kNFnTJ9hw0IWbsb0ZVmMDfeuGcDkb/uBAHQAWsPhQTFwXpmEQhlebZOKm01Vh6iiPZTdZCwKoyFDSgyZeGHWVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786989268; c=relaxed/simple;
	bh=pSS1C0QXGOvHzCVozAFUNIh3elOYnRYPfbOJE/uVnQs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ouwacikm4LwgKRCqCviJOt28X4Miklv6nzcm6aIEZxe4L47FFgIZHf56iehaKU+Ms8S2siJ5bFqqMj8++/9GysH7DlzHFKB1IdoorRpVI8SS0TbFm1ubMqKAO90NgXOpJGHmGlSHrcZM7cpreV+/N/pdtU0PYJQ4nlMdRLSM0Rg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=FztzN+Kv; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="FztzN+Kv"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-47fe2d179e2so2452249f8f.1
        for <patches@lists.linux.dev>; Mon, 17 Aug 2026 10:54:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1786989265; x=1787594065; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=z7Oo4riHRY2DosSl4t51IYrt9p2aq1oht2yaJ1ObPh0=;
        b=FztzN+Kvyz8MEXkpalwOuWczD4icDjkEJjRuPi8fjXjilQRvP7vMgIKOwO3/Dx221v
         7yg4oSgFACi74yIZ9QE3TNVgoHsn4KN0nq4r0+04pxvUhkxE++NurpUCUcXgghOANl0S
         wcR4/kLUWzaKgjAhhu7iQxNbMVMJ8ry5pEFAwGsx50C6oItbDE9HrWKnD2BBbo1KLLB0
         8u1rzJPsrPlPSWDh0xR3ron43MIsWAAYnjMA7Awu6HKGRaU6bSXj5whSM18zcPbW+6Xa
         b4ypb2ll4xfTI1fR8p2I44kBsGIJ5XGAQ7IjkSQWPmTJIja2hhQGz9MUXY0kF68lEsBW
         5x/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786989265; x=1787594065;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=z7Oo4riHRY2DosSl4t51IYrt9p2aq1oht2yaJ1ObPh0=;
        b=mzIZfsgaJOSN3IuMwHO+zeEeaz8vKd3EFBnZZagbQ4raoTuCZwkVgKnSv5Fg64Qsd7
         V0nqikH7pJ+BRtCjuVNZqeStQoZyaLpe+q9EzABrUvVI5Ejfh2s4bSUP1+gmvJSSLeXJ
         FmNz/mI11Igafva559mGERmeb0lhfx6t6fLOI3OkqCRTO2rHbBsL3EGB8qxTLX2EzOo7
         YN8fYyXt86UdP2EBtmEICVwizE35cgs0Wta6QafoJBqMIPxN/Pp3Q3Yxwhcymy265vka
         YSkVA+n+RC7oAbTKeWv/N0jC/BqetZmKAA56lIO8RoE543ZCSO3SrnS7cCj22joE9WW8
         Vlig==
X-Gm-Message-State: AOJu0YwVwC5/tzBoS1C2Yxy8omRhQ07tMiV2I1aQ/S4ovaDmkvO7ppxS
	1G2K6g7+cxo79MbiiPNbRaMHcG+c5Wo5r5Dl0DWIbfGVlfLw9YaNOfU=
X-Gm-Gg: AR+sD13DA9MwHKoOoVJLVY+3cEWnBdN2ACVquCjTC9uXJiRbxBmx2lSLucO7FHZDIrj
	CUbgnOJPK5bgRsE0HiOPVSx+WybmLB4OP1HJclm9tXbUAfb5FH4Tzj26PaTHdYI9wH36ayjwIf/
	mB9XKfEimW6s9JzKHVFTCKy9KIlzfcaCrR5NXI2l1l7sWtaGvZ4xi9fPKQsn7i2OdGwfomGbT+R
	84RmfnIIhe9CuBRup+aQIvEYD8bTVT/JcOjwwkF6w9s9hmRvynWTiZzI42NFcg8RD0ULvgQK1dt
	WZ/dYeDd0mF6KY5NhWuh/JhIRAsaMyQyXjnUm1R6FW9rdtwferq6ePcub2yiLtfnVa6d2OgC+7l
	JTmzD9RC+h9N0jDJPjkdaSPNKFbziasxxnveXQYK9L2d+3opKi654Fy5lfE5gO4bk6rGeIRnvJl
	3VfbBttcuDs4jcVs5+sJ2PNfn4cgKZHaxEZTZpClLwbraEabCIuTb3IDZj1Ql/DeHGC5otrYHZx
	ieoz/wXoBOTbKA5Lfjr4GoNIWggNdh3AwwuX0xsA+HE9Q==
X-Received: by 2002:a05:600c:3485:b0:499:8758:8cb4 with SMTP id 5b1f17b1804b1-49987935eecmr432943595e9.5.1786989265474;
        Mon, 17 Aug 2026 10:54:25 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b466b.dip0.t-ipconnect.de. [91.43.70.107])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4999d0fb867sm74590685e9.10.2026.08.17.10.54.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 10:54:25 -0700 (PDT)
Message-ID: <3424c224-a258-4d40-9a7e-9a9531de8791@googlemail.com>
Date: Mon, 17 Aug 2026 19:54:24 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/156] 6.6.152-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260817132534.666299318@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 17.08.2026 um 15:32 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.6.152 release.
> There are 156 patches in this series, all will be posted as a response
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
