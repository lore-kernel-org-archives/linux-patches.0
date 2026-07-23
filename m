Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBF8F418A2D
	for <patches@lists.linux.dev>; Thu, 23 Jul 2026 09:15:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784798141; cv=none; b=UQGVw14Id5WyBi2AyQSN38nmOGlf6UjNxm23p7b4uCFuZCOmiOeUfUEmn6+qTiYAhbZOdp01twSnyt/tGHtUMLu10kY0quVUCSPpNRGtF1mWPyfv18vbbCzJj9FKwKJfO6lQaxU4crPX7cCfFyYJWs3xEtPmu8avNY9rXZkRRE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784798141; c=relaxed/simple;
	bh=KWjnOX6HCuU0QAatYa7MDqIzVHf1BPZonkGs89BihyM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DUnbkZ5vfTkPx7C+QdO9TsigAipGOnsCLQ9WA2btLnVsZQF327OS5BHUTQaySL64uTDnQaIXg69+lAcnQEFsdQ3YRKKbfblZl9bjL3E+JUmmsfjPzFJV1WYjC+Nz1qEsa3DAheaF60xqi7ci/Hx4+IzpcWbapz09rwHwq9oTuFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com; spf=pass smtp.mailfrom=googlemail.com; dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b=A2jBjOp0; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=googlemail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=googlemail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=googlemail.com header.i=@googlemail.com header.b="A2jBjOp0"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-49553515a8bso4435965e9.1
        for <patches@lists.linux.dev>; Thu, 23 Jul 2026 02:15:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20251104; t=1784798137; x=1785402937; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=OdJj2BO7wpVY5lLG5+abPgagT826JqDJiVNrLTie0kA=;
        b=A2jBjOp0aX+OFnPIFubqROljhIlH0auOuxkp2vfJbWcp8mcJqj0D1x8X4qatswiIsQ
         jyaDKpPIFGF1vY2N1O6bovJf+b9+2+tB/gH29ie0nLFaw34ExlgV8OwFOvedxa0kt5+7
         xOMrrL0aKrJAeSlTs2FcRQQAAXPNXyGCVpMPzb41WfCAbSEluUNc1cNWOVE6OgbEYrFz
         Nq6y7/hhjXGrzAz60k1CNi1Oqh7nEz+QxKNnFwxxBoEjwHf2O0I639RGyLAQ7G9lQfzw
         wE6St//ZlLSt4T5mh2kdhEmXvHiy/mApZ8pZNhc8aivnKJCUx8DnHwidXJNXJgypt6Qh
         4ZRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784798137; x=1785402937;
        h=content-transfer-encoding:content-type:in-reply-to:from:references
         :cc:to:content-language:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=OdJj2BO7wpVY5lLG5+abPgagT826JqDJiVNrLTie0kA=;
        b=ZzNmDdCQ5Ous6NgMvjdVV9ftvrnwlbN19F2E5A7Tz4d3npBRtqcO8lSSTDhRyBBrBJ
         pGPDKvSGKG9a+zmHxvnVVQJhQSNp3aJq+DBDDn4P6Shev0X9FJu5xbqSC7V2CLxm+nUz
         3CQge865NDID4dQfT6Epx49wbnKgrZ+FJ8dSWd9yUs0+rYcMtWrV16qFY6Lh8sVkB5Ws
         jwmQwH0FapLOsK/HtZujvAZ1oQ0QgRjiigO9/x3FQTaBUrOGbbJR5svVfxzOhVhcckWL
         21XEqYsy8FaZsM3tWT0la/2APQJPveaC7wHP3kz4nEFIwLl2fQrp3t+seyDyqXjHlPXv
         uh7g==
X-Gm-Message-State: AOJu0Yy3RNQLe3e3bVg5PK07Zo4Xl9w/Cp/ogdeAxVgTiVaSoIu3M2Gm
	nvIdMNws3NoI3kPuD86J/JYmacZPov2jIRMJu12R3C7s/Vd0mX7UN8c=
X-Gm-Gg: AR+sD12hfkohU+z6JjRWvxcaSIwdDA8hrt+Xw/SXCNibqbX7atZYUDu5zY8Lq86vrvB
	Yk+j/7OA4G4oiNeqmPZW0AEAAdDQcrSLsdABJcaJ6y+6r5uydmV8u2MKPxL5RAm0nCUPdZTfVhp
	pzYWonTQ53sxpPzBj9dsD8Tu7IVTMtVh/ZwvmdQ/XelBUJ8cJavG7WUZDS/Sx11vt4jAbXMaXqh
	TzJU3oIBIITIwQyvTAO33xzb0c1rAmBT9nyllkBG0uJYchrlIXwAQnUNOpTjp4RylDe5SpPESAo
	+HYjxFErzdlSs5Tu3rhGdEAEEhMFeUm6wGg/vKMsY0hfU1ri2Wcs4MSeOfVtGjfrMroDLYhoxNJ
	wJsZwaK9Y//7mToEMKb/XXxTo5wD2FfczlRLj+28IBmupE1weU8ttTGk2xQSujSnhYh6d3FhBqB
	iKQMeFlzpTRTAcQ+babce0EReiIfVe5p3v0g8vEj796IAkzIP5jPxje5M=
X-Received: by 2002:a05:600c:46ca:b0:493:e97c:216e with SMTP id 5b1f17b1804b1-49573d26d00mr21155505e9.39.1784798136492;
        Thu, 23 Jul 2026 02:15:36 -0700 (PDT)
Received: from [192.168.1.3] (p5b2acb97.dip0.t-ipconnect.de. [91.42.203.151])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4956a4f9a11sm125801275e9.4.2026.07.23.02.15.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 02:15:36 -0700 (PDT)
Message-ID: <3f610185-9d50-4c48-b20e-212b3cb73192@googlemail.com>
Date: Thu, 23 Jul 2026 11:15:35 +0200
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Betterbird (Windows)
Subject: Re: [PATCH 6.18 0000/1624] 6.18.40-rc2 review
Content-Language: de-DE
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org,
 torvalds@linux-foundation.org, akpm@linux-foundation.org,
 linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
 lkft-triage@lists.linaro.org, pavel@nabladev.com, jonathanh@nvidia.com,
 f.fainelli@gmail.com, sudipm.mukherjee@gmail.com, rwarsow@gmx.de,
 conor@kernel.org, hargar@microsoft.com, broonie@kernel.org,
 achill@achill.org, sr@sladewatkins.com
References: <20260722142910.893804136@linuxfoundation.org>
From: Peter Schneider <pschneider1968@googlemail.com>
In-Reply-To: <20260722142910.893804136@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Am 22.07.2026 um 16:31 schrieb Greg Kroah-Hartman:
> This is the start of the stable review cycle for the 6.18.40 release.
> There are 1624 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.

Just like rc1, rc2 builds, boots and works fine on my 2-socket Ivy Bridge Xeon E5-2697 v2 server. No dmesg oddities or 
regressions found.

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
