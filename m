Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B81B3C465
	for <patches@lists.linux.dev>; Sun,  1 Mar 2026 00:49:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772326147; cv=none; b=nKCrZ27ba8f1dNdmIz6BmEJ3TagAaNRg6F2zausnGJ9wGqz4IV9qQoFx/duH3qHDAeFZlQiH/+zK4iAXMhTUSz8bjQf6sS5+/IUoVksehqplslenIyYkC7iiifrQaAZF2bf40WqzcpnuxANFC7jCXbqjQN5IsmTkozFtcQOor1s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772326147; c=relaxed/simple;
	bh=gGF+Y3A9tvAcyE8F9j+7Z3qPg7Yl0etmcQm8MW7MKbg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u0reYrY/Ux8iGY+bhJLdsl7axndovtkJWthAJhwHz/EKUQvl3Z2fw5u5OJuVpWMS17OCxHx3o7JA/g1vjKSh1+J1q1InIOjelJssLdz3B30Lp0lVBiDH40/r1NYkbNKSbpYyR+uhhCYsbUMkBFNZd/Jlux46WsWZ2aOVSHCl/EQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=LXe17Abz; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="LXe17Abz"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4836f4cbe0bso27313095e9.3
        for <patches@lists.linux.dev>; Sat, 28 Feb 2026 16:49:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1772326144; x=1772930944; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kbH+hGxj1Ii6TXn5+5SaVTYOgraNE2wqGnKW4iCopuo=;
        b=LXe17AbzlVRNygd12OL0CV2fFO1rWLxP9tqAbAZvmxVS5XdLTsY1hYVzg6bRB0Q9/l
         x3Mu2QlK+Vdq7j3SdtzHy6tvxG49cUSbYU/xXGfep2P1DrI0UO3fVmdRZItuvweb7RPb
         5SNklmsY7b5G7Lj8tuJTuJBbcdbgjdWp3XhRc5c/en8vRf3kDDDCWzyf7H6QMErJM2rZ
         Gb5OqC6EldRcCTrTH0Sx8zdFs29W4xqaWAPl9xJ/Jj7jA756ki2BEoqW/+h5EdqPq5Fk
         ZDfPWNvYYL8DZHsphnv8P1V8kolil2ThfWgLWQF8Sn9l6yE/jYc1p7Slzwx9iZl1NYUg
         eU4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772326144; x=1772930944;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=kbH+hGxj1Ii6TXn5+5SaVTYOgraNE2wqGnKW4iCopuo=;
        b=wRY5AX2PbIPB02BimbhUukKNVR0UkLeKXPvw0OsYk7dbXN7W5jihu4Md4EGV5F5zOa
         IMMJ/HI7/tenI2L0aA2764JCgGBddFvlUnLkm9JWrrvsGfXyE8iQdXl/5j3Kn+ZjWoGG
         25jnqEORjQ1pOcs3EYk60PcIUMGac6Go2efm3WMyv82XocXQduWEkWS/16GG+iILIm9T
         p94fOnav/fRopo7L0aVRZslOPtGPUzPUlhrKaMG2pjLPIupYhnpBJvzxwGWLGJ4bLE+n
         i3NlqDoYSc7wECTYPqb4/b4y1YNKd/dobw4Q93f85h4lBUI/+u/JHzfz1ncjvhA+EkXl
         V2ag==
X-Forwarded-Encrypted: i=1; AJvYcCWQ4rHg3V+r/QmCrgJtVz9DGmC8cP6JhTZ5ny+8WB7eN/lLBLkhOrdB80wVjZO3U5sRl3jFNWTQ@lists.linux.dev
X-Gm-Message-State: AOJu0YwC6ySCxt3HyJ463oQv2JASaN5kj77pvUZiy4c+nY7GGF4Kxpp7
	AAkHj7bUCXf3Y5Kf8wAZ5ZpLI2j1CIcWhhtr0HDSqKXE7lSf4n/FDNc=
X-Gm-Gg: ATEYQzxJDYLKnSbhwy6dEDu1epNdQvy+8O/udo27o8HC2be0yixu0GyEAMeQd3kkUl0
	Nd4yuM82U8uUDpJBVKfgTLFULeoz+LVepEldcZstYlfWu4hOE4CLo+vDGZaMRgt20wiytOy9YvL
	ybIUb2MPmb8B/7wUgkK30PztkEhPi3iWuv8nEMCCOsKz75Y2y1VxrSlovfRIa9zSrQz2nUnQ05O
	zeRzBnIMmFmT6gjKLcxOiSIc56OzAYAFN/4QHLqSr2GQHMgePNl4BRrrzu70KPGcAeEjle3fL8t
	dEI6yJGYiDw+sy74qLx6lhM++NQM8DJRmIKfs3W53GOylzk6c5DXVxJS3mU9/HmVMLBV9q1Iqyl
	v/K9uH4DgAJYloX3r5I8J/gVhMiWwX+hbHC1yz4P9A5wT15F6C9RmokZTt4cwBNalliwzySIlYn
	mw1vAOtUQLWwQtOSmlV5atoTObdNMa0sB0HTnQfpBBBLz0VZwsMpIwSaNi6hfgFskTC9utndmNJ
	IjT
X-Received: by 2002:a05:600c:1f06:b0:483:7783:5382 with SMTP id 5b1f17b1804b1-483c9bf49afmr117867585e9.27.1772326144342;
        Sat, 28 Feb 2026 16:49:04 -0800 (PST)
Received: from [192.168.1.3] (p5b2acadf.dip0.t-ipconnect.de. [91.42.202.223])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4399c60f8e5sm19400285f8f.4.2026.02.28.16.49.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 28 Feb 2026 16:49:03 -0800 (PST)
Message-ID: <e1b6cc96-5b8a-4256-8deb-6cfcde4e10c3@googlemail.com>
Date: Sun, 1 Mar 2026 01:49:01 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.6 000/283] 6.6.128-rc1 review
Content-Language: de-DE
To: Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
Cc: gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260228180659.1583364-1-sashal@kernel.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260228180659.1583364-1-sashal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 28.02.2026 um 19:06 schrieb Sasha Levin:
> 
> This is the start of the stable review cycle for the 6.6.128 release.
> There are 283 patches in this series, all will be posted as a response
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
