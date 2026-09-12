Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D42EB37FF53
	for <patches@lists.linux.dev>; Sat, 12 Sep 2026 16:27:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230474; cv=none; b=sdr6tPMfOhsSgcVVwiJVKdM0PZYgrRXu+6AsJzlxKWYBd1Jhi+8UnrcwokL8PntzSXdSm8caHd4nsID8pOTzTuxVq6aKIVzsuZbvhpDKL8eL/kvvhosTwLUGoxxohDSWSfOCrsRPEn5RyBqSUzIG3cKl5rzbE5zjUfSWc4gmifE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230474; c=relaxed/simple;
	bh=SB+7ZypI2a/DHX9aPHHGLY95kw1SSDbas/xPaFVh4bA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qwck1NVGVlGp74Jt3NhvVWokQieRunXY0SsKgkVuEYlrq4kvTBtMxh20MMc5KiCHGBGv0FS4rfL4AjvYSzyk+9S/m/RRfvYVr63WX9lRuYCyVbNpLq1lZji/z81HusYPemst4O3hxXJdNYcKd3VO0z5Ovc9xiS2zAZ5keRgMsvU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=RLScpSTH; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="RLScpSTH"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-482f6350f88so294117f8f.2
        for <patches@lists.linux.dev>; Sat, 12 Sep 2026 09:27:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1789230470; x=1789835270; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uLwPFVSH6fenxtAVKVtDZP5Su/rpOuHfnYhbGoS9nnQ=;
        b=RLScpSTHoqURYTU5InxqfUmitU6FWxX/n0UZOa98rR7bTijc6CaerFQJs8UgeNhhWr
         t4cfFuvU++rEjo7oiy1wOKOc8zKL878al4r6GdltbXR1fFpt8EnA6CXNaW+psbzAaspo
         WlaRi2bkfQWeRGYQf/RmXXP+6hYnoaTpLt7aUq8m5q6/iSUlK4gBN1KktZsDuzxLJwHI
         MYwHO3DOFKDk6KnAVyJ3CJDNmKm9qiBiTRCLLXw0TN2e1zfwSIGn8nkILRX1WaXWSNi6
         M853rftDU3C1daqkSGiuSHboYD2CG5suydgzsIuvDBy9Xh77C46ftHV7v1CadegcEBcv
         lB3Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789230470; x=1789835270;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=uLwPFVSH6fenxtAVKVtDZP5Su/rpOuHfnYhbGoS9nnQ=;
        b=ZUNnDVYfG/jYfFn/T0UAKETjjAM2HCxUSPlrQ6yElThhIPlI8AGGd+ECGuKROW6HnB
         +TVmsyRDw7beAuCuJy4T6ZKnXoiOv1d7mYfLihB3SHor0abl2wz//N5Zq1rFY1jrd439
         bQGd0UAg5JDeznUNKh+yFw68W8pp8BWiPJ/ZOJ0hOCmqrDMSXyZES82MVGJt5jVwGwrF
         IPJJy1KHT22dX0ZkIkFRLQSLI6MMwJSGe1oRTmEGRgjX1Ci5PePYcCUmAlJhe2hFSsNy
         Da32/0+gWTdaa+mZLOJLEYGQEBk7enqrTVV7hh9b67Wxvmk9evu7uDzi0W/RoumzRnBz
         u0ng==
X-Gm-Message-State: AFuF++lFr/RBE/Q6gh2QJ/2ERng094VZG4laA1ITfv7OerlD9JnagWr/
	tARtTOcJ3lrQsTKDnEZkuMQrXvZxTcmyV6s4m8TQO8Qn/RMIN+pFbXc=
X-Gm-Gg: AYBFou3yNv69IPYLLxQOgsL28diAfHagY81mJ7D4jRy0GjcMZZfgCaD1aVDSBggiXcY
	YUFYpreL+E7oGCJlZ5eYvt40s67v4iWGUOgLY4NqybbC//esuACZc40385kmDolQtVlARd53clk
	6sRKgU7xivRTe24soV17xP2fPfoMlcGgbpafAeQgDrDNENd9A5n+R9/B5u1oxwr7bNXOB0i0SiX
	8kVUvkkix25ApnSqeLQK4cQuX8wyASYeZ0w/0LBanKBF/91duWWaSFSY6sIsr2kjpyGczyTgcPK
	Sutso/RYGKQdZLsZqKPsYvoYRB+ERxISq7d+Q7yK+u2tApzVyb6MEGghRgh5VxMixP3O+AYKowl
	/82YmA+DXdYLuUctnvkmrHhbjv6mp78qbteYnhR//HAlWK7kdAhORurHBdqJ7xGoVZrgFawM3A9
	RF+/kwOO8lsdUdnMFH6fNM/9fEuKrABWx2VyHt7l1cvglA2tlb0DVrP2QgmFkpRbZqiiUl5H/aS
	XNnPTjj+fleuOvw7NHaGQnboQ13PCa4vAH47GV+5Pq5yQ2c/rM=
X-Received: by 2002:a05:600c:a04:b0:49e:63cd:31fb with SMTP id 5b1f17b1804b1-49e6caa2662mr32416415e9.9.1789230469857;
        Sat, 12 Sep 2026 09:27:49 -0700 (PDT)
Received: from [192.168.1.3] (p5b2ac4da.dip0.t-ipconnect.de. [91.42.196.218])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e60ad0614sm183298795e9.10.2026.09.12.09.27.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 12 Sep 2026 09:27:49 -0700 (PDT)
Message-ID: <473b0515-41b9-45cd-823c-11c759a7ada4@googlemail.com>
Date: Sat, 12 Sep 2026 18:27:48 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 0000/1376] 6.12.110-rc1 review
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260912065607.535295758@linuxfoundation.org>
Content-Language: de-DE
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.09.2026 um 08:40 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.110 release.
> There are 1376 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and seems to work on my 2-socket Ivy Bridge Xeon E5-2697v2 server.
However, I see the following dmesg warnings in this rc1:

[    2.357525] Driver 'sr' needs updating - please use bus_type methods
...
[   82.818407] Driver 'ses' needs updating - please use bus_type methods

These warnings are not present when booting into 6.12.109. I don't know if they are significant or not.


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
