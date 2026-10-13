Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C2A555C1D7
	for <patches@lists.linux.dev>; Tue, 13 Oct 2026 21:23:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791926589; cv=none; b=hhTy7H1QwV1j9TluOZZFJwlgOTFkS3IiLQ5fOLl3mySNzju0bPrhpgRREcekEy9pmf51zBM4bPmwZGB1K4pZR4D2DCKvEtepdfummwWvNaYMy+CPAPrFHqskE6JjKRDIXis1LUuZZ+okqINI40dV3SybgZZIjb6JG8/ykYA22x8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791926589; c=relaxed/simple;
	bh=yiESBERC+Xl3L7/FsxOPHfK5bIOLCgd7G0wZyXxK1mM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jfA9sSJtOEgsesn8DaH+mBaZAZUjlsv8ajSN0aIK8zOmSWltrvcG/reViUZSsVJkj8GVIGhkubgyDGwmv5bBNI+NzBm90ubFcq59q6LdScU56jAJH73lGghTZjFLqTswc+i3ReLMZY974JcirS8253veGLzPN1/RwYwp+m2RaJM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=nlhyJBxX; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="nlhyJBxX"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-4a19cba5c14so27825745e9.3
        for <patches@lists.linux.dev>; Tue, 13 Oct 2026 14:23:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1791926582; x=1792531382; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=zNr9QrvvLJoXy24Y9C0L722O7ExNexOvKEg2BEzpUi0=;
        b=nlhyJBxXGwM/hNNMa4ZY7RJwDHUXZVqYqR204LLM5TZbbfCrZat5W0TpgEDnpclwoC
         JSf8C2DzTVcZwUaCQChvYaxqHvhYWr9asTu2R5+Vp6Gp4dMNlAjaK3AhDnkyqkFqSmwH
         ztQvf2NPtVdxaLj2qRfeMCEDhagWKGp49BhDnKFLU7Ix+rTNgunj9p4dyaFHHPwVm2nd
         F2Keu0woDK0k1gqZSF7DOcksQZm4beozyqqO/C1KtRHyDPDEDAP19eBxwyyaoewYeToJ
         BCyb3nxF7iPJVnCIb+opGhIf008hMQApHDTZwOeiUibxIcn/mTn1xQHGPdBjCq2LhGkr
         Uy+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791926582; x=1792531382;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=zNr9QrvvLJoXy24Y9C0L722O7ExNexOvKEg2BEzpUi0=;
        b=DnBQ38eFH6wL+D8lcQmLD7LYiV2Vlpifs+gIJtOdrFM5CVTqqMKBi/DNlijxccTMBf
         N9N/1GrkL6DqQLiG58Im4QkjAcMjPPsr1UYSE0rxZMvZ39xy0uEvIZVd/n4bPrPnMDu5
         JDwYHEvhfkib71mHbjPzzYF6WEDNsKtaNWWyqP3ZWL90MzYKdVRxndpeKR0ducLQPozz
         avqMgfqBFjyqT2wCQ8W3kr2rMOFipVYkcB8QTorHoaGarATE0l2D0WMheLRV5xtqhqdt
         XsbCxu5QlrWoHzdVWw2go9nEuC8F1qdpr+iNXNjHu/n0PFIeiiliCRC9E9A2P9ZNxB57
         PwXA==
X-Gm-Message-State: AFq9FYKmr7M3ZLGj+rl2XqizNUNfoks0u12419zSmFyt7nslSbovr1b/
	ea/j0BSOgrZX962QvaeB8FLggtooJVVBgvSpEPjHpe6nc/WoyyJ//mQ=
X-Gm-Gg: AYBFou0y+FH3CU7VJsWzKO7rBATIWmaITbStaIqG0WUQX8R5xeXZdYYmjOt78Bdf5Iw
	64M/7zcFmO/6FqkaVlj9mYvyrk4+a7IpDCQn26oW/w+GU388dFhvHGKPNda6kKGPkUj14o5Uezk
	JZac5Fyd7hkbISmMML0kOnzX6kBGMvFUqerVVtH64VmJaZRN2vj/de5MSxmHyZQ3AJanx9PMhTd
	1726ADMKsYylE9B1Pbv2SrPdEUeEuDhSthAU+9tI3TCtYNmpS9ti1R1qHaeAW44MXQ1MNLgjCzG
	TlZjkmLzHhY34F/kBe0v/SUogFxZeDyu3HyqUGUBNZ8fX05HsGbN9WQhkBWbgXrqM9tdhluDLj0
	NUuEWP7Nbkv0nmvNI4Lulhlqhxpe85hdtLIHuTiUhz7QuGU6wINGTxWGQ0R1GOURVjT7E5KbSBZ
	LZr5x9WYjKGvJqrwl8wudO15EV79E+kfNMlWhaVle/UxO2ez0q7KkwWWotSuDwcyA48dg0Rkg6U
	Ty3fBx8Q5YdYGkeP2fn29cbPe6mFO8mhj0TviLOnf3kgogw
X-Received: by 2002:a05:600c:8519:b0:49d:4ef:bf70 with SMTP id 5b1f17b1804b1-4a18e4a16femr256430895e9.10.1791926582261;
        Tue, 13 Oct 2026 14:23:02 -0700 (PDT)
Received: from [192.168.1.3] (p5b057b0e.dip0.t-ipconnect.de. [91.5.123.14])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4a18be97d1esm613852585e9.8.2026.10.13.14.23.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 13 Oct 2026 14:23:01 -0700 (PDT)
Message-ID: <d65b9db1-3445-440c-917d-fce806af41c6@googlemail.com>
Date: Tue, 13 Oct 2026 23:23:00 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 7.2 000/281] 7.2.11-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20261013112855.045212108@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 13.10.2026 um 13:35 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 7.2.11 release.
> There are 281 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697v2 server. No dmesg oddities or regressions found.

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
