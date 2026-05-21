Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFF5836E48B
	for <patches@lists.linux.dev>; Thu, 21 May 2026 09:21:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779355294; cv=none; b=Pbt5ItmrvnCwrS94P91ivPwfybbz2GNNDlosjOcsSvPga3o3SXdIG6P3DeC3J+QiLw/G314ir4XCxHGLo7H0u+B0hucIzFhkhYbl8l8U68Zn5tL7VNXGUC6yPPQjGNp1w6dtKboxCl5Y7IdmETheYpgoExZisTqxlKxD0jTrDX4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779355294; c=relaxed/simple;
	bh=W9nyORp4vE9BwGtWonfSAIZovwxPtkmwuWrv6faLqQM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jSXwjCcA+81VnVAx0seTNSsxe2xET/Al42+A8ulU5Uuz8G7NSd8Lf8rt1a5bjl4mzfzH9ZfMsbvEn3IzhMYjteMITyJUOJ7zdvTZjzjf8YHhNgyU5ueTj52YJETdgJOamSykbV8wxtueFrv9gN431DQLnKYaVHCoyO2WPM+Mk6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=TPGdn82N; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="TPGdn82N"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-488a88aeec9so68539705e9.2
        for <patches@lists.linux.dev>; Thu, 21 May 2026 02:21:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1779355291; x=1779960091; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=uoB4vFn7tcBnU/nRMTtmwAyXHRKBcO0RDfcoUt7dviI=;
        b=TPGdn82Nk+bvTbEc/buFywHY/esrlLWRPaL79EmaKUSqc0p0pyIpZzIs8LhCUVzokr
         957fp0o/Y2DLS3bIn7A1CPCM0MvhD5N6a5Xm0dUDgOV4bld8LU99wHduHDfmDkWZ0ObP
         NIUof5igJhar5cbpLC0SETQhlSk4EfssFEV4gLftI83Yp8VyxjSW9K5WXReToM2Rgesn
         +QT66sVvfRKksa2bFA2e5YZe/XN3+JwU1jGcC0jZQQqsxtTy7cPtyUziIezpJX2II6dk
         iKKB5bIo7vy67NqzMPJTVA5KexlbSbqIIuMaB1FzWSWm0effNADjchW3D6WzZkFKT/tB
         Szlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779355291; x=1779960091;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uoB4vFn7tcBnU/nRMTtmwAyXHRKBcO0RDfcoUt7dviI=;
        b=FAymB+VCAQmt7Got3d0LOMueJzjibSfmRGHMDpup7sZq9s763xIj5CII2Bp21O5JC7
         50WSq5UauuJL1WvLF4SQSEvUbUNNs5Gcg8DwealUaQDv3AwZFLO3SmxUE8PGDKs7IR2l
         aa1uREzbaWmkqY003sME8r43zk8w4o1pZEF1MtenEtw4pj5KXDAbAeKbog3557624RhO
         5iiaweLARvDZhFPshpR/C1diwWbBIShoolDx+GLMF06CsjRv786TE39e6gqQEoeh2eJJ
         IzcjQwlhnu2D5zQ50ludsQhF0JBD5tiO+GKtUjA+Ww0EVmQzcuO2aeHY3I9rOdSnyPRy
         kaLg==
X-Gm-Message-State: AOJu0Yxvv81/2vdTXr2hD+BnZRLdKcgekR3Qh3aSpm7cePuD9cyUcCT6
	1qFW3J/8qlemr2CsynZEE9QrDJ4bh4xwN8wUJVk3gY8E3JoGY68ORxw=
X-Gm-Gg: Acq92OGYlUCX44Sx34Usr6fnsT7Ln0/WmJJ0TiC1IypsU1JBC0RU570NDu0fN31KQtL
	7dFNuPegL4cHRKTsc3WZ/CmGGUl9Zv5fmlkepe4BM6wvTknaVAwOC1RiyBgNuZnA0AInjiI8LTC
	50p6YANW33d2amF5dxT2MKvyhsxSDeukTDrR0qnkVfktXp3yGOnJBpFP+N9mL6u/D5XFKrYsaCM
	0JWGjT95l7yTRTSufFbWm5+fjQBus3WJDX55qF3gtzmSVmVWDzl01PQm9DUP985JW05n4gHhi9Z
	KsX4pXT6q/WPs33NqkL4dgq2oR9mSNq07FxnD8ebLOyxjnssQDhv8XRhZgq2fdvp1uTaoGotuSz
	w0z1OL1znHJcwYxdBJ68S7z4pJu/pX5JLFx87G4ubwggakgG4LNuDHz25GQn9wkwzeVaXe/FwgR
	TeQG2+Ts5OH5fbrmwxMqqleGm1zcNLlByZzTs9fZLm5V0EpQKqjEizNXDUzTdxRdHmJzF0W/HBk
	vhOVKHy1DnfBg==
X-Received: by 2002:a05:600c:1f8d:b0:489:5022:39a4 with SMTP id 5b1f17b1804b1-49036041cbdmr27515765e9.9.1779355291085;
        Thu, 21 May 2026 02:21:31 -0700 (PDT)
Received: from [192.168.1.3] (p5b05786a.dip0.t-ipconnect.de. [91.5.120.106])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49035adf173sm16543415e9.0.2026.05.21.02.21.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2026 02:21:30 -0700 (PDT)
Message-ID: <b16b4836-287b-47bf-a22b-8f269ecd5ee0@googlemail.com>
Date: Thu, 21 May 2026 11:21:29 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.0 0000/1146] 7.0.10-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260520162148.390695140@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 20.05.2026 um 18:04 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.0.10 release.
> There are 1146 patches in this series, all will be posted as a response
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
