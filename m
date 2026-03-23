Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C6A3BC689
	for <patches@lists.linux.dev>; Mon, 23 Mar 2026 19:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774294108; cv=none; b=mETibMjhkOcWlz22kEQgkKBgKUa0FXWV4BNqtNAx3J9+O37CbW03FxIsp9fKsuhM++0DUv4EUOo3d1zxcVhuCwNqGYF0Js48mNprWf3zPzk83ljwNMkNJPJvEWmmbpC+hK4d8vlYe8NNZrET2ZT4a77UbTxUrRA1orMsfhv+b0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774294108; c=relaxed/simple;
	bh=xJkPJYdDUmNvUwpMUL3/o1l6cJngLLwX2yIRH0OCIkM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AYZ0GovdDKXXYCL4YuxitM7+tmxJlafwjXd6/FH2SvHKga1UOwnIeRd6YSypnmZZKcrjyQvBMTVhIOoclvcqwRvPsoxXaJXGa2O4wBMxMHpOsNLMhs/v+HCitbvDrgcwiG9YnJeM8n2hNh+PV+Soj6M9lxY6AkbD+eKXoa8OhVM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=JEhs/bSA; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="JEhs/bSA"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-4852a9c6309so27811735e9.0
        for <patches@lists.linux.dev>; Mon, 23 Mar 2026 12:28:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1774294101; x=1774898901; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=/QjcEhhpVpHayU32njnxg8fd4KueGGWdq5rqYLKunqk=;
        b=JEhs/bSAoHX3IW/yhL8qbnO4aoIghfJvUk+a77jZOa0BpLqS2JPAsiFLrUi6tZK5Or
         xgl0EOt0LF3yLogEMEPGtRf0AzaDD9XXsOLwRCosafTanF8+NNKED3l/lDvdjj7J1/Q8
         IcXy6zTZoYjQrplNP2TttyVSyYxk29doYhdAOMVs413TNjqxTWA1MDygND4S7J0hwwCr
         h0fSWERsnU7tjUtrKI0YdmWH7wzPCmtk0DZJUGM/eQyEPoxg5dz4rbVsqGgk96NRMjNc
         4/JDUkmIQ5Wg+uMr4t3o0hbWFNrshPh7rQ2ZqN4V27qimq67S90Py8rJ1lgt4n+SkqLb
         0Gbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774294101; x=1774898901;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/QjcEhhpVpHayU32njnxg8fd4KueGGWdq5rqYLKunqk=;
        b=jZAYhtUQfmeXWal1vH4khQ0OatBirmZOYb1CDxCnnwdpLyLx7nHY54euYvq90LezcF
         UILUwYM4rbp753JRfGrma/zgaiWoJfVCBvoc1rjN1aN6Jpv7YLk5LXnu5BCJ+GydgCyA
         3ifaiyl/BYCRrPqHukQK4NGe+r+leehLn7xgIIL7ttbBL+2e/xRTXV2u3XX05WVczMCo
         doJ3c+92Ud26JbF0fiIlXG3yoSKk7M4c7HlXfn99XiEYFGU0TOII3D08DyJKW+5aJNdk
         IVZW/HHyrflFcnJ69Jvsml0hNwmEH3Q1s4NLu6mCuOmmOpRxSBdBHYMLt4KVl3Z3WC8Z
         kj7Q==
X-Gm-Message-State: AOJu0YynOpi8nJ+nIuyiJhlgJPqUtrp9JTI9+DrEVSZaa0ss76ZwLxyR
	FyPXP4GSa73qAVF6rStlhHn7YeVVIGGftzIpBjhFck+k9BDZrG4W/hQ=
X-Gm-Gg: ATEYQzy0x5TGqsorNoehLTj4XEyuzHUOGGhqEFOzq8yjeY71EjQzejg20tHzFsvJ4h9
	46JWbJKlEWmD3WN+ae71A80XSVTvqnB5fyIxcAXzJA8V2OPcQnpqwUaQzMsMiBcCyU0xTMcBhYO
	RBjMRa/ta+0O2YIUjoA/B2bhpLpclH7xsMc0K39PDfaH8+ZTUEyCRIMWY7wfN3tDY504f+33qLY
	8AgLSWqpAKnHEWexb8hIQYG0DI1oRyKC4GmS82glZ/jHW1YuYikmsBwmH5l9WEiWWpIldLqcnOI
	YLAafzfv9XhzoSsTr8OBVw1KPT2xhe2BV4nSp1jDzCNSiFEZLK5IisuDrsdqow5awk7rZr1g52W
	xPl16VZAd8J6KPpGRTsIsFgG4C9XNCt8xg/sgfZ4ZH0vef1msCB1iKbSDsp7potgC+7tbLwgqZ9
	wu/7k52cVhiNTzrjv4tyy73N/9zVOBwog7PgQf1O1eHStuZYWz9dQB3pw/PSF6ST0cLhB+X6qFA
	w==
X-Received: by 2002:a05:600c:4e8e:b0:485:f1d1:8f29 with SMTP id 5b1f17b1804b1-486fedaae27mr182451855e9.2.1774294101272;
        Mon, 23 Mar 2026 12:28:21 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b444d.dip0.t-ipconnect.de. [91.43.68.77])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-48700658441sm416491825e9.4.2026.03.23.12.28.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 23 Mar 2026 12:28:20 -0700 (PDT)
Message-ID: <44c8f132-cbb5-4178-bdcc-b9368fb88817@googlemail.com>
Date: Mon, 23 Mar 2026 20:28:20 +0100
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.19 000/220] 6.19.10-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260323134504.575022936@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260323134504.575022936@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 23.03.2026 um 14:42 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.19.10 release.
> There are 220 patches in this series, all will be posted as a response
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
