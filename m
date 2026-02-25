Received: from mail-wr1-f52.google.com (mail-wr1-f52.google.com [209.85.221.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD93B3D9051
	for <patches@lists.linux.dev>; Wed, 25 Feb 2026 15:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772033919; cv=none; b=qpAxKM4lwkrR+NClJwqP/NNbPkaLcQ3nrmh5b0e7m0J7ac/mk4YPCjCQBfI+YD0wU7fxhy7/dNMf7AE9XPB4UDGYhjvQIGZxQFcrpNU/3C92hUymf59yP3O/eHyd3h1RdaRf8/cHGUR6w24KpeQdNR7rgxbsVVj1ZGNPMqoxjIo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772033919; c=relaxed/simple;
	bh=lwA1dAaZa5R/4FI3CQlKfYG8RBjmQqFghd6x3qOPE3U=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tjrUTu+ivBvX8iRga5O2CeP5lhYLe3Hfj6Ss72cK5JcOKznQcKCyFroQ/ZeXnEhfZs39u9Y/wPOp2pt6k1cwjc5uKAAJ4EQrPT/zDCbda+9btU6/ZAzLtP8z0Zc2Fm8jBa5NCmPzaRW3XqbKsZvS6UOvTdtQLFoXdLifeVQctHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=lkINs8nn; arc=none smtp.client-ip=209.85.221.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="lkINs8nn"
Received: by mail-wr1-f52.google.com with SMTP id ffacd0b85a97d-436e87589e8so6579622f8f.3
        for <patches@lists.linux.dev>; Wed, 25 Feb 2026 07:38:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1772033916; x=1772638716; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=R47EnWn3QFF72N0L20NhKvIfYZosIMpJW4OqVso6fwc=;
        b=lkINs8nnMMtT4w2PVUg/qPd73EHK2QWP0HVgvr0vEPP6ESP6RO7Epazalc0LWuCKF9
         7uNrWPiZor0oKywz3UppS5M8CYz5WI2EXK+GprBO74zYuHNGA90O377Pw4hQgOS/18FI
         6kBlCzi9C1rVdKuD9GUqCHzvx4hndYr3rHYybTzD330RtTd4gMb+Fz56+7rBP5nlifGN
         V8673gHWIyULFGQgdchsE7hJ7NbjdCrqt1AFdtMaXapYnkg/NY0wm/195qFbSx9DwMIW
         M3zwSmnupR50YRit5LNyC+JDJKMDyooeKZat4P/2ZtK/T02mVZMaWvJNOasA0vD0YVVR
         NzJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772033916; x=1772638716;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=R47EnWn3QFF72N0L20NhKvIfYZosIMpJW4OqVso6fwc=;
        b=ALZBb8fQ2rfBS4LB1Lckq3pZWgtcMXFjIQt2p3VhiGRROmQiWYLzg7dHuvonLRHhB6
         Gjz9y503oIR2eZQTwlUIr/0fNpVn9kWlaka91yB9qSUwtOMrrl8QwHGGNpaDgU6YY5gA
         gkt+Jr+l5UUkElM9ZLR8MCc/iI5al27lhCPArTWLWLQH8NTtBIpIyqf3qmxB171HDrgQ
         xGOrCXX+QAWwou74cs6JfW/x7EpKsS0/18UAdm7owOpURqgfB5YVQzTF6K8fS1W9a1zJ
         JPSKdbXaWZZ1yTYO8STRWIqw/ACXIIzAJEkxzmtU57+tXOqLihVx3mhn+9/xzdRXa0/R
         qDNg==
X-Gm-Message-State: AOJu0YyJmfZt/nh0A4Ahml3zquSPAw+SkOXDcynHsCzJ5SnpTO+/rF25
	jEwnl/+bNhIOOERksHX4BtAqrHknMu5WXN2LWkZoVkgPx8Jqbv9/0bo=
X-Gm-Gg: ATEYQzxppiSMQclXrHRhB3xOizse29NwIF1W7uO/AsMf5OeACgWQ8coNDYaRAnxgKHS
	HEGN7vX7jiUYluZ2riH35EI0auWGN+7ZNyN+PbDZTDUkeG/sYfVgyJ4ewlKfec6K4ozKyHR6Y03
	Vn9yR31zP5RyBrQPSZV5u5UllZDOXOjcthjmHAdu1Kc1Dcc+xFMPTNp4zx10v5ESijl4D344PHn
	f4LVOdnx3r9xm8ENRsaa8jchRwk5psCYQ7KkuH1zxY/vKfEyQHWNHyXvY1e066j2KfCGt5v/mTX
	OWKCleJ85f77tH5xYhXaaS4ZDBPBHc3m16EXMKDyCxCLNWi6zmyoyRL/pZ3ZgXiHNbRqPxWVcdw
	OYfYW01197TUR3GR7VD1YhXv/N6k6nmRV9FUHozLuAxpS8I/m3zXHFi/7Eqj6xudxqhJ8wnRuh9
	lZuB1myTG4yFzKShWndnx3bSCGCLxx4WxQWeAnDuRi5fT8VJndFBBWjzjtwv/yA7mvKBk0gS33b
	9Q=
X-Received: by 2002:a05:6000:2410:b0:439:9015:a96c with SMTP id ffacd0b85a97d-4399015ab62mr4568471f8f.35.1772033916099;
        Wed, 25 Feb 2026 07:38:36 -0800 (PST)
Received: from [192.168.1.3] (p5b2b47ea.dip0.t-ipconnect.de. [91.43.71.234])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-43970d3ff6dsm36540108f8f.25.2026.02.25.07.38.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Feb 2026 07:38:35 -0800 (PST)
Message-ID: <1f1bbab1-b67c-4a5d-a88b-2c9b9f0970a2@googlemail.com>
Date: Wed, 25 Feb 2026 16:38:34 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.19 000/781] 6.19.4-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260225012359.695468795@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 25.02.2026 um 02:11 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.19.4 release.
> There are 781 patches in this series, all will be posted as a response
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
