Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB29A38C2AA
	for <patches@lists.linux.dev>; Thu,  2 Jul 2026 21:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783028099; cv=none; b=LIwBGmAQqNThYldJfn++iyIFQAVTASKHbBGqxV8WGlG7b441b7Mv5M2sLaVp1r7P0fs31V+iWi4GKURQ54r33/VwTxNpZyg5U5GHO0EFZ3Viq2/Yi6ewuCFFJ/+s06XNBcsvzWQW4FZxDk8Cucul6D+TFVbMjHmmoHazaVyDKCo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783028099; c=relaxed/simple;
	bh=dAZkIgzTMcSNkQrudd/y6YvGZbWolbOeKUyGbxaXf/M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=bgUptG+ipvjIHdBDwV6NYUHxrlU0vDqhEIazAl048RVqUvyzfwk2m+tKqSaobL5LXZEVouDaAqYxhuymchMKujEOt/lgJW+IgOOLc8PJdkjfAI71/vVhZVs/SZQJWZMMRO4d7LMk9Ijsfm0aZRYuXpsE17Rj0QpyiqgYzwiaebs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=dGLGbG72; arc=none smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="dGLGbG72"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-490b1bbcf3aso12584575e9.1
        for <patches@lists.linux.dev>; Thu, 02 Jul 2026 14:34:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1783028096; x=1783632896; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=19Jd1aI1vovs/PrcyY0XyIG8DDEui4gFTZsXXL4+sNc=;
        b=dGLGbG72+G3AiM6UTVfUNz4aG2bc73miLoMo0MsS9GESUn0C7GZhgfIzEZLCksRQ2N
         6cA3ds6pI94QZaQKdsnueMA39ZK/DJPgMWQXYmZ1AtzTED9Hpg+aWLIW5PQ0akTlIhbk
         kocMb7ZY1nk9OeskSzDNaE+K4OI/0kTa+NIPBC1JIX0CLaYByx3zEI0LjY/DiXfQJ6qI
         Jb3A0MnkLCCwu6+moRO/liuNuK+Mc+N448odAVmFOyyodkxHBjjaS8ufx9P4+Hn5L0xQ
         0PqnnQn67R/FyiS4G4oyt73YpzResKsFbUhYfygbXR8OgXNfbAyCSrz1minAv+oMA8WA
         5m5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783028096; x=1783632896;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=19Jd1aI1vovs/PrcyY0XyIG8DDEui4gFTZsXXL4+sNc=;
        b=ikcBT/r/6/gwoIXXPmEquAHuUNV5bEhh6weQ9MnlIKEEAq+hp5EqEkGEYxMIwiC4Z/
         SSkhrvjWkYXHVyuTf0ahjb18APQk0W7vKD6WCkw2SfHjJ4MnvJRygaVUNA0tCK7oVpMO
         NWzr3i/EBllhxycD2Fvq5rT5TFz/krBP/oEkXKaU1DRLwTT/ezlQ4JAqWGrcmaJLvxxm
         EAOT3CdYt8u9cSSimBwXifaoSIKLIIDmsPqWGaEOjcI/nHis+IpWZV+PIMic5PWugZ3H
         rnbd9o5IQ4aVWPT+SdgZoijnJZglOA814KJowIw1jW6NXifZh+71RjF8HlzBrF6YOsgB
         EMwQ==
X-Gm-Message-State: AOJu0Yz9B6gR2FwtR+3JeDnAqsyif4JarDgCQ2EPEz9zpSBRBMphgWj7
	mDPULHZeHcz6RVMdOOpBnUHOqUMMbbIExZoJkE1oJxsiVoszgv6vnOs=
X-Gm-Gg: AfdE7cl8pNwBUivYcEQkedfPm25y2QociybsI3UR+0M8VmR7Ik5xlcd0tXO7dNwlAOo
	0eDpOPEv6FPNeOaEdrACN0lIVR6rutVOj7Q9vGAr4oxDaqIBSumcqUXdjlD2/8IXnc0LqHMF+JP
	6BGN8E6eclHaL+mcPQsjaT6XfiFyiq8ibgkuiS7PC1+aZ7kJAL4gcRMwiRbCtlBwPnTgnrCD4we
	KIDDr3QuD1p7ewBrsoW8ovyDZd1FCWtsGr29OiP4ZTxU6Y0nSMmvTmadz+xj3uCNn6Sejhr8Gkp
	4Fcph/l4nzPR6mUz/pXbAAf8yHF9fMVDyIsWw3xT2PEpQOVb346wY3G12s1aCfGlPf8yEgVBvR/
	4aeGmk4yWcyzXk8F9zLMRgfw2kT+18sQgQbNYYXgzP33+v9doCnAMDcokxo5n6JFf5QwUNgIfiD
	fEXkKwm0UXPpFE6c411RO3Gn5oQkagYeF2WgIqjj2gOljJhlUBGjVK0U685sTJk84=
X-Received: by 2002:a05:600d:8649:10b0:48a:5565:ec3d with SMTP id 5b1f17b1804b1-493c2b904e7mr91825445e9.22.1783028096241;
        Thu, 02 Jul 2026 14:34:56 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac307.dip0.t-ipconnect.de. [91.42.195.7])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-493c63172fesm136523215e9.0.2026.07.02.14.34.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 02 Jul 2026 14:34:55 -0700 (PDT)
Message-ID: <59059758-e29d-4452-806c-bc4df09cb85d@googlemail.com>
Date: Thu, 2 Jul 2026 23:34:54 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/204] 6.12.95-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260702155118.667618796@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 02.07.2026 um 18:17 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.95 release.
> There are 204 patches in this series, all will be posted as a response
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
