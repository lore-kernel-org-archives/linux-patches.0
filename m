Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56B4126CE3B
	for <patches@lists.linux.dev>; Wed, 13 Aug 2025 02:52:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755053575; cv=none; b=CRJLIgVhDbKqv3RwgozzCmmsosGl6jtF4r/GhXJl2lzCYWSMffGL58qIf/EFE0JvHRvJS8oAeNUsNHNJTUssqzOls0nWGu9MUAsjPVsC5qSk5Pl9OYU9wNONUZ0qntsJQWgXgylvMuoQW41ANfJsGi9bRRzSV79UCX+ObAZrUkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755053575; c=relaxed/simple;
	bh=KLXZBaq3TLieISROhyU6yYpBnfJhCu9c5EIrzguDWzk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=jVvI0El0h8QxqZLof0tdgqzkvk4yawPAbrH2ARVSwOJnLy2yjVL5iX4S/tCb4GE5roHX4HQurX8LqazWvRvwHbECrwY0rH7ExW1s2ibpYw5+Ji81OyN1U8iExNuFLOQp3AdqVbusFEJIOXkrAFm8XrSd4gqYIlZMhU9fYHq0V/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=bInE1piw; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="bInE1piw"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6157b5d0cc2so8759829a12.1
        for <patches@lists.linux.dev>; Tue, 12 Aug 2025 19:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20230601; t=1755053572; x=1755658372; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=042+Laf4ikzkSiUo+Q4PSZALoUrhwG9sdAkdg18fh0c=;
        b=bInE1piwAX21Ttw9viWrfCxpetUBx4nZYRMDEuIZ6KGfw327Q3kt5pbfri16lDuVAo
         fkzKoUDlQ1az4vxvp+E/UdvGGN6WQnn5Zav9N8y4kVRtOG1/TCTgzfahspeqBm9mFT6B
         4ud+x3B/qoXmSNHnl8E161/TXg5OA4hQXfSUAn478joxu98belP53i/0WMmnXtJKUPEr
         j2sEJVSaSOqo0Hbaj+WvMrSIPP8UUmUtsLulbtf6A/b2Xhcj5wjO54W/P213pO8gp9Ps
         fgAhqjrUq5EsKZjfVZp/wfRQY/Pmko2Jl1Qck3/oe47WeZwTDRfZlLPfpC6tb2w838FX
         kJwg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755053572; x=1755658372;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=042+Laf4ikzkSiUo+Q4PSZALoUrhwG9sdAkdg18fh0c=;
        b=k98x0NRagYTDUkJcTjf0DwqgOFibvGE4pOYYQizrg/hJfK4ROm9jVu4mfnqwUNbkuM
         I6+PxDHcced+rqNS/+MXHsX5Fqi1X2c/lMUFIuSOED/HlHxnOOmPL2haep52YFatnKM2
         Kjpi5vJ4XHntfLNjTncCvcCjs55X6Fstvi0YriPyZGUNyLA4vLCt0IDMrDa6FeRTdnOt
         BFwuu/7UkXMfvrzFo2wxSlvNgpyXbNlXzy6hSNey3zE/AXfqKLExg48SRqOj8cuZA/jX
         QgkH72AyizepEXj7Kvcwj7yR+bDrp7yzxKv4NDTvQdtE2iihO5LV+xP8mI0bJ52JhT6n
         MYmA==
X-Gm-Message-State: AOJu0YxyrxwQASe+7j7b5fbC1FlrzJTlEAnmfMOBbzGquT+GFmTe1oxN
	nLw6p+tBe0u96A1gJSZYxzZwq8aeMhkMGSYLYHOdE45r52rX7Bg3+yU=
X-Gm-Gg: ASbGncu0iJ8X7DIVGmPN23JSi/Dv1LgZskXwODDuHozXaS8kEpT4tbqUlU4oaSRKcP/
	ugFHwnssokZ03sEDElNS484laDfF/YxwGM+d46KhJbZXLD8jEWAXAtn6h/u74HG5nGr48NhmvVG
	3wuPRNNMIC0rzdkJvgdmE+hzmxQWWnpfaHLUWbjf92YyFlLmfAwVD88obzPsz8/gR/F7n6oSMrg
	vjn42pwxT15UD4CcTpVlBpQUpES7vrv4WQ2h1swIYd/TP+Rjq46hYMO8sAOfLyk2crlcl/aq3kT
	FnEYzMZT2M+ikJcyhvmCIiPiS6gxYN6P8u2MDc+vgxUVfhnfQbFIxvhl97YkEtAOnrRnl5VLUuV
	GYguaGaEP9QrbpmsftdGRrSdUbBbaCC6hFuZH4ASeAkZxBjLvu3zeKDyzzSO6gg8J75vS8AWICQ
	B/x4z02e1FhQ==
X-Google-Smtp-Source: AGHT+IGinuV3BWJsLOw3BMnIVMFnFkk+/iO2HAJYyI+8AQMIZAXSxQDGcKdQj7k2sochfOFf0alZQg==
X-Received: by 2002:a17:907:da9:b0:ade:79c5:21dc with SMTP id a640c23a62f3a-afca4d47d82mr148548166b.25.1755053571338;
        Tue, 12 Aug 2025 19:52:51 -0700 (PDT)
Received: from [192.168.1.3] (p5b2b48db.dip0.t-ipconnect.de. [91.43.72.219])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-af99518bfacsm1339330866b.72.2025.08.12.19.52.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 12 Aug 2025 19:52:50 -0700 (PDT)
Message-ID: <0e4b2e44-30b5-4907-8ad1-5890d53bf854@googlemail.com>
Date: Wed, 13 Aug 2025 04:52:49 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.12 000/369] 6.12.42-rc1 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, srw@sladewatkins.net,
 rwarsow@gmx.de, conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org
References: <20250812173014.736537091@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20250812173014.736537091@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 12.08.2025 um 19:24 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.12.42 release.
> There are 369 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Builds, boots and works on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. Built with GCC 14.2 on Debian Trixie.
No dmesg oddities or regressions found. I did not see any of the Python warning messages here which I did see in the 
6.1.148-rc1 build.

Tested-by: Peter Schneider <pschneider1968@googlemail.com>


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
