Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8494A28C84A
	for <patches@lists.linux.dev>; Tue, 13 May 2025 11:39:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747136391; cv=none; b=Ipjlh4bP/bsAfogngvI4QBAiDZpk7iGW8WVHHaAm9ft0b4r1VHi4Xrk1eU/NjfG7uZg02sJlmFtqKcleRMUK7efxWfCx/yLI24TpzcQjhu7vpu4AkOV4HKk3aCqnbq2nDHYhbTJuGafERKiUREPVq1qetBPKp+AgHNv8ts2GJZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747136391; c=relaxed/simple;
	bh=kNT8fQ1sCfHXSprcogGJmSSqrboRbv5c9tc4C1sfofc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=HoRBys3brEKoRmvG+xky+vgz2EeTiqtvDGY2ltP2MhBkFILOSj8XR/0NCgjA8bkCwdtcZtbZl0gJBDl8AP6DhRTytMfAwHQ4x9HcwBEDtkKo93hbM0T6UQw2PtZ/ncjk/DkeloPoGf9tbNADSG6/BCfMLsVjpHx/3+1Y2qf64ZM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=CGLgVIIx; arc=none smtp.client-ip=209.85.221.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="CGLgVIIx"
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3a064a3e143so3154991f8f.3
        for <patches@lists.linux.dev>; Tue, 13 May 2025 04:39:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1747136388; x=1747741188; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kaFnDrgYgykdtxL/lmy+IZqOZa2/HPvZV0a+ILjXC1c=;
        b=CGLgVIIxl0SZi8FeYNnU5JsXE7C3SpyohBd2ykg0fS1JwcvWw6uarXaG5QvXpYh5PA
         T50bCHkYdr/mZClx2Q9SggyuIM3HYA7v9xTjHH2yYNIJWhPoTD+Nr7KnmGWPYdVmiSzZ
         kMksbScKpdpHMkjYYADa0u1AgPJvFIwg5mzaCLIl+e/AQerM9qpAznxEP9bgb0IyAntE
         vORH1ZXhpqwNYaTKZgIdX8Ez1JBeAg4F5K/xNp40waHhWE4yNpZT5A2VQKzzeSm/5Hr0
         QAbc4sAJcG+n/0XZmKF1VgyHOCU+OsqnqXHI6kewTpYZaDZyuvufiC6nzr5Ja39dZWE8
         7lPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1747136388; x=1747741188;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=kaFnDrgYgykdtxL/lmy+IZqOZa2/HPvZV0a+ILjXC1c=;
        b=o2uxqBkm0zUVKcDUXWP7yrksl+FyZOG1/0+9nDPEQnvZqDkaj7xbU/RRT4xK3JS5v6
         QlrSnPOXToButOf/EwAJMDwVI/OkLVgsAcy3cZXRi4mvcI4ZVj8TJiGDIjx1g2Mmx0dm
         0UDvUSjVllzmnPjNBiV7Q8xOJBZEBciKqkzp1NqJwJJxchh0FeBgu8Ry/OFlVVow7FmI
         kHudboPOZ09+hn4KWTed9mwVCBCZ1gmp6iCBv2v0OqGv7b1UMw7tDMSanVRTSaudI9eT
         RgXJy95bGnC4xY6WwhcZ4yguNJcgf53bBhxVg0fcyucZSkc/VRzfoTt4nvACYlCreh8r
         Zbug==
X-Gm-Message-State: AOJu0Yw7YcJFbKfhFxVo9qWUZYemb1I3ZFpdLkf8wnvVnlIFF6/7oAKV
	immizlMPT4GU04671lm1bPd67/3gsyomCfWdYRq7KTSxsUQrA7s=
X-Gm-Gg: ASbGncsGxebxELOO0T7wofKfk7js8CxwQpmX32aFuP+EGG2ojPddnswOV5iTxa9LpWb
	tF5hoHJAkXNHNY4uv5rybPfre9bO3mqxsgJxgdXHmlUq6XOyrltTt0FVMcOHk6pCHBEU1LetQtH
	R3ChqmHEsNMfLKlFuLWJ0iAgGpYPGn6QPkg1FMPX/wgL2Kpdem8ts1rREEzZE41FMREXlWBgEzQ
	fNj8mLgRnUvJPW6NEgzGJQx2HH92OaXIx6UyJge5GjywHWuFgTolQ6zZvdxTsQD7HCbpODyR9EC
	WmLFFg9CWpxT0NkCjj9E+AdL/azQujfr/6RPLnOwVLsKpPaw5KnpMREjHFqrYMMeQ8qioAWhyGf
	lSa+F89+3Pn3VwoBryyTJzpniDV4=
X-Google-Smtp-Source: AGHT+IEplDFuN2dh3lCZVBALO+XGKlSlWYb5rOawb7A5PX/PlKHh+e4UJH03tKOvimPZ+ksur0fgpA==
X-Received: by 2002:a05:6000:402a:b0:3a1:f5c7:c50 with SMTP id ffacd0b85a97d-3a1f6488071mr12005690f8f.47.1747136387506;
        Tue, 13 May 2025 04:39:47 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac006.dip0.t-ipconnect.de. [91.42.192.6])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-3a1f5a4cc2esm16248093f8f.90.2025.05.13.04.39.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 May 2025 04:39:46 -0700 (PDT)
Message-ID: <3bc38f30-b340-433f-8732-954214e41fa2@googlemail.com>
Date: Tue, 13 May 2025 13:39:45 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.1 00/92] 6.1.139-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org
References: <20250512172023.126467649@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250512172023.126467649@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.05.2025 um 19:44 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.1.139 release.
> There are 92 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg 
oddities or regressions found.

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
