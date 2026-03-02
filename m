Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7164E2DE717
	for <patches@lists.linux.dev>; Mon,  2 Mar 2026 17:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772474277; cv=none; b=HnFzl3jJfb/+bdnZ7K8GOmeGwu5qp6IqGDh1LsA/NE9t4Zber1eNXC0zr1YH1ctkcq2YKV2KivsOZcyOH86jbVrgJDDxFCfk5aZVqQlUpHkxf/X/PRBPvP20/CyiSduG3iWJNjXFBZPrvACXXA52VzL5rVFzs0SbY6/DkRrZ/a4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772474277; c=relaxed/simple;
	bh=Z70LngUR5BR/zw3bhe3+3VK271EfWXQXzkCckfVQqfQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YpO0xdYbYtaljlm8qLBqskMTVepAYEQ43eH5cbAVWMxcZwv4R82BwoE4SiUcDEdlmH2vVRMHyNQNPY9b9amD1tQiL/1+QcWrEL2bmPRsveem5mJVNOzz/7W2RjztyYZ5TBJbP7koUXdA5ZRuoMrC8WCcJiTVzRixHZeL12XLUlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=miSONd58; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="miSONd58"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4837584120eso34537645e9.1
        for <patches@lists.linux.dev>; Mon, 02 Mar 2026 09:57:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1772474275; x=1773079075; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2/CIADyXEE3wl+nWzZOQLBr0BrVFgY47ExHZeSHkKCQ=;
        b=miSONd58MvYywxY4TwPL0CcFnHlPYfSDuMJ6aEwdwLEXQgU3JDbyxo0rAoMB3cUxTg
         d34Zcx2pKmYUNQva6cRhuTIVbo3BRiNxg+GqaMqs4NNUqkb8hcQpp5jOgSkk//Saaul2
         Sl4p7odHm8DdPH2pNKNhoxor3Caw1e16NDQ7tqTvYX+zr9WZK/9/kG/TabV0X+CpBeIB
         tzT+0Ixks7jnuo43w+Ihtw1vH3m0gSRSmsVzwtUGPl4dDbnq0cES1F1kPShn3HYuFCHD
         IHIQW6uPwW6cbzSp1f7qYuRN0MuDOqHynMX91J4H2NgNtEts7m+r254JGG+T9G2U+AhE
         qfTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772474275; x=1773079075;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2/CIADyXEE3wl+nWzZOQLBr0BrVFgY47ExHZeSHkKCQ=;
        b=DNn74VqNKYDl5oXf3fsMft7laUoKS0jbEZ9oDG0irrJhWcAIPYNA4i8TGoIdBvZHKm
         dOU9/c3AogzjLeJGLqBV2sGD9hZaLKJJmQ3tJWKveJLxGi08qYQ6xb88ZDhAs3jJGonW
         R0873DQD9mW9hML+i7o+AzYP5M2D9D+B+kz3EClp9V0R3y1sSHhGyPs38K6reLmWFe2i
         tEc+J+yz/nabU4EEwyv50i5MP9uUEXbJq3kiUvwNoTG74pmhX82zyiWIiTg1XndFc7TD
         FCuEdLv6hCmua6xC4Pym2JOf6E58EtfBLFaPCaVUoZAKE4eJWvDVOC/p3E+xysMMJcvj
         8HMg==
X-Forwarded-Encrypted: i=1; AJvYcCW9Pz8wGY9tRtlRPxvrr6zowETWlAR5jZFvrGALESt+Fc4bjjLIKJy2ThlGctJ4Xwgrw8NoHuOD@lists.linux.dev
X-Gm-Message-State: AOJu0YwX7+nnjsBh9BdOrFjJ06upcXxi5/4P/eWIgXh+Ep8ovWGmrhJt
	ZzdYGlzuAd24ga6GhUvukj6cVDgg2fXYWowM7ft8p05k8p1p8gPs0NQ=
X-Gm-Gg: ATEYQzxzGZ5QttT7d+dSSI6shqPQbMt0SE+6FwQXsVlhKpmdNsZdfVBbmWybsTsEjyy
	PX2iQ+iF0rnj3nEtHhP2/jsTFZuPXncVQdaw0OBf2AD5qsJ8+Kh+EOqObcEB6+grAyKB2r4MbJS
	EljJ7ZF8jJxhlNghh4fug9fhErAauQOT/+PCuERU6w6x21LEpdLS5i3Q0Wx6BMaAgXRpx9atWO3
	saGFcao9ZFb//gW9VkZEF1MSxMh6tsqI2f5cVs9rm5JP9R3jkMe/31AzLPKhYMN8hAEYZTutz7j
	2dqepIlNCHqQDjyrGmZqh8JAuNy2JucJp47SlJpiRUM09Ar88IHPyU/BZjqau+wP7YtJX6Dckls
	NLlVDgU6kVpAq9xLFnEo5c2H5WkzoJhWHWJDtb3UWREBKlMvLGOvxENhOtiIt4Q1WXKKLqgyA1d
	tVXiaYT/p8ZCJmeBvPx+F4ubdgaAzjE4R0QLzKbvvWJCdeR4YTpa+lFO0mE9V/ZAEifVuXkdtgq
	bAVJM5oPSzJ
X-Received: by 2002:a05:600c:4f16:b0:483:1403:c47f with SMTP id 5b1f17b1804b1-483c9b942dfmr225314205e9.6.1772474274505;
        Mon, 02 Mar 2026 09:57:54 -0800 (PST)
Received: from [192.168.1.3] (p5b2b433d.dip0.t-ipconnect.de. [91.43.67.61])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-439abded86esm18412745f8f.6.2026.03.02.09.57.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Mar 2026 09:57:54 -0800 (PST)
Message-ID: <abe2fb5f-61b3-4597-b27b-c6c61f5efc7d@googlemail.com>
Date: Mon, 2 Mar 2026 18:57:53 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 000/533] 6.1.165-rc2 review
Content-Language: de-DE
To: Sasha Levin <sashal@kernel.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
 Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
 gregkh@linuxfoundation.org, patches@lists.linux.dev,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260302160943.2522184-1-sashal@kernel.org>
 <66461c13-1bb3-473c-b57f-adba9db4f756@googlemail.com> <aaXNiwFkUEy8SaTm@laps>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <aaXNiwFkUEy8SaTm@laps>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.03.2026 um 18:48 schrieb Sasha Levin:
[...]

> I'll drop it and push the -rc2 branch again for all affected kernels.
> 

Wouldn't it better to push a -rc3 branch then, so as to not create confusion? (I'm confused now... 🤔🙄)

Or did you actually mean rc3?

Also, the causing patch ("x86/kexec: add a sanity check on previous kernel's ima kexec buffer") is in all others 6.x.y 
-rc2s from today, so maybe Harshit should quickly check to which 6.x.y stable branches this patch was meant to be 
backported/included?


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
